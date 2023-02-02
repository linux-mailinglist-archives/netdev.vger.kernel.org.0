Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0B8687A8E
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 11:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjBBKp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 05:45:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbjBBKpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 05:45:08 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F92D8CA9E;
        Thu,  2 Feb 2023 02:44:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675334699; x=1706870699;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yuSDnsL/0c9B2AFF93vKaa6xO4cq9uMgsAkrTKjlUng=;
  b=lJpZD38bhNdJVsxoQvZOxfaqfeEQyhF/4QK8T1EZtiNmhrtxUY2n/8oR
   WcynHFF+uWe7dKQkXGOvRGntFFbTR5HucK8GjTmnGz3eChiOgjAWFADhT
   6mnK5q9MG8AjtwRZOQICgbsZeYankdRwGfZ4ti8yQm2Cij0NC12XmDGPi
   NQyVuX2VTDeV0G0jV7uayeFigNco1FNoIGPCGWAbtqyz0zHcTB/FYDuKJ
   eSY1dQDzAYyXnxDTtvqlsnjYTAO61RUjKW9phs0wyaaJDJaMZhHR3hVgF
   6AquRdyh1Xxya1IZImj9zMSFNKOl/6wG03k3olWbN8cjk2Ph52U686l/V
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,267,1669100400"; 
   d="scan'208";a="195044163"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Feb 2023 03:44:54 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 2 Feb 2023 03:44:53 -0700
Received: from DEN-LT-70577.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.16 via Frontend Transport; Thu, 2 Feb 2023 03:44:49 -0700
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
Subject: [PATCH net-next 09/10] net: microchip: sparx5: initialize PSFP
Date:   Thu, 2 Feb 2023 11:43:54 +0100
Message-ID: <20230202104355.1612823-10-daniel.machon@microchip.com>
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

Initialize the SDLB's, stream gates and stream filters.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
---
 .../ethernet/microchip/sparx5/sparx5_main.h    |  3 +++
 .../ethernet/microchip/sparx5/sparx5_psfp.c    | 18 ++++++++++++++++++
 .../net/ethernet/microchip/sparx5/sparx5_qos.c |  2 ++
 3 files changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index cffed893fb7b..72e7928912eb 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -456,6 +456,7 @@ int sparx5_sdlb_group_del(struct sparx5 *sparx5, u32 group, u32 idx);
 
 void sparx5_sdlb_group_init(struct sparx5 *sparx5, u64 max_rate, u32 min_burst,
 			    u32 frame_size, u32 idx);
+
 /* sparx5_police.c */
 enum {
 	/* More policer types will be added later */
@@ -530,6 +531,8 @@ u32 sparx5_psfp_isdx_get_fm(struct sparx5 *sparx5, u32 isdx);
 u32 sparx5_psfp_sf_get_sg(struct sparx5 *sparx5, u32 sfid);
 void sparx5_isdx_conf_set(struct sparx5 *sparx5, u32 isdx, u32 sfid, u32 fmid);
 
+void sparx5_psfp_init(struct sparx5 *sparx5);
+
 /* sparx5_qos.c */
 void sparx5_new_base_time(struct sparx5 *sparx5, const u32 cycle_time,
 			  const ktime_t org_base_time, ktime_t *new_base_time);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
index b70601a5e4c5..8dee1ab1fa75 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_psfp.c
@@ -312,3 +312,21 @@ int sparx5_psfp_fm_del(struct sparx5 *sparx5, u32 id)
 
 	return sparx5_sdlb_conf_set(sparx5, &fm);
 }
+
+void sparx5_psfp_init(struct sparx5 *sparx5)
+{
+	const struct sparx5_sdlb_group *group;
+	int i;
+
+	for (i = 0; i < SPX5_SDLB_GROUP_CNT; i++) {
+		group = &sdlb_groups[i];
+		sparx5_sdlb_group_init(sparx5, group->max_rate,
+				       group->min_burst, group->frame_size, i);
+	}
+
+	spx5_wr(ANA_AC_SG_CYCLETIME_UPDATE_PERIOD_SG_CT_UPDATE_ENA_SET(1),
+		sparx5, ANA_AC_SG_CYCLETIME_UPDATE_PERIOD);
+
+	spx5_rmw(ANA_L2_FWD_CFG_ISDX_LOOKUP_ENA_SET(1),
+		 ANA_L2_FWD_CFG_ISDX_LOOKUP_ENA, sparx5, ANA_L2_FWD_CFG);
+}
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
index ebfdbbf0a1ce..5f34febaee6b 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_qos.c
@@ -450,6 +450,8 @@ int sparx5_qos_init(struct sparx5 *sparx5)
 	if (ret < 0)
 		return ret;
 
+	sparx5_psfp_init(sparx5);
+
 	return 0;
 }
 
-- 
2.34.1

