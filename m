Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57FB73CCF81
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234992AbhGSIQe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:16:34 -0400
Received: from mail-ej1-f41.google.com ([209.85.218.41]:46654 "EHLO
        mail-ej1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234903AbhGSIQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:16:33 -0400
Received: by mail-ej1-f41.google.com with SMTP id c17so27374119ejk.13
        for <netdev@vger.kernel.org>; Mon, 19 Jul 2021 01:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1k48KCcy3y6vIAdtOHWsq+O6aGKfc6p+OZyi1Vzkxdg=;
        b=Q1WubCmk3c2vuY8XLCwB23Tv9+DQkdc9eL4l+yn1NMuxC3edJzvGuvOWVENS38btuO
         ohj0f8EU306raJZ+26SBlCyu60z8Y2kC50BBDWUUyEyJQRI7HhQsDqKqddH0sSoaSR2Q
         9u2TsPp4vLtJa8iObupi8nnCPkV819nrXkUNU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1k48KCcy3y6vIAdtOHWsq+O6aGKfc6p+OZyi1Vzkxdg=;
        b=jjV3dhJBTrqWrZ6w4npsr/K8jsDzCfZSqYrGk1fE14mmvF7rakzucG+owaoUe9SjvX
         2cgMMWQRQWjC6imQuUimvJYEFNHAioRs1mHDKADNXZZhJ52iip4Et89nNWRYKD+P6AT4
         gX4yzlsS5Z1Ydev4EmKvU9BLDSmwecmi5YPbOBx5Rqcl4j0QeGcileBOOzVdIS1MdqoD
         gOHD018JAtGMrEjuPvldwVT2AmQ+IPFgvbNgU5RUXTbIg8V+TPe5tPpaoh5D6NkiKswz
         8zzKFU0r62ikUvpzAfywKP/FB1LZ8W2J2kHkTK0e+IX89na2IDAoiT/ueHQjd3+Yca1S
         ZIVw==
X-Gm-Message-State: AOAM530wFPr679PriPLNeQzzysg2AuAWyvR2dsK7q3Z6okBNvFrQXBfy
        WfkiRGqrEXjzWoZUtrBjAbfvGgOGmlvRD9CSdbTrw14XDjM=
X-Google-Smtp-Source: ABdhPJxEJdcVR2SXhjQ85qLADGoRKOtqMfEnuajiHT1qzvYAz+LOuUxDG7SZyMA1wek8uSFNLIMCe2o/NUwyOgoL4gE=
X-Received: by 2002:a05:6512:22d3:: with SMTP id g19mr12501835lfu.171.1626684540314;
 Mon, 19 Jul 2021 01:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20210716100452.113652-1-lmb@cloudflare.com> <CAEf4BzauzWhNag0z31krN_MTZTGLynAJvkh_7P3yLQCx5XLTAg@mail.gmail.com>
 <7854fbef-8ea5-5396-6369-99eef1dcccaa@iogearbox.net>
In-Reply-To: <7854fbef-8ea5-5396-6369-99eef1dcccaa@iogearbox.net>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 19 Jul 2021 09:48:48 +0100
Message-ID: <CACAyw99ArX_oP17f4CeYBsjOXuK+E==6PkTBVQqSVnLzqi3P=Q@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix OOB read when printing XDP link fdinfo
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
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

On Fri, 16 Jul 2021 at 22:01, Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 7/16/21 10:43 PM, Andrii Nakryiko wrote:
> > On Fri, Jul 16, 2021 at 3:05 AM Lorenz Bauer <lmb@cloudflare.com> wrote:
> >>
> >> We got the following UBSAN report on one of our testing machines:
> >>
> >>      ================================================================================
> >>      UBSAN: array-index-out-of-bounds in kernel/bpf/syscall.c:2389:24
> >>      index 6 is out of range for type 'char *[6]'
> >>      CPU: 43 PID: 930921 Comm: systemd-coredum Tainted: G           O      5.10.48-cloudflare-kasan-2021.7.0 #1
> >>      Hardware name: <snip>
> >>      Call Trace:
> >>       dump_stack+0x7d/0xa3
> >>       ubsan_epilogue+0x5/0x40
> >>       __ubsan_handle_out_of_bounds.cold+0x43/0x48
> >>       ? seq_printf+0x17d/0x250
> >>       bpf_link_show_fdinfo+0x329/0x380
> >>       ? bpf_map_value_size+0xe0/0xe0
> >>       ? put_files_struct+0x20/0x2d0
> >>       ? __kasan_kmalloc.constprop.0+0xc2/0xd0
> >>       seq_show+0x3f7/0x540
> >>       seq_read_iter+0x3f8/0x1040
> >>       seq_read+0x329/0x500
> >>       ? seq_read_iter+0x1040/0x1040
> >>       ? __fsnotify_parent+0x80/0x820
> >>       ? __fsnotify_update_child_dentry_flags+0x380/0x380
> >>       vfs_read+0x123/0x460
> >>       ksys_read+0xed/0x1c0
> >>       ? __x64_sys_pwrite64+0x1f0/0x1f0
> >>       do_syscall_64+0x33/0x40
> >>       entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >>      <snip>
> >>      ================================================================================
> >>      ================================================================================
> >>      UBSAN: object-size-mismatch in kernel/bpf/syscall.c:2384:2
> >>
> >>  From the report, we can infer that some array access in bpf_link_show_fdinfo at index 6
> >> is out of bounds. The obvious candidate is bpf_link_type_strs[BPF_LINK_TYPE_XDP] with
> >> BPF_LINK_TYPE_XDP == 6. It turns out that BPF_LINK_TYPE_XDP is missing from bpf_types.h
> >> and therefore doesn't have an entry in bpf_link_type_strs:
> >>
> >>      pos:        0
> >>      flags:      02000000
> >>      mnt_id:     13
> >>      link_type:  (null)
> >>      link_id:    4
> >>      prog_tag:   bcf7977d3b93787c
> >>      prog_id:    4
> >>      ifindex:    1
> >>
> >> Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
> >> Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> >> ---
> >
> > Well, oops. Thanks for the fix!
> >
> > Acked-by: Andrii Nakryiko <andrii@kernel.org>
> >
> > It would be great to have a compilation error for something like this.
> > I wonder if we can do something to detect this going forward?
> >
> >>   include/linux/bpf_types.h | 1 +
> >>   1 file changed, 1 insertion(+)
> >>
> >> diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
> >> index a9db1eae6796..be95f2722ad9 100644
> >> --- a/include/linux/bpf_types.h
> >> +++ b/include/linux/bpf_types.h
> >> @@ -135,3 +135,4 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
> >>   #ifdef CONFIG_NET
> >>   BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
> >>   #endif
> >> +BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
>
> Lorenz, does this compile when you don't have CONFIG_NET configured? I would assume
> this needs to go right below the netns one depending on CONFIG_NET.. at least the
> bpf_xdp_link_lops are in net/core/dev.c which is only built under CONFIG_NET.

It does compile, since the only use of the macro is to stringify a
link type for fdinfo. I'll move it into CONFIG_NET to be consistent
with netdev though.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
