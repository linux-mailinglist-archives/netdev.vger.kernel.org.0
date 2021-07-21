Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B2B3D18EB
	for <lists+netdev@lfdr.de>; Wed, 21 Jul 2021 23:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbhGUUjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 16:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:39240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhGUUjg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Jul 2021 16:39:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E8D61001;
        Wed, 21 Jul 2021 21:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626902412;
        bh=nY7Q2Gu53XreSpv2eK6K9Pj/0kb0Rlq6C4OieN5DwQk=;
        h=From:To:Cc:Subject:Date:From;
        b=LWKs+DgVJAeoupL65lsFCr9W/4KeKzZM6w1XYmJEJy3Yv2Z9MYKWFYKKMCvwHLwAf
         37BiKFx71vtqGrKyvLRnX8unHnCHtrP2GesNagye3UcWw9b+vMvjw7z2X8Rq6hUge8
         O+WW0wFYs1+5lmqhA1VTDce+kROdetBaEehU/o7wIYwKLYuBIKttU5X6h0+vu9xBiM
         knP3x2Y848olxZ6USAXysygTeU5ygRwcK0QqQbCohpH17cu+mu7EhEr+Xw05PM2+oX
         tWGSWEWXQRmAR4Kuto+GUgdYZee9MG+cXV7N0ELH0ebHseWQEXa01mvPGNWWfq7x6k
         yHAcczawcZKFw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Alan Maguire <alan.maguire@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] bpf: fix pointer cast warning
Date:   Wed, 21 Jul 2021 23:19:45 +0200
Message-Id: <20210721212007.3876595-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

kp->addr is a pointer, so it cannot be cast directly to a 'u64'
when it gets interpreted as an integer value:

kernel/trace/bpf_trace.c: In function '____bpf_get_func_ip_kprobe':
kernel/trace/bpf_trace.c:968:21: error: cast from pointer to integer of different size [-Werror=pointer-to-int-cast]
  968 |         return kp ? (u64) kp->addr : 0;

Use the uintptr_t type instead.

Fixes: 9ffd9f3ff719 ("bpf: Add bpf_get_func_ip helper for kprobe programs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 kernel/trace/bpf_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 0de09f068697..a428d1ef0085 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -965,7 +965,7 @@ BPF_CALL_1(bpf_get_func_ip_kprobe, struct pt_regs *, regs)
 {
 	struct kprobe *kp = kprobe_running();
 
-	return kp ? (u64) kp->addr : 0;
+	return kp ? (uintptr_t)kp->addr : 0;
 }
 
 static const struct bpf_func_proto bpf_get_func_ip_proto_kprobe = {
-- 
2.29.2

