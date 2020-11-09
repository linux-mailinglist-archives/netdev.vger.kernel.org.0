Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B932AB574
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgKIKwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:52:42 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:7783 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729343AbgKIKwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:52:40 -0500
Received: from localhost.localdomain (redhouse.blr.asicdesigners.com [10.193.185.57])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0A9AqQMc011444;
        Mon, 9 Nov 2020 02:52:36 -0800
From:   Rohit Maheshwari <rohitm@chelsio.com>
To:     kuba@kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Cc:     secdev@chelsio.com, Rohit Maheshwari <rohitm@chelsio.com>
Subject: [net v6 03/12] ch_ktls: Update cheksum information
Date:   Mon,  9 Nov 2020 16:21:33 +0530
Message-Id: <20201109105142.15398-4-rohitm@chelsio.com>
X-Mailer: git-send-email 2.18.1
In-Reply-To: <20201109105142.15398-1-rohitm@chelsio.com>
References: <20201109105142.15398-1-rohitm@chelsio.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Checksum update was missing in the WR.

Fixes: 429765a149f1 ("chcr: handle partial end part of a record")
Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
---
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c     | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 447aec7ae954..b7a3e757ee72 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -959,6 +959,7 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
 	struct iphdr *ip;
 	int credits;
 	u8 buf[150];
+	u64 cntrl1;
 	void *pos;
 
 	iplen = skb_network_header_len(skb);
@@ -997,22 +998,28 @@ chcr_ktls_write_tcp_options(struct chcr_ktls_info *tx_info, struct sk_buff *skb,
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

