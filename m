Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3465299236
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 17:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1785729AbgJZQVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 12:21:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:33632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1785714AbgJZQVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 12:21:17 -0400
Received: from localhost.localdomain (unknown [192.30.34.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94F9D2463C;
        Mon, 26 Oct 2020 16:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603729276;
        bh=zNT9+W068f8fERQD91gIVDc2JWuRGhG2olBuXuEAQR8=;
        h=From:To:Cc:Subject:Date:From;
        b=tAdyWuxL2Bzw7oE+dUgBV64nS6vuHJPeka7/xu+pQhqKCdA0l382kbDE+FJimtTmg
         c78OkIKYOQD9pIb0FAyrcswvqjvO9zb6Qzr5KPUabvhtuYopJtrBGXDRC25fTfZSYi
         z/B93BmAO3idbxlYJOaKNVja1t4y15i02YGDl3fE=
From:   Arnd Bergmann <arnd@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] bpf: fix -Wshadow warnings
Date:   Mon, 26 Oct 2020 17:20:50 +0100
Message-Id: <20201026162110.3710415-1-arnd@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are thousands of warnings about one macro in a W=2 build:

include/linux/filter.h:561:6: warning: declaration of 'ret' shadows a previous local [-Wshadow]

Prefix all the locals in that macro with __ to avoid most of
these warnings.

Fixes: 492ecee892c2 ("bpf: enable program stats")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/filter.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 954f279fde01..20ba04583eaa 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -558,21 +558,21 @@ struct sk_filter {
 DECLARE_STATIC_KEY_FALSE(bpf_stats_enabled_key);
 
 #define __BPF_PROG_RUN(prog, ctx, dfunc)	({			\
-	u32 ret;							\
+	u32 __ret;							\
 	cant_migrate();							\
 	if (static_branch_unlikely(&bpf_stats_enabled_key)) {		\
-		struct bpf_prog_stats *stats;				\
-		u64 start = sched_clock();				\
-		ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);	\
-		stats = this_cpu_ptr(prog->aux->stats);			\
-		u64_stats_update_begin(&stats->syncp);			\
-		stats->cnt++;						\
-		stats->nsecs += sched_clock() - start;			\
-		u64_stats_update_end(&stats->syncp);			\
+		struct bpf_prog_stats *__stats;				\
+		u64 __start = sched_clock();				\
+		__ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);	\
+		__stats = this_cpu_ptr(prog->aux->stats);		\
+		u64_stats_update_begin(&__stats->syncp);		\
+		__stats->cnt++;						\
+		__stats->nsecs += sched_clock() - __start;		\
+		u64_stats_update_end(&__stats->syncp);			\
 	} else {							\
-		ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);	\
+		__ret = dfunc(ctx, (prog)->insnsi, (prog)->bpf_func);	\
 	}								\
-	ret; })
+	__ret; })
 
 #define BPF_PROG_RUN(prog, ctx)						\
 	__BPF_PROG_RUN(prog, ctx, bpf_dispatcher_nop_func)
-- 
2.27.0

