Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A11286729FA
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjARVJF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:09:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbjARVI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:08:59 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3213B5A806;
        Wed, 18 Jan 2023 13:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674076139; x=1705612139;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R7RD0vBu6yv4Ibxs7cO5E9IxkAxGDPNK+NtovwaTeTQ=;
  b=s95Mtf5ZD7443hBcWh+jkBrZnOVd9eCn+jz20fCrKzQEWhhAdhUdAXlQ
   GxrT1avlNThbrfYAfTP6y5F9ocA+7cLYMXNcIbhxcRkaHA3S5Nr7HFRvW
   HdjO66/p/KEkjdl8XqolvMwa9UOLKtIRS/bw86WVxgXItWeJwh3B7q/y6
   cGy2kaGsceYjGNE/dFPTW4JjprXiAA/EurXEMVr936wcEGkgTFqrO440x
   e1uuUVmgO1kG3FW1Fr4ZdR+1Um6Wc+behYdiQPHT2a5YTNyJgkkzDszgL
   HvPmczRN4G4b8/94pCxlcqQliRB6h32BFWUydQaTS7W4xkXVdh73tBFDf
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="197370536"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 14:08:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 14:08:55 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 14:08:52 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <horatiu.vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <petrm@nvidia.com>,
        <vladimir.oltean@nxp.com>, <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next v3 3/6] net: dcb: add new rewrite table
Date:   Wed, 18 Jan 2023 22:08:27 +0100
Message-ID: <20230118210830.2287069-4-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230118210830.2287069-1-daniel.machon@microchip.com>
References: <20230118210830.2287069-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new rewrite table and all the required functions, offload hooks and
bookkeeping for maintaining it. The rewrite table reuses the app struct,
and the entire set of app selectors. As such, some bookeeping code can
be shared between the rewrite- and the APP table.

New functions for getting, setting and deleting entries has been added.
Apart from operating on the rewrite list, these functions do not emit a
DCB_APP_EVENT when the list os modified. The new dcb_getrewr does a
lookup based on selector and priority and returns the protocol, so that
mappings from priority to protocol, for a given selector and ifindex is
obtained.

Also, a new nested attribute has been added, that encapsulates one or
more app structs. This attribute is used to distinguish the two tables.

The dcb_lock used for the APP table is reused for the rewrite table.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/net/dcbnl.h        |   8 +++
 include/uapi/linux/dcbnl.h |   2 +
 net/dcb/dcbnl.c            | 113 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 122 insertions(+), 1 deletion(-)

diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
index 8841ab6c2de7..fe7dfb8bcb5b 100644
--- a/include/net/dcbnl.h
+++ b/include/net/dcbnl.h
@@ -19,6 +19,10 @@ struct dcb_app_type {
 	u8	dcbx;
 };
 
+u16 dcb_getrewr(struct net_device *dev, struct dcb_app *app);
+int dcb_setrewr(struct net_device *dev, struct dcb_app *app);
+int dcb_delrewr(struct net_device *dev, struct dcb_app *app);
+
 int dcb_setapp(struct net_device *, struct dcb_app *);
 u8 dcb_getapp(struct net_device *, struct dcb_app *);
 int dcb_ieee_setapp(struct net_device *, struct dcb_app *);
@@ -113,6 +117,10 @@ struct dcbnl_rtnl_ops {
 	/* apptrust */
 	int (*dcbnl_setapptrust)(struct net_device *, u8 *, int);
 	int (*dcbnl_getapptrust)(struct net_device *, u8 *, int *);
+
+	/* rewrite */
+	int (*dcbnl_setrewr)(struct net_device *dev, struct dcb_app *app);
+	int (*dcbnl_delrewr)(struct net_device *dev, struct dcb_app *app);
 };
 
 #endif /* __NET_DCBNL_H__ */
diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index 99047223ab26..7e15214aa5dd 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -411,6 +411,7 @@ enum dcbnl_attrs {
  * @DCB_ATTR_IEEE_PEER_PFC: peer PFC configuration - get only
  * @DCB_ATTR_IEEE_PEER_APP: peer APP tlv - get only
  * @DCB_ATTR_DCB_APP_TRUST_TABLE: selector trust table
+ * @DCB_ATTR_DCB_REWR_TABLE: rewrite configuration
  */
 enum ieee_attrs {
 	DCB_ATTR_IEEE_UNSPEC,
@@ -425,6 +426,7 @@ enum ieee_attrs {
 	DCB_ATTR_IEEE_QCN_STATS,
 	DCB_ATTR_DCB_BUFFER,
 	DCB_ATTR_DCB_APP_TRUST_TABLE,
+	DCB_ATTR_DCB_REWR_TABLE,
 	__DCB_ATTR_IEEE_MAX
 };
 #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index cb5319c6afe6..2ca7fffcf069 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -178,6 +178,7 @@ static const struct nla_policy dcbnl_featcfg_nest[DCB_FEATCFG_ATTR_MAX + 1] = {
 };
 
 static LIST_HEAD(dcb_app_list);
+static LIST_HEAD(dcb_rewr_list);
 static DEFINE_SPINLOCK(dcb_lock);
 
 static enum ieee_attrs_app dcbnl_app_attr_type_get(u8 selector)
@@ -1138,7 +1139,7 @@ static int dcbnl_app_table_setdel(struct nlattr *attr,
 static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 {
 	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
-	struct nlattr *ieee, *app;
+	struct nlattr *ieee, *app, *rewr;
 	struct dcb_app_type *itr;
 	int dcbx;
 	int err;
@@ -1241,6 +1242,27 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	spin_unlock_bh(&dcb_lock);
 	nla_nest_end(skb, app);
 
+	rewr = nla_nest_start(skb, DCB_ATTR_DCB_REWR_TABLE);
+	if (!rewr)
+		return -EMSGSIZE;
+
+	spin_lock_bh(&dcb_lock);
+	list_for_each_entry(itr, &dcb_rewr_list, list) {
+		if (itr->ifindex == netdev->ifindex) {
+			enum ieee_attrs_app type =
+				dcbnl_app_attr_type_get(itr->app.selector);
+			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
+			if (err) {
+				spin_unlock_bh(&dcb_lock);
+				nla_nest_cancel(skb, rewr);
+				return -EMSGSIZE;
+			}
+		}
+	}
+
+	spin_unlock_bh(&dcb_lock);
+	nla_nest_end(skb, rewr);
+
 	if (ops->dcbnl_getapptrust) {
 		err = dcbnl_getapptrust(netdev, skb);
 		if (err)
@@ -1602,6 +1624,14 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 			goto err;
 	}
 
+	if (ieee[DCB_ATTR_DCB_REWR_TABLE]) {
+		err = dcbnl_app_table_setdel(ieee[DCB_ATTR_DCB_REWR_TABLE],
+					     netdev,
+					     ops->dcbnl_setrewr ?: dcb_setrewr);
+		if (err)
+			goto err;
+	}
+
 	if (ieee[DCB_ATTR_IEEE_APP_TABLE]) {
 		err = dcbnl_app_table_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
 					     netdev, ops->ieee_setapp ?:
@@ -1701,6 +1731,14 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
 			goto err;
 	}
 
+	if (ieee[DCB_ATTR_DCB_REWR_TABLE]) {
+		err = dcbnl_app_table_setdel(ieee[DCB_ATTR_DCB_REWR_TABLE],
+					     netdev,
+					     ops->dcbnl_delrewr ?: dcb_delrewr);
+		if (err)
+			goto err;
+	}
+
 err:
 	err = nla_put_u8(skb, DCB_ATTR_IEEE, err);
 	dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_DEL, seq, 0);
@@ -1929,6 +1967,22 @@ static int dcb_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
+static struct dcb_app_type *dcb_rewr_lookup(const struct dcb_app *app,
+					    int ifindex, int proto)
+{
+	struct dcb_app_type *itr;
+
+	list_for_each_entry(itr, &dcb_rewr_list, list) {
+		if (itr->app.selector == app->selector &&
+		    itr->app.priority == app->priority &&
+		    itr->ifindex == ifindex &&
+		    ((proto == -1) || itr->app.protocol == proto))
+			return itr;
+	}
+
+	return NULL;
+}
+
 static struct dcb_app_type *dcb_app_lookup(const struct dcb_app *app,
 					   int ifindex, int prio)
 {
@@ -2052,6 +2106,63 @@ u8 dcb_ieee_getapp_mask(struct net_device *dev, struct dcb_app *app)
 }
 EXPORT_SYMBOL(dcb_ieee_getapp_mask);
 
+/* Get protocol value from rewrite entry. */
+u16 dcb_getrewr(struct net_device *dev, struct dcb_app *app)
+{
+	struct dcb_app_type *itr;
+	u16 proto = 0;
+
+	spin_lock_bh(&dcb_lock);
+	itr = dcb_rewr_lookup(app, dev->ifindex, -1);
+	if (itr)
+		proto = itr->app.protocol;
+	spin_unlock_bh(&dcb_lock);
+
+	return proto;
+}
+EXPORT_SYMBOL(dcb_getrewr);
+
+ /* Add rewrite entry to the rewrite list. */
+int dcb_setrewr(struct net_device *dev, struct dcb_app *new)
+{
+	int err;
+
+	spin_lock_bh(&dcb_lock);
+	/* Search for existing match and abort if found. */
+	if (dcb_rewr_lookup(new, dev->ifindex, new->protocol)) {
+		err = -EEXIST;
+		goto out;
+	}
+
+	err = dcb_app_add(&dcb_rewr_list, new, dev->ifindex);
+out:
+	spin_unlock_bh(&dcb_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(dcb_setrewr);
+
+/* Delete rewrite entry from the rewrite list. */
+int dcb_delrewr(struct net_device *dev, struct dcb_app *del)
+{
+	struct dcb_app_type *itr;
+	int err = -ENOENT;
+
+	spin_lock_bh(&dcb_lock);
+	/* Search for existing match and remove it. */
+	itr = dcb_rewr_lookup(del, dev->ifindex, del->protocol);
+	if (itr) {
+		list_del(&itr->list);
+		kfree(itr);
+		err = 0;
+	}
+
+	spin_unlock_bh(&dcb_lock);
+
+	return err;
+}
+EXPORT_SYMBOL(dcb_delrewr);
+
 /**
  * dcb_ieee_setapp - add IEEE dcb application data to app list
  * @dev: network interface
-- 
2.34.1

