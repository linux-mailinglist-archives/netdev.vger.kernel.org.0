Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5164E9DE9
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 19:51:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbiC1RxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 13:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244770AbiC1Rwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 13:52:55 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C3B03CA5F;
        Mon, 28 Mar 2022 10:51:14 -0700 (PDT)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KS0YQ3KRMz67Q7R;
        Tue, 29 Mar 2022 01:48:42 +0800 (CST)
Received: from roberto-ThinkStation-P620.huawei.com (10.204.63.22) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 28 Mar 2022 19:51:11 +0200
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
Subject: [PATCH 03/18] bpf-preload: Generalize object pinning from the kernel
Date:   Mon, 28 Mar 2022 19:50:18 +0200
Message-ID: <20220328175033.2437312-4-roberto.sassu@huawei.com>
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

Rename bpf_iter_link_pin_kernel() to bpf_obj_do_pin_kernel(), to match the
user space counterpart bpf_obj_do_pin() and similarly to the latter, accept
a generic object pointer and its type, so that the preload method can pin
not only links but also maps and progs.

Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
---
 kernel/bpf/inode.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 1f2d468abf58..a9d725db4cf4 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -414,9 +414,10 @@ static const struct inode_operations bpf_dir_iops = {
 	.unlink		= simple_unlink,
 };
 
-/* pin iterator link into bpffs */
-static int bpf_iter_link_pin_kernel(struct dentry *parent,
-				    const char *name, struct bpf_link *link)
+/* pin object into bpffs */
+static int bpf_obj_do_pin_kernel(struct dentry *parent,
+				 const char *name, void *raw,
+				 enum bpf_type type)
 {
 	umode_t mode = S_IFREG | S_IRUSR;
 	struct dentry *dentry;
@@ -428,8 +429,22 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 		inode_unlock(parent->d_inode);
 		return PTR_ERR(dentry);
 	}
-	ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
-			    &bpf_iter_fops);
+
+	switch (type) {
+	case BPF_TYPE_PROG:
+		ret = bpf_mkprog(dentry, mode, raw);
+		break;
+	case BPF_TYPE_MAP:
+		ret = bpf_mkmap(dentry, mode, raw);
+		break;
+	case BPF_TYPE_LINK:
+		ret = bpf_mklink(dentry, mode, raw);
+		break;
+	default:
+		ret = -EOPNOTSUPP;
+		break;
+	}
+
 	dput(dentry);
 	inode_unlock(parent->d_inode);
 	return ret;
@@ -726,8 +741,8 @@ static int populate_bpffs(struct dentry *parent)
 		goto out_put;
 	for (i = 0; i < BPF_PRELOAD_LINKS; i++) {
 		bpf_link_inc(objs[i].link);
-		err = bpf_iter_link_pin_kernel(parent,
-					       objs[i].link_name, objs[i].link);
+		err = bpf_obj_do_pin_kernel(parent, objs[i].link_name,
+					    objs[i].link, BPF_TYPE_LINK);
 		if (err) {
 			bpf_link_put(objs[i].link);
 			goto out_put;
-- 
2.32.0

