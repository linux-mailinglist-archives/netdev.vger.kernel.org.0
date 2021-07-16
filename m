Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86B2B3CBDEC
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhGPUrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 16:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhGPUrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 16:47:02 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF39C06175F;
        Fri, 16 Jul 2021 13:44:06 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id g5so16866798ybu.10;
        Fri, 16 Jul 2021 13:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q2gswAbNH1obxNTNlaEj+a8poBJQn9ocu7cMCkTxcXc=;
        b=VcxqbuO13iNjgtwhVwNvkefz+rQVovI+bp61MiQyK5nLd9PTReE5ZtM4/4nbgkXg+V
         EBaMpztGPenFBXKKe28j4WVe3qKwSVJgFySmnFs7JVBrIvVCnaciHSOKC86Mutw0L0QB
         h7BNu2w1TJlGdah3mZCvWg/pFKdvp1WxEqX3gUjTkzKp9PSaoaMgZ4JuPM1nlPs9SzRA
         KwAcvRFJcIEIcWXtE1PlSfpJy29XvaXQFU0VHR2PhvMuNS3gdC03H7acFzXpGlPkWOVN
         HIwW5lxM6RcaEOo0Lx4gSdIxNEAI2uRq1GN12YbjskJDNz40P1pGguq6EP/JbSaZxBHx
         zhXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=q2gswAbNH1obxNTNlaEj+a8poBJQn9ocu7cMCkTxcXc=;
        b=RoE4BsKzy76tZX/HxzdGwkgfbHrE9znlkmpR9jJHGNQcDPlt/sUTeMp5hqM0CaD6yy
         TujV9Fw1B1SpGEkqupCbnOwYduPvUXXCPruO8c0rMxq+m3m0DKGlGCsc4+n5/WC/B8oK
         7+g2tytw/bVZla5heiKsHoImQFnh/UT2YJ9HA1RLvVXE7TuLdy9FCH0osZl8kT/otKAc
         M6Dic+o65GwkVnTR3i3AYVADfhOr3PwKKLYw5zS7mcsmchRgaZxTbzNTTPhvjn4cFUqV
         Lpy/TAzVNH1l/4970HUNYAcJ7/DaZis7dYaUos8OnXQmNvGpXQOXOPb2x6/SK2p6vh6B
         j33Q==
X-Gm-Message-State: AOAM531Y5haCr/mb5gN/EZqVGlqEjVX8JB2wI9zJ1hpEpymXzUkxNPFM
        hfxy0RG3DUcMd/uxVrxVHI80G4OLzgdcNl4GqtI=
X-Google-Smtp-Source: ABdhPJzq/D0ABJ7rYDRGP6M1PpYDxPBU31zy86XSOPqyhA+HidsNy4qgnJpA+U/0CN3H5WWhDKM40k1OyQUp+AHnzt0=
X-Received: by 2002:a25:b203:: with SMTP id i3mr15248038ybj.260.1626468246223;
 Fri, 16 Jul 2021 13:44:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210716100452.113652-1-lmb@cloudflare.com>
In-Reply-To: <20210716100452.113652-1-lmb@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 16 Jul 2021 13:43:55 -0700
Message-ID: <CAEf4BzauzWhNag0z31krN_MTZTGLynAJvkh_7P3yLQCx5XLTAg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix OOB read when printing XDP link fdinfo
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        kernel-team <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 3:05 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
>
> We got the following UBSAN report on one of our testing machines:
>
>     ================================================================================
>     UBSAN: array-index-out-of-bounds in kernel/bpf/syscall.c:2389:24
>     index 6 is out of range for type 'char *[6]'
>     CPU: 43 PID: 930921 Comm: systemd-coredum Tainted: G           O      5.10.48-cloudflare-kasan-2021.7.0 #1
>     Hardware name: <snip>
>     Call Trace:
>      dump_stack+0x7d/0xa3
>      ubsan_epilogue+0x5/0x40
>      __ubsan_handle_out_of_bounds.cold+0x43/0x48
>      ? seq_printf+0x17d/0x250
>      bpf_link_show_fdinfo+0x329/0x380
>      ? bpf_map_value_size+0xe0/0xe0
>      ? put_files_struct+0x20/0x2d0
>      ? __kasan_kmalloc.constprop.0+0xc2/0xd0
>      seq_show+0x3f7/0x540
>      seq_read_iter+0x3f8/0x1040
>      seq_read+0x329/0x500
>      ? seq_read_iter+0x1040/0x1040
>      ? __fsnotify_parent+0x80/0x820
>      ? __fsnotify_update_child_dentry_flags+0x380/0x380
>      vfs_read+0x123/0x460
>      ksys_read+0xed/0x1c0
>      ? __x64_sys_pwrite64+0x1f0/0x1f0
>      do_syscall_64+0x33/0x40
>      entry_SYSCALL_64_after_hwframe+0x44/0xa9
>     <snip>
>     ================================================================================
>     ================================================================================
>     UBSAN: object-size-mismatch in kernel/bpf/syscall.c:2384:2
>
> From the report, we can infer that some array access in bpf_link_show_fdinfo at index 6
> is out of bounds. The obvious candidate is bpf_link_type_strs[BPF_LINK_TYPE_XDP] with
> BPF_LINK_TYPE_XDP == 6. It turns out that BPF_LINK_TYPE_XDP is missing from bpf_types.h
> and therefore doesn't have an entry in bpf_link_type_strs:
>
>     pos:        0
>     flags:      02000000
>     mnt_id:     13
>     link_type:  (null)
>     link_id:    4
>     prog_tag:   bcf7977d3b93787c
>     prog_id:    4
>     ifindex:    1
>
> Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> ---

Well, oops. Thanks for the fix!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

It would be great to have a compilation error for something like this.
I wonder if we can do something to detect this going forward?

>  include/linux/bpf_types.h | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> index a9db1eae6796..be95f2722ad9 100644
> --- a/include/linux/bpf_types.h
> +++ b/include/linux/bpf_types.h
> @@ -135,3 +135,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
>  #ifdef CONFIG_NET
>  BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
>  #endif
> +BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
> --
> 2.30.2
>
