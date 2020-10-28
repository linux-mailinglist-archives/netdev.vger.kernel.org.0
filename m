Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A233129E0CC
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 02:38:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbgJ1WDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 18:03:03 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56982 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727344AbgJ1WBt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 18:01:49 -0400
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 853842288D0
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:44:08 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 1ADC22006B;
        Wed, 28 Oct 2020 20:44:08 +0000 (UTC)
Received: from us4-mdac16-33.at1.mdlocal (unknown [10.110.49.217])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 151DF800A3;
        Wed, 28 Oct 2020 20:44:08 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.103])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id AFFF3100076;
        Wed, 28 Oct 2020 20:44:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 79254980067;
        Wed, 28 Oct 2020 20:44:07 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 28 Oct
 2020 20:44:02 +0000
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 3/4] sfc: only use fixed-id if the skb asks for it
To:     <linux-net-drivers@solarflare.com>, <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>
References: <6e1ea05f-faeb-18df-91ef-572445691d89@solarflare.com>
Message-ID: <0b94b8de-13e6-50e6-b103-0a0efb80e70a@solarflare.com>
Date:   Wed, 28 Oct 2020 20:43:59 +0000
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
X-TM-AS-Result: No-4.830300-8.000000-10
X-TMASE-MatchedRID: hRpdYn8u+pIIENpZF+ZYEP3HILfxLV/9V+kKrdT4/BIbkKx6EJE76bEp
        pMQFmBm/DefmZc9AdMshsKVDYsfUjKH2g9syPs888Kg68su2wyE/pOSL72dTfwdkFovAReUoaUX
        s6FguVy0+2ytywvtKgbJGjmYzpozRUKJZlzyOIwhHQFjzAbvJEILQ1EX7jGPgiiKPXbEds+7bYg
        5CcKa3uhx14Xc22OvfzGuD6v0N2hhJhDcRXZUUxp4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR
        4+zsDTtiN2nYwbbDKyxA0DjgtIlV4vrLXvkeKk6Wndqqtd6rgrUmKKbm4n/VZsMidJLpL6afln6
        OcIUZPmfRvA2C+90bbkttzk4iepTZEM43YoO8r985uoYr0mmWaKdpX90rRoSErdW3Lyhe2SmzZh
        Wcml82A==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.830300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25752.003
X-MDID: 1603917848-ISSwHHhqrjIo
X-PPE-DISP: 1603917848;ISSwHHhqrjIo
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AIUI, the NETIF_F_TSO_MANGLEID flag is a signal to the stack that a
 driver may _need_ to mangle IDs in order to do TSO, and conversely
 a signal from the stack that the driver is permitted to do so.
Since we support both fixed and incrementing IPIDs, we should rely
 on the SKB_GSO_FIXEDID flag on a per-skb basis, rather than using
 the MANGLEID feature to make all TSOs fixed-id.
Includes other minor cleanups of ef100_make_tso_desc() coding style.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef100_nic.c |  2 +-
 drivers/net/ethernet/sfc/ef100_tx.c  | 13 +++++++------
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index bf92cdc60cda..8a187a16ac89 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -694,7 +694,7 @@ static unsigned int ef100_check_caps(const struct efx_nic *efx,
 #define EF100_OFFLOAD_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_RXCSUM |	\
 	NETIF_F_HIGHDMA | NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_NTUPLE | \
 	NETIF_F_RXHASH | NETIF_F_RXFCS | NETIF_F_TSO_ECN | NETIF_F_RXALL | \
-	NETIF_F_TSO_MANGLEID | NETIF_F_HW_VLAN_CTAG_TX)
+	NETIF_F_HW_VLAN_CTAG_TX)
 
 const struct efx_nic_type ef100_pf_nic_type = {
 	.revision = EFX_REV_EF100,
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index d267b12bdaa0..ad0ad9bad423 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -187,21 +187,22 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 				struct efx_tx_buffer *buffer, efx_oword_t *txd,
 				unsigned int segment_count)
 {
-	u32 mangleid = (efx->net_dev->features & NETIF_F_TSO_MANGLEID) ||
-		skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID ?
-		ESE_GZ_TX_DESC_IP4_ID_NO_OP :
-		ESE_GZ_TX_DESC_IP4_ID_INC_MOD16;
-	u16 vlan_enable =  efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX ?
-		skb_vlan_tag_present(skb) : 0;
 	bool gso_partial = skb_shinfo(skb)->gso_type & SKB_GSO_PARTIAL;
 	unsigned int len, ip_offset, tcp_offset, payload_segs;
+	u32 mangleid = ESE_GZ_TX_DESC_IP4_ID_INC_MOD16;
 	unsigned int outer_ip_offset, outer_l4_offset;
 	u16 vlan_tci = skb_vlan_tag_get(skb);
 	u32 mss = skb_shinfo(skb)->gso_size;
 	bool encap = skb->encapsulation;
+	u16 vlan_enable = 0;
 	struct tcphdr *tcp;
 	u32 paylen;
 
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_TCP_FIXEDID)
+		mangleid = ESE_GZ_TX_DESC_IP4_ID_NO_OP;
+	if (efx->net_dev->features & NETIF_F_HW_VLAN_CTAG_TX)
+		vlan_enable = skb_vlan_tag_present(skb);
+
 	len = skb->len - buffer->len;
 	/* We use 1 for the TSO descriptor and 1 for the header */
 	payload_segs = segment_count - 2;

