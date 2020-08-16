Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDE8245968
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 21:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729802AbgHPToT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 15:44:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55446 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729117AbgHPToB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 16 Aug 2020 15:44:01 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k7OZS-009c9F-8R; Sun, 16 Aug 2020 21:43:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 6/7] net: dsa: wire up devlink info get
Date:   Sun, 16 Aug 2020 21:43:15 +0200
Message-Id: <20200816194316.2291489-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200816194316.2291489-1-andrew@lunn.ch>
References: <20200816194316.2291489-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the DSA drivers to implement the devlink call to get info info,
e.g. driver name, firmware version, ASIC ID, etc.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |  5 ++++-
 net/dsa/dsa2.c    | 21 ++++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8963440ec7f8..0e34193d15ba 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -612,11 +612,14 @@ struct dsa_switch_ops {
 	bool	(*port_rxtstamp)(struct dsa_switch *ds, int port,
 				 struct sk_buff *skb, unsigned int type);
 
-	/* Devlink parameters */
+	/* Devlink parameters, etc */
 	int	(*devlink_param_get)(struct dsa_switch *ds, u32 id,
 				     struct devlink_param_gset_ctx *ctx);
 	int	(*devlink_param_set)(struct dsa_switch *ds, u32 id,
 				     struct devlink_param_gset_ctx *ctx);
+	int	(*devlink_info_get)(struct dsa_switch *ds,
+				    struct devlink_info_req *req,
+				    struct netlink_ext_ack *extack);
 
 	/*
 	 * MTU change functionality. Switches can also adjust their MRU through
diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index c0ffc7a2b65f..860f2fb22fe0 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -21,9 +21,6 @@
 static DEFINE_MUTEX(dsa2_mutex);
 LIST_HEAD(dsa_tree_list);
 
-static const struct devlink_ops dsa_devlink_ops = {
-};
-
 struct dsa_switch *dsa_switch_find(int tree_index, int sw_index)
 {
 	struct dsa_switch_tree *dst;
@@ -382,6 +379,24 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	dp->setup = false;
 }
 
+static int dsa_devlink_info_get(struct devlink *dl,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds;
+
+	ds = dsa_devlink_to_ds(dl);
+
+	if (ds->ops->devlink_info_get)
+		return ds->ops->devlink_info_get(ds, req, extack);
+
+	return -EOPNOTSUPP;
+}
+
+static const struct devlink_ops dsa_devlink_ops = {
+	.info_get = dsa_devlink_info_get,
+};
+
 static int dsa_switch_setup(struct dsa_switch *ds)
 {
 	struct dsa_devlink_priv *dl_priv;
-- 
2.28.0

