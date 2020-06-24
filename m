Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC3E206B50
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbgFXEig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:38:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:57134 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727862AbgFXEif (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 00:38:35 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05O4cZO9029224
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 21:38:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=3AzvELCBJnKMvHSgbHT4AqvyHP0fR8lFsSr95PwDW/E=;
 b=d29wAui7nBOsbUZPN6AhPeek5wX0PrbcNngxukk8TivshPfD6QtSd7zE7kLGHd53+Xvm
 TTUr0GXxcKlQLNBEX8XBtscaNXP0BNg/8fJ2Dm7bkraHaC5JALKxtO0foasGgVB8wlKR
 Vqqur57+/YSH8J5dlWFnvq89mvXS41mXHa4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0krctf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 23 Jun 2020 21:38:35 -0700
Received: from intmgw001.03.ash8.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 23 Jun 2020 21:38:28 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 2B6C92EC3938; Tue, 23 Jun 2020 21:38:24 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: prevent loading vmlinux BTF twice
Date:   Tue, 23 Jun 2020 21:38:05 -0700
Message-ID: <20200624043805.1794620-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-24_01:2020-06-23,2020-06-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=25 mlxlogscore=999
 clxscore=1015 priorityscore=1501 mlxscore=0 cotscore=-2147483648
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006240034
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prevent loading/parsing vmlinux BTF twice in some cases: for CO-RE reloca=
tions
and for BTF-aware hooks (tp_btf, fentry/fexit, etc).

Fixes: a6ed02cac690 ("libbpf: Load btf_vmlinux only once per object.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 18461deb1b19..1e77bbfe6c63 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2504,22 +2504,31 @@ static inline bool libbpf_prog_needs_vmlinux_btf(=
struct bpf_program *prog)
=20
 static int bpf_object__load_vmlinux_btf(struct bpf_object *obj)
 {
+	bool need_vmlinux_btf =3D false;
 	struct bpf_program *prog;
 	int err;
=20
+	/* CO-RE relocations need kernel BTF */
+	if (obj->btf_ext && obj->btf_ext->field_reloc_info.len)
+		need_vmlinux_btf =3D true;
+
 	bpf_object__for_each_program(prog, obj) {
 		if (libbpf_prog_needs_vmlinux_btf(prog)) {
-			obj->btf_vmlinux =3D libbpf_find_kernel_btf();
-			if (IS_ERR(obj->btf_vmlinux)) {
-				err =3D PTR_ERR(obj->btf_vmlinux);
-				pr_warn("Error loading vmlinux BTF: %d\n", err);
-				obj->btf_vmlinux =3D NULL;
-				return err;
-			}
-			return 0;
+			need_vmlinux_btf =3D true;
+			break;
 		}
 	}
=20
+	if (!need_vmlinux_btf)
+		return 0;
+
+	obj->btf_vmlinux =3D libbpf_find_kernel_btf();
+	if (IS_ERR(obj->btf_vmlinux)) {
+		err =3D PTR_ERR(obj->btf_vmlinux);
+		pr_warn("Error loading vmlinux BTF: %d\n", err);
+		obj->btf_vmlinux =3D NULL;
+		return err;
+	}
 	return 0;
 }
=20
@@ -4945,8 +4954,8 @@ bpf_core_reloc_fields(struct bpf_object *obj, const=
 char *targ_btf_path)
 	if (targ_btf_path)
 		targ_btf =3D btf__parse_elf(targ_btf_path, NULL);
 	else
-		targ_btf =3D libbpf_find_kernel_btf();
-	if (IS_ERR(targ_btf)) {
+		targ_btf =3D obj->btf_vmlinux;
+	if (IS_ERR_OR_NULL(targ_btf)) {
 		pr_warn("failed to get target BTF: %ld\n", PTR_ERR(targ_btf));
 		return PTR_ERR(targ_btf);
 	}
@@ -4987,7 +4996,9 @@ bpf_core_reloc_fields(struct bpf_object *obj, const=
 char *targ_btf_path)
 	}
=20
 out:
-	btf__free(targ_btf);
+	/* obj->btf_vmlinux is freed at the end of object load phase */
+	if (targ_btf !=3D obj->btf_vmlinux)
+		btf__free(targ_btf);
 	if (!IS_ERR_OR_NULL(cand_cache)) {
 		hashmap__for_each_entry(cand_cache, entry, i) {
 			bpf_core_free_cands(entry->value);
--=20
2.24.1

