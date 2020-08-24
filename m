Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E541025045B
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 19:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgHXRBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 13:01:25 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:42544 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726513AbgHXRBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 13:01:08 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07OH12k0100866;
        Mon, 24 Aug 2020 12:01:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598288462;
        bh=DT3PA1/IKDqSXW15ng6SPivLr45yGQeLTmDSIfcQkho=;
        h=From:To:Subject:Date;
        b=C4u2oJBkCwWBuWEgNB3FaDbjnXaCPiJOt9a+jPpmMl1A0oItgXWtmfYVzCxheiqDc
         5MtGCZgGsfEwbRTcd58tnyMvg+2v8GyIYb7VjOvELRFX9dSsHrrFYpYW6mW+N+QH8H
         tYTp6bTr+FK9zkDwuNEPWIFkVPT7t8XKWjHcjteU=
Received: from DLEE108.ent.ti.com (dlee108.ent.ti.com [157.170.170.38])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07OH1297035999
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 12:01:02 -0500
Received: from DLEE112.ent.ti.com (157.170.170.23) by DLEE108.ent.ti.com
 (157.170.170.38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 24
 Aug 2020 12:01:01 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE112.ent.ti.com
 (157.170.170.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 24 Aug 2020 12:01:01 -0500
Received: from uda0868495.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07OH103g005955;
        Mon, 24 Aug 2020 12:01:00 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net v3 PATCH] net: ethernet: ti: cpsw_new: fix error handling in cpsw_ndo_vlan_rx_kill_vid()
Date:   Mon, 24 Aug 2020 13:01:00 -0400
Message-ID: <20200824170100.21319-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a bunch of issues in cpsw_ndo_vlan_rx_kill_vid()

 - pm_runtime_get_sync() returns non zero value. This results in
   non zero value return to caller which will be interpreted as error.
   So overwrite ret with zero.
 - If VID matches with port VLAN VID, then set error code.
 - Currently when VLAN interface is deleted, all of the VLAN mc addresses
   are removed from ALE table, however the return values from ale function
   calls are not checked. These functions can return error code -ENOENT.
   But that shouldn't happen in a normal case. So add error print to
   catch the situations so that these can be investigated and addressed.
   return zero in these cases as these are not real error case, but only
   serve to catch ALE table update related issues and help address the
   same in the driver.

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 v3 - updated commit description to describe error check related to
      port vlan VID
 v2 - updated comments from Grygorii, also return error code if VID
 match with port_vlan vid.
 drivers/net/ethernet/ti/cpsw_new.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 8d0a2bc7128d..61fa5063d751 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1032,19 +1032,35 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 		return ret;
 	}
 
+	/* reset the return code as pm_runtime_get_sync() can return
+	 * non zero values as well.
+	 */
+	ret = 0;
 	for (i = 0; i < cpsw->data.slaves; i++) {
 		if (cpsw->slaves[i].ndev &&
-		    vid == cpsw->slaves[i].port_vlan)
+		    vid == cpsw->slaves[i].port_vlan) {
+			ret = -EINVAL;
 			goto err;
+		}
 	}
 
 	dev_dbg(priv->dev, "removing vlanid %d from vlan filter\n", vid);
-	cpsw_ale_del_vlan(cpsw->ale, vid, 0);
-	cpsw_ale_del_ucast(cpsw->ale, priv->mac_addr,
-			   HOST_PORT_NUM, ALE_VLAN, vid);
-	cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
-			   0, ALE_VLAN, vid);
+	ret = cpsw_ale_del_vlan(cpsw->ale, vid, 0);
+	if (ret)
+		dev_err(priv->dev, "%s: failed %d: ret %d\n",
+			__func__, __LINE__, ret);
+	ret = cpsw_ale_del_ucast(cpsw->ale, priv->mac_addr,
+				 HOST_PORT_NUM, ALE_VLAN, vid);
+	if (ret)
+		dev_err(priv->dev, "%s: failed %d: ret %d\n",
+			__func__, __LINE__, ret);
+	ret = cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
+				 0, ALE_VLAN, vid);
+	if (ret)
+		dev_err(priv->dev, "%s: failed %d: ret %d\n",
+			__func__, __LINE__, ret);
 	cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);
+	ret = 0;
 err:
 	pm_runtime_put(cpsw->dev);
 	return ret;
-- 
2.17.1

