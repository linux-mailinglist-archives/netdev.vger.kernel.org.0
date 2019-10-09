Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB03AD13A5
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 18:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731785AbfJIQJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 12:09:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41924 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731686AbfJIQJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 12:09:16 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIEWX-00034Q-U1; Wed, 09 Oct 2019 16:09:13 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 3/3] bpf: use copy_struct_from_user() in bpf() syscall
Date:   Wed,  9 Oct 2019 18:09:07 +0200
Message-Id: <20191009160907.10981-4-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191009160907.10981-1-christian.brauner@ubuntu.com>
References: <20191009160907.10981-1-christian.brauner@ubuntu.com>
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
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
 kernel/bpf/syscall.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 6f4f9097b1fe..6fdcbdb27501 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2819,14 +2819,11 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, siz
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

