Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC083C1D97
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 04:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231144AbhGICu5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 22:50:57 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:40926 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230400AbhGICu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 22:50:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R261e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=chengshuyi@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0UfAWxPe_1625798886;
Received: from localhost(mailfrom:chengshuyi@linux.alibaba.com fp:SMTPD_---0UfAWxPe_1625798886)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 09 Jul 2021 10:48:12 +0800
From:   Shuyi Cheng <chengshuyi@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Shuyi Cheng <chengshuyi@linux.alibaba.com>
Subject: [PATCH bpf-next v3 1/2] libbpf: Introduce 'btf_custom_path' to 'bpf_obj_open_opts'
Date:   Fri,  9 Jul 2021 10:47:52 +0800
Message-Id: <1625798873-55442-2-git-send-email-chengshuyi@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
References: <1625798873-55442-1-git-send-email-chengshuyi@linux.alibaba.com>
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
 tools/lib/bpf/libbpf.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 tools/lib/bpf/libbpf.h |  6 +++++-
 2 files changed, 49 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e04ce7..6702b7f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -498,6 +498,10 @@ struct bpf_object {
 	 * it at load time.
 	 */
 	struct btf *btf_vmlinux;
+	/* custom BTF is in addition to vmlinux BTF (i.e., Use the CO-RE
+	 * feature in the old kernel).
+	 */
+	char *btf_custom_path;
 	/* vmlinux BTF override for CO-RE relocations */
 	struct btf *btf_vmlinux_override;
 	/* Lazily initialized kernel module BTFs */
@@ -2668,6 +2672,27 @@ static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
 	return false;
 }
 
+static int bpf_object__load_override_btf(struct bpf_object *obj)
+{
+	int err;
+
+	if (obj->btf_vmlinux_override)
+		return 0;
+
+	if (!obj->btf_custom_path)
+		return 0;
+
+	obj->btf_vmlinux_override = btf__parse(obj->btf_custom_path, NULL);
+	err = libbpf_get_error(obj->btf_vmlinux_override);
+	pr_debug("loading custom BTF '%s': %d\n", obj->btf_custom_path, err);
+	if (err) {
+		pr_warn("failed to parse custom BTF\n");
+		obj->btf_vmlinux_override = NULL;
+	}
+
+	return err;
+}
+
 static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
 {
 	int err;
@@ -7554,7 +7579,7 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf_sz,
 		   const struct bpf_object_open_opts *opts)
 {
-	const char *obj_name, *kconfig;
+	const char *obj_name, *kconfig, *btf_tmp_path;
 	struct bpf_program *prog;
 	struct bpf_object *obj;
 	char tmp_name[64];
@@ -7584,6 +7609,19 @@ int bpf_program__load(struct bpf_program *prog, char *license, __u32 kern_ver)
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
@@ -8049,6 +8087,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 		bpf_gen__init(obj->gen_loader, attr->log_level);
 
 	err = bpf_object__probe_loading(obj);
+	err = err ? : bpf_object__load_override_btf(obj);
 	err = err ? : bpf_object__load_vmlinux_btf(obj, false);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
@@ -8075,9 +8114,11 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	}
 	free(obj->btf_modules);
 
-	/* clean up vmlinux BTF */
+	/* clean up vmlinux BTF and custom BTF*/
 	btf__free(obj->btf_vmlinux);
 	obj->btf_vmlinux = NULL;
+	btf__free(obj->btf_vmlinux_override);
+	obj->btf_vmlinux_override = NULL;
 
 	obj->loaded = true; /* doesn't matter if successfully or not */
 
@@ -8702,6 +8743,7 @@ void bpf_object__close(struct bpf_object *obj)
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

