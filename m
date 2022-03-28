Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 457C44E9E45
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:56:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244935AbiC1R4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244929AbiC1R4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:56:20 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B7823BCC;
        Mon, 28 Mar 2022 10:53:48 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0cN3jGnz67w73;
        Tue, 29 Mar 2022 01:51:16 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:53:45 +0200
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
Subject: [PATCH 13/18] bpf-preload: Move pinned links and maps to a dedicated directory in bpffs
Date:   Mon, 28 Mar 2022 19:50:28 +0200
Message-ID: <20220328175033.2437312-14-roberto.sassu@huawei.com>
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

With support for preloading multiple eBPF programs, any map, link or prog
will appear in the bpf filesystem. To identify which eBPF program a pinned
object belongs to, create a subdir for each eBPF program preloaded and
place the pinned object in the new subdir.

Keep the pinned objects of iterators_bpf in the root directory of bpffs,
for compatibility reasons.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 kernel/bpf/inode.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 440ea517cc29..619cdef0ba54 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -740,9 +740,30 @@ static bool bpf_preload_list_mod_get(void)
 	return ret;
 }
 
+static struct dentry *create_subdir(struct dentry *parent, const char *name)
+{
+	struct dentry *dentry;
+	int err;
+
+	inode_lock(parent->d_inode);
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (IS_ERR(dentry))
+		goto out;
+
+	err = vfs_mkdir(&init_user_ns, parent->d_inode, dentry, 0755);
+	if (err) {
+		dput(dentry);
+		dentry = ERR_PTR(err);
+	}
+out:
+	inode_unlock(parent->d_inode);
+	return dentry;
+}
+
 static int bpf_preload_list(struct dentry *parent)
 {
 	struct bpf_preload_ops_item *cur;
+	struct dentry *cur_parent;
 	int err;
 
 	if (bpf_preload_ops) {
@@ -755,7 +776,19 @@ static int bpf_preload_list(struct dentry *parent)
 		if (!cur->ops)
 			continue;
 
-		err = cur->ops->preload(parent);
+		cur_parent = parent;
+
+		if (strcmp(cur->obj_name, "bpf_preload")) {
+			cur_parent = create_subdir(parent, cur->obj_name);
+			if (IS_ERR(cur_parent))
+				cur_parent = parent;
+		}
+
+		err = cur->ops->preload(cur_parent);
+
+		if (cur_parent != parent)
+			dput(cur_parent);
+
 		if (err)
 			return err;
 	}
-- 
2.32.0

