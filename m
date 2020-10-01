Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D0427FDCB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 12:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732246AbgJAKxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 06:53:45 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43130 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732210AbgJAKxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 06:53:36 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 091ArXaa064323;
        Thu, 1 Oct 2020 05:53:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1601549613;
        bh=8sJK9q967g1/7fwd/GtwE26Od594eYPQgGjCLPqUHec=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=KSU/GFJlDOAxPqqad/G9gdqFwOtFHtDaaBaFpO2FCT+ii8txTmm3ICcf8jhvnrqO+
         lfhJwdhnf9wPbspP725p/JfWASbSXc/PxvxWyTuzNnUHziLIyVUVXNm3AuNcCWkaWo
         V2b/33UsiX38YkNvfUCXdNKQlLrfhiPBl8ife4II=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 091ArXgP049889
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 1 Oct 2020 05:53:33 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 1 Oct
 2020 05:53:33 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 1 Oct 2020 05:53:33 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 091ArWAY074318;
        Thu, 1 Oct 2020 05:53:32 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 5/8] net: ethernet: ti: am65-cpsw: fix vlan offload for multi mac mode
Date:   Thu, 1 Oct 2020 13:52:55 +0300
Message-ID: <20201001105258.2139-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001105258.2139-1-grygorii.strashko@ti.com>
References: <20201001105258.2139-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The VLAN offload for AM65x CPSW2G is implemented using existing ALE APIs,
which are also used by legacy CPSW drivers.
So, now it always adds current Ext. Port and Host as VLAN members when VLAN
is added by 8021Q core (.ndo_vlan_rx_add_vid) and forcibly removes VLAN
from ALE table in .ndo_vlan_rx_kill_vid(). This works as for AM65x CPSW2G
(which has only one Ext. Port) as for legacy CPSW devices (which can't
support same VLAN on more then one Port in multi mac (dual-mac) mode). But
it doesn't work for the new J721E and AM64x multi port CPSWxG versions
doesn't have such restrictions and allow to offload the same VLAN on any
number of ports.

Now the attempt to add same VLAN on two (or more) K3 CPSWxG Ports will
cause:
 - VLAN members mask overwrite when VLAN is added
 - VLAN removal from ALE table when any Port removes VLAN

This patch fixes an issue by:
 - switching to use cpsw_ale_vlan_add_modify() instead of
   cpsw_ale_add_vlan() when VLAN is added to ALE table, so VLAN members
   mask will not be overwritten;
 - Updates cpsw_ale_del_vlan() as:
     if more than one ext. Port is in VLAN member mask
     then remove only current port from VLAN member mask
     else remove VLAN ALE entry

 Example:
  add: P1 | P0 (Host) -> members mask: P1 | P0
  add: P2 | P0        -> members mask: P2 | P1 | P0
  rem: P1 | P0        -> members mask: P2 | P0
  rem: P2 | P0        -> members mask: -

The VLAN is forcibly removed if port_mask=0 passed to cpsw_ale_del_vlan()
to preserve existing legacy CPSW drivers functionality.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c |  8 +++++---
 drivers/net/ethernet/ti/cpsw_ale.c       | 19 +++++++++++++++----
 2 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 65c5446e324e..fecaf6b8270f 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -241,8 +241,8 @@ static int am65_cpsw_nuss_ndo_slave_add_vid(struct net_device *ndev,
 	if (!vid)
 		unreg_mcast = port_mask;
 	dev_info(common->dev, "Adding vlan %d to vlan filter\n", vid);
-	ret = cpsw_ale_add_vlan(common->ale, vid, port_mask,
-				unreg_mcast, port_mask, 0);
+	ret = cpsw_ale_vlan_add_modify(common->ale, vid, port_mask,
+				       unreg_mcast, port_mask, 0);
 
 	pm_runtime_put(common->dev);
 	return ret;
@@ -252,6 +252,7 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 					     __be16 proto, u16 vid)
 {
 	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
+	struct am65_cpsw_port *port = am65_ndev_to_port(ndev);
 	int ret;
 
 	if (!netif_running(ndev) || !vid)
@@ -264,7 +265,8 @@ static int am65_cpsw_nuss_ndo_slave_kill_vid(struct net_device *ndev,
 	}
 
 	dev_info(common->dev, "Removing vlan %d from vlan filter\n", vid);
-	ret = cpsw_ale_del_vlan(common->ale, vid, 0);
+	ret = cpsw_ale_del_vlan(common->ale, vid,
+				BIT(port->port_id) | ALE_PORT_HOST);
 
 	pm_runtime_put(common->dev);
 	return ret;
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index b1cce39eda17..cdc308a2aa3e 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -694,7 +694,7 @@ int cpsw_ale_vlan_del_modify(struct cpsw_ale *ale, u16 vid, int port_mask)
 int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 {
 	u32 ale_entry[ALE_ENTRY_WORDS] = {0, 0, 0};
-	int idx;
+	int members, idx;
 
 	idx = cpsw_ale_match_vlan(ale, vid);
 	if (idx < 0)
@@ -702,11 +702,22 @@ int cpsw_ale_del_vlan(struct cpsw_ale *ale, u16 vid, int port_mask)
 
 	cpsw_ale_read(ale, idx, ale_entry);
 
-	if (port_mask) {
-		cpsw_ale_vlan_del_modify_int(ale, ale_entry, vid, port_mask);
-	} else {
+	/* if !port_mask - force remove VLAN (legacy).
+	 * Check if there are other VLAN members ports
+	 * if no - remove VLAN.
+	 * if yes it means same VLAN was added to >1 port in multi port mode, so
+	 * remove port_mask ports from VLAN ALE entry excluding Host port.
+	 */
+	members = cpsw_ale_vlan_get_fld(ale, ale_entry, ALE_ENT_VID_MEMBER_LIST);
+	members &= ~port_mask;
+
+	if (!port_mask || !members) {
+		/* last port or force remove - remove VLAN */
 		cpsw_ale_set_vlan_untag(ale, ale_entry, vid, 0);
 		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
+	} else {
+		port_mask &= ~ALE_PORT_HOST;
+		cpsw_ale_vlan_del_modify_int(ale, ale_entry, vid, port_mask);
 	}
 
 	cpsw_ale_write(ale, idx, ale_entry);
-- 
2.17.1

