Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4993E170C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbhHEOes (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:34:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240990AbhHEOer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:34:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE03A61151;
        Thu,  5 Aug 2021 14:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628174073;
        bh=U1Y4Yp68ZDPUrh/nwHryXNZUiXlUYB4FPuNRMKgI1XY=;
        h=From:To:Cc:Subject:Date:From;
        b=Y+eu9cxSboSTokICrK77piatZ/iVv8zlsB2zPWfCZbnOsDYcpj4Wm7xpmarsDwtfU
         UD/MKjbyxo0mpwqdGkSrcn93mDqlce1rppmXDiqJNytS8oAFKmoa6HkgvJRlJ9mMMw
         8yUkCKrpipL7nSkceWAkWSMIcThyIsPydrwZf03hqDiaF0sSd96S4rGPfstpVzM34J
         qKrBFY8yaldpHxbaXx/VUN8H91V38Z5s8/Vx3bD9qK9pPQ4kBt3d93icVqcCcWCmXF
         6LpCBXun5KrZp9+47+kJAEOeBgpdX+kNMDlqtcelsIFCjr1nEOEc/2rjO8y0S69qHn
         axRAg9iI+Wm3w==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next] netdevsim: Protect both reload_down and reload_up paths
Date:   Thu,  5 Aug 2021 17:34:28 +0300
Message-Id: <bf73a78a5074d1c5bcc787e586b7d6dd8dee2d10.1628174048.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Don't progress with adding and deleting ports as long as devlink
reload is running.

Fixes: 23809a726c0d ("netdevsim: Forbid devlink reload when adding or deleting ports")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/net/netdevsim/bus.c       | 10 ++++++++++
 drivers/net/netdevsim/dev.c       | 12 +++++++++++-
 drivers/net/netdevsim/netdevsim.h |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index a29ec264119d..62d033a1a557 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -196,6 +196,11 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
 		return -EBUSY;
 
+	if (nsim_bus_dev->in_reload) {
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+		return -EBUSY;
+	}
+
 	ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
@@ -221,6 +226,11 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
 		return -EBUSY;
 
+	if (nsim_bus_dev->in_reload) {
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+		return -EBUSY;
+	}
+
 	ret = nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index ff5714209b86..53068e184c90 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -878,6 +878,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EOPNOTSUPP;
 	}
+	nsim_bus_dev->in_reload = true;
 
 	nsim_dev_reload_destroy(nsim_dev);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
@@ -889,17 +890,26 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
 			      struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_bus_dev *nsim_bus_dev;
+	int ret;
+
+	nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
+	nsim_bus_dev->in_reload = false;
 
 	if (nsim_dev->fail_reload) {
 		/* For testing purposes, user set debugfs fail_reload
 		 * value to true. Fail right away.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EINVAL;
 	}
 
 	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
-	return nsim_dev_reload_create(nsim_dev, extack);
+	ret = nsim_dev_reload_create(nsim_dev, extack);
+	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
+	return ret;
 }
 
 static int nsim_dev_info_get(struct devlink *devlink,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 1c20bcbd9d91..793c86dc5a9c 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -362,6 +362,7 @@ struct nsim_bus_dev {
 	struct nsim_vf_config *vfconfigs;
 	/* Lock for devlink->reload_enabled in netdevsim module */
 	struct mutex nsim_bus_reload_lock;
+	bool in_reload;
 	bool init;
 };
 
-- 
2.31.1

