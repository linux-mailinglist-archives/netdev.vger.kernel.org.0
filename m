Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4668039433C
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 15:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235908AbhE1NL1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 May 2021 09:11:27 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.85.151]:50814 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234259AbhE1NLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 09:11:23 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-94-3k4EBtglPISPPGh0Tot5Ig-1; Fri, 28 May 2021 14:09:45 +0100
X-MC-Unique: 3k4EBtglPISPPGh0Tot5Ig-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 28 May 2021 14:09:43 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 28 May 2021 14:09:43 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     =?iso-8859-1?Q?=27Michal_Such=E1nek=27?= <msuchanek@suse.de>
CC:     'Mel Gorman' <mgorman@techsingularity.net>,
        'Andrii Nakryiko' <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: RE: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Thread-Topic: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
Thread-Index: AQHXUwZwxICJrzVIrECdOMP8p5MLKKr4istw////SYCAABppAP//9DIAgABEOWA=
Date:   Fri, 28 May 2021 13:09:43 +0000
Message-ID: <5517a591606042d7aeae3c15b8c91d30@AcuMS.aculab.com>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org> <20210527090422.GA30378@techsingularity.net>
 <YK9j3YeMTZ+0I8NA@infradead.org>
 <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
 <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
 <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
 <20210528090421.GK30378@techsingularity.net>
 <2755b39d723146168e875f3b4a851a0d@AcuMS.aculab.com>
 <20210528095637.GO8544@kitsune.suse.cz>
In-Reply-To: <20210528095637.GO8544@kitsune.suse.cz>
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

From: Michal Suchánek
> Sent: 28 May 2021 10:57
> 
> On Fri, May 28, 2021 at 09:49:28AM +0000, David Laight wrote:
...
> > I can see there might be similar issues with the version of libelf-devel
> > (needed by objtool).
> > If I compile anything with gcc 10 (I'm doing build-root builds)
> > I get object files that the hosts 2.30 binutils complain about.
> > I can easily see that updating gcc and binutils might leave a
> > broken objtool unless the required updated libelf-devel package
> > can be found.
> > Statically linking the required parts of libelf into objtool
> > would save any such problems.
> 
> Static libraries are not always available. Especially for core toolchain
> libraries the developers often have some ideas about which of the static
> and dynamic libraris is the 'correct' one that they like to enforce.

The issue is that you want a version of libelf that works with objtool
and the versions of binutils/gcc/clang that the kernel build supports.
If libelf was part of the binutils package this might be ok.
But it isn't and it may end up with people scrambling around to find
a working version to build a kernel (or out of tree module).

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

