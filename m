Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9588A1B5EE9
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 17:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729081AbgDWPQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 11:16:31 -0400
Received: from conssluserg-03.nifty.com ([210.131.2.82]:55307 "EHLO
        conssluserg-03.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgDWPQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 11:16:30 -0400
Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 03NFFnuG003464;
        Fri, 24 Apr 2020 00:15:50 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 03NFFnuG003464
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1587654950;
        bh=JIgpTCwvImM/7c3SgxFwgMS59DmVqHtEAWWh3ROG+Gc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=SRdn3NqYbRcLP87XmAw1+nOFq5nscaSfasoENACzdwLaQq9MzultJjcJIaGPkbD56
         uGy/Wgm5AVB+gqGFBICMrjG563VkkgEsYBEncaKu+jCYgyS6zT4ILuqIkNoEHljCUs
         79854k3qpssyOREzW/RiXGSR1CsMQ8BtlAnoglJ98AkYZqQAjvx2nbjoXofeM5YgUJ
         xRJAo01SP3QPTRqn3msGnk7roz3bhlqmaIw/9Nb7Cp0z+rmEAI1VTMWr87Rp5ot7O9
         TWTbtw6TOyMJ8Su9F048rWjIV+5gmCUWJNDYpQ4LKTo+y1DOSpRLE5o8l0CBxuE5VC
         Sx8rQndUGjktA==
X-Nifty-SrcIP: [209.85.222.51]
Received: by mail-ua1-f51.google.com with SMTP id g10so6027207uae.5;
        Thu, 23 Apr 2020 08:15:50 -0700 (PDT)
X-Gm-Message-State: AGi0Pua02bu2589bUueMaZFCQm+5SwtsAgtXApm3mVIt8pkFQLi1sbhI
        wGPBwSmxhTbQJgBkvuxKCxwjEAwmtSlw8FIqtZE=
X-Google-Smtp-Source: APiQypJx5+++PBEd7BfwDp7BnFNQeoY/8MBP53JiljBGqJhpXq2fFSOAaSuejQ4XUBcBnTcF+eFJYIMaOVaiQeS9BH0=
X-Received: by 2002:ab0:2e84:: with SMTP id f4mr3597611uaa.121.1587654949095;
 Thu, 23 Apr 2020 08:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200423073929.127521-1-masahiroy@kernel.org> <20200423073929.127521-4-masahiroy@kernel.org>
In-Reply-To: <20200423073929.127521-4-masahiroy@kernel.org>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Fri, 24 Apr 2020 00:15:12 +0900
X-Gmail-Original-Message-ID: <CAK7LNASpLsw5SUasmpwQ++yyXJi714HDOfEo4=O5SywwYQxtQA@mail.gmail.com>
Message-ID: <CAK7LNASpLsw5SUasmpwQ++yyXJi714HDOfEo4=O5SywwYQxtQA@mail.gmail.com>
Subject: Re: [PATCH 03/16] kbuild: add infrastructure to build userspace programs
To:     Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 23, 2020 at 4:40 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
>
> Kbuild supports the infrastructure to build host programs, but there
> was no support to build userspace programs for the target architecture
> (i.e. the same architecture as the kernel).
>
> Sam Ravnborg worked on this a long time ago.
>
>   https://lkml.org/lkml/2014/7/13/154
>
> But, it was not merged. One problem at that time was, there was no
> good way to know whether $(CC) can link standalone programs. In fact,
> pre-built kernel.org toolchains [1] do not provide libc.
>
> Now, we can handle this cleanly because the compiler capability is
> evaluated at the Kconfig time. If $(CC) cannot link standalone programs,
> the relevant options are hidden by 'depends on CC_CAN_LINK'.
>
> The implementation just mimics scripts/Makefile.host
>
> The userspace programs are compiled with the same flags as the host
> programs. In addition, it uses -m32 or -m64 if it is found in
> $(KBUILD_CFLAGS).
>
> This new syntax has at least two usecases.
>
> - Sample programs
>
>   Several userspace programs under samples/ include UAPI headers
>   installed in usr/include. Most of them were previously built for
>   the host architecture just to use 'hostprogs' syntax.
>
>   However, 'make headers' always works for the target architecture.
>   This caused the arch mismatch in cross-compiling. To fix this
>   distortion, sample code should be built for the target architecture.
>
> - Bpfilter
>
>   net/bpfilter/Makefile compiles bpfilter_umh as the user mode helper,
>   and embeds it into the kernel code. Currently, it overrides HOSTCC
>   with CC to use the 'hostprogs' syntax. This hack should go away.
>
> [1]: https://mirrors.edge.kernel.org/pub/tools/crosstool/
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> ---
>
>  Makefile                   | 11 +++++++---
>  scripts/Makefile.build     |  5 +++++
>  scripts/Makefile.clean     |  2 +-
>  scripts/Makefile.userprogs | 44 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 58 insertions(+), 4 deletions(-)
>  create mode 100644 scripts/Makefile.userprogs
>
> diff --git a/Makefile b/Makefile
> index 49b2709ff44e..f20597820131 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -406,9 +406,11 @@ else
>  HOSTCC = gcc
>  HOSTCXX        = g++
>  endif
> -KBUILD_HOSTCFLAGS   := -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 \
> -               -fomit-frame-pointer -std=gnu89 $(HOST_LFS_CFLAGS) \
> -               $(HOSTCFLAGS)
> +
> +export KBUILD_USERCFLAGS := -Wall -Wmissing-prototypes -Wstrict-prototypes \
> +                             -O2 -fomit-frame-pointer -std=gnu89
> +
> +KBUILD_HOSTCFLAGS   := $(KBUILD_USERCFLAGS) $(HOST_LFS_CFLAGS) $(HOSTCFLAGS)
>  KBUILD_HOSTCXXFLAGS := -Wall -O2 $(HOST_LFS_CFLAGS) $(HOSTCXXFLAGS)
>  KBUILD_HOSTLDFLAGS  := $(HOST_LFS_LDFLAGS) $(HOSTLDFLAGS)
>  KBUILD_HOSTLDLIBS   := $(HOST_LFS_LIBS) $(HOSTLDLIBS)
> @@ -937,6 +939,9 @@ ifeq ($(CONFIG_RELR),y)
>  LDFLAGS_vmlinux        += --pack-dyn-relocs=relr
>  endif
>
> +# Align the bit size of userspace programs with the kernel
> +KBUILD_USERCFLAGS += $(filter -m32 -m64, $(KBUILD_CFLAGS))
> +
>  # make the checker run with the right architecture
>  CHECKFLAGS += --arch=$(ARCH)
>
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 9fcbfac15d1d..94f2f7016172 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -50,6 +50,11 @@ ifneq ($(hostprogs)$(hostcxxlibs-y)$(hostcxxlibs-m),)
>  include scripts/Makefile.host
>  endif
>
> +# Do not include userprogs rules unless needed
> +ifneq ($(userprogs),)
> +include scripts/Makefile.userprogs
> +endif
> +
>  ifndef obj
>  $(warning kbuild: Makefile.build is included improperly)
>  endif
> diff --git a/scripts/Makefile.clean b/scripts/Makefile.clean
> index 075f0cc2d8d7..e2c76122319d 100644
> --- a/scripts/Makefile.clean
> +++ b/scripts/Makefile.clean
> @@ -29,7 +29,7 @@ subdir-ymn    := $(addprefix $(obj)/,$(subdir-ymn))
>
>  __clean-files  := $(extra-y) $(extra-m) $(extra-)       \
>                    $(always) $(always-y) $(always-m) $(always-) $(targets) $(clean-files)   \
> -                  $(hostprogs) $(hostprogs-y) $(hostprogs-m) $(hostprogs-) \
> +                  $(hostprogs) $(hostprogs-y) $(hostprogs-m) $(hostprogs-) $(userprogs) \
>                    $(hostcxxlibs-y) $(hostcxxlibs-m)
>
>  __clean-files   := $(filter-out $(no-clean-files), $(__clean-files))
> diff --git a/scripts/Makefile.userprogs b/scripts/Makefile.userprogs
> new file mode 100644
> index 000000000000..0d987085819b
> --- /dev/null
> +++ b/scripts/Makefile.userprogs
> @@ -0,0 +1,44 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Build userspace programs for the target system
> +#
> +
> +userprogs      := $(sort $(userprogs))
> +
> +# Executables compiled from a single .c file
> +user-csingle   := $(foreach m, $(userprogs), $(if $($(m)-objs),,$(m)))
> +
> +# C executables linked based on several .o files
> +user-cmulti    := $(foreach m, $(userprogs), $(if $($(m)-objs),$(m)))
> +
> +# Object (.o) files compiled from .c files
> +user-cobjs     := $(foreach m, $(userprogs), $($(m)-objs))
> +
> +user-csingle   := $(addprefix $(obj)/, $(user-csingle))
> +user-cmulti    := $(addprefix $(obj)/, $(user-cmulti))
> +user-cobjs     := $(addprefix $(obj)/, $(user-cobjs))
> +
> +user_c_flags   = -Wp,-MMD,$(depfile) $(KBUILD_USERCFLAGS) $(user-ccflags) \
> +                       $($(target-stem)-ccflags)
> +
> +# Create an executable from a single .c file
> +quiet_cmd_user_cc_c = CC [U]  $@
> +      cmd_user_cc_c = $(CC) $(user_c_flags) -o $@ $<


                  $($(target-stem)-ldlibs)

is needed here too.



> +$(user-csingle): $(obj)/%: $(src)/%.c FORCE
> +       $(call if_changed_dep,user_cc_c)
> +
> +# Link an executable based on list of .o files
> +quiet_cmd_user_ld = LD [U]  $@
> +      cmd_user_ld = $(CC) -o $@ $(addprefix $(obj)/, $($(target-stem)-objs)) \
> +                      $($(target-stem)-ldlibs)
> +$(user-cmulti): FORCE
> +       $(call if_changed,user_ld)
> +$(call multi_depend, $(user-cmulti), , -objs)
> +
> +# Create .o file from a .c file
> +quiet_cmd_user_cc_o_c = CC [U]  $@
> +      cmd_user_cc_o_c = $(CC) $(user_c_flags) -c -o $@ $<
> +$(user-cobjs): $(obj)/%.o: $(src)/%.c FORCE
> +       $(call if_changed_dep,user_cc_o_c)
> +
> +targets += $(user-csingle) $(user-cmulti) $(user-cobjs)
> --
> 2.25.1
>


-- 
Best Regards
Masahiro Yamada
