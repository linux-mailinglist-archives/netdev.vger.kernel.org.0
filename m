Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E5CF21F966
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 20:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgGNS3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 14:29:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:34910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729091AbgGNS3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 14:29:31 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9DC227BF;
        Tue, 14 Jul 2020 18:29:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594751370;
        bh=0EiG3QGqO7QCfDZ6dIa2qqLC48WhblZk/k5njvsAhR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mgXeSwwKvUPumKBTCbaPOqYAmcR3dJGvb+ZMPxWdjWZjPYnrfoQqqflUBQGMFder4
         PR+OU12+SDNjiZs3+ChdDpueGyKLVoK45zwu/B/Cw5IjAv79r8G/INDaFkOkRfylOp
         RRhN4B/Wr7U57gtNF4d0Xx4F0BavSoNRq66NKNP8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        thomas.lendacky@amd.com, aelior@marvell.com, skalluru@marvell.com,
        vishal@chelsio.com, benve@cisco.com, _govind@gmx.com,
        dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        jeffrey.t.kirsher@intel.com, anthony.l.nguyen@intel.com,
        GR-everest-linux-l2@marvell.com, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 03/12] xgbe: switch to more generic VxLAN detection
Date:   Tue, 14 Jul 2020 11:28:59 -0700
Message-Id: <20200714182908.690108-4-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714182908.690108-1-kuba@kernel.org>
References: <20200714182908.690108-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of looping though the list of ports just check
if the geometry of the packet is correct for VxLAN.
HW most likely doesn't care about the exact port, anyway,
since only first port is actually offloaded, and this way
we won't have to maintain the port list at all.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 27 +++++++-----------------
 1 file changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index a87264f95f1a..dfeddf5fbf78 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1773,13 +1773,8 @@ static int xgbe_prep_tso(struct sk_buff *skb, struct xgbe_packet_data *packet)
 	return 0;
 }
 
-static bool xgbe_is_vxlan(struct xgbe_prv_data *pdata, struct sk_buff *skb)
+static bool xgbe_is_vxlan(struct sk_buff *skb)
 {
-	struct xgbe_vxlan_data *vdata;
-
-	if (pdata->vxlan_force_disable)
-		return false;
-
 	if (!skb->encapsulation)
 		return false;
 
@@ -1801,19 +1796,13 @@ static bool xgbe_is_vxlan(struct xgbe_prv_data *pdata, struct sk_buff *skb)
 		return false;
 	}
 
-	/* See if we have the UDP port in our list */
-	list_for_each_entry(vdata, &pdata->vxlan_ports, list) {
-		if ((skb->protocol == htons(ETH_P_IP)) &&
-		    (vdata->sa_family == AF_INET) &&
-		    (vdata->port == udp_hdr(skb)->dest))
-			return true;
-		else if ((skb->protocol == htons(ETH_P_IPV6)) &&
-			 (vdata->sa_family == AF_INET6) &&
-			 (vdata->port == udp_hdr(skb)->dest))
-			return true;
-	}
+	if (skb->inner_protocol_type != ENCAP_TYPE_ETHER ||
+	    skb->inner_protocol != htons(ETH_P_TEB) ||
+	    (skb_inner_mac_header(skb) - skb_transport_header(skb) !=
+	     sizeof(struct udphdr) + sizeof(struct vxlanhdr)))
+		return false;
 
-	return false;
+	return true;
 }
 
 static int xgbe_is_tso(struct sk_buff *skb)
@@ -1864,7 +1853,7 @@ static void xgbe_packet_info(struct xgbe_prv_data *pdata,
 		XGMAC_SET_BITS(packet->attributes, TX_PACKET_ATTRIBUTES,
 			       CSUM_ENABLE, 1);
 
-	if (xgbe_is_vxlan(pdata, skb))
+	if (xgbe_is_vxlan(skb))
 		XGMAC_SET_BITS(packet->attributes, TX_PACKET_ATTRIBUTES,
 			       VXLAN, 1);
 
-- 
2.26.2

