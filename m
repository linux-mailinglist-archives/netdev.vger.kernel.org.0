Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD193E1262
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 12:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240463AbhHEKPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 06:15:09 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:41340 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhHEKPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 06:15:07 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175AECGq041313;
        Thu, 5 Aug 2021 05:14:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628158453;
        bh=wXXYvUKbgAewe2Dkhit4put0hvhHFaTNeZ1ZUFaL7RA=;
        h=From:To:CC:Subject:Date;
        b=D8AK4XisRZMEgaqE5PxNrJMCzMfpfse+UAFix30Ipjwv8kWHsgvI8VZgfWlZckp5y
         W/bTzB5fldi8v4gn8tdCq0s/UMqqr/d3mczCx80ZN5z4Y3zIes1Qalt2yajyDZnGxX
         CMHpcmnnEOYPq3nGdjgxb7wQnz1KVgHUUQ7ctJZg=
Received: from DFLE109.ent.ti.com (dfle109.ent.ti.com [10.64.6.30])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175AECCF108467
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 05:14:12 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE109.ent.ti.com
 (10.64.6.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 05:14:12 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 05:14:12 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175AEBcI037522;
        Thu, 5 Aug 2021 05:14:12 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH] net: ethernet: ti: am65-cpsw: fix crash in am65_cpsw_port_offload_fwd_mark_update()
Date:   Thu, 5 Aug 2021 13:14:09 +0300
Message-ID: <20210805101409.3366-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The am65_cpsw_port_offload_fwd_mark_update() causes NULL exception crash
when there is at least one disabled port and any other port added to the
bridge first time.

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000858
pc : am65_cpsw_port_offload_fwd_mark_update+0x54/0x68
lr : am65_cpsw_netdevice_event+0x8c/0xf0
Call trace:
am65_cpsw_port_offload_fwd_mark_update+0x54/0x68
notifier_call_chain+0x54/0x98
raw_notifier_call_chain+0x14/0x20
call_netdevice_notifiers_info+0x34/0x78
__netdev_upper_dev_link+0x1c8/0x290
netdev_master_upper_dev_link+0x1c/0x28
br_add_if+0x3f0/0x6d0 [bridge]

Fix it by adding proper check for port->ndev != NULL.

Fixes: 2934db9bcb30 ("net: ti: am65-cpsw-nuss: Add netdevice notifiers")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 718539cdd2f2..67a08cbba859 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2060,8 +2060,12 @@ static void am65_cpsw_port_offload_fwd_mark_update(struct am65_cpsw_common *comm
 
 	for (i = 1; i <= common->port_num; i++) {
 		struct am65_cpsw_port *port = am65_common_get_port(common, i);
-		struct am65_cpsw_ndev_priv *priv = am65_ndev_to_priv(port->ndev);
+		struct am65_cpsw_ndev_priv *priv;
 
+		if (!port->ndev)
+			continue;
+
+		priv = am65_ndev_to_priv(port->ndev);
 		priv->offload_fwd_mark = set_val;
 	}
 }
-- 
2.17.1

