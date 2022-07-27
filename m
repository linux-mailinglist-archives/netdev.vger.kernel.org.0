Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C51C5821CD
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiG0ILe convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jul 2022 04:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229659AbiG0ILd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:11:33 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B22F35F6F
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:11:31 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-239-LGqOHlenN8mdXkYQ1UkmPA-1; Wed, 27 Jul 2022 09:11:28 +0100
X-MC-Unique: LGqOHlenN8mdXkYQ1UkmPA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 27 Jul 2022 09:11:26 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 27 Jul 2022 09:11:26 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Martin KaFai Lau' <kafai@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH bpf-next 01/14] net: Change sock_setsockopt from taking
 sock ptr to sk ptr
Thread-Topic: [PATCH bpf-next 01/14] net: Change sock_setsockopt from taking
 sock ptr to sk ptr
Thread-Index: AQHYoX9n6rKpB2E9FUqjXO+qN4rZzq2R3DpA
Date:   Wed, 27 Jul 2022 08:11:26 +0000
Message-ID: <a9a3e00db4764ffcaf3324046d736b76@AcuMS.aculab.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060902.2370689-1-kafai@fb.com>
In-Reply-To: <20220727060902.2370689-1-kafai@fb.com>
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
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin KaFai Lau
> Sent: 27 July 2022 07:09
> 
> A latter patch refactors bpf_setsockopt(SOL_SOCKET) with the
> sock_setsockopt() to avoid code duplication and code
> drift between the two duplicates.
> 
> The current sock_setsockopt() takes sock ptr as the argument.
> The very first thing of this function is to get back the sk ptr
> by 'sk = sock->sk'.
> 
> bpf_setsockopt() could be called when the sk does not have
> a userspace owner.  Meaning sk->sk_socket is NULL.  For example,
> when a passive tcp connection has just been established.  Thus,
> it cannot use the sock_setsockopt(sk->sk_socket) or else it will
> pass a NULL sock ptr.

I'm intrigued, I've some code that uses sock_create_kern() to create
sockets without a userspace owner - I'd have though bpf is doing
much the same.

I end up doing:
        if (level == SOL_SOCKET)
                err = sock_setsockopt(sock, level, optname, koptval, optlen);
        else
                err = sock->ops->setsockopt(sock, level, optname, koptval,
                                            optlen);
to set options.
(This code used to use kern_setsockopt() - but that got removed.)

I'd have though bpf would need similar code??

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

