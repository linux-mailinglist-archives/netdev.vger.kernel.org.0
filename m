Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 729FA15DA2E
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 16:03:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729552AbgBNPDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 10:03:32 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:61338 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729534AbgBNPDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 10:03:32 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01EF17rv013964;
        Fri, 14 Feb 2020 07:03:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=wXLnKPXJXRPyfd3rE2K/h2qkIKui+8Vk4f8ly1lEfNw=;
 b=eiGXOhCsPdTSA3uklggpQ2ufCXVFovey1b0NKP7UGKp8h6UlsTbhUSjEOidqHooRuQLd
 0/4PcBflzk1s+zF3BAc2k9cfMiJgDzg5F0/Dh7laiWQ69FLxwyAIQ3WkTR92+fKogvwh
 5hmJbGD+E559ARMgov8sZKKG6Bo+WVDvw3nuKpnEr/VXbxL5tANw9cAnr9KqK4GsHRLa
 vYAloIRW7ZqV2Aq+HzDEu1Kte7JiiJSfE5NEQ9NTHN1fo/y7okkMCW4xqJOZbysoHbd8
 3PtyL4twtbkH4l6J5KP1EC8i6VF9gYo5ryoVklngtTPFltzn5sltStO7gq+GIByPHRFe kA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 2y4j5k3gsn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 14 Feb 2020 07:03:28 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:26 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 14 Feb
 2020 07:03:25 -0800
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 14 Feb 2020 07:03:25 -0800
Received: from NN-LT0019.rdc.aquantia.com (unknown [10.9.16.63])
        by maili.marvell.com (Postfix) with ESMTP id C27AC3F703F;
        Fri, 14 Feb 2020 07:03:23 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Mark Starovoytov <mstarovoitov@marvell.com>,
        Dmitry Bogdanov <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [RFC 08/18] net: macsec: support multicast/broadcast when offloading
Date:   Fri, 14 Feb 2020 18:02:48 +0300
Message-ID: <20200214150258.390-9-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200214150258.390-1-irusskikh@marvell.com>
References: <20200214150258.390-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-14_04:2020-02-12,2020-02-14 signatures=0
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
index 066d61238b11..01da47b47f64 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -952,22 +952,53 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
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
@@ -979,19 +1010,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
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

