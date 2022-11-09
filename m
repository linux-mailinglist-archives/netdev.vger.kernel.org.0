Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78962622812
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 11:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiKIKJl convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 9 Nov 2022 05:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKIKJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 05:09:40 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7B4BBC93
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:09:39 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-81-ABe0gktTOTGcVfsSB0umYg-1; Wed, 09 Nov 2022 10:09:36 +0000
X-MC-Unique: ABe0gktTOTGcVfsSB0umYg-1
Received: from AcuMS.Aculab.com (10.202.163.6) by AcuMS.aculab.com
 (10.202.163.6) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Wed, 9 Nov
 2022 10:09:33 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.042; Wed, 9 Nov 2022 10:09:33 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Stefan Hajnoczi' <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCHSET v3 0/5] Add support for epoll min_wait
Thread-Topic: [PATCHSET v3 0/5] Add support for epoll min_wait
Thread-Index: AQHY85bpT+hcAn2hREu69xxFvk5GCa42XVDw
Date:   Wed, 9 Nov 2022 10:09:33 +0000
Message-ID: <d7fe932b7ad044e2bfc93c6b12131c2a@AcuMS.aculab.com>
References: <Y2lw4Qc1uI+Ep+2C@fedora>
 <4281b354-d67d-2883-d966-a7816ed4f811@kernel.dk> <Y2phEZKYuSmPL5B5@fedora>
 <93fa2da5-c81a-d7f8-115c-511ed14dcdbb@kernel.dk> <Y2p/YcUFhFDUnLGq@fedora>
 <75c8f5fe-6d5f-32a9-1417-818246126789@kernel.dk> <Y2qQuiZvuML14wX0@fedora>
In-Reply-To: <Y2qQuiZvuML14wX0@fedora>
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
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stefan Hajnoczi
> Sent: 08 November 2022 17:24
...
> The way the current patches add min_wait into epoll_ctl() seems hacky to
> me. struct epoll_event was meant for file descriptor event entries. It
> won't necessarily be large enough for future extensions (luckily
> min_wait only needs a uint64_t value). It's turning epoll_ctl() into an
> ioctl()/setsockopt()-style interface, which is bad for anything that
> needs to understand syscalls, like seccomp. A properly typed
> epoll_wait3() seems cleaner to me.

Is there any reason you can't use an ioctl() on an epoll fd?
That would be cleaner that hacking at epoll_ctl().

It would also be easier to modify to allow (strange) things like:
- return if no events for 10ms.
- return 200us after the first event.
- return after 10 events.
- return at most 100 events.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

