Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4053C13DB
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 15:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhGHNKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 09:10:16 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:37254 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230080AbhGHNKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 09:10:15 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Uf7.lIJ_1625749643;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0Uf7.lIJ_1625749643)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 08 Jul 2021 21:07:31 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v2] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'.
Date:   Thu,  8 Jul 2021 21:07:02 +0800
Message-Id: <1625749622-119334-1-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to enable the older kernel to use the CO-RE feature, load the
vmlinux btf of the specified path.

Learn from Andrii's comments in [0], add the btf_custom_path parameter
to bpf_obj_open_opts, you can directly use the skeleton's
<objname>_bpf__open_opts function to pass in the btf_custom_path
parameter.

Prior to this, there was also a developer who provided a patch with
similar functions. It is a pity that the follow-up did not continue to
advance. See [1].

	[0]https://lore.kernel.org/bpf/CAEf4BzbJZLjNoiK8_VfeVg_Vrg=9iYFv+po-38SMe=UzwDKJ=Q@mail.gmail.com/#t
	[1]https://yhbt.net/lore/all/CAEf4Bzbgw49w2PtowsrzKQNcxD4fZRE6AKByX-5-dMo-+oWHHA@mail.gmail.com/

Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Shuyi Cheng <chengshuyi@linux.alibaba.com>
---
v1: https://lore.kernel.org/bpf/CAEf4BzaGjEC4t1OefDo11pj2-HfNy0BLhs_G2UREjRNTmb2u=A@mail.gmail.com/t/#m4d9f7c6761fbd2b436b5dfe491cd864b70225804
v1->v2:
-- Change custom_btf_path to btf_custom_path.
-- If the length of btf_custom_path of bpf_obj_open_opts is too long, 
   return ERR_PTR(-ENAMETOOLONG).
-- Add `custom BTF is in addition to vmlinux BTF`
   with btf_custom_path field.

 tools/lib/bpf/libbpf.c | 27 ++++++++++++++++++++++++---
 tools/lib/bpf/libbpf.h |  6 +++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e04ce7..aed156c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -494,6 +494,10 @@ struct bpf_object {
 	struct btf *btf;
 	struct btf_ext *btf_ext;
 
+	/* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
+	 * feature in the old kernel).
+	 */
+	char *btf_custom_path;
 	/* Parse and load BTF vmlinux if any of the programs in the object need
 	 * it at load time.
 	 */
@@ -2679,8 +2683,15 @@ static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
 	if (!force && !obj_needs_vmlinux_btf(obj))
 		return 0;
 
-	obj->btf_vmlinux = libbpf_find_kernel_btf();
-	err = libbpf_get_error(obj->btf_vmlinux);
+	if (obj->btf_custom_path) {
+		obj->btf_vmlinux = btf__parse(obj->btf_custom_path, NULL);
+		err = libbpf_get_error(obj->btf_vmlinux);
+		pr_debug("loading custom vmlinux BTF '%s': %d\n", obj->btf_custom_path, err);
+	} else {
+		obj->btf_vmlinux = libbpf_find_kernel_btf();
+		err = libbpf_get_error(obj->btf_vmlinux);
+	}
+
 	if (err) {
 		pr_warn("Error loading vmlinux BTF: %d\n", err);
 		obj->btf_vmlinux = NULL;
@@ -7554,7 +7565,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
 {
-	const char *obj_name, *kconfig;
+	const char *obj_name, *kconfig, *btf_tmp_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char tmp_name[64];
@@ -7584,6 +7595,15 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 	obj = bpf_object__new(path, obj_buf, obj_buf_sz, obj_name);
 	if (IS_ERR(obj))
 		return obj;
+
+	btf_tmp_path = OPTS_GET(opts, btf_custom_path, NULL);
+	if (btf_tmp_path) {
+		if (strlen(btf_tmp_path) >= PATH_MAX)
+			return ERR_PTR(-ENAMETOOLONG);
+		obj->btf_custom_path = strdup(btf_tmp_path);
+		if (!obj->btf_custom_path)
+			return ERR_PTR(-ENOMEM);
+	}
 
 	kconfig = OPTS_GET(opts, kconfig, NULL);
 	if (kconfig) {
@@ -8702,6 +8722,7 @@ void bpf_object__close(struct bpf_object *obj)
 	for (i = 0; i < obj->nr_maps; i++)
 		bpf_map__destroy(&obj->maps[i]);
 
+	zfree(&obj->btf_custom_path);
 	zfree(&obj->kconfig);
 	zfree(&obj->externs);
 	obj->nr_extern = 0;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 6e61342..5002d1f 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -94,8 +94,12 @@ struct bpf_object_open_opts {
 	 * system Kconfig for CONFIG_xxx externs.
 	 */
 	const char *kconfig;
+	/* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
+	 * feature in the old kernel).
+	 */
+	char *btf_custom_path;
 };
-#define bpf_object_open_opts__last_field kconfig
+#define bpf_object_open_opts__last_field btf_custom_path
 
 LIBBPF_API struct bpf_object *bpf_object__open(const char *path);
 LIBBPF_API struct bpf_object *
-- 
1.8.3.1

