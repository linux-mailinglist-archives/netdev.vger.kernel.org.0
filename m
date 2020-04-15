Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95F31AB1AD
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 21:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436574AbgDOT3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 15:29:17 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20646 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2411842AbgDOT23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 15:28:29 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03FJPM7p008538
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yKfP/7ju0dRYFRdfnVBsgmpyxRc4+rvgre4fkivzezM=;
 b=jYAcn1DSA/Te2FpBsHgtLKog50HZhxOShumbcFIWqh5quOJUW1yeKrRgdG5Q9Si0+TGB
 9oHC2alooBMqgkE5tAH5Ws1qtOmU/dr9hW4rT7FVm8ziiAfm+2oj1y2L8jdfTT6W40sM
 ZfS8Dlf4Hqul/UA4KPa2ePhV3U/i93hliTs= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30dn7t7m78-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 15 Apr 2020 12:28:26 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:21d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 12:27:56 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id 98E1C3700AF5; Wed, 15 Apr 2020 12:27:55 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next v2 13/17] tools/libbpf: libbpf support for bpfdump
Date:   Wed, 15 Apr 2020 12:27:55 -0700
Message-ID: <20200415192755.4083842-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200415192740.4082659-1-yhs@fb.com>
References: <20200415192740.4082659-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_07:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 adultscore=0 phishscore=0 malwarescore=0 impostorscore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 suspectscore=2
 lowpriorityscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2003020000 definitions=main-2004150143
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a few libbpf APIs for bpfdump pin.

Also, parse the dump program section name,
retrieve the dump target path and open the path
to get a fd and assignment to prog->attach_target_fd.
The implementation is absolutely minimum and hacky now.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c      |  9 +++-
 tools/lib/bpf/bpf.h      |  1 +
 tools/lib/bpf/libbpf.c   | 88 +++++++++++++++++++++++++++++++++++++---
 tools/lib/bpf/libbpf.h   |  3 ++
 tools/lib/bpf/libbpf.map |  2 +
 5 files changed, 95 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5cc1b0785d18..b23f11c53109 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -238,10 +238,15 @@ int bpf_load_program_xattr(const struct bpf_load_pr=
ogram_attr *load_attr,
 	if (attr.prog_type =3D=3D BPF_PROG_TYPE_STRUCT_OPS ||
 	    attr.prog_type =3D=3D BPF_PROG_TYPE_LSM) {
 		attr.attach_btf_id =3D load_attr->attach_btf_id;
-	} else if (attr.prog_type =3D=3D BPF_PROG_TYPE_TRACING ||
-		   attr.prog_type =3D=3D BPF_PROG_TYPE_EXT) {
+	} else if (attr.prog_type =3D=3D BPF_PROG_TYPE_EXT) {
 		attr.attach_btf_id =3D load_attr->attach_btf_id;
 		attr.attach_prog_fd =3D load_attr->attach_prog_fd;
+	} else if (attr.prog_type =3D=3D BPF_PROG_TYPE_TRACING) {
+		attr.attach_btf_id =3D load_attr->attach_btf_id;
+		if (attr.expected_attach_type =3D=3D BPF_TRACE_DUMP)
+			attr.attach_target_fd =3D load_attr->attach_target_fd;
+		else
+			attr.attach_prog_fd =3D load_attr->attach_prog_fd;
 	} else {
 		attr.prog_ifindex =3D load_attr->prog_ifindex;
 		attr.kern_version =3D load_attr->kern_version;
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 46d47afdd887..7f8d740afde9 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -81,6 +81,7 @@ struct bpf_load_program_attr {
 	union {
 		__u32 kern_version;
 		__u32 attach_prog_fd;
+		__u32 attach_target_fd;
 	};
 	union {
 		__u32 prog_ifindex;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ff9174282a8c..ad7726c0c1dc 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -79,6 +79,7 @@ static struct bpf_program *bpf_object__find_prog_by_idx=
(struct bpf_object *obj,
 							int idx);
 static const struct btf_type *
 skip_mods_and_typedefs(const struct btf *btf, __u32 id, __u32 *res_id);
+static int fill_dumper_info(struct bpf_program *prog);
=20
 static int __base_pr(enum libbpf_print_level level, const char *format,
 		     va_list args)
@@ -229,6 +230,7 @@ struct bpf_program {
 	enum bpf_attach_type expected_attach_type;
 	__u32 attach_btf_id;
 	__u32 attach_prog_fd;
+	__u32 attach_target_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -2365,8 +2367,12 @@ static inline bool libbpf_prog_needs_vmlinux_btf(s=
truct bpf_program *prog)
 	/* BPF_PROG_TYPE_TRACING programs which do not attach to other programs
 	 * also need vmlinux BTF
 	 */
-	if (prog->type =3D=3D BPF_PROG_TYPE_TRACING && !prog->attach_prog_fd)
-		return true;
+	if (prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
+		if (prog->expected_attach_type =3D=3D BPF_TRACE_DUMP)
+			return false;
+		if (!prog->attach_prog_fd)
+			return true;
+	}
=20
 	return false;
 }
@@ -4870,10 +4876,15 @@ load_program(struct bpf_program *prog, struct bpf=
_insn *insns, int insns_cnt,
 	if (prog->type =3D=3D BPF_PROG_TYPE_STRUCT_OPS ||
 	    prog->type =3D=3D BPF_PROG_TYPE_LSM) {
 		load_attr.attach_btf_id =3D prog->attach_btf_id;
-	} else if (prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
-		   prog->type =3D=3D BPF_PROG_TYPE_EXT) {
+	} else if (prog->type =3D=3D BPF_PROG_TYPE_EXT) {
 		load_attr.attach_prog_fd =3D prog->attach_prog_fd;
 		load_attr.attach_btf_id =3D prog->attach_btf_id;
+	} else if (prog->type =3D=3D BPF_PROG_TYPE_TRACING) {
+		load_attr.attach_btf_id =3D prog->attach_btf_id;
+		if (load_attr.expected_attach_type =3D=3D BPF_TRACE_DUMP)
+			load_attr.attach_target_fd =3D prog->attach_target_fd;
+		else
+			load_attr.attach_prog_fd =3D prog->attach_prog_fd;
 	} else {
 		load_attr.kern_version =3D kern_version;
 		load_attr.prog_ifindex =3D prog->prog_ifindex;
@@ -4958,7 +4969,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
r *license, __u32 kern_ver)
 {
 	int err =3D 0, fd, i, btf_id;
=20
-	if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
+	if (((prog->type =3D=3D BPF_PROG_TYPE_TRACING && prog->expected_attach_=
type !=3D BPF_TRACE_DUMP) ||
 	     prog->type =3D=3D BPF_PROG_TYPE_LSM ||
 	     prog->type =3D=3D BPF_PROG_TYPE_EXT) && !prog->attach_btf_id) {
 		btf_id =3D libbpf_find_attach_btf_id(prog);
@@ -5319,6 +5330,7 @@ static int bpf_object__resolve_externs(struct bpf_o=
bject *obj,
=20
 int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 	int err, i;
=20
@@ -5335,7 +5347,17 @@ int bpf_object__load_xattr(struct bpf_object_load_=
attr *attr)
=20
 	obj->loaded =3D true;
=20
-	err =3D bpf_object__probe_caps(obj);
+	err =3D 0;
+	bpf_object__for_each_program(prog, obj) {
+		if (prog->type =3D=3D BPF_PROG_TYPE_TRACING &&
+		    prog->expected_attach_type =3D=3D BPF_TRACE_DUMP) {
+			err =3D fill_dumper_info(prog);
+			if (err)
+				break;
+		}
+	}
+
+	err =3D err ? : bpf_object__probe_caps(obj);
 	err =3D err ? : bpf_object__resolve_externs(obj, obj->kconfig);
 	err =3D err ? : bpf_object__sanitize_and_load_btf(obj);
 	err =3D err ? : bpf_object__sanitize_maps(obj);
@@ -6322,6 +6344,8 @@ static const struct bpf_sec_def section_defs[] =3D =
{
 		.is_attach_btf =3D true,
 		.expected_attach_type =3D BPF_LSM_MAC,
 		.attach_fn =3D attach_lsm),
+	SEC_DEF("dump/", TRACING,
+		.expected_attach_type =3D BPF_TRACE_DUMP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -6401,6 +6425,58 @@ static const struct bpf_sec_def *find_sec_def(cons=
t char *sec_name)
 	return NULL;
 }
=20
+static int fill_dumper_info(struct bpf_program *prog)
+{
+	const struct bpf_sec_def *sec;
+	const char *dump_target;
+	int fd;
+
+	sec =3D find_sec_def(bpf_program__title(prog, false));
+	if (sec) {
+		dump_target =3D bpf_program__title(prog, false) + sec->len;
+		fd =3D open(dump_target, O_RDONLY);
+		if (fd < 0)
+			return fd;
+		prog->attach_target_fd =3D fd;
+	}
+	return 0;
+}
+
+int bpf_dump__pin(struct bpf_program *prog, const char *dname)
+{
+	int len, prog_fd =3D bpf_program__fd(prog);
+	const struct bpf_sec_def *sec;
+	const char *dump_target;
+	char *name_buf;
+	int err;
+
+	if (dname[0] =3D=3D '/')
+		return bpf_obj_pin(prog_fd, dname);
+
+	sec =3D find_sec_def(bpf_program__title(prog, false));
+	if (!sec)
+		return bpf_obj_pin(prog_fd, dname);
+
+	dump_target =3D bpf_program__title(prog, false) + sec->len;
+	len =3D strlen(dump_target) + strlen(dname) + 2;
+	name_buf =3D malloc(len);
+	if (!name_buf)
+		return -ENOMEM;
+
+	strcpy(name_buf, dump_target);
+	strcat(name_buf, "/");
+	strcat(name_buf, dname);
+
+	err =3D bpf_obj_pin(prog_fd, name_buf);
+	free(name_buf);
+	return err;
+}
+
+int bpf_dump__unpin(struct bpf_program *prog, const char *dname)
+{
+	return -EINVAL;
+}
+
 static char *libbpf_get_type_names(bool attach_type)
 {
 	int i, len =3D ARRAY_SIZE(section_defs) * MAX_TYPE_NAME_SIZE;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 44df1d3e7287..e0d31e93d21c 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -217,6 +217,9 @@ LIBBPF_API int bpf_program__pin(struct bpf_program *p=
rog, const char *path);
 LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *=
path);
 LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
=20
+LIBBPF_API int bpf_dump__pin(struct bpf_program *prog, const char *dname=
);
+LIBBPF_API int bpf_dump__unpin(struct bpf_program *prog, const char *dna=
me);
+
 struct bpf_link;
=20
 LIBBPF_API struct bpf_link *bpf_link__open(const char *path);
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bb8831605b25..0beb70bfe65a 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -238,6 +238,8 @@ LIBBPF_0.0.7 {
=20
 LIBBPF_0.0.8 {
 	global:
+		bpf_dump__pin;
+		bpf_dump__unpin;
 		bpf_link__fd;
 		bpf_link__open;
 		bpf_link__pin;
--=20
2.24.1

