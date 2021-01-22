Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A25301026
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 23:41:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbhAVWjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 17:39:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:35772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728218AbhAVTqy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 14:46:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C42EB23AF8;
        Fri, 22 Jan 2021 19:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611344764;
        bh=LoPSxz6L3iDXqEs2jPt4YU+xS4K6WyCltNO2CZ1Vlec=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rBn7Eo1pVfpt5omsgk6bk0QegCBPnFUPyHKqQAaY7gN3h8oGrOdxpjwTTxOq5apYL
         UVgy3IbjR8vps8nvQ+Es6sJrvdVCHc7EvrWxGeurdvDIoO+M4mWMycAinePvHto1Oz
         rHP+w09VJb7QiE6m2h1dayTnAPqB77FBmsgy4QwKQQzstTykQvgv7Tht20FP1DVb+O
         ldQb/mc/q6HaVJXzAWnCnLH5lI4F7batCdOEj+ucsA7KkDd37jJMz+Tak40ZwVS0cY
         P3p0K2l1FX/rvCbQiUhVJ9r/z0Q275U41uwET1kIyUKER4U8ZRNmsoucoYMwAZE1YB
         DGS2BVX5Gb2mg==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 02F3E40513; Fri, 22 Jan 2021 16:45:59 -0300 (-03)
Date:   Fri, 22 Jan 2021 16:45:59 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, dwarves@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Yonghong Song <yhs@fb.com>, Hao Luo <haoluo@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH 1/2] elf_symtab: Add support for SHN_XINDEX index to
 elf_section_by_name
Message-ID: <20210122194559.GA617095@kernel.org>
References: <20210122163920.59177-1-jolsa@kernel.org>
 <20210122163920.59177-2-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122163920.59177-2-jolsa@kernel.org>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, Jan 22, 2021 at 05:39:19PM +0100, Jiri Olsa escreveu:
> In case the elf's header e_shstrndx contains SHN_XINDEX,
> we need to call elf_getshdrstrndx to get the proper
> string table index.

Applied, but changed the changelog comment to:

------------------------------------------------------------------
elf_symtab: Handle SHN_XINDEX index in elf_section_by_name()

Use elf_getshdrstrndx() to cover the case where the ELF header
'e_shstrndx' field contains the special value SHN_XINDEX so that we get
the proper string table index.

This is necessary to handle files with over 65536 sections, such as when
building the kernel with -f[function|data]-sections.  Other cases may
include when using FG-ASLR, LTO.

With so many sections, ELF is using extended section index table, which
is used to hold values for some of the indexes and extra code is needed
to retrieve them.
------------------------------------------------------------------

This is from the thread, so that we can have a more comprehensive idea
of what is this SHN_XINDEX and where it can show up when looking at this
code 10 years from now (or next month) :-)

Holler if I've messed up something.

Thanks,

- Arnaldo
 
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  dutil.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/dutil.c b/dutil.c
> index 7b667647420f..11fb7202049c 100644
> --- a/dutil.c
> +++ b/dutil.c
> @@ -179,12 +179,18 @@ Elf_Scn *elf_section_by_name(Elf *elf, GElf_Ehdr *ep,
>  {
>  	Elf_Scn *sec = NULL;
>  	size_t cnt = 1;
> +	size_t str_idx;
> +
> +	if (elf_getshdrstrndx(elf, &str_idx))
> +		return NULL;
>  
>  	while ((sec = elf_nextscn(elf, sec)) != NULL) {
>  		char *str;
>  
>  		gelf_getshdr(sec, shp);
> -		str = elf_strptr(elf, ep->e_shstrndx, shp->sh_name);
> +		str = elf_strptr(elf, str_idx, shp->sh_name);
> +		if (!str)
> +			return NULL;
>  		if (!strcmp(name, str)) {
>  			if (index)
>  				*index = cnt;
> -- 
> 2.26.2
> 

-- 

- Arnaldo
