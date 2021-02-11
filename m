Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72ACA319100
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 18:28:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhBKR0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 12:26:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231339AbhBKRYx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 12:24:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D002461493;
        Thu, 11 Feb 2021 17:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613064252;
        bh=g0SkrS2QFdtlV54FrYrll23FOILIZo1QXLwmykI0Ezo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LkIGSf2mpC4VHxy88N4gJ5cJb4vb7pNJiHdB00ytT0Bv/9BKfs3i5Nc49dS4wzgWu
         qZJvXsITKoMa6SeJJkA/GuT3DqjGpv5hXejBxE98vX2kmKXQAYPAB8hLKsATEJubW+
         ZHIkvVquax4NKB8MWo5ubnnATlaAS5HMbdyOCv39XpBRRQ/h6KgIU/WgVXTU5NCwyx
         SR59SRNXz8pDusq1+jCWtqUGYX3JAyOQGEkZ0ATvDnXxApNj8TpZ9z7hRpP48V4F1y
         YILOYCJ9YHqf+lxJ4n/TGf+dF5ewYg6l9ihrpwY7Ew9WUyUsd25+KWHAcb9hrV6SSa
         l1BVJBb2thO1g==
Date:   Thu, 11 Feb 2021 10:24:10 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <20210211172410.GA3301430@ubuntu-m3-large-x86>
References: <20210209074904.GA286822@ubuntu-m3-large-x86>
 <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava>
 <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
 <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava>
 <YCVIWzq0quDQm6bn@krava>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCVIWzq0quDQm6bn@krava>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 04:08:11PM +0100, Jiri Olsa wrote:
> On Wed, Feb 10, 2021 at 09:13:47PM +0100, Jiri Olsa wrote:
> > On Wed, Feb 10, 2021 at 10:20:20AM -0800, Andrii Nakryiko wrote:
> > 
> > SNIP
> > 
> > > > but below is change for checking that ftrace addrs are within elf functions
> > > >
> > > > seems to work in my tests, I'll run some more tests and send full patch
> > > 
> > > It seems unnecessarily convoluted. I was thinking about something like
> > > this (the diff will totally be screwed up by gmail, and I haven't even
> > > compiled it):
> > > 
> > > diff --git a/btf_encoder.c b/btf_encoder.c
> > > index b124ec20a689..8162b238bd43 100644
> > > --- a/btf_encoder.c
> > > +++ b/btf_encoder.c
> > > @@ -236,6 +236,23 @@ get_kmod_addrs(struct btf_elf *btfe, __u64
> > > **paddrs, __u64 *pcount)
> > >         return 0;
> > >  }
> > > 
> > > +struct func_seg { __u64 start; __u64 end; };
> > > +
> > > +static int func_exists(struct func_seg *segs, size_t len, __u64 addr)
> > > +{
> > > +       size_t l = 0, r = len - 1, m;
> > > +
> > > +       while (l < r) {
> > > +               m = l + (r - l + 1) / 2;
> > > +               if (segs[m].start <= addr)
> > > +                       l = m;
> > > +               else
> > > +                       r = m - 1;
> > > +       }
> > > +
> > > +       return segs[l].start <= addr && addr < segs[l].end;
> > > +}
> > > +
> > >  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
> > >  {
> > >         __u64 *addrs, count, i;
> > > @@ -286,7 +303,7 @@ static int setup_functions(struct btf_elf *btfe,
> > > struct funcs_layout *fl)
> > >                 __u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> > > 
> > >                 /* Make sure function is within ftrace addresses. */
> > > -               if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> > > +               if (func_exists(addrs, count, addr))
> > 
> > you pass addrs in here, but you mean func_seg array
> > filled with elf functions start/end values, right?
> > 
> > >                         /*
> > >                          * We iterate over sorted array, so we can easily skip
> > >                          * not valid item and move following valid field into
> > > 
> > > 
> > > So the idea is to use address segments and check whether there is a
> > > segment that overlaps with a given address by first binary searching
> > > for a segment with the largest starting address that is <= addr. And
> > > then just confirming that segment does overlap with the requested
> > > address.
> > > 
> > > WDYT?
> 
> heya,
> with your approach I ended up with change below, it gives me same
> results as with the previous change
> 
> I think I'll separate the kmod bool address computation later on,
> but I did not want to confuse this change for now
> 
> jirka

This still looks good against the original and reduced problematic
configurations for aarch64.

Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..34df08f2fb4e 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -36,6 +36,7 @@ struct funcs_layout {
>  struct elf_function {
>  	const char	*name;
>  	unsigned long	 addr;
> +	unsigned long	 end;
>  	unsigned long	 sh_addr;
>  	bool		 generated;
>  };
> @@ -44,7 +45,7 @@ static struct elf_function *functions;
>  static int functions_alloc;
>  static int functions_cnt;
>  
> -static int functions_cmp(const void *_a, const void *_b)
> +static int functions_cmp_name(const void *_a, const void *_b)
>  {
>  	const struct elf_function *a = _a;
>  	const struct elf_function *b = _b;
> @@ -52,6 +53,16 @@ static int functions_cmp(const void *_a, const void *_b)
>  	return strcmp(a->name, b->name);
>  }
>  
> +static int functions_cmp_addr(const void *_a, const void *_b)
> +{
> +	const struct elf_function *a = _a;
> +	const struct elf_function *b = _b;
> +
> +	if (a->addr == b->addr)
> +		return 0;
> +	return a->addr < b->addr ? -1 : 1;
> +}
> +
>  static void delete_functions(void)
>  {
>  	free(functions);
> @@ -98,6 +109,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
>  
>  	functions[functions_cnt].name = name;
>  	functions[functions_cnt].addr = elf_sym__value(sym);
> +	functions[functions_cnt].end = (__u64) -1;
>  	functions[functions_cnt].sh_addr = sh.sh_addr;
>  	functions[functions_cnt].generated = false;
>  	functions_cnt++;
> @@ -236,6 +248,40 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
>  	return 0;
>  }
>  
> +static int is_ftrace_func(struct elf_function *func, __u64 *addrs,
> +			  __u64 count, bool kmod)
> +{
> +	/*
> +	 * For vmlinux image both addrs[x] and functions[x]::addr
> +	 * values are final address and are comparable.
> +	 *
> +	 * For kernel module addrs[x] is final address, but
> +	 * functions[x]::addr is relative address within section
> +	 * and needs to be relocated by adding sh_addr.
> +	 */
> +	__u64 start = kmod ? func->addr + func->sh_addr : func->addr;
> +	__u64 end   = kmod ? func->end + func->sh_addr : func->end;
> +
> +	size_t l = 0, r = count - 1, m;
> +	__u64 addr = 0;
> +
> +	while (l < r) {
> +		m = l + (r - l + 1) / 2;
> +		addr = addrs[m];
> +
> +		if (start <= addr && addr < end)
> +			return true;
> +
> +		if (start <= addr)
> +			r = m - 1;
> +		else
> +			l = m;
> +	}
> +
> +	addr = addrs[l];
> +	return start <= addr && addr < end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
>  	__u64 *addrs, count, i;
> @@ -267,7 +313,7 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  	}
>  
>  	qsort(addrs, count, sizeof(addrs[0]), addrs_cmp);
> -	qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp);
> +	qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_addr);
>  
>  	/*
>  	 * Let's got through all collected functions and filter
> @@ -275,18 +321,12 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  	 */
>  	for (i = 0; i < functions_cnt; i++) {
>  		struct elf_function *func = &functions[i];
> -		/*
> -		 * For vmlinux image both addrs[x] and functions[x]::addr
> -		 * values are final address and are comparable.
> -		 *
> -		 * For kernel module addrs[x] is final address, but
> -		 * functions[x]::addr is relative address within section
> -		 * and needs to be relocated by adding sh_addr.
> -		 */
> -		__u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> +
> +		if (i + 1 < functions_cnt)
> +			func->end = functions[i + 1].addr;
>  
>  		/* Make sure function is within ftrace addresses. */
> -		if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +		if (is_ftrace_func(func, addrs, count, kmod)) {
>  			/*
>  			 * We iterate over sorted array, so we can easily skip
>  			 * not valid item and move following valid field into
> @@ -303,6 +343,8 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  
>  	if (btf_elf__verbose)
>  		printf("Found %d functions!\n", functions_cnt);
> +
> +	qsort(functions, functions_cnt, sizeof(functions[0]), functions_cmp_name);
>  	return 0;
>  }
>  
> @@ -312,7 +354,7 @@ static struct elf_function *find_function(const struct btf_elf *btfe,
>  	struct elf_function key = { .name = name };
>  
>  	return bsearch(&key, functions, functions_cnt, sizeof(functions[0]),
> -		       functions_cmp);
> +		       functions_cmp_name);
>  }
>  
>  static bool btf_name_char_ok(char c, bool first)
> 
