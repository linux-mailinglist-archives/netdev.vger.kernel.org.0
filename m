Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE4A1F83C6
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 16:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbgFMOy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jun 2020 10:54:26 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:46538 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgFMOy0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jun 2020 10:54:26 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 05DEsM9l069851;
        Sat, 13 Jun 2020 09:54:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1592060062;
        bh=fharIubfP4/5q4WmJtQgrrpfXx2uoim9fw9RsMrQ1YA=;
        h=From:To:CC:Subject:Date;
        b=UqiuP/lhzX20rnk0cg2IBDABfVSvsmz4grzhQwdmE6KbDObzAzl1Yz1Nv41IRzXrq
         RORtbktBjt4Ubai5bLp12+tAZgT0fZGflJfkrCiFi+UnkPT/eibcD8iCZ/2QqNrOQu
         7kFRIlSUTjqcBKHfLzVuJryRvDcz6bCm1VKp059E=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 05DEsMQB089651
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 13 Jun 2020 09:54:22 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Sat, 13
 Jun 2020 09:54:22 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Sat, 13 Jun 2020 09:54:22 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 05DEsLo3097626;
        Sat, 13 Jun 2020 09:54:21 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: ale: fix allmulti for nu type ale
Date:   Sat, 13 Jun 2020 17:54:14 +0300
Message-ID: <20200613145414.17190-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On AM65xx MCU CPSW2G NUSS and 66AK2E/L NUSS allmulti setting does not allow
unregistered mcast packets to pass.

This happens, because ALE VLAN entries on these SoCs do not contain port
masks for reg/unreg mcast packets, but instead store indexes of
ALE_VLAN_MASK_MUXx_REG registers which intended for store port masks for
reg/unreg mcast packets.
This path was missed by commit 9d1f6447274f ("net: ethernet: ti: ale: fix
seeing unreg mcast packets with promisc and allmulti disabled").

Hence, fix it by taking into account ALE type in cpsw_ale_set_allmulti().

Fixes: 9d1f6447274f ("net: ethernet: ti: ale: fix seeing unreg mcast packets with promisc and allmulti disabled")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 49 ++++++++++++++++++++++++------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 8dc6be11b2ff..9ad872bfae3a 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -604,10 +604,44 @@ void cpsw_ale_set_unreg_mcast(struct cpsw_ale *ale, int unreg_mcast_mask,
 	}
 }
 
+static void cpsw_ale_vlan_set_unreg_mcast(struct cpsw_ale *ale, u32 *ale_entry,
+					  int allmulti)
+{
+	int unreg_mcast;
+
+	unreg_mcast =
+		cpsw_ale_get_vlan_unreg_mcast(ale_entry,
+					      ale->vlan_field_bits);
+	if (allmulti)
+		unreg_mcast |= ALE_PORT_HOST;
+	else
+		unreg_mcast &= ~ALE_PORT_HOST;
+	cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
+				      ale->vlan_field_bits);
+}
+
+static void
+cpsw_ale_vlan_set_unreg_mcast_idx(struct cpsw_ale *ale, u32 *ale_entry,
+				  int allmulti)
+{
+	int unreg_mcast;
+	int idx;
+
+	idx = cpsw_ale_get_vlan_unreg_mcast_idx(ale_entry);
+
+	unreg_mcast = readl(ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
+
+	if (allmulti)
+		unreg_mcast |= ALE_PORT_HOST;
+	else
+		unreg_mcast &= ~ALE_PORT_HOST;
+
+	writel(unreg_mcast, ale->params.ale_regs + ALE_VLAN_MASK_MUX(idx));
+}
+
 void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS];
-	int unreg_mcast = 0;
 	int type, idx;
 
 	for (idx = 0; idx < ale->params.ale_entries; idx++) {
@@ -624,15 +658,12 @@ void cpsw_ale_set_allmulti(struct cpsw_ale *ale, int allmulti, int port)
 		if (port != -1 && !(vlan_members & BIT(port)))
 			continue;
 
-		unreg_mcast =
-			cpsw_ale_get_vlan_unreg_mcast(ale_entry,
-						      ale->vlan_field_bits);
-		if (allmulti)
-			unreg_mcast |= ALE_PORT_HOST;
+		if (!ale->params.nu_switch_ale)
+			cpsw_ale_vlan_set_unreg_mcast(ale, ale_entry, allmulti);
 		else
-			unreg_mcast &= ~ALE_PORT_HOST;
-		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
-					      ale->vlan_field_bits);
+			cpsw_ale_vlan_set_unreg_mcast_idx(ale, ale_entry,
+							  allmulti);
+
 		cpsw_ale_write(ale, idx, ale_entry);
 	}
 }
-- 
2.17.1

