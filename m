Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DEB65B9831
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 11:52:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiIOJwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 05:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbiIOJvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 05:51:35 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B8063FD
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 02:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663235375; x=1694771375;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=io1IH4Xu1EcTG4ruCCsj7kpMT7olyb6SnqA2sc/qKqI=;
  b=oydoyu39gvH2OpKDdqG5eV8EgMWbIz0RLbH8JciWmqJq6RUQ7gmVQkAZ
   B15TJQD66H4a3RauCV6qat36PUETzAb05i6th9QHdPtsI0KFeCLChVvrK
   kNgsAcMatyliG9c2qI9XrbU6v/KtwiQyhBpqHqyX7P9jnszGAZeEoAN8v
   yGAzJLSZyw/MAicujAdMDYY7n1lQrFags1Q94A1XWZS0a2zfp9PMxFzgF
   WZTh0b/6F+px4wgShxFInFmjG0CTCwvvR88q/n64bxQfaL7rrqXmBGK2l
   z7WjO0UZM4USJl2o4vqXaKG+/h95AfDcdVjY6YUE0Nx8ojaZtRvy83Vcx
   A==;
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="177279634"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2022 02:49:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 15 Sep 2022 02:49:09 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 15 Sep 2022 02:49:07 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH v2 net-next 2/2] net: dcb: add new apptrust attribute
Date:   Thu, 15 Sep 2022 11:57:57 +0200
Message-ID: <20220915095757.2861822-3-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220915095757.2861822-1-daniel.machon@microchip.com>
References: <20220915095757.2861822-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new apptrust extension attributes to the 8021Qaz APP managed
object.

Two new attributes, DCB_ATTR_DCB_APP_TRUST_TABLE and
DCB_ATTR_DCB_APP_TRUST, has been added. Trusted selectors are passed in
the nested attribute (TRUST_TABLE), in order of precedence.

The new attributes are meant to allow drivers, whose hw supports the
notion of trust, to be able to set whether a particular app selector is
to be trusted - and also the order of precedence of selectors.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/net/dcbnl.h        |  4 +++
 include/uapi/linux/dcbnl.h |  4 +++
 net/dcb/dcbnl.c            | 64 ++++++++++++++++++++++++++++++++++++--
 3 files changed, 69 insertions(+), 3 deletions(-)

diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
index 2b2d86fb3131..8841ab6c2de7 100644
--- a/include/net/dcbnl.h
+++ b/include/net/dcbnl.h
@@ -109,6 +109,10 @@ struct dcbnl_rtnl_ops {
 	/* buffer settings */
 	int (*dcbnl_getbuffer)(struct net_device *, struct dcbnl_buffer *);
 	int (*dcbnl_setbuffer)(struct net_device *, struct dcbnl_buffer *);
+
+	/* apptrust */
+	int (*dcbnl_setapptrust)(struct net_device *, u8 *, int);
+	int (*dcbnl_getapptrust)(struct net_device *, u8 *, int *);
 };
 
 #endif /* __NET_DCBNL_H__ */
diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index 8eab16e5bc13..ede72aefd88f 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -248,6 +248,8 @@ struct dcb_app {
 	__u16	protocol;
 };
 
+#define IEEE_8021QAZ_APP_SEL_MAX 255
+
 /**
  * struct dcb_peer_app_info - APP feature information sent by the peer
  *
@@ -419,6 +421,8 @@ enum ieee_attrs {
 	DCB_ATTR_IEEE_QCN,
 	DCB_ATTR_IEEE_QCN_STATS,
 	DCB_ATTR_DCB_BUFFER,
+	DCB_ATTR_DCB_APP_TRUST_TABLE,
+	DCB_ATTR_DCB_APP_TRUST,
 	__DCB_ATTR_IEEE_MAX
 };
 #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index dc4fb699b56c..6f5d2b295d09 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -166,6 +166,7 @@ static const struct nla_policy dcbnl_ieee_policy[DCB_ATTR_IEEE_MAX + 1] = {
 	[DCB_ATTR_IEEE_QCN]         = {.len = sizeof(struct ieee_qcn)},
 	[DCB_ATTR_IEEE_QCN_STATS]   = {.len = sizeof(struct ieee_qcn_stats)},
 	[DCB_ATTR_DCB_BUFFER]       = {.len = sizeof(struct dcbnl_buffer)},
+	[DCB_ATTR_DCB_APP_TRUST_TABLE] = {.type = NLA_NESTED},
 };
 
 /* DCB number of traffic classes nested attributes. */
@@ -1030,11 +1031,11 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
 /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
 static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 {
-	struct nlattr *ieee, *app;
+	struct nlattr *ieee, *app, *apptrust;
 	struct dcb_app_type *itr;
 	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
 	int dcbx;
-	int err;
+	int err, i;
 
 	if (nla_put_string(skb, DCB_ATTR_IFNAME, netdev->name))
 		return -EMSGSIZE;
@@ -1133,6 +1134,24 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	spin_unlock_bh(&dcb_lock);
 	nla_nest_end(skb, app);
 
+	if (ops->dcbnl_getapptrust) {
+		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
+		int nselectors;
+
+		apptrust = nla_nest_start_noflag(skb,
+						 DCB_ATTR_DCB_APP_TRUST_TABLE);
+		if (!app)
+			return -EMSGSIZE;
+
+		err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
+		if (err)
+			return -EMSGSIZE;
+
+		for (i = 0; i < nselectors; i++)
+			nla_put_u8(skb, DCB_ATTR_DCB_APP_TRUST, selectors[i]);
+		nla_nest_end(skb, apptrust);
+	}
+
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
@@ -1427,7 +1446,7 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
 	struct nlattr *ieee[DCB_ATTR_IEEE_MAX + 1];
 	int prio;
-	int err;
+	int err, i;
 
 	if (!ops)
 		return -EOPNOTSUPP;
@@ -1513,6 +1532,45 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 		}
 	}
 
+	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
+		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
+		struct nlattr *attr;
+		int nselectors = 0;
+		u8 selector;
+
+		int rem;
+
+		if (!ops->dcbnl_setapptrust) {
+			err = -EOPNOTSUPP;
+			goto err;
+		}
+
+		nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TABLE],
+				    rem) {
+			if (nla_type(attr) != DCB_ATTR_DCB_APP_TRUST ||
+			    nla_len(attr) != 1 ||
+			    nselectors >= sizeof(selectors)) {
+				err = -EINVAL;
+				goto err;
+			}
+
+			selector = nla_get_u8(attr);
+			/* Duplicate selector ? */
+			for (i = 0; i < nselectors; i++) {
+				if (selectors[i] == selector) {
+					err = -EINVAL;
+					goto err;
+				}
+			}
+
+			selectors[nselectors++] = selector;
+		}
+
+		err = ops->dcbnl_setapptrust(netdev, selectors, nselectors);
+		if (err)
+			goto err;
+	}
+
 err:
 	err = nla_put_u8(skb, DCB_ATTR_IEEE, err);
 	dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, seq, 0);
-- 
2.34.1

