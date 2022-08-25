Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7A55A18DC
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 20:38:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243414AbiHYSiP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Aug 2022 14:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242432AbiHYSiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 14:38:13 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51EEC979D1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 11:38:12 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-213-vv3swLJCMT6Ji3unTrfcKg-1; Thu, 25 Aug 2022 19:38:09 +0100
X-MC-Unique: vv3swLJCMT6Ji3unTrfcKg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.38; Thu, 25 Aug 2022 19:38:08 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.040; Thu, 25 Aug 2022 19:38:08 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: ip netns exec namespace ls -l /proc/pid/fd prepends "/root" to the
 filename.
Thread-Topic: ip netns exec namespace ls -l /proc/pid/fd prepends "/root" to
 the filename.
Thread-Index: Adi4sCQiWHPDQxzJSJeo8ZJGzIAAZg==
Date:   Thu, 25 Aug 2022 18:38:08 +0000
Message-ID: <4c5a2ef5827f471cba84a7c74279f53a@AcuMS.aculab.com>
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
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a process inside a network namespace calls readlink() on
/proc/pid/fd/n (for any pid) then the returned string is
prefixed by "/root".

So you get "/root/sys/console" or "/root/var/log/fred" etc.

There seems to be an extra call to prepend_name() called
from prepend_path() from d_path().

This seems decidedly wrong, especially since /root usually
exists.

Even it is were reporting a file outside a chroot (opened
before the chroot) prepending "/root" would be wrong.

Kernel is 5.10.132 (LTS before the retbleed breakages!)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

