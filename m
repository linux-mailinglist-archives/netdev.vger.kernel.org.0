Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229BD375FCD
	for <lists+netdev@lfdr.de>; Fri,  7 May 2021 07:41:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbhEGFmj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 7 May 2021 01:42:39 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37848 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233948AbhEGFmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 01:42:38 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1475ZLeB028937
        for <netdev@vger.kernel.org>; Thu, 6 May 2021 22:41:38 -0700
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 38cswg982v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 22:41:38 -0700
Received: from intmgw001.38.frc1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 6 May 2021 22:41:37 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 159722ED7617; Thu,  6 May 2021 22:41:27 -0700 (PDT)
From:   Andrii Nakryiko <andrii@kernel.org>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii@kernel.org>, <kernel-team@fb.com>
Subject: [RFC PATCH bpf-next 2/7] libbpf: add per-file linker opts
Date:   Thu, 6 May 2021 22:41:14 -0700
Message-ID: <20210507054119.270888-3-andrii@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210507054119.270888-1-andrii@kernel.org>
References: <20210507054119.270888-1-andrii@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: ru0ZsWQMqKj6tJr1SuX_qRTjdyHmQccn
X-Proofpoint-ORIG-GUID: ru0ZsWQMqKj6tJr1SuX_qRTjdyHmQccn
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-07_01:2021-05-06,2021-05-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0 mlxscore=0
 bulkscore=0 impostorscore=0 clxscore=1015 suspectscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105070041
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For better future extensibility add per-file linker options. Currently
the set of available options is empty. This changes bpf_linker__add_file()
API, but it's not a breaking change as bpf_linker APIs hasn't been released
yet.

Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
---
 tools/bpf/bpftool/gen.c |  2 +-
 tools/lib/bpf/libbpf.h  | 10 +++++++++-
 tools/lib/bpf/linker.c  | 16 ++++++++++++----
 3 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 440a2fcb6441..06fee4a2910a 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -638,7 +638,7 @@ static int do_object(int argc, char **argv)
 	while (argc) {
 		file = GET_ARG();
 
-		err = bpf_linker__add_file(linker, file);
+		err = bpf_linker__add_file(linker, file, NULL);
 		if (err) {
 			p_err("failed to link '%s': %s (%d)", file, strerror(err), err);
 			goto out;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index bec4e6a6e31d..3f3a24763459 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -768,10 +768,18 @@ struct bpf_linker_opts {
 };
 #define bpf_linker_opts__last_field sz
 
+struct bpf_linker_file_opts {
+	/* size of this struct, for forward/backward compatiblity */
+	size_t sz;
+};
+#define bpf_linker_file_opts__last_field sz
+
 struct bpf_linker;
 
 LIBBPF_API struct bpf_linker *bpf_linker__new(const char *filename, struct bpf_linker_opts *opts);
-LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker, const char *filename);
+LIBBPF_API int bpf_linker__add_file(struct bpf_linker *linker,
+				    const char *filename,
+				    const struct bpf_linker_file_opts *opts);
 LIBBPF_API int bpf_linker__finalize(struct bpf_linker *linker);
 LIBBPF_API void bpf_linker__free(struct bpf_linker *linker);
 
diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 9de084b1c699..3b1fbc27be37 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -158,7 +158,9 @@ struct bpf_linker {
 
 static int init_output_elf(struct bpf_linker *linker, const char *file);
 
-static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj);
+static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
+				const struct bpf_linker_file_opts *opts,
+				struct src_obj *obj);
 static int linker_sanity_check_elf(struct src_obj *obj);
 static int linker_sanity_check_elf_symtab(struct src_obj *obj, struct src_sec *sec);
 static int linker_sanity_check_elf_relos(struct src_obj *obj, struct src_sec *sec);
@@ -435,15 +437,19 @@ static int init_output_elf(struct bpf_linker *linker, const char *file)
 	return 0;
 }
 
-int bpf_linker__add_file(struct bpf_linker *linker, const char *filename)
+int bpf_linker__add_file(struct bpf_linker *linker, const char *filename,
+			 const struct bpf_linker_file_opts *opts)
 {
 	struct src_obj obj = {};
 	int err = 0;
 
+	if (!OPTS_VALID(opts, bpf_linker_file_opts))
+		return -EINVAL;
+
 	if (!linker->elf)
 		return -EINVAL;
 
-	err = err ?: linker_load_obj_file(linker, filename, &obj);
+	err = err ?: linker_load_obj_file(linker, filename, opts, &obj);
 	err = err ?: linker_append_sec_data(linker, &obj);
 	err = err ?: linker_append_elf_syms(linker, &obj);
 	err = err ?: linker_append_elf_relos(linker, &obj);
@@ -529,7 +535,9 @@ static struct src_sec *add_src_sec(struct src_obj *obj, const char *sec_name)
 	return sec;
 }
 
-static int linker_load_obj_file(struct bpf_linker *linker, const char *filename, struct src_obj *obj)
+static int linker_load_obj_file(struct bpf_linker *linker, const char *filename,
+				const struct bpf_linker_file_opts *opts,
+				struct src_obj *obj)
 {
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 	const int host_endianness = ELFDATA2LSB;
-- 
2.30.2

