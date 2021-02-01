Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1387F30A72F
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 13:07:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbhBAMGL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 07:06:11 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11665 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbhBAMFo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 07:05:44 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DTmmn3R03zlF16;
        Mon,  1 Feb 2021 20:03:21 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.498.0; Mon, 1 Feb 2021
 20:04:56 +0800
From:   wanghongzhe <wanghongzhe@huawei.com>
To:     <keescook@chromium.org>, <luto@amacapital.net>, <wad@chromium.org>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: [PATCH] seccomp: Improve performance by optimizing memory barrier
Date:   Mon, 1 Feb 2021 20:49:41 +0800
Message-ID: <1612183781-15469-1-git-send-email-wanghongzhe@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a thread(A)'s TSYNC flag is set from seccomp(), then it will
synchronize its seccomp filter to other threads(B) in same thread
group. To avoid race condition, seccomp puts rmb() between
reading the mode and filter in seccomp check patch(in B thread).
As a result, every syscall's seccomp check is slowed down by the
memory barrier.

However, we can optimize it by calling rmb() only when filter is
NULL and reading it again after the barrier, which means the rmb()
is called only once in thread lifetime.

The 'filter is NULL' conditon means that it is the first time
attaching filter and is by other thread(A) using TSYNC flag.
In this case, thread B may read the filter first and mode later
in CPU out-of-order exection. After this time, the thread B's
mode is always be set, and there will no race condition with the
filter/bitmap.

In addtion, we should puts a write memory barrier between writing
the filter and mode in smp_mb__before_atomic(), to avoid
the race condition in TSYNC case.

Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
---
 kernel/seccomp.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 952dc1c90229..b944cb2b6b94 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -397,8 +397,20 @@ static u32 seccomp_run_filters(const struct seccomp_data *sd,
 			READ_ONCE(current->seccomp.filter);
 
 	/* Ensure unexpected behavior doesn't result in failing open. */
-	if (WARN_ON(f == NULL))
-		return SECCOMP_RET_KILL_PROCESS;
+	if (WARN_ON(f == NULL)) {
+		/*
+		 * Make sure the first filter addtion (from another
+		 * thread using TSYNC flag) are seen.
+		 */
+		rmb();
+		
+		/* Read again */
+		f = READ_ONCE(current->seccomp.filter);
+
+		/* Ensure unexpected behavior doesn't result in failing open. */
+		if (WARN_ON(f == NULL))
+			return SECCOMP_RET_KILL_PROCESS;
+	}
 
 	if (seccomp_cache_check_allow(f, sd))
 		return SECCOMP_RET_ALLOW;
@@ -614,9 +626,16 @@ static inline void seccomp_sync_threads(unsigned long flags)
 		 * equivalent (see ptrace_may_access), it is safe to
 		 * allow one thread to transition the other.
 		 */
-		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED)
+		if (thread->seccomp.mode == SECCOMP_MODE_DISABLED) {
+			/*
+			 * Make sure mode cannot be set before the filter
+			 * are set.
+			 */
+			smp_mb__before_atomic();
+
 			seccomp_assign_mode(thread, SECCOMP_MODE_FILTER,
 					    flags);
+		}
 	}
 }
 
@@ -1160,12 +1179,6 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	int data;
 	struct seccomp_data sd_local;
 
-	/*
-	 * Make sure that any changes to mode from another thread have
-	 * been seen after SYSCALL_WORK_SECCOMP was seen.
-	 */
-	rmb();
-
 	if (!sd) {
 		populate_seccomp_data(&sd_local);
 		sd = &sd_local;
-- 
2.19.1

