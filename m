Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0239A18BC89
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 17:29:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgCSQ2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 12:28:30 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42608 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727064AbgCSQ22 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 12:28:28 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 02JGSJlU026939;
        Thu, 19 Mar 2020 11:28:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1584635299;
        bh=y8g8d0G5dE/6Zl70F19DjJKk/B46Y7eMj7qqwXrwLy4=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=h3ach1gjXHjxE6n+yjMMc3jdh7m/FpU+RGfz9SVHV3FdSMLKBDl7vsZjeYBSgqzOD
         AV7WnfxueydIoriYN6k3KdONcXETHAoTHgeoSKcnXGNlutl3Ge+Mydpj1+zcCOQC9h
         zKQZM2Opcrbs5hE++IO42dN/Ha97RFpib5iVBR9g=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 02JGSJ4l015487
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 19 Mar 2020 11:28:19 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Thu, 19
 Mar 2020 11:28:19 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Thu, 19 Mar 2020 11:28:19 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 02JGSIkO053192;
        Thu, 19 Mar 2020 11:28:18 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        <devicetree@vger.kernel.org>, Jakub Kicinski <kuba@kernel.org>
CC:     Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next v5 02/11] net: ethernet: ti: ale: fix seeing unreg mcast packets with promisc and allmulti disabled
Date:   Thu, 19 Mar 2020 18:27:57 +0200
Message-ID: <20200319162806.25705-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200319162806.25705-1-grygorii.strashko@ti.com>
References: <20200319162806.25705-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On AM65xx MCU CPSW2G NUSS and 66AK2E/L NUSS the unregistered multicast
packets are still can be received with promisc and allmulti disabled.

This happens, because ALE VLAN entries on these SoCs do not contain port
masks for reg/unreg mcast packets, but instead store indexes of
ALE_VLAN_MASK_MUXx_REG registers which intended for store port masks for
reg/unreg mcast packets.

ALE VLAN entry:UNREG_MCAST_FLOOD_INDEX -> ALE_VLAN_MASK_MUXx
ALE VLAN entry:REG_MCAST_FLOOD_INDEX -> ALE_VLAN_MASK_MUXy

The commit b361da837392 ("net: netcp: ale: add proper ale entry mask bits
for netcp switch ALE") update ALE code to support such ALE entries, it is
always used ALE_VLAN_MASK_MUX0_REG index in ALE VLAN entry for unreg mcast
packets mask configuration, which is read-only, at least for AM65xx MCU
CPSW2G NUSS and 66AK2E/L NUSS. As result unreg mcast packets are allowed
always.

Hence, update ALE code to use ALE_VLAN_MASK_MUX1_REG index for ALE VLAN
entries to configure unreg mcast port mask.

Fixes: b361da837392 ("net: netcp: ale: add proper ale entry mask bits for netcp switch ALE")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Tested-by: Murali Karicheri <m-karicheri2@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index ecdbde539eb7..5815225c000c 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -122,6 +122,8 @@ DEFINE_ALE_FIELD(mcast,			40,	1)
 DEFINE_ALE_FIELD(vlan_unreg_mcast_idx,	20,	3)
 DEFINE_ALE_FIELD(vlan_reg_mcast_idx,	44,	3)
 
+#define NU_VLAN_UNREG_MCAST_IDX	1
+
 /* The MAC address field in the ALE entry cannot be macroized as above */
 static inline void cpsw_ale_get_addr(u32 *ale_entry, u8 *addr)
 {
@@ -455,6 +457,8 @@ int cpsw_ale_add_vlan(struct cpsw_ale *ale, u16 vid, int port_mask, int untag,
 		cpsw_ale_set_vlan_unreg_mcast(ale_entry, unreg_mcast,
 					      ale->vlan_field_bits);
 	} else {
+		cpsw_ale_set_vlan_unreg_mcast_idx(ale_entry,
+						  NU_VLAN_UNREG_MCAST_IDX);
 		cpsw_ale_set_vlan_mcast(ale, ale_entry, reg_mcast, unreg_mcast);
 	}
 	cpsw_ale_set_vlan_member_list(ale_entry, port_mask,
-- 
2.17.1

