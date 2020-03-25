Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFC67192171
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 08:00:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCYHAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 03:00:01 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:20758 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726276AbgCYHAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 03:00:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02P6xupK021220
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:59:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=RzE9UvIqCYbVFLOutFlDQ3wZl1ZLbwB6zxX6UXOel5M=;
 b=jQVouuEZSRGcizau+InzcuCu4G3THdGtEvRlVk6ttaDE43SBjn7FKWqesOCKcdxXQj4J
 3phVo6wKCbaQRqvX9Ii3EQRnnFlkFsUKyOevFTzp0/XPn7AUpKBnSYPbgKFyi39vqECY
 1xsc6vSvg/yPup90sd0Tz4xDsagA/JBx/IA= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yy3gy7t82-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 23:59:59 -0700
Received: from intmgw004.03.ash8.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Tue, 24 Mar 2020 23:59:44 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 7BF5B2EC34F3; Tue, 24 Mar 2020 23:59:40 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <rdna@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 5/6] libbpf: add support for bpf_link-based cgroup attachment
Date:   Tue, 24 Mar 2020 23:57:45 -0700
Message-ID: <20200325065746.640559-6-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325065746.640559-1-andriin@fb.com>
References: <20200325065746.640559-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_01:2020-03-23,2020-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 bulkscore=0 adultscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=25
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003250058
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
 tools/lib/bpf/bpf.c            | 35 ++++++++++++++++++++++++
 tools/lib/bpf/bpf.h            | 20 ++++++++++++++
 tools/lib/bpf/libbpf.c         | 49 ++++++++++++++++++++++++++++++++++
 tools/lib/bpf/libbpf.h         |  9 ++++++-
 tools/lib/bpf/libbpf.map       |  4 +++
 6 files changed, 128 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 948ebbfd401b..d7583483fca5 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -112,6 +112,7 @@ enum bpf_cmd {
 	BPF_MAP_UPDATE_BATCH,
 	BPF_MAP_DELETE_BATCH,
 	BPF_LINK_CREATE,
+	BPF_LINK_UPDATE,
 };
 
 enum bpf_map_type {
@@ -575,6 +576,17 @@ union bpf_attr {
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
index c6dafe563176..b5eecb390c0c 100644
--- a/tools/lib/bpf/bpf.c
+++ b/tools/lib/bpf/bpf.c
@@ -584,6 +584,41 @@ int bpf_prog_detach2(int prog_fd, int target_fd, enum bpf_attach_type type)
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
+	attr.link_create.flags = OPTS_GET(opts, flags, 0);
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
index b976e77316cc..880879f4e434 100644
--- a/tools/lib/bpf/bpf.h
+++ b/tools/lib/bpf/bpf.h
@@ -168,6 +168,26 @@ LIBBPF_API int bpf_prog_detach(int attachable_fd, enum bpf_attach_type type);
 LIBBPF_API int bpf_prog_detach2(int prog_fd, int attachable_fd,
 				enum bpf_attach_type type);
 
+struct bpf_link_create_opts {
+	size_t sz; /* size of this struct for forward/backward compatibility */
+	__u32 flags;
+};
+#define bpf_link_create_opts__last_field flags
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
index 085e41f9b68e..09055fcb3c33 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6951,6 +6951,12 @@ struct bpf_link {
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
@@ -7489,6 +7495,49 @@ static struct bpf_link *attach_trace(const struct bpf_sec_def *sec,
 	return bpf_program__attach_trace(prog);
 }
 
+struct bpf_link *bpf_program__attach_cgroup(struct bpf_program *prog,
+					    int cgroup_fd, __u32 flags)
+{
+	DECLARE_LIBBPF_OPTS(bpf_link_create_opts, opts);
+	const struct bpf_sec_def *sec_def;
+	enum bpf_attach_type attach_type;
+	char errmsg[STRERR_BUFSIZE];
+	struct bpf_link *link;
+	int prog_fd, link_fd;
+
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
+	opts.flags = flags;
+	link_fd = bpf_link_create(prog_fd, cgroup_fd, attach_type, &opts);
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
index d38d7a629417..38288e8709b6 100644
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
 
@@ -245,11 +247,16 @@ bpf_program__attach_tracepoint(struct bpf_program *prog,
 LIBBPF_API struct bpf_link *
 bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 				   const char *tp_name);
-
 LIBBPF_API struct bpf_link *
 bpf_program__attach_trace(struct bpf_program *prog);
+LIBBPF_API struct bpf_link *
+bpf_program__attach_cgroup(struct bpf_program *prog, int cgroup_fd,
+			   __u32 flags);
+
 struct bpf_map;
+
 LIBBPF_API struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map);
+
 struct bpf_insn;
 
 /*
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 5129283c0284..793c5af07b23 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -243,5 +243,9 @@ LIBBPF_0.0.8 {
 		bpf_link__pin;
 		bpf_link__pin_path;
 		bpf_link__unpin;
+		bpf_link__update_program;
+		bpf_link_create;
+		bpf_link_update;
+		bpf_program__attach_cgroup;
 		bpf_program__set_attach_target;
 } LIBBPF_0.0.7;
-- 
2.17.1

