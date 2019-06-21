Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 774E74EEAA
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfFUSOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:14:09 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:50828 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbfFUSOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:14:08 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDQsF044218;
        Fri, 21 Jun 2019 13:13:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1561140806;
        bh=7hmbqQrhwZwcY5ClrYYCYdMGokX9azLb6R6Ur266pac=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=Aq2iSoDMJkIIwxP+IOvjtFfpFnIIqKdayvLO/bvVWgVXq5fcqMUmTJSSXxr6qQGjU
         2XYRKNoOy+gAh2lFIuMJlVkeyGu05Bptfmy6rV6WaheLfhIbGKU2e7D03RnDnfFWOf
         pooRBchb8h6f0DO0VDTF9d0NjK5PWxdmwVsERGtk=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x5LIDQ1R002627
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 21 Jun 2019 13:13:26 -0500
Received: from DFLE106.ent.ti.com (10.64.6.27) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 21
 Jun 2019 13:13:26 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 21 Jun 2019 13:13:25 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x5LIDOq7028950;
        Fri, 21 Jun 2019 13:13:25 -0500
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
Subject: [RFC PATCH v4 net-next 01/11] net: ethernet: ti: cpsw: allow untagged traffic on host port
Date:   Fri, 21 Jun 2019 21:13:04 +0300
Message-ID: <20190621181314.20778-2-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190621181314.20778-1-grygorii.strashko@ti.com>
References: <20190621181314.20778-1-grygorii.strashko@ti.com>
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
 drivers/net/ethernet/ti/cpsw_ale.c | 21 ++++++++++++++++++++-
 drivers/net/ethernet/ti/cpsw_ale.h |  5 +++++
 3 files changed, 33 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 7bdd287074fc..fe3b3b89931b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -381,17 +381,16 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
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
index 84025dcc78d5..23e7714ebee7 100644
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
 
+void cpsw_ale_set_vlan_untag(struct cpsw_ale *ale, u32 *ale_entry,
+			     u16 vid, int untag_mask)
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
@@ -791,6 +805,11 @@ struct cpsw_ale *cpsw_ale_create(struct cpsw_ale_params *params)
 	if (!ale)
 		return NULL;
 
+	ale->p0_untag_vid_mask =
+		devm_kmalloc_array(params->dev, BITS_TO_LONGS(VLAN_N_VID),
+				   sizeof(unsigned long),
+				   GFP_KERNEL);
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

