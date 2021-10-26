Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADC043BC94
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237232AbhJZVoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235366AbhJZVoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 17:44:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8589C061767;
        Tue, 26 Oct 2021 14:41:41 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id 127so747561pfu.1;
        Tue, 26 Oct 2021 14:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uRZB2rF8sHKDVMLWBScuHHaIQnj2j20RrdT9H9xm/3c=;
        b=noawh3oskqNWSO7UlEcKGWOuv5x7kOu0dOf0KYmpCo4aNAQY9bA8cf3qNeiyEKbd4o
         9ZUCI9WaNRN4I/5VRD8fEZWbMR5WCLD5zTAWWhBosUV6Ckyo+RpZxRxd5Sv3TjP35j7j
         j+l+0NHXZcP/3kP7Sv2AA7qO87Cqt/D6QqPg08dz1qgNC1qjHBmBEAK39SxVd8mo4NH2
         Yv1oBg58DOPObFh7/v7FaxRMnlW+OXllzLZ9WSH4NgUPM3O6SfKNfYIXlAvlXgPdEgar
         rNsxXXEYzXfOpD4SxY0Do2KfMk7IN/fPbqln8oo2PZef0TasNMpvkEvtNBwScKM/bS+y
         ltCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uRZB2rF8sHKDVMLWBScuHHaIQnj2j20RrdT9H9xm/3c=;
        b=gTIPq+qiHhGs2AAvEmh6Co244NYuNNtXpl/IbU/dUPdpsDYba2qFJ1iFuOXbcvrNa3
         5fLntfrp9DBaeCq01N0XGW6VMa4z/QAcP+r89xCW9kC/bSDi6wskrz0QvtpgRCTPhKFd
         +GcV5qA2msR95YeIcfXeyxsekK+ZbtWncRyVKz9VYHyBGjp/I8qJzWAo8IFnT0Gcmxn2
         sJV3FLQfE50WRZxzEUecOzBayOGyQkLzVNXGx6XPLxNqNhMR98gxZPzJjBfyrBUVdiJR
         bEXEU5r5a+6Tai49fCYikkodrCvCo7KwltUOtHqXJYuC3x4UP+JVAWGgHvS4ObnVB5a0
         NDYw==
X-Gm-Message-State: AOAM533EoNepCtQKbGeySI//UI0gj4BRqlgcbraPxwYrW/i3DEBX6cZn
        l6+CC/V24kAVhktKDBkQnX4=
X-Google-Smtp-Source: ABdhPJw/7VohMZ4MaDTTWlIoH+qGitBHyuWxRhUa7MzK2AlTBXQ0jXGavGJdaqw0nf/lMdM82PZbZg==
X-Received: by 2002:a05:6a00:1a01:b0:47b:ae61:9bd1 with SMTP id g1-20020a056a001a0100b0047bae619bd1mr28173461pfv.0.1635284500389;
        Tue, 26 Oct 2021 14:41:40 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:207c:7102:7bd7:80eb])
        by smtp.gmail.com with ESMTPSA id g22sm6495400pfj.181.2021.10.26.14.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 14:41:40 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        bpf <bpf@vger.kernel.org>
Subject: [PATCH V2 bpf-next 3/3] bpf: use u64_stats_t in struct bpf_prog_stats
Date:   Tue, 26 Oct 2021 14:41:33 -0700
Message-Id: <20211026214133.3114279-4-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
In-Reply-To: <20211026214133.3114279-1-eric.dumazet@gmail.com>
References: <20211026214133.3114279-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Commit 316580b69d0a ("u64_stats: provide u64_stats_t type")
fixed possible load/store tearing on 64bit arches.

For instance the following C code

stats->nsecs += sched_clock() - start;

Could be rightfully implemented like this by a compiler,
confusing concurrent readers a lot:

stats->nsecs += sched_clock();
// arbitrary delay
stats->nsecs -= start;

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
---
 include/linux/filter.h  | 10 +++++-----
 kernel/bpf/syscall.c    | 18 ++++++++++++------
 kernel/bpf/trampoline.c |  6 +++---
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 2fffe9cc50f946f24f4f78b59902bad91f910e5b..9782e32458522273b314579e62c6215ebb07a617 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -553,9 +553,9 @@ struct bpf_binary_header {
 };
 
 struct bpf_prog_stats {
-	u64 cnt;
-	u64 nsecs;
-	u64 misses;
+	u64_stats_t cnt;
+	u64_stats_t nsecs;
+	u64_stats_t misses;
 	struct u64_stats_sync syncp;
 } __aligned(2 * sizeof(u64));
 
@@ -617,8 +617,8 @@ static __always_inline u32 __bpf_prog_run(const struct bpf_prog *prog,
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
+		u64_stats_inc(&stats->cnt);
+		u64_stats_add(&stats->nsecs, sched_clock() - start);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	} else {
 		ret = dfunc(ctx, prog->insnsi, prog->bpf_func);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 4e50c0bfdb7d38e1c929a499c0688f59b9caf618..7a147c6eb30b2b771539cce642a359bd4dec66f8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1804,8 +1804,14 @@ static int bpf_prog_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
+struct bpf_prog_kstats {
+	u64 nsecs;
+	u64 cnt;
+	u64 misses;
+};
+
 static void bpf_prog_get_stats(const struct bpf_prog *prog,
-			       struct bpf_prog_stats *stats)
+			       struct bpf_prog_kstats *stats)
 {
 	u64 nsecs = 0, cnt = 0, misses = 0;
 	int cpu;
@@ -1818,9 +1824,9 @@ static void bpf_prog_get_stats(const struct bpf_prog *prog,
 		st = per_cpu_ptr(prog->stats, cpu);
 		do {
 			start = u64_stats_fetch_begin_irq(&st->syncp);
-			tnsecs = st->nsecs;
-			tcnt = st->cnt;
-			tmisses = st->misses;
+			tnsecs = u64_stats_read(&st->nsecs);
+			tcnt = u64_stats_read(&st->cnt);
+			tmisses = u64_stats_read(&st->misses);
 		} while (u64_stats_fetch_retry_irq(&st->syncp, start));
 		nsecs += tnsecs;
 		cnt += tcnt;
@@ -1836,7 +1842,7 @@ static void bpf_prog_show_fdinfo(struct seq_file *m, struct file *filp)
 {
 	const struct bpf_prog *prog = filp->private_data;
 	char prog_tag[sizeof(prog->tag) * 2 + 1] = { };
-	struct bpf_prog_stats stats;
+	struct bpf_prog_kstats stats;
 
 	bpf_prog_get_stats(prog, &stats);
 	bin2hex(prog_tag, prog->tag, sizeof(prog->tag));
@@ -3575,7 +3581,7 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
 	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
-	struct bpf_prog_stats stats;
+	struct bpf_prog_kstats stats;
 	char __user *uinsns;
 	u32 ulen;
 	int err;
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index e5963de368ed34874414d097bc6614ff7e168dd3..e98de5e73ba59f756480cc5f962849be1859751b 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -545,7 +545,7 @@ static void notrace inc_misses_counter(struct bpf_prog *prog)
 
 	stats = this_cpu_ptr(prog->stats);
 	u64_stats_update_begin(&stats->syncp);
-	stats->misses++;
+	u64_stats_inc(&stats->misses);
 	u64_stats_update_end(&stats->syncp);
 }
 
@@ -590,8 +590,8 @@ static void notrace update_prog_stats(struct bpf_prog *prog,
 
 		stats = this_cpu_ptr(prog->stats);
 		flags = u64_stats_update_begin_irqsave(&stats->syncp);
-		stats->cnt++;
-		stats->nsecs += sched_clock() - start;
+		u64_stats_inc(&stats->cnt);
+		u64_stats_add(&stats->nsecs, sched_clock() - start);
 		u64_stats_update_end_irqrestore(&stats->syncp, flags);
 	}
 }
-- 
2.33.0.1079.g6e70778dc9-goog

