Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 548966729F9
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjARVJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbjARVI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:08:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF7AE381;
        Wed, 18 Jan 2023 13:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674076137; x=1705612137;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2Tqi3KpyWQdTDFrBD3ehhSni+Parh9JnXVk3GWfFVhM=;
  b=2kSioqGvyjttuat8sACNVC0GJFRjqSP/79b2kPqXh/mmixswcaSZ9u3N
   H7YxEN8YHjYggmND5utupeVBpEX0m3Xc71Bo6qItDucW1nBXhsWMPgBJ+
   DmRAL59lI8xuiXKVS1vCBS3uE9F+O/eArdDHVJIgpT9m67gFojzBN75q1
   HKB2nfQJp/wCt6dTiNvFp/kiZTUIrQdItaKuBoP/40sXmabyhNq+ZaOT5
   EHfjSx8ZKc6/NKrXZb9IiB3w5kmBG2LB6B0TIJ3iWrVswZPGK0/ZFAyAn
   9AMXdgY3uEm4dqjK7Q8S/XQ9LZpoLltMMg0fDb2pvA7CfmY6YFqRLIx6p
   w==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="197370512"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 14:08:56 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 14:08:51 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 14:08:48 -0700
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
Subject: [PATCH net-next v3 2/6] net: dcb: add new common function for set/del of app/rewr entries
Date:   Wed, 18 Jan 2023 22:08:26 +0100
Message-ID: <20230118210830.2287069-3-daniel.machon@microchip.com>
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
 net/dcb/dcbnl.c | 100 ++++++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 55 deletions(-)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index a76bdf6f0198..cb5319c6afe6 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1099,6 +1099,41 @@ static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff *skb)
 	return err;
 }
 
+/* Set or delete APP table or rewrite table entries. The APP struct is validated
+ * and the appropriate callback function is called.
+ */
+static int dcbnl_app_table_setdel(struct nlattr *attr,
+				  struct net_device *netdev,
+				  int (*setdel)(struct net_device *dev,
+						struct dcb_app *app))
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
+		err = setdel(netdev, app_data);
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
@@ -1568,36 +1603,11 @@ static int dcbnl_ieee_set(struct net_device *netdev, struct nlmsghdr *nlh,
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
+		err = dcbnl_app_table_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
+					     netdev, ops->ieee_setapp ?:
+					     dcb_ieee_setapp);
+		if (err)
+			goto err;
 	}
 
 	if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
@@ -1684,31 +1694,11 @@ static int dcbnl_ieee_del(struct net_device *netdev, struct nlmsghdr *nlh,
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
+		err = dcbnl_app_table_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE],
+					     netdev, ops->ieee_delapp ?:
+					     dcb_ieee_delapp);
+		if (err)
+			goto err;
 	}
 
 err:
-- 
2.34.1

