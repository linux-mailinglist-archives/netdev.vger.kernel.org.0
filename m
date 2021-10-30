Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBAD44072C
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 06:06:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhJ3EIt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 00:08:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229766AbhJ3EIs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Oct 2021 00:08:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CCDE61165;
        Sat, 30 Oct 2021 04:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635566778;
        bh=vQxhoBqSAxKqyJOK414XKH+86KsjEZ7nS/uHI2BAWLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSVeDxU5JblOx44Q74D9bM6HLnrzQTne4XdN/WKXKM6dkVGixpionCon5bj3cnf6m
         aQP8dFZNP889UEGLCeW29gWLYij6BcNZ/BFnv0JHkh0YHaQRfTVLmAbwxBhhF7Ku/A
         xOJFUT+5nyI1qbeFbMUhD7kvWt9OSGcZ2iLT3CDsC2RroKFyj8Gn9eGDyQYGvOWujP
         v2Sn58PUKyGURXmiQG72AgKP4gY/ULC8k6mwH5zLuMNIptGdK5rHgELVl7AvtBWXBu
         2otHUklk4fgZbvy5/Cw6xu3AbTWGRRBRbXdbb6+fb167TIV+LM3NVI6C2kcxtJkMd0
         qn8miV9idPeYw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jiri@resnulli.us, leon@kernel.org,
        mkubecek@suse.cz, andrew@lunn.ch, f.fainelli@gmail.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 2/4] ethtool: handle info/flash data copying outside rtnl_lock
Date:   Fri, 29 Oct 2021 21:06:09 -0700
Message-Id: <20211030040611.1751638-3-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211030040611.1751638-1-kuba@kernel.org>
References: <20211030040611.1751638-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We need to increase the lifetime of the data for .get_info
and .flash_update beyond their handlers inside rtnl_lock.

Allocate a union on the heap and use it instead.

Note that we now copy the ethcmd before we lookup dev,
hopefully there is no crazy user space depending on error
codes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/ethtool/ioctl.c | 110 +++++++++++++++++++++++++++-----------------
 1 file changed, 69 insertions(+), 41 deletions(-)

diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 52bfc5b82ec3..1980e37b6472 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -32,6 +32,14 @@
 #include <generated/utsrelease.h>
 #include "common.h"
 
+/* State held across locks and calls for commands which have devlink fallback */
+struct ethtool_devlink_compat {
+	union {
+		struct ethtool_flash efl;
+		struct ethtool_drvinfo info;
+	};
+};
+
 /*
  * Some useful ethtool_ops methods that're device independent.
  * If we find that all drivers want to do the same thing here,
@@ -697,22 +705,20 @@ static int ethtool_set_settings(struct net_device *dev, void __user *useraddr)
 	return ret;
 }
 
-static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
-						  void __user *useraddr)
+static int
+ethtool_get_drvinfo(struct net_device *dev, struct ethtool_devlink_compat *rsp)
 {
-	struct ethtool_drvinfo info;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 
-	memset(&info, 0, sizeof(info));
-	info.cmd = ETHTOOL_GDRVINFO;
-	strlcpy(info.version, UTS_RELEASE, sizeof(info.version));
+	rsp->info.cmd = ETHTOOL_GDRVINFO;
+	strlcpy(rsp->info.version, UTS_RELEASE, sizeof(rsp->info.version));
 	if (ops->get_drvinfo) {
-		ops->get_drvinfo(dev, &info);
+		ops->get_drvinfo(dev, &rsp->info);
 	} else if (dev->dev.parent && dev->dev.parent->driver) {
-		strlcpy(info.bus_info, dev_name(dev->dev.parent),
-			sizeof(info.bus_info));
-		strlcpy(info.driver, dev->dev.parent->driver->name,
-			sizeof(info.driver));
+		strlcpy(rsp->info.bus_info, dev_name(dev->dev.parent),
+			sizeof(rsp->info.bus_info));
+		strlcpy(rsp->info.driver, dev->dev.parent->driver->name,
+			sizeof(rsp->info.driver));
 	} else {
 		return -EOPNOTSUPP;
 	}
@@ -726,30 +732,27 @@ static noinline_for_stack int ethtool_get_drvinfo(struct net_device *dev,
 
 		rc = ops->get_sset_count(dev, ETH_SS_TEST);
 		if (rc >= 0)
-			info.testinfo_len = rc;
+			rsp->info.testinfo_len = rc;
 		rc = ops->get_sset_count(dev, ETH_SS_STATS);
 		if (rc >= 0)
-			info.n_stats = rc;
+			rsp->info.n_stats = rc;
 		rc = ops->get_sset_count(dev, ETH_SS_PRIV_FLAGS);
 		if (rc >= 0)
-			info.n_priv_flags = rc;
+			rsp->info.n_priv_flags = rc;
 	}
 	if (ops->get_regs_len) {
 		int ret = ops->get_regs_len(dev);
 
 		if (ret > 0)
-			info.regdump_len = ret;
+			rsp->info.regdump_len = ret;
 	}
 
 	if (ops->get_eeprom_len)
-		info.eedump_len = ops->get_eeprom_len(dev);
-
-	if (!info.fw_version[0])
-		devlink_compat_running_version(dev, info.fw_version,
-					       sizeof(info.fw_version));
+		rsp->info.eedump_len = ops->get_eeprom_len(dev);
 
-	if (copy_to_user(useraddr, &info, sizeof(info)))
-		return -EFAULT;
+	if (!rsp->info.fw_version[0])
+		devlink_compat_running_version(dev, rsp->info.fw_version,
+					       sizeof(rsp->info.fw_version));
 	return 0;
 }
 
@@ -2178,19 +2181,13 @@ static int ethtool_set_value(struct net_device *dev, char __user *useraddr,
 	return actor(dev, edata.data);
 }
 
-static noinline_for_stack int ethtool_flash_device(struct net_device *dev,
-						   char __user *useraddr)
+static int
+ethtool_flash_device(struct net_device *dev, struct ethtool_devlink_compat *req)
 {
-	struct ethtool_flash efl;
-
-	if (copy_from_user(&efl, useraddr, sizeof(efl)))
-		return -EFAULT;
-	efl.data[ETHTOOL_FLASH_MAX_FILENAME - 1] = 0;
-
 	if (!dev->ethtool_ops->flash_device)
-		return devlink_compat_flash_update(dev, efl.data);
+		return devlink_compat_flash_update(dev, req->efl.data);
 
-	return dev->ethtool_ops->flash_device(dev, &efl);
+	return dev->ethtool_ops->flash_device(dev, &req->efl);
 }
 
 static int ethtool_set_dump(struct net_device *dev,
@@ -2701,19 +2698,18 @@ static int ethtool_set_fecparam(struct net_device *dev, void __user *useraddr)
 /* The main entry point in this file.  Called from net/core/dev_ioctl.c */
 
 static int
-__dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
+__dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr,
+	      u32 ethcmd, struct ethtool_devlink_compat *devlink_state)
 {
-	struct net_device *dev = __dev_get_by_name(net, ifr->ifr_name);
-	u32 ethcmd, sub_cmd;
+	struct net_device *dev;
+	u32 sub_cmd;
 	int rc;
 	netdev_features_t old_features;
 
+	dev = __dev_get_by_name(net, ifr->ifr_name);
 	if (!dev)
 		return -ENODEV;
 
-	if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
-		return -EFAULT;
-
 	if (ethcmd == ETHTOOL_PERQUEUE) {
 		if (copy_from_user(&sub_cmd, useraddr + sizeof(ethcmd), sizeof(sub_cmd)))
 			return -EFAULT;
@@ -2787,7 +2783,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 		rc = ethtool_set_settings(dev, useraddr);
 		break;
 	case ETHTOOL_GDRVINFO:
-		rc = ethtool_get_drvinfo(dev, useraddr);
+		rc = ethtool_get_drvinfo(dev, devlink_state);
 		break;
 	case ETHTOOL_GREGS:
 		rc = ethtool_get_regs(dev, useraddr);
@@ -2889,7 +2885,7 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 		rc = ethtool_set_rxnfc(dev, ethcmd, useraddr);
 		break;
 	case ETHTOOL_FLASHDEV:
-		rc = ethtool_flash_device(dev, useraddr);
+		rc = ethtool_flash_device(dev, devlink_state);
 		break;
 	case ETHTOOL_RESET:
 		rc = ethtool_reset(dev, useraddr);
@@ -3003,12 +2999,44 @@ __dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 
 int dev_ethtool(struct net *net, struct ifreq *ifr, void __user *useraddr)
 {
+	struct ethtool_devlink_compat *state;
+	u32 ethcmd;
 	int rc;
 
+	if (copy_from_user(&ethcmd, useraddr, sizeof(ethcmd)))
+		return -EFAULT;
+
+	state = kzalloc(sizeof(*state), GFP_KERNEL);
+	if (!state)
+		return -ENOMEM;
+
+	switch (ethcmd) {
+	case ETHTOOL_FLASHDEV:
+		if (copy_from_user(&state->efl, useraddr, sizeof(state->efl))) {
+			rc = -EFAULT;
+			goto exit_free;
+		}
+		state->efl.data[ETHTOOL_FLASH_MAX_FILENAME - 1] = 0;
+		break;
+	}
+
 	rtnl_lock();
-	rc = __dev_ethtool(net, ifr, useraddr);
+	rc = __dev_ethtool(net, ifr, useraddr, ethcmd, state);
 	rtnl_unlock();
+	if (rc)
+		goto exit_free;
+
+	switch (ethcmd) {
+	case ETHTOOL_GDRVINFO:
+		if (copy_to_user(useraddr, &state->info, sizeof(state->info))) {
+			rc = -EFAULT;
+			goto exit_free;
+		}
+		break;
+	}
 
+exit_free:
+	kfree(state);
 	return rc;
 }
 
-- 
2.31.1

