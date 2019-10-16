Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EED7AD84FC
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390362AbfJPAmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:42:02 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53360 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390304AbfJPAlu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:41:50 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKXNr-00065g-Qz; Wed, 16 Oct 2019 00:41:47 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     christian.brauner@ubuntu.com
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v2 3/3] bpf: use copy_struct_from_user() in bpf() syscall
Date:   Wed, 16 Oct 2019 02:41:38 +0200
Message-Id: <20191016004138.24845-4-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016004138.24845-1-christian.brauner@ubuntu.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
 <20191016004138.24845-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
This helper is intended for all codepaths that copy structs from
userspace that are versioned by size. The bpf() syscall does exactly
what copy_struct_from_user() is doing.
Note that copy_struct_from_user() is calling min() already. So
technically, the min_t() call could go. But the size is used further
below so leave it.

[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org
Acked-by: Aleksa Sarai <cyphar@cyphar.com>
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v1 */
Link: https://lore.kernel.org/r/20191009160907.10981-4-christian.brauner@ubuntu.com

/* v2 */
- Alexei Starovoitov <ast@kernel.org>:
  - remove unneeded initialization
---
 kernel/bpf/syscall.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 45524089e15d..5db9887a8f4c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2817,20 +2817,17 @@ static int bpf_task_fd_query(const union bpf_attr *attr,
 
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
-	union bpf_attr attr = {};
+	union bpf_attr attr;
 	int err;
 
 	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	err = bpf_check_uarg_tail_zero(uattr, sizeof(attr), size);
-	if (err)
-		return err;
 	size = min_t(u32, size, sizeof(attr));
-
 	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
-	if (copy_from_user(&attr, uattr, size) != 0)
-		return -EFAULT;
+	err = copy_struct_from_user(&attr, sizeof(attr), uattr, size);
+	if (err)
+		return err;
 
 	err = security_bpf(cmd, &attr, size);
 	if (err < 0)
-- 
2.23.0

