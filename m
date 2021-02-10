Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C936316D20
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 18:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhBJRpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 12:45:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:48786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232775AbhBJRpi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 12:45:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F74964E7A;
        Wed, 10 Feb 2021 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612979093;
        bh=01pStANs1to4xQWD5/x31z4La1/1W4IHPj6IcnswEqo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZuRPF5cCwEX3+19MJQBEuaUebD7qgpcAL7s4Hu2XBxd2mKRyUmxb554D83yGmo6Vy
         tWYvjRtyo7Td4xSnVV7C4J3Jxv9KbCNUx/5YUhgep37ib+wCX9YSSk30m0dyDDSkMw
         PGOZbLC/VHQ70kz0iGKf8kjGaKp4pI2AlrU6gsFPm8DZ1Z2zYh0eAxGDpNMcOZLVdJ
         rnNfzFJzqD+iIoT4S8oG8gcpJAPw9TJrCoW8vkI+4taJt3x3tgcveKYqtabftX07WS
         hd8nc0Hc6sQuNBqWx7vEJMdfAz3rtBaNkyHGL7w9gJ9aISzwMOg89t538h9eLHQ/iv
         PlmOYdO5HgQ2g==
Date:   Wed, 10 Feb 2021 10:44:51 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH bpf-next 4/4] kbuild: Add resolve_btfids clean to root
 clean target
Message-ID: <20210210174451.GA1943051@ubuntu-m3-large-x86>
References: <20210205124020.683286-1-jolsa@kernel.org>
 <20210205124020.683286-5-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210205124020.683286-5-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 05, 2021 at 01:40:20PM +0100, Jiri Olsa wrote:
> The resolve_btfids tool is used during the kernel build,
> so we should clean it on kernel's make clean.
> 
> Invoking the the resolve_btfids clean as part of root
> 'make clean'.
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  Makefile | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index b0e4767735dc..159d9592b587 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1086,6 +1086,11 @@ ifdef CONFIG_STACK_VALIDATION
>    endif
>  endif
>  
> +PHONY += resolve_btfids_clean
> +
> +resolve_btfids_clean:
> +	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(abspath $(objtree))/tools/bpf/resolve_btfids clean
> +
>  ifdef CONFIG_BPF
>  ifdef CONFIG_DEBUG_INFO_BTF
>    ifeq ($(has_libelf),1)
> @@ -1495,7 +1500,7 @@ vmlinuxclean:
>  	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
>  	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
>  
> -clean: archclean vmlinuxclean
> +clean: archclean vmlinuxclean resolve_btfids_clean
>  
>  # mrproper - Delete all generated files, including .config
>  #
> -- 
> 2.26.2
> 

This breaks running distclean on a clean tree (my script just
unconditionally runs distclean regardless of the tree state):

$ make -s O=build distclean
../../scripts/Makefile.include:4: *** O=/home/nathan/cbl/src/linux-next/build/tools/bpf/resolve_btfids does not exist.  Stop.

Cheers,
Nathan
