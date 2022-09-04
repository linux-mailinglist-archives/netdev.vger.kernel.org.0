Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB83E5AC4A0
	for <lists+netdev@lfdr.de>; Sun,  4 Sep 2022 16:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229782AbiIDOFa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 4 Sep 2022 10:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbiIDOFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Sep 2022 10:05:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C059303C2
        for <netdev@vger.kernel.org>; Sun,  4 Sep 2022 07:05:23 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-125-62v7-tjuNvizpZ-y9KtpGQ-1; Sun, 04 Sep 2022 15:05:21 +0100
X-MC-Unique: 62v7-tjuNvizpZ-y9KtpGQ-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Sun, 4 Sep
 2022 15:05:20 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Sun, 4 Sep 2022 15:05:20 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Eric Dumazet <edumazet@google.com>
Subject: setns() affecting other threads in 5.10.132 and 6.0
Thread-Topic: setns() affecting other threads in 5.10.132 and 6.0
Thread-Index: AdjAZGr2bm2+BO9aR228APTLkn1hUg==
Date:   Sun, 4 Sep 2022 14:05:20 +0000
Message-ID: <d9f7a7d26eb5489e93742e57e55ebc02@AcuMS.aculab.com>
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
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sometime after 5.10.105 (5.10.132 and 6.0) there is a change that
makes setns(open("/proc/1/ns/net")) in the main process change
the behaviour of other process threads.

I don't know how much is broken, but the following fails.

Create a network namespace (eg "test").
Create a 'bond' interface (eg "test0") in the namespace.

Then /proc/net/bonding/test0 only exists inside the namespace.

However if you run a program in the "test" namespace that does:
- create a thread.
- change the main thread to in "init" namespace.
- try to open /proc/net/bonding/test0 in the thread.
then the open fails.

I don't know how much else is affected and haven't tried
to bisect (I can't create bonds on my normal test kernel).

The test program below shows the problem.
Compile and run as:
# ip netns exec test strace -f test_prog /proc/net/bonding/test0

The second open by the child should succeed, but fails.

I can't see any changes to the bonding code, so I suspect
it is something much more fundamental.
It might only affect /proc/net, but it might also affect
which namespace sockets get created in.
IIRC ls -l /proc/n/task/*/ns gives the correct namespaces.

	David


#define _GNU_SOURCE

#include <fcntl.h>
#include <unistd.h>
#include <poll.h>
#include <pthread.h>
#include <sched.h>

#define delay(secs) poll(0,0, (secs) * 1000)

static void *thread_fn(void *file)
{
        delay(2);
        open(file, O_RDONLY);

        delay(5);
        open(file, O_RDONLY);

        return NULL;
}

int main(int argc, char **argv)
{
        pthread_t id;

        pthread_create(&id, NULL, thread_fn, argv[1]);

        delay(1);
        open(argv[1], O_RDONLY);

        delay(2);
        setns(open("/proc/1/ns/net", O_RDONLY), 0);

        delay(1);
        open(argv[1], O_RDONLY);

        delay(4);

        return 0;
}

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

