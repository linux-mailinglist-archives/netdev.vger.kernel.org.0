Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55FEC41A5A0
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 04:38:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238778AbhI1CkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 22:40:17 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:13344 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238733AbhI1CkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 22:40:13 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HJNqR3sV0z8ywj;
        Tue, 28 Sep 2021 10:33:55 +0800 (CST)
Received: from dggpeml500025.china.huawei.com (7.185.36.35) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Tue, 28 Sep 2021 10:38:31 +0800
Received: from huawei.com (10.175.124.27) by dggpeml500025.china.huawei.com
 (7.185.36.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Tue, 28 Sep
 2021 10:38:30 +0800
From:   Hou Tao <houtao1@huawei.com>
To:     Martin KaFai Lau <kafai@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <houtao1@huawei.com>
Subject: [PATCH bpf-next 2/5] bpf: factor out a helper to prepare trampoline for struct_ops prog
Date:   Tue, 28 Sep 2021 10:52:25 +0800
Message-ID: <20210928025228.88673-3-houtao1@huawei.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210928025228.88673-1-houtao1@huawei.com>
References: <20210928025228.88673-1-houtao1@huawei.com>
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

Factor out a helper bpf_prepare_st_ops_prog() to prepare trampoline
for BPF_PROG_TYPE_STRUCT_OPS prog. It will be used by .test_run
callback in following patch.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 include/linux/bpf.h         |  5 +++++
 kernel/bpf/bpf_struct_ops.c | 26 +++++++++++++++++---------
 2 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 155dfcfb8923..002bbb2c8bc7 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -2224,4 +2224,9 @@ int bpf_bprintf_prepare(char *fmt, u32 fmt_size, const u64 *raw_args,
 			u32 **bin_buf, u32 num_args);
 void bpf_bprintf_cleanup(void);
 
+int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
+			    struct bpf_prog *prog,
+			    const struct btf_func_model *model,
+			    void *image, void *image_end);
+
 #endif /* _LINUX_BPF_H */
diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 9abcc33f02cf..ec3c25174923 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -312,6 +312,20 @@ static int check_zero_holes(const struct btf_type *t, void *data)
 	return 0;
 }
 
+int bpf_prepare_st_ops_prog(struct bpf_tramp_progs *tprogs,
+			    struct bpf_prog *prog,
+			    const struct btf_func_model *model,
+			    void *image, void *image_end)
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
@@ -368,7 +382,6 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
 		const struct btf_type *mtype, *ptype;
 		struct bpf_prog *prog;
 		u32 moff;
-		u32 flags;
 
 		moff = btf_member_bit_offset(t, member) / 8;
 		ptype = btf_type_resolve_ptr(btf_vmlinux, member->type, NULL);
@@ -430,14 +443,9 @@ static int bpf_struct_ops_map_update_elem(struct bpf_map *map, void *key,
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
+		err = bpf_prepare_st_ops_prog(tprogs, prog,
+					      &st_ops->func_models[i],
+					      image, st_map->image + PAGE_SIZE);
 		if (err < 0)
 			goto reset_unlock;
 
-- 
2.29.2

