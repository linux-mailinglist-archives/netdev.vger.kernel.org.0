Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E44584E7A
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 12:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234932AbiG2KEf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Jul 2022 06:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiG2KEe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 06:04:34 -0400
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 292F57B372
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 03:04:33 -0700 (PDT)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-315-tE6h0QNRNy-hJiKiIBFEYA-1; Fri, 29 Jul 2022 11:04:30 +0100
X-MC-Unique: tE6h0QNRNy-hJiKiIBFEYA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.36; Fri, 29 Jul 2022 11:04:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.036; Fri, 29 Jul 2022 11:04:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Jakub Kicinski' <kuba@kernel.org>, Martin KaFai Lau <kafai@fb.com>
CC:     Stanislav Fomichev <sdf@google.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: RE: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Thread-Topic: [PATCH bpf-next 02/14] bpf: net: Avoid sock_setsockopt() taking
 sk lock when called from bpf
Thread-Index: AQHYoqL7kSbmKz+Wykmj0IeOsCioUq2VHixQ
Date:   Fri, 29 Jul 2022 10:04:29 +0000
Message-ID: <732a8006394f49d58c586156f3f81281@AcuMS.aculab.com>
References: <20220727060856.2370358-1-kafai@fb.com>
        <20220727060909.2371812-1-kafai@fb.com>
        <YuFsHaTIu7dTzotG@google.com>
        <20220727183700.iczavo77o6ubxbwm@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBt5-p24p9AvuEntb=gRFsJ_UQZ_GX8mFsPZZPq7CgL_4A@mail.gmail.com>
        <20220727212133.3uvpew67rzha6rzp@kafai-mbp.dhcp.thefacebook.com>
        <CAKH8qBs3jp_0gRiHyzm29HaW53ZYpGYpWbmLhwi87xWKi9g=UA@mail.gmail.com>
        <20220728004546.6n42isdvyg65vuke@kafai-mbp.dhcp.thefacebook.com>
        <20220727184903.4d24a00a@kernel.org>
        <20220728163104.usdkmsxjyqwaitxu@kafai-mbp.dhcp.thefacebook.com>
 <20220728095629.6109f78c@kernel.org>
In-Reply-To: <20220728095629.6109f78c@kernel.org>
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

From: Jakub Kicinski
> Sent: 28 July 2022 17:56
> 
> On Thu, 28 Jul 2022 09:31:04 -0700 Martin KaFai Lau wrote:
> > If I understand the concern correctly, it may not be straight forward to
> > grip the reason behind the testings at in_bpf() [ the in_task() and
> > the current->bpf_ctx test ] ?  Yes, it is a valid point.
> >
> > The optval.is_bpf bit can be directly traced back to the bpf_setsockopt
> > helper and should be easier to reason about.
> 
> I think we're saying the opposite thing. in_bpf() the context checking
> function is fine. There is a clear parallel to in_task() and combined
> with the capability check it should be pretty obvious what the code
> is intending to achieve.
> 
> sockptr_t::in_bpf which randomly implies that the lock is already held
> will be hard to understand for anyone not intimately familiar with the
> BPF code. Naming that bit is_locked seems much clearer.
> 
> Which is what I believe Stan was proposing.

Or make sk_setsockopt() be called after the integer value
has been read and with the lock held.

That saves any (horrid) conditional locking.

Also sockptr_t should probably have been a structure with separate
user and kernel address fields.
Putting the length in there would (probably) save code.

There then might be scope for pre-copying short user buffers
into a kernel buffer while still allowing the requests that
ignore the length copy directly from a user buffer.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

