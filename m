Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5D92639C5
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730549AbgIJCCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:02:54 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730181AbgIJB4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:56:08 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00DzpQ-P3; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 3/9] net: dsa: Add helper to convert from devlink to ds
Date:   Thu, 10 Sep 2020 01:58:21 +0200
Message-Id: <20200909235827.3335881-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909235827.3335881-1-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
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
 include/net/dsa.h |  7 +++++++
 net/dsa/dsa.c     | 12 ++----------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 75c8fac82017..42ae6d4d9d43 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -664,6 +664,13 @@ struct dsa_devlink_priv {
 	struct dsa_switch *ds;
 };
 
+static inline struct dsa_switch *dsa_devlink_to_ds(struct devlink *dl)
+{
+	struct dsa_devlink_priv *dl_priv = devlink_priv(dl);
+
+	return dl_priv->ds;
+}
+
 struct dsa_switch_driver {
 	struct list_head	list;
 	const struct dsa_switch_ops *ops;
diff --git a/net/dsa/dsa.c b/net/dsa/dsa.c
index 1ce9ba8cf545..9b7019d86165 100644
--- a/net/dsa/dsa.c
+++ b/net/dsa/dsa.c
@@ -330,11 +330,7 @@ EXPORT_SYMBOL_GPL(call_dsa_notifiers);
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
@@ -346,11 +342,7 @@ EXPORT_SYMBOL_GPL(dsa_devlink_param_get);
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

