Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F871483907
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiACX0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbiACX0B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:26:01 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B10DCC061784;
        Mon,  3 Jan 2022 15:26:00 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c2so30619901pfc.1;
        Mon, 03 Jan 2022 15:26:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QCUoaEOA0tftjLb0LI0lpsnVHcMQNSiDzWVP7rq9STo=;
        b=qCu8poPV1paRstjK/1c6MsqZuvuiM7u/06fcyyrJT4eWMWjThBKeGEWVDWKFGUJct+
         7JcKrq/RawsTOLlXps/BJEe2Ke8tBDxrTLvp/aNqGmY1pKqUZKBNPJikyRPq6O67HNCj
         CG/LwAGRzQVwOdorhD0uueD6A1JXgKkZvRdgrZmT9KtvmGN3ojGcKWrnOh8q7ECHKr8B
         yuFNXYM16ai+FfOFdszskAblpYTj75HzysrCHBAiPeqRFzNbz0xZruhBxqorkbTVhuuv
         3K9TjLcG0yG4GXRWtKzG+lzSHo6hTqD8gOJdA5dbqJ0ypwAOrK24o+PHyrULGaFU5yzV
         VvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QCUoaEOA0tftjLb0LI0lpsnVHcMQNSiDzWVP7rq9STo=;
        b=U8uAC0TtM1msSRAPn0BLUP/073AMZ9cq93RcG9TMscWIgWIcRi5TdZ7ezjXhaDZb1V
         4J4XcZZa3oN1hyEuJdOGHpYBXWkD2QPZiTcic4QvXCO7FSPKeEN9tnjZp+ufGFSrev5h
         +KbX/M4jQ5ENUYEGluRnF1GDVVU7sN2bzqmo5t+V75rCN4J+DAVdnX1IxigW31weXX7R
         UF6bdI75i/USEerJ3jfcn5RQzg4124k2F4Q8xMzQalN2PqxYLpFVZvV4eM68qKucniQ6
         EnCG1NqXLyGinXEa6df8hYxTuxRnz2v7D+Qp6/oIepoNik0Xyosq/7llGQ4IsQvMENhL
         iOdQ==
X-Gm-Message-State: AOAM5337wrYXbe6aYQSKaIyGOw2FBXted/o9eqrzsKJ/Q4JU3Kel09Mu
        eKmyDn/Q9Kp8UDd7myFoBoSufk8DyTo=
X-Google-Smtp-Source: ABdhPJwOApE90rsP5VPsbCmqmpHBnliakFXKKz3HaJtUGyVIrzT8QBWRVvQef5Zo5Wbevc+UA+v/0A==
X-Received: by 2002:a63:91c1:: with SMTP id l184mr42672766pge.452.1641252360121;
        Mon, 03 Jan 2022 15:26:00 -0800 (PST)
Received: from localhost.localdomain ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k6sm41340191pff.106.2022.01.03.15.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:25:59 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC V1 net-next 2/4] net: Expose available time stamping layers to user space.
Date:   Mon,  3 Jan 2022 15:25:53 -0800
Message-Id: <20220103232555.19791-3-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Time stamping on network packets may happen either in the MAC or in
the PHY, but not both.  In preparation for making the choice
selectable, expose both the current and available layers via sysfs.

In accordance with the kernel implementation as it stands, the current
layer will always read as "phy" when a PHY time stamping device is
present.  Future patches will allow changing the current layer
administratively.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 .../ABI/testing/sysfs-class-net-timestamping  | 17 ++++++
 drivers/net/phy/phy_device.c                  |  2 +
 include/linux/netdevice.h                     | 10 ++++
 net/core/net-sysfs.c                          | 60 +++++++++++++++++++
 4 files changed, 89 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-timestamping

diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/Documentation/ABI/testing/sysfs-class-net-timestamping
new file mode 100644
index 000000000000..529c3a6eb607
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
@@ -0,0 +1,17 @@
+What:		/sys/class/net/<iface>/available_timestamping_providers
+Date:		January 2022
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		Enumerates the available providers for SO_TIMESTAMPING.
+		The possible values are:
+		- "mac"  The MAC provides time stamping.
+		- "phy"  The PHY or MII device provides time stamping.
+
+What:		/sys/class/net/<iface>/current_timestamping_provider
+Date:		January 2022
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		Show the current SO_TIMESTAMPING provider.
+		The possible values are:
+		- "mac"  The MAC provides time stamping.
+		- "phy"  The PHY or MII device provides time stamping.
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..5538ee27e865 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1415,6 +1415,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 	phydev->phy_link_change = phy_link_change;
 	if (dev) {
+		dev->selected_timestamping_layer = PHY_TIMESTAMPING;
 		phydev->attached_dev = dev;
 		dev->phydev = phydev;
 
@@ -1727,6 +1728,7 @@ void phy_detach(struct phy_device *phydev)
 
 	phy_suspend(phydev);
 	if (dev) {
+		dev->selected_timestamping_layer = MAC_TIMESTAMPING;
 		phydev->attached_dev->phydev = NULL;
 		phydev->attached_dev = NULL;
 	}
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2684bdb6defa..b44ae00df3a8 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1687,6 +1687,11 @@ enum netdev_ml_priv_type {
 	ML_PRIV_CAN,
 };
 
+enum timestamping_layer {
+	MAC_TIMESTAMPING,
+	PHY_TIMESTAMPING,
+};
+
 /**
  *	struct net_device - The DEVICE structure.
  *
@@ -1927,6 +1932,9 @@ enum netdev_ml_priv_type {
  *
  *	@threaded:	napi threaded mode is enabled
  *
+ *	@selected_timestamping_layer:	Tracks whether the MAC or the PHY
+ *					performs packet time stamping.
+ *
  *	@net_notifier_list:	List of per-net netdev notifier block
  *				that follow this device when it is moved
  *				to another network namespace.
@@ -2263,6 +2271,8 @@ struct net_device {
 	unsigned		wol_enabled:1;
 	unsigned		threaded:1;
 
+	enum timestamping_layer selected_timestamping_layer;
+
 	struct list_head	net_notifier_list;
 
 #if IS_ENABLED(CONFIG_MACSEC)
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 53ea262ecafd..4ff7ef417c38 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -618,6 +618,64 @@ static ssize_t threaded_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(threaded);
 
+static ssize_t available_timestamping_providers_show(struct device *dev,
+						     struct device_attribute *attr,
+						     char *buf)
+{
+	const struct ethtool_ops *ops;
+	struct net_device *netdev;
+	struct phy_device *phydev;
+	int ret = 0;
+
+	netdev = to_net_dev(dev);
+	phydev = netdev->phydev;
+	ops = netdev->ethtool_ops;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	ret += sprintf(buf, "%s\n", "mac");
+	buf += 4;
+
+	if (phy_has_tsinfo(phydev)) {
+		ret += sprintf(buf, "%s\n", "phy");
+		buf += 4;
+	}
+
+	rtnl_unlock();
+
+	return ret;
+}
+static DEVICE_ATTR_RO(available_timestamping_providers);
+
+static ssize_t current_timestamping_provider_show(struct device *dev,
+						  struct device_attribute *attr,
+						  char *buf)
+{
+	const struct ethtool_ops *ops;
+	struct net_device *netdev;
+	struct phy_device *phydev;
+	int ret;
+
+	netdev = to_net_dev(dev);
+	phydev = netdev->phydev;
+	ops = netdev->ethtool_ops;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (phy_has_tsinfo(phydev)) {
+		ret = sprintf(buf, "%s\n", "phy");
+	} else {
+		ret = sprintf(buf, "%s\n", "mac");
+	}
+
+	rtnl_unlock();
+
+	return ret;
+}
+static DEVICE_ATTR_RO(current_timestamping_provider);
+
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
 	&dev_attr_type.attr,
@@ -651,6 +709,8 @@ static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_carrier_up_count.attr,
 	&dev_attr_carrier_down_count.attr,
 	&dev_attr_threaded.attr,
+	&dev_attr_available_timestamping_providers.attr,
+	&dev_attr_current_timestamping_provider.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(net_class);
-- 
2.20.1

