Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98F316729FC
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 22:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbjARVJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 16:09:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230335AbjARVJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 16:09:04 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6312C611F0;
        Wed, 18 Jan 2023 13:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674076142; x=1705612142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wwp41EBsynnmFWMpb+zxl4+xcQO6Z+ZQm953U3ymkZc=;
  b=df0+f1cOOagi5Px2kTFJherUfrjcLuG++rdt4sqH2tIAsJXYJmutYh4S
   6+zBvzAOO4PfQEhO7WpH4YY1bFUVaEqjKYqp8NknagVoCtUsFHxe+9pjH
   YBKW9N+B7sctoom2Uxn8UZUFDGgavbvb4AbnUCxFIrC6o+tahGSSRXz6M
   CQk0GfjmJCRpZcpFBYhSMbt2B3gOEEi5oeBLL37jwyWCuQSI7KkwR5k5e
   Sp5pnWIoQfiQ6iigWdslnYsgTc+Xi1JgJwCwgFobmi/AAdMWXoafTYRWS
   /tZBD2XGTyojydRuHh4VBCOhh/5bjFfRYLVEcX5RSjQuAAxEqTL/aiQPU
   A==;
X-IronPort-AV: E=Sophos;i="5.97,226,1669100400"; 
   d="scan'208";a="197370569"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Jan 2023 14:09:02 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 18 Jan 2023 14:08:59 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Wed, 18 Jan 2023 14:08:55 -0700
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
Subject: [PATCH net-next v3 4/6] net: dcb: add helper functions to retrieve PCP and DSCP rewrite maps
Date:   Wed, 18 Jan 2023 22:08:28 +0100
Message-ID: <20230118210830.2287069-5-daniel.machon@microchip.com>
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
index 2ca7fffcf069..c0c438128575 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -2232,6 +2232,58 @@ int dcb_ieee_delapp(struct net_device *dev, struct dcb_app *del)
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

