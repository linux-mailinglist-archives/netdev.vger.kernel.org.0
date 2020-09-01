Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C664258561
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 03:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgIABud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Aug 2020 21:50:33 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58524 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726501AbgIABuY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Aug 2020 21:50:24 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0811m6BM009688
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fJMxN8Zuw20jslCbO+L7rVqWMogYw/X9JRFMkr9yhz4=;
 b=nrF4hesmXExzwIdCYr/V8erOsR7M/IpTT4X+3Sox4M4yxWXqRRuNeUcvhKwG9HULvHOm
 NGsRL5F3HoAcR/UYD8ByGzTWHph3sGlAfaBm8x0Ko8RlDGWXozV8t04N07t74P20ci6C
 yJAXZ87b0QPEobJelPMkvgoQtpR3aGBmZos= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 337jpnb74v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 18:50:23 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 31 Aug 2020 18:50:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 3ACBF2EC663B; Mon, 31 Aug 2020 18:50:18 -0700 (PDT)
From:   Andrii Nakryiko <andriin@fb.com>
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH v2 bpf-next 06/14] libbpf: add multi-prog section support for struct_ops
Date:   Mon, 31 Aug 2020 18:49:55 -0700
Message-ID: <20200901015003.2871861-7-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200901015003.2871861-1-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-01_01:2020-08-31,2020-09-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 phishscore=0 suspectscore=8
 mlxscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009010014
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adjust struct_ops handling code to work with multi-program ELF sections
properly.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 26 ++++++++------------------
 1 file changed, 8 insertions(+), 18 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a2ac10511852..1485e562ec32 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -73,8 +73,6 @@
 #define __printf(a, b)	__attribute__((format(printf, a, b)))
=20
 static struct bpf_map *bpf_object__add_map(struct bpf_object *obj);
-static struct bpf_program *bpf_object__find_prog_by_idx(struct bpf_objec=
t *obj,
-							int idx);
 static const struct btf_type *
 skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
=20
@@ -3249,20 +3247,6 @@ static int bpf_object__collect_externs(struct bpf_=
object *obj)
 	return 0;
 }
=20
-static struct bpf_program *
-bpf_object__find_prog_by_idx(struct bpf_object *obj, int idx)
-{
-	struct bpf_program *prog;
-	size_t i;
-
-	for (i =3D 0; i < obj->nr_programs; i++) {
-		prog =3D &obj->programs[i];
-		if (prog->sec_idx =3D=3D idx)
-			return prog;
-	}
-	return NULL;
-}
-
 struct bpf_program *
 bpf_object__find_program_by_title(const struct bpf_object *obj,
 				  const char *title)
@@ -8109,7 +8093,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 	const struct btf *btf;
 	struct bpf_map *map;
 	Elf_Data *symbols;
-	unsigned int moff;
+	unsigned int moff, insn_idx;
 	const char *name;
 	__u32 member_idx;
 	GElf_Sym sym;
@@ -8154,6 +8138,12 @@ static int bpf_object__collect_st_ops_relos(struct=
 bpf_object *obj,
 				map->name, (size_t)rel.r_offset, shdr_idx);
 			return -LIBBPF_ERRNO__RELOC;
 		}
+		if (sym.st_value % BPF_INSN_SZ) {
+			pr_warn("struct_ops reloc %s: invalid target program offset %llu\n",
+				map->name, (__u64)sym.st_value);
+			return -LIBBPF_ERRNO__FORMAT;
+		}
+		insn_idx =3D sym.st_value / BPF_INSN_SZ;
=20
 		member =3D find_member_by_offset(st_ops->type, moff * 8);
 		if (!member) {
@@ -8170,7 +8160,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 			return -EINVAL;
 		}
=20
-		prog =3D bpf_object__find_prog_by_idx(obj, shdr_idx);
+		prog =3D find_prog_by_sec_insn(obj, shdr_idx, insn_idx);
 		if (!prog) {
 			pr_warn("struct_ops reloc %s: cannot find prog at shdr_idx %u to relo=
cate func ptr %s\n",
 				map->name, shdr_idx, name);
--=20
2.24.1

