Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 435CA387DA1
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350813AbhERQee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:34:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:36892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350830AbhERQe0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 12:34:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13465611AD;
        Tue, 18 May 2021 16:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621355587;
        bh=/fSUMPN4GK7C6MQNXxAQ0JDBgMYTWIO90Bp4KuCsoTQ=;
        h=From:To:Cc:Subject:Date:From;
        b=DDvz3PaxkIoOst5JbI8k+slOY0Ui7xZVb3itce8L12EavJ+1LnFpPjB/0VS8Kx2Up
         DsrZW4eZfRNN4FnzAz3cjVHgho6sPGxq+Zomu1DNOOpvH4DPDct+Wi7y6EgZYaGxIQ
         saD5iG3dY0tyiMARq6LtwxEa0zq5SX6usuBdlpKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-wireless@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Chao Yu <chao@kernel.org>,
        Leon Romanovsky <leon@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] b43: don't save dentries for debugfs
Date:   Tue, 18 May 2021 18:33:04 +0200
Message-Id: <20210518163304.3702015-1-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to keep around the dentry pointers for the debugfs
files as they will all be automatically removed when the subdir is
removed.  So save the space and logic involved in keeping them around by
just getting rid of them entirely.

By doing this change, we remove one of the last in-kernel user that was
storing the result of debugfs_create_bool(), so that api can be cleaned
up.

Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Chao Yu <chao@kernel.org>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/b43/debugfs.c | 34 +++------------------
 drivers/net/wireless/broadcom/b43/debugfs.h |  3 --
 2 files changed, 5 insertions(+), 32 deletions(-)

Note, I can take this through my debugfs tree if wanted, that way I can
clean up the debugfs_create_bool() api at the same time.  Otherwise it's
fine, I can wait until next -rc1 for that to happen.

v2: remove X/N from subject, it is a stand-alone patch.


diff --git a/drivers/net/wireless/broadcom/b43/debugfs.c b/drivers/net/wireless/broadcom/b43/debugfs.c
index 89a25aefb327..efa98444e3fb 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43/debugfs.c
@@ -643,24 +643,14 @@ bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature)
 	return enabled;
 }
 
-static void b43_remove_dynamic_debug(struct b43_wldev *dev)
-{
-	struct b43_dfsentry *e = dev->dfsentry;
-	int i;
-
-	for (i = 0; i < __B43_NR_DYNDBG; i++)
-		debugfs_remove(e->dyn_debug_dentries[i]);
-}
-
 static void b43_add_dynamic_debug(struct b43_wldev *dev)
 {
 	struct b43_dfsentry *e = dev->dfsentry;
 
 #define add_dyn_dbg(name, id, initstate) do {			\
 	e->dyn_debug[id] = (initstate);				\
-	e->dyn_debug_dentries[id] =				\
-		debugfs_create_bool(name, 0600, e->subdir,	\
-				&(e->dyn_debug[id]));		\
+	debugfs_create_bool(name, 0600, e->subdir,		\
+			    &(e->dyn_debug[id]));		\
 	} while (0)
 
 	add_dyn_dbg("debug_xmitpower", B43_DBG_XMITPOWER, false);
@@ -713,10 +703,9 @@ void b43_debugfs_add_device(struct b43_wldev *dev)
 
 #define ADD_FILE(name, mode)	\
 	do {							\
-		e->file_##name.dentry =				\
-			debugfs_create_file(__stringify(name),	\
-					mode, e->subdir, dev,	\
-					&fops_##name.fops);	\
+		debugfs_create_file(__stringify(name),		\
+				mode, e->subdir, dev,		\
+				&fops_##name.fops);		\
 	} while (0)
 
 
@@ -746,19 +735,6 @@ void b43_debugfs_remove_device(struct b43_wldev *dev)
 	e = dev->dfsentry;
 	if (!e)
 		return;
-	b43_remove_dynamic_debug(dev);
-
-	debugfs_remove(e->file_shm16read.dentry);
-	debugfs_remove(e->file_shm16write.dentry);
-	debugfs_remove(e->file_shm32read.dentry);
-	debugfs_remove(e->file_shm32write.dentry);
-	debugfs_remove(e->file_mmio16read.dentry);
-	debugfs_remove(e->file_mmio16write.dentry);
-	debugfs_remove(e->file_mmio32read.dentry);
-	debugfs_remove(e->file_mmio32write.dentry);
-	debugfs_remove(e->file_txstat.dentry);
-	debugfs_remove(e->file_restart.dentry);
-	debugfs_remove(e->file_loctls.dentry);
 
 	debugfs_remove(e->subdir);
 	kfree(e->txstatlog.log);
diff --git a/drivers/net/wireless/broadcom/b43/debugfs.h b/drivers/net/wireless/broadcom/b43/debugfs.h
index 0bf437c86c67..6f6b500b8881 100644
--- a/drivers/net/wireless/broadcom/b43/debugfs.h
+++ b/drivers/net/wireless/broadcom/b43/debugfs.h
@@ -32,7 +32,6 @@ struct b43_txstatus_log {
 };
 
 struct b43_dfs_file {
-	struct dentry *dentry;
 	char *buffer;
 	size_t data_len;
 };
@@ -70,8 +69,6 @@ struct b43_dfsentry {
 
 	/* Enabled/Disabled list for the dynamic debugging features. */
 	bool dyn_debug[__B43_NR_DYNDBG];
-	/* Dentries for the dynamic debugging entries. */
-	struct dentry *dyn_debug_dentries[__B43_NR_DYNDBG];
 };
 
 bool b43_debug(struct b43_wldev *dev, enum b43_dyndbg feature);
-- 
2.31.1

