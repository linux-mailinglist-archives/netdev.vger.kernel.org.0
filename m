Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DAAE46E1CD
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 06:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbhLIFVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 00:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhLIFVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 00:21:19 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8C0CC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 21:17:46 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso3965427pjb.0
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 21:17:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=4Isb6RngWyyYYY0h5iwHxhT4CUuYmE9K4Ijbwpppe/0=;
        b=IL5y49lFnodstx6ZHbCevJ2A0UtuFWSB7P+SVQoyXjyMOzs1+g2szBeI+DT2GHyuoB
         sxNW5XztebuX6XDOecmzcRc98qhQeVA6Jv41IJr50YrobsFlg7pt9tO9z0JIf3CgAlKI
         y96bx9wMK/hD4Em4Kg1dEg6fBo5nVFa6NuJOg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=4Isb6RngWyyYYY0h5iwHxhT4CUuYmE9K4Ijbwpppe/0=;
        b=MK/gk/ZPCWXA4WXSsDKk95vhpX7UDbI2uUExCDp5QKbpNTGKPT2290J6r/t5ZIj2KN
         /ie2LcfidsKuKQKleSu1NntLnUDUJgPvUO6+h5xZ647HgelkB4aJcg5K9oRiS4EY15pM
         xUS9+1EN0gjNfPO05H5486MpnyovewxBGwT4Ixi26UA3qe/K2vKbvI2TySJKMIo8JAQ3
         jefrngBppxQ5S9nn3oI+a8tPb6pOHa0njT87CIPFgM1Wjbs55NfNFT9dhjSsbQoFV1Ro
         9WSBzNGkxO62XRxUSg+hkR1bNYDHyewZGWtW37HTk4QhJ6VK98kZ8xKoIKu7l0WAb/Ha
         sbyA==
X-Gm-Message-State: AOAM533V11oobxB9ZYshNZs7kp06H0dYbbsvSYR1LKKK8S/N2t9JoKYO
        CKfcFcsOOcf0yrPcKvBaOb74Kw==
X-Google-Smtp-Source: ABdhPJxeNFepnXXB/34L76N4vdRimSjaTfTVdfxtfwCC2tAYfw81FunJcFYhweowBzFuUyDf4LbXkA==
X-Received: by 2002:a17:902:e5c9:b0:142:53c4:478d with SMTP id u9-20020a170902e5c900b0014253c4478dmr63375010plf.33.1639027066307;
        Wed, 08 Dec 2021 21:17:46 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id 66sm4266192pgg.63.2021.12.08.21.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 21:17:45 -0800 (PST)
Date:   Wed, 8 Dec 2021 21:17:44 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     xiujianfeng <xiujianfeng@huawei.com>,
        laniel_francis@privacyrequired.com,
        andriy.shevchenko@linux.intel.com, adobriyan@gmail.com,
        linux@roeck-us.net, andreyknvl@gmail.com, dja@axtens.net,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH -next 1/2] string.h: Introduce memset_range() for wiping
 members
Message-ID: <202112082111.14E796A23@keescook>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
 <20211208030451.219751-2-xiujianfeng@huawei.com>
 <20211207202829.48d15f0ffa006e3656811784@linux-foundation.org>
 <e2d5936d-8490-5871-b3d4-b286d256832a@huawei.com>
 <20211208154437.01441d2dcf4cd812a9c58a7d@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211208154437.01441d2dcf4cd812a9c58a7d@linux-foundation.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 08, 2021 at 03:44:37PM -0800, Andrew Morton wrote:
> On Wed, 8 Dec 2021 18:30:26 +0800 xiujianfeng <xiujianfeng@huawei.com> wrote:
> 
> > 
> > 在 2021/12/8 12:28, Andrew Morton 写道:
> > > On Wed, 8 Dec 2021 11:04:50 +0800 Xiu Jianfeng <xiujianfeng@huawei.com> wrote:
> > >
> > >> Motivated by memset_after() and memset_startat(), introduce a new helper,
> > >> memset_range() that takes the target struct instance, the byte to write,
> > >> and two member names where zeroing should start and end.
> > > Is this likely to have more than a single call site?
> > There maybe more call site for this function, but I just use bpf as an 
> > example.
> > >
> > >> ...
> > >>
> > >> --- a/include/linux/string.h
> > >> +++ b/include/linux/string.h
> > >> @@ -291,6 +291,26 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
> > >>   	       sizeof(*(obj)) - offsetof(typeof(*(obj)), member));	\
> > >>   })
> > >>   
> > >> +/**
> > >> + * memset_range - Set a value ranging from member1 to member2, boundary included.
> > > I'm not sure what "boundary included" means.
> > I mean zeroing from member1 to member2(including position indicated by 
> > member1 and member2)
> > >
> > >> + *
> > >> + * @obj: Address of target struct instance
> > >> + * @v: Byte value to repeatedly write
> > >> + * @member1: struct member to start writing at
> > >> + * @member2: struct member where writing should stop
> > > Perhaps "struct member before which writing should stop"?
> > memset_range should include position indicated by member2 as well
> 
> In that case we could say "struct member where writing should stop
> (inclusive)", to make it very clear.
> 
> > >
> > >> + *
> > >> + */
> > >> +#define memset_range(obj, v, member_1, member_2)			\
> > >> +({									\
> > >> +	u8 *__ptr = (u8 *)(obj);					\
> > >> +	typeof(v) __val = (v);						\
> > >> +	BUILD_BUG_ON(offsetof(typeof(*(obj)), member_1) >		\
> > >> +		     offsetof(typeof(*(obj)), member_2));		\
> > >> +	memset(__ptr + offsetof(typeof(*(obj)), member_1), __val,	\
> > >> +	       offsetofend(typeof(*(obj)), member_2) -			\
> > >> +	       offsetof(typeof(*(obj)), member_1));			\
> > >> +})
> > > struct a {
> > > 	int b;
> > > 	int c;
> > > 	int d;
> > > };
> > >
> > > How do I zero out `c' and `d'?
> > if you want to zero out 'c' and 'd', you can use it like 
> > memset_range(a_ptr, c, d);
> 
> But I don't think that's what the code does!
> 
> it expands to
> 
> 	memset(__ptr + offsetof(typeof(*(a)), c), __val,
> 	       offsetofend(typeof(*(a)), d) -
> 	       offsetof(typeof(*(a)), c));
> 
> which expands to
> 
> 	memset(__ptr + 4, __val,
> 	       8 -
> 	       4);
> 
> and `d' will not be written to.

Please don't add memset_range(): just use a struct_group() to capture
the range and use memset() against the new substruct. This will allow
for the range to be documented where it is defined in the struct (rather
than deep in some code), keep any changes centralized instead of spread
around in memset_range() calls, protect against accidental struct member
reordering breaking things, and lets the compiler be able to examine
the range explicitly and do all the correct bounds checking:

struct a {
	int b;
	struct_group(range,
		int c;
		int d;
	);
	int e;
};

memset(&instance->range, 0, sizeof(instance->range));

memset_from/after() were added because of the very common case of "wipe
from here to end", which stays tied to a single member, and addressed
cases where struct_group() couldn't help (e.g. trailing padding).

-- 
Kees Cook
