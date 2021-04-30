Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9027036FBB8
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 15:48:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232549AbhD3Ns4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 30 Apr 2021 09:48:56 -0400
Received: from us-smtp-delivery-44.mimecast.com ([207.211.30.44]:58488 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhD3Nsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Apr 2021 09:48:55 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-595-CWtxxXPbNGm-XAiUBUHKiQ-1; Fri, 30 Apr 2021 09:48:01 -0400
X-MC-Unique: CWtxxXPbNGm-XAiUBUHKiQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44B3F107ACC7;
        Fri, 30 Apr 2021 13:47:58 +0000 (UTC)
Received: from krava.redhat.com (unknown [10.40.195.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9443E19C79;
        Fri, 30 Apr 2021 13:47:55 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [RFC] bpf: Fix crash on mm_init trampoline attachment
Date:   Fri, 30 Apr 2021 15:47:54 +0200
Message-Id: <20210430134754.179242-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are 2 mm_init functions in kernel.

One in kernel/fork.c:
  static struct mm_struct *mm_init(struct mm_struct *mm,
                                   struct task_struct *p,
                                   struct user_namespace *user_ns)

And another one in init/main.c:
  static void __init mm_init(void)

The BTF data will get the first one, which is most likely
(in my case) mm_init from init/main.c without arguments.

Then in runtime when we want to attach to 'mm_init' the
kalsyms contains address of the one from kernel/fork.c.

So we have function model with no arguments and using it
to attach function with 3 arguments.. as result the trampoline
will not save function's arguments and we get crash because
trampoline changes argument registers:

  BUG: unable to handle page fault for address: 0000607d87a1d558
  #PF: supervisor write access in kernel mode
  #PF: error_code(0x0002) - not-present page
  PGD 0 P4D 0
  Oops: 0002 [#1] SMP PTI
  CPU: 6 PID: 936 Comm: systemd Not tainted 5.12.0-rc4qemu+ #191
  RIP: 0010:mm_init+0x223/0x2a0
  ...
  Call Trace:
   ? bpf_trampoline_6442453476_0+0x3b/0x1000
   dup_mm+0x66/0x5f0
   ? __lock_task_sighand+0x3a/0x70
   copy_process+0x17d0/0x1b50
   kernel_clone+0x97/0x3c0
   __do_sys_clone+0x60/0x80
   do_syscall_64+0x33/0x40
   entry_SYSCALL_64_after_hwframe+0x44/0xae
  RIP: 0033:0x7f1dc9b3201f

I think there might be more cases like this, but I don't have
an idea yet how to solve this in generic way. The rename in
this change fix it for this instance.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 init/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/main.c b/init/main.c
index 53b278845b88..bc1bfe57daf7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -818,7 +818,7 @@ static void __init report_meminit(void)
 /*
  * Set up kernel memory allocators
  */
-static void __init mm_init(void)
+static void __init init_mem(void)
 {
 	/*
 	 * page_ext requires contiguous pages,
@@ -905,7 +905,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	vfs_caches_init_early();
 	sort_main_extable();
 	trap_init();
-	mm_init();
+	init_mem();
 
 	ftrace_init();
 
-- 
2.30.2

