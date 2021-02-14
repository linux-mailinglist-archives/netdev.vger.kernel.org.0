Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A31E31AEC2
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 03:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBNCbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 21:31:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229713AbhBNCbb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Feb 2021 21:31:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E047464E4C;
        Sun, 14 Feb 2021 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613269850;
        bh=2PXUQYLG1xM67okQCRR7lPd88pelhekCZVO3xslW9fQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KZ0/tOiJgQG1T9kkCrE814r8jPeog+VWSDu48ITg6KwEFwRdPFe+jRy9knr1dH4jZ
         AdXZA2Ee11fUq08fWH7y9Dif4hkCYuZfL5w72y9nB2R+7w56o8LHWVPxKzpG6BaCAt
         6gPGlDN28T0UkBZ3ARJ1olLY8zQd9JjIeA5juo0qM11qUjFK9mYy0x+NsHsvNF53Db
         EUSiGglfmEOHhrwCwoRudvB4bdl+/hrh0naWh5zQu5r39BAL7Jez7X//OLHg6vlrSP
         DzaNQaCpQ28XDhdxBNc7vf44SoHvt53oGLr/YNgK72OYqiyh7XdCYqFctU9ds2PwO0
         TnQkNeJKocCyw==
Date:   Sat, 13 Feb 2021 19:30:48 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCHv2] btf_encoder: Match ftrace addresses within elf
 functions
Message-ID: <20210214023048.GA12132@24bbad8f3778>
References: <20210213164648.1322182-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213164648.1322182-1-jolsa@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 13, 2021 at 05:46:48PM +0100, Jiri Olsa wrote:
> Currently when processing DWARF function, we check its entrypoint
> against ftrace addresses, assuming that the ftrace address matches
> with function's entrypoint.
> 
> This is not the case on some architectures as reported by Nathan
> when building kernel on arm [1].
> 
> Fixing the check to take into account the whole function not
> just the entrypoint.
> 
> Most of the is_ftrace_func code was contributed by Andrii.
> 
> [1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>

I did several builds with CONFIG_DEBUG_INFO_BTF enabled (arm64, ppc64le,
and x86_64) and saw no build errors. I did not do any runtime testing.

Tested-by: Nathan Chancellor <nathan@kernel.org>

> ---
> v2 changes:
>   - update functions addr directly [Andrii]
> 
>  btf_encoder.c | 40 ++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/btf_encoder.c b/btf_encoder.c
> index b124ec20a689..80e896961d4e 100644
> --- a/btf_encoder.c
> +++ b/btf_encoder.c
> @@ -36,6 +36,7 @@ struct funcs_layout {
>  struct elf_function {
>  	const char	*name;
>  	unsigned long	 addr;
> +	unsigned long	 size;
>  	unsigned long	 sh_addr;
>  	bool		 generated;
>  };
> @@ -98,6 +99,7 @@ static int collect_function(struct btf_elf *btfe, GElf_Sym *sym,
>  
>  	functions[functions_cnt].name = name;
>  	functions[functions_cnt].addr = elf_sym__value(sym);
> +	functions[functions_cnt].size = elf_sym__size(sym);
>  	functions[functions_cnt].sh_addr = sh.sh_addr;
>  	functions[functions_cnt].generated = false;
>  	functions_cnt++;
> @@ -236,6 +238,39 @@ get_kmod_addrs(struct btf_elf *btfe, __u64 **paddrs, __u64 *pcount)
>  	return 0;
>  }
>  
> +static int is_ftrace_func(struct elf_function *func, __u64 *addrs, __u64 count)
> +{
> +	__u64 start = func->addr;
> +	__u64 addr, end = func->addr + func->size;
> +
> +	/*
> +	 * The invariant here is addr[r] that is the smallest address
> +	 * that is >= than function start addr. Except the corner case
> +	 * where there is no such r, but for that we have a final check
> +	 * in the return.
> +	 */
> +	size_t l = 0, r = count - 1, m;
> +
> +	/* make sure we don't use invalid r */
> +	if (count == 0)
> +		return false;
> +
> +	while (l < r) {
> +		m = l + (r - l) / 2;
> +		addr = addrs[m];
> +
> +		if (addr >= start) {
> +			/* we satisfy invariant, so tighten r */
> +			r = m;
> +		} else {
> +			/* m is not good enough as l, maybe m + 1 will be */
> +			l = m + 1;
> +		}
> +	}
> +
> +	return start <= addrs[r] && addrs[r] < end;
> +}
> +
>  static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  {
>  	__u64 *addrs, count, i;
> @@ -283,10 +318,11 @@ static int setup_functions(struct btf_elf *btfe, struct funcs_layout *fl)
>  		 * functions[x]::addr is relative address within section
>  		 * and needs to be relocated by adding sh_addr.
>  		 */
> -		__u64 addr = kmod ? func->addr + func->sh_addr : func->addr;
> +		if (kmod)
> +			func->addr += func->sh_addr;
>  
>  		/* Make sure function is within ftrace addresses. */
> -		if (bsearch(&addr, addrs, count, sizeof(addrs[0]), addrs_cmp)) {
> +		if (is_ftrace_func(func, addrs, count)) {
>  			/*
>  			 * We iterate over sorted array, so we can easily skip
>  			 * not valid item and move following valid field into
> -- 
> 2.29.2
> 
