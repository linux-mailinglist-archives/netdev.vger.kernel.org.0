Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 645D1440B9D
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 22:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbhJ3UXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 16:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230338AbhJ3UXg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 16:23:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92CA460F4C;
        Sat, 30 Oct 2021 20:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635625265;
        bh=xmO0M28RluItCTYskEYW/9cgDS1g/C2qVeETTSyk77o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNnOudAKwOBkTuo7zWHnQENESpXEQsBtCmbJPmjSbs959moU4Pg5CecW7LCrBh9aq
         CAraM6tO1eU1gYnAp0lTxHxZ70B7zQWRsdzZ034JInltiSi1pbZLgW1FGmxpPdsPod
         cWKGaMjQJtTxdV9okCEAy6FzUiuamFnbDoiBzvm6gpSMR31qiOvu79TP8FyKNLvjKS
         pozDTeIvH+S7WRDsU4rhkqqYaiTOKaxOGJIRzJJ9JbeAqSWzZlAGUISsKDdXiltM58
         XC87JKG8SdS6yNnft8rbVnrjA4696uINPvUp60YBEu4kOcWrsDTuU/Ap4h+2nrACsl
         kYy6v8w39q+Yg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/5] netdevsim: take rtnl_lock when assigning num_vfs
Date:   Sat, 30 Oct 2021 13:20:58 -0700
Message-Id: <20211030202102.2157622-2-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030202102.2157622-1-kuba@kernel.org>
References: <20211030202102.2157622-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Legacy VF NDOs look at num_vfs and then based on that
index into vfconfig. If we don't rtnl_lock() num_vfs
may get set to 0 and vfconfig freed/replaced while
the NDO is running.

We don't need to protect replacing vfconfig since it's
only done when num_vfs is 0.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/netdevsim/bus.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index 29f5627d11e6..284223108d25 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -24,6 +24,14 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct device *dev)
 	return container_of(dev, struct nsim_bus_dev, dev);
 }
 
+static void
+nsim_bus_dev_set_vfs(struct nsim_bus_dev *nsim_bus_dev, unsigned int num_vfs)
+{
+	rtnl_lock();
+	nsim_bus_dev->num_vfs = num_vfs;
+	rtnl_unlock();
+}
+
 static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 				   unsigned int num_vfs)
 {
@@ -35,13 +43,13 @@ static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev *nsim_bus_dev,
 
 	if (!nsim_bus_dev->vfconfigs)
 		return -ENOMEM;
-	nsim_bus_dev->num_vfs = num_vfs;
+	nsim_bus_dev_set_vfs(nsim_bus_dev, num_vfs);
 
 	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	if (nsim_esw_mode_is_switchdev(nsim_dev)) {
 		err = nsim_esw_switchdev_enable(nsim_dev, NULL);
 		if (err)
-			nsim_bus_dev->num_vfs = 0;
+			nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
 	}
 
 	return err;
@@ -51,7 +59,7 @@ void nsim_bus_dev_vfs_disable(struct nsim_bus_dev *nsim_bus_dev)
 {
 	struct nsim_dev *nsim_dev;
 
-	nsim_bus_dev->num_vfs = 0;
+	nsim_bus_dev_set_vfs(nsim_bus_dev, 0);
 	nsim_dev = dev_get_drvdata(&nsim_bus_dev->dev);
 	if (nsim_esw_mode_is_switchdev(nsim_dev))
 		nsim_esw_legacy_enable(nsim_dev, NULL);
-- 
2.31.1

