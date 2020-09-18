Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7AE82704BE
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 21:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726290AbgIRTLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 15:11:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:44192 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726192AbgIRTLa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 15:11:30 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJLn1-00FH9A-TL; Fri, 18 Sep 2020 21:11:23 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v4 4/9] net: dsa: Add devlink regions support to DSA
Date:   Fri, 18 Sep 2020 21:11:04 +0200
Message-Id: <20200918191109.3640779-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200918191109.3640779-1-andrew@lunn.ch>
References: <20200918191109.3640779-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow DSA drivers to make use of devlink regions, via simple wrappers.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/dsa.c     | 16 ++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 42ae6d4d9d43..431efb5098be 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -658,6 +658,12 @@ void dsa_devlink_resource_occ_get_register(struct dsa_switch *ds,
 					   void *occ_get_priv);
 void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
 					     u64 resource_id);
+struct devlink_region *
+dsa_devlink_region_create(struct dsa_switch *ds,
+			  const struct devlink_region_ops *ops,
+			  u32 region_max_snapshots, u64 region_size);
+void dsa_devlink_region_destroy(struct devlink_region *region);
+
 struct dsa_port *dsa_port_from_netdev(struct net_device *netdev);
 
 struct dsa_devlink_priv {
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 9b7019d86165..5c18c0214aac 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -404,6 +404,22 @@ void dsa_devlink_resource_occ_get_unregister(struct dsa_switch *ds,
 }
 EXPORT_SYMBOL_GPL(dsa_devlink_resource_occ_get_unregister);
 
+struct devlink_region *
+dsa_devlink_region_create(struct dsa_switch *ds,
+			  const struct devlink_region_ops *ops,
+			  u32 region_max_snapshots, u64 region_size)
+{
+	return devlink_region_create(ds->devlink, ops, region_max_snapshots,
+				     region_size);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_region_create);
+
+void dsa_devlink_region_destroy(struct devlink_region *region)
+{
+	devlink_region_destroy(region);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_region_destroy);
+
 struct dsa_port *dsa_port_from_netdev(struct net_device *netdev)
 {
 	if (!netdev || !dsa_slave_dev_check(netdev))
-- 
2.28.0

