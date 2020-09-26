Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B2D279C8E
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 23:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727278AbgIZVHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 17:07:18 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57280 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727017AbgIZVHQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 17:07:16 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kMHPU-00GJhA-2d; Sat, 26 Sep 2020 23:07:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 5/7] net: dsa: Add devlink port regions support to DSA
Date:   Sat, 26 Sep 2020 23:06:30 +0200
Message-Id: <20200926210632.3888886-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200926210632.3888886-1-andrew@lunn.ch>
References: <20200926210632.3888886-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow DSA drivers to make use of devlink port regions, via simple
wrappers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |  5 +++++
 net/dsa/dsa.c     | 14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 9aa44dc8ecdb..f0bb64e5002f 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -666,6 +666,11 @@ struct devlink_region *
 dsa_devlink_region_create(struct dsa_switch *ds,
 			  const struct devlink_region_ops *ops,
 			  u32 region_max_snapshots, u64 region_size);
+struct devlink_region *
+dsa_devlink_port_region_create(struct dsa_switch *ds,
+			       int port,
+			       const struct devlink_port_region_ops *ops,
+			       u32 region_max_snapshots, u64 region_size);
 void dsa_devlink_region_destroy(struct devlink_region *region);
 
 struct dsa_port *dsa_port_from_netdev(struct net_device *netdev);
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 5c18c0214aac..97fcabdeccec 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -414,6 +414,20 @@ dsa_devlink_region_create(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL_GPL(dsa_devlink_region_create);
 
+struct devlink_region *
+dsa_devlink_port_region_create(struct dsa_switch *ds,
+			       int port,
+			       const struct devlink_port_region_ops *ops,
+			       u32 region_max_snapshots, u64 region_size)
+{
+	struct dsa_port *dp = dsa_to_port(ds, port);
+
+	return devlink_port_region_create(&dp->devlink_port, ops,
+					  region_max_snapshots,
+					  region_size);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_port_region_create);
+
 void dsa_devlink_region_destroy(struct devlink_region *region)
 {
 	devlink_region_destroy(region);
-- 
2.28.0

