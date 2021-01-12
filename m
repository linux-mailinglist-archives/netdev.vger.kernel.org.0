Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76DB72F295F
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 08:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404239AbhALH4Y convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 12 Jan 2021 02:56:24 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7167 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403970AbhALH4X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 02:56:23 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10C7rCDo013461
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:42 -0800
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 35yw8798t6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 23:55:42 -0800
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 23:55:40 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 8A0BD2ECD646; Mon, 11 Jan 2021 23:55:36 -0800 (PST)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Hao Luo <haoluo@google.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 6/7] libbpf: support kernel module ksym externs
Date:   Mon, 11 Jan 2021 23:55:19 -0800
Message-ID: <20210112075520.4103414-7-andrii@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20210112075520.4103414-1-andrii@kernel.org>
References: <20210112075520.4103414-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0 clxscore=1015
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101120042
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for searching for ksym externs not just in vmlinux BTF, but across
all module BTFs, similarly to how it's done for CO-RE relocations. Kernels
that expose module BTFs through sysfs are assumed to support new ldimm64
instruction extension with BTF FD provided in insn[1].imm field, so no extra
feature detection is performed.

Acked-by: Yonghong Song <yhs@fb.com>
Acked-by: Hao Luo <haoluo@google.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c | 50 +++++++++++++++++++++++++++---------------
 1 file changed, 32 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ae748f6ea11..2abbc3800568 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -395,7 +395,8 @@ struct extern_desc {
 			unsigned long long addr;
 
 			/* target btf_id of the corresponding kernel var. */
-			int vmlinux_btf_id;
+			int kernel_btf_obj_fd;
+			int kernel_btf_id;
 
 			/* local btf_id of the ksym extern's type. */
 			__u32 type_id;
@@ -6162,7 +6163,8 @@ bpf_object__relocate_data(struct bpf_object *obj, struct bpf_program *prog)
 			} else /* EXT_KSYM */ {
 				if (ext->ksym.type_id) { /* typed ksyms */
 					insn[0].src_reg = BPF_PSEUDO_BTF_ID;
-					insn[0].imm = ext->ksym.vmlinux_btf_id;
+					insn[0].imm = ext->ksym.kernel_btf_id;
+					insn[1].imm = ext->ksym.kernel_btf_obj_fd;
 				} else { /* typeless ksyms */
 					insn[0].imm = (__u32)ext->ksym.addr;
 					insn[1].imm = ext->ksym.addr >> 32;
@@ -7319,7 +7321,8 @@ static int bpf_object__read_kallsyms_file(struct bpf_object *obj)
 static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 {
 	struct extern_desc *ext;
-	int i, id;
+	struct btf *btf;
+	int i, j, id, btf_fd, err;
 
 	for (i = 0; i < obj->nr_extern; i++) {
 		const struct btf_type *targ_var, *targ_type;
@@ -7331,10 +7334,25 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 		if (ext->type != EXT_KSYM || !ext->ksym.type_id)
 			continue;
 
-		id = btf__find_by_name_kind(obj->btf_vmlinux, ext->name,
-					    BTF_KIND_VAR);
+		btf = obj->btf_vmlinux;
+		btf_fd = 0;
+		id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
+		if (id == -ENOENT) {
+			err = load_module_btfs(obj);
+			if (err)
+				return err;
+
+			for (j = 0; j < obj->btf_module_cnt; j++) {
+				btf = obj->btf_modules[j].btf;
+				/* we assume module BTF FD is always >0 */
+				btf_fd = obj->btf_modules[j].fd;
+				id = btf__find_by_name_kind(btf, ext->name, BTF_KIND_VAR);
+				if (id != -ENOENT)
+					break;
+			}
+		}
 		if (id <= 0) {
-			pr_warn("extern (ksym) '%s': failed to find BTF ID in vmlinux BTF.\n",
+			pr_warn("extern (ksym) '%s': failed to find BTF ID in kernel BTF(s).\n",
 				ext->name);
 			return -ESRCH;
 		}
@@ -7343,24 +7361,19 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 		local_type_id = ext->ksym.type_id;
 
 		/* find target type_id */
-		targ_var = btf__type_by_id(obj->btf_vmlinux, id);
-		targ_var_name = btf__name_by_offset(obj->btf_vmlinux,
-						    targ_var->name_off);
-		targ_type = skip_mods_and_typedefs(obj->btf_vmlinux,
-						   targ_var->type,
-						   &targ_type_id);
+		targ_var = btf__type_by_id(btf, id);
+		targ_var_name = btf__name_by_offset(btf, targ_var->name_off);
+		targ_type = skip_mods_and_typedefs(btf, targ_var->type, &targ_type_id);
 
 		ret = bpf_core_types_are_compat(obj->btf, local_type_id,
-						obj->btf_vmlinux, targ_type_id);
+						btf, targ_type_id);
 		if (ret <= 0) {
 			const struct btf_type *local_type;
 			const char *targ_name, *local_name;
 
 			local_type = btf__type_by_id(obj->btf, local_type_id);
-			local_name = btf__name_by_offset(obj->btf,
-							 local_type->name_off);
-			targ_name = btf__name_by_offset(obj->btf_vmlinux,
-							targ_type->name_off);
+			local_name = btf__name_by_offset(obj->btf, local_type->name_off);
+			targ_name = btf__name_by_offset(btf, targ_type->name_off);
 
 			pr_warn("extern (ksym) '%s': incompatible types, expected [%d] %s %s, but kernel has [%d] %s %s\n",
 				ext->name, local_type_id,
@@ -7370,7 +7383,8 @@ static int bpf_object__resolve_ksyms_btf_id(struct bpf_object *obj)
 		}
 
 		ext->is_set = true;
-		ext->ksym.vmlinux_btf_id = id;
+		ext->ksym.kernel_btf_obj_fd = btf_fd;
+		ext->ksym.kernel_btf_id = id;
 		pr_debug("extern (ksym) '%s': resolved to [%d] %s %s\n",
 			 ext->name, id, btf_kind_str(targ_var), targ_var_name);
 	}
-- 
2.24.1

