Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A555D46CC8C
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 05:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240384AbhLHEcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 23:32:07 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34912 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233519AbhLHEcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 23:32:06 -0500
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2B393CE1FAC;
        Wed,  8 Dec 2021 04:28:33 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB9526052B;
        Wed,  8 Dec 2021 04:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1638937711;
        bh=y2aFHRT3xbJ/MoeEYqljar7awQKq44QJXZDHZuqCzPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o18aB1wlNWXcDx4GIxajZ91AO4rjNAkU75DEEEu2gYbj6NDddyNQy9+4K7fw1L2l2
         PWfzlf/kBF48gLIUWMO8oOeZgbBw/mdMpWQCdOQR/CgUtf3Ox+3/f9hfdTrPAx0Wf6
         8VVQBio4EFIvmW75zH6vYLNknDsu3cfdA0wUvg3Y=
Date:   Tue, 7 Dec 2021 20:28:29 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
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
Message-Id: <20211207202829.48d15f0ffa006e3656811784@linux-foundation.org>
In-Reply-To: <20211208030451.219751-2-xiujianfeng@huawei.com>
References: <20211208030451.219751-1-xiujianfeng@huawei.com>
        <20211208030451.219751-2-xiujianfeng@huawei.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 8 Dec 2021 11:04:50 +0800 Xiu Jianfeng <xiujianfeng@huawei.com> wrote:

> Motivated by memset_after() and memset_startat(), introduce a new helper,
> memset_range() that takes the target struct instance, the byte to write,
> and two member names where zeroing should start and end.

Is this likely to have more than a single call site?

> ...
>
> --- a/include/linux/string.h
> +++ b/include/linux/string.h
> @@ -291,6 +291,26 @@ void memcpy_and_pad(void *dest, size_t dest_len, const void *src, size_t count,
>  	       sizeof(*(obj)) - offsetof(typeof(*(obj)), member));	\
>  })
>  
> +/**
> + * memset_range - Set a value ranging from member1 to member2, boundary included.

I'm not sure what "boundary included" means.

> + *
> + * @obj: Address of target struct instance
> + * @v: Byte value to repeatedly write
> + * @member1: struct member to start writing at
> + * @member2: struct member where writing should stop

Perhaps "struct member before which writing should stop"?

> + *
> + */
> +#define memset_range(obj, v, member_1, member_2)			\
> +({									\
> +	u8 *__ptr = (u8 *)(obj);					\
> +	typeof(v) __val = (v);						\
> +	BUILD_BUG_ON(offsetof(typeof(*(obj)), member_1) >		\
> +		     offsetof(typeof(*(obj)), member_2));		\
> +	memset(__ptr + offsetof(typeof(*(obj)), member_1), __val,	\
> +	       offsetofend(typeof(*(obj)), member_2) -			\
> +	       offsetof(typeof(*(obj)), member_1));			\
> +})

struct a {
	int b;
	int c;
	int d;
};

How do I zero out `c' and `d'?


