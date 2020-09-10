Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31B082650E3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgIJUf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:35:29 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35544 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726893AbgIJUdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:33:43 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7F45E600B4;
        Thu, 10 Sep 2020 20:33:42 +0000 (UTC)
Received: from us4-mdac16-29.ut7.mdlocal (unknown [10.7.66.139])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 7D1A98009E;
        Thu, 10 Sep 2020 20:33:42 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E9E5880052;
        Thu, 10 Sep 2020 20:33:41 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 80AA9BC007D;
        Thu, 10 Sep 2020 20:33:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Sep
 2020 21:33:36 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 6/7] sfc: implement encapsulated TSO on EF10
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Message-ID: <5b29e89e-7394-5cf3-e377-11b6ac1a964f@solarflare.com>
Date:   Thu, 10 Sep 2020 21:33:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25656.007
X-TM-AS-Result: No-8.985400-8.000000-10
X-TMASE-MatchedRID: 5pkKPw1ETgXbUSlFWXatlLsHVDDM5xAP1JP9NndNOkUda1Vk3RqxOHIo
        zGa69omdrdoLblq9S5oO8oAkUYa35OkRkiOij/UrR0BY8wG7yRB92481RZz42rlmMfLNiukaFfZ
        qFf4/LXJbbAX22cSkBDgJ+EV63RHnCh/G5x2ZkCqYsQ8meK57By8or/7xcxJECkKOpUQuXBUbTO
        GiOQJTfFuK1lmDh3Nub+/COiqX2vGCDNvA+9+VG8ebIMlISwjb5T1HpvyeXOSk+oW3oLzmHuLSd
        VP2tZn5DGa/pWDW//IxJT+9mYBOxBNhZ/XJyO6XGjzBgnFZvQ5ESUW/Y5v0Ep+4ziUPq4LxvQn7
        DslvScHrqNjMROw+yO8TEIh4RUxdMsFLDxbgfaUWqJ/PBjhtWsoioCrSMgeKXZgp9Jjp/MymS7T
        DIKNasLryT9rSPFf7ukODB/hp/ilNfs8n85Te8oMbH85DUZXy3QfwsVk0UbuGrPnef/I+em4CYC
        f8U5ARDEmzg9VGgwRCWv451r5bnG5Ny7qTzvOPr2a15/0+H5s=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--8.985400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25656.007
X-MDID: 1599770022-gsRPrkbm3fZi
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From the 8000 series onwards, EF10 NICs with suitable firmware are able
 to perform TSO within VXLAN or NVGRE encapsulation.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c       | 55 ++++++++++++++++++++-------
 drivers/net/ethernet/sfc/net_driver.h |  5 +++
 2 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index c6507d1f79fe..4775b822519d 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2179,10 +2179,11 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			 bool *data_mapped)
 {
 	struct efx_tx_buffer *buffer;
+	u16 inner_ipv4_id = 0;
+	u16 outer_ipv4_id = 0;
 	struct tcphdr *tcp;
 	struct iphdr *ip;
-
-	u16 ipv4_id;
+	u16 ip_tot_len;
 	u32 seqnum;
 	u32 mss;
 
@@ -2195,21 +2196,43 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 		return -EINVAL;
 	}
 
-	ip = ip_hdr(skb);
+	if (skb->encapsulation) {
+		if (!tx_queue->tso_encap)
+			return -EINVAL;
+		ip = ip_hdr(skb);
+		if (ip->version == 4)
+			outer_ipv4_id = ntohs(ip->id);
+
+		ip = inner_ip_hdr(skb);
+		tcp = inner_tcp_hdr(skb);
+	} else {
+		ip = ip_hdr(skb);
+		tcp = tcp_hdr(skb);
+	}
+
+	/* 8000-series EF10 hardware requires that IP Total Length be
+	 * greater than or equal to the value it will have in each segment
+	 * (which is at most mss + 208 + TCP header length), but also less
+	 * than (0x10000 - inner_network_header).  Otherwise the TCP
+	 * checksum calculation will be broken for encapsulated packets.
+	 * We fill in ip->tot_len with 0xff30, which should satisfy the
+	 * first requirement unless the MSS is ridiculously large (which
+	 * should be impossible as the driver max MTU is 9216); it is
+	 * guaranteed to satisfy the second as we only attempt TSO if
+	 * inner_network_header <= 208.
+	 */
+	ip_tot_len = -EFX_TSO2_MAX_HDRLEN;
+	EFX_WARN_ON_ONCE_PARANOID(mss + EFX_TSO2_MAX_HDRLEN +
+				  (tcp->doff << 2u) > ip_tot_len);
+
 	if (ip->version == 4) {
-		/* Modify IPv4 header if needed. */
-		ip->tot_len = 0;
+		ip->tot_len = htons(ip_tot_len);
 		ip->check = 0;
-		ipv4_id = ntohs(ip->id);
+		inner_ipv4_id = ntohs(ip->id);
 	} else {
-		/* Modify IPv6 header if needed. */
-		struct ipv6hdr *ipv6 = ipv6_hdr(skb);
-
-		ipv6->payload_len = 0;
-		ipv4_id = 0;
+		((struct ipv6hdr *)ip)->payload_len = htons(ip_tot_len);
 	}
 
-	tcp = tcp_hdr(skb);
 	seqnum = ntohl(tcp->seq);
 
 	buffer = efx_tx_queue_get_insert_buffer(tx_queue);
@@ -2222,7 +2245,7 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 			ESF_DZ_TX_OPTION_TYPE, ESE_DZ_TX_OPTION_DESC_TSO,
 			ESF_DZ_TX_TSO_OPTION_TYPE,
 			ESE_DZ_TX_TSO_OPTION_DESC_FATSO2A,
-			ESF_DZ_TX_TSO_IP_ID, ipv4_id,
+			ESF_DZ_TX_TSO_IP_ID, inner_ipv4_id,
 			ESF_DZ_TX_TSO_TCP_SEQNO, seqnum
 			);
 	++tx_queue->insert_count;
@@ -2232,11 +2255,12 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
 	buffer->flags = EFX_TX_BUF_OPTION;
 	buffer->len = 0;
 	buffer->unmap_len = 0;
-	EFX_POPULATE_QWORD_4(buffer->option,
+	EFX_POPULATE_QWORD_5(buffer->option,
 			ESF_DZ_TX_DESC_IS_OPT, 1,
 			ESF_DZ_TX_OPTION_TYPE, ESE_DZ_TX_OPTION_DESC_TSO,
 			ESF_DZ_TX_TSO_OPTION_TYPE,
 			ESE_DZ_TX_TSO_OPTION_DESC_FATSO2B,
+			ESF_DZ_TX_TSO_OUTER_IPID, outer_ipv4_id,
 			ESF_DZ_TX_TSO_TCP_MSS, mss
 			);
 	++tx_queue->insert_count;
@@ -2322,6 +2346,9 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 			     ESF_DZ_TX_TIMESTAMP, tx_queue->timestamping);
 	tx_queue->write_count = 1;
 
+	if (tx_queue->tso_version == 2 && efx_has_cap(efx, TX_TSO_V2_ENCAP))
+		tx_queue->tso_encap = true;
+
 	wmb();
 	efx_ef10_push_tx_desc(tx_queue, txd);
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ddcd1c46e3f3..a4c0445a3e88 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -77,6 +77,9 @@
 /* Minimum MTU, from RFC791 (IP) */
 #define EFX_MIN_MTU 68
 
+/* Maximum total header length for TSOv2 */
+#define EFX_TSO2_MAX_HDRLEN	208
+
 /* Size of an RX scatter buffer.  Small enough to pack 2 into a 4K page,
  * and should be a multiple of the cache line size.
  */
@@ -195,6 +198,7 @@ struct efx_tx_buffer {
  *	Is our index within @channel->tx_queue array.
  * @type: configuration type of this TX queue.  A bitmask of %EFX_TXQ_TYPE_* flags.
  * @tso_version: Version of TSO in use for this queue.
+ * @tso_encap: Is encapsulated TSO supported? Supported in TSOv2 on 8000 series.
  * @channel: The associated channel
  * @core_txq: The networking core TX queue structure
  * @buffer: The software buffer ring
@@ -258,6 +262,7 @@ struct efx_tx_queue {
 	unsigned int label;
 	unsigned int type;
 	unsigned int tso_version;
+	bool tso_encap;
 	struct efx_channel *channel;
 	struct netdev_queue *core_txq;
 	struct efx_tx_buffer *buffer;

