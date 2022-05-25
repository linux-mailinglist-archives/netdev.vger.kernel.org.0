Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B9F5339BD
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233681AbiEYJQK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 25 May 2022 05:16:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240505AbiEYJOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:14:55 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2152698086
        for <netdev@vger.kernel.org>; Wed, 25 May 2022 02:13:03 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-286-FrwQxWopO92KId7QoSTyrw-1; Wed, 25 May 2022 10:13:01 +0100
X-MC-Unique: FrwQxWopO92KId7QoSTyrw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 25 May 2022 10:01:54 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 25 May 2022 10:01:54 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "'greearb@candelatech.com'" <greearb@candelatech.com>,
        "'tglx@linutronix.de'" <tglx@linutronix.de>
CC:     "'tj@kernel.org'" <tj@kernel.org>,
        "'priikone@iki.fi'" <priikone@iki.fi>,
        "'peterz@infradead.org'" <peterz@infradead.org>
Subject: Softirq latencies causing lost ethernet packets
Thread-Topic: Softirq latencies causing lost ethernet packets
Thread-Index: AdhwC4bqst8LExmEQFywizODbQDT1g==
Date:   Wed, 25 May 2022 09:01:54 +0000
Message-ID: <50c8042451454d8e907dd026ed5a3d53@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've finally discovered why I'm getting a lot of lost ethernet
packets in one of my high packet rate tests (400k/sec short UDP).

The underlying problem is that the napi callbacks need to loop
in the softirq code.
For my test I need the cpu to be running at well over 50% 'softint'.
(And that is just for the ethernet receive, RPS is moving the IP/UDP
processing elsewhere.)

The problems are caused by this bit of code in __do_softirq():

        pending = local_softirq_pending();
        if (pending) {
                if (time_before(jiffies, end) && !need_resched() &&
                    --max_restart)
                        goto restart;

                wakeup_softirqd();
        }

Eric's c10d73671 changed it from:
        if (pending) {
                if (--max_restart)
                        goto restart;

                wakeup_softirqd();
        }

to
        if (pending) {
                if (time_before(jiffies, end) && !need_resched())
                        goto restart;

                wakeup_softirqd();
        }

Because just running 10 copies caused excessive latencies.

The good work was then undone by 34376a50f that added the
'max_restart' check back (with its limit of 10) to avoid
an issue with stop_machine getting stuck (jiffies doesn't
increment).

This can (probably) be fixed by setting the limit to 1000.

However there is a separate issue with the need_resched() check.
In my tests this is stopping the softint/napi callbacks for
anything up to 9 milliseconds - more than enough to drop packets.

The problem here is that the softirqd are low priority processes.
The application processes the receive the UDP all run under the
realtime scheduler (priority -51).
If the softint interrupts my RT process it is fine.
But the following sequence isn't:
 - softint runs on idle process.
 - RT process scheduled on the same cpu
 - __do_softirq() detects need_resched() calls wakeup_softirqd()
 - scheduler switches from the idle to my RT process.
 - RT process runs for several milliseconds.
 - finally softirqd is scheduled

The softint is usually higher priority than any RT thread
(because it just steals the context).
But in the more unusual case of an RT process being scheduled
while the softint is active it suddenly becomes lower priority
than the RT process.

I'm sure what the intended purpose of the need_resched() is?
I think it was eric's first thought for a limit, but he had to
add the jiffies test as well to avoid RCU stalls.

The jiffies test itself might be problematic.
It is fixed at 2 jiffies - 1ms to 2ms at 1000Hz.
I'm expecting the softint code to be running at (maybe) 80% cpu.
So that limit would need increasing.
There is a similar limit in the napi code - but that is configurable
(and, I think, just causes the softing code to loop).

But if RCU stalls are a problem maybe the rcu read lock ought to
disable softints?
So the softint is run when the rcu lock is released.

I did try setting the softirqd processes to a much higher priority
but that didn't seem to help - I didn't look exactly why.

While I could use processor affinities to stop the application's
RT threads running on the softint-heavy cpu that is all hard
and difficult to arrange.
In any case the application can make use of the non-softint time
on those cpu.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

