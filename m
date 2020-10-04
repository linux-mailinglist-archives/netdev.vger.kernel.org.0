Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9C98282BB2
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbgJDQNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:13:24 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42552 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726095AbgJDQNO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Oct 2020 12:13:14 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kP6dJ-0003eW-C2; Sun, 04 Oct 2020 18:13:09 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 5/7] net: dsa: Add devlink port regions support to DSA
Date:   Sun,  4 Oct 2020 18:12:55 +0200
Message-Id: <20201004161257.13945-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201004161257.13945-1-andrew@lunn.ch>
References: <20201004161257.13945-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow DSA drivers to make use of devlink port regions, via simple
wrappers.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Tested-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |  5 +++++
 net/dsa/dsa.c     | 14 ++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 049140b2f593..ca426cf9927b 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -681,6 +681,11 @@ struct devlink_region *
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
index dec4ab59b7c4..2131bf2b3a67 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -423,6 +423,20 @@ dsa_devlink_region_create(struct dsa_switch *ds,
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

