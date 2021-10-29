Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3437343F48F
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 03:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbhJ2BvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 21:51:05 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:25322 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbhJ2BvF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 21:51:05 -0400
Received: from dggeme751-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HgQFQ1WbYzbhBT;
        Fri, 29 Oct 2021 09:43:54 +0800 (CST)
Received: from k03.huawei.com (10.67.174.111) by
 dggeme751-chm.china.huawei.com (10.3.19.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Fri, 29 Oct 2021 09:48:34 +0800
From:   He Fengqing <hefengqing@huawei.com>
To:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <tj@kernel.org>, <lizefan.x@bytedance.com>, <hannes@cmpxchg.org>
CC:     <bpf@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>
Subject: [PATCH] cgroup: bpf: Move wrapper for __cgroup_bpf_*() to kernel/bpf/cgroup.c
Date:   Fri, 29 Oct 2021 02:39:06 +0000
Message-ID: <20211029023906.245294-1-hefengqing@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.174.111]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme751-chm.china.huawei.com (10.3.19.97)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit 324bda9e6c5a("bpf: multi program support for cgroup+bpf")
cgroup_bpf_*() called from kernel/bpf/syscall.c, but now they are only
used in kernel/bpf/cgroup.c, so move these function to
kernel/bpf/cgroup.c, like cgroup_bpf_replace().

Signed-off-by: He Fengqing <hefengqing@huawei.com>
---
 include/linux/bpf-cgroup.h | 20 --------------
 kernel/bpf/cgroup.c        | 54 +++++++++++++++++++++++++++++++-------
 kernel/cgroup/cgroup.c     | 38 ---------------------------
 3 files changed, 45 insertions(+), 67 deletions(-)

diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
index 2746fd804216..9aad4e3ca29b 100644
--- a/include/linux/bpf-cgroup.h
+++ b/include/linux/bpf-cgroup.h
@@ -157,26 +157,6 @@ struct cgroup_bpf {
 int cgroup_bpf_inherit(struct cgroup *cgrp);
 void cgroup_bpf_offline(struct cgroup *cgrp);
 
-int __cgroup_bpf_attach(struct cgroup *cgrp,
-			struct bpf_prog *prog, struct bpf_prog *replace_prog,
-			struct bpf_cgroup_link *link,
-			enum bpf_attach_type type, u32 flags);
-int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-			struct bpf_cgroup_link *link,
-			enum bpf_attach_type type);
-int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
-		       union bpf_attr __user *uattr);
-
-/* Wrapper for __cgroup_bpf_*() protected by cgroup_mutex */
-int cgroup_bpf_attach(struct cgroup *cgrp,
-		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
-		      struct bpf_cgroup_link *link, enum bpf_attach_type type,
-		      u32 flags);
-int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type);
-int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
-		     union bpf_attr __user *uattr);
-
 int __cgroup_bpf_run_filter_skb(struct sock *sk,
 				struct sk_buff *skb,
 				enum cgroup_bpf_attach_type atype);
diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 03145d45e3d5..2ca643af9a54 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -430,10 +430,10 @@ static struct bpf_prog_list *find_attach_entry(struct list_head *progs,
  * Exactly one of @prog or @link can be non-null.
  * Must be called with cgroup_mutex held.
  */
-int __cgroup_bpf_attach(struct cgroup *cgrp,
-			struct bpf_prog *prog, struct bpf_prog *replace_prog,
-			struct bpf_cgroup_link *link,
-			enum bpf_attach_type type, u32 flags)
+static int __cgroup_bpf_attach(struct cgroup *cgrp,
+			       struct bpf_prog *prog, struct bpf_prog *replace_prog,
+			       struct bpf_cgroup_link *link,
+			       enum bpf_attach_type type, u32 flags)
 {
 	u32 saved_flags = (flags & (BPF_F_ALLOW_OVERRIDE | BPF_F_ALLOW_MULTI));
 	struct bpf_prog *old_prog = NULL;
@@ -523,6 +523,20 @@ int __cgroup_bpf_attach(struct cgroup *cgrp,
 	return err;
 }
 
+static int cgroup_bpf_attach(struct cgroup *cgrp,
+			     struct bpf_prog *prog, struct bpf_prog *replace_prog,
+			     struct bpf_cgroup_link *link,
+			     enum bpf_attach_type type,
+			     u32 flags)
+{
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags);
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
 /* Swap updated BPF program for given link in effective program arrays across
  * all descendant cgroups. This function is guaranteed to succeed.
  */
@@ -672,14 +686,14 @@ static struct bpf_prog_list *find_detach_entry(struct list_head *progs,
  *                         propagate the change to descendants
  * @cgrp: The cgroup which descendants to traverse
  * @prog: A program to detach or NULL
- * @prog: A link to detach or NULL
+ * @link: A link to detach or NULL
  * @type: Type of detach operation
  *
  * At most one of @prog or @link can be non-NULL.
  * Must be called with cgroup_mutex held.
  */
-int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-			struct bpf_cgroup_link *link, enum bpf_attach_type type)
+static int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
+			       struct bpf_cgroup_link *link, enum bpf_attach_type type)
 {
 	enum cgroup_bpf_attach_type atype;
 	struct bpf_prog *old_prog;
@@ -730,9 +744,20 @@ int __cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
 	return err;
 }
 
+static int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
+			     enum bpf_attach_type type)
+{
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type);
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
 /* Must be called with cgroup_mutex held to avoid races. */
-int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
-		       union bpf_attr __user *uattr)
+static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
+			      union bpf_attr __user *uattr)
 {
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	enum bpf_attach_type type = attr->query.attach_type;
@@ -789,6 +814,17 @@ int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
 	return ret;
 }
 
+static int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
+			    union bpf_attr __user *uattr)
+{
+	int ret;
+
+	mutex_lock(&cgroup_mutex);
+	ret = __cgroup_bpf_query(cgrp, attr, uattr);
+	mutex_unlock(&cgroup_mutex);
+	return ret;
+}
+
 int cgroup_bpf_prog_attach(const union bpf_attr *attr,
 			   enum bpf_prog_type ptype, struct bpf_prog *prog)
 {
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a..ffc2f2b9b68f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6623,44 +6623,6 @@ void cgroup_sk_free(struct sock_cgroup_data *skcd)
 
 #endif	/* CONFIG_SOCK_CGROUP_DATA */
 
-#ifdef CONFIG_CGROUP_BPF
-int cgroup_bpf_attach(struct cgroup *cgrp,
-		      struct bpf_prog *prog, struct bpf_prog *replace_prog,
-		      struct bpf_cgroup_link *link,
-		      enum bpf_attach_type type,
-		      u32 flags)
-{
-	int ret;
-
-	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_attach(cgrp, prog, replace_prog, link, type, flags);
-	mutex_unlock(&cgroup_mutex);
-	return ret;
-}
-
-int cgroup_bpf_detach(struct cgroup *cgrp, struct bpf_prog *prog,
-		      enum bpf_attach_type type)
-{
-	int ret;
-
-	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_detach(cgrp, prog, NULL, type);
-	mutex_unlock(&cgroup_mutex);
-	return ret;
-}
-
-int cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
-		     union bpf_attr __user *uattr)
-{
-	int ret;
-
-	mutex_lock(&cgroup_mutex);
-	ret = __cgroup_bpf_query(cgrp, attr, uattr);
-	mutex_unlock(&cgroup_mutex);
-	return ret;
-}
-#endif /* CONFIG_CGROUP_BPF */
-
 #ifdef CONFIG_SYSFS
 static ssize_t show_delegatable_files(struct cftype *files, char *buf,
 				      ssize_t size, const char *prefix)
-- 
2.25.1

