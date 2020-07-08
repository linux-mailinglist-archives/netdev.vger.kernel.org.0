Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3CB218D6D
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730759AbgGHQr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:47:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730697AbgGHQrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:47:13 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1ADBC061A0B;
        Wed,  8 Jul 2020 09:47:12 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x11so18405522plo.7;
        Wed, 08 Jul 2020 09:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=szvXhftN68cWeewyScTKoiCjjS6X/v2Foh6Cqx+cXIY=;
        b=t8Hujyqx3UV/YjaqYWcam4arwJFJsu/iVKmo8us5fcqN3lIUti2Kz+z/SLF3Z+HdaU
         QeEmBMdadfCTW29oQmdW6SksI9wuA2XDq7RORfsQw+0RJzOc+7GWjGAhMTHFHjedQsOy
         UkYjuOITLAVy1Z5avsWwxXGRe020gPRqPKB+ZRHcXYfP4cBlBmWNwsxVDX8k2JCb7MNB
         Mc1aQnVrhMluxVEE9SY3W2NgBdCHgdOihJJ+B+F+oHI503h+JQvzkmhx9ucj2fsBem96
         ZFbLCW3glYywV5I1uc4diGN2+rGsyMZ71tZMlBOSHO6mTt3b+ArFuZkzmpQfZEYb4Zl0
         bGFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=szvXhftN68cWeewyScTKoiCjjS6X/v2Foh6Cqx+cXIY=;
        b=PbQnQAwjXDVE9uHp/X9YTsvicyklEnSyEKkiqgECj/lZtmKAM+8miKhrsOSwcAKavl
         Koj16fAgxjBysU8IpAahbwT0XeYb5cIkR354Zmi9DLk+HhcNEqQbhP0wHEpO93+y6/dd
         a8TaMZyATvuoTYrNSJxoYkN0PTKSnbCaDVfel7YReH8Q8IK3/LdHDbp5NnRy46/Ifl+F
         u7lR5Li6sP2Ixow7vu2SAOb7r+QrMmRx/zuUuMEGXrjU8Q+Vfv5i3kAIG6hkYou6Nzv5
         YYcX7LPdPiiMA4t6Gp0S68BWW7CHSfMHnGrJUMJz8WSZxF2T9Af6HPgvdvwQAwlUBh5W
         BZPA==
X-Gm-Message-State: AOAM532idumEHjSk7OO8SenHUmTEzCUoNnM7evPcf/sMY1QTIj8zdT5e
        +gJb22DoW1xmMBzhQA8Euv4DfpLU
X-Google-Smtp-Source: ABdhPJxEpD7ot+X1wXejXw7PR2zHWWtns/a/g85LEZzJOU4PSbBGE8/LuNhROPCjZ89kq94bX/Kh8w==
X-Received: by 2002:a17:90a:80c3:: with SMTP id k3mr10339176pjw.102.1594226832018;
        Wed, 08 Jul 2020 09:47:12 -0700 (PDT)
Received: from localhost.localdomain (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x22sm356247pfr.11.2020.07.08.09.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 09:47:11 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 2/2] net: phy: Uninline PHY ethtool statistics operations
Date:   Wed,  8 Jul 2020 09:46:25 -0700
Message-Id: <20200708164625.40180-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708164625.40180-1-f.fainelli@gmail.com>
References: <20200708164625.40180-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have moved the PHY ethtool statistics to be dynamically
registered, we no longer need to inline those for ethtool. This used to
be done to avoid cross symbol referencing and allow ethtool to be
decoupled from PHYLIB entirely.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/phy.c | 48 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/phy.h   | 49 ++++---------------------------------------
 net/ethtool/ioctl.c   | 23 +++++++++++++-------
 net/ethtool/strset.c  | 11 ++++++----
 4 files changed, 74 insertions(+), 57 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 56cfae950472..79b4f35d151e 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -489,6 +489,54 @@ static void phy_abort_cable_test(struct phy_device *phydev)
 		phydev_err(phydev, "Error while aborting cable test");
 }
 
+int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	mutex_lock(&phydev->lock);
+	phydev->drv->get_strings(phydev, data);
+	mutex_unlock(&phydev->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_ethtool_get_strings);
+
+int phy_ethtool_get_sset_count(struct phy_device *phydev)
+{
+	int ret;
+
+	if (!phydev->drv)
+		return -EIO;
+
+	if (phydev->drv->get_sset_count &&
+	    phydev->drv->get_strings &&
+	    phydev->drv->get_stats) {
+		mutex_lock(&phydev->lock);
+		ret = phydev->drv->get_sset_count(phydev);
+		mutex_unlock(&phydev->lock);
+
+		return ret;
+	}
+
+	return -EOPNOTSUPP;
+}
+EXPORT_SYMBOL(phy_ethtool_get_sset_count);
+
+int phy_ethtool_get_stats(struct phy_device *phydev,
+			  struct ethtool_stats *stats, u64 *data)
+{
+	if (!phydev->drv)
+		return -EIO;
+
+	mutex_lock(&phydev->lock);
+	phydev->drv->get_stats(phydev, stats, data);
+	mutex_unlock(&phydev->lock);
+
+	return 0;
+}
+EXPORT_SYMBOL(phy_ethtool_get_stats);
+
 int phy_start_cable_test(struct phy_device *phydev,
 			 struct netlink_ext_ack *extack)
 {
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 1592c3d0e12f..0403eb799913 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1474,51 +1474,10 @@ int __init mdio_bus_init(void);
 void mdio_bus_exit(void);
 #endif
 
-/* Inline function for use within net/core/ethtool.c (built-in) */
-static inline int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data)
-{
-	if (!phydev->drv)
-		return -EIO;
-
-	mutex_lock(&phydev->lock);
-	phydev->drv->get_strings(phydev, data);
-	mutex_unlock(&phydev->lock);
-
-	return 0;
-}
-
-static inline int phy_ethtool_get_sset_count(struct phy_device *phydev)
-{
-	int ret;
-
-	if (!phydev->drv)
-		return -EIO;
-
-	if (phydev->drv->get_sset_count &&
-	    phydev->drv->get_strings &&
-	    phydev->drv->get_stats) {
-		mutex_lock(&phydev->lock);
-		ret = phydev->drv->get_sset_count(phydev);
-		mutex_unlock(&phydev->lock);
-
-		return ret;
-	}
-
-	return -EOPNOTSUPP;
-}
-
-static inline int phy_ethtool_get_stats(struct phy_device *phydev,
-					struct ethtool_stats *stats, u64 *data)
-{
-	if (!phydev->drv)
-		return -EIO;
-
-	mutex_lock(&phydev->lock);
-	phydev->drv->get_stats(phydev, stats, data);
-	mutex_unlock(&phydev->lock);
-
-	return 0;
-}
+int phy_ethtool_get_strings(struct phy_device *phydev, u8 *data);
+int phy_ethtool_get_sset_count(struct phy_device *phydev);
+int phy_ethtool_get_stats(struct phy_device *phydev,
+			  struct ethtool_stats *stats, u64 *data);
 
 static inline int phy_package_read(struct phy_device *phydev, u32 regnum)
 {
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 83f22196d64c..441794e0034f 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -135,6 +135,7 @@ static int ethtool_set_features(struct net_device *dev, void __user *useraddr)
 
 static int __ethtool_get_sset_count(struct net_device *dev, int sset)
 {
+	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 
 	if (sset == ETH_SS_FEATURES)
@@ -150,8 +151,9 @@ static int __ethtool_get_sset_count(struct net_device *dev, int sset)
 		return ARRAY_SIZE(phy_tunable_strings);
 
 	if (sset == ETH_SS_PHY_STATS && dev->phydev &&
-	    !ops->get_ethtool_phy_stats)
-		return phy_ethtool_get_sset_count(dev->phydev);
+	    !ops->get_ethtool_phy_stats &&
+	    phy_ops && phy_ops->get_sset_count)
+		return phy_ops->get_sset_count(dev->phydev);
 
 	if (sset == ETH_SS_LINK_MODES)
 		return __ETHTOOL_LINK_MODE_MASK_NBITS;
@@ -165,6 +167,7 @@ static int __ethtool_get_sset_count(struct net_device *dev, int sset)
 static void __ethtool_get_strings(struct net_device *dev,
 	u32 stringset, u8 *data)
 {
+	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 
 	if (stringset == ETH_SS_FEATURES)
@@ -178,8 +181,9 @@ static void __ethtool_get_strings(struct net_device *dev,
 	else if (stringset == ETH_SS_PHY_TUNABLES)
 		memcpy(data, phy_tunable_strings, sizeof(phy_tunable_strings));
 	else if (stringset == ETH_SS_PHY_STATS && dev->phydev &&
-		 !ops->get_ethtool_phy_stats)
-		phy_ethtool_get_strings(dev->phydev, data);
+		 !ops->get_ethtool_phy_stats && phy_ops &&
+		 phy_ops->get_strings)
+		phy_ops->get_strings(dev->phydev, data);
 	else if (stringset == ETH_SS_LINK_MODES)
 		memcpy(data, link_mode_names,
 		       __ETHTOOL_LINK_MODE_MASK_NBITS * ETH_GSTRING_LEN);
@@ -1929,6 +1933,7 @@ static int ethtool_get_stats(struct net_device *dev, void __user *useraddr)
 
 static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 {
+	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	struct phy_device *phydev = dev->phydev;
 	struct ethtool_stats stats;
@@ -1938,8 +1943,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 	if (!phydev && (!ops->get_ethtool_phy_stats || !ops->get_sset_count))
 		return -EOPNOTSUPP;
 
-	if (dev->phydev && !ops->get_ethtool_phy_stats)
-		n_stats = phy_ethtool_get_sset_count(dev->phydev);
+	if (dev->phydev && !ops->get_ethtool_phy_stats &&
+	    phy_ops && phy_ops->get_sset_count)
+		n_stats = phy_ops->get_sset_count(dev->phydev);
 	else
 		n_stats = ops->get_sset_count(dev, ETH_SS_PHY_STATS);
 	if (n_stats < 0)
@@ -1958,8 +1964,9 @@ static int ethtool_get_phy_stats(struct net_device *dev, void __user *useraddr)
 		if (!data)
 			return -ENOMEM;
 
-		if (dev->phydev && !ops->get_ethtool_phy_stats) {
-			ret = phy_ethtool_get_stats(dev->phydev, &stats, data);
+		if (dev->phydev && !ops->get_ethtool_phy_stats &&
+		    phy_ops && phy_ops->get_stats) {
+			ret = phy_ops->get_stats(dev->phydev, &stats, data);
 			if (ret < 0)
 				goto out;
 		} else {
diff --git a/net/ethtool/strset.c b/net/ethtool/strset.c
index 0eed4e4909ab..773634b6b048 100644
--- a/net/ethtool/strset.c
+++ b/net/ethtool/strset.c
@@ -209,13 +209,15 @@ static void strset_cleanup_data(struct ethnl_reply_data *reply_base)
 static int strset_prepare_set(struct strset_info *info, struct net_device *dev,
 			      unsigned int id, bool counts_only)
 {
+	const struct ethtool_phy_ops *phy_ops = ethtool_phy_ops;
 	const struct ethtool_ops *ops = dev->ethtool_ops;
 	void *strings;
 	int count, ret;
 
 	if (id == ETH_SS_PHY_STATS && dev->phydev &&
-	    !ops->get_ethtool_phy_stats)
-		ret = phy_ethtool_get_sset_count(dev->phydev);
+	    !ops->get_ethtool_phy_stats && phy_ops &&
+	    phy_ops->get_sset_count)
+		ret = phy_ops->get_sset_count(dev->phydev);
 	else if (ops->get_sset_count && ops->get_strings)
 		ret = ops->get_sset_count(dev, id);
 	else
@@ -231,8 +233,9 @@ static int strset_prepare_set(struct strset_info *info, struct net_device *dev,
 		if (!strings)
 			return -ENOMEM;
 		if (id == ETH_SS_PHY_STATS && dev->phydev &&
-		    !ops->get_ethtool_phy_stats)
-			phy_ethtool_get_strings(dev->phydev, strings);
+		    !ops->get_ethtool_phy_stats && phy_ops &&
+		    phy_ops->get_strings)
+			phy_ops->get_strings(dev->phydev, strings);
 		else
 			ops->get_strings(dev, id, strings);
 		info->strings = strings;
-- 
2.25.1

