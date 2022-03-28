Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A651B4E9DE4
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:51:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244777AbiC1RxO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244775AbiC1Rw4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:52:56 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD65D3C735;
        Mon, 28 Mar 2022 10:51:15 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0YR4g3Pz67w73;
        Tue, 29 Mar 2022 01:48:43 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:51:12 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     <corbet@lwn.net>, <viro@zeniv.linux.org.uk>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <andrii@kernel.org>, <kpsingh@kernel.org>,
        <shuah@kernel.org>, <mcoquelin.stm32@gmail.com>,
        <alexandre.torgue@foss.st.com>, <zohar@linux.ibm.com>
CC:     <linux-doc@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        <linux-stm32@st-md-mailman.stormreply.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-integrity@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Roberto Sassu <roberto.sassu@huawei.com>
Subject: [PATCH 04/18] bpf-preload: Export and call bpf_obj_do_pin_kernel()
Date:   Mon, 28 Mar 2022 19:50:19 +0200
Message-ID: <20220328175033.2437312-5-roberto.sassu@huawei.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220328175033.2437312-1-roberto.sassu@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.204.63.22]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 fraeml714-chm.china.huawei.com (10.206.15.33)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export bpf_obj_do_pin_kernel(), so that the preload method of an eBPF
program (built-in or in a kernel module) can call this function to pin
links, maps and progs.

This removes the need of defining the bpf_preload_info structure, to hold
the links to be pinned by populate_bpffs().

Since after this patch the preload method has everything needed to pin
objects, that makes it possible to pin arbitrary objects of eBPF programs,
by generating the corresponding preload method in the light skeleton.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/bpf_preload.h           | 20 +++++++++++++-----
 kernel/bpf/inode.c                    | 30 +++++----------------------
 kernel/bpf/preload/bpf_preload_kern.c | 25 +++++++++++++++++-----
 3 files changed, 40 insertions(+), 35 deletions(-)

diff --git a/include/linux/bpf_preload.h b/include/linux/bpf_preload.h
index 09d55d9f1131..e604933b3daa 100644
--- a/include/linux/bpf_preload.h
+++ b/include/linux/bpf_preload.h
@@ -2,19 +2,29 @@
 #ifndef _BPF_PRELOAD_H
 #define _BPF_PRELOAD_H
 
-struct bpf_preload_info {
-	char link_name[16];
-	struct bpf_link *link;
+enum bpf_type {
+	BPF_TYPE_UNSPEC	= 0,
+	BPF_TYPE_PROG,
+	BPF_TYPE_MAP,
+	BPF_TYPE_LINK,
 };
 
 struct bpf_preload_ops {
-	int (*preload)(struct bpf_preload_info *);
+	int (*preload)(struct dentry *parent);
 	struct module *owner;
 };
 
 #ifdef CONFIG_BPF_SYSCALL
 extern struct bpf_preload_ops *bpf_preload_ops;
+
+int bpf_obj_do_pin_kernel(struct dentry *parent, const char *name, void *raw,
+			  enum bpf_type type);
+#else
+static inline int bpf_obj_do_pin_kernel(struct dentry *parent, const char *name,
+					void *raw, enum bpf_type type)
+{
+	return -EOPNOTSUPP;
+}
 #endif /*CONFIG_BPF_SYSCALL*/
 
-#define BPF_PRELOAD_LINKS 2
 #endif
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index a9d725db4cf4..bb8762abbf3d 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -22,13 +22,6 @@
 #include <linux/bpf_trace.h>
 #include <linux/bpf_preload.h>
 
-enum bpf_type {
-	BPF_TYPE_UNSPEC	= 0,
-	BPF_TYPE_PROG,
-	BPF_TYPE_MAP,
-	BPF_TYPE_LINK,
-};
-
 static void *bpf_any_get(void *raw, enum bpf_type type)
 {
 	switch (type) {
@@ -415,9 +408,8 @@ static const struct inode_operations bpf_dir_iops = {
 };
 
 /* pin object into bpffs */
-static int bpf_obj_do_pin_kernel(struct dentry *parent,
-				 const char *name, void *raw,
-				 enum bpf_type type)
+int bpf_obj_do_pin_kernel(struct dentry *parent, const char *name, void *raw,
+			  enum bpf_type type)
 {
 	umode_t mode = S_IFREG | S_IRUSR;
 	struct dentry *dentry;
@@ -449,6 +441,7 @@ static int bpf_obj_do_pin_kernel(struct dentry *parent,
 	inode_unlock(parent->d_inode);
 	return ret;
 }
+EXPORT_SYMBOL(bpf_obj_do_pin_kernel);
 
 static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 			  enum bpf_type type)
@@ -724,8 +717,7 @@ static DEFINE_MUTEX(bpf_preload_lock);
 
 static int populate_bpffs(struct dentry *parent)
 {
-	struct bpf_preload_info objs[BPF_PRELOAD_LINKS] = {};
-	int err = 0, i;
+	int err = 0;
 
 	/* grab the mutex to make sure the kernel interactions with bpf_preload
 	 * are serialized
@@ -736,19 +728,7 @@ static int populate_bpffs(struct dentry *parent)
 	if (!bpf_preload_mod_get())
 		goto out;
 
-	err = bpf_preload_ops->preload(objs);
-	if (err)
-		goto out_put;
-	for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
-		bpf_link_inc(objs[i].link);
-		err = bpf_obj_do_pin_kernel(parent, objs[i].link_name,
-					    objs[i].link, BPF_TYPE_LINK);
-		if (err) {
-			bpf_link_put(objs[i].link);
-			goto out_put;
-		}
-	}
-out_put:
+	err = bpf_preload_ops->preload(parent);
 	bpf_preload_mod_put();
 out:
 	mutex_unlock(&bpf_preload_lock);
diff --git a/kernel/bpf/preload/bpf_preload_kern.c b/kernel/bpf/preload/bpf_preload_kern.c
index f43391d1c49c..d70047108bb3 100644
--- a/kernel/bpf/preload/bpf_preload_kern.c
+++ b/kernel/bpf/preload/bpf_preload_kern.c
@@ -17,13 +17,28 @@ static void free_links_and_skel(void)
 	iterators_bpf__destroy(skel);
 }
 
-static int preload(struct bpf_preload_info *obj)
+static int preload(struct dentry *parent)
 {
-	strlcpy(obj[0].link_name, "maps.debug", sizeof(obj[0].link_name));
-	obj[0].link = maps_link;
-	strlcpy(obj[1].link_name, "progs.debug", sizeof(obj[1].link_name));
-	obj[1].link = progs_link;
+	int err;
+
+	bpf_link_inc(maps_link);
+	bpf_link_inc(progs_link);
+
+	err = bpf_obj_do_pin_kernel(parent, "maps.debug", maps_link,
+				    BPF_TYPE_LINK);
+	if (err)
+		goto undo;
+
+	err = bpf_obj_do_pin_kernel(parent, "progs.debug", progs_link,
+				    BPF_TYPE_LINK);
+	if (err)
+		goto undo;
+
 	return 0;
+undo:
+	bpf_link_put(maps_link);
+	bpf_link_put(progs_link);
+	return err;
 }
 
 static struct bpf_preload_ops ops = {
-- 
2.32.0

