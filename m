Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA756387D6C
	for <lists+netdev@lfdr.de>; Tue, 18 May 2021 18:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350632AbhERQ3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 12:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350648AbhERQ33 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 12:29:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C0AB46109F;
        Tue, 18 May 2021 16:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621355289;
        bh=4zLrvE+vCu7f2a/CkEJrYYThP5aozCo8/VKyDst76eM=;
        h=From:To:Cc:Subject:Date:From;
        b=FlOxQ//H9+fiCQb/HN0gC4LrbumTMF98Kh1Gr+E2t7ye1J6sJkWMONWU9/1ZS/Zmm
         Yfr+8HuUqhxaodL+TwUsWa4VvNi/Ces2/mHbXxEkP1jhqQP/P2YpwlbLB3I2Iz/EBb
         wjKfk2+9AMWoqukdK5twj+sQg427CpcV1kAoJbAE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-wireless@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/9] b43legacy: don't save dentries for debugfs
Date:   Tue, 18 May 2021 18:28:05 +0200
Message-Id: <20210518162805.3700405-1-gregkh@linuxfoundation.org>
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

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 .../net/wireless/broadcom/b43legacy/debugfs.c | 29 ++++---------------
 .../net/wireless/broadcom/b43legacy/debugfs.h |  3 --
 2 files changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.c b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
index e7e4293c01f2..6b0e8d117061 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.c
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.c
@@ -336,24 +336,14 @@ int b43legacy_debug(struct b43legacy_wldev *dev, enum b43legacy_dyndbg feature)
 	return !!(dev->dfsentry && dev->dfsentry->dyn_debug[feature]);
 }
 
-static void b43legacy_remove_dynamic_debug(struct b43legacy_wldev *dev)
-{
-	struct b43legacy_dfsentry *e = dev->dfsentry;
-	int i;
-
-	for (i = 0; i < __B43legacy_NR_DYNDBG; i++)
-		debugfs_remove(e->dyn_debug_dentries[i]);
-}
-
 static void b43legacy_add_dynamic_debug(struct b43legacy_wldev *dev)
 {
 	struct b43legacy_dfsentry *e = dev->dfsentry;
 
 #define add_dyn_dbg(name, id, initstate) do {			\
 	e->dyn_debug[id] = (initstate);				\
-	e->dyn_debug_dentries[id] =				\
-		debugfs_create_bool(name, 0600, e->subdir,	\
-				&(e->dyn_debug[id]));		\
+	debugfs_create_bool(name, 0600, e->subdir,		\
+			    &(e->dyn_debug[id]));		\
 	} while (0)
 
 	add_dyn_dbg("debug_xmitpower", B43legacy_DBG_XMITPOWER, false);
@@ -396,11 +386,9 @@ void b43legacy_debugfs_add_device(struct b43legacy_wldev *dev)
 
 #define ADD_FILE(name, mode)	\
 	do {							\
-		e->file_##name.dentry =				\
-			debugfs_create_file(__stringify(name),	\
-					mode, e->subdir, dev,	\
-					&fops_##name.fops);	\
-		e->file_##name.dentry = NULL;			\
+		debugfs_create_file(__stringify(name), mode,	\
+				    e->subdir, dev,		\
+				    &fops_##name.fops);		\
 	} while (0)
 
 
@@ -424,13 +412,6 @@ void b43legacy_debugfs_remove_device(struct b43legacy_wldev *dev)
 	e = dev->dfsentry;
 	if (!e)
 		return;
-	b43legacy_remove_dynamic_debug(dev);
-
-	debugfs_remove(e->file_tsf.dentry);
-	debugfs_remove(e->file_ucode_regs.dentry);
-	debugfs_remove(e->file_shm.dentry);
-	debugfs_remove(e->file_txstat.dentry);
-	debugfs_remove(e->file_restart.dentry);
 
 	debugfs_remove(e->subdir);
 	kfree(e->txstatlog.log);
diff --git a/drivers/net/wireless/broadcom/b43legacy/debugfs.h b/drivers/net/wireless/broadcom/b43legacy/debugfs.h
index 7a37764406b1..924130880dfe 100644
--- a/drivers/net/wireless/broadcom/b43legacy/debugfs.h
+++ b/drivers/net/wireless/broadcom/b43legacy/debugfs.h
@@ -28,7 +28,6 @@ struct b43legacy_txstatus_log {
 };
 
 struct b43legacy_dfs_file {
-	struct dentry *dentry;
 	char *buffer;
 	size_t data_len;
 };
@@ -49,8 +48,6 @@ struct b43legacy_dfsentry {
 
 	/* Enabled/Disabled list for the dynamic debugging features. */
 	bool dyn_debug[__B43legacy_NR_DYNDBG];
-	/* Dentries for the dynamic debugging entries. */
-	struct dentry *dyn_debug_dentries[__B43legacy_NR_DYNDBG];
 };
 
 int b43legacy_debug(struct b43legacy_wldev *dev,
-- 
2.31.1

