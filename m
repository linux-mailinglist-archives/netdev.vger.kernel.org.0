Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8BC01A8982
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 20:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503971AbgDNS1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 14:27:44 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:65468 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2503939AbgDNS10 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 14:27:26 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03EIR023008111
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:27:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=2KduSINvmWbk/ZP8Zjj3hszBYXDyEsuLMn2fFldDqcA=;
 b=PSjhsLJVBhBZsDFxPRPdnowu0ejCiGjlGx2g12zIyOOEzK5XyJh8xKH2UnCJsTXUf1v8
 Vo2VDQJD3VOUI2McqCilfj1wmNzHgCdM+O68XTUpTzkvICtG2z/iErO0ty3vBZ9VLZ4P
 vP55dW+1Cf5S6HlHAtNhdl3nxx+i/mnqUfo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 30def990nc-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 11:27:24 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 14 Apr 2020 11:26:57 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 400332EC31CF; Tue, 14 Apr 2020 11:26:46 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next] libbpf: always specify expected_attach_type on program load if supported
Date:   Tue, 14 Apr 2020 11:26:45 -0700
Message-ID: <20200414182645.1368174-1-andriin@fb.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-14_09:2020-04-14,2020-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 spamscore=0 suspectscore=0
 bulkscore=0 mlxscore=0 adultscore=0 clxscore=1015 impostorscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140132
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some types of BPF programs that utilize expected_attach_type, libbpf =
won't
set load_attr.expected_attach_type, even if expected_attach_type is known=
 from
section definition. This was done to preserve backwards compatibility wit=
h old
kernels that didn't recognize expected_attach_type attribute yet (which w=
as
added in 5e43f899b03a ("bpf: Check attach type at prog load time"). But t=
his
is problematic for some BPF programs that utilize never features that req=
uire
kernel to know specific expected_attach_type (e.g., extended set of retur=
n
codes for cgroup_skb/egress programs).

This patch makes libbpf specify expected_attach_type by default, but also
detect support for this field in kernel and not set it during program loa=
d.
This allows to have a good metadata for bpf_program
(e.g., bpf_program__get_extected_attach_type()), but still work with old
kernels (for cases where it can work at all).

Additionally, due to expected_attach_type being always set for recognized
program types, bpf_program__attach_cgroup doesn't have to do extra checks=
 to
determine correct attach type, so remove that additional logic.

Also adjust section_names selftest to account for this change.

More detailed discussion can be found in [0].

  [0] https://lore.kernel.org/bpf/20200412003604.GA15986@rdna-mbp.dhcp.th=
efacebook.com/

Reported-by: Andrey Ignatov <rdna@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 126 ++++++++++++------
 .../selftests/bpf/prog_tests/section_names.c  |  42 +++---
 2 files changed, 109 insertions(+), 59 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index ff9174282a8c..8f480e29a6b0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -178,6 +178,8 @@ struct bpf_capabilities {
 	__u32 array_mmap:1;
 	/* BTF_FUNC_GLOBAL is supported */
 	__u32 btf_func_global:1;
+	/* kernel support for expected_attach_type in BPF_PROG_LOAD */
+	__u32 exp_attach_type:1;
 };
=20
 enum reloc_type {
@@ -194,6 +196,22 @@ struct reloc_desc {
 	int sym_off;
 };
=20
+struct bpf_sec_def;
+
+typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
+					struct bpf_program *prog);
+
+struct bpf_sec_def {
+	const char *sec;
+	size_t len;
+	enum bpf_prog_type prog_type;
+	enum bpf_attach_type expected_attach_type;
+	bool is_exp_attach_type_optional;
+	bool is_attachable;
+	bool is_attach_btf;
+	attach_fn_t attach_fn;
+};
+
 /*
  * bpf_prog should be a better name but it has been used in
  * linux/filter.h.
@@ -204,6 +222,7 @@ struct bpf_program {
 	char *name;
 	int prog_ifindex;
 	char *section_name;
+	const struct bpf_sec_def *sec_def;
 	/* section_name with / replaced by _; makes recursive pinning
 	 * in bpf_object__pin_programs easier
 	 */
@@ -3315,6 +3334,37 @@ static int bpf_object__probe_array_mmap(struct bpf=
_object *obj)
 	return 0;
 }
=20
+static int
+bpf_object__probe_exp_attach_type(struct bpf_object *obj)
+{
+	struct bpf_load_program_attr attr;
+	struct bpf_insn insns[] =3D {
+		BPF_MOV64_IMM(BPF_REG_0, 0),
+		BPF_EXIT_INSN(),
+	};
+	int fd;
+
+	memset(&attr, 0, sizeof(attr));
+	/* use any valid combination of program type and (optional)
+	 * non-zero expected attach type (i.e., not a BPF_CGROUP_INET_INGRESS)
+	 * to see if kernel supports expected_attach_type field for
+	 * BPF_PROG_LOAD command
+	 */
+	attr.prog_type =3D BPF_PROG_TYPE_CGROUP_SOCK;
+	attr.expected_attach_type =3D BPF_CGROUP_INET_SOCK_CREATE;
+	attr.insns =3D insns;
+	attr.insns_cnt =3D ARRAY_SIZE(insns);
+	attr.license =3D "GPL";
+
+	fd =3D bpf_load_program_xattr(&attr, NULL, 0);
+	if (fd >=3D 0) {
+		obj->caps.exp_attach_type =3D 1;
+		close(fd);
+		return 1;
+	}
+	return 0;
+}
+
 static int
 bpf_object__probe_caps(struct bpf_object *obj)
 {
@@ -3325,6 +3375,7 @@ bpf_object__probe_caps(struct bpf_object *obj)
 		bpf_object__probe_btf_func_global,
 		bpf_object__probe_btf_datasec,
 		bpf_object__probe_array_mmap,
+		bpf_object__probe_exp_attach_type,
 	};
 	int i, ret;
=20
@@ -4861,7 +4912,12 @@ load_program(struct bpf_program *prog, struct bpf_=
insn *insns, int insns_cnt,
=20
 	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type =3D prog->type;
-	load_attr.expected_attach_type =3D prog->expected_attach_type;
+	/* old kernels might not support specifying expected_attach_type */
+	if (!prog->caps->exp_attach_type && prog->sec_def &&
+	    prog->sec_def->is_exp_attach_type_optional)
+		load_attr.expected_attach_type =3D 0;
+	else
+		load_attr.expected_attach_type =3D prog->expected_attach_type;
 	if (prog->caps->name)
 		load_attr.name =3D prog->name;
 	load_attr.insns =3D insns;
@@ -5062,6 +5118,8 @@ bpf_object__load_progs(struct bpf_object *obj, int =
log_level)
 	return 0;
 }
=20
+static const struct bpf_sec_def *find_sec_def(const char *sec_name);
+
 static struct bpf_object *
 __bpf_object__open(const char *path, const void *obj_buf, size_t obj_buf=
_sz,
 		   const struct bpf_object_open_opts *opts)
@@ -5117,24 +5175,17 @@ __bpf_object__open(const char *path, const void *=
obj_buf, size_t obj_buf_sz,
 	bpf_object__elf_finish(obj);
=20
 	bpf_object__for_each_program(prog, obj) {
-		enum bpf_prog_type prog_type;
-		enum bpf_attach_type attach_type;
-
-		if (prog->type !=3D BPF_PROG_TYPE_UNSPEC)
-			continue;
-
-		err =3D libbpf_prog_type_by_name(prog->section_name, &prog_type,
-					       &attach_type);
-		if (err =3D=3D -ESRCH)
+		prog->sec_def =3D find_sec_def(prog->section_name);
+		if (!prog->sec_def)
 			/* couldn't guess, but user might manually specify */
 			continue;
-		if (err)
-			goto out;
=20
-		bpf_program__set_type(prog, prog_type);
-		bpf_program__set_expected_attach_type(prog, attach_type);
-		if (prog_type =3D=3D BPF_PROG_TYPE_TRACING ||
-		    prog_type =3D=3D BPF_PROG_TYPE_EXT)
+		bpf_program__set_type(prog, prog->sec_def->prog_type);
+		bpf_program__set_expected_attach_type(prog,
+				prog->sec_def->expected_attach_type);
+
+		if (prog->sec_def->prog_type =3D=3D BPF_PROG_TYPE_TRACING ||
+		    prog->sec_def->prog_type =3D=3D BPF_PROG_TYPE_EXT)
 			prog->attach_prog_fd =3D OPTS_GET(opts, attach_prog_fd, 0);
 	}
=20
@@ -6223,23 +6274,32 @@ void bpf_program__set_expected_attach_type(struct=
 bpf_program *prog,
 	prog->expected_attach_type =3D type;
 }
=20
-#define BPF_PROG_SEC_IMPL(string, ptype, eatype, is_attachable, btf, aty=
pe) \
-	{ string, sizeof(string) - 1, ptype, eatype, is_attachable, btf, atype =
}
+#define BPF_PROG_SEC_IMPL(string, ptype, eatype, eatype_optional,	    \
+			  attachable, attach_btf)			    \
+	{								    \
+		.sec =3D string,						    \
+		.len =3D sizeof(string) - 1,				    \
+		.prog_type =3D ptype,					    \
+		.expected_attach_type =3D eatype,				    \
+		.is_exp_attach_type_optional =3D eatype_optional,		    \
+		.is_attachable =3D attachable,				    \
+		.is_attach_btf =3D attach_btf,				    \
+	}
=20
 /* Programs that can NOT be attached. */
 #define BPF_PROG_SEC(string, ptype) BPF_PROG_SEC_IMPL(string, ptype, 0, =
0, 0, 0)
=20
 /* Programs that can be attached. */
 #define BPF_APROG_SEC(string, ptype, atype) \
-	BPF_PROG_SEC_IMPL(string, ptype, 0, 1, 0, atype)
+	BPF_PROG_SEC_IMPL(string, ptype, atype, true, 1, 0)
=20
 /* Programs that must specify expected attach type at load time. */
 #define BPF_EAPROG_SEC(string, ptype, eatype) \
-	BPF_PROG_SEC_IMPL(string, ptype, eatype, 1, 0, eatype)
+	BPF_PROG_SEC_IMPL(string, ptype, eatype, false, 1, 0)
=20
 /* Programs that use BTF to identify attach point */
 #define BPF_PROG_BTF(string, ptype, eatype) \
-	BPF_PROG_SEC_IMPL(string, ptype, eatype, 0, 1, 0)
+	BPF_PROG_SEC_IMPL(string, ptype, eatype, false, 0, 1)
=20
 /* Programs that can be attached but attach type can't be identified by =
section
  * name. Kept for backward compatibility.
@@ -6253,11 +6313,6 @@ void bpf_program__set_expected_attach_type(struct =
bpf_program *prog,
 	__VA_ARGS__							    \
 }
=20
-struct bpf_sec_def;
-
-typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
-					struct bpf_program *prog);
-
 static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
 				      struct bpf_program *prog);
 static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
@@ -6269,17 +6324,6 @@ static struct bpf_link *attach_trace(const struct =
bpf_sec_def *sec,
 static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
 				   struct bpf_program *prog);
=20
-struct bpf_sec_def {
-	const char *sec;
-	size_t len;
-	enum bpf_prog_type prog_type;
-	enum bpf_attach_type expected_attach_type;
-	bool is_attachable;
-	bool is_attach_btf;
-	enum bpf_attach_type attach_type;
-	attach_fn_t attach_fn;
-};
-
 static const struct bpf_sec_def section_defs[] =3D {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
 	BPF_PROG_SEC("sk_reuseport",		BPF_PROG_TYPE_SK_REUSEPORT),
@@ -6713,7 +6757,7 @@ int libbpf_attach_type_by_name(const char *name,
 			continue;
 		if (!section_defs[i].is_attachable)
 			return -EINVAL;
-		*attach_type =3D section_defs[i].attach_type;
+		*attach_type =3D section_defs[i].expected_attach_type;
 		return 0;
 	}
 	pr_debug("failed to guess attach type based on ELF section name '%s'\n"=
, name);
@@ -7542,7 +7586,6 @@ static struct bpf_link *attach_lsm(const struct bpf=
_sec_def *sec,
 struct bpf_link *
 bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
 {
-	const struct bpf_sec_def *sec_def;
 	enum bpf_attach_type attach_type;
 	char errmsg[STRERR_BUFSIZE];
 	struct bpf_link *link;
@@ -7561,11 +7604,6 @@ bpf_program__attach_cgroup(struct bpf_program *pro=
g, int cgroup_fd)
 	link->detach =3D &bpf_link__detach_fd;
=20
 	attach_type =3D bpf_program__get_expected_attach_type(prog);
-	if (!attach_type) {
-		sec_def =3D find_sec_def(bpf_program__title(prog, false));
-		if (sec_def)
-			attach_type =3D sec_def->attach_type;
-	}
 	link_fd =3D bpf_link_create(prog_fd, cgroup_fd, attach_type, NULL);
 	if (link_fd < 0) {
 		link_fd =3D -errno;
diff --git a/tools/testing/selftests/bpf/prog_tests/section_names.c b/too=
ls/testing/selftests/bpf/prog_tests/section_names.c
index 9d9351dc2ded..713167449c98 100644
--- a/tools/testing/selftests/bpf/prog_tests/section_names.c
+++ b/tools/testing/selftests/bpf/prog_tests/section_names.c
@@ -43,18 +43,18 @@ static struct sec_name_test tests[] =3D {
 	{"lwt_seg6local", {0, BPF_PROG_TYPE_LWT_SEG6LOCAL, 0}, {-EINVAL, 0} },
 	{
 		"cgroup_skb/ingress",
-		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
+		{0, BPF_PROG_TYPE_CGROUP_SKB, BPF_CGROUP_INET_INGRESS},
 		{0, BPF_CGROUP_INET_INGRESS},
 	},
 	{
 		"cgroup_skb/egress",
-		{0, BPF_PROG_TYPE_CGROUP_SKB, 0},
+		{0, BPF_PROG_TYPE_CGROUP_SKB, BPF_CGROUP_INET_EGRESS},
 		{0, BPF_CGROUP_INET_EGRESS},
 	},
 	{"cgroup/skb", {0, BPF_PROG_TYPE_CGROUP_SKB, 0}, {-EINVAL, 0} },
 	{
 		"cgroup/sock",
-		{0, BPF_PROG_TYPE_CGROUP_SOCK, 0},
+		{0, BPF_PROG_TYPE_CGROUP_SOCK, BPF_CGROUP_INET_SOCK_CREATE},
 		{0, BPF_CGROUP_INET_SOCK_CREATE},
 	},
 	{
@@ -69,26 +69,38 @@ static struct sec_name_test tests[] =3D {
 	},
 	{
 		"cgroup/dev",
-		{0, BPF_PROG_TYPE_CGROUP_DEVICE, 0},
+		{0, BPF_PROG_TYPE_CGROUP_DEVICE, BPF_CGROUP_DEVICE},
 		{0, BPF_CGROUP_DEVICE},
 	},
-	{"sockops", {0, BPF_PROG_TYPE_SOCK_OPS, 0}, {0, BPF_CGROUP_SOCK_OPS} },
+	{
+		"sockops",
+		{0, BPF_PROG_TYPE_SOCK_OPS, BPF_CGROUP_SOCK_OPS},
+		{0, BPF_CGROUP_SOCK_OPS},
+	},
 	{
 		"sk_skb/stream_parser",
-		{0, BPF_PROG_TYPE_SK_SKB, 0},
+		{0, BPF_PROG_TYPE_SK_SKB, BPF_SK_SKB_STREAM_PARSER},
 		{0, BPF_SK_SKB_STREAM_PARSER},
 	},
 	{
 		"sk_skb/stream_verdict",
-		{0, BPF_PROG_TYPE_SK_SKB, 0},
+		{0, BPF_PROG_TYPE_SK_SKB, BPF_SK_SKB_STREAM_VERDICT},
 		{0, BPF_SK_SKB_STREAM_VERDICT},
 	},
 	{"sk_skb", {0, BPF_PROG_TYPE_SK_SKB, 0}, {-EINVAL, 0} },
-	{"sk_msg", {0, BPF_PROG_TYPE_SK_MSG, 0}, {0, BPF_SK_MSG_VERDICT} },
-	{"lirc_mode2", {0, BPF_PROG_TYPE_LIRC_MODE2, 0}, {0, BPF_LIRC_MODE2} },
+	{
+		"sk_msg",
+		{0, BPF_PROG_TYPE_SK_MSG, BPF_SK_MSG_VERDICT},
+		{0, BPF_SK_MSG_VERDICT},
+	},
+	{
+		"lirc_mode2",
+		{0, BPF_PROG_TYPE_LIRC_MODE2, BPF_LIRC_MODE2},
+		{0, BPF_LIRC_MODE2},
+	},
 	{
 		"flow_dissector",
-		{0, BPF_PROG_TYPE_FLOW_DISSECTOR, 0},
+		{0, BPF_PROG_TYPE_FLOW_DISSECTOR, BPF_FLOW_DISSECTOR},
 		{0, BPF_FLOW_DISSECTOR},
 	},
 	{
@@ -158,17 +170,17 @@ static void test_prog_type_by_name(const struct sec=
_name_test *test)
 				      &expected_attach_type);
=20
 	CHECK(rc !=3D test->expected_load.rc, "check_code",
-	      "prog: unexpected rc=3D%d for %s", rc, test->sec_name);
+	      "prog: unexpected rc=3D%d for %s\n", rc, test->sec_name);
=20
 	if (rc)
 		return;
=20
 	CHECK(prog_type !=3D test->expected_load.prog_type, "check_prog_type",
-	      "prog: unexpected prog_type=3D%d for %s",
+	      "prog: unexpected prog_type=3D%d for %s\n",
 	      prog_type, test->sec_name);
=20
 	CHECK(expected_attach_type !=3D test->expected_load.expected_attach_typ=
e,
-	      "check_attach_type", "prog: unexpected expected_attach_type=3D%d =
for %s",
+	      "check_attach_type", "prog: unexpected expected_attach_type=3D%d =
for %s\n",
 	      expected_attach_type, test->sec_name);
 }
=20
@@ -180,13 +192,13 @@ static void test_attach_type_by_name(const struct s=
ec_name_test *test)
 	rc =3D libbpf_attach_type_by_name(test->sec_name, &attach_type);
=20
 	CHECK(rc !=3D test->expected_attach.rc, "check_ret",
-	      "attach: unexpected rc=3D%d for %s", rc, test->sec_name);
+	      "attach: unexpected rc=3D%d for %s\n", rc, test->sec_name);
=20
 	if (rc)
 		return;
=20
 	CHECK(attach_type !=3D test->expected_attach.attach_type,
-	      "check_attach_type", "attach: unexpected attach_type=3D%d for %s"=
,
+	      "check_attach_type", "attach: unexpected attach_type=3D%d for %s\=
n",
 	      attach_type, test->sec_name);
 }
=20
--=20
2.24.1

