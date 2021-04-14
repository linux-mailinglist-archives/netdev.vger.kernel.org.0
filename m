Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D042835FC36
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353678AbhDNUDA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:03:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35344 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353665AbhDNUCo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:44 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EJw2kW025865
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:22 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37wv93kjd3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:22 -0700
Received: from intmgw001.06.ash9.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:02:21 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 57EF52ED1A84; Wed, 14 Apr 2021 13:02:19 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 12/17] libbpf: support extern resolution for BTF-defined maps in .maps section
Date:   Wed, 14 Apr 2021 13:01:41 -0700
Message-ID: <20210414200146.2663044-13-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
References: <20210414200146.2663044-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: ntYxPiHqP57dBwe5mIZZMlT3qjHCjXtr
X-Proofpoint-GUID: ntYxPiHqP57dBwe5mIZZMlT3qjHCjXtr
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 spamscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add extra logic to handle map externs (only BTF-defined maps are supported for
linking). Re-use the map parsing logic used during bpf_object__open(). Map
externs are currently restricted to always and only specify map type, key
type and/or size, and value type and/or size. Nothing extra is allowed. If any
of those attributes are mismatched between extern and actual map definition,
linker will report an error.

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

Otherwise extern maps behave intuitively, just like extern vars and funcs.
Weak definitions are also supported.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/linker.c | 167 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 167 insertions(+)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 7f9b91760462..9432c125fa43 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1467,6 +1467,169 @@ static bool glob_sym_btf_matches(const char *sym_name, bool exact,
 	}
 }
 
+static bool map_defs_match(const char *sym_name, bool full_match,
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
+	/* when having non-extern and extern, we don't compare the rest,
+	 * because externs are currently enforced to only specify map type,
+	 * key, and value info
+	 */
+	if (!full_match)
+		return true;
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
+		return map_defs_match(inner_map_name, true /*full_match*/,
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
+#define MAP_DEF_EXTERN_PARTS (MAP_DEF_MAP_TYPE				\
+			      | MAP_DEF_KEY_SIZE | MAP_DEF_KEY_TYPE	\
+			      | MAP_DEF_VALUE_SIZE | MAP_DEF_VALUE_TYPE)
+
+static bool glob_map_defs_match(const char *sym_name,
+				struct bpf_linker *linker, struct glob_sym *glob_sym,
+				struct src_obj *obj, Elf64_Sym *sym, int btf_id)
+{
+	bool sym_is_extern = sym->st_shndx == SHN_UNDEF;
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
+	/* We restict extern map defs to only specify map type and key/value
+	 * type or size. Inner map definitions are prohibited for now as well.
+	 */
+	if (sym_is_extern && (src_def.parts & ~MAP_DEF_EXTERN_PARTS)) {
+		pr_warn("global '%s': extern map can specify only map type and key/value info\n",
+			sym_name);
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
+	if (glob_sym->is_extern != sym_is_extern) {
+		/* extern map def should be a subset of non-extern one */
+		if (sym_is_extern)
+			/* existing map def is the main one */
+			return map_defs_match(sym_name, false /*full_match*/,
+					      linker->btf, &dst_def, &dst_inner_def,
+					      obj->btf, &src_def, &src_inner_def);
+		else
+			/* new map def is the main one */
+			return map_defs_match(sym_name, false /*full_match*/,
+					      obj->btf, &src_def, &src_inner_def,
+					      linker->btf, &dst_def, &dst_inner_def);
+	} else {
+		/* map defs should match exactly regardless of extern/extern
+		 * or non-extern/non-extern case
+		 */
+		return map_defs_match(sym_name, true /*full_match*/,
+				      linker->btf, &dst_def, &dst_inner_def,
+				      obj->btf, &src_def, &src_inner_def);
+	}
+}
+
 static bool glob_syms_match(const char *sym_name,
 			    struct bpf_linker *linker, struct glob_sym *glob_sym,
 			    struct src_obj *obj, Elf64_Sym *sym, size_t sym_idx, int btf_id)
@@ -1488,6 +1651,10 @@ static bool glob_syms_match(const char *sym_name,
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

