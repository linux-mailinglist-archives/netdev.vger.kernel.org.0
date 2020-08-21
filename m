Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A980824D68F
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 15:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgHUNtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 09:49:25 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:58258 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728633AbgHUNtU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 09:49:20 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07LDnG0h044154;
        Fri, 21 Aug 2020 08:49:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1598017756;
        bh=U1IbJLUcumtugOjZo1HlCDkgCIgGAvBcLRyw1XPkUAY=;
        h=From:To:Subject:Date:In-Reply-To:References;
        b=uCuf7JsshVipcS1nGxll54DPKWIWcuaOnLJvb7aKXPd/nHfZtbSEuGYygrvbW79OS
         SAd+DSdNMMAoTETnECZY+vKjnl/gdv6CNRD3t06nX4d7o5MjNuddwKhccHwKHfpa20
         rK7CcAELLcKJAvod5BJXh1ieGLAgc6HYMF8AUzRI=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07LDnGMJ098946;
        Fri, 21 Aug 2020 08:49:16 -0500
Received: from DFLE100.ent.ti.com (10.64.6.21) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 21
 Aug 2020 08:49:16 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE100.ent.ti.com
 (10.64.6.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 21 Aug 2020 08:49:15 -0500
Received: from uda0868495.fios-router.home (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07LDnC1D035260;
        Fri, 21 Aug 2020 08:49:14 -0500
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <grygorii.strashko@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [net v2 PATCH 2/2] net: ethernet: ti: cpsw_new: fix clean up of vlan mc entries for host port
Date:   Fri, 21 Aug 2020 09:49:12 -0400
Message-ID: <20200821134912.30008-2-m-karicheri2@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200821134912.30008-1-m-karicheri2@ti.com>
References: <20200821134912.30008-1-m-karicheri2@ti.com>
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

