Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A10824C858
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:14:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgHTXOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:14:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:33446 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728832AbgHTXOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:14:00 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 07KN8O1r019071
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=BwDNb5yQDSR+FufReOEKA1VEU9uq8WRi6YngKfALl9Y=;
 b=c+Dum+K7lGvmm5l+D4KdQ9g5e7/amOOTKLMIhnbHuBYwe8EXPuu+M3w4ry3+9nKVfdg8
 UCws/pyfrwAjnf7sckwizhL4KI9xxdhA+cKCEEJNQdOXTHYdglDKWt/dfYkNERLnClWU
 3wuS5Ut3xWLtKqcRbeMMTjoJhUGZOLn+mRw= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 3304jjh7kd-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:13:59 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 20 Aug 2020 16:13:22 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 313362EC5F42; Thu, 20 Aug 2020 16:13:16 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 11/16] libbpf: add multi-prog section support for struct_ops
Date:   Thu, 20 Aug 2020 16:12:45 -0700
Message-ID: <20200820231250.1293069-12-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200820231250.1293069-1-andriin@fb.com>
References: <20200820231250.1293069-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-20_07:2020-08-19,2020-08-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=8
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=983 phishscore=0 mlxscore=0
 clxscore=1015 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008200189
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
index 2151bb0ecfb8..c6edd8eb614b 100644
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
@@ -3247,20 +3245,6 @@ static int bpf_object__collect_externs(struct bpf_=
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
@@ -8084,7 +8068,7 @@ static int bpf_object__collect_st_ops_relos(struct =
bpf_object *obj,
 	const struct btf *btf;
 	struct bpf_map *map;
 	Elf_Data *symbols;
-	unsigned int moff;
+	unsigned int moff, insn_idx;
 	const char *name;
 	__u32 member_idx;
 	GElf_Sym sym;
@@ -8129,6 +8113,12 @@ static int bpf_object__collect_st_ops_relos(struct=
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
@@ -8145,7 +8135,7 @@ static int bpf_object__collect_st_ops_relos(struct =
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

