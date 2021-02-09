Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A13315913
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 23:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbhBIWAc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 17:00:32 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:23824 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234305AbhBIVAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 16:00:19 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119JSsOO009519
        for <netdev@vger.kernel.org>; Tue, 9 Feb 2021 11:31:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=qeWMbAqsV2xnsezJY3EKVF37E1MCAJSZfNjLznhKVgU=;
 b=jSLsvcV6FFo+sCgs4TVhJuYfZfaQU2Tq6CAGrNZlXUGEwOvHetRV8tZk6wF7cK4PEj7N
 vkEwxxk5SS12teOgxU9Do0l6i0Ma5hPTmm1jNYF03i7tZm5Q4wDcqGYwHFZ3FTrSR6PL
 VWMULEU1W6xmoBvlGGoWtMHZWyCNC6ooIZs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 36jcaa518c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 11:31:09 -0800
Received: from intmgw006.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 11:31:08 -0800
Received: by devbig005.ftw2.facebook.com (Postfix, from userid 6611)
        id EAB8329408EB; Tue,  9 Feb 2021 11:31:05 -0800 (PST)
From:   Martin KaFai Lau <kafai@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH bpf 1/2] libbpf: Ignore non function pointer member in struct_ops
Date:   Tue, 9 Feb 2021 11:31:05 -0800
Message-ID: <20210209193105.1752743-1-kafai@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_06:2021-02-09,2021-02-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=602 phishscore=0
 bulkscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090094
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
after the existing "if (!prog) { continue; }".

The "btf_is_func_proto(mtype)" has already been guaranteed
in "bpf_object__collect_st_ops_relos()" which has been run
before "bpf_map__init_kern_struct_ops()".  Thus, this check
is removed.

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
---
 tools/lib/bpf/libbpf.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ae748f6ea11..b483608ea72a 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -887,12 +887,6 @@ static int bpf_map__init_kern_struct_ops(struct bpf_=
map *map,
 			kern_mtype =3D skip_mods_and_typedefs(kern_btf,
 							    kern_mtype->type,
 							    &kern_mtype_id);
-			if (!btf_is_func_proto(mtype) ||
-			    !btf_is_func_proto(kern_mtype)) {
-				pr_warn("struct_ops init_kern %s: non func ptr %s is not supported\n=
",
-					map->name, mname);
-				return -ENOTSUP;
-			}
=20
 			prog =3D st_ops->progs[i];
 			if (!prog) {
@@ -901,6 +895,12 @@ static int bpf_map__init_kern_struct_ops(struct bpf_=
map *map,
 				continue;
 			}
=20
+			if (!btf_is_func_proto(kern_mtype)) {
+				pr_warn("struct_ops init_kern %s: kernel member %s is not a func ptr=
\n",
+					map->name, mname);
+				return -ENOTSUP;
+			}
+
 			prog->attach_btf_id =3D kern_type_id;
 			prog->expected_attach_type =3D kern_member_idx;
=20
--=20
2.24.1

