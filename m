Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31BCA582243
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 10:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiG0Ig0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jul 2022 04:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiG0IgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 04:36:25 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7EA7459A0
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 01:36:23 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-216-G3MsD2lvP_O3H9T1lzIpBg-1; Wed, 27 Jul 2022 09:36:20 +0100
X-MC-Unique: G3MsD2lvP_O3H9T1lzIpBg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Wed, 27 Jul 2022 09:36:19 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Wed, 27 Jul 2022 09:36:19 +0100
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
Subject: RE: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Thread-Topic: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Thread-Index: AQHYoX9rkSbmKz+Wykmj0IeOsCioUq2R48pw
Date:   Wed, 27 Jul 2022 08:36:18 +0000
Message-ID: <381439a429b54e8e8dda848e1d3d306f@AcuMS.aculab.com>
References: <20220727060856.2370358-1-kafai@fb.com>
 <20220727060909.2371812-1-kafai@fb.com>
In-Reply-To: <20220727060909.2371812-1-kafai@fb.com>
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
> Most of the codes in bpf_setsockopt(SOL_SOCKET) are duplicated from
> the sock_setsockopt().  The number of supported options are
> increasing ever and so as the duplicated codes.
> 
> One issue in reusing sock_setsockopt() is that the bpf prog
> has already acquired the sk lock.  sockptr_t is useful to handle this.
> sockptr_t already has a bit 'is_kernel' to handle the kernel-or-user
> memory copy.  This patch adds a 'is_bpf' bit to tell if sk locking
> has already been ensured by the bpf prog.

That is a really horrid place to hide an 'is locked' bit.

You'd be better off splitting sock_setsockopt() to add a function
that is called with sk_lock held and the value read.
That would also save the churn of all the callers.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

