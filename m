Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8BB25009B
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 17:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgHXPL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 11:11:59 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:56578 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgHXPLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 11:11:02 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07OFAtuv070408;
        Mon, 24 Aug 2020 10:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598281855;
        bh=bc3+F1aDrV+LVjOhWlZLzv4CIrifgUg26Eymvdzu2nw=;
        h=From:To:Subject:Date;
        b=lVkm3Din5MeF1eBDXjmscRlnkb9O2ZHhL01zoHlufdOS6xUPrcejjuUdHn36oNUB+
         St1UG+QTTIQZcXgYv8ye+Yxe6eocNZ/dPE0BH+uA+9k1qOALk2kRawMwu/zcyxtAf6
         61wB+6wjksv7XR3kJgvR44CXSQeBSiw1uSQLF25s=
Received: from DLEE111.ent.ti.com (dlee111.ent.ti.com [157.170.170.22])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07OFAtob039164;
        Mon, 24 Aug 2020 10:10:55 -0500
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE111.ent.ti.com
 (157.170.170.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 24
 Aug 2020 10:10:54 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 24 Aug 2020 10:10:54 -0500
Received: from uda0868495.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07OFAsJf066660;
        Mon, 24 Aug 2020 10:10:54 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net v3 PATCH 1/2] net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port
Date:   Mon, 24 Aug 2020 11:10:52 -0400
Message-ID: <20200824151053.18449-1-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To flush the vid + mc entries from ALE, which is required when a VLAN
interface is removed, driver needs to call cpsw_ale_flush_multicast()
with ALE_PORT_HOST for port mask as these entries are added only for
host port. Without this, these entries remain in the ALE table even
after removing the VLAN interface. cpsw_ale_flush_multicast() calls
cpsw_ale_flush_mcast which expects a port mask to do the job.

Fixes: 15180eca569b ("net: ethernet: ti: cpsw: fix vlan mcast")
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 v3: added Fixes tag as per comment
 v2: Dropped 3/3 and re-sending as it need more work
 drivers/net/ethernet/ti/cpsw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index 9b17bbbe102f..4a65edc5a375 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1116,7 +1116,7 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 				  HOST_PORT_NUM, ALE_VLAN, vid);
 	ret |= cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
 				  0, ALE_VLAN, vid);
-	ret |= cpsw_ale_flush_multicast(cpsw->ale, 0, vid);
+	ret |= cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);
 err:
 	pm_runtime_put(cpsw->dev);
 	return ret;
-- 
2.17.1

