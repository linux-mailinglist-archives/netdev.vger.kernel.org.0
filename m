Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5BB2687A8D
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:45:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbjBBKp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:45:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjBBKo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:44:57 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 861DE709BC;
        Thu,  2 Feb 2023 02:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334694; x=1706870694;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RNKHvf+RGFRODy4V7cRMpbFQQlHD3gRu2QEBFHIyo0w=;
  b=2UjM7RuMJfC5EWFDilwH/CfKnOz/jgbj7Y9E97DE179sZKKTHHmamqql
   505MXwJXc2/yWBpPPLc8q4C8JZSaJhhta2pS2TRHWCP2zX5fy8qpU0eKI
   ceh1Wlqx1Epyw7Ido6jHdPyPLUGDVYKgAljBqNwatYNlrxv91Twj26GHy
   V+jd8Ueqa0TcXDkyyvMg/rmImB68kjBm0M/cgRYVbYzxI+zropQruMkMp
   Tip8/dwhsV8Rqqh0tSHPNhvG0QVql5ce43F99PHOLtN8wIn04JA7KOdyD
   IdDtY0tktKFNbIupvTLd5TcvyyjHHt5c1xapLDfv48fJKsZc8kHRemtRr
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="195044156"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:49 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:45 -0700
From:   Daniel Machon <daniel.machon@microchip.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <lars.povlsen@microchip.com>,
        <Steen.Hegelund@microchip.com>, <daniel.machon@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <richardcochran@gmail.com>, <casper.casan@gmail.com>,
        <horatiu.vultur@microchip.com>, <shangxiaojing@huawei.com>,
        <rmk+kernel@armlinux.org.uk>, <nhuck@google.com>,
        <error27@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 08/10] net: microchip: sparx5: add support for PSFP stream filters
Date:   Thu, 2 Feb 2023 11:43:53 +0100
Message-ID: <20230202104355.1612823-9-daniel.machon@microchip.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230202104355.1612823-1-daniel.machon@microchip.com>
References: <20230202104355.1612823-1-daniel.machon@microchip.com>
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

Add support for configuring PSFP stream filters (IEEE 802.1Q-2018,
8.6.5.1.1).

The VCAP CLM (VCAP IS0 ingress classifier) classifies streams,
identified by ISDX (Ingress Service Index, frame metadata), and maps
ISDX to streams.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.h   | 17 ++++
 .../ethernet/microchip/sparx5/sparx5_psfp.c   | 78 +++++++++++++++++++
 2 files changed, 95 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index 5a2d893749fd..cffed893fb7b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -505,6 +505,14 @@ struct sparx5_psfp_sg {
 	struct sparx5_psfp_gce gce[SPX5_PSFP_GCE_CNT];
 };
 
+struct sparx5_psfp_sf {
+	bool sblock_osize_ena;
+	bool sblock_osize;
+	u32 max_sdu;
+	u32 sgid; /* Gate id */
+	u32 fmid; /* Flow meter id */
+};
+
 int sparx5_psfp_fm_add(struct sparx5 *sparx5, u32 uidx,
 		       struct sparx5_psfp_fm *fm, u32 *id);
 int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id);
@@ -513,6 +521,15 @@ int sparx5_psfp_sg_add(struct sparx5 *sparx5, u32 uidx,
 		       struct sparx5_psfp_sg *sg, u32 *id);
 int sparx5_psfp_sg_del(struct sparx5 *sparx5, u32 id);
 
+int sparx5_psfp_sf_add(struct sparx5 *sparx5, const struct sparx5_psfp_sf *sf,
+		       u32 *id);
+int sparx5_psfp_sf_del(struct sparx5 *sparx5, u32 id);
+
+u32 sparx5_psfp_isdx_get_sf(struct sparx5 *sparx5, u32 isdx);
+u32 sparx5_psfp_isdx_get_fm(struct sparx5 *sparx5, u32 isdx);
+u32 sparx5_psfp_sf_get_sg(struct sparx5 *sparx5, u32 sfid);
+void sparx5_isdx_conf_set(struct sparx5 *sparx5, u32 isdx, u32 sfid, u32 fmid);
+
 /* sparx5_qos.c */
 void sparx5_new_base_time(struct sparx5 *sparx5, const u32 cycle_time,
 			  const ktime_t org_base_time, ktime_t *new_base_time);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
index 883becd6781b..b70601a5e4c5 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -7,6 +7,7 @@
 #include "sparx5_main_regs.h"
 #include "sparx5_main.h"
 
+#define SPX5_PSFP_SF_CNT 1024
 #define SPX5_PSFP_SG_CONFIG_CHANGE_SLEEP 1000
 #define SPX5_PSFP_SG_CONFIG_CHANGE_TIMEO 100000
 
@@ -16,6 +17,19 @@ static struct sparx5_pool_entry sparx5_psfp_fm_pool[SPX5_SDLB_CNT];
 /* Pool of available stream gates */
 static struct sparx5_pool_entry sparx5_psfp_sg_pool[SPX5_PSFP_SG_CNT];
 
+/* Pool of available stream filters */
+static struct sparx5_pool_entry sparx5_psfp_sf_pool[SPX5_PSFP_SF_CNT];
+
+static int sparx5_psfp_sf_get(u32 *id)
+{
+	return sparx5_pool_get(sparx5_psfp_sf_pool, SPX5_PSFP_SF_CNT, id);
+}
+
+static int sparx5_psfp_sf_put(u32 id)
+{
+	return sparx5_pool_put(sparx5_psfp_sf_pool, SPX5_PSFP_SF_CNT, id);
+}
+
 static int sparx5_psfp_sg_get(u32 idx, u32 *id)
 {
 	return sparx5_pool_get_with_idx(sparx5_psfp_sg_pool, SPX5_PSFP_SG_CNT,
@@ -38,6 +52,33 @@ static int sparx5_psfp_fm_put(u32 id)
 	return sparx5_pool_put(sparx5_psfp_fm_pool, SPX5_SDLB_CNT, id);
 }
 
+u32 sparx5_psfp_isdx_get_sf(struct sparx5 *sparx5, u32 isdx)
+{
+	return ANA_L2_TSN_CFG_TSN_SFID_GET(spx5_rd(sparx5,
+						   ANA_L2_TSN_CFG(isdx)));
+}
+
+u32 sparx5_psfp_isdx_get_fm(struct sparx5 *sparx5, u32 isdx)
+{
+	return ANA_L2_DLB_CFG_DLB_IDX_GET(spx5_rd(sparx5,
+						  ANA_L2_DLB_CFG(isdx)));
+}
+
+u32 sparx5_psfp_sf_get_sg(struct sparx5 *sparx5, u32 sfid)
+{
+	return ANA_AC_TSN_SF_CFG_TSN_SGID_GET(spx5_rd(sparx5,
+						      ANA_AC_TSN_SF_CFG(sfid)));
+}
+
+void sparx5_isdx_conf_set(struct sparx5 *sparx5, u32 isdx, u32 sfid, u32 fmid)
+{
+	spx5_rmw(ANA_L2_TSN_CFG_TSN_SFID_SET(sfid), ANA_L2_TSN_CFG_TSN_SFID,
+		 sparx5, ANA_L2_TSN_CFG(isdx));
+
+	spx5_rmw(ANA_L2_DLB_CFG_DLB_IDX_SET(fmid), ANA_L2_DLB_CFG_DLB_IDX,
+		 sparx5, ANA_L2_DLB_CFG(isdx));
+}
+
 /* Internal priority value to internal priority selector */
 static u32 sparx5_psfp_ipv_to_ips(s32 ipv)
 {
@@ -73,6 +114,20 @@ static void sparx5_psfp_sg_config_change(struct sparx5 *sparx5, u32 id)
 			 __func__, __LINE__);
 }
 
+static void sparx5_psfp_sf_set(struct sparx5 *sparx5, u32 id,
+			       const struct sparx5_psfp_sf *sf)
+{
+	/* Configure stream gate*/
+	spx5_rmw(ANA_AC_TSN_SF_CFG_TSN_SGID_SET(sf->sgid) |
+		ANA_AC_TSN_SF_CFG_TSN_MAX_SDU_SET(sf->max_sdu) |
+		ANA_AC_TSN_SF_CFG_BLOCK_OVERSIZE_STATE_SET(sf->sblock_osize) |
+		ANA_AC_TSN_SF_CFG_BLOCK_OVERSIZE_ENA_SET(sf->sblock_osize_ena),
+		ANA_AC_TSN_SF_CFG_TSN_SGID | ANA_AC_TSN_SF_CFG_TSN_MAX_SDU |
+		ANA_AC_TSN_SF_CFG_BLOCK_OVERSIZE_STATE |
+		ANA_AC_TSN_SF_CFG_BLOCK_OVERSIZE_ENA,
+		sparx5, ANA_AC_TSN_SF_CFG(id));
+}
+
 static int sparx5_psfp_sg_set(struct sparx5 *sparx5, u32 id,
 			      const struct sparx5_psfp_sg *sg)
 {
@@ -145,6 +200,29 @@ static int sparx5_sdlb_conf_set(struct sparx5 *sparx5,
 	return sparx5_sdlb_group_action(sparx5, fm->pol.group, fm->pol.idx);
 }
 
+int sparx5_psfp_sf_add(struct sparx5 *sparx5, const struct sparx5_psfp_sf *sf,
+		       u32 *id)
+{
+	int ret;
+
+	ret = sparx5_psfp_sf_get(id);
+	if (ret < 0)
+		return ret;
+
+	sparx5_psfp_sf_set(sparx5, *id, sf);
+
+	return 0;
+}
+
+int sparx5_psfp_sf_del(struct sparx5 *sparx5, u32 id)
+{
+	const struct sparx5_psfp_sf sf = { 0 };
+
+	sparx5_psfp_sf_set(sparx5, id, &sf);
+
+	return sparx5_psfp_sf_put(id);
+}
+
 int sparx5_psfp_sg_add(struct sparx5 *sparx5, u32 uidx,
 		       struct sparx5_psfp_sg *sg, u32 *id)
 {
-- 
2.34.1

