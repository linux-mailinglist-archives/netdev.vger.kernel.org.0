Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AB942C93FF
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389160AbgLAAcp convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 30 Nov 2020 19:32:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726316AbgLAAco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:32:44 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B10VxYY019483
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:32:04 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 354hsyet1q-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 16:32:03 -0800
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 30 Nov 2020 16:31:54 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 48D722ECA5FC; Mon, 30 Nov 2020 16:31:53 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v2 bpf-next 4/7] libbpf: add kernel module BTF support for CO-RE relocations
Date:   Mon, 30 Nov 2020 16:31:34 -0800
Message-ID: <20201201003137.1692914-5-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201003137.1692914-1-andrii@kernel.org>
References: <20201201003137.1692914-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-30_12:2020-11-30,2020-11-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1034
 adultscore=0 priorityscore=1501 impostorscore=0 mlxscore=0 spamscore=0
 bulkscore=0 lowpriorityscore=0 suspectscore=29 mlxlogscore=999
 phishscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2012010000
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Teach libbpf to search for candidate types for CO-RE relocations across kernel
modules BTFs, in addition to vmlinux BTF. If at least one candidate type is
found in vmlinux BTF, kernel module BTFs are not iterated. If vmlinux BTF has
no matching candidates, then find all kernel module BTFs and search for all
matching candidates across all of them.

Kernel's support for module BTFs are inferred from the support for BTF name
pointer in BPF UAPI.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 178 ++++++++++++++++++++++++++++++++++++++---
 1 file changed, 168 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index c4a49e8eb7b5..225258d9b273 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -176,6 +176,8 @@ enum kern_feature_id {
 	FEAT_PROBE_READ_KERN,
 	/* BPF_PROG_BIND_MAP is supported */
 	FEAT_PROG_BIND_MAP,
+	/* Kernel support for module BTFs */
+	FEAT_MODULE_BTF,
 	__FEAT_CNT,
 };
 
@@ -402,6 +404,12 @@ struct extern_desc {
 
 static LIST_HEAD(bpf_objects_list);
 
+struct module_btf {
+	struct btf *btf;
+	char *name;
+	__u32 id;
+};
+
 struct bpf_object {
 	char name[BPF_OBJ_NAME_LEN];
 	char license[64];
@@ -470,6 +478,11 @@ struct bpf_object {
 	struct btf *btf_vmlinux;
 	/* vmlinux BTF override for CO-RE relocations */
 	struct btf *btf_vmlinux_override;
+	/* Lazily initialized kernel module BTFs */
+	struct module_btf *btf_modules;
+	bool btf_modules_loaded;
+	size_t btf_module_cnt;
+	size_t btf_module_cap;
 
 	void *priv;
 	bpf_object_clear_priv_t clear_priv;
@@ -3960,6 +3973,35 @@ static int probe_prog_bind_map(void)
 	return ret >= 0;
 }
 
+static int probe_module_btf(void)
+{
+	static const char strs[] = "\0int";
+	__u32 types[] = {
+		/* int */
+		BTF_TYPE_INT_ENC(1, BTF_INT_SIGNED, 0, 32, 4),
+	};
+	struct bpf_btf_info info;
+	__u32 len = sizeof(info);
+	char name[16];
+	int fd, err;
+
+	fd = libbpf__load_raw_btf((char *)types, sizeof(types), strs, sizeof(strs));
+	if (fd < 0)
+		return 0; /* BTF not supported at all */
+
+	memset(&info, 0, sizeof(info));
+	info.name = ptr_to_u64(name);
+	info.name_len = sizeof(name);
+
+	/* check that BPF_OBJ_GET_INFO_BY_FD supports specifying name pointer;
+	 * kernel's module BTF support coincides with support for
+	 * name/name_len fields in struct bpf_btf_info.
+	 */
+	err = bpf_obj_get_info_by_fd(fd, &info, &len);
+	close(fd);
+	return !err;
+}
+
 enum kern_feature_result {
 	FEAT_UNKNOWN = 0,
 	FEAT_SUPPORTED = 1,
@@ -4003,7 +4045,10 @@ static struct kern_feature_desc {
 	},
 	[FEAT_PROG_BIND_MAP] = {
 		"BPF_PROG_BIND_MAP support", probe_prog_bind_map,
-	}
+	},
+	[FEAT_MODULE_BTF] = {
+		"module BTF support", probe_module_btf,
+	},
 };
 
 static bool kernel_supports(enum kern_feature_id feat_id)
@@ -4674,13 +4719,95 @@ static int bpf_core_add_cands(struct core_cand *local_cand,
 	return 0;
 }
 
+static int load_module_btfs(struct bpf_object *obj)
+{
+	struct bpf_btf_info info;
+	struct module_btf *mod_btf;
+	struct btf *btf;
+	char name[64];
+	__u32 id, len;
+	int err, fd;
+
+	if (obj->btf_modules_loaded)
+		return 0;
+
+	/* don't do this again, even if we find no module BTFs */
+	obj->btf_modules_loaded = true;
+
+	/* kernel too old to support module BTFs */
+	if (!kernel_supports(FEAT_MODULE_BTF))
+		return 0;
+
+	while (true) {
+		err = bpf_btf_get_next_id(id, &id);
+		if (err && errno == ENOENT)
+			return 0;
+		if (err) {
+			err = -errno;
+			pr_warn("failed to iterate BTF objects: %d\n", err);
+			return err;
+		}
+
+		fd = bpf_btf_get_fd_by_id(id);
+		if (fd < 0) {
+			if (errno == ENOENT)
+				continue; /* expected race: BTF was unloaded */
+			err = -errno;
+			pr_warn("failed to get BTF object #%d FD: %d\n", id, err);
+			return err;
+		}
+
+		len = sizeof(info);
+		memset(&info, 0, sizeof(info));
+		info.name = ptr_to_u64(name);
+		info.name_len = sizeof(name);
+
+		err = bpf_obj_get_info_by_fd(fd, &info, &len);
+		if (err) {
+			err = -errno;
+			pr_warn("failed to get BTF object #%d info: %d\n", id, err);
+			return err;
+		}
+
+		/* ignore non-module BTFs */
+		if (!info.kernel_btf || strcmp(name, "vmlinux") == 0) {
+			close(fd);
+			continue;
+		}
+
+		btf = btf_get_from_fd(fd, obj->btf_vmlinux);
+		close(fd);
+		if (IS_ERR(btf)) {
+			pr_warn("failed to load module [%s]'s BTF object #%d: %ld\n",
+				name, id, PTR_ERR(btf));
+			return PTR_ERR(btf);
+		}
+
+		err = btf_ensure_mem((void **)&obj->btf_modules, &obj->btf_module_cap,
+				     sizeof(*obj->btf_modules), obj->btf_module_cnt + 1);
+		if (err)
+			return err;
+
+		mod_btf = &obj->btf_modules[obj->btf_module_cnt++];
+
+		mod_btf->btf = btf;
+		mod_btf->id = id;
+		mod_btf->name = strdup(name);
+		if (!mod_btf->name)
+			return -ENOMEM;
+	}
+
+	return 0;
+}
+
 static struct core_cand_list *
 bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 local_type_id)
 {
 	struct core_cand local_cand = {};
 	struct core_cand_list *cands;
+	const struct btf *main_btf;
 	size_t local_essent_len;
-	int err;
+	int err, i;
 
 	local_cand.btf = local_btf;
 	local_cand.t = btf__type_by_id(local_btf, local_type_id);
@@ -4697,15 +4824,38 @@ bpf_core_find_cands(struct bpf_object *obj, const struct btf *local_btf, __u32 l
 		return ERR_PTR(-ENOMEM);
 
 	/* Attempt to find target candidates in vmlinux BTF first */
-	err = bpf_core_add_cands(&local_cand, local_essent_len,
-				 obj->btf_vmlinux_override ?: obj->btf_vmlinux,
-				 "vmlinux", 1, cands);
-	if (err) {
-		bpf_core_free_cands(cands);
-		return ERR_PTR(err);
+	main_btf = obj->btf_vmlinux_override ?: obj->btf_vmlinux;
+	err = bpf_core_add_cands(&local_cand, local_essent_len, main_btf, "vmlinux", 1, cands);
+	if (err)
+		goto err_out;
+
+	/* if vmlinux BTF has any candidate, don't got for module BTFs */
+	if (cands->len)
+		return cands;
+
+	/* if vmlinux BTF was overridden, don't attempt to load module BTFs */
+	if (obj->btf_vmlinux_override)
+		return cands;
+
+	/* now look through module BTFs, trying to still find candidates */
+	err = load_module_btfs(obj);
+	if (err)
+		goto err_out;
+
+	for (i = 0; i < obj->btf_module_cnt; i++) {
+		err = bpf_core_add_cands(&local_cand, local_essent_len,
+					 obj->btf_modules[i].btf,
+					 obj->btf_modules[i].name,
+					 btf__get_nr_types(obj->btf_vmlinux) + 1,
+					 cands);
+		if (err)
+			goto err_out;
 	}
 
 	return cands;
+err_out:
+	bpf_core_free_cands(cands);
+	return ERR_PTR(err);
 }
 
 /* Check two types for compatibility for the purpose of field access
@@ -5756,7 +5906,7 @@ static int bpf_core_apply_relo(struct bpf_program *prog,
 	if (!hashmap__find(cand_cache, type_key, (void **)&cands)) {
 		cands = bpf_core_find_cands(prog->obj, local_btf, local_id);
 		if (IS_ERR(cands)) {
-			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d] %s %s: %ld",
+			pr_warn("prog '%s': relo #%d: target candidate search failed for [%d] %s %s: %ld\n",
 				prog->name, relo_idx, local_id, btf_kind_str(local_type),
 				local_name, PTR_ERR(cands));
 			return PTR_ERR(cands);
@@ -5944,7 +6094,7 @@ bpf_object__relocate_core(struct bpf_object *obj, const char *targ_btf_path)
 	}
 
 out:
-	/* obj->btf_vmlinux is freed at the end of object load phase */
+	/* obj->btf_vmlinux and module BTFs are freed after object load */
 	btf__free(obj->btf_vmlinux_override);
 	obj->btf_vmlinux_override = NULL;
 
@@ -7303,6 +7453,14 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	err = err ? : bpf_object__relocate(obj, attr->target_btf_path);
 	err = err ? : bpf_object__load_progs(obj, attr->log_level);
 
+	/* clean up module BTFs */
+	for (i = 0; i < obj->btf_module_cnt; i++) {
+		btf__free(obj->btf_modules[i].btf);
+		free(obj->btf_modules[i].name);
+	}
+	free(obj->btf_modules);
+
+	/* clean up vmlinux BTF */
 	btf__free(obj->btf_vmlinux);
 	obj->btf_vmlinux = NULL;
 
-- 
2.24.1

