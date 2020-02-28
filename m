Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 814B7174215
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 23:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgB1WkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 17:40:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31628 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726621AbgB1WkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 17:40:02 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01SMYggF031177
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:40:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=2IzERmdmX0Z8RNCsXkr/P7ZJ2EbkHQ0gftdu0lz7UJI=;
 b=O9pB8NssaZUXkWYC+FlnmuHh/HDVI4VGM+GUwpAdlJsBaeF7R5390V8kcjkmouHhhAUN
 X79OkPBM3n8uCAn+oiHNXjgNN5v9hzUjy2NFt5cWd5DdQbAqN9UtTc/lDH6ewSWLwfag
 StkosAnVX18HdgP8T89jv+KzuRgTCahXXOE= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2yepvgwvv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 14:40:00 -0800
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::4) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 28 Feb 2020 14:39:59 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 4E3612EC2D20; Fri, 28 Feb 2020 14:39:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 2/3] libbpf: add bpf_link pinning/unpinning
Date:   Fri, 28 Feb 2020 14:39:47 -0800
Message-ID: <20200228223948.360936-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200228223948.360936-1-andriin@fb.com>
References: <20200228223948.360936-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-28_08:2020-02-28,2020-02-28 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 spamscore=0 bulkscore=0 phishscore=0 suspectscore=25 mlxscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2002280162
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With bpf_link abstraction supported by kernel explicitly, add
pinning/unpinning API for links. Also allow to create (open) bpf_link from BPF
FS file.

This API allows to have an "ephemeral" FD-based BPF links (like raw tracepoint
or fexit/freplace attachments) surviving user process exit, by pinning them in
a BPF FS, which is an important use case for long-running BPF programs.

As part of this, expose underlying FD for bpf_link. While legacy bpf_link's
might not have a FD associated with them (which will be expressed as
a bpf_link with fd=-1), kernel's abstraction is based around FD-based usage,
so match it closely. This, subsequently, allows to have a generic
pinning/unpinning API for generalized bpf_link. For some types of bpf_links
kernel might not support pinning, in which case bpf_link__pin() will return
error.

With FD being part of generic bpf_link, also get rid of bpf_link_fd in favor
of using vanialla bpf_link.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 131 +++++++++++++++++++++++++++++++--------
 tools/lib/bpf/libbpf.h   |   5 ++
 tools/lib/bpf/libbpf.map |   5 ++
 3 files changed, 114 insertions(+), 27 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 996162801f7a..f8c4042e5855 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6931,6 +6931,8 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 struct bpf_link {
 	int (*detach)(struct bpf_link *link);
 	int (*destroy)(struct bpf_link *link);
+	char *pin_path;		/* NULL, if not pinned */
+	int fd;			/* hook FD, -1 if not applicable */
 	bool disconnected;
 };
 
@@ -6960,26 +6962,109 @@ int bpf_link__destroy(struct bpf_link *link)
 		err = link->detach(link);
 	if (link->destroy)
 		link->destroy(link);
+	if (link->pin_path)
+		free(link->pin_path);
 	free(link);
 
 	return err;
 }
 
-struct bpf_link_fd {
-	struct bpf_link link; /* has to be at the top of struct */
-	int fd; /* hook FD */
-};
+int bpf_link__fd(const struct bpf_link *link)
+{
+	return link->fd;
+}
+
+const char *bpf_link__pin_path(const struct bpf_link *link)
+{
+	return link->pin_path;
+}
+
+static int bpf_link__detach_fd(struct bpf_link *link)
+{
+	return close(link->fd);
+}
+
+struct bpf_link *bpf_link__open(const char *path)
+{
+	struct bpf_link *link;
+	int fd;
+
+	fd = bpf_obj_get(path);
+	if (fd < 0) {
+		fd = -errno;
+		pr_warn("failed to open link at %s: %d\n", path, fd);
+		return ERR_PTR(fd);
+	}
+
+	link = calloc(1, sizeof(*link));
+	if (!link) {
+		close(fd);
+		return ERR_PTR(-ENOMEM);
+	}
+	link->detach = &bpf_link__detach_fd;
+	link->fd = fd;
+
+	link->pin_path = strdup(path);
+	if (!link->pin_path) {
+		bpf_link__destroy(link);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return link;
+}
+
+int bpf_link__pin(struct bpf_link *link, const char *path)
+{
+	int err;
+
+	if (link->pin_path)
+		return -EBUSY;
+	err = make_parent_dir(path);
+	if (err)
+		return err;
+	err = check_path(path);
+	if (err)
+		return err;
+
+	link->pin_path = strdup(path);
+	if (!link->pin_path)
+		return -ENOMEM;
+
+	if (bpf_obj_pin(link->fd, link->pin_path)) {
+		err = -errno;
+		zfree(&link->pin_path);
+		return err;
+	}
+
+	pr_debug("link fd=%d: pinned at %s\n", link->fd, link->pin_path);
+	return 0;
+}
+
+int bpf_link__unpin(struct bpf_link *link)
+{
+	int err;
+
+	if (!link->pin_path)
+		return -EINVAL;
+
+	err = unlink(link->pin_path);
+	if (err != 0)
+		return -errno;
+
+	pr_debug("link fd=%d: unpinned from %s\n", link->fd, link->pin_path);
+	zfree(&link->pin_path);
+	return 0;
+}
 
 static int bpf_link__detach_perf_event(struct bpf_link *link)
 {
-	struct bpf_link_fd *l = (void *)link;
 	int err;
 
-	err = ioctl(l->fd, PERF_EVENT_IOC_DISABLE, 0);
+	err = ioctl(link->fd, PERF_EVENT_IOC_DISABLE, 0);
 	if (err)
 		err = -errno;
 
-	close(l->fd);
+	close(link->fd);
 	return err;
 }
 
@@ -6987,7 +7072,7 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 						int pfd)
 {
 	char errmsg[STRERR_BUFSIZE];
-	struct bpf_link_fd *link;
+	struct bpf_link *link;
 	int prog_fd, err;
 
 	if (pfd < 0) {
@@ -7005,7 +7090,7 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 	link = calloc(1, sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
-	link->link.detach = &bpf_link__detach_perf_event;
+	link->detach = &bpf_link__detach_perf_event;
 	link->fd = pfd;
 
 	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
@@ -7024,7 +7109,7 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 			   libbpf_strerror_r(err, errmsg, sizeof(errmsg)));
 		return ERR_PTR(err);
 	}
-	return (struct bpf_link *)link;
+	return link;
 }
 
 /*
@@ -7312,18 +7397,11 @@ static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
 	return link;
 }
 
-static int bpf_link__detach_fd(struct bpf_link *link)
-{
-	struct bpf_link_fd *l = (void *)link;
-
-	return close(l->fd);
-}
-
 struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 						    const char *tp_name)
 {
 	char errmsg[STRERR_BUFSIZE];
-	struct bpf_link_fd *link;
+	struct bpf_link *link;
 	int prog_fd, pfd;
 
 	prog_fd = bpf_program__fd(prog);
@@ -7336,7 +7414,7 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 	link = calloc(1, sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
-	link->link.detach = &bpf_link__detach_fd;
+	link->detach = &bpf_link__detach_fd;
 
 	pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
 	if (pfd < 0) {
@@ -7348,7 +7426,7 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 		return ERR_PTR(pfd);
 	}
 	link->fd = pfd;
-	return (struct bpf_link *)link;
+	return link;
 }
 
 static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
@@ -7362,7 +7440,7 @@ static struct bpf_link *attach_raw_tp(const struct bpf_sec_def *sec,
 struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 {
 	char errmsg[STRERR_BUFSIZE];
-	struct bpf_link_fd *link;
+	struct bpf_link *link;
 	int prog_fd, pfd;
 
 	prog_fd = bpf_program__fd(prog);
@@ -7375,7 +7453,7 @@ struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 	link = calloc(1, sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
-	link->link.detach = &bpf_link__detach_fd;
+	link->detach = &bpf_link__detach_fd;
 
 	pfd = bpf_raw_tracepoint_open(NULL, prog_fd);
 	if (pfd < 0) {
@@ -7409,10 +7487,9 @@ struct bpf_link *bpf_program__attach(struct bpf_program *prog)
 
 static int bpf_link__detach_struct_ops(struct bpf_link *link)
 {
-	struct bpf_link_fd *l = (void *)link;
 	__u32 zero = 0;
 
-	if (bpf_map_delete_elem(l->fd, &zero))
+	if (bpf_map_delete_elem(link->fd, &zero))
 		return -errno;
 
 	return 0;
@@ -7421,7 +7498,7 @@ static int bpf_link__detach_struct_ops(struct bpf_link *link)
 struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
 {
 	struct bpf_struct_ops *st_ops;
-	struct bpf_link_fd *link;
+	struct bpf_link *link;
 	__u32 i, zero = 0;
 	int err;
 
@@ -7453,10 +7530,10 @@ struct bpf_link *bpf_map__attach_struct_ops(struct bpf_map *map)
 		return ERR_PTR(err);
 	}
 
-	link->link.detach = bpf_link__detach_struct_ops;
+	link->detach = bpf_link__detach_struct_ops;
 	link->fd = map->fd;
 
-	return (struct bpf_link *)link;
+	return link;
 }
 
 enum bpf_perf_event_ret
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 02fc58a21a7f..d38d7a629417 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -219,6 +219,11 @@ LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 
 struct bpf_link;
 
+LIBBPF_API struct bpf_link *bpf_link__open(const char *path);
+LIBBPF_API int bpf_link__fd(const struct bpf_link *link);
+LIBBPF_API const char *bpf_link__pin_path(const struct bpf_link *link);
+LIBBPF_API int bpf_link__pin(struct bpf_link *link, const char *path);
+LIBBPF_API int bpf_link__unpin(struct bpf_link *link);
 LIBBPF_API void bpf_link__disconnect(struct bpf_link *link);
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 7b014c8cdece..5129283c0284 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -238,5 +238,10 @@ LIBBPF_0.0.7 {
 
 LIBBPF_0.0.8 {
 	global:
+		bpf_link__fd;
+		bpf_link__open;
+		bpf_link__pin;
+		bpf_link__pin_path;
+		bpf_link__unpin;
 		bpf_program__set_attach_target;
 } LIBBPF_0.0.7;
-- 
2.17.1

