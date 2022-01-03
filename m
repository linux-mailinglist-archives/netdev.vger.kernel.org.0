Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF6F483908
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbiACX0E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiACX0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:26:02 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B03C061761;
        Mon,  3 Jan 2022 15:26:02 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id z3so25820852plg.8;
        Mon, 03 Jan 2022 15:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tRbA9VyOjLVvoknHXvMJ6qY2wU3zvdmza99A/Uu0abA=;
        b=Z+85qpx9leulsSqxTd77xcqihNi07ZXv6tL8A3Hgw2tYFWfVP/c260x2sm6U9fFSpO
         0yl2Cl5JkdRJk9jumUxYqRXS/DMEt7JJ4B8bA9lhOg0+d8SCV9KxifW6sP5c33G/7Ntu
         QnpfOjz8/veOsrqB/pluigIMGeZm5UFDUv5tnvMomCW2nizaeGNIhr4sFXdP+hPptzWT
         EZ31GX8tS5YUyhTZuFtaI+ak528IpmAA+ZG/A5ptzcogkPPF7K4xNkuw9ArsUgpvnQHi
         exjUXeQArDvach8gHBEK7XDKWtgiA5i+kDpFvRnCy8BMUpAwiHH/dAAVYyPaVKsRQxuw
         jMPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=tRbA9VyOjLVvoknHXvMJ6qY2wU3zvdmza99A/Uu0abA=;
        b=HCd8tR7kHjHe2F4IOagRvxCZ7agcE0eWO9ZIQPJpwM6Pi+iS05O0ks/fWXilyv35HC
         swBMRVrv4tfbq16ZZlMMWlXwgx1EbO+EfSAdjLA3ya/4MoKgMP0V1w00M1ARi9vsHJYa
         flON2jUVIXUxp0JWFmJVr2S59uCvG59caZIlDSuJT8puZweeJOZ/GXf3+PwQwWaWey7S
         VTuyhRsk63GgdoIip7qEpjmKTTrLX5yTTWVnZFNU9r8YVFZkPXUKKHhDI7h+QQMj6lOq
         1R40/z3lb3TtTQPY3B19vTcNEFsJvmfZTzS2FPAUaQfc+fzGv+sylgaic5b1rqOE1jp3
         Qqng==
X-Gm-Message-State: AOAM532jFl3oNZUnw6SoMyoHkn4WWaQbbAcy3TnRUPxcnoETpwmjE7T0
        a51c5NX/RbSGBZbdyIjSafnnqXzMcLw=
X-Google-Smtp-Source: ABdhPJzbFGPyBHeabrShgT2zS30eSrQJFXKU5DFm67QkXsLT06zy66akf3/lXzJuvW6ahfcSQftZkw==
X-Received: by 2002:a17:902:7443:b0:149:b16d:c527 with SMTP id e3-20020a170902744300b00149b16dc527mr12811751plt.89.1641252361409;
        Mon, 03 Jan 2022 15:26:01 -0800 (PST)
Received: from localhost.localdomain ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k6sm41340191pff.106.2022.01.03.15.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:26:01 -0800 (PST)
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
Subject: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping layer be selectable.
Date:   Mon,  3 Jan 2022 15:25:54 -0800
Message-Id: <20220103232555.19791-4-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make the sysfs knob writable, and add checks in the ioctl and time
stamping paths to respect the currently selected time stamping layer.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 .../ABI/testing/sysfs-class-net-timestamping  |  5 +-
 net/core/dev_ioctl.c                          | 44 ++++++++++++++--
 net/core/net-sysfs.c                          | 50 +++++++++++++++++--
 net/core/timestamping.c                       |  6 +++
 net/ethtool/common.c                          | 18 +++++--
 5 files changed, 111 insertions(+), 12 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-net-timestamping b/Documentation/ABI/testing/sysfs-class-net-timestamping
index 529c3a6eb607..6dfd59740cad 100644
--- a/Documentation/ABI/testing/sysfs-class-net-timestamping
+++ b/Documentation/ABI/testing/sysfs-class-net-timestamping
@@ -11,7 +11,10 @@ What:		/sys/class/net/<iface>/current_timestamping_provider
 Date:		January 2022
 Contact:	Richard Cochran <richardcochran@gmail.com>
 Description:
-		Show the current SO_TIMESTAMPING provider.
+		Shows or sets the current SO_TIMESTAMPING provider.
+		When changing the value, some packets in the kernel
+		networking stack may still be delivered with time
+		stamps from the previous provider.
 		The possible values are:
 		- "mac"  The MAC provides time stamping.
 		- "phy"  The PHY or MII device provides time stamping.
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 1b807d119da5..269068ce3a51 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -260,6 +260,43 @@ static int dev_eth_ioctl(struct net_device *dev,
 	return err;
 }
 
+static int dev_hwtstamp_ioctl(struct net_device *dev,
+			      struct ifreq *ifr, unsigned int cmd)
+{
+	const struct net_device_ops *ops = dev->netdev_ops;
+	int err;
+
+	err = dsa_ndo_eth_ioctl(dev, ifr, cmd);
+	if (err == 0 || err != -EOPNOTSUPP)
+		return err;
+
+	if (!netif_device_present(dev))
+		return -ENODEV;
+
+	switch (dev->selected_timestamping_layer) {
+
+	case MAC_TIMESTAMPING:
+		if (ops->ndo_do_ioctl == phy_do_ioctl) {
+			/* Some drivers set .ndo_do_ioctl to phy_do_ioctl. */
+			err = -EOPNOTSUPP;
+		} else {
+			err = ops->ndo_eth_ioctl(dev, ifr, cmd);
+		}
+		break;
+
+	case PHY_TIMESTAMPING:
+		if (phy_has_hwtstamp(dev->phydev)) {
+			err = phy_mii_ioctl(dev->phydev, ifr, cmd);
+		} else {
+			err = -ENODEV;
+			WARN_ON(1);
+		}
+		break;
+	}
+
+	return err;
+}
+
 static int dev_siocbond(struct net_device *dev,
 			struct ifreq *ifr, unsigned int cmd)
 {
@@ -395,6 +432,9 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 			return err;
 		fallthrough;
 
+	case SIOCGHWTSTAMP:
+		return dev_hwtstamp_ioctl(dev, ifr, cmd);
+
 	/*
 	 *	Unknown or private ioctl
 	 */
@@ -405,9 +445,7 @@ static int dev_ifsioc(struct net *net, struct ifreq *ifr, void __user *data,
 
 		if (cmd == SIOCGMIIPHY ||
 		    cmd == SIOCGMIIREG ||
-		    cmd == SIOCSMIIREG ||
-		    cmd == SIOCSHWTSTAMP ||
-		    cmd == SIOCGHWTSTAMP) {
+		    cmd == SIOCSMIIREG) {
 			err = dev_eth_ioctl(dev, ifr, cmd);
 		} else if (cmd == SIOCBONDENSLAVE ||
 		    cmd == SIOCBONDRELEASE ||
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 4ff7ef417c38..c27f01a1a285 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -664,17 +664,59 @@ static ssize_t current_timestamping_provider_show(struct device *dev,
 	if (!rtnl_trylock())
 		return restart_syscall();
 
-	if (phy_has_tsinfo(phydev)) {
-		ret = sprintf(buf, "%s\n", "phy");
-	} else {
+	switch (netdev->selected_timestamping_layer) {
+	case MAC_TIMESTAMPING:
 		ret = sprintf(buf, "%s\n", "mac");
+		break;
+	case PHY_TIMESTAMPING:
+		ret = sprintf(buf, "%s\n", "phy");
+		break;
 	}
 
 	rtnl_unlock();
 
 	return ret;
 }
-static DEVICE_ATTR_RO(current_timestamping_provider);
+
+static ssize_t current_timestamping_provider_store(struct device *dev,
+						   struct device_attribute *attr,
+						   const char *buf, size_t len)
+{
+	struct net_device *netdev = to_net_dev(dev);
+	struct net *net = dev_net(netdev);
+	enum timestamping_layer flavor;
+
+	if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (!strcmp(buf, "mac\n"))
+		flavor = MAC_TIMESTAMPING;
+	else if (!strcmp(buf, "phy\n"))
+		flavor = PHY_TIMESTAMPING;
+	else
+		return -EINVAL;
+
+	if (!rtnl_trylock())
+		return restart_syscall();
+
+	if (!dev_isalive(netdev))
+		goto out;
+
+	if (netdev->selected_timestamping_layer != flavor) {
+		const struct net_device_ops *ops = netdev->netdev_ops;
+		struct ifreq ifr = {0};
+
+		/* Disable time stamping in the current layer. */
+		if (netif_device_present(netdev) && ops->ndo_eth_ioctl)
+			ops->ndo_eth_ioctl(netdev, &ifr, SIOCSHWTSTAMP);
+
+		netdev->selected_timestamping_layer = flavor;
+	}
+out:
+	rtnl_unlock();
+	return len;
+}
+static DEVICE_ATTR_RW(current_timestamping_provider);
 
 static struct attribute *net_class_attrs[] __ro_after_init = {
 	&dev_attr_netdev_group.attr,
diff --git a/net/core/timestamping.c b/net/core/timestamping.c
index 04840697fe79..31c3142787b7 100644
--- a/net/core/timestamping.c
+++ b/net/core/timestamping.c
@@ -28,6 +28,9 @@ void skb_clone_tx_timestamp(struct sk_buff *skb)
 	if (!skb->sk)
 		return;
 
+	if (skb->dev->selected_timestamping_layer != PHY_TIMESTAMPING)
+		return;
+
 	type = classify(skb);
 	if (type == PTP_CLASS_NONE)
 		return;
@@ -50,6 +53,9 @@ bool skb_defer_rx_timestamp(struct sk_buff *skb)
 	if (!skb->dev || !skb->dev->phydev || !skb->dev->phydev->mii_ts)
 		return false;
 
+	if (skb->dev->selected_timestamping_layer != PHY_TIMESTAMPING)
+		return false;
+
 	if (skb_headroom(skb) < ETH_HLEN)
 		return false;
 
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 651d18eef589..7b50820c1d1d 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -545,10 +545,20 @@ int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
 	memset(info, 0, sizeof(*info));
 	info->cmd = ETHTOOL_GET_TS_INFO;
 
-	if (phy_has_tsinfo(phydev))
-		return phy_ts_info(phydev, info);
-	if (ops->get_ts_info)
-		return ops->get_ts_info(dev, info);
+	switch (dev->selected_timestamping_layer) {
+
+	case MAC_TIMESTAMPING:
+		if (ops->get_ts_info)
+			return ops->get_ts_info(dev, info);
+		break;
+
+	case PHY_TIMESTAMPING:
+		if (phy_has_tsinfo(phydev)) {
+			return phy_ts_info(phydev, info);
+		}
+		WARN_ON(1);
+		return -ENODEV;
+	}
 
 	info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
 				SOF_TIMESTAMPING_SOFTWARE;
-- 
2.20.1

