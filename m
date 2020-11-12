Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3D92B0848
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:20:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728616AbgKLPT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:19:59 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55928 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727932AbgKLPT7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:19:59 -0500
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id B0568200FE;
        Thu, 12 Nov 2020 15:19:57 +0000 (UTC)
Received: from us4-mdac16-24.at1.mdlocal (unknown [10.110.49.206])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id AE4EA800AF;
        Thu, 12 Nov 2020 15:19:57 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 17D7B10007F;
        Thu, 12 Nov 2020 15:19:57 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D4877140055;
        Thu, 12 Nov 2020 15:19:56 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 12 Nov
 2020 15:19:51 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 2/3] sfc: correctly support non-partial
 GSO_UDP_TUNNEL_CSUM on EF100
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <eda2de73-edf2-8b92-edb9-099ebda09ebc@solarflare.com>
Message-ID: <6c770e62-231c-6c98-d850-820a9c9a1012@solarflare.com>
Date:   Thu, 12 Nov 2020 15:19:47 +0000
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
X-TM-AS-Result: No-0.493000-8.000000-10
X-TMASE-MatchedRID: TWnYCMK5KzdCeO9z35rMg0V4CvmC4hgmZAGtCJE23YjzB9ACjDXPutti
        DkJwpre6tipQQRHpDAAX0wellvm416H2g9syPs888Kg68su2wyE/pOSL72dTfwdkFovAReUoaUX
        s6FguVy0jW5FWKYjOGB238RECSCTtHzpIYp97uNYgCPGiZqtI8D4H4hoqLeJJH1bhq4z+yfRAvt
        BOrQ7+YI1gywLb9VwiIDTeqMjs2DvjN5FxHmqL+T9eH8dNy75y5kzxLgNhSillEnpqwB4ckaPFj
        JEFr+olA9Mriq0CDAg9wJeM2pSaRVgXepbcl7r7gJwNekNcqRsVtunJa77J297aYbIsxaDLix0s
        f028gLsx0/5NDE6dKrHmc46TQnW7qCSWvg10XvDUavu8ykObvWfwm7RvQdj7McKpXuu/1jVAMwW
        4rY/0WO2hZq8RbsdETdnyMokJ1HTiaosWHm9+bH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.493000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25782.003
X-MDID: 1605194397-lvf_h0UvuEJN
X-PPE-DISP: 1605194397;lvf_h0UvuEJN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By asking the HW for the correct edits, we can make UDP tunnel TSO
 work without needing GSO_PARTIAL.  So don't specify it in our
 netdev->gso_partial_features.
However, retain GSO_PARTIAL support, as this will be used for other
 protocols later.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c | 1 -
 drivers/net/ethernet/sfc/ef100_tx.c  | 6 +++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index cd93c5ffd45c..05d22220228a 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -190,7 +190,6 @@ static int efx_ef100_init_datapath_caps(struct efx_nic *efx)
 		net_dev->features |= tso;
 		net_dev->hw_features |= tso;
 		net_dev->hw_enc_features |= tso;
-		net_dev->gso_partial_features |= NETIF_F_GSO_UDP_TUNNEL | NETIF_F_GSO_UDP_TUNNEL_CSUM;
 	}
 	efx->num_mac_stats = MCDI_WORD(outbuf,
 				       GET_CAPABILITIES_V4_OUT_MAC_STATS_NUM_STATS);
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index ad0ad9bad423..a9e045c54a79 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -196,6 +196,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 	bool encap = skb->encapsulation;
 	u16 vlan_enable = 0;
 	struct tcphdr *tcp;
+	bool outer_csum;
 	u32 paylen;
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
@@ -216,19 +217,21 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 		tcp_offset = skb_transport_offset(skb);
 		outer_ip_offset = outer_l4_offset = 0;
 	}
+	outer_csum = skb_shinfo(skb)->gso_type & SKB_GSO_UDP_TUNNEL_CSUM;
 
 	/* subtract TCP payload length from inner checksum */
 	tcp = (void *)skb->data + tcp_offset;
 	paylen = skb->len - tcp_offset;
 	csum_replace_by_diff(&tcp->check, (__force __wsum)htonl(paylen));
 
-	EFX_POPULATE_OWORD_17(*txd,
+	EFX_POPULATE_OWORD_19(*txd,
 			      ESF_GZ_TX_DESC_TYPE, ESE_GZ_TX_DESC_TYPE_TSO,
 			      ESF_GZ_TX_TSO_MSS, mss,
 			      ESF_GZ_TX_TSO_HDR_NUM_SEGS, 1,
 			      ESF_GZ_TX_TSO_PAYLOAD_NUM_SEGS, payload_segs,
 			      ESF_GZ_TX_TSO_HDR_LEN_W, buffer->len >> 1,
 			      ESF_GZ_TX_TSO_PAYLOAD_LEN, len,
+			      ESF_GZ_TX_TSO_CSO_OUTER_L4, outer_csum,
 			      ESF_GZ_TX_TSO_CSO_INNER_L4, 1,
 			      ESF_GZ_TX_TSO_INNER_L3_OFF_W, ip_offset >> 1,
 			      ESF_GZ_TX_TSO_INNER_L4_OFF_W, tcp_offset >> 1,
@@ -237,6 +240,7 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 			      ESF_GZ_TX_TSO_OUTER_L3_OFF_W, outer_ip_offset >> 1,
 			      ESF_GZ_TX_TSO_OUTER_L4_OFF_W, outer_l4_offset >> 1,
 			      ESF_GZ_TX_TSO_ED_OUTER_UDP_LEN, encap && !gso_partial,
+			      ESF_GZ_TX_TSO_ED_OUTER_IP_LEN, encap && !gso_partial,
 			      ESF_GZ_TX_TSO_ED_OUTER_IP4_ID, encap ? mangleid :
 								     ESE_GZ_TX_DESC_IP4_ID_NO_OP,
 			      ESF_GZ_TX_TSO_VLAN_INSERT_EN, vlan_enable,

