Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7412C6AB96C
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 10:14:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCFJOJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 6 Mar 2023 04:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjCFJOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 04:14:01 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 329D918AAF
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 01:13:57 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-234-wLlajqEvM_i0pebfXhezoA-1; Mon, 06 Mar 2023 09:13:55 +0000
X-MC-Unique: wLlajqEvM_i0pebfXhezoA-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.47; Mon, 6 Mar
 2023 09:13:52 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.047; Mon, 6 Mar 2023 09:13:52 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Thomas Gleixner' <tglx@linutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "peterz@infradead.org" <peterz@infradead.org>,
        "jstultz@google.com" <jstultz@google.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>
Subject: RE: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Thread-Topic: [PATCH 2/3] softirq: avoid spurious stalls due to need_resched()
Thread-Index: AQHZT6MmVGN6gMfiFUibqhxDqTGe3a7tcg6A
Date:   Mon, 6 Mar 2023 09:13:52 +0000
Message-ID: <dc3b87517d8342e8a8e61b75730cf3d1@AcuMS.aculab.com>
References: <20230303133143.7b35433f@kernel.org> <87r0u3hqtw.ffs@tglx>
In-Reply-To: <87r0u3hqtw.ffs@tglx>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,PDS_BAD_THREAD_QP_64,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner
> Sent: 05 March 2023 20:43
...
> The point is that softirqs are just the proliferation of an at least 50
> years old OS design paradigm. Back then everyhting which run in an
> interrupt handler was "important" and more or less allowed to hog the
> CPU at will.
> 
> That obviously caused problems because it prevented other interrupt
> handlers from being served.
> 
> This was attempted to work around in hardware by providing interrupt
> priority levels. No general purpose OS utilized that ever because there
> is no way to get this right. Not even on UP, unless you build a designed
> for the purpose "OS".
> 
> Soft interrupts are not any better. They avoid the problem of stalling
> interrupts by moving the problem one level down to the scheduler.
> 
> Granted they are a cute hack, but at the very end they are still evading
> the resource control mechanisms of the OS by defining their own rules:

From some measurements I've done, while softints seem like a good
idea they are almost pointless.

What usually happens is a hardware interrupt happens, does some
of the required work, schedules a softint and returns.
Immediately a softint happens (at the same instruction) and
does all the rest of the work.
The work has to be done, but you've added cost of the extra
scheduling and interrupt - so overall it is slower.

The massive batching up of some operations (like ethernet
transmit clearing and rx setup, and things being freed after rcu)
doesn't help latency.
Without the batching the softint would finish faster and cause
less of a latency 'problem' to whatever was interrupted.

Now softints do help interrupt latency, but that is only relevant
if you have critical interrupts (like pulling data out of a hardware
fifo).  Most modern hardware doesn't have anything that critical.

Now there is code that can decide to drop softint processing to
a normal thread. If that ever happens you probably lose 'big time'.
Normal softint processing is higher priority than any process code.
But the kernel thread runs at the priority of a normal user thread.
Pretty much the lowest of the low.
So all this 'high priority' interrupt related processing that
really does have to happen to keep the system running just doesn't
get scheduled.

I think it was Eric who had problems with ethernet packets being
dropped and changed the logic (of dropping to a thread) to make
it much less likely - but that got reverted (well more code added
that effectively reverted it) not long after.

Try (as I was) to run a test that requires you to receive ALL
of the 500000 ethernet packets being sent to an interface every
second while also doing enough processing on the packets to
make the system (say) 90% busy (real time UDP audio processing)
and you soon find the defaults are entirely hopeless.

Even the interrupt 'mitigation' options on the ethernet controller
don't actually work - packets get dropped at the low level.
(That will fail on an otherwise idle system.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

