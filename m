Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE86D263AD8
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 04:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIJCAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 22:00:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729779AbgIJBnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 21:43:10 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kG9z5-00Dzpf-Vq; Thu, 10 Sep 2020 01:58:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH v3 net-next 8/9] net: dsa: wire up devlink info get
Date:   Thu, 10 Sep 2020 01:58:26 +0200
Message-Id: <20200909235827.3335881-9-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200909235827.3335881-1-andrew@lunn.ch>
References: <20200909235827.3335881-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow the DSA drivers to implement the devlink call to get info info,
e.g. driver name, firmware version, ASIC ID, etc.

v2:
Combine declaration and the assignment on a single line.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 include/net/dsa.h |  5 ++++-
 net/dsa/dsa2.c    | 19 ++++++++++++++++---
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 431efb5098be..d16057c5987a 100644
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
index c0ffc7a2b65f..3cf67f5fe54a 100644
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
@@ -382,6 +379,22 @@ static void dsa_port_teardown(struct dsa_port *dp)
 	dp->setup = false;
 }
 
+static int dsa_devlink_info_get(struct devlink *dl,
+				struct devlink_info_req *req,
+				struct netlink_ext_ack *extack)
+{
+	struct dsa_switch *ds = dsa_devlink_to_ds(dl);
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

