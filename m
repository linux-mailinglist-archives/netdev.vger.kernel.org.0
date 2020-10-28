Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6AE29E0D8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:38:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729885AbgJ1WDB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:03:01 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56828 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728420AbgJ1WBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:01:49 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id CBA4D2288C1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:43:59 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 68F0820062;
        Wed, 28 Oct 2020 20:43:59 +0000 (UTC)
Received: from us4-mdac16-21.at1.mdlocal (unknown [10.110.49.203])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 66CBC8009B;
        Wed, 28 Oct 2020 20:43:59 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (admin2.mdlocal [10.110.48.53])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E2E0340084;
        Wed, 28 Oct 2020 20:43:58 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 9C5FBA00061;
        Wed, 28 Oct 2020 20:43:58 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct
 2020 20:43:41 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/4] sfc: implement encap TSO on EF100
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Message-ID: <94ca05ca-2871-3da6-e14f-0a9cb48ed2a5@solarflare.com>
Date:   Wed, 28 Oct 2020 20:43:39 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25752.003
X-TM-AS-Result: No-4.862100-8.000000-10
X-TMASE-MatchedRID: MGo7m+8Tw8EhqOTHIlh7zkdAWPMBu8kQ+LljbN4c70MUvn93ewYigjd3
        6q149aCOCmviniliH8oVrJjIZW/qJPzvA5uNtDbPuoibJpHRrFmpXdWa4gU0SzLZyQk29Rf4rUj
        jMrcBP6Fnz/tr+VrHWlO9V994jC9DBRx9b+h52aqcVWc2a+/ju0tc8DbogbSE31GU/N5W5BB4pq
        O87q5acP7+c8aUCZ8pLIJQYNcPviYEL+qFx24QujQ60lWQoG0rXGjQf7uckKvhWjjGhpcHL/em3
        /0HxOy9u5h9co4nGEOIJXwFB+8S+Es3SiaAjbkfMiMrbc70Pfc+B+IaKi3iSUdmDSBYfnJR2RtX
        HKJh9FMTmTRJBVsPwA3KhoD02XFZoycGiHkOAtAXK/dRaOWlvQRryDXHx6oXzbzwSOFaB2hXCD9
        ofCprZn80P0kX93DmFIFGmfOeVE6XBXaJoB9JZzl/1fD/GopdcmfM3DjaQLHEQdG7H66TyHEqm8
        QYBtMO2VIirNkmpVKyML6pSYmRJwuISyMglTkcz3q8BxgufpB+sAjV3hPeWjNEJxmO547EN0QYT
        GsyGYSrHMnKw8eWAuoLtnaOVwdBGhBWFwMpQfUlEjOZsGnBpCAkKbrKkYtniQWaoMYDBaY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.862100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25752.003
X-MDID: 1603917839-yk1_nsItG9Pt
X-PPE-DISP: 1603917839;yk1_nsItG9Pt
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The NIC only needs to know where the headers it has to edit (TCP and
 inner and outer IPv4) are, which fits GSO_PARTIAL nicely.
It also supports non-PARTIAL offload of UDP tunnels, again just
 needing to be told the outer transport offset so that it can edit
 the UDP length field.
(It's not clear to me whether the stack will ever use the non-PARTIAL
 version with the netdev feature flags we're setting here.)

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 13 ++++++--
 drivers/net/ethernet/sfc/ef100_tx.c  | 45 ++++++++++++++++------------
 2 files changed, 37 insertions(+), 21 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 3148fe770356..bf92cdc60cda 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -182,8 +182,16 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 	if (rc)
 		return rc;
 
-	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3))
-		efx->net_dev->features |= NETIF_F_TSO | NETIF_F_TSO6;
+	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
+		struct net_device *net_dev = efx->net_dev;
+		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
+					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+
+		net_dev->features |= tso;
+		net_dev->hw_features |= tso;
+		net_dev->hw_enc_features |= tso;
+		net_dev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
 	netif_dbg(efx, probe, efx->net_dev,
@@ -1101,6 +1109,7 @@ static int ef100_probe_main(struct efx_nic *efx)
 	nic_data->efx = efx;
 	net_dev->features |= efx->type->offload_features;
 	net_dev->hw_features |= efx->type->offload_features;
+	net_dev->hw_enc_features |= efx->type->offload_features;
 
 	/* Populate design-parameter defaults */
 	nic_data->tso_max_hdr_len = ESE_EF100_DP_GZ_TSO_MAX_HDR_LEN_DEFAULT;
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index a90e5a9d2a37..d267b12bdaa0 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -54,8 +54,6 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	struct efx_nic *efx = tx_queue->efx;
 	struct ef100_nic_data *nic_data;
 	struct efx_tx_buffer *buffer;
-	struct tcphdr *tcphdr;
-	struct iphdr *iphdr;
 	size_t header_len;
 	u32 mss;
 
@@ -98,20 +96,6 @@ static bool ef100_tx_can_tso(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	buffer->unmap_len = 0;
 	buffer->skb = skb;
 	++tx_queue->insert_count;
-
-	/* Adjust the TCP checksum to exclude the total length, since we set
-	 * ED_INNER_IP_LEN in the descriptor.
-	 */
-	tcphdr = tcp_hdr(skb);
-	if (skb_is_gso_v6(skb)) {
-		tcphdr->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
-						 &ipv6_hdr(skb)->daddr,
-						 0, IPPROTO_TCP, 0);
-	} else {
-		iphdr = ip_hdr(skb);
-		tcphdr->check = ~csum_tcpudp_magic(iphdr->saddr, iphdr->daddr,
-						   0, IPPROTO_TCP, 0);
-	}
 	return true;
 }
 
@@ -209,17 +193,35 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 		ESE_GZ_TX_DESC_IP4_ID_INC_MOD16;
 	u16 vlan_enable =  efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX ?
 		skb_vlan_tag_present(skb) : 0;
+	bool gso_partial = skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL;
 	unsigned int len, ip_offset, tcp_offset, payload_segs;
+	unsigned int outer_ip_offset, outer_l4_offset;
 	u16 vlan_tci = skb_vlan_tag_get(skb);
 	u32 mss = skb_shinfo(skb)->gso_size;
+	bool encap = skb->encapsulation;
+	struct tcphdr *tcp;
+	u32 paylen;
 
 	len = skb->len - buffer->len;
 	/* We use 1 for the TSO descriptor and 1 for the header */
 	payload_segs = segment_count - 2;
-	ip_offset =  skb_network_offset(skb);
-	tcp_offset = skb_transport_offset(skb);
+	if (encap) {
+		outer_ip_offset = skb_network_offset(skb);
+		outer_l4_offset = skb_transport_offset(skb);
+		ip_offset = skb_inner_network_offset(skb);
+		tcp_offset = skb_inner_transport_offset(skb);
+	} else {
+		ip_offset =  skb_network_offset(skb);
+		tcp_offset = skb_transport_offset(skb);
+		outer_ip_offset = outer_l4_offset = 0;
+	}
+
+	/* subtract TCP payload length from inner checksum */
+	tcp = (void *)skb->data + tcp_offset;
+	paylen = skb->len - tcp_offset;
+	csum_replace_by_diff(&tcp->check, (__force __wsum)htonl(paylen));
 
-	EFX_POPULATE_OWORD_13(*txd,
+	EFX_POPULATE_OWORD_17(*txd,
 			      ESF_GZ_TX_DESC_TYPE, ESE_GZ_TX_DESC_TYPE_TSO,
 			      ESF_GZ_TX_TSO_MSS, mss,
 			      ESF_GZ_TX_TSO_HDR_NUM_SEGS, 1,
@@ -231,6 +233,11 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 			      ESF_GZ_TX_TSO_INNER_L4_OFF_W, tcp_offset >> 1,
 			      ESF_GZ_TX_TSO_ED_INNER_IP4_ID, mangleid,
 			      ESF_GZ_TX_TSO_ED_INNER_IP_LEN, 1,
+			      ESF_GZ_TX_TSO_OUTER_L3_OFF_W, outer_ip_offset >> 1,
+			      ESF_GZ_TX_TSO_OUTER_L4_OFF_W, outer_l4_offset >> 1,
+			      ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, encap && !gso_partial,
+			      ESF_GZ_TX_TSO_ED_OUTER_IP4_ID, encap ? mangleid :
+								     ESE_GZ_TX_DESC_IP4_ID_NO_OP,
 			      ESF_GZ_TX_TSO_VLAN_INSERT_EN, vlan_enable,
 			      ESF_GZ_TX_TSO_VLAN_INSERT_TCI, vlan_tci
 		);

