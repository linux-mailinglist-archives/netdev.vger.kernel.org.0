Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69465373287
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:37:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhEDWiU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231464AbhEDWiT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:38:19 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FB0C061574;
        Tue,  4 May 2021 15:37:22 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id r8so134914ybb.9;
        Tue, 04 May 2021 15:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/rcOxPodICfG9N9CM3OcwHXOlg6CyM6WBBBB3GXGalc=;
        b=pIYKtvpQre6fXnjVXh0hX1f7LJLo2zPgC0EvkSYFBhApXePYfGAHWAmOe6sycm1gBj
         I8wctKSVe6+HF4BmWH2jMlIFWS2sUF4TgviZvRiTBqeTyb9FjpOGWOBfb5P+hxI6mLa2
         3e6P/yp7B5AnLoXCJtsLthoEuG7/GvJMRxh+861Kbvs3LDe0cHeVZ3+g3ctMDuySivf8
         IN42PqxHZ7Xi6z75sDEdp9UBQMl+0hdtILXw/32jiJjONmXY+1f99FHN84OIDyOLpTRM
         VtTHuGTEX4lh5BUA/ww4/uRJjeH4isUVgiu5le4SOAVQUJhry2G5mDwrrjCbi8XE0CsC
         Re1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/rcOxPodICfG9N9CM3OcwHXOlg6CyM6WBBBB3GXGalc=;
        b=k3dVeBYWnNp78bz6jBDkbyUrilifoTElI3/DynMiCFNAMjPoetSnyYF7YDhVrwVIDO
         4mVfPYVlKji2EYHQUVoL1pOKbmh6ZpdSRmp4nKgezDGJfT1ixuXtkBM7OZ6wK8ulNqpR
         K1d6+9BDYVRzmmhqzx46ocC8A45r5W07LmYgcLzCb3VzH4j2K/aHH+OerHh+MnCOOA+c
         g2RUy1Q+TZz2+3h6V1e/81RCRZHIy2OhK3VFe4BMhnFixFqWAwFgMBYzhbcvGW9u1r5h
         NfFqm2+FlZVot5bwanVLaaWPRrAlldoQ0apk1FXAZ9Aa4vikHGC2EcsSj2OOoWfYLU22
         rhzA==
X-Gm-Message-State: AOAM530ZV5ezrODCmA40uJOjzU9y+j0FnlFJA5sZ6WBI7Wp1b2rprvGE
        qKnlzy/am6mVfS4zBQIBaDEviqlkfnGQ80NLfvA=
X-Google-Smtp-Source: ABdhPJzCk/CVV637ag7i3mlzcM39x4Lj5FcYXY7Gj5G8Wj90vxrNn9hx49htDsH1V2jYO436s5pIyQM4bEi24rSwWsY=
X-Received: by 2002:a25:9942:: with SMTP id n2mr39337234ybo.230.1620167842180;
 Tue, 04 May 2021 15:37:22 -0700 (PDT)
MIME-Version: 1.0
References: <20210429212834.82621-1-jolsa@kernel.org> <YI8WokIxTkZvzVuP@krava>
 <CAEf4BzZjtU1hicc8dK1M9Mqf3wanU2AJFDtZJzUfQdwCsC6cGg@mail.gmail.com> <YJFLpAbUiwIu0I4H@krava>
In-Reply-To: <YJFLpAbUiwIu0I4H@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 4 May 2021 15:37:11 -0700
Message-ID: <CAEf4BzYz3G4aRWT4YTrnKaVCsE_A2UGGn6jVvqOuK8ZLU-sN8g@mail.gmail.com>
Subject: Re: [PATCH RFC] bpf: Fix trampoline for functions with variable arguments
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 4, 2021 at 6:27 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, May 03, 2021 at 03:32:34PM -0700, Andrii Nakryiko wrote:
> > On Sun, May 2, 2021 at 2:17 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > On Thu, Apr 29, 2021 at 11:28:34PM +0200, Jiri Olsa wrote:
> > > > For functions with variable arguments like:
> > > >
> > > >   void set_worker_desc(const char *fmt, ...)
> > > >
> > > > the BTF data contains void argument at the end:
> > > >
> > > > [4061] FUNC_PROTO '(anon)' ret_type_id=0 vlen=2
> > > >         'fmt' type_id=3
> > > >         '(anon)' type_id=0
> > > >
> > > > When attaching function with this void argument the btf_distill_func_proto
> > > > will set last btf_func_model's argument with size 0 and that
> > > > will cause extra loop in save_regs/restore_regs functions and
> > > > generate trampoline code like:
> > > >
> > > >   55             push   %rbp
> > > >   48 89 e5       mov    %rsp,%rbp
> > > >   48 83 ec 10    sub    $0x10,%rsp
> > > >   53             push   %rbx
> > > >   48 89 7d f0    mov    %rdi,-0x10(%rbp)
> > > >   75 f8          jne    0xffffffffa00cf007
> > > >                  ^^^ extra jump
> > > >
> > > > It's causing soft lockups/crashes probably depends on what context
> > > > is the attached function called, like for set_worker_desc:
> > > >
> > > >   watchdog: BUG: soft lockup - CPU#16 stuck for 22s! [kworker/u40:4:239]
> > > >   CPU: 16 PID: 239 Comm: kworker/u40:4 Not tainted 5.12.0-rc4qemu+ #178
> > > >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
> > > >   Workqueue: writeback wb_workfn
> > > >   RIP: 0010:bpf_trampoline_6442464853_0+0xa/0x1000
> > > >   Code: Unable to access opcode bytes at RIP 0xffffffffa3597fe0.
> > > >   RSP: 0018:ffffc90000687da8 EFLAGS: 00000217
> > > >   Call Trace:
> > > >    set_worker_desc+0x5/0xb0
> > > >    wb_workfn+0x48/0x4d0
> > > >    ? psi_group_change+0x41/0x210
> > > >    ? __bpf_prog_exit+0x15/0x20
> > > >    ? bpf_trampoline_6442458903_0+0x3b/0x1000
> > > >    ? update_pasid+0x5/0x90
> > > >    ? __switch_to+0x187/0x450
> > > >    process_one_work+0x1e7/0x380
> > > >    worker_thread+0x50/0x3b0
> > > >    ? rescuer_thread+0x380/0x380
> > > >    kthread+0x11b/0x140
> > > >    ? __kthread_bind_mask+0x60/0x60
> > > >    ret_from_fork+0x22/0x30
> > > >
> > > > This patch is removing the void argument from struct btf_func_model
> > > > in btf_distill_func_proto, but perhaps we should also check for this
> > > > in JIT's save_regs/restore_regs functions.
> > >
> > > actualy looks like we need to disable functions with variable arguments
> > > completely, because we don't know how many arguments to save
> > >
> > > I tried to disable them in pahole and it's easy fix, will post new fix
> >
> > Can we still allow access to fixed arguments for such functions and
> > just disallow the vararg ones?
>
> the problem is that we should save all the registers for arguments,
> which is probably doable.. but if caller uses more than 6 arguments,
> we need stack data, which will be wrong because of the extra stack
> frame we do in bpf trampoline.. so we could crash
>
> the patch below prevents to attach these functions directly in kernel,
> so we could keep these functions in BTF
>
> jirka
>
>
> ---
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 0600ed325fa0..f9709dc08c44 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -5213,6 +5213,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
>                                 tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
>                         return -EINVAL;
>                 }
> +               if (ret == 0) {
> +                       bpf_log(log,
> +                               "The function %s has variable args, it's unsupported.\n",
> +                               tname);
> +                       return -EINVAL;
> +
> +               }

this will work, but the explicit check for vararg should be `i ==
nargs - 1 && args[i].type == 0`. Everything else (if it happens) is
probably a bad BTF data.

>                 m->arg_size[i] = ret;
>         }
>         m->nr_args = nargs;
>
