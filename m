Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A12611237
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiJ1NEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiJ1NEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:04:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04DB63BD;
        Fri, 28 Oct 2022 06:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666962283; x=1698498283;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yuaZtzldNYKAWOQfEZAb5+0OMaFaC28v7Or0OmMKOsY=;
  b=hm2jqdBrMY7UZACOw+NRBYjFpJ/+Bx04lyk5gbPaapNR3XlMsw5kYDLG
   qNCfPEB/0qEzs+8aDKAdjx5q46MMwzKoXCmLPJeDcarBbYSSPj9HKp67A
   tLWBLBNc57In965v4zw673UQYq4WLpT2LSLEBnYvbGNBDWlb0y0aV5N95
   Kl1bYSoChXyiqTxBlwlrkVyhcbDh6Mz+1By+yyfvUnjcXHh3Vdj/v0qmS
   aKIJHneyGV0fqaCCwWE9ZbOtUco1JPAlaj9zj5W5euxBChJeEoPDV1dx9
   H7ggU+FD9UefSfb/C/q3nenCo84KlWXe5Ig9tvoyjrWPXs57IYqVI/ZJL
   w==;
X-IronPort-AV: E=Sophos;i="5.95,221,1661842800"; 
   d="scan'208";a="186698439"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2022 06:04:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 28 Oct 2022 06:04:39 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Fri, 28 Oct 2022 06:04:36 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <lars.povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <daniel.machon@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <joe@perches.com>, <linux@armlinux.org.uk>,
        <horatiu.vultur@microchip.com>, <Julia.Lawall@inria.fr>,
        <vladimir.oltean@nxp.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v5 2/6] net: dcb: add new apptrust attribute
Date:   Fri, 28 Oct 2022 15:13:59 +0200
Message-ID: <20221028131403.1055694-3-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028131403.1055694-1-daniel.machon@microchip.com>
References: <20221028131403.1055694-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new apptrust extension attributes to the 8021Qaz APP managed object.

Two new attributes, DCB_ATTR_DCB_APP_TRUST_TABLE and
DCB_ATTR_DCB_APP_TRUST, has been added. Trusted selectors are passed in
the nested attribute DCB_ATTR_DCB_APP_TRUST, in order of precedence.

The new attributes are meant to allow drivers, whose hw supports the
notion of trust, to be able to set whether a particular app selector is
trusted - and in which order.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/net/dcbnl.h        |  4 ++
 include/uapi/linux/dcbnl.h | 10 +++++
 net/dcb/dcbnl.c            | 78 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 90 insertions(+), 2 deletions(-)

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
index dc7ef96207ca..9344e3ba5768 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -410,6 +410,7 @@ enum dcbnl_attrs {
  * @DCB_ATTR_IEEE_PEER_ETS: peer ETS configuration - get only
  * @DCB_ATTR_IEEE_PEER_PFC: peer PFC configuration - get only
  * @DCB_ATTR_IEEE_PEER_APP: peer APP tlv - get only
+ * @DCB_ATTR_DCB_APP_TRUST_TABLE: selector trust table
  */
 enum ieee_attrs {
 	DCB_ATTR_IEEE_UNSPEC,
@@ -423,6 +424,7 @@ enum ieee_attrs {
 	DCB_ATTR_IEEE_QCN,
 	DCB_ATTR_IEEE_QCN_STATS,
 	DCB_ATTR_DCB_BUFFER,
+	DCB_ATTR_DCB_APP_TRUST_TABLE,
 	__DCB_ATTR_IEEE_MAX
 };
 #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
@@ -435,6 +437,14 @@ enum ieee_attrs_app {
 };
 #define DCB_ATTR_IEEE_APP_MAX (__DCB_ATTR_IEEE_APP_MAX - 1)
 
+enum dcbnl_attrs_apptrust {
+	DCB_ATTR_DCB_APP_TRUST_UNSPEC,
+	DCB_ATTR_DCB_APP_TRUST,
+	__DCB_ATTR_DCB_APP_TRUST_MAX
+};
+
+#define DCB_ATTR_DCB_APP_TRUST_MAX (__DCB_ATTR_DCB_APP_TRUST_MAX - 1)
+
 /**
  * enum cee_attrs - CEE DCBX get attributes.
  *
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 68e033a459af..a56f401aeec4 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -166,6 +166,7 @@ static const struct nla_policy dcbnl_ieee_policy[DCB_ATTR_IEEE_MAX + 1] = {
 	[DCB_ATTR_IEEE_QCN]         = {.len = sizeof(struct ieee_qcn)},
 	[DCB_ATTR_IEEE_QCN_STATS]   = {.len = sizeof(struct ieee_qcn_stats)},
 	[DCB_ATTR_DCB_BUFFER]       = {.len = sizeof(struct dcbnl_buffer)},
+	[DCB_ATTR_DCB_APP_TRUST_TABLE] = {.type = NLA_NESTED},
 };
 
 /* DCB number of traffic classes nested attributes. */
@@ -1081,9 +1082,9 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
 /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
 static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 {
-	struct nlattr *ieee, *app;
-	struct dcb_app_type *itr;
 	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
+	struct nlattr *ieee, *app, *apptrust;
+	struct dcb_app_type *itr;
 	int dcbx;
 	int err;
 
@@ -1185,6 +1186,29 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	spin_unlock_bh(&dcb_lock);
 	nla_nest_end(skb, app);
 
+	if (ops->dcbnl_getapptrust) {
+		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
+		int nselectors, i;
+
+		apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
+		if (!app)
+			return -EMSGSIZE;
+
+		err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
+		if (!err) {
+			for (i = 0; i < nselectors; i++) {
+				err = nla_put_u8(skb, DCB_ATTR_DCB_APP_TRUST,
+						 selectors[i]);
+				if (err) {
+					nla_nest_cancel(skb, apptrust);
+					return err;
+				}
+			}
+		}
+
+		nla_nest_end(skb, apptrust);
+	}
+
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
@@ -1571,6 +1595,56 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 		}
 	}
 
+	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
+		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
+		struct nlattr *attr;
+		int nselectors = 0;
+		u8 selector;
+		int rem, i;
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
+			switch (selector) {
+			case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+			case IEEE_8021QAZ_APP_SEL_STREAM:
+			case IEEE_8021QAZ_APP_SEL_DGRAM:
+			case IEEE_8021QAZ_APP_SEL_ANY:
+			case IEEE_8021QAZ_APP_SEL_DSCP:
+			case DCB_APP_SEL_PCP:
+				break;
+			default:
+				err = -EINVAL;
+				goto err;
+			}
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

