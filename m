Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8F0E3B24
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440104AbfJXSjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:39:47 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:38486 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440077AbfJXSjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:39:46 -0400
Received: from v4.asicdesigners.com (v4.blr.asicdesigners.com [10.193.186.237])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x9OIdVPn007332;
        Thu, 24 Oct 2019 11:39:37 -0700
From:   Raju Rangoju <rajur@chelsio.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     vishal@chelsio.com, nirranjan@chelsio.com, dt@chelsio.com,
        rajur@chelsio.com
Subject: [PATCH v2 net] cxgb4: request the TX CIDX updates to status page
Date:   Fri, 25 Oct 2019 00:09:16 +0530
Message-Id: <20191024183916.11800-1-rajur@chelsio.com>
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

Request the Hardware to write the CIDX Updates into the Status Page
(at the end of the TX Queue) rather than generating an ingress
queue message (as an interrupt). It helps in reducing the load on
PCIe link and further improving the BW at lower IO sizes.

Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
Signed-off-by: Raju Rangoju <rajur@chelsio.com>

---
Changes since V1:
 - modified the commit message
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index b3da81e90132..46758ca7846d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -3785,21 +3785,14 @@ int t4_sge_alloc_eth_txq(struct adapter *adap, struct sge_eth_txq *txq,
 	c.alloc_to_len16 = htonl(FW_EQ_ETH_CMD_ALLOC_F |
 				 FW_EQ_ETH_CMD_EQSTART_F | FW_LEN16(c));
 
-	/* For TX Ethernet Queues using the SGE Doorbell Queue Timer
-	 * mechanism, we use Ingress Queue messages for Hardware Consumer
-	 * Index Updates on the TX Queue.  Otherwise we have the Hardware
-	 * write the CIDX Updates into the Status Page at the end of the
-	 * TX Queue.
+	/* Request the Hardware to write the CIDX Updates into the
+	 * Status Page at the end of the TX Queue.
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

