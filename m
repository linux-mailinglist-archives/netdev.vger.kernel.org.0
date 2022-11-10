Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1204C623EB9
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 10:36:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbiKJJgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 04:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKJJgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 04:36:45 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0FB267F60;
        Thu, 10 Nov 2022 01:36:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668073004; x=1699609004;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bZGinb1GlB+jVorOK6luSyiTkDtoV7cUYIIAN1FmgDQ=;
  b=e09k7bYG1C0/HJLdkFipjO67rgXaEyKiZfASTWz37A2yA7trbPyTkh7l
   FR2BnlwcAxMFf+QRgI7VkrRZxUrPQBHyVnuJ+T3zVUVv038cDuehAT+wf
   uzxqwdTI4lXdrFduj6bpWs2Rb3lgmgb/Gc+68DLo6933PkBm7YaKuvCzw
   yXsA9RSy0PG/h8isyrtuY5RlZH+Kyp0JpFrbM0PHlb4lW8PGxnu4fpRh6
   UswcRjX97cjmc0t782CR/CK4DIH22uBD3RH4WxEgbIxv/aQHwP2U65We7
   O/Mu/PJFpdFD3tGDoat6dJpPHNG80dZh6MHkhcPsqvGB0xzGDcu2Sv5UK
   A==;
X-IronPort-AV: E=Sophos;i="5.96,153,1665471600"; 
   d="scan'208";a="188462126"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Nov 2022 02:36:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 10 Nov 2022 02:36:43 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Thu, 10 Nov 2022 02:36:41 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <joe@perches.com>,
        <daniel.machon@microchip.com>, <vladimir.oltean@nxp.com>,
        <petrm@nvidia.com>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, "kernel test robot" <lkp@intel.com>
Subject: [PATCH net-next] net: dcb: move getapptrust to separate function
Date:   Thu, 10 Nov 2022 10:46:23 +0100
Message-ID: <20221110094623.3395670-1-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
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

This patch fixes a frame size warning, reported by kernel test robot.

>> net/dcb/dcbnl.c:1230:1: warning: the frame size of 1244 bytes is
>> larger than 1024 bytes [-Wframe-larger-than=]

The getapptrust part of dcbnl_ieee_fill is moved to a separate function,
and the selector array is now dynamically allocated, instead of stack
allocated.

Tested on microchip sparx5 driver.

Fixes: 6182d5875c33 ("net: dcb: add new apptrust attribute")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 net/dcb/dcbnl.c | 67 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 45 insertions(+), 22 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index cec0632f96db..3f4d88c1ec78 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1060,11 +1060,52 @@ static int dcbnl_build_peer_app(struct net_device *netdev, struct sk_buff* skb,
 	return err;
 }
 
+static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
+{
+	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
+	int nselectors, err;
+	u8 *selectors;
+
+	selectors = kzalloc(IEEE_8021QAZ_APP_SEL_MAX + 1, GFP_KERNEL);
+	if (!selectors)
+		return -ENOMEM;
+
+	err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
+
+	if (!err) {
+		struct nlattr *apptrust;
+		int i;
+
+		err = -EMSGSIZE;
+
+		apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
+		if (!apptrust)
+			goto nla_put_failure;
+
+		for (i = 0; i < nselectors; i++) {
+			enum ieee_attrs_app type =
+				dcbnl_app_attr_type_get(selectors[i]);
+			err = nla_put_u8(skb, type, selectors[i]);
+			if (err) {
+				nla_nest_cancel(skb, apptrust);
+				goto nla_put_failure;
+			}
+		}
+		nla_nest_end(skb, apptrust);
+	}
+
+	err = 0;
+
+nla_put_failure:
+	kfree(selectors);
+	return err;
+}
+
 /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
 static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 {
 	const struct dcbnl_rtnl_ops *ops = netdev->dcbnl_ops;
-	struct nlattr *ieee, *app, *apptrust;
+	struct nlattr *ieee, *app;
 	struct dcb_app_type *itr;
 	int dcbx;
 	int err;
@@ -1168,27 +1209,9 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	nla_nest_end(skb, app);
 
 	if (ops->dcbnl_getapptrust) {
-		u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] = {0};
-		int nselectors, i;
-
-		apptrust = nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_TABLE);
-		if (!apptrust)
-			return -EMSGSIZE;
-
-		err = ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
-		if (!err) {
-			for (i = 0; i < nselectors; i++) {
-				enum ieee_attrs_app type =
-					dcbnl_app_attr_type_get(selectors[i]);
-				err = nla_put_u8(skb, type, selectors[i]);
-				if (err) {
-					nla_nest_cancel(skb, apptrust);
-					return err;
-				}
-			}
-		}
-
-		nla_nest_end(skb, apptrust);
+		err = dcbnl_getapptrust(netdev, skb);
+		if (err)
+			return err;
 	}
 
 	/* get peer info if available */
-- 
2.34.1

