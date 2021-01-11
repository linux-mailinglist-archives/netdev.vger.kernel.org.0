Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD302F1F33
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 20:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403826AbhAKTU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 14:20:58 -0500
Received: from conssluserg-01.nifty.com ([210.131.2.80]:63858 "EHLO
        conssluserg-01.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403793AbhAKTU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 14:20:57 -0500
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181]) (authenticated)
        by conssluserg-01.nifty.com with ESMTP id 10BJJcUA008023;
        Tue, 12 Jan 2021 04:19:39 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-01.nifty.com 10BJJcUA008023
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1610392779;
        bh=pHi7+gSVpF90pPM2Xy2bn15uah7SVIhPfi3n/QhRCHU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=njSIvSgoXx2FlpZ0es+iD3fdlv1FktyD02kl0QVCAUPHvh+sUf7L2ytXBu2BODRh+
         7b1QUp6fO4KxiiaqJCtlv/qdJCFvi7ByBlqRDVt5oS8sTDIC73wb4i4I1uRRpjWSeO
         BlEaU9PeyxkiBQLd+qlDxIUeiDDscoK5x7l8RZnXsziUXS2Y20EW8xffGxngkzVYfM
         tUUA85Nz5jIYFGR2naHwbq9LeivdDmJtDFtsqpEEGntfUabR2U0cKMIf2B8AbDNhph
         IOqhUWVgES4GGtVe8W5rQBTfh4YYOZrn/XDd5lVsZklJdqeBbzYlNgllBCW9TYfV6c
         ub2tLhEJ0GaMA==
X-Nifty-SrcIP: [209.85.215.181]
Received: by mail-pg1-f181.google.com with SMTP id n25so318933pgb.0;
        Mon, 11 Jan 2021 11:19:39 -0800 (PST)
X-Gm-Message-State: AOAM530nvfkWDPIyZNGBbjm/I1FjtYsv8u0qDFQLIJJMQvbeuqbTP6lE
        XNKX6jODCdEUrBIPEx9zdSc6tnUIw83B8viFIac=
X-Google-Smtp-Source: ABdhPJyHve2ypA5A/3j7Cbj69rESnHlsh67r6wNIthvsGunuG3cOn2kBOg29azHfFBCYkcV8U5W9PhEZZxfOpMpdB+E=
X-Received: by 2002:a63:1f1d:: with SMTP id f29mr988794pgf.47.1610392778340;
 Mon, 11 Jan 2021 11:19:38 -0800 (PST)
MIME-Version: 1.0
References: <20210111180609.713998-1-natechancellor@gmail.com>
In-Reply-To: <20210111180609.713998-1-natechancellor@gmail.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 12 Jan 2021 04:19:01 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
Message-ID: <CAK7LNAQ=38BUi-EG5v2UiuAF-BOsVe5BTd-=jVYHHHPD7ikS5A@mail.gmail.com>
Subject: Re: [PATCH] bpf: Hoise pahole version checks into Kconfig
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Michal Marek <michal.lkml@markovi.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Sedat Dilek <sedat.dilek@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 3:06 AM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> After commit da5fb18225b4 ("bpf: Support pre-2.25-binutils objcopy for
> vmlinux BTF"), having CONFIG_DEBUG_INFO_BTF enabled but lacking a valid
> copy of pahole results in a kernel that will fully compile but fail to
> link. The user then has to either install pahole or disable
> CONFIG_DEBUG_INFO_BTF and rebuild the kernel but only after their build
> has failed, which could have been a significant amount of time depending
> on the hardware.
>
> Avoid a poor user experience and require pahole to be installed with an
> appropriate version to select and use CONFIG_DEBUG_INFO_BTF, which is
> standard for options that require a specific tools version.
>
> Suggested-by: Sedat Dilek <sedat.dilek@gmail.com>
> Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>



I am not sure if this is the right direction.


I used to believe moving any tool test to the Kconfig
was the right thing to do.

For example, I tried to move the libelf test to Kconfig,
and make STACK_VALIDATION depend on it.

https://patchwork.kernel.org/project/linux-kbuild/patch/1531186516-15764-1-git-send-email-yamada.masahiro@socionext.com/

It was rejected.


In my understanding, it is good to test target toolchains
in Kconfig (e.g. cc-option, ld-option, etc).

As for host tools, in contrast, it is better to _intentionally_
break the build in order to let users know that something needed is missing.
Then, they will install necessary tools or libraries.
It is just a one-time setup, in most cases,
just running 'apt install' or 'dnf install'.



Recently, a similar thing happened to GCC_PLUGINS
https://patchwork.kernel.org/project/linux-kbuild/patch/20201203125700.161354-1-masahiroy@kernel.org/#23855673




Following this pattern, if a new pahole is not installed,
it might be better to break the build instead of hiding
the CONFIG option.

In my case, it is just a matter of 'apt install pahole'.
On some distributions, the bundled pahole is not new enough,
and people may end up with building pahole from the source code.





> ---
>  MAINTAINERS               |  1 +
>  init/Kconfig              |  4 ++++
>  lib/Kconfig.debug         |  6 ++----
>  scripts/link-vmlinux.sh   | 13 -------------
>  scripts/pahole-version.sh | 16 ++++++++++++++++
>  5 files changed, 23 insertions(+), 17 deletions(-)
>  create mode 100755 scripts/pahole-version.sh
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b8db7637263a..6f6e24285a94 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3282,6 +3282,7 @@ F:        net/core/filter.c
>  F:     net/sched/act_bpf.c
>  F:     net/sched/cls_bpf.c
>  F:     samples/bpf/
> +F:     scripts/pahole-version.sh
>  F:     tools/bpf/
>  F:     tools/lib/bpf/
>  F:     tools/testing/selftests/bpf/
> diff --git a/init/Kconfig b/init/Kconfig
> index b77c60f8b963..872c61b5d204 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -74,6 +74,10 @@ config TOOLS_SUPPORT_RELR
>  config CC_HAS_ASM_INLINE
>         def_bool $(success,echo 'void foo(void) { asm inline (""); }' | $(CC) -x c - -c -o /dev/null)
>
> +config PAHOLE_VERSION
> +       int
> +       default $(shell,$(srctree)/scripts/pahole-version.sh $(PAHOLE))
> +
>  config CONSTRUCTORS
>         bool
>         depends on !UML
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 7937265ef879..70c446af9664 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -267,6 +267,7 @@ config DEBUG_INFO_DWARF4
>
>  config DEBUG_INFO_BTF
>         bool "Generate BTF typeinfo"
> +       depends on PAHOLE_VERSION >= 116
>         depends on !DEBUG_INFO_SPLIT && !DEBUG_INFO_REDUCED
>         depends on !GCC_PLUGIN_RANDSTRUCT || COMPILE_TEST
>         help
> @@ -274,12 +275,9 @@ config DEBUG_INFO_BTF
>           Turning this on expects presence of pahole tool, which will convert
>           DWARF type info into equivalent deduplicated BTF type info.
>
> -config PAHOLE_HAS_SPLIT_BTF
> -       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
> -
>  config DEBUG_INFO_BTF_MODULES
>         def_bool y
> -       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> +       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_VERSION >= 119
>         help
>           Generate compact split BTF type information for kernel modules.
>
> diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
> index 6eded325c837..eef40fa9485d 100755
> --- a/scripts/link-vmlinux.sh
> +++ b/scripts/link-vmlinux.sh
> @@ -139,19 +139,6 @@ vmlinux_link()
>  # ${2} - file to dump raw BTF data into
>  gen_btf()
>  {
> -       local pahole_ver
> -
> -       if ! [ -x "$(command -v ${PAHOLE})" ]; then
> -               echo >&2 "BTF: ${1}: pahole (${PAHOLE}) is not available"
> -               return 1
> -       fi
> -
> -       pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> -       if [ "${pahole_ver}" -lt "116" ]; then
> -               echo >&2 "BTF: ${1}: pahole version $(${PAHOLE} --version) is too old, need at least v1.16"
> -               return 1
> -       fi
> -
>         vmlinux_link ${1}
>
>         info "BTF" ${2}
> diff --git a/scripts/pahole-version.sh b/scripts/pahole-version.sh
> new file mode 100755
> index 000000000000..6de6f734a345
> --- /dev/null
> +++ b/scripts/pahole-version.sh
> @@ -0,0 +1,16 @@
> +#!/bin/sh
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Usage: $ ./scripts/pahole-version.sh pahole
> +#
> +# Print the pahole version as a three digit string
> +# such as `119' for pahole v1.19 etc.
> +
> +pahole="$*"
> +
> +if ! [ -x "$(command -v $pahole)" ]; then
> +    echo 0
> +    exit 1
> +fi
> +
> +$pahole --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'
>
> base-commit: e22d7f05e445165e58feddb4e40cc9c0f94453bc
> --
> 2.30.0
>


-- 
Best Regards
Masahiro Yamada
