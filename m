Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5F31F184D
	for <lists+netdev@lfdr.de>; Mon,  8 Jun 2020 13:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729734AbgFHL4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 07:56:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:51664 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgFHL4c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 07:56:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9CACCAB8F;
        Mon,  8 Jun 2020 11:56:33 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id EF84260490; Mon,  8 Jun 2020 13:56:28 +0200 (CEST)
Date:   Mon, 8 Jun 2020 13:56:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     linux-kbuild@vger.kernel.org, bpf@vger.kernel.org,
        Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 04/16] net: bpfilter: use 'userprogs' syntax to build
 bpfilter_umh
Message-ID: <20200608115628.osizkpo76cgn2ci7@lion.mk-sys.cz>
References: <20200423073929.127521-1-masahiroy@kernel.org>
 <20200423073929.127521-5-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423073929.127521-5-masahiroy@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 04:39:17PM +0900, Masahiro Yamada wrote:
> The user mode helper should be compiled for the same architecture as
> the kernel.
> 
> This Makefile reuses the 'hostprogs' syntax by overriding HOSTCC with CC.
> 
> Now that Kbuild provides the syntax 'userprogs', use it to fix the
> Makefile mess.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Reported-by: kbuild test robot <lkp@intel.com>
> ---
> 
>  net/bpfilter/Makefile | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> index 36580301da70..6ee650c6badb 100644
> --- a/net/bpfilter/Makefile
> +++ b/net/bpfilter/Makefile
> @@ -3,17 +3,14 @@
>  # Makefile for the Linux BPFILTER layer.
>  #
>  
> -hostprogs := bpfilter_umh
> +userprogs := bpfilter_umh
>  bpfilter_umh-objs := main.o
> -KBUILD_HOSTCFLAGS += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
> -HOSTCC := $(CC)
> +user-ccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
>  
> -ifeq ($(CONFIG_BPFILTER_UMH), y)
> -# builtin bpfilter_umh should be compiled with -static
> +# builtin bpfilter_umh should be linked with -static
>  # since rootfs isn't mounted at the time of __init
>  # function is called and do_execv won't find elf interpreter
> -KBUILD_HOSTLDFLAGS += -static
> -endif
> +bpfilter_umh-ldflags += -static
>  
>  $(obj)/bpfilter_umh_blob.o: $(obj)/bpfilter_umh

Hello,

I just noticed that this patch (now in mainline as commit 8a2cc0505cc4)
drops the test if CONFIG_BPFILTER_UMH is "y" so that -static is now
passed to the linker even if bpfilter_umh is built as a module which
wasn't the case in v5.7.

This is not mentioned in the commit message and the comment still says
"*builtin* bpfilter_umh should be linked with -static" so this change
doesn't seem to be intentional. Did I miss something?

Michal Kubecek
