Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 303DF4E9E03
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245058AbiC1R4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244928AbiC1R4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:56:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5316B237E0;
        Mon, 28 Mar 2022 10:53:48 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0d716hCz67bVy;
        Tue, 29 Mar 2022 01:51:55 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:53:44 +0200
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
Subject: [PATCH 12/18] bpf-preload: Implement new registration method for preloading eBPF programs
Date:   Mon, 28 Mar 2022 19:50:27 +0200
Message-ID: <20220328175033.2437312-13-roberto.sassu@huawei.com>
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

The current registration method consisting in setting the bpf_preload_ops
global variable is not suitable for preloading multiple eBPF programs, as
each eBPF program would overwrite the global variable with its own method.

Implement a new registration method in two steps. First, introduce
bpf_init_preload_list() to populate at kernel initialization time the new
linked list with an element for each of the desired eBPF programs to
preload.

Second, introduce bpf_preload_set_ops() to allow an eBPF program to set its
preload method in the corresponding item of the linked list. The condition
for a successful registration is that the item in the linked list should
already exist. Return a boolean value to report if registration was
successful or not.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 include/linux/bpf_preload.h |   7 +++
 kernel/bpf/inode.c          | 107 +++++++++++++++++++++++++++++++++++-
 2 files changed, 113 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf_preload.h b/include/linux/bpf_preload.h
index e604933b3daa..bdbe75c22fcb 100644
--- a/include/linux/bpf_preload.h
+++ b/include/linux/bpf_preload.h
@@ -19,12 +19,19 @@ extern struct bpf_preload_ops *bpf_preload_ops;
 
 int bpf_obj_do_pin_kernel(struct dentry *parent, const char *name, void *raw,
 			  enum bpf_type type);
+bool bpf_preload_set_ops(const char *name, struct module *owner,
+			 struct bpf_preload_ops *ops);
 #else
 static inline int bpf_obj_do_pin_kernel(struct dentry *parent, const char *name,
 					void *raw, enum bpf_type type)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline bool bpf_preload_set_ops(const char *name, struct module *owner,
+				       struct bpf_preload_ops *ops)
+{
+}
 #endif /*CONFIG_BPF_SYSCALL*/
 
 #endif
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 0a6e83d32360..440ea517cc29 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -22,6 +22,8 @@
 #include <linux/bpf_trace.h>
 #include <linux/bpf_preload.h>
 
+static char *bpf_preload_list_str;
+
 static void *bpf_any_get(void *raw, enum bpf_type type)
 {
 	switch (type) {
@@ -855,6 +857,100 @@ static struct file_system_type bpf_fs_type = {
 	.kill_sb	= kill_litter_super,
 };
 
+static struct bpf_preload_ops_item *
+bpf_preload_list_lookup_entry(const char *obj_name)
+{
+	struct bpf_preload_ops_item *cur;
+
+	list_for_each_entry(cur, &preload_list, list)
+		if (!strcmp(obj_name, cur->obj_name))
+			return cur;
+
+	return NULL;
+}
+
+static int bpf_preload_list_add_entry(const char *obj_name,
+				      struct bpf_preload_ops *ops)
+{
+	struct bpf_preload_ops_item *new;
+
+	if (!*obj_name)
+		return 0;
+
+	new = kzalloc(sizeof(*new), GFP_NOFS);
+	if (!new)
+		return -ENOMEM;
+
+	new->obj_name = kstrdup(obj_name, GFP_NOFS);
+	if (!new->obj_name) {
+		kfree(new);
+		return -ENOMEM;
+	}
+
+	new->ops = ops;
+
+	list_add(&new->list, &preload_list);
+	return 0;
+}
+
+bool bpf_preload_set_ops(const char *obj_name, struct module *owner,
+			 struct bpf_preload_ops *ops)
+{
+	struct bpf_preload_ops_item *found_item;
+	bool set = false;
+
+	mutex_lock(&bpf_preload_lock);
+
+	found_item = bpf_preload_list_lookup_entry(obj_name);
+	if (found_item) {
+		if (!found_item->ops ||
+		    (found_item->ops && found_item->ops->owner == owner)) {
+			found_item->ops = ops;
+			set = true;
+		}
+	}
+
+	mutex_unlock(&bpf_preload_lock);
+	return set;
+}
+EXPORT_SYMBOL_GPL(bpf_preload_set_ops);
+
+static int __init bpf_init_preload_list(void)
+{
+	char *str_ptr = bpf_preload_list_str, *str_end;
+	struct bpf_preload_ops_item *cur, *tmp;
+	char obj_name[NAME_MAX + 1];
+	int ret;
+
+	while (str_ptr && *str_ptr) {
+		str_end = strchrnul(str_ptr, ',');
+
+		snprintf(obj_name, sizeof(obj_name), "%.*s",
+			 (int)(str_end - str_ptr), str_ptr);
+
+		if (!bpf_preload_list_lookup_entry(obj_name)) {
+			ret = bpf_preload_list_add_entry(obj_name, NULL);
+			if (ret)
+				goto out;
+		}
+
+		if (!*str_end)
+			break;
+
+		str_ptr = str_end + 1;
+	}
+
+	return 0;
+out:
+	list_for_each_entry_safe(cur, tmp, &preload_list, list) {
+		list_del(&cur->list);
+		kfree(cur->obj_name);
+		kfree(cur);
+	}
+
+	return ret;
+}
+
 static int __init bpf_init(void)
 {
 	int ret;
@@ -864,8 +960,17 @@ static int __init bpf_init(void)
 		return ret;
 
 	ret = register_filesystem(&bpf_fs_type);
-	if (ret)
+	if (ret) {
 		sysfs_remove_mount_point(fs_kobj, "bpf");
+		return ret;
+	}
+
+	ret = bpf_init_preload_list();
+	if (ret) {
+		unregister_filesystem(&bpf_fs_type);
+		sysfs_remove_mount_point(fs_kobj, "bpf");
+		return ret;
+	}
 
 	return ret;
 }
-- 
2.32.0

