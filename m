Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB0C2AA478
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 11:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbgKGKqU convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 7 Nov 2020 05:46:20 -0500
Received: from eu-smtp-delivery-151.mimecast.com ([207.82.80.151]:59677 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726034AbgKGKqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 05:46:19 -0500
Received: from AcuMS.aculab.com (156.67.243.126 [156.67.243.126]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-140-msBd2F_bM0aXdiLYBHdEZA-1; Sat, 07 Nov 2020 10:46:15 +0000
X-MC-Unique: msBd2F_bM0aXdiLYBHdEZA-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:43c:695e:880f:8750) with Microsoft SMTP
 Server (TLS) id 15.0.1347.2; Sat, 7 Nov 2020 10:46:14 +0000
Received: from AcuMS.Aculab.com ([fe80::43c:695e:880f:8750]) by
 AcuMS.aculab.com ([fe80::43c:695e:880f:8750%12]) with mapi id 15.00.1347.000;
 Sat, 7 Nov 2020 10:46:14 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Joe Perches' <joe@perches.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "xiakaixu1987@gmail.com" <xiakaixu1987@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Kaixu Xia <kaixuxia@tencent.com>
Subject: RE: [PATCH] libbpf: Remove unnecessary conversion to bool
Thread-Topic: [PATCH] libbpf: Remove unnecessary conversion to bool
Thread-Index: AQHWtIbeQirvCJY95ES7G/VMIbfcM6m8e+Tg
Date:   Sat, 7 Nov 2020 10:46:14 +0000
Message-ID: <72757066568b4b64b89572e04d783137@AcuMS.aculab.com>
References: <1604646759-785-1-git-send-email-kaixuxia@tencent.com>
         <CAEf4BzZQ6=-h3g1duXFwDLr92z7nE6ajv8Rz_Zv=qx=-F3sRVA@mail.gmail.com>
 <d1cefb17a0a915fdabe7a80d14895ff3d85970c1.camel@perches.com>
In-Reply-To: <d1cefb17a0a915fdabe7a80d14895ff3d85970c1.camel@perches.com>
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

From: Joe Perches
> Sent: 06 November 2020 21:50
> 
> On Fri, 2020-11-06 at 13:32 -0800, Andrii Nakryiko wrote:
> > On Thu, Nov 5, 2020 at 11:12 PM <xiakaixu1987@gmail.com> wrote:
> > > Fix following warning from coccinelle:
> > > ./tools/lib/bpf/libbpf.c:1478:43-48: WARNING: conversion to bool not needed here
> []
> > > diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> []
> > > @@ -1475,7 +1475,7 @@ static int set_kcfg_value_tri(struct extern_desc *ext, void *ext_val,
> > >                                 ext->name, value);
> > >                         return -EINVAL;
> > >                 }
> > > -               *(bool *)ext_val = value == 'y' ? true : false;
> > > +               *(bool *)ext_val = value == 'y';
> >
> > I actually did this intentionally. x = y == z; pattern looked too
> > obscure to my taste, tbh.
> 
> It's certainly a question of taste and obviously there is nothing
> wrong with yours.
> 
> Maybe adding parentheses makes the below look less obscure to you?
> 
> 	x = (y == z);

That just leads to people thinking conditionals need to be in parentheses
and then getting the priorities for ?: all wrong as in:
	x = a + (b == c) ? d : e;

It would (probably) be better to make 'ext_val' be a union type
(probably a 'pointer to a union' rather than a union of pointers)
so that all the casts go away.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

