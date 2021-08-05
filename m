Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C2F53E1F0D
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 00:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242176AbhHEW4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 18:56:07 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:43432 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242015AbhHEW4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 18:56:02 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 175Mthr0088767;
        Thu, 5 Aug 2021 17:55:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1628204143;
        bh=oU9KWyxlGeDI6RvDLAF+0omt78i3oBLg/hmxQwSgpKs=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=zLoZXuH0WpRkiQK7nTCldg9PANUoKLu2S/jLXeamp5RNlsQs81zC7zbvpT9iaB6z4
         3bBdsKhd5Ld6rmhYj9Vd5o+VILaSCR0Q89x4W3zny7XQRTzRFcyNS6GWUE9ytGbLCm
         Kd3PRSndm4JdZ/LH0DRv/aIl1ebszAMtXf3cRic0=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 175Mthq0118444
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 5 Aug 2021 17:55:43 -0500
Received: from DFLE103.ent.ti.com (10.64.6.24) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 5 Aug
 2021 17:55:43 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 5 Aug 2021 17:55:43 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 175MtgXY058877;
        Thu, 5 Aug 2021 17:55:42 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Eric Dumazet <edumazet@google.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [PATCH net-next 2/2] net: ethernet: ti: am65-cpsw: use napi_complete_done() in TX completion
Date:   Fri, 6 Aug 2021 01:55:32 +0300
Message-ID: <20210805225532.2667-3-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210805225532.2667-1-grygorii.strashko@ti.com>
References: <20210805225532.2667-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch enables support for hard irqs deferral feature from Eric Dumazet
[1] for TI K3 CPSW driver by using napi_complete_done() in TX completion
path.

Depending on gro_flush_timeout and napi_defer_hard_irqs at gives up to 30%
CPU utilization reduction:

gro_flush_timeout=50000
napi_defer_hard_irqs=2

netperf -l 10 -H 192.168.1.1  -t UDP_STREAM -c -C -- -m 1470
MIGRATED UDP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.1.1 () port 0 AF_INET
Socket  Message  Elapsed      Messages                   CPU      Service
Size    Size     Time         Okay Errors   Throughput   Util     Demand
bytes   bytes    secs            #      #   10^6bits/sec % SS     us/KB

before:
212992    1470   10.00      809632      0      952.0     42.98    14.792
212992           10.00      809630             952.0     50.66    8.719

after:
212992    1470   10.00      813686      0      956.8     32.14    11.009
212992           10.00      813686             956.8     50.05    8.570

[1] https://lore.kernel.org/netdev/20200422161329.56026-1-edumazet@google.com/

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 08399f572091..b18343f9791d 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1086,13 +1086,13 @@ static int am65_cpsw_nuss_tx_poll(struct napi_struct *napi_tx, int budget)
 	else
 		num_tx = am65_cpsw_nuss_tx_compl_packets(tx_chn->common, tx_chn->id, budget);
 
-	num_tx = min(num_tx, budget);
-	if (num_tx < budget) {
-		napi_complete(napi_tx);
+	if (num_tx >= budget)
+		return budget;
+
+	if (napi_complete_done(napi_tx, num_tx))
 		enable_irq(tx_chn->irq);
-	}
 
-	return num_tx;
+	return 0;
 }
 
 static irqreturn_t am65_cpsw_nuss_rx_irq(int irq, void *dev_id)
-- 
2.17.1

