Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0826743029A
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 14:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240422AbhJPMfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 08:35:18 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:25195 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235124AbhJPMfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 08:35:17 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HWjF94kNVz8tV5;
        Sat, 16 Oct 2021 20:31:57 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 16 Oct 2021 20:33:07 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 16 Oct
 2021 20:33:07 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next v2 1/5] bpf: factor out a helper to prepare trampoline for struct_ops prog
Date:   Sat, 16 Oct 2021 20:48:02 +0800
Message-ID: <20211016124806.1547989-2-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20211016124806.1547989-1-houtao1@huawei.com>
References: <20211016124806.1547989-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Factor out a helper bpf_struct_ops_prepare_trampoline() to prepare
trampoline for BPF_PROG_TYPE_STRUCT_OPS prog. It will be used by
.test_run callback in following patch.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h         |  4 ++++
 kernel/bpf/bpf_struct_ops.c | 29 +++++++++++++++++++----------
 2 files changed, 23 insertions(+), 10 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index d604c8251d88..b7c1e2bc93f7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -998,6 +998,10 @@ bool bpf_struct_ops_get(const void *kdata);
 void bpf_struct_ops_put(const void *kdata);
 int bpf_struct_ops_map_sys_lookup_elem(struct bpf_map *map, void *key,
 				       void *value);
+int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_progs *tprogs,
+				      struct bpf_prog *prog,
+				      const struct btf_func_model *model,
+				      void *image, void *image_end);
 static inline bool bpf_try_module_get(const void *data, struct module *owner)
 {
 	if (owner == BPF_MODULE_OWNER)
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 9abcc33f02cf..44be101f2562 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -312,6 +312,20 @@ static int check_zero_holes(const struct btf_type *t, void *data)
 	return 0;
 }
 
+int bpf_struct_ops_prepare_trampoline(struct bpf_tramp_progs *tprogs,
+				      struct bpf_prog *prog,
+				      const struct btf_func_model *model,
+				      void *image, void *image_end)
+{
+	u32 flags;
+
+	tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
+	tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
+	flags = model->ret_size > 0 ? BPF_TRAMP_F_RET_FENTRY_RET : 0;
+	return arch_prepare_bpf_trampoline(NULL, image, image_end,
+					   model, flags, tprogs, NULL);
+}
+
 static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 					  void *value, u64 flags)
 {
@@ -323,7 +337,7 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 	struct bpf_tramp_progs *tprogs = NULL;
 	void *udata, *kdata;
 	int prog_fd, err = 0;
-	void *image;
+	void *image, *image_end;
 	u32 i;
 
 	if (flags)
@@ -363,12 +377,12 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 	udata = &uvalue->data;
 	kdata = &kvalue->data;
 	image = st_map->image;
+	image_end = st_map->image + PAGE_SIZE;
 
 	for_each_member(i, t, member) {
 		const struct btf_type *mtype, *ptype;
 		struct bpf_prog *prog;
 		u32 moff;
-		u32 flags;
 
 		moff = btf_member_bit_offset(t, member) / 8;
 		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
@@ -430,14 +444,9 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 			goto reset_unlock;
 		}
 
-		tprogs[BPF_TRAMP_FENTRY].progs[0] = prog;
-		tprogs[BPF_TRAMP_FENTRY].nr_progs = 1;
-		flags = st_ops->func_models[i].ret_size > 0 ?
-			BPF_TRAMP_F_RET_FENTRY_RET : 0;
-		err = arch_prepare_bpf_trampoline(NULL, image,
-						  st_map->image + PAGE_SIZE,
-						  &st_ops->func_models[i],
-						  flags, tprogs, NULL);
+		err = bpf_struct_ops_prepare_trampoline(tprogs, prog,
+							&st_ops->func_models[i],
+							image, image_end);
 		if (err < 0)
 			goto reset_unlock;
 
-- 
2.29.2

