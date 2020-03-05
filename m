Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8054B17A802
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgCEOqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:46:05 -0500
Received: from forwardcorp1o.mail.yandex.net ([95.108.205.193]:40540 "EHLO
        forwardcorp1o.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726007AbgCEOqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:46:05 -0500
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id A73272E1590;
        Thu,  5 Mar 2020 17:46:02 +0300 (MSK)
Received: from vla1-5a8b76e65344.qloud-c.yandex.net (vla1-5a8b76e65344.qloud-c.yandex.net [2a02:6b8:c0d:3183:0:640:5a8b:76e6])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id YwBzQzhqnL-k1OS3OfW;
        Thu, 05 Mar 2020 17:46:02 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1583419562; bh=fo3tbG3C0PXsxTJCTn1PgRXt8vVMVs6kMIso0QOwg3c=;
        h=Message-ID:Subject:To:From:Date:Cc;
        b=pPfabWCbqU0SUkUNiYfkjfgpPH0EJ9NvoYGMEYFoyfCAyA2CNrbsY4mov2d36Qv8W
         6EgJu4ctmWD9aCUkSOFi53YF6cCNGxG62hLDBroIXvHP9xX09XtQsK2DZiatxDoc0S
         TUE6BAQgm4OKlQlobI5isNgkV5a/CYhSpxmraWtc=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-red.dhcp.yndx.net (dynamic-red.dhcp.yndx.net [2a02:6b8:0:40c:dd96:4e43:5407:4249])
        by vla1-5a8b76e65344.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id lLMAkb7OLk-k1VmSN1u;
        Thu, 05 Mar 2020 17:46:01 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Thu, 5 Mar 2020 17:45:57 +0300
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     khlebnikov@yandex-team.ru
Subject: [PATCH net] cgroup, netclassid: periodically release file_lock on
 classid updating
Message-ID: <20200305144557.GA78822@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In our production environment we have faced with problem that updating
classid in cgroup with heavy tasks cause long freeze of the file tables
in this tasks. By heavy tasks we understand tasks with many threads and
opened sockets (e.g. balancers). This freeze leads to an increase number
of client timeouts.

This patch implements following logic to fix this issue:
аfter iterating 1000 file descriptors file table lock will be released
thus providing a time gap for socket creation/deletion.

Now update is non atomic and socket may be skipped using calls:

dup2(oldfd, newfd);
close(oldfd);

But this case is not typical. Moreover before this patch skip is possible
too by hiding socket fd in unix socket buffer.

New sockets will be allocated with updated classid because cgroup state
is updated before start of the file descriptors iteration.

So in common cases this patch has no side effects.

Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
Reviewed-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 net/core/netclassid_cgroup.c | 47 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/net/core/netclassid_cgroup.c b/net/core/netclassid_cgroup.c
index 0642f91..b4c87fe 100644
--- a/net/core/netclassid_cgroup.c
+++ b/net/core/netclassid_cgroup.c
@@ -53,30 +53,60 @@ static void cgrp_css_free(struct cgroup_subsys_state *css)
 	kfree(css_cls_state(css));
 }
 
+/*
+ * To avoid freezing of sockets creation for tasks with big number of threads
+ * and opened sockets lets release file_lock every 1000 iterated descriptors.
+ * New sockets will already have been created with new classid.
+ */
+
+struct update_classid_context {
+	u32 classid;
+	unsigned int batch;
+};
+
+#define UPDATE_CLASSID_BATCH 1000
+
 static int update_classid_sock(const void *v, struct file *file, unsigned n)
 {
 	int err;
+	struct update_classid_context *ctx = (void *)v;
 	struct socket *sock = sock_from_file(file, &err);
 
 	if (sock) {
 		spin_lock(&cgroup_sk_update_lock);
-		sock_cgroup_set_classid(&sock->sk->sk_cgrp_data,
-					(unsigned long)v);
+		sock_cgroup_set_classid(&sock->sk->sk_cgrp_data, ctx->classid);
 		spin_unlock(&cgroup_sk_update_lock);
 	}
+	if (--ctx->batch == 0) {
+		ctx->batch = UPDATE_CLASSID_BATCH;
+		return n + 1;
+	}
 	return 0;
 }
 
+static void update_classid_task(struct task_struct *p, u32 classid)
+{
+	struct update_classid_context ctx = {
+		.classid = classid,
+		.batch = UPDATE_CLASSID_BATCH
+	};
+	unsigned int fd = 0;
+
+	do {
+		task_lock(p);
+		fd = iterate_fd(p->files, fd, update_classid_sock, &ctx);
+		task_unlock(p);
+		cond_resched();
+	} while (fd);
+}
+
 static void cgrp_attach(struct cgroup_taskset *tset)
 {
 	struct cgroup_subsys_state *css;
 	struct task_struct *p;
 
 	cgroup_taskset_for_each(p, css, tset) {
-		task_lock(p);
-		iterate_fd(p->files, 0, update_classid_sock,
-			   (void *)(unsigned long)css_cls_state(css)->classid);
-		task_unlock(p);
+		update_classid_task(p, css_cls_state(css)->classid);
 	}
 }
 
@@ -98,10 +128,7 @@ static int write_classid(struct cgroup_subsys_state *css, struct cftype *cft,
 
 	css_task_iter_start(css, 0, &it);
 	while ((p = css_task_iter_next(&it))) {
-		task_lock(p);
-		iterate_fd(p->files, 0, update_classid_sock,
-			   (void *)(unsigned long)cs->classid);
-		task_unlock(p);
+		update_classid_task(p, cs->classid);
 		cond_resched();
 	}
 	css_task_iter_end(&it);
-- 
2.7.4

