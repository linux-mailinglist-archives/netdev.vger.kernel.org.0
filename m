Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E95D270EA0
	for <lists+netdev@lfdr.de>; Sat, 19 Sep 2020 16:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbgISOoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Sep 2020 10:44:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45202 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726312AbgISOn6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Sep 2020 10:43:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kJe5h-00FNaS-4h; Sat, 19 Sep 2020 16:43:53 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Chris Healy <cphealy@gmail.com>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next RFC v1 2/4] net: dsa: Add devlink port regions support to DSA
Date:   Sat, 19 Sep 2020 16:43:30 +0200
Message-Id: <20200919144332.3665538-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200919144332.3665538-1-andrew@lunn.ch>
References: <20200919144332.3665538-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow DSA drivers to make use of devlink port regions, via simple
wrappers.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h  |  5 +++++
 net/core/devlink.c |  3 +--
 net/dsa/dsa.c      | 14 ++++++++++++++
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index d16057c5987a..01da896b2998 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -665,6 +665,11 @@ struct devlink_region *
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
diff --git a/net/core/devlink.c b/net/core/devlink.c
index 66469cdcdc1e..4701ec17f3da 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -4292,7 +4292,6 @@ static int devlink_nl_cmd_region_get_port_dumpit(struct sk_buff *msg,
 	}
 
 out:
-	mutex_unlock(&devlink_mutex);
 	return err;
 }
 
@@ -4330,7 +4329,7 @@ static int devlink_nl_cmd_region_get_devlink_dumpit(struct sk_buff *msg,
 	}
 
 out:
-	mutex_unlock(&devlink_mutex);
+	mutex_unlock(&devlink->lock);
 	return err;
 }
 
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

