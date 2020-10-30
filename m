Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD0862A0D07
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:02:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbgJ3SCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:02:45 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:30395 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725808AbgJ3SCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:02:45 -0400
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 09UI2Suv020754;
        Fri, 30 Oct 2020 11:02:41 -0700
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v4 03/10] ch_ktls: Update cheksum information
Date:   Fri, 30 Oct 2020 23:32:18 +0530
Message-Id: <20201030180225.11089-4-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201030180225.11089-1-rohitm@chelsio.com>
References: <20201030180225.11089-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checksum update was missing in the WR.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 447aec7ae954..a1448a1b38fd 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -947,18 +947,17 @@ static int
 chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 			    struct sge_eth_txq *q, uint32_t tx_chan)
 {
+	u32 ctrl, iplen, maclen, pktlen, ndesc, len16;
 	struct fw_eth_tx_pkt_wr *wr;
 	struct cpl_tx_pkt_core *cpl;
-	u32 ctrl, iplen, maclen;
 #if IS_ENABLED(CONFIG_IPV6)
 	struct ipv6hdr *ip6;
 #endif
-	unsigned int ndesc;
 	struct tcphdr *tcp;
-	int len16, pktlen;
+	u8 buf[150] = {0};
 	struct iphdr *ip;
 	int credits;
-	u8 buf[150];
+	u64 cntrl1;
 	void *pos;
 
 	iplen = skb_network_header_len(skb);
@@ -997,22 +996,28 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 			   TXPKT_PF_V(tx_info->adap->pf));
 	cpl->pack = 0;
 	cpl->len = htons(pktlen);
-	/* checksum offload */
-	cpl->ctrl1 = 0;
-
-	pos = cpl + 1;
 
 	memcpy(buf, skb->data, pktlen);
 	if (tx_info->ip_family == AF_INET) {
 		/* we need to correct ip header len */
 		ip = (struct iphdr *)(buf + maclen);
 		ip->tot_len = htons(pktlen - maclen);
+		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else {
 		ip6 = (struct ipv6hdr *)(buf + maclen);
 		ip6->payload_len = htons(pktlen - maclen - iplen);
+		cntrl1 = TXPKT_CSUM_TYPE_V(TX_CSUM_TCPIP6);
 #endif
 	}
+
+	cntrl1 |= T6_TXPKT_ETHHDR_LEN_V(maclen - ETH_HLEN) |
+		  TXPKT_IPHDR_LEN_V(iplen);
+	/* checksum offload */
+	cpl->ctrl1 = cpu_to_be64(cntrl1);
+
+	pos = cpl + 1;
+
 	/* now take care of the tcp header, if fin is not set then clear push
 	 * bit as well, and if fin is set, it will be sent at the last so we
 	 * need to update the tcp sequence number as per the last packet.
-- 
2.18.1

