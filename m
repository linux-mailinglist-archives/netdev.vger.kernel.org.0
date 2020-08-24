Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490A62500A8
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 17:15:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgHXPNj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 11:13:39 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:60884 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726952AbgHXPLC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 11:11:02 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07OFAtDb106587;
        Mon, 24 Aug 2020 10:10:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598281855;
        bh=/wnUGiGXREEQsll6liytq+i5deOeV09JVHvznTtg9f0=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=fUDQUe+jKi/uXx2D4X8daUIKZ0JQ1vWexcr6EukwVovQMBO60v8pMZC1nddpp9lyv
         oMBnvEl55FddKC5QJu6s5SSv671lChM35sDfNsW8Lp8UZdqKrUWNdG/LSFjsZpk0Ud
         hXuKoGIW7alPi6dO7l+r9FoUs8MP4zlbStIsAT7Q=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07OFAtbx114916
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 10:10:55 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 24
 Aug 2020 10:10:55 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 24 Aug 2020 10:10:55 -0500
Received: from uda0868495.ent.ti.com (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07OFAsJg066660;
        Mon, 24 Aug 2020 10:10:55 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net v3 PATCH 2/2] net: ethernet: ti: cpsw_new: fix clean up of vlan mc entries for host port
Date:   Mon, 24 Aug 2020 11:10:53 -0400
Message-ID: <20200824151053.18449-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200824151053.18449-1-m-karicheri2@ti.com>
References: <20200824151053.18449-1-m-karicheri2@ti.com>
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

Fixes: ed3525eda4c4 ("net: ethernet: ti: introduce cpsw switchdev based driver part 1 - dual-emac")
Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
 v3: added Fixes tag as per comment
 v2: Dropped 3/3 and re-sending as it need more work
 drivers/net/ethernet/ti/cpsw_new.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/cpsw_new.c b/drivers/net/ethernet/ti/cpsw_new.c
index 1247d35d42ef..8d0a2bc7128d 100644
--- a/drivers/net/ethernet/ti/cpsw_new.c
+++ b/drivers/net/ethernet/ti/cpsw_new.c
@@ -1044,7 +1044,7 @@ static int cpsw_ndo_vlan_rx_kill_vid(struct net_device *ndev,
 			   HOST_PORT_NUM, ALE_VLAN, vid);
 	cpsw_ale_del_mcast(cpsw->ale, priv->ndev->broadcast,
 			   0, ALE_VLAN, vid);
-	cpsw_ale_flush_multicast(cpsw->ale, 0, vid);
+	cpsw_ale_flush_multicast(cpsw->ale, ALE_PORT_HOST, vid);
 err:
 	pm_runtime_put(cpsw->dev);
 	return ret;
-- 
2.17.1

