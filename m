Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C541341FCFB
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 18:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233585AbhJBQLI convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 2 Oct 2021 12:11:08 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:44527 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233451AbhJBQLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 12:11:07 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-185-X3JNG97FPwich-hLz-WT8w-1; Sat, 02 Oct 2021 17:09:19 +0100
X-MC-Unique: X3JNG97FPwich-hLz-WT8w-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.23; Sat, 2 Oct 2021 17:09:17 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.023; Sat, 2 Oct 2021 17:09:17 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Kees Cook' <keescook@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [PATCH bpf-next v2 2/2] bpf: Replace callers of BPF_CAST_CALL
 with proper function typedef
Thread-Topic: [PATCH bpf-next v2 2/2] bpf: Replace callers of BPF_CAST_CALL
 with proper function typedef
Thread-Index: AQHXtL3/8BB2BiidZEGFv/aSkiFUcau/5NIA
Date:   Sat, 2 Oct 2021 16:09:17 +0000
Message-ID: <29ca9f764f07426093b570515dc8e025@AcuMS.aculab.com>
References: <20210928230946.4062144-1-keescook@chromium.org>
 <20210928230946.4062144-3-keescook@chromium.org>
In-Reply-To: <20210928230946.4062144-3-keescook@chromium.org>
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kees Cook
> Sent: 29 September 2021 00:10
...
> In order to keep ahead of cases in the kernel where Control Flow
> Integrity (CFI) may trip over function call casts, enabling
> -Wcast-function-type is helpful. To that end, BPF_CAST_CALL causes
> various warnings and is one of the last places in the kernel
> triggering this warning.
...
> -static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
> +static int bpf_for_each_array_elem(struct bpf_map *map, bpf_callback_t callback_fn,
>  				   void *callback_ctx, u64 flags)
>  {
>  	u32 i, key, num_elems = 0;
> @@ -668,9 +668,8 @@ static int bpf_for_each_array_elem(struct bpf_map *map, void *callback_fn,
>  			val = array->value + array->elem_size * i;
>  		num_elems++;
>  		key = i;
> -		ret = BPF_CAST_CALL(callback_fn)((u64)(long)map,
> -					(u64)(long)&key, (u64)(long)val,
> -					(u64)(long)callback_ctx, 0);
> +		ret = callback_fn((u64)(long)map, (u64)(long)&key,
> +				  (u64)(long)val, (u64)(long)callback_ctx, 0);
>  		/* return value: 0 - continue, 1 - stop and return */
>  		if (ret)
>  			break;

This is still entirely horrid and potentially error prone.
While a callback function seems a nice idea the code is
almost always better and much easier to read if some
kind of iterator function is used so that the calling
code is just a simple loop.
This is true even if you need a #define for the loop end.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

