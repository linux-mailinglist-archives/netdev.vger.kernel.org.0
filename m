Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6697B1928F1
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbgCYMxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727460AbgCYMxN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:13 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp54H014665;
        Wed, 25 Mar 2020 05:53:10 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=73hHJf4OezBY000vSHrVIhFi5q3RobR97wc08AVFiyo=;
 b=X96ig4jeeT12Dw47lrz2aYAKkGgLx0NhdF6iZ/I0Krqbov/YTj7+MemZmNWEsaks34xn
 4j4xJf1t1tah5KB8bCC/7xSgIp0re2IKBkaz+Q1PXCwqgF/KkIvGh/g4T02G7NXXtJeI
 +mMC0P5SUSqmR3CURNPSxRrF1Z8dtiPbZlGwQAv4hK849crRp0RKe3iDOYTyTXafEFGs
 g+k+HlE2IU9D+HT0IwRSf9OGeOUVV/rpAX7VUJSyAsuS2sPl/gyKWNsW4jN32sWj7gUn
 m1k/lTL2a/Ngn5Mo1ybe530usg2p+Ex+YeUk8J4azokMfIQXIFJMI3mki9PMDbvtVlwJ tQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr5pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:10 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:08 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:07 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:53:07 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id 390A83F703F;
        Wed, 25 Mar 2020 05:53:05 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 07/17] net: macsec: support multicast/broadcast when offloading
Date:   Wed, 25 Mar 2020 15:52:36 +0300
Message-ID: <20200325125246.987-8-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
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
index 5d1564cda7fe..884407d92f93 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1005,22 +1005,53 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
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
@@ -1032,19 +1063,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
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

