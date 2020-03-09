Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEE6217EC75
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 00:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727397AbgCIXK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 19:10:59 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51048 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727146AbgCIXK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 19:10:59 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029MuO45017790
        for <netdev@vger.kernel.org>; Mon, 9 Mar 2020 16:10:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=vRl1hxGTNa2mYo9soJcx79KiFce8qbWDsKlKujeepZM=;
 b=A3VBc5Bov9wW2PZSZwewUjuAydYBfGGcYznmDAPQD6uPoKq/iQUBZfgb9JBiD1ahowym
 cR9JYvvNhO9HGzq31+VD0Bhb2bGEHhrt3huNFyaPOEBrbsUESl9z20f9bbAwopRG0xMP
 jALYAYkDesPMqiIj0CZLHZqgm8zbGMucRiI= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv8w7afv-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 16:10:58 -0700
Received: from intmgw001.08.frc2.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 16:10:57 -0700
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 37B272EC27CA; Mon,  9 Mar 2020 16:10:52 -0700 (PDT)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] bpf: add bpf_link_new_file that doesn't install FD
Date:   Mon, 9 Mar 2020 16:10:51 -0700
Message-ID: <20200309231051.1270337-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_12:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 lowpriorityscore=0 spamscore=0 impostorscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 suspectscore=25 adultscore=0 clxscore=1015 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003090139
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add bpf_link_new_file() API for cases when we need to ensure anon_inode is
successfully created before we proceed with expensive BPF program attachment
procedure, which will require equally (if not more so) expensive and
potentially failing compensation detachment procedure just because anon_inode
creation failed. This API allows to simplify code by ensuring first that
anon_inode is created and after BPF program is attached proceed with
fd_install() that can't fail.

After anon_inode file is created, link can't be just kfree()'d anymore,
because its destruction will be performed by deferred file_operations->release
call. For this, bpf_link API required specifying two separate operations:
release() and dealloc(), former performing detachment only, while the latter
frees memory used by bpf_link itself. dealloc() needs to be specified, because
struct bpf_link is frequently embedded into link type-specific container
struct (e.g., struct bpf_raw_tp_link), so bpf_link itself doesn't know how to
properly free the memory. In case when anon_inode file was successfully
created, but subsequent BPF attachment failed, bpf_link needs to be marked as
"defunct", so that file's release() callback will perform only memory
deallocation, but no detachment.

Convert raw tracepoint and tracing attachment to new API and eliminate
detachment from error handling path.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 include/linux/bpf.h  |   3 ++
 kernel/bpf/syscall.c | 122 +++++++++++++++++++++++++++++++------------
 2 files changed, 91 insertions(+), 34 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 94a329b9da81..4fd91b7c95ea 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1070,13 +1070,16 @@ struct bpf_link;
 
 struct bpf_link_ops {
 	void (*release)(struct bpf_link *link);
+	void (*dealloc)(struct bpf_link *link);
 };
 
 void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
 		   struct bpf_prog *prog);
+void bpf_link_defunct(struct bpf_link *link);
 void bpf_link_inc(struct bpf_link *link);
 void bpf_link_put(struct bpf_link *link);
 int bpf_link_new_fd(struct bpf_link *link);
+struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd);
 struct bpf_link *bpf_link_get_from_fd(u32 ufd);
 
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 7ce0815793dd..b2f73ecacced 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2188,6 +2188,11 @@ void bpf_link_init(struct bpf_link *link, const struct bpf_link_ops *ops,
 	link->prog = prog;
 }
 
+void bpf_link_defunct(struct bpf_link *link)
+{
+	link->prog = NULL;
+}
+
 void bpf_link_inc(struct bpf_link *link)
 {
 	atomic64_inc(&link->refcnt);
@@ -2196,14 +2201,13 @@ void bpf_link_inc(struct bpf_link *link)
 /* bpf_link_free is guaranteed to be called from process context */
 static void bpf_link_free(struct bpf_link *link)
 {
-	struct bpf_prog *prog;
-
-	/* remember prog locally, because release below will free link memory */
-	prog = link->prog;
-	/* extra clean up and kfree of container link struct */
-	link->ops->release(link);
-	/* no more accesing of link members after this point */
-	bpf_prog_put(prog);
+	if (link->prog) {
+		/* detach BPF program, clean up used resources */
+		link->ops->release(link);
+		bpf_prog_put(link->prog);
+	}
+	/* free bpf_link and its containing memory */
+	link->ops->dealloc(link);
 }
 
 static void bpf_link_put_deferred(struct work_struct *work)
@@ -2281,6 +2285,33 @@ int bpf_link_new_fd(struct bpf_link *link)
 	return anon_inode_getfd("bpf-link", &bpf_link_fops, link, O_CLOEXEC);
 }
 
+/* Similar to bpf_link_new_fd, create anon_inode for given bpf_link, but
+ * instead of immediately installing fd in fdtable, just reserve it and
+ * return. Caller then need to either install it with fd_install(fd, file) or
+ * release with put_unused_fd(fd).
+ * This is useful for cases when bpf_link attachment/detachment are
+ * complicated and expensive operations and should be delayed until all the fd
+ * reservation and anon_inode creation succeeds.
+ */
+struct file *bpf_link_new_file(struct bpf_link *link, int *reserved_fd)
+{
+	struct file *file;
+	int fd;
+
+	fd = get_unused_fd_flags(O_CLOEXEC);
+	if (fd < 0)
+		return ERR_PTR(fd);
+
+	file = anon_inode_getfile("bpf_link", &bpf_link_fops, link, O_CLOEXEC);
+	if (IS_ERR(file)) {
+		put_unused_fd(fd);
+		return file;
+	}
+
+	*reserved_fd = fd;
+	return file;
+}
+
 struct bpf_link *bpf_link_get_from_fd(u32 ufd)
 {
 	struct fd f = fdget(ufd);
@@ -2305,21 +2336,27 @@ struct bpf_tracing_link {
 };
 
 static void bpf_tracing_link_release(struct bpf_link *link)
+{
+	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
+}
+
+static void bpf_tracing_link_dealloc(struct bpf_link *link)
 {
 	struct bpf_tracing_link *tr_link =
 		container_of(link, struct bpf_tracing_link, link);
 
-	WARN_ON_ONCE(bpf_trampoline_unlink_prog(link->prog));
 	kfree(tr_link);
 }
 
 static const struct bpf_link_ops bpf_tracing_link_lops = {
 	.release = bpf_tracing_link_release,
+	.dealloc = bpf_tracing_link_dealloc,
 };
 
 static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 {
 	struct bpf_tracing_link *link;
+	struct file *link_file;
 	int link_fd, err;
 
 	if (prog->expected_attach_type != BPF_TRACE_FENTRY &&
@@ -2337,20 +2374,24 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog)
 	}
 	bpf_link_init(&link->link, &bpf_tracing_link_lops, prog);
 
-	err = bpf_trampoline_link_prog(prog);
-	if (err)
-		goto out_free_link;
+	link_file = bpf_link_new_file(&link->link, &link_fd);
+	if (IS_ERR(link_file)) {
+		kfree(link);
+		err = PTR_ERR(link_file);
+		goto out_put_prog;
+	}
 
-	link_fd = bpf_link_new_fd(&link->link);
-	if (link_fd < 0) {
-		WARN_ON_ONCE(bpf_trampoline_unlink_prog(prog));
-		err = link_fd;
-		goto out_free_link;
+	err = bpf_trampoline_link_prog(prog);
+	if (err) {
+		bpf_link_defunct(&link->link);
+		fput(link_file);
+		put_unused_fd(link_fd);
+		goto out_put_prog;
 	}
+
+	fd_install(link_fd, link_file);
 	return link_fd;
 
-out_free_link:
-	kfree(link);
 out_put_prog:
 	bpf_prog_put(prog);
 	return err;
@@ -2368,19 +2409,28 @@ static void bpf_raw_tp_link_release(struct bpf_link *link)
 
 	bpf_probe_unregister(raw_tp->btp, raw_tp->link.prog);
 	bpf_put_raw_tracepoint(raw_tp->btp);
+}
+
+static void bpf_raw_tp_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_raw_tp_link *raw_tp =
+		container_of(link, struct bpf_raw_tp_link, link);
+
 	kfree(raw_tp);
 }
 
 static const struct bpf_link_ops bpf_raw_tp_lops = {
 	.release = bpf_raw_tp_link_release,
+	.dealloc = bpf_raw_tp_link_dealloc,
 };
 
 #define BPF_RAW_TRACEPOINT_OPEN_LAST_FIELD raw_tracepoint.prog_fd
 
 static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 {
-	struct bpf_raw_tp_link *raw_tp;
+	struct bpf_raw_tp_link *link;
 	struct bpf_raw_event_map *btp;
+	struct file *link_file;
 	struct bpf_prog *prog;
 	const char *tp_name;
 	char buf[128];
@@ -2431,28 +2481,32 @@ static int bpf_raw_tracepoint_open(const union bpf_attr *attr)
 		goto out_put_prog;
 	}
 
-	raw_tp = kzalloc(sizeof(*raw_tp), GFP_USER);
-	if (!raw_tp) {
+	link = kzalloc(sizeof(*link), GFP_USER);
+	if (!link) {
 		err = -ENOMEM;
 		goto out_put_btp;
 	}
-	bpf_link_init(&raw_tp->link, &bpf_raw_tp_lops, prog);
-	raw_tp->btp = btp;
+	bpf_link_init(&link->link, &bpf_raw_tp_lops, prog);
+	link->btp = btp;
 
-	err = bpf_probe_register(raw_tp->btp, prog);
-	if (err)
-		goto out_free_tp;
+	link_file = bpf_link_new_file(&link->link, &link_fd);
+	if (IS_ERR(link_file)) {
+		kfree(link);
+		err = PTR_ERR(link_file);
+		goto out_put_btp;
+	}
 
-	link_fd = bpf_link_new_fd(&raw_tp->link);
-	if (link_fd < 0) {
-		bpf_probe_unregister(raw_tp->btp, prog);
-		err = link_fd;
-		goto out_free_tp;
+	err = bpf_probe_register(link->btp, prog);
+	if (err) {
+		bpf_link_defunct(&link->link);
+		fput(link_file);
+		put_unused_fd(link_fd);
+		goto out_put_btp;
 	}
+
+	fd_install(link_fd, link_file);
 	return link_fd;
 
-out_free_tp:
-	kfree(raw_tp);
 out_put_btp:
 	bpf_put_raw_tracepoint(btp);
 out_put_prog:
-- 
2.17.1

