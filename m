Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D9EE637CAD
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiKXPSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:18:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiKXPSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:18:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 385AE16E8CA
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:16:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669302978;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1gSBxJ3JD+Lhw0lQsSl13cc2SNWiLM1GIUzZ7OkQbMU=;
        b=U691ylK/wZVwKQHKn+/WUaWE/P2hCyuSW6QSgXsblBHUvqYbJcVV+2YHX+6wiQ9sgBQ4lN
        MDMcVxXMFSHlQ/Wy7MpC38MYPkJdQKAs74b2iCEqeGsZGXY9UKmxOqTiMF8LQZKKhdhTzn
        lWdx4ZrhefYBgv6c8yVarOnLyvqh6fM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-9-2nluelRgODCohAjC4AFX6g-1; Thu, 24 Nov 2022 10:16:14 -0500
X-MC-Unique: 2nluelRgODCohAjC4AFX6g-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 87F903C01E03;
        Thu, 24 Nov 2022 15:16:13 +0000 (UTC)
Received: from plouf.redhat.com (unknown [10.39.193.200])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C7AEF40C2064;
        Thu, 24 Nov 2022 15:16:11 +0000 (UTC)
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [RFC hid v1 02/10] WIP: bpf: allow to pin programs from the kernel when bpffs is mounted
Date:   Thu, 24 Nov 2022 16:15:55 +0100
Message-Id: <20221124151603.807536-3-benjamin.tissoires@redhat.com>
In-Reply-To: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
References: <20221124151603.807536-1-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I want to be able to pin programs loaded by the kernel and expose them
through the bpffs so userspace knows what is loaded.

There are a few things missings in this WIP:
- locking on bpffs_sb
- ability to create a hierarchy from the kernel: I'd like to store all
  of my programs in /sys/fs/bpf/hid, not everything at the root of
  the mount
- ability to store programs when bpffs is not mounted

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
---
 include/linux/bpf.h |  1 +
 kernel/bpf/inode.c  | 41 ++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 41 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0566705c1d4e..f5a7dca520eb 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1806,6 +1806,7 @@ struct bpf_link *bpf_link_get_curr_or_next(u32 *id);
 
 int bpf_obj_pin_user(u32 ufd, const char __user *pathname);
 int bpf_obj_get_user(const char __user *pathname, int flags);
+int bpf_prog_pin_kernel(const char *name, struct bpf_prog *prog);
 
 #define BPF_ITER_FUNC_PREFIX "bpf_iter_"
 #define DEFINE_BPF_ITER_FUNC(target, args...)			\
diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 4f841e16779e..7be24ffad7f7 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -29,6 +29,9 @@ enum bpf_type {
 	BPF_TYPE_LINK,
 };
 
+
+static struct super_block *bpffs_sb;
+
 static void *bpf_any_get(void *raw, enum bpf_type type)
 {
 	switch (type) {
@@ -435,6 +438,34 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 	return ret;
 }
 
+/* pin a program in the bpffs */
+/* TODO: handle path relative to mount point instead of plain name by recreating
+ * the hierarchy, like in drivers/base/devtmpfs.c
+ */
+int bpf_prog_pin_kernel(const char *name, struct bpf_prog *prog)
+{
+	struct dentry *parent;
+	umode_t mode = S_IFREG | S_IRUSR;
+	struct dentry *dentry;
+	int ret;
+
+	if (!bpffs_sb)
+		return -ENOENT;
+
+	parent = bpffs_sb->s_root;
+
+	inode_lock(parent->d_inode);
+	dentry = lookup_one_len(name, parent, strlen(name));
+	if (IS_ERR(dentry)) {
+		inode_unlock(parent->d_inode);
+		return PTR_ERR(dentry);
+	}
+	ret = bpf_mkprog(dentry, mode, prog);
+	dput(dentry);
+	inode_unlock(parent->d_inode);
+	return ret;
+}
+
 static int bpf_obj_do_pin(const char __user *pathname, void *raw,
 			  enum bpf_type type)
 {
@@ -758,6 +789,8 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	inode->i_mode &= ~S_IALLUGO;
 	populate_bpffs(sb->s_root);
 	inode->i_mode |= S_ISVTX | opts->mode;
+
+	bpffs_sb = sb;
 	return 0;
 }
 
@@ -795,12 +828,18 @@ static int bpf_init_fs_context(struct fs_context *fc)
 	return 0;
 }
 
+static void bpf_kill_sb(struct super_block *sb)
+{
+	bpffs_sb = NULL;
+	kill_litter_super(sb);
+}
+
 static struct file_system_type bpf_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "bpf",
 	.init_fs_context = bpf_init_fs_context,
 	.parameters	= bpf_fs_parameters,
-	.kill_sb	= kill_litter_super,
+	.kill_sb	= bpf_kill_sb,
 };
 
 static int __init bpf_init(void)
-- 
2.38.1

