Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A683698F8
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243716AbhDWSPY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:24 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27224 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243548AbhDWSPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:15:00 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NI93T7001400
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:23 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839usrkxm-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:23 -0700
Received: from intmgw001.05.ash7.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 442AC2ED5CB8; Fri, 23 Apr 2021 11:14:17 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH v3 bpf-next 12/18] libbpf: support extern resolution for BTF-defined maps in .maps section
Date:   Fri, 23 Apr 2021 11:13:42 -0700
Message-ID: <20210423181348.1801389-13-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: 4JJFpnxof8comnuz-7WEih1h0JYWwLxJ
X-Proofpoint-ORIG-GUID: 4JJFpnxof8comnuz-7WEih1h0JYWwLxJ
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 impostorscore=0 adultscore=0 mlxlogscore=999 clxscore=1015
 lowpriorityscore=0 mlxscore=0 malwarescore=0 suspectscore=0 spamscore=0
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extra logic to handle map externs (only BTF-defined maps are supported for
linking). Re-use the map parsing logic used during bpf_object__open(). Map
externs are currently restricted to always match complete map definition. So
all the specified attributes will be compared (down to pining, map_flags,
numa_node, etc). In the future this restriction might be relaxed with no
backwards compatibility issues. If any attribute is mismatched between extern
and actual map definition, linker will report an error, pointing out which one
mismatches.

The original intent was to allow for extern to specify attributes that matters
(to user) to enforce. E.g., if you specify just key information and omit
value, then any value fits. Similarly, it should have been possible to enforce
map_flags, pinning, and any other possible map attribute. Unfortunately, that
means that multiple externs can be only partially overlapping with each other,
which means linker would need to combine their type definitions to end up with
the most restrictive and fullest map definition. This requires an extra amount
of BTF manipulation which at this time was deemed unnecessary and would
require further extending generic BTF writer APIs. So that is left for future
follow ups, if there will be demand for that. But the idea seems intresting
and useful, so I want to document it here.

Weak definitions are also supported, but are pretty strict as well, just
like externs: all weak map definitions have to match exactly. In the follow up
patches this most probably will be relaxed, with __weak map definitions being
able to differ between each other (with non-weak definition always winning, of
course).

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 132 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 132 insertions(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 23f49945dc7a..9de084b1c699 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1471,6 +1471,134 @@ static bool glob_sym_btf_matches(const char *sym_name, bool exact,
 	}
 }
 
+static bool map_defs_match(const char *sym_name,
+			   const struct btf *main_btf,
+			   const struct btf_map_def *main_def,
+			   const struct btf_map_def *main_inner_def,
+			   const struct btf *extra_btf,
+			   const struct btf_map_def *extra_def,
+			   const struct btf_map_def *extra_inner_def)
+{
+	const char *reason;
+
+	if (main_def->map_type != extra_def->map_type) {
+		reason = "type";
+		goto mismatch;
+	}
+
+	/* check key type/size match */
+	if (main_def->key_size != extra_def->key_size) {
+		reason = "key_size";
+		goto mismatch;
+	}
+	if (!!main_def->key_type_id != !!extra_def->key_type_id) {
+		reason = "key type";
+		goto mismatch;
+	}
+	if ((main_def->parts & MAP_DEF_KEY_TYPE)
+	     && !glob_sym_btf_matches(sym_name, true /*exact*/,
+				      main_btf, main_def->key_type_id,
+				      extra_btf, extra_def->key_type_id)) {
+		reason = "key type";
+		goto mismatch;
+	}
+
+	/* validate value type/size match */
+	if (main_def->value_size != extra_def->value_size) {
+		reason = "value_size";
+		goto mismatch;
+	}
+	if (!!main_def->value_type_id != !!extra_def->value_type_id) {
+		reason = "value type";
+		goto mismatch;
+	}
+	if ((main_def->parts & MAP_DEF_VALUE_TYPE)
+	     && !glob_sym_btf_matches(sym_name, true /*exact*/,
+				      main_btf, main_def->value_type_id,
+				      extra_btf, extra_def->value_type_id)) {
+		reason = "key type";
+		goto mismatch;
+	}
+
+	if (main_def->max_entries != extra_def->max_entries) {
+		reason = "max_entries";
+		goto mismatch;
+	}
+	if (main_def->map_flags != extra_def->map_flags) {
+		reason = "map_flags";
+		goto mismatch;
+	}
+	if (main_def->numa_node != extra_def->numa_node) {
+		reason = "numa_node";
+		goto mismatch;
+	}
+	if (main_def->pinning != extra_def->pinning) {
+		reason = "pinning";
+		goto mismatch;
+	}
+
+	if ((main_def->parts & MAP_DEF_INNER_MAP) != (extra_def->parts & MAP_DEF_INNER_MAP)) {
+		reason = "inner map";
+		goto mismatch;
+	}
+
+	if (main_def->parts & MAP_DEF_INNER_MAP) {
+		char inner_map_name[128];
+
+		snprintf(inner_map_name, sizeof(inner_map_name), "%s.inner", sym_name);
+
+		return map_defs_match(inner_map_name,
+				      main_btf, main_inner_def, NULL,
+				      extra_btf, extra_inner_def, NULL);
+	}
+
+	return true;
+
+mismatch:
+	pr_warn("global '%s': map %s mismatch\n", sym_name, reason);
+	return false;
+}
+
+static bool glob_map_defs_match(const char *sym_name,
+				struct bpf_linker *linker, struct glob_sym *glob_sym,
+				struct src_obj *obj, Elf64_Sym *sym, int btf_id)
+{
+	struct btf_map_def dst_def = {}, dst_inner_def = {};
+	struct btf_map_def src_def = {}, src_inner_def = {};
+	const struct btf_type *t;
+	int err;
+
+	t = btf__type_by_id(obj->btf, btf_id);
+	if (!btf_is_var(t)) {
+		pr_warn("global '%s': invalid map definition type [%d]\n", sym_name, btf_id);
+		return false;
+	}
+	t = skip_mods_and_typedefs(obj->btf, t->type, NULL);
+
+	err = parse_btf_map_def(sym_name, obj->btf, t, true /*strict*/, &src_def, &src_inner_def);
+	if (err) {
+		pr_warn("global '%s': invalid map definition\n", sym_name);
+		return false;
+	}
+
+	/* re-parse existing map definition */
+	t = btf__type_by_id(linker->btf, glob_sym->btf_id);
+	t = skip_mods_and_typedefs(linker->btf, t->type, NULL);
+	err = parse_btf_map_def(sym_name, linker->btf, t, true /*strict*/, &dst_def, &dst_inner_def);
+	if (err) {
+		/* this should not happen, because we already validated it */
+		pr_warn("global '%s': invalid dst map definition\n", sym_name);
+		return false;
+	}
+
+	/* Currently extern map definition has to be complete and match
+	 * concrete map definition exactly. This restriction might be lifted
+	 * in the future.
+	 */
+	return map_defs_match(sym_name, linker->btf, &dst_def, &dst_inner_def,
+			      obj->btf, &src_def, &src_inner_def);
+}
+
 static bool glob_syms_match(const char *sym_name,
 			    struct bpf_linker *linker, struct glob_sym *glob_sym,
 			    struct src_obj *obj, Elf64_Sym *sym, size_t sym_idx, int btf_id)
@@ -1492,6 +1620,10 @@ static bool glob_syms_match(const char *sym_name,
 		return false;
 	}
 
+	/* deal with .maps definitions specially */
+	if (glob_sym->sec_id && strcmp(linker->secs[glob_sym->sec_id].sec_name, MAPS_ELF_SEC) == 0)
+		return glob_map_defs_match(sym_name, linker, glob_sym, obj, sym, btf_id);
+
 	if (!glob_sym_btf_matches(sym_name, true /*exact*/,
 				  linker->btf, glob_sym->btf_id, obj->btf, btf_id))
 		return false;
-- 
2.30.2

