Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01F6632385F
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 09:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234185AbhBXIMJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 03:12:09 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12201 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234091AbhBXILz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 03:11:55 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DlpTs0c4tzlNZ3;
        Wed, 24 Feb 2021 16:09:05 +0800 (CST)
Received: from huawei.com (10.175.124.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.498.0; Wed, 24 Feb 2021
 16:10:56 +0800
From:   wanghongzhe <wanghongzhe@huawei.com>
To:     <keescook@chromium.org>, <luto@amacapital.net>
CC:     <andrii@kernel.org>, <ast@kernel.org>, <bpf@vger.kernel.org>,
        <daniel@iogearbox.net>, <john.fastabend@gmail.com>, <kafai@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <songliubraving@fb.com>,
        <wad@chromium.org>, <wanghongzhe@huawei.com>, <yhs@fb.com>
Subject: [PATCH v3] seccomp: Improve performace by optimizing rmb()
Date:   Wed, 24 Feb 2021 16:58:05 +0800
Message-ID: <1614157085-18952-1-git-send-email-wanghongzhe@huawei.com>
X-Mailer: git-send-email 1.7.12.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As Kees haved accepted the v2 patch at a381b70a1 which just
replaced rmb() with smp_rmb(), this patch will base on that and just adjust
the smp_rmb() to the correct position.

As the original comment shown (and indeed it should be):
   /*
    * Make sure that any changes to mode from another thread have
    * been seen after SYSCALL_WORK_SECCOMP was seen.
    */
the smp_rmb() should be put between reading SYSCALL_WORK_SECCOMP and reading
seccomp.mode to make sure that any changes to mode from another thread have
been seen after SYSCALL_WORK_SECCOMP was seen, for TSYNC situation. However,
it is misplaced between reading seccomp.mode and seccomp->filter. This issue
seems to be misintroduced at 13aa72f0fd0a9f98a41cefb662487269e2f1ad65 which
aims to refactor the filter callback and the API. So let's just adjust the
smp_rmb() to the correct position.

A next optimization patch will be provided if this ajustment is appropriate.

v2 -> v3:
 - move the smp_rmb() to the correct position

v1 -> v2:
 - only replace rmb() with smp_rmb()
 - provide the performance test number

RFC -> v1:
 - replace rmb() with smp_rmb()
 - move the smp_rmb() logic to the middle between TIF_SECCOMP and mode

Signed-off-by: wanghongzhe <wanghongzhe@huawei.com>
---
 kernel/seccomp.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 1d60fc2c9987..64b236cb8a7f 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1160,12 +1160,6 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	int data;
 	struct seccomp_data sd_local;
 
-	/*
-	 * Make sure that any changes to mode from another thread have
-	 * been seen after SYSCALL_WORK_SECCOMP was seen.
-	 */
-	smp_rmb();
-
 	if (!sd) {
 		populate_seccomp_data(&sd_local);
 		sd = &sd_local;
@@ -1291,7 +1285,6 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 
 int __secure_computing(const struct seccomp_data *sd)
 {
-	int mode = current->seccomp.mode;
 	int this_syscall;
 
 	if (IS_ENABLED(CONFIG_CHECKPOINT_RESTORE) &&
@@ -1301,7 +1294,13 @@ int __secure_computing(const struct seccomp_data *sd)
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
-- 
2.19.1

