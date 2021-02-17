Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BED3F31D9B1
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 13:45:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhBQMo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Feb 2021 07:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232657AbhBQMoy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Feb 2021 07:44:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA82564D92;
        Wed, 17 Feb 2021 12:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613565853;
        bh=j7WtDoQrJRmiGcT2hv6Y8c5vNqeHFKZrr3gfa88QxrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jY65C7UbX4VqydQSpz6fn8326LS1Ugvhe/50vJVYws/STBC5NGAQhVJ8Owd7wVTry
         +w3xsfXmqVrg3IZXltYFzvGp4mUvupVimBM52h1avjjhGGid4WG8hqEBmQhcpWJpoq
         IAGKgJ975+jvI1Y81PmfpVrEYqy5RiDAH0TrIA82pXQXv9d9+TFZ8mrevDeAYGWXKd
         wNrgCmeEsniC+5S6bt5bz4DdUe+O/0SPCbSkDSD0KhpBjg1y1z1PPOH235xB8IDGy+
         A/jd81LKW6vE7IloO9f35KUHquVEhpvnKfrnu8VLpUy0ByNnxgIyGtsQ4pk8FjHE+l
         xZFXIaKtZbGFw==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 28FC640CD9; Wed, 17 Feb 2021 09:44:10 -0300 (-03)
Date:   Wed, 17 Feb 2021 09:44:10 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [PATCHv2] btf_encoder: Match ftrace addresses within elf
 functions
Message-ID: <YC0Pmn0uwhHROsQd@kernel.org>
References: <20210213164648.1322182-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213164648.1322182-1-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, Feb 13, 2021 at 05:46:48PM +0100, Jiri Olsa escreveu:
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

Applied locally, will go out after tests,

- Arnaldo
 
> [1] https://lore.kernel.org/bpf/20210209034416.GA1669105@ubuntu-m3-large-x86/
> Acked-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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

-- 

- Arnaldo
