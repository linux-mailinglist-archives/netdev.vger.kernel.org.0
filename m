Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1310E546AD1
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 18:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349814AbiFJQsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 12:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349815AbiFJQsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 12:48:06 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE462B2EB6;
        Fri, 10 Jun 2022 09:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654879674; x=1686415674;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dTbJGn1wT4KOCMCBcHh3vCtqTv4ul5foDXW+RuzFICU=;
  b=LhhTH24iqh+l/4hFBcayLgBPEEqtNq/KcYS23TFGO6OjTY5ApSX9MEFe
   y4pxEkynT6ZRNcbj1OmVQtGfBW51UOKh2uYJik5tizVhhnO3fLYqLdY4D
   e83sPvlPZkTEkAZQwx2cW3AGtHsWYOgfPKs/lGD3zaxQfeksmbQpWpojY
   gfC3+w534za4VrvAt2v5d3aVzD4qgp3xK7ovuu9IGaok9uan3ekVni+La
   +kegdEeAMUDv478cb91aH+WlfzWuA5mZPhj+ATnv0I6QVXMu/jRgoHdjk
   Aqg5TbrKr1Qh4hRvL9ZwnlnlyRN2mDa++4V1XKyd0jgwOmDDPam1b1wKT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10374"; a="275209640"
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="275209640"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:54 -0700
X-IronPort-AV: E=Sophos;i="5.91,290,1647327600"; 
   d="scan'208";a="638211067"
Received: from unknown (HELO jiaqingz-server.sh.intel.com) ([10.239.48.171])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2022 09:47:53 -0700
From:   Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
To:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
Subject: [PATCH 6/6] net/ncsi: Support VLAN mode configuration
Date:   Sat, 11 Jun 2022 00:45:55 +0800
Message-Id: <20220610164555.2322930-7-jiaqing.zhao@linux.intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
References: <20220610164555.2322930-1-jiaqing.zhao@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NCSI specification defines 4 VLAN modes, currently kernel NCSI driver
only supports the "VLAN + non-VLAN" mode (Mode #2), and there is no
way to detect which modes are supported by the device. This patch adds
support for configuring VLAN mode via the "ncsi,vlan-mode" devicetree
node.

Signed-off-by: Jiaqing Zhao <jiaqing.zhao@linux.intel.com>
---
 net/ncsi/internal.h    |  1 +
 net/ncsi/ncsi-manage.c | 41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 35 insertions(+), 7 deletions(-)

diff --git a/net/ncsi/internal.h b/net/ncsi/internal.h
index 7f384f841019..b868e07f7ffd 100644
--- a/net/ncsi/internal.h
+++ b/net/ncsi/internal.h
@@ -334,6 +334,7 @@ struct ncsi_dev_priv {
 	struct work_struct  work;            /* For channel management     */
 	struct packet_type  ptype;           /* NCSI packet Rx handler     */
 	struct list_head    node;            /* Form NCSI device list      */
+	u32                  vlan_mode;      /* VLAN mode                  */
 #define NCSI_MAX_VLAN_VIDS	15
 	struct list_head    vlan_vids;       /* List of active VLAN IDs */
 
diff --git a/net/ncsi/ncsi-manage.c b/net/ncsi/ncsi-manage.c
index 3fb95f29e3e2..a398b0eb72b2 100644
--- a/net/ncsi/ncsi-manage.c
+++ b/net/ncsi/ncsi-manage.c
@@ -10,6 +10,7 @@
 #include <linux/skbuff.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
+#include <dt-bindings/net/ncsi.h>
 
 #include <net/ncsi.h>
 #include <net/net_namespace.h>
@@ -1042,7 +1043,11 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 		nd->state = ncsi_dev_state_config_oem_gma;
 		break;
 	case ncsi_dev_state_config_oem_gma:
-		nd->state = ncsi_dev_state_config_clear_vids;
+		/* Only set up hardware VLAN filters in filtered mode */
+		if (ndp->vlan_mode == NCSI_VLAN_MODE_FILTERED)
+			nd->state = ncsi_dev_state_config_clear_vids;
+		else
+			nd->state = ncsi_dev_state_config_ev;
 		ret = -1;
 
 #if IS_ENABLED(CONFIG_NCSI_OEM_CMD_GET_MAC)
@@ -1094,11 +1099,15 @@ static void ncsi_configure_channel(struct ncsi_dev_priv *ndp)
 			nd->state = ncsi_dev_state_config_svf;
 		/* Enable/Disable the VLAN filter */
 		} else if (nd->state == ncsi_dev_state_config_ev) {
-			if (list_empty(&ndp->vlan_vids)) {
-				nca.type = NCSI_PKT_CMD_DV;
-			} else {
+			if (ndp->vlan_mode == NCSI_VLAN_MODE_FILTERED &&
+			    !list_empty(&ndp->vlan_vids)) {
 				nca.type = NCSI_PKT_CMD_EV;
 				nca.bytes[3] = NCSI_CAP_VLAN_FILTERED;
+			} else if (ndp->vlan_mode == NCSI_VLAN_MODE_ANY) {
+				nca.type = NCSI_PKT_CMD_EV;
+				nca.bytes[3] = NCSI_CAP_VLAN_ANY;
+			} else {
+				nca.type = NCSI_PKT_CMD_DV;
 			}
 			nd->state = ncsi_dev_state_config_sma;
 		} else if (nd->state == ncsi_dev_state_config_sma) {
@@ -1800,15 +1809,33 @@ struct ncsi_dev *ncsi_register_dev(struct net_device *dev,
 	ndp->ptype.dev = dev;
 	dev_add_pack(&ndp->ptype);
 
+	/* Set default VLAN mode (filtered) */
+	ndp->vlan_mode = NCSI_VLAN_MODE_FILTERED;
+
 	pdev = to_platform_device(dev->dev.parent);
 	if (pdev) {
 		np = pdev->dev.of_node;
-		if (np && of_get_property(np, "mlx,multi-host", NULL))
-			ndp->mlx_multi_host = true;
+		if (np) {
+			u32 vlan_mode;
+
+			if (!of_property_read_u32(np, "ncsi,vlan-mode", &vlan_mode)) {
+				if (vlan_mode > NCSI_VLAN_MODE_ANY ||
+				    vlan_mode == NCSI_VLAN_MODE_ONLY)
+					dev_warn(&pdev->dev, "NCSI: Unsupported VLAN mode %u",
+						 vlan_mode);
+				else
+					ndp->vlan_mode = vlan_mode;
+				dev_info(&pdev->dev, "NCSI: Configured VLAN mode %u",
+					 ndp->vlan_mode);
+			}
+			if (of_get_property(np, "mlx,multi-host", NULL))
+				ndp->mlx_multi_host = true;
+		}
 	}
 
 	/* Enable hardware VLAN filtering */
-	if (dev->netdev_ops->ndo_vlan_rx_add_vid == ncsi_vlan_rx_add_vid &&
+	if (ndp->vlan_mode == NCSI_VLAN_MODE_FILTERED &&
+	    dev->netdev_ops->ndo_vlan_rx_add_vid == ncsi_vlan_rx_add_vid &&
 	    dev->netdev_ops->ndo_vlan_rx_kill_vid == ncsi_vlan_rx_kill_vid)
 		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
 
-- 
2.34.1

