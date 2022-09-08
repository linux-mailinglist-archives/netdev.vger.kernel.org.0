Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E54285B1BFB
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 13:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiIHL4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 07:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiIHL4c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 07:56:32 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CACCC11C7D8
        for <netdev@vger.kernel.org>; Thu,  8 Sep 2022 04:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662638190; x=1694174190;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nz5lGJrIKdCt44rewfthJovmwG5wWfP1w5/XeB3EdhM=;
  b=x4TwSy9H7AsANnDa/ZuYvo9tCK+oxbOEmVUzq2P1snLLcvL8t591vbA/
   hAITliyp4XniAf2ZMUTAs4szFtHeYWuybK0C2lTTOxEr+ygRrCgOz8B8O
   3/CJw8cqDNYTVevRZgghP0KakfwbrSoJUVKfM/403VoRoTlOTbUQyrMz/
   f0M3ZyLYQzrZkHKmwqNTFkOa1hgaIA5zWebjj7wUe3xgehy1w4Qa1wmgi
   HQtvrFBDv05sRlISXB74zapUs5ay3C4jmyWNVhTU2N9DeasBit3G2FkwP
   mDZRetMSUe9A2iobBRPDgnUtbbdSvL+EXNPpLomZFthitFs51aRIy/CLW
   g==;
X-IronPort-AV: E=Sophos;i="5.93,300,1654585200"; 
   d="scan'208";a="112728453"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Sep 2022 04:56:30 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 8 Sep 2022 04:56:25 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 8 Sep 2022 04:56:24 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <Allan.Nielsen@microchip.com>, <UNGLinuxDriver@microchip.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <kuba@kernel.org>, <vinicius.gomes@intel.com>,
        <thomas.petazzoni@bootlin.com>,
        Daniel Machon <daniel.machon@microchip.com>
Subject: [RFC PATCH net-next 2/2] net: dcb: add new apptrust attribute
Date:   Thu, 8 Sep 2022 14:04:42 +0200
Message-ID: <20220908120442.3069771-3-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220908120442.3069771-1-daniel.machon@microchip.com>
References: <20220908120442.3069771-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a new apptrust extension attribute to the 8021Qaz APP managed
object.

The new attribute is meant to allow drivers, whose hw supports the
notion of trust, to be able to set whether a particular app selector is
to be trusted - and also the order of precedence of selectors.

A new structure ieee_apptrust has been created, which contains an array
of selectors, where lower indexes has higher precedence.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/net/dcbnl.h        |  2 ++
 include/uapi/linux/dcbnl.h | 14 ++++++++++++++
 net/dcb/dcbnl.c            | 17 +++++++++++++++++
 3 files changed, 33 insertions(+)

diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
index 2b2d86fb3131..0c4b0107981d 100644
--- a/include/net/dcbnl.h
+++ b/include/net/dcbnl.h
@@ -61,6 +61,8 @@ struct dcbnl_rtnl_ops {
 	int (*ieee_getapp) (struct net_device *, struct dcb_app *);
 	int (*ieee_setapp) (struct net_device *, struct dcb_app *);
 	int (*ieee_delapp) (struct net_device *, struct dcb_app *);
+	int (*ieee_setapptrust)  (struct net_device *, struct ieee_apptrust *);
+	int (*ieee_getapptrust)  (struct net_device *, struct ieee_apptrust *);
 	int (*ieee_peer_getets) (struct net_device *, struct ieee_ets *);
 	int (*ieee_peer_getpfc) (struct net_device *, struct ieee_pfc *);
 
diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index 8eab16e5bc13..833466dec096 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -248,6 +248,19 @@ struct dcb_app {
 	__u16	protocol;
 };
 
+#define IEEE_8021QAZ_APP_SEL_MAX 255
+
+/* This structure contains trust order extension to the IEEE 802.1Qaz APP
+ * managed object.
+ *
+ * @order: contains trust ordering of selector values for the IEEE 802.1Qaz
+ *               APP managed object. Lower indexes has higher trust.
+ */
+struct ieee_apptrust {
+	__u8 num;
+	__u8 order[IEEE_8021QAZ_APP_SEL_MAX];
+};
+
 /**
  * struct dcb_peer_app_info - APP feature information sent by the peer
  *
@@ -419,6 +432,7 @@ enum ieee_attrs {
 	DCB_ATTR_IEEE_QCN,
 	DCB_ATTR_IEEE_QCN_STATS,
 	DCB_ATTR_DCB_BUFFER,
+	DCB_ATTR_IEEE_APP_TRUST,
 	__DCB_ATTR_IEEE_MAX
 };
 #define DCB_ATTR_IEEE_MAX (__DCB_ATTR_IEEE_MAX - 1)
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index dc4fb699b56c..e87f0128c3bd 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -162,6 +162,7 @@ static const struct nla_policy dcbnl_ieee_policy[DCB_ATTR_IEEE_MAX + 1] = {
 	[DCB_ATTR_IEEE_ETS]	    = {.len = sizeof(struct ieee_ets)},
 	[DCB_ATTR_IEEE_PFC]	    = {.len = sizeof(struct ieee_pfc)},
 	[DCB_ATTR_IEEE_APP_TABLE]   = {.type = NLA_NESTED},
+	[DCB_ATTR_IEEE_APP_TRUST]   = {.len = sizeof(struct ieee_apptrust)},
 	[DCB_ATTR_IEEE_MAXRATE]   = {.len = sizeof(struct ieee_maxrate)},
 	[DCB_ATTR_IEEE_QCN]         = {.len = sizeof(struct ieee_qcn)},
 	[DCB_ATTR_IEEE_QCN_STATS]   = {.len = sizeof(struct ieee_qcn_stats)},
@@ -1133,6 +1134,14 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	spin_unlock_bh(&dcb_lock);
 	nla_nest_end(skb, app);
 
+	if (ops->ieee_getapptrust) {
+		struct ieee_apptrust trust;
+		memset(&trust, 0, sizeof(trust));
+		err = ops->ieee_getapptrust(netdev, &trust);
+		if (!err && nla_put(skb, DCB_ATTR_IEEE_APP_TRUST, sizeof(trust), &trust))
+			return -EMSGSIZE;
+	}
+
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
@@ -1513,6 +1522,14 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 		}
 	}
 
+	if (ieee[DCB_ATTR_IEEE_APP_TRUST] && ops->ieee_setapptrust) {
+		struct ieee_apptrust *trust =
+			nla_data(ieee[DCB_ATTR_IEEE_APP_TRUST]);
+		err = ops->ieee_setapptrust(netdev, trust);
+		if (err)
+			goto err;
+	}
+
 err:
 	err = nla_put_u8(skb, DCB_ATTR_IEEE, err);
 	dcbnl_ieee_notify(netdev, RTM_SETDCB, DCB_CMD_IEEE_SET, seq, 0);
-- 
2.34.1

