Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247814BA15D
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 14:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240625AbiBQNg0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Feb 2022 08:36:26 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236145AbiBQNgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 08:36:25 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4D31D2AEDB0
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 05:36:10 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-180-DvoA-mOvMgWZ2EaaUyzgIQ-1; Thu, 17 Feb 2022 13:36:07 +0000
X-MC-Unique: DvoA-mOvMgWZ2EaaUyzgIQ-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 17 Feb 2022 13:36:06 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 17 Feb 2022 13:36:06 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Christophe Leroy' <christophe.leroy@csgroup.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Masahiro Yamada" <yamada.masahiro@socionext.com>
Subject: RE: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Thread-Topic: [PATCH net v3] net: Force inlining of checksum functions in
 net/checksum.h
Thread-Index: AQHYI/ioJk+yETn/QkyN152xjKaZ96yXvR4w
Date:   Thu, 17 Feb 2022 13:36:06 +0000
Message-ID: <35bcd5df0fb546008ff4043dbea68836@AcuMS.aculab.com>
References: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
In-Reply-To: <978951d76d8cb84bab347c7623bc163e9a038452.1645100305.git.christophe.leroy@csgroup.eu>
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
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe Leroy
> Sent: 17 February 2022 12:19
> 
> All functions defined as static inline in net/checksum.h are
> meant to be inlined for performance reason.
> 
> But since commit ac7c3e4ff401 ("compiler: enable
> CONFIG_OPTIMIZE_INLINING forcibly") the compiler is allowed to
> uninline functions when it wants.
> 
> Fair enough in the general case, but for tiny performance critical
> checksum helpers that's counter-productive.

There isn't a real justification for allowing the compiler
to 'not inline' functions in that commit.

It rather seems backwards.
The kernel sources don't really have anything marked 'inline'
that shouldn't always be inlined.
If there are any such functions they are few and far between.

I've had enough trouble (elsewhere) getting gcc to inline
static functions that are only called once.
I ended up using 'always_inline'.
(That is 4k of embedded object code that will be too slow
if it ever spills a register to stack.)

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

