Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A63E24D68C
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 15:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728789AbgHUNtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 09:49:22 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:48026 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727929AbgHUNtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 09:49:19 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07LDnEiK126288;
        Fri, 21 Aug 2020 08:49:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598017754;
        bh=ykGFwxHybdYeyIYRyYFOG7cBotylhW0+qN5JBcDCze8=;
        h=From:To:Subject:Date;
        b=EKKVqknglKKs4/WV0lh5k1NRNIfGqeSAcIzei+g++30LVFte17ssRwqbqZPyJHeuX
         zj19T0+23yPJPFDvRyVU+//cy/Zw63glNg3JwBM5olLFYKxAGUFMl9zgMV5TfxEKxi
         fwCl0u7T7KFyMgBVniDa79Ptd83VmW4u6cda0DXc=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07LDnEFe098899;
        Fri, 21 Aug 2020 08:49:14 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 21
 Aug 2020 08:49:14 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 21 Aug 2020 08:49:14 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07LDnC1C035260;
        Fri, 21 Aug 2020 08:49:13 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net v2 PATCH 1/2] net: ethernet: ti: cpsw: fix clean up of vlan mc entries for host port
Date:   Fri, 21 Aug 2020 09:49:11 -0400
Message-ID: <20200821134912.30008-1-m-karicheri2@ti.com>
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

Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
---
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

