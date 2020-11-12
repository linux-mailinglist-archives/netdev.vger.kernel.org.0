Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9177E2B084A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:20:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgKLPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:20:17 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:60032 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728258AbgKLPUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:20:16 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B4BCE201B9;
        Thu, 12 Nov 2020 15:20:15 +0000 (UTC)
Received: from us4-mdac16-63.at1.mdlocal (unknown [10.110.50.156])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B2DA2800AF;
        Thu, 12 Nov 2020 15:20:15 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.107])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1AA5E10007E;
        Thu, 12 Nov 2020 15:20:15 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D7834280080;
        Thu, 12 Nov 2020 15:20:14 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Nov
 2020 15:20:09 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/3] sfc: support GRE TSO on EF100
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
Message-ID: <07a77fe6-2418-d13a-9ef6-ea292ec87883@solarflare.com>
Date:   Thu, 12 Nov 2020 15:20:05 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25782.003
X-TM-AS-Result: No-3.008600-8.000000-10
X-TMASE-MatchedRID: 6q+DmWmERNooS/tMLUVY9eIfK/Jd5eHmprzcyrz2L10WhfQgHJ/xHkCQ
        j+h+9wPkdNLu0Uc2RiUN25tj8sME0qH2g9syPs888Kg68su2wyE/pOSL72dTfwdkFovAReUoaUX
        s6FguVy2/bQ5VOF8E64K2BS2ryBmc4pT+ud9Ye/oHtOpEBhWiFswx7VbZgGmK+G875WvUoRDfel
        djYKxB4ht8UJiMz9H8UGVEq8q5z4rloCs7pAMiMyT9vTe4FHdQrqNUh44b3oMo6/BioTjbkKPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRSdET58jp62SKW+Wt2vD66Z9dB9Zj7b9xH7joChQiie03WM5
        Codml8QigxlR1qZWV8/URmGOc4QqNVkooC8+ZQ1nyD9HuSCiNRX4hCOS9JJEMcKpXuu/1jVAMwW
        4rY/0WO2hZq8RbsdETdnyMokJ1HRF/CeP64tXnA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.008600-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25782.003
X-MDID: 1605194415-y01JdQjz-G2B
X-PPE-DISP: 1605194415;y01JdQjz-G2B
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We can treat SKB_GSO_GRE almost exactly the same as UDP tunnels, except
 that we don't want to edit the outer UDP len (as there isn't one).
For SKB_GSO_GRE_CSUM, we have to use GSO_PARTIAL as the device doesn't
 support offload of non-UDP outer L4 checksums.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 7 ++++++-
 drivers/net/ethernet/sfc/ef100_tx.c  | 6 +++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index 05d22220228a..518268ce2064 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -185,11 +185,16 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 	if (efx_ef100_has_cap(nic_data->datapath_caps2, TX_TSO_V3)) {
 		struct net_device *net_dev = efx->net_dev;
 		netdev_features_t tso = NETIF_F_TSO | NETIF_F_TSO6 | NETIF_F_GSO_PARTIAL |
-					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
+					NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM |
+					NETIF_F_GSO_GRE | NETIF_F_GSO_GRE_CSUM;
 
 		net_dev->features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
+		/* EF100 HW can only offload outer checksums if they are UDP,
+		 * so for GRE_CSUM we have to use GSO_PARTIAL.
+		 */
+		net_dev->gso_partial_features |= NETIF_F_GSO_GRE_CSUM;
 	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index a9e045c54a79..26ef51d6b542 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -194,6 +194,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 	u16 vlan_tci = skb_vlan_tag_get(skb);
 	u32 mss = skb_shinfo(skb)->gso_size;
 	bool encap = skb->encapsulation;
+	bool udp_encap = false;
 	u16 vlan_enable = 0;
 	struct tcphdr *tcp;
 	bool outer_csum;
@@ -212,6 +213,9 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 		outer_l4_offset = skb_transport_offset(skb);
 		ip_offset = skb_inner_network_offset(skb);
 		tcp_offset = skb_inner_transport_offset(skb);
+		if (skb_shinfo(skb)->gso_type &
+		    (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))
+			udp_encap = true;
 	} else {
 		ip_offset =  skb_network_offset(skb);
 		tcp_offset = skb_transport_offset(skb);
@@ -239,7 +243,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 			      ESF_GZ_TX_TSO_ED_INNER_IP_LEN, 1,
 			      ESF_GZ_TX_TSO_OUTER_L3_OFF_W, outer_ip_offset >> 1,
 			      ESF_GZ_TX_TSO_OUTER_L4_OFF_W, outer_l4_offset >> 1,
-			      ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, encap && !gso_partial,
+			      ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, udp_encap && !gso_partial,
 			      ESF_GZ_TX_TSO_ED_OUTER_IP_LEN, encap && !gso_partial,
 			      ESF_GZ_TX_TSO_ED_OUTER_IP4_ID, encap ? mangleid :
 								     ESE_GZ_TX_DESC_IP4_ID_NO_OP,
