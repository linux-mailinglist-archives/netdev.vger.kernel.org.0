Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767463E16F0
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241683AbhHEO1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241678AbhHEO1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 10:27:06 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAFEC0613D5
        for <netdev@vger.kernel.org>; Thu,  5 Aug 2021 07:26:51 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id s22-20020a17090a1c16b0290177caeba067so15267788pjs.0
        for <netdev@vger.kernel.org>; Thu, 05 Aug 2021 07:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Z62VjdfuhZ7eaSPHHjKLEZ+eXOGVQq7qo6c+hqx5eo=;
        b=VxkbNqNxmqK7N6+gir754s4mC/jo06fa/HBdjo8oOiKQyRvxubUoICA7wJdmeidP7s
         AYadKd+PhX3wT6AJ3bNeOEWSaDz+dlz2UjDSLX13vPjkNc1DoEjY+nh2YcOqFTMI1qHW
         olsAfWxrAIcydP8F3xkoZLv2QxTEv7o+UR0w4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4Z62VjdfuhZ7eaSPHHjKLEZ+eXOGVQq7qo6c+hqx5eo=;
        b=iR9k5xymzrER1mnc7cGdmp/gfqxWppCGaoMXkYfZY65WD9Lge7oxEBNaAaDersqC7L
         Ka9GuKLsl3LCrygZe3lr+LQrWnawzQo27pijg2JfeLLWtaNva15bNo4bax2F7ZX6EhGG
         3JEBw3Eo7eXc5zZuwCnQwvtrjQYBlz6+EYsBK27zAw/kEc44OcGruS+P9tghUEjhRx0g
         h6prbcWCrYKmwF0I1cBsbznKzi54S4k2W868VlKi6pcBnswrwd9yNB94dLFjpzzS4GnG
         hrwuEvRlHHkjjCbG903WVf6XfMQ10Xl5hfWPpvG4fWSxp+voq0OWZSxYcvANioIp5+oI
         jo6A==
X-Gm-Message-State: AOAM533feoYApDPOIhAYztBdagpZsyahmgCFANCNANzGxX3tv8OnbIuZ
        aKM+J+3gYYZGKjmiO6c3HN6Rhw==
X-Google-Smtp-Source: ABdhPJwZu5LjOvFgT6i3Po4/ZpUPMhEskn63XSLoGzDS+369QY0jKmg4fgfoE4G22vtrHrfiTnH1ww==
X-Received: by 2002:a62:92d7:0:b029:3c4:d123:928e with SMTP id o206-20020a6292d70000b02903c4d123928emr5487876pfd.43.1628173611107;
        Thu, 05 Aug 2021 07:26:51 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id c136sm6893037pfc.53.2021.08.05.07.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 07:26:50 -0700 (PDT)
Date:   Thu, 5 Aug 2021 07:26:49 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH] bpf: Fix integer overflow involving bucket_size
Message-ID: <202108050725.384AA3E0@keescook>
References: <20210805140515.35630-1-th.yasumatsu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805140515.35630-1-th.yasumatsu@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 11:05:15PM +0900, Tatsuhiko Yasumatsu wrote:
> In __htab_map_lookup_and_delete_batch(), hash buckets are iterated over
> to count the number of elements in each bucket (bucket_size).
> If bucket_size is large enough, the multiplication to calculate
> kvmalloc() size could overflow, resulting in out-of-bounds write
> as reported by KASAN.
> 
> [...]
> [  104.986052] BUG: KASAN: vmalloc-out-of-bounds in __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.986489] Write of size 4194224 at addr ffffc9010503be70 by task crash/112
> [  104.986889]
> [  104.987193] CPU: 0 PID: 112 Comm: crash Not tainted 5.14.0-rc4 #13
> [  104.987552] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [  104.988104] Call Trace:
> [  104.988410]  dump_stack_lvl+0x34/0x44
> [  104.988706]  print_address_description.constprop.0+0x21/0x140
> [  104.988991]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.989327]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.989622]  kasan_report.cold+0x7f/0x11b
> [  104.989881]  ? __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.990239]  kasan_check_range+0x17c/0x1e0
> [  104.990467]  memcpy+0x39/0x60
> [  104.990670]  __htab_map_lookup_and_delete_batch+0x5ce/0xb60
> [  104.990982]  ? __wake_up_common+0x4d/0x230
> [  104.991256]  ? htab_of_map_free+0x130/0x130
> [  104.991541]  bpf_map_do_batch+0x1fb/0x220
> [...]
> 
> In hashtable, if the elements' keys have the same jhash() value, the
> elements will be put into the same bucket. By putting a lot of elements
> into a single bucket, the value of bucket_size can be increased to
> trigger the integer overflow.
> 
> Triggering the overflow is possible for both callers with CAP_SYS_ADMIN
> and callers without CAP_SYS_ADMIN.
> 
> It will be trivial for a caller with CAP_SYS_ADMIN to intentionally
> reach this overflow by enabling BPF_F_ZERO_SEED. As this flag will set
> the random seed passed to jhash() to 0, it will be easy for the caller
> to prepare keys which will be hashed into the same value, and thus put
> all the elements into the same bucket.
> 
> If the caller does not have CAP_SYS_ADMIN, BPF_F_ZERO_SEED cannot be
> used. However, it will be still technically possible to trigger the
> overflow, by guessing the random seed value passed to jhash() (32bit)
> and repeating the attempt to trigger the overflow. In this case,
> the probability to trigger the overflow will be low and will take
> a very long time.
> 
> Fix the integer overflow by casting 1 operand to u64.
> 
> Fixes: 057996380a42 ("bpf: Add batch ops to all htab bpf map")
> Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
> ---
>  kernel/bpf/hashtab.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 72c58cc516a3..e29283c3b17f 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -1565,8 +1565,8 @@ __htab_map_lookup_and_delete_batch(struct bpf_map *map,
>  	/* We cannot do copy_from_user or copy_to_user inside
>  	 * the rcu_read_lock. Allocate enough space here.
>  	 */
> -	keys = kvmalloc(key_size * bucket_size, GFP_USER | __GFP_NOWARN);
> -	values = kvmalloc(value_size * bucket_size, GFP_USER | __GFP_NOWARN);
> +	keys = kvmalloc((u64)key_size * bucket_size, GFP_USER | __GFP_NOWARN);
> +	values = kvmalloc((u64)value_size * bucket_size, GFP_USER | __GFP_NOWARN);

Please, no open-coded multiplication[1]. This should use kvmalloc_array()
instead.

-Kees

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#open-coded-arithmetic-in-allocator-arguments

>  	if (!keys || !values) {
>  		ret = -ENOMEM;
>  		goto after_loop;
> -- 
> 2.25.1
> 

-- 
Kees Cook
