Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0DE125736
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 23:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfLRWu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 17:50:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36758 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726387AbfLRWu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 17:50:59 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBIMosCs023545
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 14:50:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=xuRuGaZgE31G11DRik5RdFIXjI/noajopne86ModjmA=;
 b=HfwBeDTgy4QEogg6wkd3CZ86ZrJb4OhCLyvLN8Pq0O4C+n1ie5zZ01NWNqj4obh4PVV1
 kMzgNxfD58iM7pc/Fo6wByDGsseI/tMEbK5eYuT27fSd+JK3i+A8xsrUfcR+VD8f01Vs
 GM3NjwF7tbJFZigC4rlUwBCh4iVz6FXgpNI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wye5f4btr-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 14:50:57 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Wed, 18 Dec 2019 14:50:44 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 95F912EC16E6; Wed, 18 Dec 2019 14:50:43 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kafai@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: add bpf_link__disconnect() API to preserve underlying BPF resource
Date:   Wed, 18 Dec 2019 14:50:39 -0800
Message-ID: <20191218225039.2668205-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-18_07:2019-12-17,2019-12-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 bulkscore=0 priorityscore=1501 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 suspectscore=25 phishscore=0 adultscore=0 clxscore=1015
 mlxscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912180170
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are cases in which BPF resource (program, map, etc) has to outlive
userspace program that "installed" it in the system in the first place.
When BPF program is attached, libbpf returns bpf_link object, which
is supposed to be destroyed after no longer necessary through
bpf_link__destroy() API. Currently, bpf_link destruction causes both automatic
detachment and frees up any resources allocated to for bpf_link in-memory
representation. This is inconvenient for the case described above because of
coupling of detachment and resource freeing.

This patch introduces bpf_link__disconnect() API call, which marks bpf_link as
disconnected from its underlying BPF resouces. This means that when bpf_link
is destroyed later, all its memory resources will be freed, but BPF resource
itself won't be detached.

This design allows to follow strict and resource-leak-free design by default,
while giving easy and straightforward way for user code to opt for keeping BPF
resource attached beyond lifetime of a bpf_link. For some BPF programs (i.e.,
FS-based tracepoints, kprobes, raw tracepoint, etc), user has to make sure to
pin BPF program to prevent kernel to automatically detach it on process exit.
This should typically be achived by pinning BPF program (or map in some cases)
in BPF FS.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c   | 40 ++++++++++++++++++++++++++++++----------
 tools/lib/bpf/libbpf.h   |  1 +
 tools/lib/bpf/libbpf.map |  1 +
 3 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 906bbbf7b2e4..2a341a5b9f63 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6245,17 +6245,37 @@ int bpf_prog_load_xattr(const struct bpf_prog_load_attr *attr,
 }
 
 struct bpf_link {
+	int (*detach)(struct bpf_link *link);
 	int (*destroy)(struct bpf_link *link);
+	bool disconnected;
 };
 
+/* Release "ownership" of underlying BPF resource (typically, BPF program
+ * attached to some BPF hook, e.g., tracepoint, kprobe, etc). Disconnected
+ * link, when destructed through bpf_link__destroy() call won't attempt to
+ * detach/unregisted that BPF resource. This is useful in situations where,
+ * say, attached BPF program has to outlive userspace program that attached it
+ * in the system. Depending on type of BPF program, though, there might be
+ * additional steps (like pinning BPF program in BPF FS) necessary to ensure
+ * exit of userspace program doesn't trigger automatic detachment and clean up
+ * inside the kernel.
+ */
+void bpf_link__disconnect(struct bpf_link *link)
+{
+	link->disconnected = true;
+}
+
 int bpf_link__destroy(struct bpf_link *link)
 {
-	int err;
+	int err = 0;
 
 	if (!link)
 		return 0;
 
-	err = link->destroy(link);
+	if (!link->disconnected && link->detach)
+		err = link->detach(link);
+	if (link->destroy)
+		link->destroy(link);
 	free(link);
 
 	return err;
@@ -6266,7 +6286,7 @@ struct bpf_link_fd {
 	int fd; /* hook FD */
 };
 
-static int bpf_link__destroy_perf_event(struct bpf_link *link)
+static int bpf_link__detach_perf_event(struct bpf_link *link)
 {
 	struct bpf_link_fd *l = (void *)link;
 	int err;
@@ -6298,10 +6318,10 @@ struct bpf_link *bpf_program__attach_perf_event(struct bpf_program *prog,
 		return ERR_PTR(-EINVAL);
 	}
 
-	link = malloc(sizeof(*link));
+	link = calloc(1, sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
-	link->link.destroy = &bpf_link__destroy_perf_event;
+	link->link.detach = &bpf_link__detach_perf_event;
 	link->fd = pfd;
 
 	if (ioctl(pfd, PERF_EVENT_IOC_SET_BPF, prog_fd) < 0) {
@@ -6608,7 +6628,7 @@ static struct bpf_link *attach_tp(const struct bpf_sec_def *sec,
 	return link;
 }
 
-static int bpf_link__destroy_fd(struct bpf_link *link)
+static int bpf_link__detach_fd(struct bpf_link *link)
 {
 	struct bpf_link_fd *l = (void *)link;
 
@@ -6629,10 +6649,10 @@ struct bpf_link *bpf_program__attach_raw_tracepoint(struct bpf_program *prog,
 		return ERR_PTR(-EINVAL);
 	}
 
-	link = malloc(sizeof(*link));
+	link = calloc(1, sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
-	link->link.destroy = &bpf_link__destroy_fd;
+	link->link.detach = &bpf_link__detach_fd;
 
 	pfd = bpf_raw_tracepoint_open(tp_name, prog_fd);
 	if (pfd < 0) {
@@ -6668,10 +6688,10 @@ struct bpf_link *bpf_program__attach_trace(struct bpf_program *prog)
 		return ERR_PTR(-EINVAL);
 	}
 
-	link = malloc(sizeof(*link));
+	link = calloc(1, sizeof(*link));
 	if (!link)
 		return ERR_PTR(-ENOMEM);
-	link->link.destroy = &bpf_link__destroy_fd;
+	link->link.detach = &bpf_link__detach_fd;
 
 	pfd = bpf_raw_tracepoint_open(NULL, prog_fd);
 	if (pfd < 0) {
diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index f7084235bae9..ad8c1c127933 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -215,6 +215,7 @@ LIBBPF_API void bpf_program__unload(struct bpf_program *prog);
 
 struct bpf_link;
 
+LIBBPF_API void bpf_link__disconnect(struct bpf_link *link);
 LIBBPF_API int bpf_link__destroy(struct bpf_link *link);
 
 LIBBPF_API struct bpf_link *
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index 1376d992a703..e3a471f38a71 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -212,6 +212,7 @@ LIBBPF_0.0.6 {
 LIBBPF_0.0.7 {
 	global:
 		btf_dump__emit_type_decl;
+		bpf_link__disconnect;
 		bpf_object__find_program_by_name;
 		bpf_object__attach_skeleton;
 		bpf_object__destroy_skeleton;
-- 
2.17.1

