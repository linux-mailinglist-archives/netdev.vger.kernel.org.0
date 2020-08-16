Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E73E245962
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729708AbgHPToC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:44:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55436 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729239AbgHPToB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 15:44:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7OZR-009c8b-UW; Sun, 16 Aug 2020 21:43:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/7] net: dsa: Add helper to convert from devlink to ds
Date:   Sun, 16 Aug 2020 21:43:10 +0200
Message-Id: <20200816194316.2291489-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200816194316.2291489-1-andrew@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a devlink instance, return the dsa switch it is associated to.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |  2 ++
 net/dsa/dsa.c     | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 75c8fac82017..63ff6f717307 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -629,6 +629,8 @@ struct dsa_switch_ops {
 	int	(*port_max_mtu)(struct dsa_switch *ds, int port);
 };
 
+struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl);
+
 #define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
 	DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes,		\
 			     dsa_devlink_param_get, dsa_devlink_param_set, NULL)
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1ce9ba8cf545..86351da4e202 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -327,14 +327,18 @@ int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_dsa_notifiers);
 
+struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+
+	return dl_priv->ds;
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_to_ds);
+
 int dsa_devlink_param_get(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
-	struct dsa_devlink_priv *dl_priv;
-	struct dsa_switch *ds;
-
-	dl_priv = devlink_priv(dl);
-	ds = dl_priv->ds;
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
 
 	if (!ds->ops->devlink_param_get)
 		return -EOPNOTSUPP;
@@ -346,11 +350,7 @@ EXPORT_SYMBOL_GPL(dsa_devlink_param_get);
 int dsa_devlink_param_set(struct devlink *dl, u32 id,
 			  struct devlink_param_gset_ctx *ctx)
 {
-	struct dsa_devlink_priv *dl_priv;
-	struct dsa_switch *ds;
-
-	dl_priv = devlink_priv(dl);
-	ds = dl_priv->ds;
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
 
 	if (!ds->ops->devlink_param_set)
 		return -EOPNOTSUPP;
-- 
2.28.0

