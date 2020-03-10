Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE29180105
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 16:04:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727745AbgCJPEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 11:04:14 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28920 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727693AbgCJPEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 11:04:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02AEtwgA011910;
        Tue, 10 Mar 2020 08:04:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=OkHwsEPs0hTcyRKQ/KXUC7j/cmMU936nilDEWxzdRe8=;
 b=YzCPAkKUHNBzxHfaUQ69wAGlbbHiKoLZfapY0gMEAqd65hRY0hRm6OPV0RlGxtiuk00g
 Y0/YpQaQqAeYq+9jz7BELPAY0RSLeBqBYd6duCb2BX4jB/O8Py6xIpQd6+pGV3C05+br
 hFGWncFbzt0mfn22TnzjL9Jf3MS+Dna7pVDo2jPd6hf20BHZwV2j7wjMc2KmsUKHsc6b
 BqOZ69Y0zbLTdjNiTB6zk4GlILzPsJ8vKICE+97ELKBbcxxEj69EbLnuGDfbtSzSfRPC
 KG3umsaxkW/vjhk7Vp3e3Kp6dWVCL4zZ0dO86x0jJ5YO84ZcmVEc1LOzoZWXm1Tmq70p Iw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2yp04fm0rb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Mar 2020 08:04:10 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 10 Mar
 2020 08:04:08 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 10 Mar 2020 08:04:08 -0700
Received: from NN-LT0019.rdc.aquantia.com (nn-lt0019.marvell.com [10.9.16.69])
        by maili.marvell.com (Postfix) with ESMTP id 422033F703F;
        Tue, 10 Mar 2020 08:04:07 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC v2 07/16] net: macsec: support multicast/broadcast when offloading
Date:   Tue, 10 Mar 2020 18:03:33 +0300
Message-ID: <20200310150342.1701-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200310150342.1701-1-irusskikh@marvell.com>
References: <20200310150342.1701-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-10_08:2020-03-10,2020-03-10 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

The idea is simple. If the frame is an exact match for the controlled port
(based on DA comparison), then we simply divert this skb to matching port.

Multicast/broadcast messages are delivered to all ports.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 drivers/net/macsec.c | 51 +++++++++++++++++++++++++++++++++-----------
 1 file changed, 38 insertions(+), 13 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 45ede40692f8..20a5b4c414d0 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -947,22 +947,53 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 {
 	/* Deliver to the uncontrolled port by default */
 	enum rx_handler_result ret = RX_HANDLER_PASS;
+	struct ethhdr *hdr = eth_hdr(skb);
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
 
-	/* 10.6 If the management control validateFrames is not
-	 * Strict, frames without a SecTAG are received, counted, and
-	 * delivered to the Controlled Port
-	 */
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct sk_buff *nskb;
 		struct pcpu_secy_stats *secy_stats = this_cpu_ptr(macsec->stats);
+		struct net_device *ndev = macsec->secy.netdev;
 
-		if (!macsec_is_offloaded(macsec) &&
-		    macsec->secy.validate_frames == MACSEC_VALIDATE_STRICT) {
+		/* If h/w offloading is enabled, HW decodes frames and strips
+		 * the SecTAG, so we have to deduce which port to deliver to.
+		 */
+		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
+			if (ether_addr_equal_64bits(hdr->h_dest,
+						    ndev->dev_addr)) {
+				/* exact match, divert skb to this port */
+				skb->dev = ndev;
+				skb->pkt_type = PACKET_HOST;
+				ret = RX_HANDLER_ANOTHER;
+				goto out;
+			} else if (is_multicast_ether_addr_64bits(
+					   hdr->h_dest)) {
+				/* multicast frame, deliver on this port too */
+				nskb = skb_clone(skb, GFP_ATOMIC);
+				if (!nskb)
+					break;
+
+				nskb->dev = ndev;
+				if (ether_addr_equal_64bits(hdr->h_dest,
+							    ndev->broadcast))
+					nskb->pkt_type = PACKET_BROADCAST;
+				else
+					nskb->pkt_type = PACKET_MULTICAST;
+
+				netif_rx(nskb);
+			}
+			continue;
+		}
+
+		/* 10.6 If the management control validateFrames is not
+		 * Strict, frames without a SecTAG are received, counted, and
+		 * delivered to the Controlled Port
+		 */
+		if (macsec->secy.validate_frames == MACSEC_VALIDATE_STRICT) {
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsNoTag++;
 			u64_stats_update_end(&secy_stats->syncp);
@@ -974,19 +1005,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		if (!nskb)
 			break;
 
-		nskb->dev = macsec->secy.netdev;
+		nskb->dev = ndev;
 
 		if (netif_rx(nskb) == NET_RX_SUCCESS) {
 			u64_stats_update_begin(&secy_stats->syncp);
 			secy_stats->stats.InPktsUntagged++;
 			u64_stats_update_end(&secy_stats->syncp);
 		}
-
-		if (netif_running(macsec->secy.netdev) &&
-		    macsec_is_offloaded(macsec)) {
-			ret = RX_HANDLER_EXACT;
-			goto out;
-		}
 	}
 
 out:
-- 
2.17.1

