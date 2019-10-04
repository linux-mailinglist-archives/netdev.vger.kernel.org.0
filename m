Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75960CC49A
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:10:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbfJDVKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:10:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33394 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730341AbfJDVKR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 17:10:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fmCXx76+rPMBIpqHD/d8KvBmJa39OjaaJppdi5tsXFU=; b=dYRlwpDCpBlxDXRdILG4UxzcQs
        +JXFRIJmprftAXP5TLi9bwUEgswS9SLDdILpXNxCmSAlPlg9XZGQAP4DXjjUxh4TWDKcmust8fFLw
        gkRtcfa/D1yTaVZ2TRy9U8oav6zQrOiBBDm3hoxL7QDPceZjrM1mKHm9tQTiDV8ScOfQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iGUpi-0003LT-EZ; Fri, 04 Oct 2019 23:09:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v2 net-next 1/2] net: dsa: Add support for devlink device parameters
Date:   Fri,  4 Oct 2019 23:09:33 +0200
Message-Id: <20191004210934.12813-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004210934.12813-1-andrew@lunn.ch>
References: <20191004210934.12813-1-andrew@lunn.ch>
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
---
 include/net/dsa.h | 23 +++++++++++++++++++++++
 net/dsa/dsa.c     | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 net/dsa/dsa2.c    |  7 ++++++-
 3 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8c3ea0530f65..6623f4428930 100644
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
+			     dsa_dl_param_get,	dsa_dl_param_set, NULL)
+
+int dsa_dl_param_get(struct devlink *dl, u32 id,
+		     struct devlink_param_gset_ctx *ctx);
+int dsa_dl_param_set(struct devlink *dl, u32 id,
+		     struct devlink_param_gset_ctx *ctx);
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
index 43120a3fb06f..ea7678650d8c 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -329,6 +329,54 @@ int call_dsa_notifiers(unsigned long val, struct net_device *dev,
 }
 EXPORT_SYMBOL_GPL(call_dsa_notifiers);
 
+int dsa_dl_param_get(struct devlink *dl, u32 id,
+		     struct devlink_param_gset_ctx *ctx)
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
+EXPORT_SYMBOL_GPL(dsa_dl_param_get);
+
+int dsa_dl_param_set(struct devlink *dl, u32 id,
+		     struct devlink_param_gset_ctx *ctx)
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
+EXPORT_SYMBOL_GPL(dsa_dl_param_set);
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
index 73002022c9d8..d74cc82fb44a 100644
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
+	ds->devlink = devlink_alloc(&dsa_devlink_ops, sizeof(*devlink_priv));
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

