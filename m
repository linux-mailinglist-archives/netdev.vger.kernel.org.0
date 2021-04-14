Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 224F835FC31
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 22:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353657AbhDNUC4 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Apr 2021 16:02:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47320 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353650AbhDNUCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 16:02:39 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13EJsj5T007359
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:17 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 37wv5jbnr6-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 13:02:16 -0700
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 14 Apr 2021 13:02:15 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2B1902ECEBDF; Wed, 14 Apr 2021 13:02:11 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [PATCH bpf-next 08/17] libbpf: make few internal helpers available outside of libbpf.c
Date:   Wed, 14 Apr 2021 13:01:37 -0700
Message-ID: <20210414200146.2663044-9-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210414200146.2663044-1-andrii@kernel.org>
References: <20210414200146.2663044-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: i6FYPhfZjLCItuLkKiFSTVuOzkntZ6CO
X-Proofpoint-GUID: i6FYPhfZjLCItuLkKiFSTVuOzkntZ6CO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_12:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 bulkscore=0 spamscore=0 adultscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104140127
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make skip_mods_and_typedefs(), btf_kind_str(), and btf_func_linkage() helpers
available outside of libbpf.c, to be used by static linker code.

Also do few cleanups (error code fixes, comment clean up, etc) that don't
deserve their own commit.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 13 +++----------
 tools/lib/bpf/libbpf_internal.h |  7 +++++++
 tools/lib/bpf/linker.c          |  8 ++++----
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index b0dfe822cb50..16fe2065ef7d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -69,8 +69,6 @@
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
 static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
-static const struct btf_type *
-skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
 static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog);
 
 static int __base_pr(enum libbpf_print_level level, const char *format,
@@ -1907,7 +1905,7 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
-static const struct btf_type *
+const struct btf_type *
 skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
 {
 	const struct btf_type *t = btf__type_by_id(btf, id);
@@ -1962,16 +1960,11 @@ static const char *__btf_kind_str(__u16 kind)
 	}
 }
 
-static const char *btf_kind_str(const struct btf_type *t)
+const char *btf_kind_str(const struct btf_type *t)
 {
 	return __btf_kind_str(btf_kind(t));
 }
 
-static enum btf_func_linkage btf_func_linkage(const struct btf_type *t)
-{
-	return (enum btf_func_linkage)BTF_INFO_VLEN(t->info);
-}
-
 /*
  * Fetch integer attribute of BTF map definition. Such attributes are
  * represented using a pointer to an array, in which dimensionality of array
@@ -7048,7 +7041,7 @@ static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id *func_id
 	return false;
 }
 
-static int bpf_object__sanitize_prog(struct bpf_object* obj, struct bpf_program *prog)
+static int bpf_object__sanitize_prog(struct bpf_object *obj, struct bpf_program *prog)
 {
 	struct bpf_insn *insn = prog->insns;
 	enum bpf_func_id func_id;
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 17883073710c..ee426226928f 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -132,6 +132,13 @@ struct btf;
 struct btf_type;
 
 struct btf_type *btf_type_by_id(struct btf *btf, __u32 type_id);
+const char *btf_kind_str(const struct btf_type *t);
+const struct btf_type *skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
+
+static inline enum btf_func_linkage btf_func_linkage(const struct btf_type *t)
+{
+	return (enum btf_func_linkage)(int)btf_vlen(t);
+}
 
 static inline __u32 btf_type_info(int kind, int vlen, int kflag)
 {
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 0bb927226370..b23bfa6e7e5f 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -925,13 +925,13 @@ static int init_sec(struct bpf_linker *linker, struct dst_sec *dst_sec, struct s
 
 	scn = elf_newscn(linker->elf);
 	if (!scn)
-		return -1;
+		return -ENOMEM;
 	data = elf_newdata(scn);
 	if (!data)
-		return -1;
+		return -ENOMEM;
 	shdr = elf64_getshdr(scn);
 	if (!shdr)
-		return -1;
+		return -ENOMEM;
 
 	dst_sec->scn = scn;
 	dst_sec->shdr = shdr;
@@ -1221,7 +1221,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 				return err;
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
-			pr_warn("Secs %s are not compatible\n", src_sec->sec_name);
+			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
 			return -1;
 		}
 
-- 
2.30.2

