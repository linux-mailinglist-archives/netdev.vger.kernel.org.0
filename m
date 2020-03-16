Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4AB186BD6
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 14:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731124AbgCPNNT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 09:13:19 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11702 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731025AbgCPNNT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 09:13:19 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 8D0A22A0B1305EC4C0D3;
        Mon, 16 Mar 2020 21:13:14 +0800 (CST)
Received: from huawei.com (10.175.113.25) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Mon, 16 Mar 2020
 21:13:04 +0800
From:   Zheng Zengkai <zhengzengkai@huawei.com>
To:     <davem@davemloft.net>, <aelior@marvell.com>,
        <GR-everest-linux-l2@marvell.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <zhengzengkai@huawei.com>
Subject: [PATCH net-next] qede: remove some unused code in function qede_selftest_receive_traffic
Date:   Mon, 16 Mar 2020 21:05:24 +0800
Message-ID: <20200316130524.140421-1-zhengzengkai@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove set but not used variables 'sw_comp_cons' and 'hw_comp_cons'
to fix gcc '-Wunused-but-set-variable' warning:

drivers/net/ethernet/qlogic/qede/qede_ethtool.c: In function qede_selftest_receive_traffic:
drivers/net/ethernet/qlogic/qede/qede_ethtool.c:1569:20:
 warning: variable sw_comp_cons set but not used [-Wunused-but-set-variable]
drivers/net/ethernet/qlogic/qede/qede_ethtool.c: In function qede_selftest_receive_traffic:
drivers/net/ethernet/qlogic/qede/qede_ethtool.c:1569:6:
 warning: variable hw_comp_cons set but not used [-Wunused-but-set-variable]

After removing 'hw_comp_cons',the memory barrier 'rmb()' and its comments become useless,
so remove them as well.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Zengkai <zhengzengkai@huawei.com>
---
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8a426afb6a55..f5141d1f19bf 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -1566,7 +1566,7 @@ static int qede_selftest_transmit_traffic(struct qede_dev *edev,
 
 static int qede_selftest_receive_traffic(struct qede_dev *edev)
 {
-	u16 hw_comp_cons, sw_comp_cons, sw_rx_index, len;
+	u16 sw_rx_index, len;
 	struct eth_fast_path_rx_reg_cqe *fp_cqe;
 	struct qede_rx_queue *rxq = NULL;
 	struct sw_rx_data *sw_rx_data;
@@ -1596,17 +1596,6 @@ static int qede_selftest_receive_traffic(struct qede_dev *edev)
 			continue;
 		}
 
-		hw_comp_cons = le16_to_cpu(*rxq->hw_cons_ptr);
-		sw_comp_cons = qed_chain_get_cons_idx(&rxq->rx_comp_ring);
-
-		/* Memory barrier to prevent the CPU from doing speculative
-		 * reads of CQE/BD before reading hw_comp_cons. If the CQE is
-		 * read before it is written by FW, then FW writes CQE and SB,
-		 * and then the CPU reads the hw_comp_cons, it will use an old
-		 * CQE.
-		 */
-		rmb();
-
 		/* Get the CQE from the completion ring */
 		cqe = (union eth_rx_cqe *)qed_chain_consume(&rxq->rx_comp_ring);
 
-- 
2.20.1

