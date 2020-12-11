Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A444D2D8172
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 23:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405008AbgLKV7p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 11 Dec 2020 16:59:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404976AbgLKV7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 16:59:19 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BBLjNAf023495
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 13:58:33 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35b3eryjnn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 11 Dec 2020 13:58:33 -0800
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 11 Dec 2020 13:58:32 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AC04E2EC8ED7; Fri, 11 Dec 2020 13:58:29 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/2] libbpf: support modules in bpf_program__set_attach_target() API
Date:   Fri, 11 Dec 2020 13:58:24 -0800
Message-ID: <20201211215825.3646154-2-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201211215825.3646154-1-andrii@kernel.org>
References: <20201211215825.3646154-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-11_09:2020-12-11,2020-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0 suspectscore=8
 phishscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 priorityscore=1501 clxscore=1034 bulkscore=0 adultscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012110144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support finding kernel targets in kernel modules when using
bpf_program__set_attach_target() API. This brings it up to par with what
libbpf supports when doing declarative SEC()-based target determination.

Some minor internal refactoring was needed to make sure vmlinux BTF can be
loaded before bpf_object's load phase.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 64 ++++++++++++++++++++++++++----------------
 1 file changed, 40 insertions(+), 24 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 9be88a90a4aa..6ae748f6ea11 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2518,7 +2518,7 @@ static int bpf_object__finalize_btf(struct bpf_object *obj)
 	return 0;
 }
 
-static inline bool libbpf_prog_needs_vmlinux_btf(struct bpf_program *prog)
+static bool prog_needs_vmlinux_btf(struct bpf_program *prog)
 {
 	if (prog->type == BPF_PROG_TYPE_STRUCT_OPS ||
 	    prog->type == BPF_PROG_TYPE_LSM)
@@ -2533,37 +2533,43 @@ static inline bool libbpf_prog_needs_vmlinux_btf(struct bpf_program *prog)
 	return false;
 }
 
-static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
+static bool obj_needs_vmlinux_btf(const struct bpf_object *obj)
 {
-	bool need_vmlinux_btf = false;
 	struct bpf_program *prog;
-	int i, err;
+	int i;
 
 	/* CO-RE relocations need kernel BTF */
 	if (obj->btf_ext && obj->btf_ext->core_relo_info.len)
-		need_vmlinux_btf = true;
+		return true;
 
 	/* Support for typed ksyms needs kernel BTF */
 	for (i = 0; i < obj->nr_extern; i++) {
 		const struct extern_desc *ext;
 
 		ext = &obj->externs[i];
-		if (ext->type == EXT_KSYM && ext->ksym.type_id) {
-			need_vmlinux_btf = true;
-			break;
-		}
+		if (ext->type == EXT_KSYM && ext->ksym.type_id)
+			return true;
 	}
 
 	bpf_object__for_each_program(prog, obj) {
 		if (!prog->load)
 			continue;
-		if (libbpf_prog_needs_vmlinux_btf(prog)) {
-			need_vmlinux_btf = true;
-			break;
-		}
+		if (prog_needs_vmlinux_btf(prog))
+			return true;
 	}
 
-	if (!need_vmlinux_btf)
+	return false;
+}
+
+static int bpf_object__load_vmlinux_btf(struct bpf_object *obj, bool force)
+{
+	int err;
+
+	/* btf_vmlinux could be loaded earlier */
+	if (obj->btf_vmlinux)
+		return 0;
+
+	if (!force && !obj_needs_vmlinux_btf(obj))
 		return 0;
 
 	obj->btf_vmlinux = libbpf_find_kernel_btf();
@@ -7475,7 +7481,7 @@ int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 	}
 
 	err = bpf_object__probe_loading(obj);
-	err = err ? : bpf_object__load_vmlinux_btf(obj);
+	err = err ? : bpf_object__load_vmlinux_btf(obj, false);
 	err = err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err = err ? : bpf_object__sanitize_and_load_btf(obj);
 	err = err ? : bpf_object__sanitize_maps(obj);
@@ -10870,23 +10876,33 @@ int bpf_program__set_attach_target(struct bpf_program *prog,
 				   int attach_prog_fd,
 				   const char *attach_func_name)
 {
-	int btf_id;
+	int btf_obj_fd = 0, btf_id = 0, err;
 
 	if (!prog || attach_prog_fd < 0 || !attach_func_name)
 		return -EINVAL;
 
-	if (attach_prog_fd)
+	if (prog->obj->loaded)
+		return -EINVAL;
+
+	if (attach_prog_fd) {
 		btf_id = libbpf_find_prog_btf_id(attach_func_name,
 						 attach_prog_fd);
-	else
-		btf_id = libbpf_find_vmlinux_btf_id(attach_func_name,
-						    prog->expected_attach_type);
-
-	if (btf_id < 0)
-		return btf_id;
+		if (btf_id < 0)
+			return btf_id;
+	} else {
+		/* load btf_vmlinux, if not yet */
+		err = bpf_object__load_vmlinux_btf(prog->obj, true);
+		if (err)
+			return err;
+		err = find_kernel_btf_id(prog->obj, attach_func_name,
+					 prog->expected_attach_type,
+					 &btf_obj_fd, &btf_id);
+		if (err)
+			return err;
+	}
 
 	prog->attach_btf_id = btf_id;
-	prog->attach_btf_obj_fd = 0;
+	prog->attach_btf_obj_fd = btf_obj_fd;
 	prog->attach_prog_fd = attach_prog_fd;
 	return 0;
 }
-- 
2.24.1

