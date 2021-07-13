Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 689CA3C709C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 14:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236303AbhGMMq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 08:46:27 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:40102 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236268AbhGMMq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 08:46:26 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R741e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Ufgcb2l_1626180206;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0Ufgcb2l_1626180206)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Jul 2021 20:43:34 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v4 1/3] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
Date:   Tue, 13 Jul 2021 20:42:37 +0800
Message-Id: <1626180159-112996-2-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
References: <1626180159-112996-1-git-send-email-chengshuyi@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

btf_custom_path allows developers to load custom BTF, and subsequent 
CO-RE will use custom BTF for relocation.

Learn from Andrii's comments in [0], add the btf_custom_path parameter
to bpf_obj_open_opts, you can directly use the skeleton's
<objname>_bpf__open_opts function to pass in the btf_custom_path
parameter.

Prior to this, there was also a developer who provided a patch with
similar functions. It is a pity that the follow-up did not continue to
advance. See [1].

	[0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
	[1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/

Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
---
 tools/lib/bpf/libbpf.c | 36 ++++++++++++++++++++++++++++++------
 tools/lib/bpf/libbpf.h |  9 ++++++++-
 2 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e04ce7..6e11a7b 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -498,6 +498,13 @@ struct bpf_object {
 	 * it at load time.
 	 */
 	struct btf *btf_vmlinux;
+	/* Path to the custom BTF to be used for BPF CO-RE relocations.
+	 * This custom BTF completely replaces the use of vmlinux BTF
+	 * for the purpose of CO-RE relocations.
+	 * NOTE: any other BPF feature (e.g., fentry/fexit programs,
+	 * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
+	 */
+	char *btf_custom_path;
 	/* vmlinux BTF override for CO-RE relocations */
 	struct btf *btf_vmlinux_override;
 	/* Lazily initialized kernel module BTFs */
@@ -2645,10 +2652,6 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
 	struct bpf_program *prog;
 	int i;
 
-	/* CO-RE relocations need kernel BTF */
-	if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
-		return true;
-
 	/* Support for typed ksyms needs kernel BTF */
 	for (i = 0; i < obj->nr_extern; i++) {
 		const struct extern_desc *ext;
@@ -2665,6 +2668,13 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
 			return true;
 	}
 
+	/* CO-RE relocations need kernel BTF, only when btf_custom_path
+	 * is not specified
+	 */
+	if (obj->btf_ext && obj->btf_ext->core_relo_info.len
+		&& !obj->btf_custom_path)
+		return true;
+
 	return false;
 }
 
@@ -7554,7 +7564,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
 {
-	const char *obj_name, *kconfig;
+	const char *obj_name, *kconfig, *btf_tmp_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char tmp_name[64];
@@ -7584,6 +7594,19 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 	obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
 	if (IS_ERR(obj))
 		return obj;
+
+	btf_tmp_path = OPTS_GET(opts, btf_custom_path, NULL);
+	if (btf_tmp_path) {
+		if (strlen(btf_tmp_path) >= PATH_MAX) {
+			err = -ENAMETOOLONG;
+			goto out;
+		}
+		obj->btf_custom_path = strdup(btf_tmp_path);
+		if (!obj->btf_custom_path) {
+			err = -ENOMEM;
+			goto out;
+		}
+	}
 
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
@@ -8055,7 +8078,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	err = err ? : bpf_object__sanitize_maps(obj);
 	err = err ? : bpf_object__init_kern_struct_ops_maps(obj);
 	err = err ? : bpf_object__create_maps(obj);
-	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
+	err = err ? : bpf_object__relocate(obj, obj->btf_custom_path ? : attr->target_btf_path);
 	err = err ? : bpf_object__load_progs(obj, attr->log_level);
 
 	if (obj->gen_loader) {
@@ -8702,6 +8725,7 @@ void bpf_object__close(struct bpf_object *obj)
 	for (i = 0; i < obj->nr_maps; i++)
 		bpf_map__destroy(&obj->maps[i]);
 
+	zfree(&obj->btf_custom_path);
 	zfree(&obj->kconfig);
 	zfree(&obj->externs);
 	obj->nr_extern = 0;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6e61342..102ee8e 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -94,8 +94,15 @@ struct bpf_object_open_opts {
 	 * system Kconfig for CONFIG_xxx externs.
 	 */
 	const char *kconfig;
+	/* Path to the custom BTF to be used for BPF CO-RE relocations.
+	 * This custom BTF completely replaces the use of vmlinux BTF
+	 * for the purpose of CO-RE relocations.
+	 * NOTE: any other BPF feature (e.g., fentry/fexit programs,
+	 * struct_ops, etc) will need actual kernel BTF at /sys/kernel/btf/vmlinux.
+	 */
+	char *btf_custom_path;
 };
-#define bpf_object_open_opts__last_field kconfig
+#define bpf_object_open_opts__last_field btf_custom_path
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
-- 
1.8.3.1

