Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28B1F50FF57
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 15:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351043AbiDZNoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 09:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351092AbiDZNn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 09:43:58 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0AF3D498;
        Tue, 26 Apr 2022 06:40:46 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Knjgg70YgzhYhy;
        Tue, 26 Apr 2022 21:40:31 +0800 (CST)
Received: from dggpemm500019.china.huawei.com (7.185.36.180) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 21:40:44 +0800
Received: from k04.huawei.com (10.67.174.115) by
 dggpemm500019.china.huawei.com (7.185.36.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Apr 2022 21:40:44 +0800
From:   Pu Lehui <pulehui@huawei.com>
To:     <bpf@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <bjorn@kernel.org>, <luke.r.nels@gmail.com>, <xi.wang@gmail.com>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
        <aou@eecs.berkeley.edu>, <pulehui@huawei.com>
Subject: [PATCH -next 1/2] bpf: Unify data extension operation of jited_ksyms and jited_linfo
Date:   Tue, 26 Apr 2022 22:09:23 +0800
Message-ID: <20220426140924.3308472-2-pulehui@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220426140924.3308472-1-pulehui@huawei.com>
References: <20220426140924.3308472-1-pulehui@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.115]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500019.china.huawei.com (7.185.36.180)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found that 32-bit environment can not print bpf line info due
to data inconsistency between jited_ksyms[0] and jited_linfo[0].

For example:
jited_kyms[0] = 0xb800067c, jited_linfo[0] = 0xffffffffb800067c

We know that both of them store bpf func address, but due to the
different data extension operations when extended to u64, they may
not be the same. We need to unify the data extension operations of
them.

Signed-off-by: Pu Lehui <pulehui@huawei.com>
---
 kernel/bpf/syscall.c                         |  5 ++++-
 tools/lib/bpf/bpf_prog_linfo.c               |  8 ++++----
 tools/testing/selftests/bpf/prog_tests/btf.c | 18 +++++++++---------
 3 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e9621cfa09f2..4c417c806d92 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3868,13 +3868,16 @@ static int bpf_prog_get_info_by_fd(struct file *file,
 		info.nr_jited_line_info = 0;
 	if (info.nr_jited_line_info && ulen) {
 		if (bpf_dump_raw_ok(file->f_cred)) {
+			unsigned long jited_linfo_addr;
 			__u64 __user *user_linfo;
 			u32 i;
 
 			user_linfo = u64_to_user_ptr(info.jited_line_info);
 			ulen = min_t(u32, info.nr_jited_line_info, ulen);
 			for (i = 0; i < ulen; i++) {
-				if (put_user((__u64)(long)prog->aux->jited_linfo[i],
+				jited_linfo_addr = (unsigned long)
+					prog->aux->jited_linfo[i];
+				if (put_user((__u64) jited_linfo_addr,
 					     &user_linfo[i]))
 					return -EFAULT;
 			}
diff --git a/tools/lib/bpf/bpf_prog_linfo.c b/tools/lib/bpf/bpf_prog_linfo.c
index 5c503096ef43..5cf41a563ef5 100644
--- a/tools/lib/bpf/bpf_prog_linfo.c
+++ b/tools/lib/bpf/bpf_prog_linfo.c
@@ -127,7 +127,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	prog_linfo->raw_linfo = malloc(data_sz);
 	if (!prog_linfo->raw_linfo)
 		goto err_free;
-	memcpy(prog_linfo->raw_linfo, (void *)(long)info->line_info, data_sz);
+	memcpy(prog_linfo->raw_linfo, (void *)(unsigned long)info->line_info, data_sz);
 
 	nr_jited_func = info->nr_jited_ksyms;
 	if (!nr_jited_func ||
@@ -148,7 +148,7 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 	if (!prog_linfo->raw_jited_linfo)
 		goto err_free;
 	memcpy(prog_linfo->raw_jited_linfo,
-	       (void *)(long)info->jited_line_info, data_sz);
+	       (void *)(unsigned long)info->jited_line_info, data_sz);
 
 	/* Number of jited_line_info per jited func */
 	prog_linfo->nr_jited_linfo_per_func = malloc(nr_jited_func *
@@ -166,8 +166,8 @@ struct bpf_prog_linfo *bpf_prog_linfo__new(const struct bpf_prog_info *info)
 		goto err_free;
 
 	if (dissect_jited_func(prog_linfo,
-			       (__u64 *)(long)info->jited_ksyms,
-			       (__u32 *)(long)info->jited_func_lens))
+			       (__u64 *)(unsigned long)info->jited_ksyms,
+			       (__u32 *)(unsigned long)info->jited_func_lens))
 		goto err_free;
 
 	return prog_linfo;
diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
index 84aae639ddb5..d9ba1ec1d5b3 100644
--- a/tools/testing/selftests/bpf/prog_tests/btf.c
+++ b/tools/testing/selftests/bpf/prog_tests/btf.c
@@ -6451,8 +6451,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 		  info.nr_jited_line_info, jited_cnt,
 		  info.line_info_rec_size, rec_size,
 		  info.jited_line_info_rec_size, jited_rec_size,
-		  (void *)(long)info.line_info,
-		  (void *)(long)info.jited_line_info)) {
+		  (void *)(unsigned long)info.line_info,
+		  (void *)(unsigned long)info.jited_line_info)) {
 		err = -1;
 		goto done;
 	}
@@ -6500,8 +6500,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 	}
 
 	if (CHECK(jited_linfo[0] != jited_ksyms[0],
-		  "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
-		  (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
+		  "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
+		  jited_linfo[0], jited_ksyms[0])) {
 		err = -1;
 		goto done;
 	}
@@ -6519,16 +6519,16 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
 		}
 
 		if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
-			  "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
-			  i, (long)jited_linfo[i],
-			  i - 1, (long)(jited_linfo[i - 1]))) {
+			  "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
+			  i, jited_linfo[i],
+			  i - 1, (jited_linfo[i - 1]))) {
 			err = -1;
 			goto done;
 		}
 
 		if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
-			  "jited_linfo[%u]:%lx - %lx > %u",
-			  i, (long)jited_linfo[i], (long)cur_func_ksyms,
+			  "jited_linfo[%u]:%llx - %llx > %u",
+			  i, jited_linfo[i], cur_func_ksyms,
 			  cur_func_len)) {
 			err = -1;
 			goto done;
-- 
2.25.1

