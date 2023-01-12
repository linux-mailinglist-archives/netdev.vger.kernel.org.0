Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593BD668409
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 21:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjALUVj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 15:21:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbjALUTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 15:19:37 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6718D63D08;
        Thu, 12 Jan 2023 12:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673553874; x=1705089874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UQLuLU/iqMheGfkgsr28maQNwuv/7seT27sZWLi7akw=;
  b=r5rWUIlVmgu+W4cNK+6H49sAzE19SF8NRpip+cm5DyHjw92fYi261L4Y
   plZwwOtp1+wCobEriA66XXliEUtOjFoUwRcW5TgBKyzPg4fRUEheABP8G
   mv2NPWnZ4ijFEg1bqDuEYXIFPEopjQY2v+S6GkJBAs5PGTVpoPzLXHQSU
   6uIXB+ZOQ76B/HDxNCZmYhr9YnVim775dvYPv2VQ3NrJU+sIGeyvHQupO
   pJPF5mL9B8WI8YlpsR7ht5VcCkbwzZFRk18sOa+VFbfsWfM0ZSy5VE1MD
   cnrakMpJxWhAcN+xbC4w6JNn2GheCKLSroG6GLNTTspoEhJOI0UmcdEc5
   A==;
X-IronPort-AV: E=Sophos;i="5.97,211,1669100400"; 
   d="scan'208";a="207544414"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Jan 2023 13:04:11 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 12 Jan 2023 13:04:05 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 12 Jan 2023 13:04:02 -0700
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
Subject: [PATCH net-next 4/6] net: dcb: add helper functions to retrieve PCP and DSCP rewrite maps
Date:   Thu, 12 Jan 2023 21:15:52 +0100
Message-ID: <20230112201554.752144-5-daniel.machon@microchip.com>
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

Add two new helper functions to retrieve a mapping of priority to PCP
and DSCP bitmasks, where each bitmap contains ones in positions that
match a rewrite entry.

dcb_ieee_getrewr_prio_dscp_mask_map() reuses the dcb_ieee_app_prio_map,
as this struct is already used for a similar mapping in the app table.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 include/net/dcbnl.h | 10 +++++++++
 net/dcb/dcbnl.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+)

diff --git a/include/net/dcbnl.h b/include/net/dcbnl.h
index fe7dfb8bcb5b..42207fc44660 100644
--- a/include/net/dcbnl.h
+++ b/include/net/dcbnl.h
@@ -29,12 +29,22 @@ int dcb_ieee_setapp(struct net_device *, struct dcb_app *);
 int dcb_ieee_delapp(struct net_device *, struct dcb_app *);
 u8 dcb_ieee_getapp_mask(struct net_device *, struct dcb_app *);
 
+struct dcb_rewr_prio_pcp_map {
+	u16 map[IEEE_8021QAZ_MAX_TCS];
+};
+
+void dcb_getrewr_prio_pcp_mask_map(const struct net_device *dev,
+				   struct dcb_rewr_prio_pcp_map *p_map);
+
 struct dcb_ieee_app_prio_map {
 	u64 map[IEEE_8021QAZ_MAX_TCS];
 };
 void dcb_ieee_getapp_prio_dscp_mask_map(const struct net_device *dev,
 					struct dcb_ieee_app_prio_map *p_map);
 
+void dcb_getrewr_prio_dscp_mask_map(const struct net_device *dev,
+				    struct dcb_ieee_app_prio_map *p_map);
+
 struct dcb_ieee_app_dscp_map {
 	u8 map[64];
 };
diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index b52acf30a0bc..8a0f33df27ea 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2235,6 +2235,58 @@ int dcb_ieee_delapp(struct net_device *dev, struct dcb_app *del)
 }
 EXPORT_SYMBOL(dcb_ieee_delapp);
 
+/* dcb_getrewr_prio_pcp_mask_map - For a given device, find mapping from
+ * priorities to the PCP and DEI values assigned to that priority.
+ */
+void dcb_getrewr_prio_pcp_mask_map(const struct net_device *dev,
+				   struct dcb_rewr_prio_pcp_map *p_map)
+{
+	int ifindex = dev->ifindex;
+	struct dcb_app_type *itr;
+	u8 prio;
+
+	memset(p_map->map, 0, sizeof(p_map->map));
+
+	spin_lock_bh(&dcb_lock);
+	list_for_each_entry(itr, &dcb_rewr_list, list) {
+		if (itr->ifindex == ifindex &&
+		    itr->app.selector == DCB_APP_SEL_PCP &&
+		    itr->app.protocol < 16 &&
+		    itr->app.priority < IEEE_8021QAZ_MAX_TCS) {
+			prio = itr->app.priority;
+			p_map->map[prio] |= 1 << itr->app.protocol;
+		}
+	}
+	spin_unlock_bh(&dcb_lock);
+}
+EXPORT_SYMBOL(dcb_getrewr_prio_pcp_mask_map);
+
+/* dcb_getrewr_prio_dscp_mask_map - For a given device, find mapping from
+ * priorities to the DSCP values assigned to that priority.
+ */
+void dcb_getrewr_prio_dscp_mask_map(const struct net_device *dev,
+				    struct dcb_ieee_app_prio_map *p_map)
+{
+	int ifindex = dev->ifindex;
+	struct dcb_app_type *itr;
+	u8 prio;
+
+	memset(p_map->map, 0, sizeof(p_map->map));
+
+	spin_lock_bh(&dcb_lock);
+	list_for_each_entry(itr, &dcb_rewr_list, list) {
+		if (itr->ifindex == ifindex &&
+		    itr->app.selector == IEEE_8021QAZ_APP_SEL_DSCP &&
+		    itr->app.protocol < 64 &&
+		    itr->app.priority < IEEE_8021QAZ_MAX_TCS) {
+			prio = itr->app.priority;
+			p_map->map[prio] |= 1ULL << itr->app.protocol;
+		}
+	}
+	spin_unlock_bh(&dcb_lock);
+}
+EXPORT_SYMBOL(dcb_getrewr_prio_dscp_mask_map);
+
 /*
  * dcb_ieee_getapp_prio_dscp_mask_map - For a given device, find mapping from
  * priorities to the DSCP values assigned to that priority. Initialize p_map
-- 
2.34.1

