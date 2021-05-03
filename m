Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C034C372302
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 00:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbhECWdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 18:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbhECWdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 18:33:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBB81C061574;
        Mon,  3 May 2021 15:32:46 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id i4so9679089ybe.2;
        Mon, 03 May 2021 15:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mm+4ghZV/Woz4HWldAjCfh4bYE7Dbs2Sxp/AbetWJpg=;
        b=KDzM6qeyCzoYx7K3tpJ7QH1o0eMVZhCybvjCSwTjuCRkBVpIFPSiB/JaZ8bUIT2Mat
         5s4ZTS8TaufRO49DUQPU2OSSE/y9hi13H7LBueSHFzcG2jaf4u8vYZ+BaQtumAo8qVwv
         tZXh8kPLAg/zhvTbTEAq+IzbFieKeAuh7WUltAAlXtq5odY1LQewVhVQO4vwgVAGNisB
         hqAf9sxN7Fcm9iIsijRm/Nsm4Rjje4skYS1ScOVzZ7eBSmKYq3gBpNt8H9N6m7HraCeh
         Pn4eljACvYV0rFsF8hMDR+ZZEr0L8C3e1cA5xDxBtzcJseVsMc39oQBDt9q/Zd3z4aw/
         PV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mm+4ghZV/Woz4HWldAjCfh4bYE7Dbs2Sxp/AbetWJpg=;
        b=mCAufFSc7+1Ie88Qve7NxugUMaHdjRuGL9QnLEaLs0adJvA3n0IjLEqhLGE6d6YewJ
         S7RQjUn3BJkd/XqGFA9+K5A4vHBKAq0jmyo/f6O3u8oo+KG2EzM0X9Mj8eF1OYjc/PId
         U/zq1tG/R7lpWTUCN4ySmylS3kB6tNK5ZIhaEeyBUjeMR3VasM3nVZ7M5Sr4ikqY3scq
         C48csaCYub3vXyG73cH9zl8SOd0BF2+B1uK3IuZVZtxLokJVEG49nvFvb2FlKt+tC5QI
         2w1yHdZxJMQnKpZ3+05JQ7eY/cahSNu/sdH4N7855qzDRqvvNxPTutTTu5OLlbSdz1at
         fz9Q==
X-Gm-Message-State: AOAM5327bnBp1wdrdoPZcbuR95UmjSbCyVPq/ECh24eModHgVXcgKXIw
        +X1FW3tou8GyAnG5vDum6qx4RV20vWbQbtmcba0=
X-Google-Smtp-Source: ABdhPJxicuitJ5i+znHqAi3yZ+far4ZEFrjv55/7kRdJ/O720WpRGUu25oiS5HJfJRyaByVp8cqg3JxgqTP+P0DW8dg=
X-Received: by 2002:a25:ba06:: with SMTP id t6mr28751486ybg.459.1620081165449;
 Mon, 03 May 2021 15:32:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210429212834.82621-1-jolsa@kernel.org> <YI8WokIxTkZvzVuP@krava>
In-Reply-To: <YI8WokIxTkZvzVuP@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 3 May 2021 15:32:34 -0700
Message-ID: <CAEf4BzZjtU1hicc8dK1M9Mqf3wanU2AJFDtZJzUfQdwCsC6cGg@mail.gmail.com>
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

On Sun, May 2, 2021 at 2:17 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Thu, Apr 29, 2021 at 11:28:34PM +0200, Jiri Olsa wrote:
> > For functions with variable arguments like:
> >
> >   void set_worker_desc(const char *fmt, ...)
> >
> > the BTF data contains void argument at the end:
> >
> > [4061] FUNC_PROTO '(anon)' ret_type_id=0 vlen=2
> >         'fmt' type_id=3
> >         '(anon)' type_id=0
> >
> > When attaching function with this void argument the btf_distill_func_proto
> > will set last btf_func_model's argument with size 0 and that
> > will cause extra loop in save_regs/restore_regs functions and
> > generate trampoline code like:
> >
> >   55             push   %rbp
> >   48 89 e5       mov    %rsp,%rbp
> >   48 83 ec 10    sub    $0x10,%rsp
> >   53             push   %rbx
> >   48 89 7d f0    mov    %rdi,-0x10(%rbp)
> >   75 f8          jne    0xffffffffa00cf007
> >                  ^^^ extra jump
> >
> > It's causing soft lockups/crashes probably depends on what context
> > is the attached function called, like for set_worker_desc:
> >
> >   watchdog: BUG: soft lockup - CPU#16 stuck for 22s! [kworker/u40:4:239]
> >   CPU: 16 PID: 239 Comm: kworker/u40:4 Not tainted 5.12.0-rc4qemu+ #178
> >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
> >   Workqueue: writeback wb_workfn
> >   RIP: 0010:bpf_trampoline_6442464853_0+0xa/0x1000
> >   Code: Unable to access opcode bytes at RIP 0xffffffffa3597fe0.
> >   RSP: 0018:ffffc90000687da8 EFLAGS: 00000217
> >   Call Trace:
> >    set_worker_desc+0x5/0xb0
> >    wb_workfn+0x48/0x4d0
> >    ? psi_group_change+0x41/0x210
> >    ? __bpf_prog_exit+0x15/0x20
> >    ? bpf_trampoline_6442458903_0+0x3b/0x1000
> >    ? update_pasid+0x5/0x90
> >    ? __switch_to+0x187/0x450
> >    process_one_work+0x1e7/0x380
> >    worker_thread+0x50/0x3b0
> >    ? rescuer_thread+0x380/0x380
> >    kthread+0x11b/0x140
> >    ? __kthread_bind_mask+0x60/0x60
> >    ret_from_fork+0x22/0x30
> >
> > This patch is removing the void argument from struct btf_func_model
> > in btf_distill_func_proto, but perhaps we should also check for this
> > in JIT's save_regs/restore_regs functions.
>
> actualy looks like we need to disable functions with variable arguments
> completely, because we don't know how many arguments to save
>
> I tried to disable them in pahole and it's easy fix, will post new fix

Can we still allow access to fixed arguments for such functions and
just disallow the vararg ones?

>
> jirka
>
