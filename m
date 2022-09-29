Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D415EF896
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 17:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiI2PW2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Sep 2022 11:22:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235896AbiI2PW0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 11:22:26 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678B11514DC
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 08:22:16 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-215-KJpOk1o4M2ult_yIQyhK4w-1; Thu, 29 Sep 2022 16:22:11 +0100
X-MC-Unique: KJpOk1o4M2ult_yIQyhK4w-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.38; Thu, 29 Sep
 2022 16:22:10 +0100
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.040; Thu, 29 Sep 2022 16:22:10 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Thread-Topic: re: [PATCH 3/4] proc: Point /proc/net at /proc/thread-self/net
 instead of /proc/self/net
Thread-Index: AdjUFaAzwFjoFpF4RWSGA65kFT23EA==
Date:   Thu, 29 Sep 2022 15:22:10 +0000
Message-ID: <dacfc18d6667421d97127451eafe4f29@AcuMS.aculab.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
X-Mimecast-Spam-Score: 1
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

I've just bumped into (the lack of) this change (from aug 2014):

> In oddball cases where the thread has a different network namespace
> than the primary thread group leader or more likely in cases where
> the thread remains and the thread group leader has exited this
> ensures that /proc/net continues to work.

> -	proc_symlink("net", NULL, "self/net");
> +	proc_symlink("net", NULL, "thread-self/net");

This was applied and then reverted by Linus (I can't find anything
in the LKML archive) - see git show 155134fef - because of
issues with apparmor and dhclient.

In my case we have an application that is started in one
network namespace (where most of what it needs to do exists)
but needs one thread to revert to the 'init' namespace in
order to accept TCP connections from applications.

The thread that reverts is the main thread.
Until a change made in the last 6 months it actually worked.
(I'm using 5.10 LTS kernels so I'm not sure when.)
Then a fix was made to correctly update the mounts when the
namespace changed - and it suddenly stopped working.

So the 'oddball' case of different threads being in different
namespaces and then accessing /proc/net (because that is what
the code always did before being changed to run in a namespace)
has happened to a real application.

Fortunately it happened in testing and the application could
be changed.

(I was looking at the kernel sources to propose the change
that got reverted!)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

