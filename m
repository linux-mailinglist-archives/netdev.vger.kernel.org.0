Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 608784E9E56
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245070AbiC1R4b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244810AbiC1R4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:56:19 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451AA2316A;
        Mon, 28 Mar 2022 10:53:47 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0cL000Bz67mcQ;
        Tue, 29 Mar 2022 01:51:13 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:53:43 +0200
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
Subject: [PATCH 11/18] bpf-preload: Store multiple bpf_preload_ops structures in a linked list
Date:   Mon, 28 Mar 2022 19:50:26 +0200
Message-ID: <20220328175033.2437312-12-roberto.sassu@huawei.com>
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

In preparation to support preloading multiple eBPF programs, define a
linked list of bpf_preload_ops_item structures. The new structure contains
the object name from the eBPF program to preload (except for iterators_bpf
whose kernel module name is bpf_preload, the object name and the kernel
module name should match).

The new structure also contains a bpf_preload_ops structure declared in the
light skeleton, with the preload method of the eBPF program.

The list of eBPF programs that can be preloaded can be specified in a
subsequent patch from the kernel configuration or with the new option
bpf_preload_list= in the kernel command line.

For now, bpf_preload is always preloaded, as it still relies on the old
registration method consisting in setting the bpf_preload_ops global
variable. That will change when bpf_preload will switch to the new
registration method based on the linked list.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 kernel/bpf/inode.c | 89 +++++++++++++++++++++++++++++++++++++---------
 1 file changed, 73 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index bb8762abbf3d..0a6e83d32360 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -685,35 +685,91 @@ static int bpf_parse_param(struct fs_context *fc, struct fs_parameter *param)
 struct bpf_preload_ops *bpf_preload_ops;
 EXPORT_SYMBOL_GPL(bpf_preload_ops);
 
-static bool bpf_preload_mod_get(void)
+struct bpf_preload_ops_item {
+	struct list_head list;
+	struct bpf_preload_ops *ops;
+	char *obj_name;
+};
+
+static LIST_HEAD(preload_list);
+static DEFINE_MUTEX(bpf_preload_lock);
+
+static bool bpf_preload_mod_get(const char *obj_name,
+				struct bpf_preload_ops **ops)
 {
-	/* If bpf_preload.ko wasn't loaded earlier then load it now.
-	 * When bpf_preload is built into vmlinux the module's __init
+	/* If the kernel preload module wasn't loaded earlier then load it now.
+	 * When the preload code is built into vmlinux the module's __init
 	 * function will populate it.
 	 */
-	if (!bpf_preload_ops) {
-		request_module("bpf_preload");
-		if (!bpf_preload_ops)
+	if (!*ops) {
+		mutex_unlock(&bpf_preload_lock);
+		request_module(obj_name);
+		mutex_lock(&bpf_preload_lock);
+		if (!*ops)
 			return false;
 	}
 	/* And grab the reference, so the module doesn't disappear while the
 	 * kernel is interacting with the kernel module and its UMD.
 	 */
-	if (!try_module_get(bpf_preload_ops->owner)) {
+	if (!try_module_get((*ops)->owner)) {
 		pr_err("bpf_preload module get failed.\n");
 		return false;
 	}
 	return true;
 }
 
-static void bpf_preload_mod_put(void)
+static void bpf_preload_mod_put(struct bpf_preload_ops *ops)
 {
-	if (bpf_preload_ops)
-		/* now user can "rmmod bpf_preload" if necessary */
-		module_put(bpf_preload_ops->owner);
+	if (ops)
+		/* now user can "rmmod <kernel module>" if necessary */
+		module_put(ops->owner);
 }
 
-static DEFINE_MUTEX(bpf_preload_lock);
+static bool bpf_preload_list_mod_get(void)
+{
+	struct bpf_preload_ops_item *cur;
+	bool ret = false;
+
+	ret |= bpf_preload_mod_get("bpf_preload", &bpf_preload_ops);
+
+	list_for_each_entry(cur, &preload_list, list)
+		ret |= bpf_preload_mod_get(cur->obj_name, &cur->ops);
+
+	return ret;
+}
+
+static int bpf_preload_list(struct dentry *parent)
+{
+	struct bpf_preload_ops_item *cur;
+	int err;
+
+	if (bpf_preload_ops) {
+		err = bpf_preload_ops->preload(parent);
+		if (err)
+			return err;
+	}
+
+	list_for_each_entry(cur, &preload_list, list) {
+		if (!cur->ops)
+			continue;
+
+		err = cur->ops->preload(parent);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static void bpf_preload_list_mod_put(void)
+{
+	struct bpf_preload_ops_item *cur;
+
+	list_for_each_entry(cur, &preload_list, list)
+		bpf_preload_mod_put(cur->ops);
+
+	bpf_preload_mod_put(bpf_preload_ops);
+}
 
 static int populate_bpffs(struct dentry *parent)
 {
@@ -724,12 +780,13 @@ static int populate_bpffs(struct dentry *parent)
 	 */
 	mutex_lock(&bpf_preload_lock);
 
-	/* if bpf_preload.ko wasn't built into vmlinux then load it */
-	if (!bpf_preload_mod_get())
+	/* if kernel preload mods weren't built into vmlinux then load them */
+	if (!bpf_preload_list_mod_get())
 		goto out;
 
-	err = bpf_preload_ops->preload(parent);
-	bpf_preload_mod_put();
+	err = bpf_preload_list(parent);
+	bpf_preload_list_mod_put();
+
 out:
 	mutex_unlock(&bpf_preload_lock);
 	return err;
-- 
2.32.0

