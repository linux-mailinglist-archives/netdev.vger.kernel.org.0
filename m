Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 044B5D8F35
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 13:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392749AbfJPLTW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 07:19:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40233 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392705AbfJPLTU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 07:19:20 -0400
Received: from [213.220.153.21] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iKhKo-0003tb-R7; Wed, 16 Oct 2019 11:19:18 +0000
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     christian.brauner@ubuntu.com
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        kafai@fb.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, yhs@fb.com, Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH bpf-next v4 2/3] bpf: use copy_struct_from_user() in bpf_prog_get_info_by_fd()
Date:   Wed, 16 Oct 2019 13:18:09 +0200
Message-Id: <20191016111810.1799-3-christian.brauner@ubuntu.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016111810.1799-1-christian.brauner@ubuntu.com>
References: <20191016034432.4418-1-christian.brauner@ubuntu.com>
 <20191016111810.1799-1-christian.brauner@ubuntu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In v5.4-rc2 we added a new helper (cf. [1]) copy_struct_from_user().
This helper is intended for all codepaths that copy structs from
userspace that are versioned by size. bpf_prog_get_info_by_fd() does
exactly what copy_struct_from_user() is doing.
Note that copy_struct_from_user() is calling min() already. So
technically, the min_t() call could go. But the info_len is used further
below so leave it.

[1]: f5a1a536fa14 ("lib: introduce copy_struct_from_user() helper")
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: bpf@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
---
/* v1 */
Link: https://lore.kernel.org/r/20191009160907.10981-3-christian.brauner@ubuntu.com

/* v2 */
Link: https://lore.kernel.org/r/20191016004138.24845-3-christian.brauner@ubuntu.com
- Alexei Starovoitov <ast@kernel.org>:
  - remove unneeded initialization

/* v3 */
Link: https://lore.kernel.org/r/20191016034432.4418-3-christian.brauner@ubuntu.com
unchanged

/* v4 */
- Alexei Starovoitov <ast@kernel.org>:
  - move misplaced min after copy_struct_from_user()
---
 kernel/bpf/syscall.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8d112bc069c0..d554ca7671b6 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2304,21 +2304,18 @@ static int bpf_prog_get_info_by_fd(struct bpf_prog *prog,
 				   union bpf_attr __user *uattr)
 {
 	struct bpf_prog_info __user *uinfo = u64_to_user_ptr(attr->info.info);
-	struct bpf_prog_info info = {};
+	struct bpf_prog_info info;
 	u32 info_len = attr->info.info_len;
 	struct bpf_prog_stats stats;
 	char __user *uinsns;
 	u32 ulen;
 	int err;
 
-	err = bpf_check_uarg_tail_zero(uinfo, sizeof(info), info_len);
+	err = copy_struct_from_user(&info, sizeof(info), uinfo, info_len);
 	if (err)
 		return err;
 	info_len = min_t(u32, sizeof(info), info_len);
 
-	if (copy_from_user(&info, uinfo, info_len))
-		return -EFAULT;
-
 	info.type = prog->type;
 	info.id = prog->aux->id;
 	info.load_time = prog->aux->load_time;
-- 
2.23.0

