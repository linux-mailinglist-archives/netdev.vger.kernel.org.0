Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCF436CEB4
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 00:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236792AbhD0Wmv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Apr 2021 18:42:51 -0400
Received: from us-smtp-delivery-44.mimecast.com ([205.139.111.44]:43961 "EHLO
        us-smtp-delivery-44.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235420AbhD0Wmv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 18:42:51 -0400
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-192-WtPfqhlBMCqXJZwPGjXKvw-1; Tue, 27 Apr 2021 18:42:01 -0400
X-MC-Unique: WtPfqhlBMCqXJZwPGjXKvw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CDDC3805EF8;
        Tue, 27 Apr 2021 22:41:59 +0000 (UTC)
Received: from krava.cust.in.nbox.cz (unknown [10.40.192.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7E18310027A5;
        Tue, 27 Apr 2021 22:41:57 +0000 (UTC)
From:   Jiri Olsa <jolsa@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: [PATCH] bpf: Fix recursion check in trampoline
Date:   Wed, 28 Apr 2021 00:41:56 +0200
Message-Id: <20210427224156.708231-1-jolsa@kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=jolsa@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: kernel.org
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recursion check in __bpf_prog_enter and __bpf_prog_exit leaves
some (not inlined) functions unprotected:

In __bpf_prog_enter:
  - migrate_disable is called before prog->active is checked

In __bpf_prog_exit:
  - migrate_enable,rcu_read_unlock_strict are called after
    prog->active is decreased

When attaching trampoline to them we get panic like:

  traps: PANIC: double fault, error_code: 0x0
  double fault: 0000 [#1] SMP PTI
  RIP: 0010:__bpf_prog_enter+0x4/0x50
  ...
  Call Trace:
   <IRQ>
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   __bpf_prog_enter+0x9/0x50
   bpf_trampoline_6442466513_0+0x18/0x1000
   migrate_disable+0x5/0x50
   ...

Making the recursion check before the rest of the calls
in __bpf_prog_enter and as last call in __bpf_prog_exit.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/bpf/trampoline.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 4aa8b52adf25..301735f7e88e 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -558,12 +558,12 @@ static void notrace inc_misses_counter(struct bpf_prog *prog)
 u64 notrace __bpf_prog_enter(struct bpf_prog *prog)
 	__acquires(RCU)
 {
-	rcu_read_lock();
-	migrate_disable();
 	if (unlikely(__this_cpu_inc_return(*(prog->active)) != 1)) {
 		inc_misses_counter(prog);
 		return 0;
 	}
+	rcu_read_lock();
+	migrate_disable();
 	return bpf_prog_start_time();
 }
 
@@ -590,10 +590,12 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 void notrace __bpf_prog_exit(struct bpf_prog *prog, u64 start)
 	__releases(RCU)
 {
-	update_prog_stats(prog, start);
+	if (start) {
+		update_prog_stats(prog, start);
+		migrate_enable();
+		rcu_read_unlock();
+	}
 	__this_cpu_dec(*(prog->active));
-	migrate_enable();
-	rcu_read_unlock();
 }
 
 u64 notrace __bpf_prog_enter_sleepable(struct bpf_prog *prog)
-- 
2.30.2

