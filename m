Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DADD342743
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 21:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbhCSU7W convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Mar 2021 16:59:22 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3796 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230235AbhCSU7T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 16:59:19 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12JKwTPO004087
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:19 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37bs1ew1rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 13:59:19 -0700
Received: from intmgw001.37.frc1.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 19 Mar 2021 13:59:18 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 1639A2ED268B; Fri, 19 Mar 2021 13:59:13 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 1/3] bpftool: improve skeleton generation for objects without BTF
Date:   Fri, 19 Mar 2021 13:59:07 -0700
Message-ID: <20210319205909.1748642-2-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210319205909.1748642-1-andrii@kernel.org>
References: <20210319205909.1748642-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-19_12:2021-03-19,2021-03-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 mlxscore=0 adultscore=0 mlxlogscore=999 malwarescore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190144
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BPF object file is using global variables, but is compiled without BTF or
ends up having only some of DATASEC types due to static linking, generated
skeleton won't compile, as some parts of skeleton would assume memory-mapped
struct definitions for each special data section.

Fix this by generating empty struct definition for such data sections. The
benefit of that is that they still will be memory-mapped by skeleton handling
code in libbpf, and user-space parts of user application would be able to
access data in them (though pointer casting), assuming they know the memory
layout they need.

Fixes: 985ead416df3 ("bpftool: Add skeleton codegen command")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/gen.c | 81 ++++++++++++++++++++++++++++++++---------
 1 file changed, 64 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 31ade77f5ef8..6ec7c2e90a01 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -85,6 +85,18 @@ static const char *get_map_ident(const struct bpf_map *map)
 	else
 		return NULL;
 }
+static const char *datasec_ident(const char *sec_name)
+{
+	if (strcmp(sec_name, ".data") == 0)
+		return "data";
+	if (strcmp(sec_name, ".bss") == 0)
+		return "bss";
+	if (strcmp(sec_name, ".rodata") == 0)
+		return "rodata";
+	if (strcmp(sec_name, ".kconfig") == 0)
+		return "kconfig";
+	return NULL;
+}
 
 static void codegen_btf_dump_printf(void *ctx, const char *fmt, va_list args)
 {
@@ -104,18 +116,12 @@ static int codegen_datasec_def(struct bpf_object *obj,
 	char var_ident[256];
 	bool strip_mods = false;
 
-	if (strcmp(sec_name, ".data") == 0) {
-		sec_ident = "data";
-	} else if (strcmp(sec_name, ".bss") == 0) {
-		sec_ident = "bss";
-	} else if (strcmp(sec_name, ".rodata") == 0) {
-		sec_ident = "rodata";
-		strip_mods = true;
-	} else if (strcmp(sec_name, ".kconfig") == 0) {
-		sec_ident = "kconfig";
-	} else {
+	sec_ident = datasec_ident(sec_name);
+	if (!sec_ident)
 		return 0;
-	}
+
+	if (strcmp(sec_name, ".rodata") == 0)
+		strip_mods = true;
 
 	printf("	struct %s__%s {\n", obj_name, sec_ident);
 	for (i = 0; i < vlen; i++, sec_var++) {
@@ -188,22 +194,63 @@ static int codegen_datasecs(struct bpf_object *obj, const char *obj_name)
 	struct btf *btf = bpf_object__btf(obj);
 	int n = btf__get_nr_types(btf);
 	struct btf_dump *d;
+	struct bpf_map *map;
+	const struct btf_type *sec;
+	const char *sec_ident, *map_ident;
 	int i, err = 0;
 
 	d = btf_dump__new(btf, NULL, NULL, codegen_btf_dump_printf);
 	if (IS_ERR(d))
 		return PTR_ERR(d);
 
-	for (i = 1; i <= n; i++) {
-		const struct btf_type *t = btf__type_by_id(btf, i);
+	bpf_object__for_each_map(map, obj) {
+		/* only generate definitions for memory-mapped internal maps */
+		if (!bpf_map__is_internal(map))
+			continue;
+		if (!(bpf_map__def(map)->map_flags & BPF_F_MMAPABLE))
+			continue;
 
-		if (!btf_is_datasec(t))
+		map_ident = get_map_ident(map);
+		if (!map_ident)
 			continue;
 
-		err = codegen_datasec_def(obj, btf, d, t, obj_name);
-		if (err)
-			goto out;
+		sec = NULL;
+		for (i = 1; i <= n; i++) {
+			const struct btf_type *t = btf__type_by_id(btf, i);
+			const char *name;
+
+			if (!btf_is_datasec(t))
+				continue;
+
+			name = btf__str_by_offset(btf, t->name_off);
+			sec_ident = datasec_ident(name);
+			if (!sec_ident)
+				continue;
+
+			if (strcmp(sec_ident, map_ident) == 0) {
+				sec = t;
+				break;
+			}
+		}
+
+		/* In rare cases when BPF object file is using global
+		 * variables, but is compiled without BTF, we will have
+		 * special internal map, but no corresponding DATASEC BTF
+		 * type. In such case, generate empty structs for each such
+		 * map. It will still be memory-mapped as a convenience for
+		 * applications that know exact memory layout to expect.
+		 */
+		if (!sec) {
+			printf("	struct %s__%s {\n", obj_name, map_ident);
+			printf("	} *%s;\n", map_ident);
+		} else {
+			err = codegen_datasec_def(obj, btf, d, sec, obj_name);
+			if (err)
+				goto out;
+		}
 	}
+
+
 out:
 	btf_dump__free(d);
 	return err;
-- 
2.30.2

