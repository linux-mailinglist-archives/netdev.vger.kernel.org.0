Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6874D46DF16
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 00:45:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241252AbhLHXsQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 18:48:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45636 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbhLHXsP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 18:48:15 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA711B82312;
        Wed,  8 Dec 2021 23:44:41 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id CF5CE603E4;
        Wed,  8 Dec 2021 23:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639007080;
        bh=UkQani6FEO+P7NP71yI3ezLyKvLVm8th0l7ERr+VtXM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EUwAtzZ4il4NboJbOfflvB9STYCCGKnPsyM1Kx+UZicRJY2jIlEX+pWzbzZKA7rJg
         5mXivCSeUyD9QvoEO6vhhT9wtSX3TvfYHC7X1hg6aO5TIsoZ7QMOgG+bNdm1NckAN/
         xJBrUVFEic3wFBBoBYWBQkLpBP+Y7AUWHE3mhLm4=
Date:   Wed, 8 Dec 2021 15:44:37 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     xiujianfeng <xiujianfeng@huawei.com>
Cc:     <keescook@chromium.org>, <laniel_francis@privacyrequired.com>,
        <andriy.shevchenko@linux.intel.com>, <adobriyan@gmail.com>,
        <linux@roeck-us.net>, <andreyknvl@gmail.com>, <dja@axtens.net>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH -next 1/2] string.h: Introduce memset_range() for wiping
 members
Message-Id: <20211208154437.01441d2dcf4cd812a9c58a7d@linux-foundation.org>
In-Reply-To: <e2d5936d-8490-5871-b3d4-b286d256832a@huawei.com>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
        <20211208030451.219751-2-xiujianfeng@huawei.com>
        <20211207202829.48d15f0ffa006e3656811784@linux-foundation.org>
        <e2d5936d-8490-5871-b3d4-b286d256832a@huawei.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 18:30:26 +0800 xiujianfeng <xiujianfeng@huawei.com> wrote:

> 
> 在 2021/12/8 12:28, Andrew Morton 写道:
> > On Wed, 8 Dec 2021 11:04:50 +0800 Xiu Jianfeng <xiujianfeng@huawei.com> wrote:
> >
> >> Motivated by memset_after() and memset_startat(), introduce a new helper,
> >> memset_range() that takes the target struct instance, the byte to write,
> >> and two member names where zeroing should start and end.
> > Is this likely to have more than a single call site?
> There maybe more call site for this function, but I just use bpf as an 
> example.
> >
> >> ...
> >>
> >> --- a/include/linux/string.h
> >> +++ b/include/linux/string.h
> >> @@ -291,6 +291,26 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
> >>   	       sizeof(*(obj)) - offsetof(typeof(*(obj)), member));	\
> >>   })
> >>   
> >> +/**
> >> + * memset_range - Set a value ranging from member1 to member2, boundary included.
> > I'm not sure what "boundary included" means.
> I mean zeroing from member1 to member2(including position indicated by 
> member1 and member2)
> >
> >> + *
> >> + * @obj: Address of target struct instance
> >> + * @v: Byte value to repeatedly write
> >> + * @member1: struct member to start writing at
> >> + * @member2: struct member where writing should stop
> > Perhaps "struct member before which writing should stop"?
> memset_range should include position indicated by member2 as well

In that case we could say "struct member where writing should stop
(inclusive)", to make it very clear.

> >
> >> + *
> >> + */
> >> +#define memset_range(obj, v, member_1, member_2)			\
> >> +({									\
> >> +	u8 *__ptr = (u8 *)(obj);					\
> >> +	typeof(v) __val = (v);						\
> >> +	BUILD_BUG_ON(offsetof(typeof(*(obj)), member_1) >		\
> >> +		     offsetof(typeof(*(obj)), member_2));		\
> >> +	memset(__ptr + offsetof(typeof(*(obj)), member_1), __val,	\
> >> +	       offsetofend(typeof(*(obj)), member_2) -			\
> >> +	       offsetof(typeof(*(obj)), member_1));			\
> >> +})
> > struct a {
> > 	int b;
> > 	int c;
> > 	int d;
> > };
> >
> > How do I zero out `c' and `d'?
> if you want to zero out 'c' and 'd', you can use it like 
> memset_range(a_ptr, c, d);

But I don't think that's what the code does!

it expands to

	memset(__ptr + offsetof(typeof(*(a)), c), __val,
	       offsetofend(typeof(*(a)), d) -
	       offsetof(typeof(*(a)), c));

which expands to

	memset(__ptr + 4, __val,
	       8 -
	       4);

and `d' will not be written to.
