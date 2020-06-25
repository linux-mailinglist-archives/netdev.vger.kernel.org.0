Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F3720A8D1
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390999AbgFYX0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:26:41 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15840 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390973AbgFYX0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:26:40 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PNP2Zs005348
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:26:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=O4IM4mpnzr7vgIA5lsTt2Q+KkRs3BwRS6vEquW93BCg=;
 b=DrXhKuuJLGG8OkVFjZHLqayY8BbYINIVLZzxbWGtVS0FwKjpVa+fK/URHc1QRXYgfLpq
 GjiQtkaNX5ddUciqBLI10lEDbal5VSdHlQLVTY1bCpCBBlk++5uuBTaD7Y8thn4MGddl
 U44X3r1pKWcZG6gczdpY4ahKwRRM0pghV3M= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 31ux0qas2r-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:26:38 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 25 Jun 2020 16:26:36 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id AA0692EC3954; Thu, 25 Jun 2020 16:26:35 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 1/2] libbpf: support disabling auto-loading BPF programs
Date:   Thu, 25 Jun 2020 16:26:28 -0700
Message-ID: <20200625232629.3444003-2-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200625232629.3444003-1-andriin@fb.com>
References: <20200625232629.3444003-1-andriin@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_19:2020-06-25,2020-06-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 mlxscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 suspectscore=29 phishscore=0 clxscore=1015
 cotscore=-2147483648 mlxlogscore=999 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006250136
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, bpf_object__load() (and by induction skeleton's load), will al=
ways
attempt to prepare, relocate, and load into kernel every single BPF progr=
am
found inside the BPF object file. This is often convenient and the right =
thing
to do and what users expect.

But there are plenty of cases (especially with BPF development constantly
picking up the pace), where BPF application is intended to work with old
kernels, with potentially reduced set of features. But on kernels support=
ing
extra features, it would like to take a full advantage of them, by employ=
ing
extra BPF program. This could be a choice of using fentry/fexit over
kprobe/kretprobe, if kernel is recent enough and is built with BTF. Or BP=
F
program might be providing optimized bpf_iter-based solution that user-sp=
ace
might want to use, whenever available. And so on.

With libbpf and BPF CO-RE in particular, it's advantageous to not have to
maintain two separate BPF object files to achieve this. So to enable such=
 use
cases, this patch adds ability to request not auto-loading chosen BPF
programs. In such case, libbpf won't attempt to perform relocations (whic=
h
might fail due to old kernel), won't try to resolve BTF types for
BTF-aware (tp_btf/fentry/fexit/etc) program types, because BTF might not =
be
present, and so on. Skeleton will also automatically skip auto-attachment=
 step
for such not loaded BPF programs.

Overall, this feature allows to simplify development and deployment of
real-world BPF applications with complicated compatibility requirements.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 48 +++++++++++++++++++++++++++++++++-------
 tools/lib/bpf/libbpf.h   |  2 ++
 tools/lib/bpf/libbpf.map |  2 ++
 3 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6b4955d170ff..4ea7f4f1a691 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -230,6 +230,7 @@ struct bpf_program {
 	struct bpf_insn *insns;
 	size_t insns_cnt, main_prog_cnt;
 	enum bpf_prog_type type;
+	bool load;
=20
 	struct reloc_desc *reloc_desc;
 	int nr_reloc;
@@ -541,6 +542,7 @@ bpf_program__init(void *data, size_t size, char *sect=
ion_name, int idx,
 	prog->instances.fds =3D NULL;
 	prog->instances.nr =3D -1;
 	prog->type =3D BPF_PROG_TYPE_UNSPEC;
+	prog->load =3D true;
=20
 	return 0;
 errout:
@@ -2513,6 +2515,8 @@ static int bpf_object__load_vmlinux_btf(struct bpf_=
object *obj)
 		need_vmlinux_btf =3D true;
=20
 	bpf_object__for_each_program(prog, obj) {
+		if (!prog->load)
+			continue;
 		if (libbpf_prog_needs_vmlinux_btf(prog)) {
 			need_vmlinux_btf =3D true;
 			break;
@@ -5445,6 +5449,12 @@ int bpf_program__load(struct bpf_program *prog, ch=
ar *license, __u32 kern_ver)
 {
 	int err =3D 0, fd, i, btf_id;
=20
+	if (prog->obj->loaded) {
+		pr_warn("prog '%s'('%s'): can't load after object was loaded\n",
+			prog->name, prog->section_name);
+		return -EINVAL;
+	}
+
 	if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
 	     prog->type =3D=3D BPF_PROG_TYPE_LSM ||
 	     prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
@@ -5533,16 +5543,21 @@ static bool bpf_program__is_function_storage(cons=
t struct bpf_program *prog,
 static int
 bpf_object__load_progs(struct bpf_object *obj, int log_level)
 {
+	struct bpf_program *prog;
 	size_t i;
 	int err;
=20
 	for (i =3D 0; i < obj->nr_programs; i++) {
-		if (bpf_program__is_function_storage(&obj->programs[i], obj))
+		prog =3D &obj->programs[i];
+		if (bpf_program__is_function_storage(prog, obj))
 			continue;
-		obj->programs[i].log_level |=3D log_level;
-		err =3D bpf_program__load(&obj->programs[i],
-					obj->license,
-					obj->kern_version);
+		if (!prog->load) {
+			pr_debug("prog '%s'('%s'): skipped loading\n",
+				 prog->name, prog->section_name);
+			continue;
+		}
+		prog->log_level |=3D log_level;
+		err =3D bpf_program__load(prog, obj->license, obj->kern_version);
 		if (err)
 			return err;
 	}
@@ -5869,12 +5884,10 @@ int bpf_object__load_xattr(struct bpf_object_load=
_attr *attr)
 		return -EINVAL;
=20
 	if (obj->loaded) {
-		pr_warn("object should not be loaded twice\n");
+		pr_warn("object '%s': load can't be attempted twice\n", obj->name);
 		return -EINVAL;
 	}
=20
-	obj->loaded =3D true;
-
 	err =3D bpf_object__probe_loading(obj);
 	err =3D err ? : bpf_object__probe_caps(obj);
 	err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
@@ -5889,6 +5902,8 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
ttr *attr)
 	btf__free(obj->btf_vmlinux);
 	obj->btf_vmlinux =3D NULL;
=20
+	obj->loaded =3D true; /* doesn't matter if successfully or not */
+
 	if (err)
 		goto out;
=20
@@ -6661,6 +6676,20 @@ const char *bpf_program__title(const struct bpf_pr=
ogram *prog, bool needs_copy)
 	return title;
 }
=20
+bool bpf_program__autoload(const struct bpf_program *prog)
+{
+	return prog->load;
+}
+
+int bpf_program__set_autoload(struct bpf_program *prog, bool autoload)
+{
+	if (prog->obj->loaded)
+		return -EINVAL;
+
+	prog->load =3D autoload;
+	return 0;
+}
+
 int bpf_program__fd(const struct bpf_program *prog)
 {
 	return bpf_program__nth_fd(prog, 0);
@@ -9283,6 +9312,9 @@ int bpf_object__attach_skeleton(struct bpf_object_s=
keleton *s)
 		const struct bpf_sec_def *sec_def;
 		const char *sec_name =3D bpf_program__title(prog, false);
=20
+		if (!prog->load)
+			continue;
+
 		sec_def =3D find_sec_def(sec_name);
 		if (!sec_def || !sec_def->attach_fn)
 			continue;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index fdd279fb1866..2335971ed0bd 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -200,6 +200,8 @@ LIBBPF_API void bpf_program__set_ifindex(struct bpf_p=
rogram *prog,
 LIBBPF_API const char *bpf_program__name(const struct bpf_program *prog)=
;
 LIBBPF_API const char *bpf_program__title(const struct bpf_program *prog=
,
 					  bool needs_copy);
+LIBBPF_API bool bpf_program__autoload(const struct bpf_program *prog);
+LIBBPF_API int bpf_program__set_autoload(struct bpf_program *prog, bool =
autoload);
=20
 /* returns program size in bytes */
 LIBBPF_API size_t bpf_program__size(const struct bpf_program *prog);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 9914e0db4859..6544d2cd1ed6 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -286,4 +286,6 @@ LIBBPF_0.1.0 {
 		bpf_map__set_value_size;
 		bpf_map__type;
 		bpf_map__value_size;
+		bpf_program__autoload;
+		bpf_program__set_autoload;
 } LIBBPF_0.0.9;
--=20
2.24.1

