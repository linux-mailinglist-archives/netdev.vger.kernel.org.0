Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D82F1C4DFA
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 07:58:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgEEF6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 01:58:16 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54588 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725320AbgEEF6Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 01:58:16 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 09885A24B97E355DA470;
        Tue,  5 May 2020 13:58:05 +0800 (CST)
Received: from localhost (10.173.251.152) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Tue, 5 May 2020
 13:57:58 +0800
From:   wangyunjian <wangyunjian@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <jerry.lilijun@huawei.com>,
        <xudingke@huawei.com>, Yunjian Wang <wangyunjian@huawei.com>
Subject: [PATCH] net: emac: Fix use correct return type for ndo_start_xmit()
Date:   Tue, 5 May 2020 13:57:49 +0800
Message-ID: <1588658269-21452-1-git-send-email-wangyunjian@huawei.com>
X-Mailer: git-send-email 1.9.5.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.251.152]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

The method ndo_start_xmit() returns a value of type netdev_tx_t. Fix
the ndo function to use the correct type.

Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c | 5 +++--
 drivers/net/ethernet/qualcomm/emac/emac-mac.h | 5 +++--
 drivers/net/ethernet/qualcomm/emac/emac.c     | 3 ++-
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 251d4ac..117188e3 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1431,8 +1431,9 @@ static void emac_tx_fill_tpd(struct emac_adapter *adpt,
 }
 
 /* Transmit the packet using specified transmit queue */
-int emac_mac_tx_buf_send(struct emac_adapter *adpt, struct emac_tx_queue *tx_q,
-			 struct sk_buff *skb)
+netdev_tx_t emac_mac_tx_buf_send(struct emac_adapter *adpt,
+				 struct emac_tx_queue *tx_q,
+				 struct sk_buff *skb)
 {
 	struct emac_tpd tpd;
 	u32 prod_idx;
diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.h b/drivers/net/ethernet/qualcomm/emac/emac-mac.h
index ae08bdd..920123e 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.h
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.h
@@ -227,8 +227,9 @@ struct emac_tx_queue {
 void emac_mac_mode_config(struct emac_adapter *adpt);
 void emac_mac_rx_process(struct emac_adapter *adpt, struct emac_rx_queue *rx_q,
 			 int *num_pkts, int max_pkts);
-int emac_mac_tx_buf_send(struct emac_adapter *adpt, struct emac_tx_queue *tx_q,
-			 struct sk_buff *skb);
+netdev_tx_t emac_mac_tx_buf_send(struct emac_adapter *adpt,
+				 struct emac_tx_queue *tx_q,
+				 struct sk_buff *skb);
 void emac_mac_tx_process(struct emac_adapter *adpt, struct emac_tx_queue *tx_q);
 void emac_mac_rx_tx_ring_init_all(struct platform_device *pdev,
 				  struct emac_adapter *adpt);
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 18b0c7a..20b1b43 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -115,7 +115,8 @@ static int emac_napi_rtx(struct napi_struct *napi, int budget)
 }
 
 /* Transmit the packet */
-static int emac_start_xmit(struct sk_buff *skb, struct net_device *netdev)
+static netdev_tx_t emac_start_xmit(struct sk_buff *skb,
+				   struct net_device *netdev)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 
-- 
1.8.3.1


