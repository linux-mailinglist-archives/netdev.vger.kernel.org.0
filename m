Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D992525B6
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 05:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgHZDKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 23:10:11 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5920 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726672AbgHZDKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 23:10:10 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07Q35BP5014838
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 20:10:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=GCQKPuvA9eng5ybNI2DOYZrTlMDd9wi721TRvtYjF3s=;
 b=hYctapAOGyvBf3xW+ZOv6GIIq/KGiYGJoGsPMGnEh/yQ4zx9bZqM2MxAQUmCxMt7Mztd
 6oCQayIc1ya9oSc34Yw5HBFg5cmYY7K3E7GBPxx5LNpsLjIAbX4KX/t/9TmJeGjZTyQr
 mNhfc83jN/Fg7AHcRWh54su7lm/NEBSAARQ= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 333jv9xuyg-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 20:10:09 -0700
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 25 Aug 2020 20:09:38 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 363A42EC628A; Tue, 25 Aug 2020 20:09:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: fix compilation warnings for 64-bit printf args
Date:   Tue, 25 Aug 2020 20:09:21 -0700
Message-ID: <20200826030922.2591203-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_11:2020-08-25,2020-08-26 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 suspectscore=9 mlxlogscore=999 lowpriorityscore=0 clxscore=1015 mlxscore=0
 spamscore=0 adultscore=0 impostorscore=0 bulkscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260023
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add __pu64 and __ps64 (sort of like "printf u64 and s64") for libbpf-inte=
rnal
use only in printf-like situations to avoid compilation warnings due to
%lld/%llu mismatch with a __u64/__s64 due to some architecture defining t=
he
latter as either `long` or `long long`. Use that on all %lld/%llu cases i=
n
libbpf.c.

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Fixes: eacaaed784e2 ("libbpf: Implement enum value-based CO-RE relocation=
s")
Fixes: 50e09460d9f8 ("libbpf: Skip well-known ELF sections when iterating=
 ELF")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c          | 15 ++++++++-------
 tools/lib/bpf/libbpf_internal.h | 11 +++++++++++
 2 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 2e2523d8bb6d..211eb0d9020c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1529,12 +1529,12 @@ static int set_kcfg_value_num(struct extern_desc =
*ext, void *ext_val,
 {
 	if (ext->kcfg.type !=3D KCFG_INT && ext->kcfg.type !=3D KCFG_CHAR) {
 		pr_warn("extern (kcfg) %s=3D%llu should be integer\n",
-			ext->name, (unsigned long long)value);
+			ext->name, (__pu64)value);
 		return -EINVAL;
 	}
 	if (!is_kcfg_value_in_range(ext, value)) {
 		pr_warn("extern (kcfg) %s=3D%llu value doesn't fit in %d bytes\n",
-			ext->name, (unsigned long long)value, ext->kcfg.sz);
+			ext->name, (__pu64)value, ext->kcfg.sz);
 		return -ERANGE;
 	}
 	switch (ext->kcfg.sz) {
@@ -2823,7 +2823,8 @@ static int bpf_object__elf_collect(struct bpf_objec=
t *obj)
 			obj->efile.bss =3D data;
 			obj->efile.bss_shndx =3D idx;
 		} else {
-			pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name, sh.sh=
_size);
+			pr_info("elf: skipping section(%d) %s (size %zu)\n", idx, name,
+				(size_t)sh.sh_size);
 		}
 	}
=20
@@ -5244,7 +5245,7 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 		if (res->validate && imm !=3D orig_val) {
 			pr_warn("prog '%s': relo #%d: unexpected insn #%d (LDIMM64) value: go=
t %llu, exp %u -> %u\n",
 				bpf_program__title(prog, false), relo_idx,
-				insn_idx, imm, orig_val, new_val);
+				insn_idx, (__pu64)imm, orig_val, new_val);
 			return -EINVAL;
 		}
=20
@@ -5252,7 +5253,7 @@ static int bpf_core_patch_insn(struct bpf_program *=
prog,
 		insn[1].imm =3D 0; /* currently only 32-bit values are supported */
 		pr_debug("prog '%s': relo #%d: patched insn #%d (LDIMM64) imm64 %llu -=
> %u\n",
 			 bpf_program__title(prog, false), relo_idx, insn_idx,
-			 imm, new_val);
+			 (__pu64)imm, new_val);
 		break;
 	}
 	default:
@@ -7782,8 +7783,8 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 		st_ops =3D map->st_ops;
 		pr_debug("struct_ops reloc %s: for %lld value %lld shdr_idx %u rel.r_o=
ffset %zu map->sec_offset %zu name %d (\'%s\')\n",
 			 map->name,
-			 (long long)(rel.r_info >> 32),
-			 (long long)sym.st_value,
+			 (__ps64)(rel.r_info >> 32),
+			 (__ps64)sym.st_value,
 			 shdr_idx, (size_t)rel.r_offset,
 			 map->sec_offset, sym.st_name, name);
=20
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_inter=
nal.h
index 4d1c366fca2c..7ad3c4b9917c 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -69,6 +69,17 @@ extern void libbpf_print(enum libbpf_print_level level=
,
 			 const char *format, ...)
 	__attribute__((format(printf, 2, 3)));
=20
+/* These types are for casting 64-bit arguments of printf-like functions=
 to
+ * avoid compiler warnings on various architectures that define size_t, =
__u64,
+ * uint64_t, etc as either unsigned long or unsigned long long (similarl=
y for
+ * signed variants). Use these typedefs only for these purposes. Alterna=
tive
+ * is PRIu64 (and similar) macros, requiring stitching printf format str=
ings
+ * which are extremely ugly and should be avoided in libbpf code base. W=
ith
+ * arguments casted to __pu64/__ps64, always use %llu/%lld in format str=
ing.
+ */
+typedef unsigned long long __pu64;
+typedef long long __ps64;
+
 #define __pr(level, fmt, ...)	\
 do {				\
 	libbpf_print(level, "libbpf: " fmt, ##__VA_ARGS__);	\
--=20
2.24.1

