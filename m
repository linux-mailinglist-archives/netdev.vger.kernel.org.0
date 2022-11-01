Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 805B76146EF
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiKAJk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiKAJkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:40:05 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB87619021;
        Tue,  1 Nov 2022 02:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667295577; x=1698831577;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CmC8eYQReqtWDQ6BKIeRgk5XyRo4qlz24kRWLwklk98=;
  b=JjDwz3P8g1JsQ8n+Fi5R6t/jIkhg34o5Bxi6OzBmGUdgmqh94quTb9Vp
   5VbY/hrYrK3SKfIZDVcVtmNULx6MxqDqVuAx6B8EOR4+zjvXgqyh8Z1sn
   TWVX0aFrjWIBjWViFPMYVgNaqmb4EpV07zNuMSleBLxD9Y4VIQAy+tSW/
   BxvvTBydwiHUyVTpH+0rsXYEvtMOiYvAwJJxIgkEVL2sgJHn4RYLn0vhW
   r5uWcjSrstgEGv/7WPrmhv6f2783H+yUZa/JzqYuj1ccrR2B5zhk2nFAM
   CwhI4P9yd5V4zIilsM6blpm3FfjOcFVjHdOT2m7WJYsxDLvCGOAey65N3
   A==;
X-IronPort-AV: E=Sophos;i="5.95,230,1661842800"; 
   d="scan'208";a="121243187"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Nov 2022 02:39:37 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 1 Nov 2022 02:39:36 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 1 Nov 2022 02:39:33 -0700
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
Subject: [PATCH net-next v6 1/6] net: dcb: add new pcp selector to app object
Date:   Tue, 1 Nov 2022 10:48:29 +0100
Message-ID: <20221101094834.2726202-2-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221101094834.2726202-1-daniel.machon@microchip.com>
References: <20221101094834.2726202-1-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add new PCP selector for the 8021Qaz APP managed object.

As the PCP selector is not part of the 8021Qaz standard, a new non-std
extension attribute DCB_ATTR_DCB_APP has been introduced. Also two
helper functions to translate between selector and app attribute type
has been added. The new selector has been given a value of 255, to
minimize the risk of future overlap of std- and non-std attributes.

The new DCB_ATTR_DCB_APP is sent alongside the ieee std attribute in the
app table. This means that the dcb_app struct can now both contain std-
and non-std app attributes. Currently there is no overlap between the
selector values of the two attributes.

The purpose of adding the PCP selector, is to be able to offload
PCP-based queue classification to the 8021Q Priority Code Point table,
see 6.9.3 of IEEE Std 802.1Q-2018.

PCP and DEI is encoded in the protocol field as 8*dei+pcp, so that a
mapping of PCP 2 and DEI 1 to priority 3 is encoded as {255, 10, 3}.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/uapi/linux/dcbnl.h |  6 ++++
 net/dcb/dcbnl.c            | 58 +++++++++++++++++++++++++++++++++++---
 2 files changed, 60 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/dcbnl.h b/include/uapi/linux/dcbnl.h
index a791a94013a6..dc7ef96207ca 100644
--- a/include/uapi/linux/dcbnl.h
+++ b/include/uapi/linux/dcbnl.h
@@ -218,6 +218,9 @@ struct cee_pfc {
 #define IEEE_8021QAZ_APP_SEL_ANY	4
 #define IEEE_8021QAZ_APP_SEL_DSCP       5
 
+/* Non-std selector values */
+#define DCB_APP_SEL_PCP 255
+
 /* This structure contains the IEEE 802.1Qaz APP managed object. This
  * object is also used for the CEE std as well.
  *
@@ -247,6 +250,8 @@ struct dcb_app {
 	__u16	protocol;
 };
 
+#define IEEE_8021QAZ_APP_SEL_MAX 255
+
 /**
  * struct dcb_peer_app_info - APP feature information sent by the peer
  *
@@ -425,6 +430,7 @@ enum ieee_attrs {
 enum ieee_attrs_app {
 	DCB_ATTR_IEEE_APP_UNSPEC,
 	DCB_ATTR_IEEE_APP,
+	DCB_ATTR_DCB_APP,
 	__DCB_ATTR_IEEE_APP_MAX
 };
 #define DCB_ATTR_IEEE_APP_MAX (__DCB_ATTR_IEEE_APP_MAX - 1)
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index dc4fb699b56c..0c17bb28ae60 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -179,6 +179,38 @@ static const struct nla_policy dcbnl_featcfg_nest[DCB_FEATCFG_ATTR_MAX + 1] = {
 static LIST_HEAD(dcb_app_list);
 static DEFINE_SPINLOCK(dcb_lock);
 
+static enum ieee_attrs_app dcbnl_app_attr_type_get(u8 selector)
+{
+	switch (selector) {
+	case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
+	case IEEE_8021QAZ_APP_SEL_STREAM:
+	case IEEE_8021QAZ_APP_SEL_DGRAM:
+	case IEEE_8021QAZ_APP_SEL_ANY:
+	case IEEE_8021QAZ_APP_SEL_DSCP:
+		return DCB_ATTR_IEEE_APP;
+	case DCB_APP_SEL_PCP:
+		return DCB_ATTR_DCB_APP;
+	default:
+		return DCB_ATTR_IEEE_APP_UNSPEC;
+	}
+}
+
+static bool dcbnl_app_attr_type_validate(enum ieee_attrs_app type)
+{
+	switch (type) {
+	case DCB_ATTR_IEEE_APP:
+	case DCB_ATTR_DCB_APP:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static bool dcbnl_app_selector_validate(enum ieee_attrs_app type, u8 selector)
+{
+	return dcbnl_app_attr_type_get(selector) == type;
+}
+
 static struct sk_buff *dcbnl_newmsg(int type, u8 cmd, u32 port, u32 seq,
 				    u32 flags, struct nlmsghdr **nlhp)
 {
@@ -1116,8 +1148,9 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	spin_lock_bh(&dcb_lock);
 	list_for_each_entry(itr, &dcb_app_list, list) {
 		if (itr->ifindex == netdev->ifindex) {
-			err = nla_put(skb, DCB_ATTR_IEEE_APP, sizeof(itr->app),
-					 &itr->app);
+			enum ieee_attrs_app type =
+				dcbnl_app_attr_type_get(itr->app.selector);
+			err = nla_put(skb, type, sizeof(itr->app), &itr->app);
 			if (err) {
 				spin_unlock_bh(&dcb_lock);
 				return -EMSGSIZE;
@@ -1493,9 +1526,10 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 		int rem;
 
 		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
+			enum ieee_attrs_app type = nla_type(attr);
 			struct dcb_app *app_data;
 
-			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
+			if (!dcbnl_app_attr_type_validate(type))
 				continue;
 
 			if (nla_len(attr) < sizeof(struct dcb_app)) {
@@ -1504,6 +1538,13 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 			}
 
 			app_data = nla_data(attr);
+
+			if (!dcbnl_app_selector_validate(type,
+							 app_data->selector)) {
+				err = -EINVAL;
+				goto err;
+			}
+
 			if (ops->ieee_setapp)
 				err = ops->ieee_setapp(netdev, app_data);
 			else
@@ -1554,11 +1595,20 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
 		int rem;
 
 		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
+			enum ieee_attrs_app type = nla_type(attr);
 			struct dcb_app *app_data;
 
-			if (nla_type(attr) != DCB_ATTR_IEEE_APP)
+			if (!dcbnl_app_attr_type_validate(type))
 				continue;
+
 			app_data = nla_data(attr);
+
+			if (!dcbnl_app_selector_validate(type,
+							 app_data->selector)) {
+				err = -EINVAL;
+				goto err;
+			}
+
 			if (ops->ieee_delapp)
 				err = ops->ieee_delapp(netdev, app_data);
 			else
-- 
2.34.1

