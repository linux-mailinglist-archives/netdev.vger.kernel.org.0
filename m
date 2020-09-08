Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4816B26228D
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729779AbgIHWVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:21:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728620AbgIHWVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 18:21:21 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AACDB2137B;
        Tue,  8 Sep 2020 22:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599603681;
        bh=ttUYf9u6OA9ikPiihSyzD9NF7/2m88emyQ6x1MvQjwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LapH3qtO3xnHqNEcOoWy0ATAS6/g2U4WWdF0QvRsmI4FWiEdoosfXWEUaTcbkypT+
         E6AxnckBeugzPSLR+k7VS0wN+KAoQTOyHmDMfXaOEQH4VcuL/l/gWC+OkqtwxU9FpM
         f0mgHhOTZqLtAbKqyOULQF651YUfSDgwmmhl/Gn4=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        ogerlitz@mellanox.com, yishaih@mellanox.com, saeedm@mellanox.com,
        leonro@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 1/2] devlink: don't crash if netdev is NULL
Date:   Tue,  8 Sep 2020 15:21:13 -0700
Message-Id: <20200908222114.190718-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908222114.190718-1-kuba@kernel.org>
References: <20200908222114.190718-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following change will add support for a corner case where
we may not have a netdev to pass to devlink_port_type_eth_set()
but we still want to set port type.

This is definitely a corner case, and drivers should not normally
pass NULL netdev - print a warning message when this happens.

Sadly for other port types (ib) switches don't have a device
reference, the way we always do for Ethernet, so we can't put
the warning in __devlink_port_type_set().

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/devlink.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index 49e911c19881..31cac8365b22 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -7603,14 +7603,8 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 	devlink_port_notify(devlink_port, DEVLINK_CMD_PORT_NEW);
 }
 
-/**
- *	devlink_port_type_eth_set - Set port type to Ethernet
- *
- *	@devlink_port: devlink port
- *	@netdev: related netdevice
- */
-void devlink_port_type_eth_set(struct devlink_port *devlink_port,
-			       struct net_device *netdev)
+static void devlink_port_type_netdev_checks(struct devlink_port *devlink_port,
+					    struct net_device *netdev)
 {
 	const struct net_device_ops *ops = netdev->netdev_ops;
 
@@ -7644,6 +7638,24 @@ void devlink_port_type_eth_set(struct devlink_port *devlink_port,
 		err = ops->ndo_get_port_parent_id(netdev, &ppid);
 		WARN_ON(err != -EOPNOTSUPP);
 	}
+}
+
+/**
+ *	devlink_port_type_eth_set - Set port type to Ethernet
+ *
+ *	@devlink_port: devlink port
+ *	@netdev: related netdevice
+ */
+void devlink_port_type_eth_set(struct devlink_port *devlink_port,
+			       struct net_device *netdev)
+{
+	if (netdev)
+		devlink_port_type_netdev_checks(devlink_port, netdev);
+	else
+		dev_warn(devlink_port->devlink->dev,
+			 "devlink port type for port %d set to Ethernet without a software interface reference, device type not supported by the kernel?\n",
+			 devlink_port->index);
+
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_ETH, netdev);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_eth_set);
-- 
2.26.2

