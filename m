Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2916217CCD
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 03:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729170AbgGHBxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 21:53:36 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25586 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728676AbgGHBxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 21:53:36 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0681nxAo003479
        for <netdev@vger.kernel.org>; Tue, 7 Jul 2020 18:53:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=l7ybyVm3gXGYW9nLFN0RjpbqK1EEKygZobzGb16Pl/k=;
 b=gaArTOKTcuYpiKuD1IOUZ/5akf0S0GK5ESbLLYT0aHrb3gmcCt7rj6TNyr0GSnEXfAZh
 GUk4OdV8ACYWL8JcM0BDaWhol7EQYeN+1H7GnzikZqBzjP51oHNVDA8mLCGIa0UZbeM0
 UOwJlu5zd+mz3KoSTTAg01wdWUo7w69Zutw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 322q9vqmej-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 18:53:34 -0700
Received: from intmgw003.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 7 Jul 2020 18:53:31 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0E9BD2EC39F5; Tue,  7 Jul 2020 18:53:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Matthew Lim <matthewlim@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/6] libbpf: improve BTF sanitization handling
Date:   Tue, 7 Jul 2020 18:53:15 -0700
Message-ID: <20200708015318.3827358-4-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200708015318.3827358-1-andriin@fb.com>
References: <20200708015318.3827358-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-07_15:2020-07-07,2020-07-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxscore=0 clxscore=1015 cotscore=-2147483648
 suspectscore=25 impostorscore=0 mlxlogscore=979 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2007080010
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change sanitization process to preserve original BTF, which might be used=
 by
libbpf itself for Kconfig externs, CO-RE relocs, etc, even if kernel is o=
ld
and doesn't support BTF. To achieve that, if libbpf detects the need for =
BTF
sanitization, it would clone original BTF, sanitize it in-place, attempt =
to
load it into kernel, and if successful, will preserve loaded BTF FD in
original `struct btf`, while freeing sanitized local copy.

If kernel doesn't support any BTF, original btf and btf_ext will still be
preserved to be used later for CO-RE relocation and other BTF-dependent l=
ibbpf
features, which don't dependon kernel BTF support.

Patch takes care to not specify BTF and BTF.ext features when loading BPF
programs and/or maps, if it was detected that kernel doesn't support BTF
features.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 103 +++++++++++++++++++++++------------------
 1 file changed, 58 insertions(+), 45 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index f4a1cf7f4873..b4f50d12f51f 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -2338,18 +2338,23 @@ static bool section_have_execinstr(struct bpf_obj=
ect *obj, int idx)
 	return false;
 }
=20
-static void bpf_object__sanitize_btf(struct bpf_object *obj)
+static bool btf_needs_sanitization(struct bpf_object *obj)
+{
+	bool has_func_global =3D obj->caps.btf_func_global;
+	bool has_datasec =3D obj->caps.btf_datasec;
+	bool has_func =3D obj->caps.btf_func;
+
+	return !has_func || !has_datasec || !has_func_global;
+}
+
+static void bpf_object__sanitize_btf(struct bpf_object *obj, struct btf =
*btf)
 {
 	bool has_func_global =3D obj->caps.btf_func_global;
 	bool has_datasec =3D obj->caps.btf_datasec;
 	bool has_func =3D obj->caps.btf_func;
-	struct btf *btf =3D obj->btf;
 	struct btf_type *t;
 	int i, j, vlen;
=20
-	if (!obj->btf || (has_func && has_datasec && has_func_global))
-		return;
-
 	for (i =3D 1; i <=3D btf__get_nr_types(btf); i++) {
 		t =3D (struct btf_type *)btf__type_by_id(btf, i);
=20
@@ -2402,17 +2407,6 @@ static void bpf_object__sanitize_btf(struct bpf_ob=
ject *obj)
 	}
 }
=20
-static void bpf_object__sanitize_btf_ext(struct bpf_object *obj)
-{
-	if (!obj->btf_ext)
-		return;
-
-	if (!obj->caps.btf_func) {
-		btf_ext__free(obj->btf_ext);
-		obj->btf_ext =3D NULL;
-	}
-}
-
 static bool libbpf_needs_btf(const struct bpf_object *obj)
 {
 	return obj->efile.btf_maps_shndx >=3D 0 ||
@@ -2530,30 +2524,50 @@ static int bpf_object__load_vmlinux_btf(struct bp=
f_object *obj)
=20
 static int bpf_object__sanitize_and_load_btf(struct bpf_object *obj)
 {
+	struct btf *kern_btf =3D obj->btf;
+	bool btf_mandatory, sanitize;
 	int err =3D 0;
=20
 	if (!obj->btf)
 		return 0;
=20
-	bpf_object__sanitize_btf(obj);
-	bpf_object__sanitize_btf_ext(obj);
+	sanitize =3D btf_needs_sanitization(obj);
+	if (sanitize) {
+		const void *orig_data;
+		void *san_data;
+		__u32 sz;
=20
-	err =3D btf__load(obj->btf);
-	if (err) {
-		pr_warn("Error loading %s into kernel: %d.\n",
-			BTF_ELF_SEC, err);
-		btf__free(obj->btf);
-		obj->btf =3D NULL;
-		/* btf_ext can't exist without btf, so free it as well */
-		if (obj->btf_ext) {
-			btf_ext__free(obj->btf_ext);
-			obj->btf_ext =3D NULL;
-		}
+		/* clone BTF to sanitize a copy and leave the original intact */
+		orig_data =3D btf__get_raw_data(obj->btf, &sz);
+		san_data =3D malloc(sz);
+		if (!san_data)
+			return -ENOMEM;
+		memcpy(san_data, orig_data, sz);
+		kern_btf =3D btf__new(san_data, sz);
+		if (IS_ERR(kern_btf))
+			return PTR_ERR(kern_btf);
=20
-		if (kernel_needs_btf(obj))
-			return err;
+		bpf_object__sanitize_btf(obj, kern_btf);
 	}
-	return 0;
+
+	err =3D btf__load(kern_btf);
+	if (sanitize) {
+		if (!err) {
+			/* move fd to libbpf's BTF */
+			btf__set_fd(obj->btf, btf__fd(kern_btf));
+			btf__set_fd(kern_btf, -1);
+		}
+		btf__free(kern_btf);
+	}
+	if (err) {
+		btf_mandatory =3D kernel_needs_btf(obj);
+		pr_warn("Error loading .BTF into kernel: %d. %s\n", err,
+			btf_mandatory ? "BTF is mandatory, can't proceed."
+				      : "BTF is optional, ignoring.");
+		if (!btf_mandatory)
+			err =3D 0;
+	}
+	return err;
 }
=20
 static int bpf_object__elf_collect(struct bpf_object *obj)
@@ -3777,7 +3791,7 @@ static int bpf_object__create_map(struct bpf_object=
 *obj, struct bpf_map *map)
 	create_attr.btf_fd =3D 0;
 	create_attr.btf_key_type_id =3D 0;
 	create_attr.btf_value_type_id =3D 0;
-	if (obj->btf && !bpf_map_find_btf_info(obj, map)) {
+	if (obj->btf && btf__fd(obj->btf) >=3D 0 && !bpf_map_find_btf_info(obj,=
 map)) {
 		create_attr.btf_fd =3D btf__fd(obj->btf);
 		create_attr.btf_key_type_id =3D map->btf_key_type_id;
 		create_attr.btf_value_type_id =3D map->btf_value_type_id;
@@ -5361,18 +5375,17 @@ load_program(struct bpf_program *prog, struct bpf=
_insn *insns, int insns_cnt,
 		load_attr.kern_version =3D kern_version;
 		load_attr.prog_ifindex =3D prog->prog_ifindex;
 	}
-	/* if .BTF.ext was loaded, kernel supports associated BTF for prog */
-	if (prog->obj->btf_ext)
-		btf_fd =3D bpf_object__btf_fd(prog->obj);
-	else
-		btf_fd =3D -1;
-	load_attr.prog_btf_fd =3D btf_fd >=3D 0 ? btf_fd : 0;
-	load_attr.func_info =3D prog->func_info;
-	load_attr.func_info_rec_size =3D prog->func_info_rec_size;
-	load_attr.func_info_cnt =3D prog->func_info_cnt;
-	load_attr.line_info =3D prog->line_info;
-	load_attr.line_info_rec_size =3D prog->line_info_rec_size;
-	load_attr.line_info_cnt =3D prog->line_info_cnt;
+	/* specify func_info/line_info only if kernel supports them */
+	btf_fd =3D bpf_object__btf_fd(prog->obj);
+	if (btf_fd >=3D 0 && prog->obj->caps.btf_func) {
+		load_attr.prog_btf_fd =3D btf_fd;
+		load_attr.func_info =3D prog->func_info;
+		load_attr.func_info_rec_size =3D prog->func_info_rec_size;
+		load_attr.func_info_cnt =3D prog->func_info_cnt;
+		load_attr.line_info =3D prog->line_info;
+		load_attr.line_info_rec_size =3D prog->line_info_rec_size;
+		load_attr.line_info_cnt =3D prog->line_info_cnt;
+	}
 	load_attr.log_level =3D prog->log_level;
 	load_attr.prog_flags =3D prog->prog_flags;
=20
--=20
2.24.1

