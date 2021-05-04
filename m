Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF3D372AF2
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 15:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhEDN2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 09:28:06 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231127AbhEDN2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 09:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620134831;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r6jEV0+MR5VFM9+ohpe8WFHPD4y/Vv8hPlbXKlAqSbQ=;
        b=NdEot7NSuvwhNjdGFIO6dbACNdvPHsvrOQEKs2MWH7z41CXqD74+7byRENdINFDfMnGqx2
        B+9kLCN11asp7393C36ufcRRVfp2M3ss6f1g0m38juwrsUArnj+Ncu5jmxftgZOz23YwB4
        JWfQeLgEsR2iMeGTO6mJH+vW2L/HKxw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-gprCdgvgPYCXpnhDlSoEnQ-1; Tue, 04 May 2021 09:27:07 -0400
X-MC-Unique: gprCdgvgPYCXpnhDlSoEnQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 355CB802958;
        Tue,  4 May 2021 13:27:04 +0000 (UTC)
Received: from krava (unknown [10.40.192.136])
        by smtp.corp.redhat.com (Postfix) with SMTP id A34FC5E7B3;
        Tue,  4 May 2021 13:27:01 +0000 (UTC)
Date:   Tue, 4 May 2021 15:27:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH RFC] bpf: Fix trampoline for functions with variable
 arguments
Message-ID: <YJFLpAbUiwIu0I4H@krava>
References: <20210429212834.82621-1-jolsa@kernel.org>
 <YI8WokIxTkZvzVuP@krava>
 <CAEf4BzZjtU1hicc8dK1M9Mqf3wanU2AJFDtZJzUfQdwCsC6cGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZjtU1hicc8dK1M9Mqf3wanU2AJFDtZJzUfQdwCsC6cGg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 03, 2021 at 03:32:34PM -0700, Andrii Nakryiko wrote:
> On Sun, May 2, 2021 at 2:17 PM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Apr 29, 2021 at 11:28:34PM +0200, Jiri Olsa wrote:
> > > For functions with variable arguments like:
> > >
> > >   void set_worker_desc(const char *fmt, ...)
> > >
> > > the BTF data contains void argument at the end:
> > >
> > > [4061] FUNC_PROTO '(anon)' ret_type_id=0 vlen=2
> > >         'fmt' type_id=3
> > >         '(anon)' type_id=0
> > >
> > > When attaching function with this void argument the btf_distill_func_proto
> > > will set last btf_func_model's argument with size 0 and that
> > > will cause extra loop in save_regs/restore_regs functions and
> > > generate trampoline code like:
> > >
> > >   55             push   %rbp
> > >   48 89 e5       mov    %rsp,%rbp
> > >   48 83 ec 10    sub    $0x10,%rsp
> > >   53             push   %rbx
> > >   48 89 7d f0    mov    %rdi,-0x10(%rbp)
> > >   75 f8          jne    0xffffffffa00cf007
> > >                  ^^^ extra jump
> > >
> > > It's causing soft lockups/crashes probably depends on what context
> > > is the attached function called, like for set_worker_desc:
> > >
> > >   watchdog: BUG: soft lockup - CPU#16 stuck for 22s! [kworker/u40:4:239]
> > >   CPU: 16 PID: 239 Comm: kworker/u40:4 Not tainted 5.12.0-rc4qemu+ #178
> > >   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
> > >   Workqueue: writeback wb_workfn
> > >   RIP: 0010:bpf_trampoline_6442464853_0+0xa/0x1000
> > >   Code: Unable to access opcode bytes at RIP 0xffffffffa3597fe0.
> > >   RSP: 0018:ffffc90000687da8 EFLAGS: 00000217
> > >   Call Trace:
> > >    set_worker_desc+0x5/0xb0
> > >    wb_workfn+0x48/0x4d0
> > >    ? psi_group_change+0x41/0x210
> > >    ? __bpf_prog_exit+0x15/0x20
> > >    ? bpf_trampoline_6442458903_0+0x3b/0x1000
> > >    ? update_pasid+0x5/0x90
> > >    ? __switch_to+0x187/0x450
> > >    process_one_work+0x1e7/0x380
> > >    worker_thread+0x50/0x3b0
> > >    ? rescuer_thread+0x380/0x380
> > >    kthread+0x11b/0x140
> > >    ? __kthread_bind_mask+0x60/0x60
> > >    ret_from_fork+0x22/0x30
> > >
> > > This patch is removing the void argument from struct btf_func_model
> > > in btf_distill_func_proto, but perhaps we should also check for this
> > > in JIT's save_regs/restore_regs functions.
> >
> > actualy looks like we need to disable functions with variable arguments
> > completely, because we don't know how many arguments to save
> >
> > I tried to disable them in pahole and it's easy fix, will post new fix
> 
> Can we still allow access to fixed arguments for such functions and
> just disallow the vararg ones?

the problem is that we should save all the registers for arguments,
which is probably doable.. but if caller uses more than 6 arguments,
we need stack data, which will be wrong because of the extra stack
frame we do in bpf trampoline.. so we could crash

the patch below prevents to attach these functions directly in kernel,
so we could keep these functions in BTF

jirka


---
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0600ed325fa0..f9709dc08c44 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5213,6 +5213,13 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 			return -EINVAL;
 		}
+		if (ret == 0) {
+			bpf_log(log,
+				"The function %s has variable args, it's unsupported.\n",
+				tname);
+			return -EINVAL;
+
+		}
 		m->arg_size[i] = ret;
 	}
 	m->nr_args = nargs;

