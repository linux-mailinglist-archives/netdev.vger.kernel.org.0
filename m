Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00B813698EE
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 20:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243565AbhDWSPJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 23 Apr 2021 14:15:09 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:22240 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S243561AbhDWSOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 14:14:52 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13NI9uSi019498
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:15 -0700
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3839sh8hxw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 11:14:15 -0700
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Apr 2021 11:14:14 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 9DF2C2ED5CB8; Fri, 23 Apr 2021 11:14:09 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH v3 bpf-next 08/18] libbpf: make few internal helpers available outside of libbpf.c
Date:   Fri, 23 Apr 2021 11:13:38 -0700
Message-ID: <20210423181348.1801389-9-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423181348.1801389-1-andrii@kernel.org>
References: <20210423181348.1801389-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: cB06ln6cg4qwfnrGV66Jcuj-LLn5700R
X-Proofpoint-GUID: cB06ln6cg4qwfnrGV66Jcuj-LLn5700R
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-23_07:2021-04-23,2021-04-23 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 malwarescore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 suspectscore=0 impostorscore=0 mlxlogscore=999 adultscore=0 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104230120
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make skip_mods_and_typedefs(), btf_kind_str(), and btf_func_linkage() helpers
available outside of libbpf.c, to be used by static linker code.

Also do few cleanups (error code fixes, comment clean up, etc) that don't
deserve their own commit.

Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/lib/bpf/libbpf.c          | 13 +++----------
 tools/lib/bpf/libbpf_internal.h |  7 +++++++
 tools/lib/bpf/linker.c          | 14 ++++++--------
 3 files changed, 16 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 4f8335fc0bc9..a1cddd17af7d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -69,8 +69,6 @@
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
 
 static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
-static const struct btf_type *
-skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
 static bool prog_is_subprog(const struct bpf_object *obj, const struct bpf_program *prog);
 
 static int __base_pr(enum libbpf_print_level level, const char *format,
@@ -1906,7 +1904,7 @@ static int bpf_object__init_user_maps(struct bpf_object *obj, bool strict)
 	return 0;
 }
 
-static const struct btf_type *
+const struct btf_type *
 skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id)
 {
 	const struct btf_type *t = btf__type_by_id(btf, id);
@@ -1961,16 +1959,11 @@ static const char *__btf_kind_str(__u16 kind)
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
@@ -7036,7 +7029,7 @@ static bool insn_is_helper_call(struct bpf_insn *insn, enum bpf_func_id *func_id
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
index 0bb927226370..1263641e8b97 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -123,9 +123,7 @@ struct bpf_linker {
 };
 
 #define pr_warn_elf(fmt, ...)									\
-do {												\
-	libbpf_print(LIBBPF_WARN, "libbpf: " fmt ": %s\n", ##__VA_ARGS__, elf_errmsg(-1));	\
-} while (0)
+	libbpf_print(LIBBPF_WARN, "libbpf: " fmt ": %s\n", ##__VA_ARGS__, elf_errmsg(-1))
 
 static int init_output_elf(struct bpf_linker *linker, const char *file);
 
@@ -284,7 +282,7 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 
 	/* ELF header */
 	linker->elf_hdr = elf64_newehdr(linker->elf);
-	if (!linker->elf_hdr){
+	if (!linker->elf_hdr) {
 		pr_warn_elf("failed to create ELF header");
 		return -EINVAL;
 	}
@@ -925,13 +923,13 @@ static int init_sec(struct bpf_linker *linker, struct dst_sec *dst_sec, struct s
 
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
@@ -1221,7 +1219,7 @@ static int linker_append_elf_relos(struct bpf_linker *linker, struct src_obj *ob
 				return err;
 			}
 		} else if (!secs_match(dst_sec, src_sec)) {
-			pr_warn("Secs %s are not compatible\n", src_sec->sec_name);
+			pr_warn("sections %s are not compatible\n", src_sec->sec_name);
 			return -1;
 		}
 
-- 
2.30.2

