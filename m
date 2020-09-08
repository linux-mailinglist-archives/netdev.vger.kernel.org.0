Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1979F2607D8
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgIHAwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:52:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48786 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728229AbgIHAwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:52:23 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFRro-00Di6B-90; Tue, 08 Sep 2020 02:52:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH net-next v2 1/7] net: dsa: Add helper to convert from devlink to ds
Date:   Tue,  8 Sep 2020 02:51:49 +0200
Message-Id: <20200908005155.3267736-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908005155.3267736-1-andrew@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Given a devlink instance, return the dsa switch it is associated to.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
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

