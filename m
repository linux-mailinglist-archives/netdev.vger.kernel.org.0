Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06B40319836
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 03:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbhBLCLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 21:11:18 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:29054 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229547AbhBLCLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 21:11:15 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11C2AMqf028270
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 18:10:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=n3X+eeKZMDVhWIl1ZrY+U/19oZ27D9nk958D3k7giLk=;
 b=gKD6Zz7PdIIkVu4PDKRSdtqCd4ss6zLUvdKgHJyqL91mHWIgeLIlxQlFC2HKnZsm56CM
 zbpQkv389M86lV32GkuL6Mi57B+jnCjQZIrGKYG29jGmhXVlLCwecM+gy8DXKKJ+c6kh
 IEC89yAGn6D004nKSeh8oQ7EY0OX2uKGGPA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 36mj9x21gc-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 18:10:33 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 11 Feb 2021 18:10:32 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EF4D329425C2; Thu, 11 Feb 2021 18:10:30 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH v2 bpf 1/2] libbpf: Ignore non function pointer member in struct_ops
Date:   Thu, 11 Feb 2021 18:10:30 -0800
Message-ID: <20210212021030.266932-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 priorityscore=1501 impostorscore=0 suspectscore=0 spamscore=0
 malwarescore=0 clxscore=1015 mlxscore=0 mlxlogscore=730 adultscore=0
 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2102120014
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When libbpf initializes the kernel's struct_ops in
"bpf_map__init_kern_struct_ops()", it enforces all
pointer types must be a function pointer and rejects
others.  It turns out to be too strict.  For example,
when directly using "struct tcp_congestion_ops" from vmlinux.h,
it has a "struct module *owner" member and it is set to NULL
in a bpf_tcp_cc.o.

Instead, it only needs to ensure the member is a function
pointer if it has been set (relocated) to a bpf-prog.
This patch moves the "btf_is_func_proto(kern_mtype)" check
after the existing "if (!prog) { continue; }".  The original debug
message in "if (!prog) { continue; }" is also removed since it is
no longer valid.  Beside, there is a later debug message to tell
which function pointer is set.

The "btf_is_func_proto(mtype)" has already been guaranteed
in "bpf_object__collect_st_ops_relos()" which has been run
before "bpf_map__init_kern_struct_ops()".  Thus, this check
is removed.

v2:
- Remove outdated debug message (Andrii)
  Remove because there is a later debug message to tell
  which function pointer is set.
- Following mtype->type is no longer needed. Remove:
  "skip_mods_and_typedefs(btf, mtype->type, &mtype_id)"
- Do "if (!prog)" test before skip_mods_and_typedefs.

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ae748f6ea11..a0d4fc4de402 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -883,24 +883,24 @@ static int bpf_map__init_kern_struct_ops(struct bpf=
_map *map,
 		if (btf_is_ptr(mtype)) {
 			struct bpf_program *prog;
=20
-			mtype =3D skip_mods_and_typedefs(btf, mtype->type, &mtype_id);
+			prog =3D st_ops->progs[i];
+			if (!prog)
+				continue;
+
 			kern_mtype =3D skip_mods_and_typedefs(kern_btf,
 							    kern_mtype->type,
 							    &kern_mtype_id);
-			if (!btf_is_func_proto(mtype) ||
-			    !btf_is_func_proto(kern_mtype)) {
-				pr_warn("struct_ops init_kern %s: non func ptr %s is not supported\n=
",
+
+			/* mtype->type must be a func_proto which was
+			 * guaranteed in bpf_object__collect_st_ops_relos(),
+			 * so only check kern_mtype for func_proto here.
+			 */
+			if (!btf_is_func_proto(kern_mtype)) {
+				pr_warn("struct_ops init_kern %s: kernel member %s is not a func ptr=
\n",
 					map->name, mname);
 				return -ENOTSUP;
 			}
=20
-			prog =3D st_ops->progs[i];
-			if (!prog) {
-				pr_debug("struct_ops init_kern %s: func ptr %s is not set\n",
-					 map->name, mname);
-				continue;
-			}
-
 			prog->attach_btf_id =3D kern_type_id;
 			prog->expected_attach_type =3D kern_member_idx;
=20
--=20
2.24.1

