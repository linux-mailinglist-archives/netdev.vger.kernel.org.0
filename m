Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7591F4D5476
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 23:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344350AbiCJWTZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 10 Mar 2022 17:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244216AbiCJWTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 17:19:24 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B749B4EF55
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 14:18:21 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-101-1qRMEwtpO-2LLQYOTwUG6Q-1; Thu, 10 Mar 2022 22:18:18 +0000
X-MC-Unique: 1qRMEwtpO-2LLQYOTwUG6Q-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Thu, 10 Mar 2022 22:18:17 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Thu, 10 Mar 2022 22:18:16 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Tadeusz Struk' <tadeusz.struk@linaro.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com" 
        <syzbot+e223cf47ec8ae183f2a0@syzkaller.appspotmail.com>
Subject: RE: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Thread-Topic: [PATCH v2] net: ipv6: fix skb_over_panic in __ip6_append_data
Thread-Index: AQHYNMwtn/GFN1e7cUOoZGj2dooiCKy5LxsQ
Date:   Thu, 10 Mar 2022 22:18:16 +0000
Message-ID: <d83a4ea5fc794728bf5d2bf6f0d4fce9@AcuMS.aculab.com>
References: <CA+FuTScPUVpyK6WYXrePTg_533VF2wfPww4MOJYa17v0xbLeGQ@mail.gmail.com>
 <20220310221328.877987-1-tadeusz.struk@linaro.org>
In-Reply-To: <20220310221328.877987-1-tadeusz.struk@linaro.org>
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
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tadeusz Struk
> Sent: 10 March 2022 22:13
> 
> Syzbot found a kernel bug in the ipv6 stack:
> LINK: https://syzkaller.appspot.com/bug?id=205d6f11d72329ab8d62a610c44c5e7e25415580
> The reproducer triggers it by sending a crafted message via sendmmsg()
> call, which triggers skb_over_panic, and crashes the kernel:
> 
> skbuff: skb_over_panic: text:ffffffff84647fb4 len:65575 put:65575
> head:ffff888109ff0000 data:ffff888109ff0088 tail:0x100af end:0xfec0
> dev:<NULL>
> 
> Add a check that prevents an invalid packet with MTU equall to the
> fregment header size to eat up all the space for payload.

There probably ought to be a check much earlier that stops
the option that makes the iphdr being to big being accepted
in the first place.

Much better to do the check in the option generation code.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

