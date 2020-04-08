Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A20021A2C3F
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 01:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbgDHXZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 19:25:50 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44332 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726609AbgDHXZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 19:25:49 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 038NPktG019414
        for <netdev@vger.kernel.org>; Wed, 8 Apr 2020 16:25:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=iY/N6EyknMM8ykkZlA2aWrMlYJg1LKgpcNsAiirlEvA=;
 b=SuCfeFV1buL45opqHmzKIOznPBIzJHYQmx2Ar0V9rFe+PyacQ6SF/zq6D3kmG972T88d
 Avr6xKhxypX9X+oCO5dxBA9PIDgYMg33yZ0L9aZ496qyjFAjoDNjbHXLwurrMqYngcIO
 3BqelpI0UvAJ84MCcH+Qf2LkW4GN62JmL/4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 3091m37bq5-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 16:25:48 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 8 Apr 2020 16:25:36 -0700
Received: by devbig003.ftw2.facebook.com (Postfix, from userid 128203)
        id E15AE3700D98; Wed,  8 Apr 2020 16:25:34 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Yonghong Song <yhs@fb.com>
Smtp-Origin-Hostname: devbig003.ftw2.facebook.com
To:     Andrii Nakryiko <andriin@fb.com>, <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, <netdev@vger.kernel.org>
CC:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 12/16] tools/libbpf: libbpf support for bpfdump
Date:   Wed, 8 Apr 2020 16:25:34 -0700
Message-ID: <20200408232534.2676393-1-yhs@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200408232520.2675265-1-yhs@fb.com>
References: <20200408232520.2675265-1-yhs@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-08_09:2020-04-07,2020-04-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 spamscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0 lowpriorityscore=0
 malwarescore=0 impostorscore=0 priorityscore=1501 clxscore=1015
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004080164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a few libbpf APIs for bpfdump pin and query.

Also, parse the dump program section name,
retrieve the dump target path and open the path
to get a fd and assignment to prog->attach_prog_fd.
This is not really desirable, and need to think
more how to have equally better user interface
and cope with libbpf well.

Signed-off-by: Yonghong Song <yhs@fb.com>
---
 tools/lib/bpf/bpf.c      | 33 +++++++++++++++++++++++++++
 tools/lib/bpf/bpf.h      |  5 +++++
 tools/lib/bpf/libbpf.c   | 48 ++++++++++++++++++++++++++++++++++++----
 tools/lib/bpf/libbpf.h   |  1 +
 tools/lib/bpf/libbpf.map |  3 +++
 5 files changed, 86 insertions(+), 4 deletions(-)

diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 5cc1b0785d18..e8d4304fcc98 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -533,6 +533,39 @@ int bpf_obj_get(const char *pathname)
 	return sys_bpf(BPF_OBJ_GET, &attr, sizeof(attr));
 }
=20
+int bpf_obj_pin_dumper(int fd, const char *dname)
+{
+	union bpf_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.dumper_name =3D ptr_to_u64((void *)dname);
+	attr.bpf_fd =3D fd;
+	attr.file_flags =3D BPF_F_DUMP;
+
+	return sys_bpf(BPF_OBJ_PIN, &attr, sizeof(attr));
+}
+
+int bpf_dump_query(int query_fd, __u32 flags, void *target_proto_buf,
+		   __u32 buf_len, __u32 *prog_id)
+{
+	union bpf_attr attr;
+	int ret;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.dump_query.query_fd =3D query_fd;
+	attr.dump_query.flags =3D flags;
+	if (target_proto_buf) {
+		attr.dump_query.target_proto =3D ptr_to_u64((void *)target_proto_buf);
+		attr.dump_query.proto_buf_len =3D buf_len;
+	}
+
+	ret =3D sys_bpf(BPF_DUMP_QUERY, &attr, sizeof(attr));
+	if (!ret && prog_id)
+		*prog_id =3D attr.dump_query.prog_id;
+
+	return ret;
+}
+
 int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type typ=
e,
 		    unsigned int flags)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index 46d47afdd887..2f89f8445962 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -149,8 +149,13 @@ LIBBPF_API int bpf_map_update_batch(int fd, void *ke=
ys, void *values,
 				    __u32 *count,
 				    const struct bpf_map_batch_opts *opts);
=20
+LIBBPF_API int bpf_dump_query(int query_fd, __u32 flags,
+			      void *target_proto_buf, __u32 buf_len,
+			      __u32 *prog_id);
+
 LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
 LIBBPF_API int bpf_obj_get(const char *pathname);
+LIBBPF_API int bpf_obj_pin_dumper(int fd, const char *dname);
=20
 struct bpf_prog_attach_opts {
 	size_t sz; /* size of this struct for forward/backward compatibility */
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ff9174282a8c..c7a81ede56ce 100644
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
@@ -2365,8 +2366,12 @@ static inline bool libbpf_prog_needs_vmlinux_btf(s=
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
@@ -4958,7 +4963,7 @@ int bpf_program__load(struct bpf_program *prog, cha=
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
@@ -5319,6 +5324,7 @@ static int bpf_object__resolve_externs(struct bpf_o=
bject *obj,
=20
 int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
 {
+	struct bpf_program *prog;
 	struct bpf_object *obj;
 	int err, i;
=20
@@ -5335,7 +5341,17 @@ int bpf_object__load_xattr(struct bpf_object_load_=
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
@@ -5459,6 +5475,11 @@ int bpf_program__pin_instance(struct bpf_program *=
prog, const char *path,
 	return 0;
 }
=20
+int bpf_program__pin_dumper(struct bpf_program *prog, const char *dname)
+{
+	return bpf_obj_pin_dumper(bpf_program__fd(prog), dname);
+}
+
 int bpf_program__unpin_instance(struct bpf_program *prog, const char *pa=
th,
 				int instance)
 {
@@ -6322,6 +6343,8 @@ static const struct bpf_sec_def section_defs[] =3D =
{
 		.is_attach_btf =3D true,
 		.expected_attach_type =3D BPF_LSM_MAC,
 		.attach_fn =3D attach_lsm),
+	SEC_DEF("dump/", TRACING,
+		.expected_attach_type =3D BPF_TRACE_DUMP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -6401,6 +6424,23 @@ static const struct bpf_sec_def *find_sec_def(cons=
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
+		prog->attach_prog_fd =3D fd;
+	}
+	return 0;
+}
+
 static char *libbpf_get_type_names(bool attach_type)
 {
 	int i, len =3D ARRAY_SIZE(section_defs) * MAX_TYPE_NAME_SIZE;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 44df1d3e7287..ccb5d30fff4a 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -216,6 +216,7 @@ LIBBPF_API int bpf_program__unpin_instance(struct bpf=
_program *prog,
 LIBBPF_API int bpf_program__pin(struct bpf_program *prog, const char *pa=
th);
 LIBBPF_API int bpf_program__unpin(struct bpf_program *prog, const char *=
path);
 LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
+LIBBPF_API int bpf_program__pin_dumper(struct bpf_program *prog, const c=
har *dname);
=20
 struct bpf_link;
=20
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index bb8831605b25..ed6234bb199f 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -238,6 +238,7 @@ LIBBPF_0.0.7 {
=20
 LIBBPF_0.0.8 {
 	global:
+		bpf_dump_query;
 		bpf_link__fd;
 		bpf_link__open;
 		bpf_link__pin;
@@ -248,8 +249,10 @@ LIBBPF_0.0.8 {
 		bpf_link_update;
 		bpf_map__set_initial_value;
 		bpf_program__attach_cgroup;
+		bpf_obj_pin_dumper;
 		bpf_program__attach_lsm;
 		bpf_program__is_lsm;
+		bpf_program__pin_dumper;
 		bpf_program__set_attach_target;
 		bpf_program__set_lsm;
 		bpf_set_link_xdp_fd_opts;
--=20
2.24.1

