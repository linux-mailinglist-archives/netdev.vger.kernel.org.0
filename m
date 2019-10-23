Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A34CE21DA
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 19:34:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730453AbfJWReb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 13:34:31 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:23780 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730302AbfJWReb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 13:34:31 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x9NHYOw9031504;
        Wed, 23 Oct 2019 10:34:25 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     vishal@chelsio.com, nirranjan@chelsio.com, dt@chelsio.com,
        rajur@chelsio.com
Subject: [PATCH net] cxgb4: request the TX CIDX updates to status page
Date:   Wed, 23 Oct 2019 23:03:55 +0530
Message-Id: <20191023173355.11341-1-rajur@chelsio.com>
X-Mailer: git-send-email 2.9.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For adapters which support the SGE Doorbell Queue Timer facility,
we configured the Ethernet TX Queues to send CIDX Updates to the
Associated Ethernet RX Response Queue with CPL_SGE_EGR_UPDATE
messages to allow us to respond more quickly to the CIDX Updates.
But, this was adding load to PCIe Link RX bandwidth and,
potentially, resulting in higher CPU Interrupt load.

This patch requests the HW to deliver the CIDX updates to the TX
queue status page rather than generating an ingress queue message
(as an interrupt). With this patch, the load on RX bandwidth is
reduced and a substantial improvement in BW is noticed at lower
IO sizes.

Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index b3da81e90132..928bfea5457b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3791,15 +3791,11 @@ int t4_sge_alloc_eth_txq(struct adapter *adap, struct sge_eth_txq *txq,
 	 * write the CIDX Updates into the Status Page at the end of the
 	 * TX Queue.
 	 */
-	c.autoequiqe_to_viid = htonl((dbqt
-				      ? FW_EQ_ETH_CMD_AUTOEQUIQE_F
-				      : FW_EQ_ETH_CMD_AUTOEQUEQE_F) |
+	c.autoequiqe_to_viid = htonl(FW_EQ_ETH_CMD_AUTOEQUEQE_F |
 				     FW_EQ_ETH_CMD_VIID_V(pi->viid));
 
 	c.fetchszm_to_iqid =
-		htonl(FW_EQ_ETH_CMD_HOSTFCMODE_V(dbqt
-						 ? HOSTFCMODE_INGRESS_QUEUE_X
-						 : HOSTFCMODE_STATUS_PAGE_X) |
+		htonl(FW_EQ_ETH_CMD_HOSTFCMODE_V(HOSTFCMODE_STATUS_PAGE_X) |
 		      FW_EQ_ETH_CMD_PCIECHN_V(pi->tx_chan) |
 		      FW_EQ_ETH_CMD_FETCHRO_F | FW_EQ_ETH_CMD_IQID_V(iqid));
 
-- 
2.9.5

