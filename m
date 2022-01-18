Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD334929BD
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 16:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345842AbiARPfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 10:35:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238270AbiARPfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 10:35:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4929EC061574;
        Tue, 18 Jan 2022 07:35:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBB9D608C0;
        Tue, 18 Jan 2022 15:35:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B3C8C00446;
        Tue, 18 Jan 2022 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642520131;
        bh=llO38vHsuSCs/rDP/NVCD+ResUy3xRA+7B4nJRSjHKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ENapVa8duZZ9RUNv1L9BsTosnjY64d7IAncJpI44qfURpRxPkm3OKr8X9Xixd4p77
         kK3nsAIoh0eD9ah3yiYQ5SCMTbYvpfj6o+yxMRIhjm2mEFs6F8DcrHj5Nb1rVNRqJ6
         8wvZfbJJaSOcEkYzEmk/JnHZgFqKECP18EbncXY7dUN/YdL6Q4/hwVuZHWb+r7hd3h
         zEvJwj/AatKHtjgwiNRpJHTBTXG+GwD1/7EEFw+SYtWAr5WE+87PpjXKcDDhsay9Rv
         O3M4voHXGGctluTSNPHuHl0GlEZSRQ08xHSB8tbF97uy3HQsF2G+0PEAN79VbRXu5e
         s+A/m6D5WRFlA==
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 5A00F40714; Tue, 18 Jan 2022 12:35:28 -0300 (-03)
Date:   Tue, 18 Jan 2022 12:35:28 -0300
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf] libbpf: define BTF_KIND_* constants in btf.h to
 avoid compilation errors
Message-ID: <YebeQKsIDDaBMtpW@kernel.org>
References: <20220118141327.34231-1-toke@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220118141327.34231-1-toke@redhat.com>
X-Url:  http://acmel.wordpress.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, Jan 18, 2022 at 03:13:27PM +0100, Toke Høiland-Jørgensen escreveu:
> The btf.h header included with libbpf contains inline helper functions to
> check for various BTF kinds. These helpers directly reference the
> BTF_KIND_* constants defined in the kernel header, and because the header
> file is included in user applications, this happens in the user application
> compile units.
> 
> This presents a problem if a user application is compiled on a system with
> older kernel headers because the constants are not available. To avoid
> this, add #defines of the constants directly in btf.h before using them.
> 
> Since the kernel header moved to an enum for BTF_KIND_*, the #defines can
> shadow the enum values without any errors, so we only need #ifndef guards
> for the constants that predates the conversion to enum. We group these so
> there's only one guard for groups of values that were added together.
> 
>   [0] Closes: https://github.com/libbpf/libbpf/issues/436

The coexistence of enums with the defines (in turn #ifndef guarded) as
something I hadn't considered, clever.

Should fix lots of build errors in my test containers :-)

FWIW:

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>
 
> Fixes: 223f903e9c83 ("bpf: Rename BTF_KIND_TAG to BTF_KIND_DECL_TAG")
> Fixes: 5b84bd10363e ("libbpf: Add support for BTF_KIND_TAG")
> Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/btf.h | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index 061839f04525..51862fdee850 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -375,8 +375,28 @@ btf_dump__dump_type_data(struct btf_dump *d, __u32 id,
>  			 const struct btf_dump_type_data_opts *opts);
>  
>  /*
> - * A set of helpers for easier BTF types handling
> + * A set of helpers for easier BTF types handling.
> + *
> + * The inline functions below rely on constants from the kernel headers which
> + * may not be available for applications including this header file. To avoid
> + * compilation errors, we define all the constants here that were added after
> + * the initial introduction of the BTF_KIND* constants.
>   */
> +#ifndef BTF_KIND_FUNC
> +#define BTF_KIND_FUNC		12	/* Function	*/
> +#define BTF_KIND_FUNC_PROTO	13	/* Function Proto	*/
> +#endif
> +#ifndef BTF_KIND_VAR
> +#define BTF_KIND_VAR		14	/* Variable	*/
> +#define BTF_KIND_DATASEC	15	/* Section	*/
> +#endif
> +#ifndef BTF_KIND_FLOAT
> +#define BTF_KIND_FLOAT		16	/* Floating point	*/
> +#endif
> +/* The kernel header switched to enums, so these two were never #defined */
> +#define BTF_KIND_DECL_TAG	17	/* Decl Tag */
> +#define BTF_KIND_TYPE_TAG	18	/* Type Tag */
> +
>  static inline __u16 btf_kind(const struct btf_type *t)
>  {
>  	return BTF_INFO_KIND(t->info);
> -- 
> 2.34.1

-- 

- Arnaldo
