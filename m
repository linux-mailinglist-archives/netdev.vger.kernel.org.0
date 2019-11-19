Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0CD102F27
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 23:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbfKSWTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 17:19:44 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:56428 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbfKSWTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 17:19:43 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJV0w059632;
        Tue, 19 Nov 2019 16:19:31 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1574201971;
        bh=ws58TVRflIm1UjwGG5DDRy3ZYcZ0CQimVXjNWJbDB3o=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=ZCXsB1wIsH02UnisdF5Cax2tTJDKX5RU6rZs1SkSML8jb5FPfHwgYDhP9PDXEu1Ei
         anY1cBl64wuPO8Ncq8chUAihuHjWNHt1n63yrKgK5sp1/6LK31Y9zEUmGvDVsw9Njx
         gis+/pzdbkc8vI3lFTblsr8wtB0berVcg8OSgDPU=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJVXG034271;
        Tue, 19 Nov 2019 16:19:31 -0600
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Tue, 19
 Nov 2019 16:19:31 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Tue, 19 Nov 2019 16:19:31 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id xAJMJUUq084786;
        Tue, 19 Nov 2019 16:19:30 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>
CC:     Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH v7 net-next 02/13] net: ethernet: ti: cpsw: allow untagged traffic on host port
Date:   Wed, 20 Nov 2019 00:19:14 +0200
Message-ID: <20191119221925.28426-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191119221925.28426-1-grygorii.strashko@ti.com>
References: <20191119221925.28426-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now untagged vlan traffic is not support on Host P0 port. This patch adds
in ALE context bitmap of VLANs for which Host P0 port bit set in Force
Untagged Packet Egress bitmask in VLANs ALE entries, and adds corresponding
check in VLAN incapsulation header parsing function cpsw_rx_vlan_encap().

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw.c     | 17 ++++++++---------
 drivers/net/ethernet/ti/cpsw_ale.c | 23 ++++++++++++++++++++++-
 drivers/net/ethernet/ti/cpsw_ale.h |  5 +++++
 3 files changed, 35 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 329671e66fe4..15a76d3842c5 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -428,17 +428,16 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
 	/* Ignore vid 0 and pass packet as is */
 	if (!vid)
 		return;
-	/* Ignore default vlans in dual mac mode */
-	if (cpsw->data.dual_emac &&
-	    vid == cpsw->slaves[priv->emac_port].port_vlan)
-		return;
 
-	prio = (rx_vlan_encap_hdr >>
-		CPSW_RX_VLAN_ENCAP_HDR_PRIO_SHIFT) &
-		CPSW_RX_VLAN_ENCAP_HDR_PRIO_MSK;
+	/* Untag P0 packets if set for vlan */
+	if (!cpsw_ale_get_vlan_p0_untag(cpsw->ale, vid)) {
+		prio = (rx_vlan_encap_hdr >>
+			CPSW_RX_VLAN_ENCAP_HDR_PRIO_SHIFT) &
+			CPSW_RX_VLAN_ENCAP_HDR_PRIO_MSK;
 
-	vtag = (prio << VLAN_PRIO_SHIFT) | vid;
-	__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vtag);
+		vtag = (prio << VLAN_PRIO_SHIFT) | vid;
+		__vlan_hwaccel_put_tag(skb, htons(ETH_P_8021Q), vtag);
+	}
 
 	/* strip vlan tag for VLAN-tagged packet */
 	if (pkt_type == CPSW_RX_VLAN_ENCAP_HDR_PKT_VLAN_TAG) {
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index e7c24396933e..723f742e6437 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -5,6 +5,8 @@
  * Copyright (C) 2012 Texas Instruments
  *
  */
+#include <linux/bitmap.h>
+#include <linux/if_vlan.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
@@ -415,6 +417,17 @@ static void cpsw_ale_set_vlan_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 	writel(unreg_mcast, ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
 }
 
+static void cpsw_ale_set_vlan_untag(struct cpsw_ale *ale, u32 *ale_entry,
+				    u16 vid, int untag_mask)
+{
+	cpsw_ale_set_vlan_untag_force(ale_entry,
+				      untag_mask, ale->vlan_field_bits);
+	if (untag_mask & ALE_PORT_HOST)
+		bitmap_set(ale->p0_untag_vid_mask, vid, 1);
+	else
+		bitmap_clear(ale->p0_untag_vid_mask, vid, 1);
+}
+
 int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 		      int reg_mcast, int unreg_mcast)
 {
@@ -427,8 +440,8 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port, int untag,
 
 	cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_VLAN);
 	cpsw_ale_set_vlan_id(ale_entry, vid);
+	cpsw_ale_set_vlan_untag(ale, ale_entry, vid, untag);
 
-	cpsw_ale_set_vlan_untag_force(ale_entry, untag, ale->vlan_field_bits);
 	if (!ale->params.nu_switch_ale) {
 		cpsw_ale_set_vlan_reg_mcast(ale_entry, reg_mcast,
 					    ale->vlan_field_bits);
@@ -460,6 +473,7 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 		return -ENOENT;
 
 	cpsw_ale_read(ale, idx, ale_entry);
+	cpsw_ale_set_vlan_untag(ale, ale_entry, vid, 0);
 
 	if (port_mask)
 		cpsw_ale_set_vlan_member_list(ale_entry, port_mask,
@@ -792,6 +806,13 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	if (!ale)
 		return NULL;
 
+	ale->p0_untag_vid_mask =
+		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
+				   sizeof(unsigned long),
+				   GFP_KERNEL);
+	if (!ale->p0_untag_vid_mask)
+		return ERR_PTR(-ENOMEM);
+
 	ale->params = *params;
 	ale->ageout = ale->params.ale_ageout * HZ;
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.h b/drivers/net/ethernet/ti/cpsw_ale.h
index 370df254eb12..93d6d56d12f4 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.h
+++ b/drivers/net/ethernet/ti/cpsw_ale.h
@@ -35,6 +35,7 @@ struct cpsw_ale {
 	u32			port_mask_bits;
 	u32			port_num_bits;
 	u32			vlan_field_bits;
+	unsigned long		*p0_untag_vid_mask;
 };
 
 enum cpsw_ale_control {
@@ -115,4 +116,8 @@ int cpsw_ale_control_set(struct cpsw_ale *ale, int port,
 			 int control, int value);
 void cpsw_ale_dump(struct cpsw_ale *ale, u32 *data);
 
+static inline int cpsw_ale_get_vlan_p0_untag(struct cpsw_ale *ale, u16 vid)
+{
+	return test_bit(vid, ale->p0_untag_vid_mask);
+}
 #endif
-- 
2.17.1

