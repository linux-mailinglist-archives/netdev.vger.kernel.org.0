Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A72FD391D66
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 18:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhEZQ7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 12:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhEZQ7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 12:59:18 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5D9C061574;
        Wed, 26 May 2021 09:57:45 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id b13so3008266ybk.4;
        Wed, 26 May 2021 09:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Yn7CeyN/Ax4qJvbBhSE5jUn28BKN8kSjubNkFF568nQ=;
        b=sTorsW7KrcAcdCYVH6VQMmf7vhQWE32mD/kQag14vi7y8whdrQDp+Dyb7tRCa6dYI5
         rQQRl/v77MlFjRJYilDlp+pa72vrs4CXr1nejfmMSgnV5t6dhP11eL5tmE3zTdF7AQc6
         kgSy+jBByIRkFmKAFOFK4Rq7nz/OYFwHlt1DD9nFJAsJsIWWI5gLNQYac17Uh0ad06GU
         LhRIiMUoHURY4C8t2e512d3Mkbz0o6G3Y8JKRICp+F2uwrx/ESlDn1NhbOP5JQwmg0+D
         GBSILHlWEafw0LiUCuxL8q1Bw2r64W7FLP07bGMg0AAgavU6/Rjme8Pa7RxKZEBL16uw
         iuRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Yn7CeyN/Ax4qJvbBhSE5jUn28BKN8kSjubNkFF568nQ=;
        b=o0IyO0GqpTs8P3Bye+ZYIZ+VafnV2WWL+XAZAf35CURRg80/Kn/CaZAObrEOOdB9tN
         TxmPKQz64O8rPMZ/VVKCfYZRwiZzfL092FeL+C99JcH4kmRBCMgX7U7EQhLKGAi1O7IM
         5lqGEDuwKji76F/cwZG+mr+cqUXG0ZyorKn1O9fWDHUchVJtViYVLfp7EOteLbMqd7mb
         8ntdkvzchwIC6xltf+x21VlBV1jTP2HjmehG4fFSWPoTqR13TkxhUmrJEhVVV+ej141t
         gaQ/Hgr6dLbMwJqbNTvVF/Sams6SOUf6i3J2Ke0d/ObCAe5ZJXFwJun9pgKwIuvco9ZY
         jZQg==
X-Gm-Message-State: AOAM531/0QDcpbJyU+nSg1/RfuWyBVYq04n/+7FObZF+CWlSJa5SKzIt
        YD7lDTg61Lyr8emQQlePhMyZCm7vNUWzKEIweZ4=
X-Google-Smtp-Source: ABdhPJy6Q6f3StwP4SGWWhMW4RL0arKS1Bad/84pExe5B6bPazmqxMfeLxPtL3rn2Az4PGqnDSULHjthRW2k5a7Smqk=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr49756749ybg.459.1622048263017;
 Wed, 26 May 2021 09:57:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210526080741.GW30378@techsingularity.net>
In-Reply-To: <20210526080741.GW30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 26 May 2021 09:57:31 -0700
Message-ID: <CAEf4BzZOQnBgYXSR71HgsqhYcaFk5M5mre+6do+hnuxgWx5aNg@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>, bpf <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 1:07 AM Mel Gorman <mgorman@techsingularity.net> wr=
ote:
>
> Michal Suchanek reported the following problem with linux-next
>
>   [    0.000000] Linux version 5.13.0-rc2-next-20210519-1.g3455ff8-vanill=
a (geeko@buildhost) (gcc (SUSE Linux) 10.3.0, GNU ld (GNU Binutils; openSUS=
E Tumbleweed) 2.36.1.20210326-3) #1 SMP Wed May 19 10:05:10 UTC 2021 (3455f=
f8)
>   [    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next=
-20210519-1.g3455ff8-vanilla root=3DUUID=3Dec42c33e-a2c2-4c61-afcc-93e9527 =
8f687 plymouth.enable=3D0 resume=3D/dev/disk/by-uuid/f1fe4560-a801-4faf-a63=
8-834c407027c7 mitigations=3Dauto earlyprintk initcall_debug nomodeset earl=
ycon ignore_loglevel console=3DttyS0,115200
> ...
>   [   26.093364] calling  tracing_set_default_clock+0x0/0x62 @ 1
>   [   26.098937] initcall tracing_set_default_clock+0x0/0x62 returned 0 a=
fter 0 usecs
>   [   26.106330] calling  acpi_gpio_handle_deferred_request_irqs+0x0/0x7c=
 @ 1
>   [   26.113033] initcall acpi_gpio_handle_deferred_request_irqs+0x0/0x7c=
 returned 0 after 3 usecs
>   [   26.121559] calling  clk_disable_unused+0x0/0x102 @ 1
>   [   26.126620] initcall clk_disable_unused+0x0/0x102 returned 0 after 0=
 usecs
>   [   26.133491] calling  regulator_init_complete+0x0/0x25 @ 1
>   [   26.138890] initcall regulator_init_complete+0x0/0x25 returned 0 aft=
er 0 usecs
>   [   26.147816] Freeing unused decrypted memory: 2036K
>   [   26.153682] Freeing unused kernel image (initmem) memory: 2308K
>   [   26.165776] Write protecting the kernel read-only data: 26624k
>   [   26.173067] Freeing unused kernel image (text/rodata gap) memory: 20=
36K
>   [   26.180416] Freeing unused kernel image (rodata/data gap) memory: 11=
84K
>   [   26.187031] Run /init as init process
>   [   26.190693]   with arguments:
>   [   26.193661]     /init
>   [   26.195933]   with environment:
>   [   26.199079]     HOME=3D/
>   [   26.201444]     TERM=3Dlinux
>   [   26.204152]     BOOT_IMAGE=3D/boot/vmlinuz-5.13.0-rc2-next-20210519-=
1.g3455ff8-vanilla
>   [   26.254154] BPF:      type_id=3D35503 offset=3D178440 size=3D4
>   [   26.259125] BPF:
>   [   26.261054] BPF:Invalid offset
>   [   26.264119] BPF:
>   [   26.264119]
>   [   26.267437] failed to validate module [efivarfs] BTF: -22
>
> Andrii Nakryiko bisected the problem to the commit "mm/page_alloc: conver=
t
> per-cpu list protection to local_lock" currently staged in mmotm. In his
> own words
>
>   The immediate problem is two different definitions of numa_node per-cpu
>   variable. They both are at the same offset within .data..percpu ELF
>   section, they both have the same name, but one of them is marked as
>   static and another as global. And one is int variable, while another
>   is struct pagesets. I'll look some more tomorrow, but adding Jiri and
>   Arnaldo for visibility.
>
>   [110907] DATASEC '.data..percpu' size=3D178904 vlen=3D303
>   ...
>         type_id=3D27753 offset=3D163976 size=3D4 (VAR 'numa_node')
>         type_id=3D27754 offset=3D163976 size=3D4 (VAR 'numa_node')
>
>   [27753] VAR 'numa_node' type_id=3D27556, linkage=3Dstatic
>   [27754] VAR 'numa_node' type_id=3D20, linkage=3Dglobal
>
>   [20] INT 'int' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3DSIGNED
>
>   [27556] STRUCT 'pagesets' size=3D0 vlen=3D1
>         'lock' type_id=3D507 bits_offset=3D0
>
>   [506] STRUCT '(anon)' size=3D0 vlen=3D0
>   [507] TYPEDEF 'local_lock_t' type_id=3D506
>
> The patch in question introduces a zero-sized per-cpu struct and while
> this is not wrong, versions of pahole prior to 1.22 (unreleased) get
> confused during BTF generation with two separate variables occupying the
> same address.
>
> This patch checks for older versions of pahole and forces struct pagesets
> to be non-zero sized as a workaround when CONFIG_DEBUG_INFO_BTF is set. A
> warning is omitted so that distributions can update pahole when 1.22

s/omitted/emitted/ ?

> is released.
>
> Reported-by: Michal Suchanek <msuchanek@suse.de>
> Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---

Looks good! I verified that this does fix the issue on the latest
linux-next tree, thanks!

One question, should

Fixes: 5716a627517d ("mm/page_alloc: convert per-cpu list protection
to local_lock")

be added to facilitate backporting?

Either way:

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Andrii Nakryiko <andrii@kernel.org>

>  lib/Kconfig.debug |  3 +++
>  mm/page_alloc.c   | 11 +++++++++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 678c13967580..f88a155b80a9 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -313,6 +313,9 @@ config DEBUG_INFO_BTF
>  config PAHOLE_HAS_SPLIT_BTF
>         def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]=
+)\.([0-9]+)/\1\2/'` -ge "119")
>
> +config PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
> +       def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]=
+)\.([0-9]+)/\1\2/'` -ge "122")
> +
>  config DEBUG_INFO_BTF_MODULES
>         def_bool y
>         depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ff8f706839ea..1d56d3de8e08 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -124,6 +124,17 @@ static DEFINE_MUTEX(pcp_batch_high_lock);
>
>  struct pagesets {
>         local_lock_t lock;
> +#if defined(CONFIG_DEBUG_INFO_BTF) &&                  \
> +    !defined(CONFIG_DEBUG_LOCK_ALLOC) &&               \
> +    !defined(CONFIG_PAHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT)
> +       /*
> +        * pahole 1.21 and earlier gets confused by zero-sized per-CPU
> +        * variables and produces invalid BTF. Ensure that
> +        * sizeof(struct pagesets) !=3D 0 for older versions of pahole.
> +        */
> +       char __pahole_hack;
> +       #warning "pahole too old to support zero-sized struct pagesets"
> +#endif
>  };
>  static DEFINE_PER_CPU(struct pagesets, pagesets) =3D {
>         .lock =3D INIT_LOCAL_LOCK(lock),
