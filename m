Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4B16393107
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 16:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233587AbhE0Oi7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 10:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233092AbhE0Oiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 10:38:52 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C9DCC061574;
        Thu, 27 May 2021 07:37:17 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id f9so976738ybo.6;
        Thu, 27 May 2021 07:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8MtJxbl4dS/jR4kzEF/nXxKmtEwc2fq75yeN0p0CuMY=;
        b=s+qoJWTessmaa9+xK/BaCAHgfhMf7MfdgR01atvZaDUhH4nJ7RVdFLGfheie5w+zSv
         8zHYuEYkqjx3Hx3xAv3Z2QkgbPVfjq1rEYC3YiA7r8gd66QcrOvdCzBUZUWRrJ0mAVPU
         Y2AheMcz2+JuCdae1Z0f9k8VDW1adYKFkeqiTEBM1I+Exur1dkg6rGRIacpw5up1fKpu
         MmzLVpuWqTRz1bK5RMc19Fb0V9agsaiEwaz5Ju6FJ+mLABBvHNPB3V29hqYI+2FELsbd
         7LO5lE18skSvOJxR3PHxcuBm2uc0pdyZhhU0jkzOMXxoguxzkeIMwJFRxRrSOg1NgCoL
         y5Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8MtJxbl4dS/jR4kzEF/nXxKmtEwc2fq75yeN0p0CuMY=;
        b=jnzN7AvfI72pgKOpsvAq3X/Mb+2vpLylW5xT+tHvepkkFsAltPqx6Hbf9iVDBeA+pw
         eqG1cSOppWT7eym854kdR/Xcf+BSjCOl5L4EQvFFuT5ymJINe4UUruSv+Ola28uTli+C
         astGbXfRThK7RqLSvfnIHnEVK2gnYXxv8z2JkmBM/pufNT87/hDbZAxFJGJIqa1eyO/J
         Yj9eL3q9IM43fTf0eaWY9FA4Xhz8CBSN6DNJa/m+9tx+7vZiXrnOntG4wq3NWqyKkD0V
         +B8K31Wr7fl3Lr/Pc7bKvk2ZfQwpFjygFSbt/QMHNyGiLHYjLATrssI8WrWAAIMq41RY
         JSuA==
X-Gm-Message-State: AOAM531QxQNdEwL37l+u1+3ABg02GiCewcLVTyLWFPPJOcsBZNHnzYnS
        oc/zfuTKuIkpx3CYEs4/ovWgCpTo1QeqpDXdEFI=
X-Google-Smtp-Source: ABdhPJz/OOHT6INTqfottp6gqNifOQMXHh+qXXciDS+h3xk4SCq3xRaOvjXyGJ0LjDP4CWtA+n/kV0lVsmVO7fWtlek=
X-Received: by 2002:a5b:286:: with SMTP id x6mr5539351ybl.347.1622126236610;
 Thu, 27 May 2021 07:37:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210527120251.GC30378@techsingularity.net>
In-Reply-To: <20210527120251.GC30378@techsingularity.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 27 May 2021 07:37:05 -0700
Message-ID: <CAEf4BzartMG36AGs-7LkQdpgrB6TYyTJ8PQhjkQWiTN=7sO1Bw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/page_alloc: Work around a pahole limitation with
 zero-sized struct pagesets
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Michal Suchanek <msuchanek@suse.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Hritik Vijay <hritikxx8@gmail.com>,
        Linux-BPF <bpf@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 27, 2021 at 5:02 AM Mel Gorman <mgorman@techsingularity.net> wr=
ote:
>
> This patch replaces
> mm-page_alloc-convert-per-cpu-list-protection-to-local_lock-fix.patch in
> Andrew's tree.
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
> This patch checks for older versions of pahole and only allows
> DEBUG_INFO_BTF_MODULES if pahole supports zero-sized per-cpu structures.
> DEBUG_INFO_BTF is still allowed as a KVM boot test passed with pahole

Unfortunately this won't work. The problem is that vmlinux BTF is
corrupted, which results in module BTFs to be rejected as well, as
they depend on it.

But vmlinux BTF corruption makes BPF subsystem completely unusable. So
even though kernel boots, nothing BPF-related works. So we'd need to
add dependency for DEBUG_INFO_BTF on pahole 1.22+.

> v1.19.  While pahole 1.22 does not exist yet, it is assumed that Hritik's
> fix that allows DEBUG_INFO_BTF_MODULES to work will be included in that
> release.
>
> Reported-by: Michal Suchanek <msuchanek@suse.de>
> Reported-by: Hritik Vijay <hritikxx8@gmail.com>
> Debugged-by: Andrii Nakryiko <andrii.nakryiko@gmail.com>
> Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
> ---
>  lib/Kconfig.debug | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 678c13967580..51b355cbe6d7 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -313,9 +313,12 @@ config DEBUG_INFO_BTF
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
> -       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF
> +       depends on DEBUG_INFO_BTF && MODULES && PAHOLE_HAS_SPLIT_BTF && P=
AHOLE_HAS_ZEROSIZE_PERCPU_SUPPORT
>         help
>           Generate compact split BTF type information for kernel modules.
>
