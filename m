Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200E1440A87
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhJ3RVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 13:21:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230188AbhJ3RVZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 13:21:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 86E5361054;
        Sat, 30 Oct 2021 17:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635614334;
        bh=nmu0gNN8JJDUIp8bVbDpZfefVuHnNU4He4OhPCSNB+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VejJovEQtfp+te9qmUEvc06MLt1jBkB1J80HH8UpT2pQfiNQe8pgAyd4CTT/3U4Iv
         YOZWXUadl9Wiy5t4M/bAW0y4YOK6cFRvnD95BP56dJ8L0I4UaEXIzSPuEyI8+9aNFU
         McBPgbGjfsrPHWwJ8f3ZkhHndXaUJTAYoI5IEjWnXshD+Im4WdxCD32VFkC85xD69N
         Pz2jppdHuYzCKdBIb73OEVTobZBV0cpUQdtG0KE9xdNqxlXK/xfbxZp9jyvUIyqP5F
         WuhWjPQJ3y/p502sF55bF6Eyac7RApugfeDZ7n4+yuHR9BAsPKxTwnVobBucW/wZ9Q
         jK0GFewIyrX0A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leon@kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 4/4] ethtool: don't drop the rtnl_lock half way thru the ioctl
Date:   Sat, 30 Oct 2021 10:18:51 -0700
Message-Id: <20211030171851.1822583-5-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030171851.1822583-1-kuba@kernel.org>
References: <20211030171851.1822583-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

devlink compat code needs to drop rtnl_lock to take
devlink->lock to ensure correct lock ordering.

This is problematic because we're not strictly guaranteed
that the netdev will not disappear after we re-lock.
It may open a possibility of nested ->begin / ->complete
calls.

Instead of calling into devlink under rtnl_lock take
a ref on the devlink instance and make the call after
we've dropped rtnl_lock.

We (continue to) assume that netdevs have an implicit
reference on the devlink returned from ndo_get_devlink_port

Note that ndo_get_devlink_port will now get called
under rtnl_lock. That should be fine since none of
the drivers seem to be taking serious locks inside
ndo_get_devlink_port.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/net/devlink.h |  8 ++++----
 net/core/devlink.c    | 45 +++++++------------------------------------
 net/ethtool/ioctl.c   | 36 ++++++++++++++++++++++++++++++----
 3 files changed, 43 insertions(+), 46 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 991ce48f77ca..aab3d007c577 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1729,9 +1729,9 @@ devlink_trap_policers_unregister(struct devlink *devlink,
 struct devlink *__must_check devlink_try_get(struct devlink *devlink);
 void devlink_put(struct devlink *devlink);
 
-void devlink_compat_running_version(struct net_device *dev,
+void devlink_compat_running_version(struct devlink *devlink,
 				    char *buf, size_t len);
-int devlink_compat_flash_update(struct net_device *dev, const char *file_name);
+int devlink_compat_flash_update(struct devlink *devlink, const char *file_name);
 int devlink_compat_phys_port_name_get(struct net_device *dev,
 				      char *name, size_t len);
 int devlink_compat_switch_id_get(struct net_device *dev,
@@ -1749,12 +1749,12 @@ static inline void devlink_put(struct devlink *devlink)
 }
 
 static inline void
-devlink_compat_running_version(struct net_device *dev, char *buf, size_t len)
+devlink_compat_running_version(struct devlink *devlink, char *buf, size_t len)
 {
 }
 
 static inline int
-devlink_compat_flash_update(struct net_device *dev, const char *file_name)
+devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 100d87fd3f65..6b5ee862429e 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -11283,55 +11283,28 @@ static struct devlink_port *netdev_to_devlink_port(struct net_device *dev)
 	return dev->netdev_ops->ndo_get_devlink_port(dev);
 }
 
-static struct devlink *netdev_to_devlink(struct net_device *dev)
-{
-	struct devlink_port *devlink_port = netdev_to_devlink_port(dev);
-
-	if (!devlink_port)
-		return NULL;
-
-	return devlink_port->devlink;
-}
-
-void devlink_compat_running_version(struct net_device *dev,
+void devlink_compat_running_version(struct devlink *devlink,
 				    char *buf, size_t len)
 {
-	struct devlink *devlink;
-
-	dev_hold(dev);
-	rtnl_unlock();
-
-	devlink = netdev_to_devlink(dev);
-	if (!devlink || !devlink->ops->info_get)
-		goto out;
+	if (!devlink->ops->info_get)
+		return;
 
 	mutex_lock(&devlink->lock);
 	__devlink_compat_running_version(devlink, buf, len);
 	mutex_unlock(&devlink->lock);
-
-out:
-	rtnl_lock();
-	dev_put(dev);
 }
 
-int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
+int devlink_compat_flash_update(struct devlink *devlink, const char *file_name)
 {
 	struct devlink_flash_update_params params = {};
-	struct devlink *devlink;
 	int ret;
 
-	dev_hold(dev);
-	rtnl_unlock();
-
-	devlink = netdev_to_devlink(dev);
-	if (!devlink || !devlink->ops->flash_update) {
-		ret = -EOPNOTSUPP;
-		goto out;
-	}
+	if (!devlink->ops->flash_update)
+		return -EOPNOTSUPP;
 
 	ret = request_firmware(&params.fw, file_name, devlink->dev);
 	if (ret)
-		goto out;
+		return ret;
 
 	mutex_lock(&devlink->lock);
 	devlink_flash_update_begin_notify(devlink);
@@ -11341,10 +11314,6 @@ int devlink_compat_flash_update(struct net_device *dev, const char *file_name)
 
 	release_firmware(params.fw);
 
-out:
-	rtnl_lock();
-	dev_put(dev);
-
 	return ret;
 }
 
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 1980e37b6472..65e9bc1058b5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -34,12 +34,27 @@
 
 /* State held across locks and calls for commands which have devlink fallback */
 struct ethtool_devlink_compat {
+	struct devlink *devlink;
 	union {
 		struct ethtool_flash efl;
 		struct ethtool_drvinfo info;
 	};
 };
 
+static struct devlink *netdev_to_devlink_get(struct net_device *dev)
+{
+	struct devlink_port *devlink_port;
+
+	if (!dev->netdev_ops->ndo_get_devlink_port)
+		return NULL;
+
+	devlink_port = dev->netdev_ops->ndo_get_devlink_port(dev);
+	if (!devlink_port)
+		return NULL;
+
+	return devlink_try_get(devlink_port->devlink);
+}
+
 /*
  * Some useful ethtool_ops methods that're device independent.
  * If we find that all drivers want to do the same thing here,
@@ -751,8 +766,8 @@ ethtool_get_drvinfo(struct net_device *dev, struct ethtool_devlink_compat *rsp)
 		rsp->info.eedump_len = ops->get_eeprom_len(dev);
 
 	if (!rsp->info.fw_version[0])
-		devlink_compat_running_version(dev, rsp->info.fw_version,
-					       sizeof(rsp->info.fw_version));
+		rsp->devlink = netdev_to_devlink_get(dev);
+
 	return 0;
 }
 
@@ -2184,8 +2199,10 @@ static int ethtool_set_value(struct net_device *dev, char __user *useraddr,
 static int
 ethtool_flash_device(struct net_device *dev, struct ethtool_devlink_compat *req)
 {
-	if (!dev->ethtool_ops->flash_device)
-		return devlink_compat_flash_update(dev, req->efl.data);
+	if (!dev->ethtool_ops->flash_device) {
+		req->devlink = netdev_to_devlink_get(dev);
+		return 0;
+	}
 
 	return dev->ethtool_ops->flash_device(dev, &req->efl);
 }
@@ -3027,7 +3044,16 @@ int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 		goto exit_free;
 
 	switch (ethcmd) {
+	case ETHTOOL_FLASHDEV:
+		if (state->devlink)
+			rc = devlink_compat_flash_update(state->devlink,
+							 state->efl.data);
+		break;
 	case ETHTOOL_GDRVINFO:
+		if (state->devlink)
+			devlink_compat_running_version(state->devlink,
+						       state->info.fw_version,
+						       sizeof(state->info.fw_version));
 		if (copy_to_user(useraddr, &state->info, sizeof(state->info))) {
 			rc = -EFAULT;
 			goto exit_free;
@@ -3036,6 +3062,8 @@ int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 	}
 
 exit_free:
+	if (state->devlink)
+		devlink_put(state->devlink);
 	kfree(state);
 	return rc;
 }
-- 
2.31.1

