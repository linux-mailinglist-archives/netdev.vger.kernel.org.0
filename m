Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715E33E136C
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 13:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240676AbhHELGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 07:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240478AbhHELGA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 07:06:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B85A5610A2;
        Thu,  5 Aug 2021 11:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628161546;
        bh=6r3dbKDvyT5cZqmYK6vc77hmBJKzLoB7xhGJx7/6m1w=;
        h=From:To:Cc:Subject:Date:From;
        b=uEsBX1TKdfuwokOl8iYcfq+ccV+McYDjTnEbVau1ncWJoxR1AVlPJk3qrg2btDzsy
         NBXOWciskx5rz8HCmiqflpSRoleqdP5ayyET19x11eTtzmR66Tcg5VjXsRf4ZPr0Vp
         bK666yoMxRZHgttISiaubkaoIv/qA4IicTLz3zh1fX0POrUl0oHbdJwJYmqINbRJD8
         dmtsH58fZ0FBfybg33zh0FM0dd1HheVEzcxdtrHrrNGPPF3iHrbiNC8NYuDaVHb5AP
         S1gkfIMQsO2jri4SWKah0q86425BkfOxy9IaxZIPUHtBIqyXXH9cIk3UrFWSZ/MIYO
         tqVM/GkjWY0Ow==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH net-next v1] netdevsim: Forbid devlink reload when adding or deleting ports
Date:   Thu,  5 Aug 2021 14:05:41 +0300
Message-Id: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In order to remove complexity in devlink core related to
devlink_reload_enable/disable, let's rewrite new_port/del_port
logic to rely on internal to netdevsim lock.

We should protect only reload_down flow because it destroys nsim_dev,
which is needed for nsim_dev_port_add/nsim_dev_port_del to hold
port_list_lock.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
Changelog:
 v1:
 * fixed typo in the commit message
 v0: https://lore.kernel.org/netdev/53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com/T/#u
---
 drivers/net/netdevsim/bus.c | 16 ++++------------
 drivers/net/netdevsim/dev.c |  7 +++++++
 2 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
index ff01e5bdc72e..a29ec264119d 100644
--- a/drivers/net/netdevsim/bus.c
+++ b/drivers/net/netdevsim/bus.c
@@ -183,8 +183,6 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
-	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
-	struct devlink *devlink;
 	unsigned int port_index;
 	int ret;
 
@@ -195,12 +193,10 @@ new_port_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	devlink = priv_to_devlink(nsim_dev);
+	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
+		return -EBUSY;
 
-	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
-	devlink_reload_disable(devlink);
 	ret = nsim_dev_port_add(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
-	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
@@ -212,8 +208,6 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	       const char *buf, size_t count)
 {
 	struct nsim_bus_dev *nsim_bus_dev = to_nsim_bus_dev(dev);
-	struct nsim_dev *nsim_dev = dev_get_drvdata(dev);
-	struct devlink *devlink;
 	unsigned int port_index;
 	int ret;
 
@@ -224,12 +218,10 @@ del_port_store(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	devlink = priv_to_devlink(nsim_dev);
+	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
+		return -EBUSY;
 
-	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
-	devlink_reload_disable(devlink);
 	ret = nsim_dev_port_del(nsim_bus_dev, NSIM_DEV_PORT_TYPE_PF, port_index);
-	devlink_reload_enable(devlink);
 	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return ret ? ret : count;
 }
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index d538a39d4225..ff5714209b86 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -864,16 +864,23 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
 				struct netlink_ext_ack *extack)
 {
 	struct nsim_dev *nsim_dev = devlink_priv(devlink);
+	struct nsim_bus_dev *nsim_bus_dev;
+
+	nsim_bus_dev = nsim_dev->nsim_bus_dev;
+	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
+		return -EOPNOTSUPP;
 
 	if (nsim_dev->dont_allow_reload) {
 		/* For testing purposes, user set debugfs dont_allow_reload
 		 * value to true. So forbid it.
 		 */
 		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for testing purposes");
+		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 		return -EOPNOTSUPP;
 	}
 
 	nsim_dev_reload_destroy(nsim_dev);
+	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
 	return 0;
 }
 
-- 
2.31.1

