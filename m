Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980BE6683FD
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:15:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbjALUPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:15:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240800AbjALUNq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:13:46 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43FB74882A;
        Thu, 12 Jan 2023 12:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673553842; x=1705089842;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dnABJ1HlYwLvumPfQ3KWGTUNUjlqesGWo6zqCVDasaI=;
  b=2amy3ov0oE4Twb334BJk7vfnfM2XcL9Ax4HvsqZuZX/YZnCdstxGe1qp
   g/QxlU2ZOFBpgZySQxPIr2qf/eBqa+36V0oRsgDkPvmyU2TIQKBt8vgrF
   +Wz/6j6wpsAp/6CQ8KA7iPIFWTgGCqVh9kHIj+YLvFO2FQfX0FeZF/hZo
   r3c/RWWUBaMryE3QgECoAGZQ3K7IjnWF5NKBJMmmvZSPlfm6suZUXyGPy
   4b7DjJ+PWTAEC4F0s2ckGJxpz23/NvE6HEtMMPQ1dAee2miVEWUJbKetz
   z6VNgaW3m6SubRTkDXwqy9/AD2xDmkOIok7BQPxZ9o5JdIPuDKSYwZqL6
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669100400"; 
   d="scan'208";a="207544205"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2023 13:03:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 13:03:58 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 13:03:55 -0700
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
Subject: [PATCH net-next 2/6] net: dcb: add new common function for set/del of app/rewr entries
Date:   Thu, 12 Jan 2023 21:15:50 +0100
Message-ID: <20230112201554.752144-3-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230112201554.752144-1-daniel.machon@microchip.com>
References: <20230112201554.752144-1-daniel.machon@microchip.com>
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

In preparation for DCB rewrite. Add a new function for setting and
deleting both app and rewrite entries. Moving this into a separate
function reduces duplicate code, as both type of entries requires the
same set of checks. The function will now iterate through a configurable
nested attribute (app or rewrite attr), validate each attribute and call
the appropriate set- or delete function.

Note that this function always checks for nla_len(attr_itr) <
sizeof(struct dcb_app), which was only done in dcbnl_ieee_set and not in
dcbnl_ieee_del prior to this patch. This means, that any userspace tool
that used to shove in data < sizeof(struct dcb_app) would now receive
-ERANGE.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 net/dcb/dcbnl.c | 104 +++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 55 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index a76bdf6f0198..6d19564e19a8 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1099,6 +1099,45 @@ static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
 	return err;
 }
 
+/* Set or delete APP table or rewrite table entries. The APP struct is validated
+ * and the appropriate callback function is called.
+ */
+static int dcbnl_apprewr_setdel(struct nlattr *attr, struct net_device *netdev,
+				int (*setdel)(struct net_device *dev,
+					      struct dcb_app *app),
+				int (*ops_setdel)(struct net_device *dev,
+						  struct dcb_app *app))
+{
+	struct dcb_app *app_data;
+	enum ieee_attrs_app type;
+	struct nlattr *attr_itr;
+	int rem, err;
+
+	nla_for_each_nested(attr_itr, attr, rem) {
+		type = nla_type(attr_itr);
+
+		if (!dcbnl_app_attr_type_validate(type))
+			continue;
+
+		if (nla_len(attr_itr) < sizeof(struct dcb_app))
+			return -ERANGE;
+
+		app_data = nla_data(attr_itr);
+
+		if (!dcbnl_app_selector_validate(type, app_data->selector))
+			return -EINVAL;
+
+		if (ops_setdel)
+			err = ops_setdel(netdev, app_data);
+		else
+			err = setdel(netdev, app_data);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
 static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 {
@@ -1568,36 +1607,11 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
 	}
 
 	if (ieee[DCB_ATTR_IEEE_APP_TABLE]) {
-		struct nlattr *attr;
-		int rem;
-
-		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
-			enum ieee_attrs_app type = nla_type(attr);
-			struct dcb_app *app_data;
-
-			if (!dcbnl_app_attr_type_validate(type))
-				continue;
-
-			if (nla_len(attr) < sizeof(struct dcb_app)) {
-				err = -ERANGE;
-				goto err;
-			}
-
-			app_data = nla_data(attr);
-
-			if (!dcbnl_app_selector_validate(type,
-							 app_data->selector)) {
-				err = -EINVAL;
-				goto err;
-			}
-
-			if (ops->ieee_setapp)
-				err = ops->ieee_setapp(netdev, app_data);
-			else
-				err = dcb_ieee_setapp(netdev, app_data);
-			if (err)
-				goto err;
-		}
+		err = dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
+					   netdev, dcb_ieee_setapp,
+					   ops->ieee_setapp);
+		if (err)
+			goto err;
 	}
 
 	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
@@ -1684,31 +1698,11 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
 		return err;
 
 	if (ieee[DCB_ATTR_IEEE_APP_TABLE]) {
-		struct nlattr *attr;
-		int rem;
-
-		nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], rem) {
-			enum ieee_attrs_app type = nla_type(attr);
-			struct dcb_app *app_data;
-
-			if (!dcbnl_app_attr_type_validate(type))
-				continue;
-
-			app_data = nla_data(attr);
-
-			if (!dcbnl_app_selector_validate(type,
-							 app_data->selector)) {
-				err = -EINVAL;
-				goto err;
-			}
-
-			if (ops->ieee_delapp)
-				err = ops->ieee_delapp(netdev, app_data);
-			else
-				err = dcb_ieee_delapp(netdev, app_data);
-			if (err)
-				goto err;
-		}
+		err = dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
+					   netdev, dcb_ieee_delapp,
+					   ops->ieee_delapp);
+		if (err)
+			goto err;
 	}
 
 err:
-- 
2.34.1

