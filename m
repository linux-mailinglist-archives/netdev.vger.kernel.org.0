Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 581D5DFA30
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730754AbfJVBfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:35:08 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56814 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728819AbfJVBfI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 21:35:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9+ZmlOIipmVuQakzPV5yYVjqF3blb7h8JIlDx6hev8Q=; b=JQTwYQQm6SgWFU/pAmSut6X44p
        BJuFKXA1mp09JD5FgO3BHfhNJhnP1As2nAgNzZ5RBhikIKxcmQ9SXFjpI6YdZNqS0TvruUHCar+mQ
        NkD9gJVDzKOWuTacRqiIovk0lHV6H2uKljmhCgCzdZqRFdTRpFdILCyxvnHdRc4rduWk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iMj4S-0007il-KH; Tue, 22 Oct 2019 03:34:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, jiri@mellanox.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v5 1/2] net: dsa: Add support for devlink device parameters
Date:   Tue, 22 Oct 2019 03:34:35 +0200
Message-Id: <20191022013436.29635-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191022013436.29635-1-andrew@lunn.ch>
References: <20191022013436.29635-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add plumbing to allow DSA drivers to register parameters with devlink.

To keep with the abstraction, the DSA drivers pass the ds structure to
these helpers, and the DSA core then translates that to the devlink
structure associated to the device.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
---
 include/net/dsa.h | 23 +++++++++++++++++++++++
 net/dsa/dsa.c     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa2.c    |  7 ++++++-
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8c3ea0530f65..524ffabada91 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -541,6 +541,29 @@ struct dsa_switch_ops {
 	 */
 	netdev_tx_t (*port_deferred_xmit)(struct dsa_switch *ds, int port,
 					  struct sk_buff *skb);
+	/* Devlink parameters */
+	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
+				     struct devlink_param_gset_ctx *ctx);
+	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
+				     struct devlink_param_gset_ctx *ctx);
+};
+
+#define DSA_DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes)		\
+	DEVLINK_PARAM_DRIVER(_id, _name, _type, _cmodes,		\
+			     dsa_devlink_param_get, dsa_devlink_param_set, NULL)
+
+int dsa_devlink_param_get(struct devlink *dl, u32 id,
+			  struct devlink_param_gset_ctx *ctx);
+int dsa_devlink_param_set(struct devlink *dl, u32 id,
+			  struct devlink_param_gset_ctx *ctx);
+int dsa_devlink_params_register(struct dsa_switch *ds,
+				const struct devlink_param *params,
+				size_t params_count);
+void dsa_devlink_params_unregister(struct dsa_switch *ds,
+				   const struct devlink_param *params,
+				   size_t params_count);
+struct dsa_devlink_priv {
+	struct dsa_switch *ds;
 };
 
 struct dsa_switch_driver {
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 43120a3fb06f..81ced09e933f 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -329,6 +329,54 @@ int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_dsa_notifiers);
 
+int dsa_devlink_param_get(struct devlink *dl, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct dsa_devlink_priv *dl_priv;
+	struct dsa_switch *ds;
+
+	dl_priv = devlink_priv(dl);
+	ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_param_get)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_param_get(ds, id, ctx);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_param_get);
+
+int dsa_devlink_param_set(struct devlink *dl, u32 id,
+			  struct devlink_param_gset_ctx *ctx)
+{
+	struct dsa_devlink_priv *dl_priv;
+	struct dsa_switch *ds;
+
+	dl_priv = devlink_priv(dl);
+	ds = dl_priv->ds;
+
+	if (!ds->ops->devlink_param_set)
+		return -EOPNOTSUPP;
+
+	return ds->ops->devlink_param_set(ds, id, ctx);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_param_set);
+
+int dsa_devlink_params_register(struct dsa_switch *ds,
+				const struct devlink_param *params,
+				size_t params_count)
+{
+	return devlink_params_register(ds->devlink, params, params_count);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_params_register);
+
+void dsa_devlink_params_unregister(struct dsa_switch *ds,
+				   const struct devlink_param *params,
+				   size_t params_count)
+{
+	devlink_params_unregister(ds->devlink, params, params_count);
+}
+EXPORT_SYMBOL_GPL(dsa_devlink_params_unregister);
+
 static int __init dsa_init_module(void)
 {
 	int rc;
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 73002022c9d8..59711ee2836d 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -367,6 +367,7 @@ static void dsa_port_teardown(struct dsa_port *dp)
 
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
+	struct dsa_devlink_priv *dl_priv;
 	int err = 0;
 
 	/* Initialize ds->phys_mii_mask before registering the slave MDIO bus
@@ -379,9 +380,11 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	/* Add the switch to devlink before calling setup, so that setup can
 	 * add dpipe tables
 	 */
-	ds->devlink = devlink_alloc(&dsa_devlink_ops, 0);
+	ds->devlink = devlink_alloc(&dsa_devlink_ops, sizeof(*dl_priv));
 	if (!ds->devlink)
 		return -ENOMEM;
+	dl_priv = devlink_priv(ds->devlink);
+	dl_priv->ds = ds;
 
 	err = devlink_register(ds->devlink, ds->dev);
 	if (err)
@@ -395,6 +398,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	if (err < 0)
 		goto unregister_notifier;
 
+	devlink_params_publish(ds->devlink);
+
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
 		if (!ds->slave_mii_bus) {
-- 
2.23.0

