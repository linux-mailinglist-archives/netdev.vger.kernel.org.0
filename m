Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C55339404E
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 11:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhE1JvK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 28 May 2021 05:51:10 -0400
Received: from eu-smtp-delivery-151.mimecast.com ([185.58.86.151]:38065 "EHLO
        eu-smtp-delivery-151.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235299AbhE1JvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 05:51:08 -0400
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 uk-mta-275-yccOMhXpN7i8SNWlKAUUQw-1; Fri, 28 May 2021 10:49:31 +0100
X-MC-Unique: yccOMhXpN7i8SNWlKAUUQw-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Fri, 28 May 2021 10:49:29 +0100
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.015; Fri, 28 May 2021 10:49:29 +0100
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Mel Gorman' <mgorman@techsingularity.net>
CC:     'Andrii Nakryiko' <andrii.nakryiko@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, "Yonghong Song" <yhs@fb.com>,
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
Thread-Index: AQHXUwZwxICJrzVIrECdOMP8p5MLKKr4istw////SYCAABppAA==
Date:   Fri, 28 May 2021 09:49:28 +0000
Message-ID: <2755b39d723146168e875f3b4a851a0d@AcuMS.aculab.com>
References: <20210526080741.GW30378@techsingularity.net>
 <YK9SiLX1E1KAZORb@infradead.org> <20210527090422.GA30378@techsingularity.net>
 <YK9j3YeMTZ+0I8NA@infradead.org>
 <CAEf4BzZLy0s+t+Nj9QgUNM66Ma6HN=VkS+ocgT5h9UwanxHaZQ@mail.gmail.com>
 <CAEf4BzbzPK-3cyLFM8QKE5-o_dL7=UCcvRF+rEqyUcHhyY+FJg@mail.gmail.com>
 <8fe547e9e87f40aebce82021d76a2d08@AcuMS.aculab.com>
 <20210528090421.GK30378@techsingularity.net>
In-Reply-To: <20210528090421.GK30378@techsingularity.net>
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

From: Mel Gorman
> Sent: 28 May 2021 10:04
> 
> On Fri, May 28, 2021 at 08:09:39AM +0000, David Laight wrote:
> > From: Andrii Nakryiko
> > > Sent: 27 May 2021 15:42
> > ...
> > > I agree that empty structs are useful, but here we are talking about
> > > per-CPU variables only, which is the first use case so far, as far as
> > > I can see. If we had pahole 1.22 released and widely packaged it could
> > > have been a viable option to force it on everyone.
> > ...
> >
> > Would it be feasible to put the sources for pahole into the
> > kernel repository and build it at the same time as objtool?
> 
> We don't store other build dependencies like compilers, binutils etc in
> the kernel repository even though minimum versions are mandated.
> Obviously tools/ exists but for the most part, they are tools that do
> not exist in other repositories and are kernel-specific. I don't know if
> pahole would be accepted and it introduces the possibility that upstream
> pahole and the kernel fork of it would diverge.

The other side of the coin is that is you want reproducible builds
the smaller the number of variables that need to match the better.

I can see there might be similar issues with the version of libelf-devel
(needed by objtool).
If I compile anything with gcc 10 (I'm doing build-root builds)
I get object files that the hosts 2.30 binutils complain about.
I can easily see that updating gcc and binutils might leave a
broken objtool unless the required updated libelf-devel package
can be found.
Statically linking the required parts of libelf into objtool
would save any such problems.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

