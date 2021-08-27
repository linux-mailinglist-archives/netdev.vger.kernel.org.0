Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8943F9827
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 12:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244899AbhH0KgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 06:36:25 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:48172 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233315AbhH0KgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 06:36:24 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 98878223A7;
        Fri, 27 Aug 2021 10:35:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630060534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=niAdtdRCe3YpJfeiYeUkcQkA9WVjzr/Y1St+dfHJ19g=;
        b=bGRUA8sCloiajoYtwpYGvw/NjZTUgRDhltqgbcujdXto30eUX+gl0W/qvwhHN8IG/C45jU
        jpKN1JCRoWw7cbLBBVmI/ronTH6QfJGJUWgi2yccDn1SvFt43IhhmvRB2DbaQFurgqq5z+
        xGlYXNYaJHOFnIhoWniEunm2AsUvUGg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630060534;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=niAdtdRCe3YpJfeiYeUkcQkA9WVjzr/Y1St+dfHJ19g=;
        b=j5RRjcIxfPmjkIqfqgKufe7b3Get8FCHVvITIft9iOIVkpWBk6xn5amNXep2SXguQ4yrlT
        KtNCmoplL7d1wZBQ==
Received: from kunlun.suse.cz (unknown [10.100.128.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 69FD7A3B94;
        Fri, 27 Aug 2021 10:35:34 +0000 (UTC)
Date:   Fri, 27 Aug 2021 12:35:33 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Patrick McCarty <patrick.mccarty@intel.com>
Subject: Re: [PATCH] libbpf: Fix build with latest gcc/binutils with LTO
Message-ID: <20210827103533.GF21630@kunlun.suse.cz>
References: <20210827072855.3664-1-msuchanek@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827072855.3664-1-msuchanek@suse.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this is a duplicate of

https://patchwork.kernel.org/project/netdevbpf/patch/20210827072539.3399-1-msuchanek@suse.de/

Sorry aboit the noise.

On Fri, Aug 27, 2021 at 09:28:55AM +0200, Michal Suchanek wrote:
> From: Patrick McCarty <patrick.mccarty@intel.com>
> 
> After updating to binutils 2.35, the build began to fail with an
> assembler error. A bug was opened on the Red Hat Bugzilla a few days
> later for the same issue.
> 
> Work around the problem by using the new `symver` attribute (introduced
> in GCC 10) as needed, instead of the `COMPAT_VERSION` and
> `DEFAULT_VERSION` macros, which expand to assembler directives.
> 
> Fixes: https://github.com/libbpf/libbpf/issues/338
> Fixes: https://bugzilla.redhat.com/show_bug.cgi?id=1863059
> Fixes: https://bugzilla.opensuse.org/show_bug.cgi?id=1188749
> Signed-off-by: Patrick McCarty <patrick.mccarty@intel.com>
> Make the change conditional on GCC version
> Signed-off-by: Michal Suchanek <msuchanek@suse.de>
> ---
>  tools/lib/bpf/libbpf_internal.h | 23 +++++++++++++++++------
>  tools/lib/bpf/xsk.c             |  4 ++--
>  2 files changed, 19 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
> index 016ca7cb4f8a..af0f3fb102c0 100644
> --- a/tools/lib/bpf/libbpf_internal.h
> +++ b/tools/lib/bpf/libbpf_internal.h
> @@ -86,20 +86,31 @@
>  	(offsetof(TYPE, FIELD) + sizeof(((TYPE *)0)->FIELD))
>  #endif
>  
> +#ifdef __GNUC__
> +# if __GNUC__ >= 10
> +#  define DEFAULT_VERSION(internal_name, api_name, version) \
> +__attribute__((__symver__(#api_name "@@" #version)))
> +#  define COMPAT_VERSION(internal_name, api_name, version) \
> +__attribute__((__symver__(#api_name "@" #version)))
> +# endif
> +#endif
> +
> +#if !defined(COMPAT_VERSION) || !defined(DEFAULT_VERSION)
>  /* Symbol versioning is different between static and shared library.
>   * Properly versioned symbols are needed for shared library, but
>   * only the symbol of the new version is needed for static library.
>   */
> -#ifdef SHARED
> -# define COMPAT_VERSION(internal_name, api_name, version) \
> +# ifdef SHARED
> +#  define COMPAT_VERSION(internal_name, api_name, version) \
>  	asm(".symver " #internal_name "," #api_name "@" #version);
> -# define DEFAULT_VERSION(internal_name, api_name, version) \
> +#  define DEFAULT_VERSION(internal_name, api_name, version) \
>  	asm(".symver " #internal_name "," #api_name "@@" #version);
> -#else
> -# define COMPAT_VERSION(internal_name, api_name, version)
> -# define DEFAULT_VERSION(internal_name, api_name, version) \
> +# else
> +#  define COMPAT_VERSION(internal_name, api_name, version)
> +#  define DEFAULT_VERSION(internal_name, api_name, version) \
>  	extern typeof(internal_name) api_name \
>  	__attribute__((alias(#internal_name)));
> +# endif
>  #endif
>  
>  extern void libbpf_print(enum libbpf_print_level level,
> diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> index e9b619aa0cdf..a2111696ba91 100644
> --- a/tools/lib/bpf/xsk.c
> +++ b/tools/lib/bpf/xsk.c
> @@ -281,6 +281,7 @@ static int xsk_create_umem_rings(struct xsk_umem *umem, int fd,
>  	return err;
>  }
>  
> +DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
>  int xsk_umem__create_v0_0_4(struct xsk_umem **umem_ptr, void *umem_area,
>  			    __u64 size, struct xsk_ring_prod *fill,
>  			    struct xsk_ring_cons *comp,
> @@ -345,6 +346,7 @@ struct xsk_umem_config_v1 {
>  	__u32 frame_headroom;
>  };
>  
> +COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
>  int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>  			    __u64 size, struct xsk_ring_prod *fill,
>  			    struct xsk_ring_cons *comp,
> @@ -358,8 +360,6 @@ int xsk_umem__create_v0_0_2(struct xsk_umem **umem_ptr, void *umem_area,
>  	return xsk_umem__create_v0_0_4(umem_ptr, umem_area, size, fill, comp,
>  					&config);
>  }
> -COMPAT_VERSION(xsk_umem__create_v0_0_2, xsk_umem__create, LIBBPF_0.0.2)
> -DEFAULT_VERSION(xsk_umem__create_v0_0_4, xsk_umem__create, LIBBPF_0.0.4)
>  
>  static enum xsk_prog get_xsk_prog(void)
>  {
> -- 
> 2.31.1
> 
