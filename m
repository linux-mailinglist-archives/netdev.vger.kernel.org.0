Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C88E36F202
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 23:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236953AbhD2V3c convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Apr 2021 17:29:32 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:50914 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233293AbhD2V3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 17:29:32 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-wdsMpYtLOA2JuJj_M98MmA-1; Thu, 29 Apr 2021 17:28:40 -0400
X-MC-Unique: wdsMpYtLOA2JuJj_M98MmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 188ED8042A6;
        Thu, 29 Apr 2021 21:28:38 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.195.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A77DA36DE;
        Thu, 29 Apr 2021 21:28:35 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH RFC] bpf: Fix trampoline for functions with variable arguments
Date:   Thu, 29 Apr 2021 23:28:34 +0200
Message-Id: <20210429212834.82621-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For functions with variable arguments like:

  void set_worker_desc(const char *fmt, ...)

the BTF data contains void argument at the end:

[4061] FUNC_PROTO '(anon)' ret_type_id=0 vlen=2
        'fmt' type_id=3
        '(anon)' type_id=0

When attaching function with this void argument the btf_distill_func_proto
will set last btf_func_model's argument with size 0 and that
will cause extra loop in save_regs/restore_regs functions and
generate trampoline code like:

  55             push   %rbp
  48 89 e5       mov    %rsp,%rbp
  48 83 ec 10    sub    $0x10,%rsp
  53             push   %rbx
  48 89 7d f0    mov    %rdi,-0x10(%rbp)
  75 f8          jne    0xffffffffa00cf007
                 ^^^ extra jump

It's causing soft lockups/crashes probably depends on what context
is the attached function called, like for set_worker_desc:

  watchdog: BUG: soft lockup - CPU#16 stuck for 22s! [kworker/u40:4:239]
  CPU: 16 PID: 239 Comm: kworker/u40:4 Not tainted 5.12.0-rc4qemu+ #178
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-1.fc33 04/01/2014
  Workqueue: writeback wb_workfn
  RIP: 0010:bpf_trampoline_6442464853_0+0xa/0x1000
  Code: Unable to access opcode bytes at RIP 0xffffffffa3597fe0.
  RSP: 0018:ffffc90000687da8 EFLAGS: 00000217
  Call Trace:
   set_worker_desc+0x5/0xb0
   wb_workfn+0x48/0x4d0
   ? psi_group_change+0x41/0x210
   ? __bpf_prog_exit+0x15/0x20
   ? bpf_trampoline_6442458903_0+0x3b/0x1000
   ? update_pasid+0x5/0x90
   ? __switch_to+0x187/0x450
   process_one_work+0x1e7/0x380
   worker_thread+0x50/0x3b0
   ? rescuer_thread+0x380/0x380
   kthread+0x11b/0x140
   ? __kthread_bind_mask+0x60/0x60
   ret_from_fork+0x22/0x30

This patch is removing the void argument from struct btf_func_model
in btf_distill_func_proto, but perhaps we should also check for this
in JIT's save_regs/restore_regs functions.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/btf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index b1a76fe046cb..017a80324139 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5133,6 +5133,11 @@ int btf_distill_func_proto(struct bpf_verifier_log *log,
 				tname, i, btf_kind_str[BTF_INFO_KIND(t->info)]);
 			return -EINVAL;
 		}
+		/* void at the end of args means '...' argument, skip it */
+		if (!ret && (i + 1 == nargs)) {
+			nargs--;
+			break;
+		}
 		m->arg_size[i] = ret;
 	}
 	m->nr_args = nargs;
-- 
2.30.2

