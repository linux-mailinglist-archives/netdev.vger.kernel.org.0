Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE07579589
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 10:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237097AbiGSIuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 04:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235378AbiGSIuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 04:50:11 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C32B101D;
        Tue, 19 Jul 2022 01:50:07 -0700 (PDT)
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LnC9P4XPTzVgHp;
        Tue, 19 Jul 2022 16:46:17 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 16:49:45 +0800
Received: from localhost.localdomain (10.175.112.70) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 19 Jul 2022 16:49:45 +0800
From:   Xu Jia <xujia39@huawei.com>
To:     <sdf@google.com>, <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <xujia39@huawei.com>
Subject: [PATCH bpf-next] bpf: fix bpf compile error caused by CONFIG_CGROUP_BPF
Date:   Tue, 19 Jul 2022 17:01:45 +0800
Message-ID: <1658221305-35718-1-git-send-email-xujia39@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We failed to compile when CONFIG_BPF_LSM is enabled but CONFIG_CGROUP_BPF
is not set. The failings are shown as below:

kernel/bpf/trampoline.o: in function `bpf_trampoline_link_cgroup_shim'
trampoline.c: undefined reference to `bpf_cgroup_atype_get'
kernel/bpf/bpf_lsm.o: In function `bpf_lsm_find_cgroup_shim':
bpf_lsm.c: undefined reference to `__cgroup_bpf_run_lsm_current'
bpf_lsm.c: undefined reference to `__cgroup_bpf_run_lsm_sock'
bpf_lsm.c: undefined reference to `__cgroup_bpf_run_lsm_socket'

Fix them by protecting these functions with CONFIG_CGROUP_BPF.

Fixes: 69fd337a975c ("bpf: per-cgroup lsm flavor")
Signed-off-by: Xu Jia <xujia39@huawei.com>
---
 include/linux/bpf.h     | 12 +++++++++---
 include/linux/bpf_lsm.h | 10 ++++++----
 kernel/bpf/bpf_lsm.c    |  2 ++
 kernel/bpf/trampoline.c |  2 ++
 4 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 2b21f2a3452f..add8895c02cc 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1255,9 +1255,7 @@ struct bpf_dummy_ops {
 int bpf_struct_ops_test_run(struct bpf_prog *prog, const union bpf_attr *kattr,
 			    union bpf_attr __user *uattr);
 #endif
-int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
-				    int cgroup_atype);
-void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
+
 #else
 static inline const struct bpf_struct_ops *bpf_struct_ops_find(u32 type_id)
 {
@@ -1281,6 +1279,14 @@ static inline int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map,
 {
 	return -EINVAL;
 }
+#endif
+
+#if defined(CONFIG_BPF_JIT) && defined(CONFIG_BPF_SYSCALL) && \
+    defined(CONFIG_CGROUP_BPF)
+int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
+				    int cgroup_atype);
+void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog);
+#else
 static inline int bpf_trampoline_link_cgroup_shim(struct bpf_prog *prog,
 						  int cgroup_atype)
 {
diff --git a/include/linux/bpf_lsm.h b/include/linux/bpf_lsm.h
index 4bcf76a9bb06..bed45a0c8a9c 100644
--- a/include/linux/bpf_lsm.h
+++ b/include/linux/bpf_lsm.h
@@ -42,8 +42,6 @@ extern const struct bpf_func_proto bpf_inode_storage_get_proto;
 extern const struct bpf_func_proto bpf_inode_storage_delete_proto;
 void bpf_inode_storage_free(struct inode *inode);
 
-void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
-
 #else /* !CONFIG_BPF_LSM */
 
 static inline bool bpf_lsm_is_sleepable_hook(u32 btf_id)
@@ -67,11 +65,15 @@ static inline void bpf_inode_storage_free(struct inode *inode)
 {
 }
 
+#endif /* CONFIG_BPF_LSM */
+
+#if defined(CONFIG_BPF_LSM) && defined(CONFIG_BPF_CGROUP)
+void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog, bpf_func_t *bpf_func);
+#else
 static inline void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 					   bpf_func_t *bpf_func)
 {
 }
-
-#endif /* CONFIG_BPF_LSM */
+#endif
 
 #endif /* _LINUX_BPF_LSM_H */
diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index d469b7f3deef..29527828b38b 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -63,6 +63,7 @@ BTF_ID(func, bpf_lsm_socket_post_create)
 BTF_ID(func, bpf_lsm_socket_socketpair)
 BTF_SET_END(bpf_lsm_unlocked_sockopt_hooks)
 
+#ifdef CONFIG_BPF_CGROUP
 void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 			     bpf_func_t *bpf_func)
 {
@@ -86,6 +87,7 @@ void bpf_lsm_find_cgroup_shim(const struct bpf_prog *prog,
 #endif
 		*bpf_func = __cgroup_bpf_run_lsm_current;
 }
+#endif /* CONFIG_BPF_CGROUP */
 
 int bpf_lsm_verify_prog(struct bpf_verifier_log *vlog,
 			const struct bpf_prog *prog)
diff --git a/kernel/bpf/trampoline.c b/kernel/bpf/trampoline.c
index 6cd226584c33..127924711935 100644
--- a/kernel/bpf/trampoline.c
+++ b/kernel/bpf/trampoline.c
@@ -525,6 +525,7 @@ static const struct bpf_link_ops bpf_shim_tramp_link_lops = {
 	.dealloc = bpf_shim_tramp_link_dealloc,
 };
 
+#ifdef CONFIG_CGROUP_BPF
 static struct bpf_shim_tramp_link *cgroup_shim_alloc(const struct bpf_prog *prog,
 						     bpf_func_t bpf_func,
 						     int cgroup_atype)
@@ -668,6 +669,7 @@ void bpf_trampoline_unlink_cgroup_shim(struct bpf_prog *prog)
 
 	bpf_trampoline_put(tr); /* bpf_trampoline_lookup above */
 }
+#endif /* CONFIG_CGROUP_BPF */
 #endif
 
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
-- 
2.25.1

