Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA8BE1972B6
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 05:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgC3DAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 23:00:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7722 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729096AbgC3DAP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 23:00:15 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02U2thmF027498
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=DgwF80+1f5HQ0Tn+qXOU3JGf3KetDhK/HyNbAaRED0E=;
 b=cACT4PbipBM6+39wQnSIy7Wjux1nItKJ9AzLRXiAeAlCo+BSXJFmZpGpS7zEoj12XlDm
 gRTfPykZ6AI1f0rdsI8KT1tULb4mg/+o930GHa1N9ZM1fjoQ3ujvt8lJIMpHDKoYZ+gB
 gDI6M78biwJj/VQe1dKEsFDy6i2yybXgTQY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 302pqvurn6-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 20:00:14 -0700
Received: from intmgw003.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Sun, 29 Mar 2020 20:00:13 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7906F2EC3214; Sun, 29 Mar 2020 20:00:09 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 3/4] libbpf: add support for bpf_link-based cgroup attachment
Date:   Sun, 29 Mar 2020 20:00:00 -0700
Message-ID: <20200330030001.2312810-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330030001.2312810-1-andriin@fb.com>
References: <20200330030001.2312810-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-29_10:2020-03-27,2020-03-29 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 adultscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1015 suspectscore=25
 phishscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003300026
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_program__attach_cgroup(), which uses BPF_LINK_CREATE subcommand to
create an FD-based kernel bpf_link. Also add low-level bpf_link_create() API.

If expected_attach_type is not specified explicitly with
bpf_program__set_expected_attach_type(), libbpf will try to determine proper
attach type from BPF program's section definition.

Also add support for bpf_link's underlying BPF program replacement:
  - unconditional through high-level bpf_link__update_program() API;
  - cmpxchg-like with specifying expected current BPF program through
    low-level bpf_link_update() API.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/include/uapi/linux/bpf.h | 12 +++++++++
 tools/lib/bpf/bpf.c            | 34 +++++++++++++++++++++++++
 tools/lib/bpf/bpf.h            | 19 ++++++++++++++
 tools/lib/bpf/libbpf.c         | 46 ++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h         |  8 +++++-
 tools/lib/bpf/libbpf.map       |  4 +++
 6 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 8b3f1c098ac0..6241cbcd2a64 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -112,6 +112,7 @@ enum bpf_cmd {
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
+	BPF_LINK_UPDATE,
 };
 
 enum bpf_map_type {
@@ -577,6 +578,17 @@ union bpf_attr {
 		__u32		attach_type;	/* attach type */
 		__u32		flags;		/* extra flags */
 	} link_create;
+
+	struct { /* struct used by BPF_LINK_UPDATE command */
+		__u32		link_fd;	/* link fd */
+		/* new program fd to update link with */
+		__u32		new_prog_fd;
+		__u32		flags;		/* extra flags */
+		/* expected link's program fd; is specified only if
+		 * BPF_F_REPLACE flag is set in flags */
+		__u32		old_prog_fd;
+	} link_update;
+
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF
diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
index 73220176728d..5cc1b0785d18 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -585,6 +585,40 @@ int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
 	return sys_bpf(BPF_PROG_DETACH, &attr, sizeof(attr));
 }
 
+int bpf_link_create(int prog_fd, int target_fd,
+		    enum bpf_attach_type attach_type,
+		    const struct bpf_link_create_opts *opts)
+{
+	union bpf_attr attr;
+
+	if (!OPTS_VALID(opts, bpf_link_create_opts))
+		return -EINVAL;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.link_create.prog_fd = prog_fd;
+	attr.link_create.target_fd = target_fd;
+	attr.link_create.attach_type = attach_type;
+
+	return sys_bpf(BPF_LINK_CREATE, &attr, sizeof(attr));
+}
+
+int bpf_link_update(int link_fd, int new_prog_fd,
+		    const struct bpf_link_update_opts *opts)
+{
+	union bpf_attr attr;
+
+	if (!OPTS_VALID(opts, bpf_link_update_opts))
+		return -EINVAL;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.link_update.link_fd = link_fd;
+	attr.link_update.new_prog_fd = new_prog_fd;
+	attr.link_update.flags = OPTS_GET(opts, flags, 0);
+	attr.link_update.old_prog_fd = OPTS_GET(opts, old_prog_fd, 0);
+
+	return sys_bpf(BPF_LINK_UPDATE, &attr, sizeof(attr));
+}
+
 int bpf_prog_query(int target_fd, enum bpf_attach_type type, __u32 query_flags,
 		   __u32 *attach_flags, __u32 *prog_ids, __u32 *prog_cnt)
 {
diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
index b976e77316cc..46d47afdd887 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -168,6 +168,25 @@ LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
 LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
 				enum bpf_attach_type type);
 
+struct bpf_link_create_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+};
+#define bpf_link_create_opts__last_field sz
+
+LIBBPF_API int bpf_link_create(int prog_fd, int target_fd,
+			       enum bpf_attach_type attach_type,
+			       const struct bpf_link_create_opts *opts);
+
+struct bpf_link_update_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 flags;	   /* extra flags */
+	__u32 old_prog_fd; /* expected old program FD */
+};
+#define bpf_link_update_opts__last_field old_prog_fd
+
+LIBBPF_API int bpf_link_update(int link_fd, int new_prog_fd,
+			       const struct bpf_link_update_opts *opts);
+
 struct bpf_prog_test_run_attr {
 	int prog_fd;
 	int repeat;
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 0638e717f502..ff9174282a8c 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6978,6 +6978,12 @@ struct bpf_link {
 	bool disconnected;
 };
 
+/* Replace link's underlying BPF program with the new one */
+int bpf_link__update_program(struct bpf_link *link, struct bpf_program *prog)
+{
+	return bpf_link_update(bpf_link__fd(link), bpf_program__fd(prog), NULL);
+}
+
 /* Release "ownership" of underlying BPF resource (typically, BPF program
  * attached to some BPF hook, e.g., tracepoint, kprobe, etc). Disconnected
  * link, when destructed through bpf_link__destroy() call won't attempt to
@@ -7533,6 +7539,46 @@ static struct bpf_link *attach_lsm(const struct bpf_sec_def *sec,
 	return bpf_program__attach_lsm(prog);
 }
 
+struct bpf_link *
+bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd)
+{
+	const struct bpf_sec_def *sec_def;
+	enum bpf_attach_type attach_type;
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int prog_fd, link_fd;
+
+	prog_fd = bpf_program__fd(prog);
+	if (prog_fd < 0) {
+		pr_warn("program '%s': can't attach before loaded\n",
+			bpf_program__title(prog, false));
+		return ERR_PTR(-EINVAL);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link)
+		return ERR_PTR(-ENOMEM);
+	link->detach = &bpf_link__detach_fd;
+
+	attach_type = bpf_program__get_expected_attach_type(prog);
+	if (!attach_type) {
+		sec_def = find_sec_def(bpf_program__title(prog, false));
+		if (sec_def)
+			attach_type = sec_def->attach_type;
+	}
+	link_fd = bpf_link_create(prog_fd, cgroup_fd, attach_type, NULL);
+	if (link_fd < 0) {
+		link_fd = -errno;
+		free(link);
+		pr_warn("program '%s': failed to attach to cgroup: %s\n",
+			bpf_program__title(prog, false),
+			libbpf_strerror_r(link_fd, errmsg, sizeof(errmsg)));
+		return ERR_PTR(link_fd);
+	}
+	link->fd = link_fd;
+	return link;
+}
+
 struct bpf_link *bpf_program__attach(struct bpf_program *prog)
 {
 	const struct bpf_sec_def *sec_def;
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 55348724c355..44df1d3e7287 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -224,6 +224,8 @@ LIBBPF_API int bpf_link__fd(const struct bpf_link *link);
 LIBBPF_API const char *bpf_link__pin_path(const struct bpf_link *link);
 LIBBPF_API int bpf_link__pin(struct bpf_link *link, const char *path);
 LIBBPF_API int bpf_link__unpin(struct bpf_link *link);
+LIBBPF_API int bpf_link__update_program(struct bpf_link *link,
+					struct bpf_program *prog);
 LIBBPF_API void bpf_link__disconnect(struct bpf_link *link);
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
@@ -245,13 +247,17 @@ bpf_program__attach_tracepoint(struct bpf_program *prog,
 LIBBPF_API struct bpf_link *
 bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 				   const char *tp_name);
-
 LIBBPF_API struct bpf_link *
 bpf_program__attach_trace(struct bpf_program *prog);
 LIBBPF_API struct bpf_link *
 bpf_program__attach_lsm(struct bpf_program *prog);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd);
+
 struct bpf_map;
+
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index eabd3d3e689f..bb8831605b25 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -243,7 +243,11 @@ LIBBPF_0.0.8 {
 		bpf_link__pin;
 		bpf_link__pin_path;
 		bpf_link__unpin;
+		bpf_link__update_program;
+		bpf_link_create;
+		bpf_link_update;
 		bpf_map__set_initial_value;
+		bpf_program__attach_cgroup;
 		bpf_program__attach_lsm;
 		bpf_program__is_lsm;
 		bpf_program__set_attach_target;
-- 
2.17.1

