Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AB12607D7
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728235AbgIHAw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:52:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:48782 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728213AbgIHAwW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:52:22 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kFRro-00Di6P-Fp; Tue, 08 Sep 2020 02:52:12 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 6/7] net: dsa: wire up devlink info get
Date:   Tue,  8 Sep 2020 02:51:54 +0200
Message-Id: <20200908005155.3267736-7-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200908005155.3267736-1-andrew@lunn.ch>
References: <20200908005155.3267736-1-andrew@lunn.ch>
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

