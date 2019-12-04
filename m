Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3CC011232B
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbfLDHAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727257AbfLDHAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:44 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB470blD020390
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=Qk+d1m3oUQokS0EMfPinQUhhExP1yyFwHoPmxXBO/qk=;
 b=f++Y51QP/ehtebR7mP2GrYY+/m2zL3UYd5nWApvOslRdSqaMtRvNID2jEkekYtTRgtkg
 yxKSZOrsIP3p4En5eYH+tvFIA0qvGLwzJ+unl94LOKqKXGO+6INWRtOvw4oHA3psSJ8D
 ac+eksgiLeuMby43gf87CnmQ4FBHo1muYAY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wn9csgj4c-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:42 -0800
Received: from 2401:db00:30:600c:face:0:39:0 (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 3 Dec 2019 23:00:23 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 95FE32EC1853; Tue,  3 Dec 2019 23:00:22 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 02/16] libbpf: add generic bpf_program__attach()
Date:   Tue, 3 Dec 2019 23:00:01 -0800
Message-ID: <20191204070015.3523523-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0 spamscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=25 mlxlogscore=999
 mlxscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Generalize BPF program attaching and allow libbpf to auto-detect type (and
extra parameters, where applicable) and attach supported BPF program types
based on program sections. Currently this is supported for:
- kprobe/kretprobe;
- tracepoint;
- raw tracepoint;
- tracing programs (typed raw TP/fentry/fexit).

More types support can be trivially added within this framework.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c                        | 181 ++++++++++++++----
 tools/lib/bpf/libbpf.h                        |   2 +
 tools/lib/bpf/libbpf.map                      |   6 +
 .../selftests/bpf/prog_tests/probe_user.c     |   6 +-
 4 files changed, 157 insertions(+), 38 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 1e29a47da4f5..edfe1cf1e940 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -4971,7 +4971,28 @@ void bpf_program__set_expected_attach_type(struct bpf_program *prog,
  */
 #define BPF_APROG_COMPAT(string, ptype) BPF_PROG_SEC(string, ptype)
 
-static const struct {
+#define SEC_DEF(sec_pfx, ptype, ...) {					    \
+	.sec = sec_pfx,							    \
+	.len = sizeof(sec_pfx) - 1,					    \
+	.prog_type = BPF_PROG_TYPE_##ptype,				    \
+	__VA_ARGS__							    \
+}
+
+struct bpf_sec_def;
+
+typedef struct bpf_link *(*attach_fn_t)(const struct bpf_sec_def *sec,
+					struct bpf_program *prog);
+
+static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
+				      struct bpf_program *prog);
+static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
+				  struct bpf_program *prog);
+static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
+				      struct bpf_program *prog);
+static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
+				     struct bpf_program *prog);
+
+struct bpf_sec_def {
 	const char *sec;
 	size_t len;
 	enum bpf_prog_type prog_type;
@@ -4979,24 +5000,39 @@ static const struct {
 	bool is_attachable;
 	bool is_attach_btf;
 	enum bpf_attach_type attach_type;
-} section_names[] = {
+	attach_fn_t attach_fn;
+};
+
+static const struct bpf_sec_def section_defs[] = {
 	BPF_PROG_SEC("socket",			BPF_PROG_TYPE_SOCKET_FILTER),
-	BPF_PROG_SEC("kprobe/",			BPF_PROG_TYPE_KPROBE),
+	SEC_DEF("kprobe/", KPROBE,
+		.attach_fn = attach_kprobe),
 	BPF_PROG_SEC("uprobe/",			BPF_PROG_TYPE_KPROBE),
-	BPF_PROG_SEC("kretprobe/",		BPF_PROG_TYPE_KPROBE),
+	SEC_DEF("kretprobe/", KPROBE,
+		.attach_fn = attach_kprobe),
 	BPF_PROG_SEC("uretprobe/",		BPF_PROG_TYPE_KPROBE),
 	BPF_PROG_SEC("classifier",		BPF_PROG_TYPE_SCHED_CLS),
 	BPF_PROG_SEC("action",			BPF_PROG_TYPE_SCHED_ACT),
-	BPF_PROG_SEC("tracepoint/",		BPF_PROG_TYPE_TRACEPOINT),
-	BPF_PROG_SEC("tp/",			BPF_PROG_TYPE_TRACEPOINT),
-	BPF_PROG_SEC("raw_tracepoint/",		BPF_PROG_TYPE_RAW_TRACEPOINT),
-	BPF_PROG_SEC("raw_tp/",			BPF_PROG_TYPE_RAW_TRACEPOINT),
-	BPF_PROG_BTF("tp_btf/",			BPF_PROG_TYPE_TRACING,
-						BPF_TRACE_RAW_TP),
-	BPF_PROG_BTF("fentry/",			BPF_PROG_TYPE_TRACING,
-						BPF_TRACE_FENTRY),
-	BPF_PROG_BTF("fexit/",			BPF_PROG_TYPE_TRACING,
-						BPF_TRACE_FEXIT),
+	SEC_DEF("tracepoint/", TRACEPOINT,
+		.attach_fn = attach_tp),
+	SEC_DEF("tp/", TRACEPOINT,
+		.attach_fn = attach_tp),
+	SEC_DEF("raw_tracepoint/", RAW_TRACEPOINT,
+		.attach_fn = attach_raw_tp),
+	SEC_DEF("raw_tp/", RAW_TRACEPOINT,
+		.attach_fn = attach_raw_tp),
+	SEC_DEF("tp_btf/", TRACING,
+		.expected_attach_type = BPF_TRACE_RAW_TP,
+		.is_attach_btf = true,
+		.attach_fn = attach_trace),
+	SEC_DEF("fentry/", TRACING,
+		.expected_attach_type = BPF_TRACE_FENTRY,
+		.is_attach_btf = true,
+		.attach_fn = attach_trace),
+	SEC_DEF("fexit/", TRACING,
+		.expected_attach_type = BPF_TRACE_FEXIT,
+		.is_attach_btf = true,
+		.attach_fn = attach_trace),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
@@ -5058,12 +5094,26 @@ static const struct {
 #undef BPF_APROG_SEC
 #undef BPF_EAPROG_SEC
 #undef BPF_APROG_COMPAT
+#undef SEC_DEF
 
 #define MAX_TYPE_NAME_SIZE 32
 
+static const struct bpf_sec_def *find_sec_def(const char *sec_name)
+{
+	int i, n = ARRAY_SIZE(section_defs);
+
+	for (i = 0; i < n; i++) {
+		if (strncmp(sec_name,
+			    section_defs[i].sec, section_defs[i].len))
+			continue;
+		return &section_defs[i];
+	}
+	return NULL;
+}
+
 static char *libbpf_get_type_names(bool attach_type)
 {
-	int i, len = ARRAY_SIZE(section_names) * MAX_TYPE_NAME_SIZE;
+	int i, len = ARRAY_SIZE(section_defs) * MAX_TYPE_NAME_SIZE;
 	char *buf;
 
 	buf = malloc(len);
@@ -5072,16 +5122,16 @@ static char *libbpf_get_type_names(bool attach_type)
 
 	buf[0] = '\0';
 	/* Forge string buf with all available names */
-	for (i = 0; i < ARRAY_SIZE(section_names); i++) {
-		if (attach_type && !section_names[i].is_attachable)
+	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
+		if (attach_type && !section_defs[i].is_attachable)
 			continue;
 
-		if (strlen(buf) + strlen(section_names[i].sec) + 2 > len) {
+		if (strlen(buf) + strlen(section_defs[i].sec) + 2 > len) {
 			free(buf);
 			return NULL;
 		}
 		strcat(buf, " ");
-		strcat(buf, section_names[i].sec);
+		strcat(buf, section_defs[i].sec);
 	}
 
 	return buf;
@@ -5090,19 +5140,19 @@ static char *libbpf_get_type_names(bool attach_type)
 int libbpf_prog_type_by_name(const char *name, enum bpf_prog_type *prog_type,
 			     enum bpf_attach_type *expected_attach_type)
 {
+	const struct bpf_sec_def *sec_def;
 	char *type_names;
-	int i;
 
 	if (!name)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(section_names); i++) {
-		if (strncmp(name, section_names[i].sec, section_names[i].len))
-			continue;
-		*prog_type = section_names[i].prog_type;
-		*expected_attach_type = section_names[i].expected_attach_type;
+	sec_def = find_sec_def(name);
+	if (sec_def) {
+		*prog_type = sec_def->prog_type;
+		*expected_attach_type = sec_def->expected_attach_type;
 		return 0;
 	}
+
 	pr_warn("failed to guess program type from ELF section '%s'\n", name);
 	type_names = libbpf_get_type_names(false);
 	if (type_names != NULL) {
@@ -5185,16 +5235,16 @@ static int libbpf_find_attach_btf_id(const char *name,
 	if (!name)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(section_names); i++) {
-		if (!section_names[i].is_attach_btf)
+	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
+		if (!section_defs[i].is_attach_btf)
 			continue;
-		if (strncmp(name, section_names[i].sec, section_names[i].len))
+		if (strncmp(name, section_defs[i].sec, section_defs[i].len))
 			continue;
 		if (attach_prog_fd)
-			err = libbpf_find_prog_btf_id(name + section_names[i].len,
+			err = libbpf_find_prog_btf_id(name + section_defs[i].len,
 						      attach_prog_fd);
 		else
-			err = libbpf_find_vmlinux_btf_id(name + section_names[i].len,
+			err = libbpf_find_vmlinux_btf_id(name + section_defs[i].len,
 							 attach_type);
 		if (err <= 0)
 			pr_warn("%s is not found in vmlinux BTF\n", name);
@@ -5213,12 +5263,12 @@ int libbpf_attach_type_by_name(const char *name,
 	if (!name)
 		return -EINVAL;
 
-	for (i = 0; i < ARRAY_SIZE(section_names); i++) {
-		if (strncmp(name, section_names[i].sec, section_names[i].len))
+	for (i = 0; i < ARRAY_SIZE(section_defs); i++) {
+		if (strncmp(name, section_defs[i].sec, section_defs[i].len))
 			continue;
-		if (!section_names[i].is_attachable)
+		if (!section_defs[i].is_attachable)
 			return -EINVAL;
-		*attach_type = section_names[i].attach_type;
+		*attach_type = section_defs[i].attach_type;
 		return 0;
 	}
 	pr_warn("failed to guess attach type based on ELF section name '%s'\n", name);
@@ -5678,6 +5728,18 @@ struct bpf_link *bpf_program__attach_kprobe(struct bpf_program *prog,
 	return link;
 }
 
+static struct bpf_link *attach_kprobe(const struct bpf_sec_def *sec,
+				      struct bpf_program *prog)
+{
+	const char *func_name;
+	bool retprobe;
+
+	func_name = bpf_program__title(prog, false) + sec->len;
+	retprobe = strcmp(sec->sec, "kretprobe/") == 0;
+
+	return bpf_program__attach_kprobe(prog, retprobe, func_name);
+}
+
 struct bpf_link *bpf_program__attach_uprobe(struct bpf_program *prog,
 					    bool retprobe, pid_t pid,
 					    const char *binary_path,
@@ -5790,6 +5852,32 @@ struct bpf_link *bpf_program__attach_tracepoint(struct bpf_program *prog,
 	return link;
 }
 
+static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
+				  struct bpf_program *prog)
+{
+	char *sec_name, *tp_cat, *tp_name;
+	struct bpf_link *link;
+
+	sec_name = strdup(bpf_program__title(prog, false));
+	if (!sec_name)
+		return ERR_PTR(-ENOMEM);
+
+	/* extract "tp/<category>/<name>" */
+	tp_cat = sec_name + sec->len;
+	tp_name = strchr(tp_cat, '/');
+	if (!tp_name) {
+		link = ERR_PTR(-EINVAL);
+		goto out;
+	}
+	*tp_name = '\0';
+	tp_name++;
+
+	link = bpf_program__attach_tracepoint(prog, tp_cat, tp_name);
+out:
+	free(sec_name);
+	return link;
+}
+
 static int bpf_link__destroy_fd(struct bpf_link *link)
 {
 	struct bpf_link_fd *l = (void *)link;
@@ -5829,6 +5917,14 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 	return (struct bpf_link *)link;
 }
 
+static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
+				      struct bpf_program *prog)
+{
+	const char *tp_name = bpf_program__title(prog, false) + sec->len;
+
+	return bpf_program__attach_raw_tracepoint(prog, tp_name);
+}
+
 struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 {
 	char errmsg[STRERR_BUFSIZE];
@@ -5860,6 +5956,23 @@ struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 	return (struct bpf_link *)link;
 }
 
+static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
+				     struct bpf_program *prog)
+{
+	return bpf_program__attach_trace(prog);
+}
+
+struct bpf_link *bpf_program__attach(struct bpf_program *prog)
+{
+	const struct bpf_sec_def *sec_def;
+
+	sec_def = find_sec_def(bpf_program__title(prog, false));
+	if (!sec_def || !sec_def->attach_fn)
+		return ERR_PTR(-ESRCH);
+
+	return sec_def->attach_fn(sec_def, prog);
+}
+
 enum bpf_perf_event_ret
 bpf_perf_event_read_simple(void *mmap_mem, size_t mmap_size, size_t page_size,
 			   void **copy_mem, size_t *copy_size,
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 0dbf4bfba0c4..804f445c9957 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -237,6 +237,8 @@ struct bpf_link;
 
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
+LIBBPF_API struct bpf_link *
+bpf_program__attach(struct bpf_program *prog);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_perf_event(struct bpf_program *prog, int pfd);
 LIBBPF_API struct bpf_link *
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 8ddc2c40e482..88dded011a84 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -203,8 +203,14 @@ LIBBPF_0.0.6 {
 		bpf_program__get_expected_attach_type;
 		bpf_program__get_type;
 		bpf_program__is_tracing;
+		bpf_program__name;
 		bpf_program__set_tracing;
 		bpf_program__size;
 		btf__find_by_name_kind;
 		libbpf_find_vmlinux_btf_id;
 } LIBBPF_0.0.5;
+
+LIBBPF_0.0.7 {
+	global:
+		bpf_program__attach;
+} LIBBPF_0.0.6;
diff --git a/tools/testing/selftests/bpf/prog_tests/probe_user.c b/tools/testing/selftests/bpf/prog_tests/probe_user.c
index 8a3187dec048..7aecfd9e87d1 100644
--- a/tools/testing/selftests/bpf/prog_tests/probe_user.c
+++ b/tools/testing/selftests/bpf/prog_tests/probe_user.c
@@ -3,8 +3,7 @@
 
 void test_probe_user(void)
 {
-#define kprobe_name "__sys_connect"
-	const char *prog_name = "kprobe/" kprobe_name;
+	const char *prog_name = "kprobe/__sys_connect";
 	const char *obj_file = "./test_probe_user.o";
 	DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts, );
 	int err, results_map_fd, sock_fd, duration = 0;
@@ -33,8 +32,7 @@ void test_probe_user(void)
 		  "err %d\n", results_map_fd))
 		goto cleanup;
 
-	kprobe_link = bpf_program__attach_kprobe(kprobe_prog, false,
-						 kprobe_name);
+	kprobe_link = bpf_program__attach(kprobe_prog);
 	if (CHECK(IS_ERR(kprobe_link), "attach_kprobe",
 		  "err %ld\n", PTR_ERR(kprobe_link))) {
 		kprobe_link = NULL;
-- 
2.17.1

