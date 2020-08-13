Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24DA2434B4
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 09:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726627AbgHMHRh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 03:17:37 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:20214 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726612AbgHMHRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 03:17:36 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07D7BNgN005854
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:17:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=nxAKZ8Az69/8rLy2V1EBnunQAgjn24A9Diwa1zub0Bc=;
 b=WL8ijKyQ6tK7z0CTXsmh5N1xbbaqkVMFAFsnp4smHTXgQ1PyjGY48T2WcSJ2ZVZFLByA
 z0GXZYXYEiJRbDytiH6WVEk/5S6rfTYrSA5q0Dk6KGsy0oco/Ap4FSZWQ2uBzcuM8sD6
 G97ma6nqMmYNGqrkL6qybmHU802vlgu1pz4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32v0kgrf5s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 13 Aug 2020 00:17:35 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 13 Aug 2020 00:17:34 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 087932EC5928; Thu, 13 Aug 2020 00:17:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf 1/9] tools/bpftool: fix compilation warnings in 32-bit mode
Date:   Thu, 13 Aug 2020 00:17:14 -0700
Message-ID: <20200813071722.2213397-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200813071722.2213397-1-andriin@fb.com>
References: <20200813071722.2213397-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_04:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 mlxscore=0 suspectscore=8 clxscore=1015
 phishscore=0 lowpriorityscore=0 malwarescore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130055
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix few compilation warnings in bpftool when compiling in 32-bit mode.
Abstract away u64 to pointer conversion into a helper function.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/btf_dumper.c |  2 +-
 tools/bpf/bpftool/link.c       |  4 ++--
 tools/bpf/bpftool/main.h       | 10 +++++++++-
 tools/bpf/bpftool/prog.c       | 16 ++++++++--------
 4 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumpe=
r.c
index ede162f83eea..0e9310727281 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -67,7 +67,7 @@ static int dump_prog_id_as_func_ptr(const struct btf_du=
mper *d,
 	if (!info->btf_id || !info->nr_func_info ||
 	    btf__get_from_id(info->btf_id, &prog_btf))
 		goto print;
-	finfo =3D (struct bpf_func_info *)info->func_info;
+	finfo =3D u64_to_ptr(info->func_info);
 	func_type =3D btf__type_by_id(prog_btf, finfo->type_id);
 	if (!func_type || !btf_is_func(func_type))
 		goto print;
diff --git a/tools/bpf/bpftool/link.c b/tools/bpf/bpftool/link.c
index 1b793759170e..a89f09e3c848 100644
--- a/tools/bpf/bpftool/link.c
+++ b/tools/bpf/bpftool/link.c
@@ -106,7 +106,7 @@ static int show_link_close_json(int fd, struct bpf_li=
nk_info *info)
 	switch (info->type) {
 	case BPF_LINK_TYPE_RAW_TRACEPOINT:
 		jsonw_string_field(json_wtr, "tp_name",
-				   (const char *)info->raw_tracepoint.tp_name);
+				   u64_to_ptr(info->raw_tracepoint.tp_name));
 		break;
 	case BPF_LINK_TYPE_TRACING:
 		err =3D get_prog_info(info->prog_id, &prog_info);
@@ -185,7 +185,7 @@ static int show_link_close_plain(int fd, struct bpf_l=
ink_info *info)
 	switch (info->type) {
 	case BPF_LINK_TYPE_RAW_TRACEPOINT:
 		printf("\n\ttp '%s'  ",
-		       (const char *)info->raw_tracepoint.tp_name);
+		       (const char *)u64_to_ptr(info->raw_tracepoint.tp_name));
 		break;
 	case BPF_LINK_TYPE_TRACING:
 		err =3D get_prog_info(info->prog_id, &prog_info);
diff --git a/tools/bpf/bpftool/main.h b/tools/bpf/bpftool/main.h
index e3a79b5a9960..c46e52137b87 100644
--- a/tools/bpf/bpftool/main.h
+++ b/tools/bpf/bpftool/main.h
@@ -21,7 +21,15 @@
 /* Make sure we do not use kernel-only integer typedefs */
 #pragma GCC poison u8 u16 u32 u64 s8 s16 s32 s64
=20
-#define ptr_to_u64(ptr)	((__u64)(unsigned long)(ptr))
+static inline __u64 ptr_to_u64(const void *ptr)
+{
+	return (__u64)(unsigned long)ptr;
+}
+
+static inline void *u64_to_ptr(__u64 ptr)
+{
+	return (void *)(unsigned long)ptr;
+}
=20
 #define NEXT_ARG()	({ argc--; argv++; if (argc < 0) usage(); })
 #define NEXT_ARGP()	({ (*argc)--; (*argv)++; if (*argc < 0) usage(); })
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 158995d853b0..d393eb8263a6 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -428,14 +428,14 @@ prog_dump(struct bpf_prog_info *info, enum dump_mod=
e mode,
 			p_info("no instructions returned");
 			return -1;
 		}
-		buf =3D (unsigned char *)(info->jited_prog_insns);
+		buf =3D u64_to_ptr(info->jited_prog_insns);
 		member_len =3D info->jited_prog_len;
 	} else {	/* DUMP_XLATED */
 		if (info->xlated_prog_len =3D=3D 0 || !info->xlated_prog_insns) {
 			p_err("error retrieving insn dump: kernel.kptr_restrict set?");
 			return -1;
 		}
-		buf =3D (unsigned char *)info->xlated_prog_insns;
+		buf =3D u64_to_ptr(info->xlated_prog_insns);
 		member_len =3D info->xlated_prog_len;
 	}
=20
@@ -444,7 +444,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode =
mode,
 		return -1;
 	}
=20
-	func_info =3D (void *)info->func_info;
+	func_info =3D u64_to_ptr(info->func_info);
=20
 	if (info->nr_line_info) {
 		prog_linfo =3D bpf_prog_linfo__new(info);
@@ -462,7 +462,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode =
mode,
=20
 		n =3D write(fd, buf, member_len);
 		close(fd);
-		if (n !=3D member_len) {
+		if (n !=3D (ssize_t)member_len) {
 			p_err("error writing output file: %s",
 			      n < 0 ? strerror(errno) : "short write");
 			return -1;
@@ -492,13 +492,13 @@ prog_dump(struct bpf_prog_info *info, enum dump_mod=
e mode,
 			__u32 i;
 			if (info->nr_jited_ksyms) {
 				kernel_syms_load(&dd);
-				ksyms =3D (__u64 *) info->jited_ksyms;
+				ksyms =3D u64_to_ptr(info->jited_ksyms);
 			}
=20
 			if (json_output)
 				jsonw_start_array(json_wtr);
=20
-			lens =3D (__u32 *) info->jited_func_lens;
+			lens =3D u64_to_ptr(info->jited_func_lens);
 			for (i =3D 0; i < info->nr_jited_func_lens; i++) {
 				if (ksyms) {
 					sym =3D kernel_syms_search(&dd, ksyms[i]);
@@ -559,7 +559,7 @@ prog_dump(struct bpf_prog_info *info, enum dump_mode =
mode,
 	} else {
 		kernel_syms_load(&dd);
 		dd.nr_jited_ksyms =3D info->nr_jited_ksyms;
-		dd.jited_ksyms =3D (__u64 *) info->jited_ksyms;
+		dd.jited_ksyms =3D u64_to_ptr(info->jited_ksyms);
 		dd.btf =3D btf;
 		dd.func_info =3D func_info;
 		dd.finfo_rec_size =3D info->func_info_rec_size;
@@ -1681,7 +1681,7 @@ static char *profile_target_name(int tgt_fd)
 		goto out;
 	}
=20
-	func_info =3D (struct bpf_func_info *)(info_linear->info.func_info);
+	func_info =3D u64_to_ptr(info_linear->info.func_info);
 	t =3D btf__type_by_id(btf, func_info[0].type_id);
 	if (!t) {
 		p_err("btf %d doesn't have type %d",
--=20
2.24.1

