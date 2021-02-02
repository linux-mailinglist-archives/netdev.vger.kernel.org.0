Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44AE30BAF1
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 10:29:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhBBJ33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 04:29:29 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:12006 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhBBJ3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 04:29:19 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4DVKGC1hlszjHBK;
        Tue,  2 Feb 2021 17:27:15 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.498.0; Tue, 2 Feb 2021
 17:28:23 +0800
From:   wanghongzhe <wanghongzhe@huawei.com>
To:     <luto@amacapital.net>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <keescook@chromium.org>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <songliubraving@fb.com>, <wad@chromium.org>,
        <wanghongzhe@huawei.com>, <yhs@fb.com>
Subject: [PATCH v1 1/1] Firstly, as Andy mentioned, this should be smp_rmb() instead of rmb(). considering that TSYNC is a cross-thread situation, and rmb() is a mandatory barrier which should not be used to control SMP effects, since mandatory barriers impose unnecessary overhead on both SMP and UP systems, as kernel Documentation said.
Date:   Tue, 2 Feb 2021 18:13:07 +0800
Message-ID: <1612260787-28015-1-git-send-email-wanghongzhe@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
References: <B1DC6A42-15AF-4804-B20E-FC6E2BDD1C8E@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Secondly, the smp_rmb() should be put between reading SYSCALL_WORK_SECCOMP and reading
seccomp.mode, not between reading seccomp.mode and seccomp->filter, to make
sure that any changes to mode from another thread have been seen after
SYSCALL_WORK_SECCOMP was seen, as the original comment shown. This issue seems to be
misintroduced at 13aa72f0fd0a9f98a41cefb662487269e2f1ad65 which aims to
refactor the filter callback and the API. So the intuitive solution is to put
it back like:

Thirdly, however, we can go further to improve the performace of checking
syscall, considering that smp_rmb is always executed on the syscall-check
path at each time for both FILTER and STRICT check while the TSYNC case
which may lead to race condition is just a rare situation, and that in
some arch like Arm64 smp_rmb is dsb(ishld) not a cheap barrier() in x86-64.

As a result, smp_rmb() should only be executed when necessary, e.g, it is
only necessary when current thread's mode is SECCOMP_MODE_DISABLED at the
first TYSNCed time, because after that the current thread's mode will always
be SECCOMP_MODE_FILTER (and SYSCALL_WORK_SECCOMP will always be set) and can not be
changed anymore by anyone. In other words, after that, any thread can not
change the mode (and SYSCALL_WORK_SECCOMP), so the race condition disappeared, and
no more smb_rmb() needed ever.

So the solution is to read mode again behind smp_rmb() after the mode is seen
as SECCOMP_MODE_DISABLED by current thread at the first TSYNCed time, and if
the new mode don't equals to SECCOMP_MODE_FILTER, do BUG(), go to FILTER path
otherwise.

RFC -> v1:
 - replace rmb() with smp_rmb()
 - move the smp_rmb() logic to the middle between SYSCALL_WORK_SECCOMP and mode

Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/seccomp.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 952dc1c90229..a621fb913ec6 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1160,12 +1160,6 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
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
@@ -1289,7 +1283,6 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 int __secure_computing(const struct seccomp_data *sd)
 {
-	int mode = current->seccomp.mode;
 	int this_syscall;
 
 	if (IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) &&
@@ -1299,10 +1292,26 @@ int __secure_computing(const struct seccomp_data *sd)
 	this_syscall = sd ? sd->nr :
 		syscall_get_nr(current, current_pt_regs());
 
-	switch (mode) {
+	/*
+	 * Make sure that any changes to mode from another thread have
+	 * been seen after SYSCALL_WORK_SECCOMP was seen.
+	 */
+	smp_rmb();
+
+	switch (current->seccomp.mode) {
 	case SECCOMP_MODE_STRICT:
 		__secure_computing_strict(this_syscall);  /* may call do_exit */
 		return 0;
+	/*
+	 * Make sure that change to mode (from SECCOMP_MODE_DISABLED to
+	 * SECCOMP_MODE_FILTER) from another thread using TSYNC ability
+	 * have been seen after SYSCALL_WORK_SECCOMP was seen. Read mode again behind
+	 * smp_rmb(), if it equals SECCOMP_MODE_FILTER, go to the right path.
+	 */
+	case SECCOMP_MODE_DISABLED:
+		smp_rmb();
+		if (unlikely(current->seccomp.mode != SECCOMP_MODE_FILTER))
+			BUG();
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, sd, false);
 	default:
-- 
2.19.1

