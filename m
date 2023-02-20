Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2022E69CAB5
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 13:21:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbjBTMVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 07:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231714AbjBTMVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 07:21:15 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD0C1A968;
        Mon, 20 Feb 2023 04:21:14 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31KARCML015915;
        Mon, 20 Feb 2023 04:21:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=U/igizjUnjAnW/ogHe0/GJc6RUu5xJOtFonIac+URKc=;
 b=HV7lVM8I59C8WJj3SyRwTsRHSU6FNSFoYFadZkDZ4VUxzKN2XOib/kocIwQp/YGRqL1O
 PU8YHI4Y3QNgxpKtFmM2TnIc/kjMii9Q+yghrUklEA/2UDAcIFmioVmUGiq7hoFQvW9N
 NdEtej1u/xoit+tesFr8evBxz+Xt3HzArYh746N3yZc1r7AqT4MHWHicIu5uHRV3jdAm
 Z4QX8xivtO+YIxz1uAAYpha23rebPQuZ/febX9abUbd36bn/785NkJBPDcq8Mr0w+Bbx
 qUXSiGCrzaUxrEon+TSH3LXpbnkm+/wn90SF/lZh+xoPGGbEpTwAy5nttCt+hRL/pSQL dw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ntvwumbkx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 20 Feb 2023 04:21:02 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Mon, 20 Feb
 2023 04:21:00 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.42 via Frontend
 Transport; Mon, 20 Feb 2023 04:21:00 -0800
Received: from hyd1425.marvell.com (unknown [10.29.37.83])
        by maili.marvell.com (Postfix) with ESMTP id 4C4E23F70A6;
        Mon, 20 Feb 2023 04:20:57 -0800 (PST)
From:   Sai Krishna <saikrishnag@marvell.com>
To:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <richardcochran@gmail.com>
CC:     Hariprasad Kelam <hkelam@marvell.com>,
        Sai Krishna <saikrishnag@marvell.com>
Subject: [net PATCH] octeontx2-pf: Recalculate UDP checksum for ptp 1-step sync packet
Date:   Mon, 20 Feb 2023 17:50:50 +0530
Message-ID: <20230220122050.1639299-1-saikrishnag@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Wi11AWWIDstoAktjDh3Z4ZNM37leDHkz
X-Proofpoint-ORIG-GUID: Wi11AWWIDstoAktjDh3Z4ZNM37leDHkz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-20_09,2023-02-20_02,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

When checksum offload is disabled in the driver via ethtool,
the PTP 1-step sync packets contain incorrect checksum, since
the stack calculates the checksum before driver updates
PTP timestamp field in the packet. This results in PTP packets
getting dropped at the other end. This patch fixes the issue by
re-calculating the UDP checksum after updating PTP
timestamp field in the driver.

Fixes: 2958d17a8984 ("octeontx2-pf: Add support for ptp 1-step mode on CN10K silicon")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Sai Krishna <saikrishnag@marvell.com>
---
 .../marvell/octeontx2/nic/otx2_txrx.c         | 78 ++++++++++++++-----
 1 file changed, 59 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index ef10aef3cda0..67345a3e2bba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -10,6 +10,7 @@
 #include <net/tso.h>
 #include <linux/bpf.h>
 #include <linux/bpf_trace.h>
+#include <net/ip6_checksum.h>
 
 #include "otx2_reg.h"
 #include "otx2_common.h"
@@ -699,7 +700,7 @@ static void otx2_sqe_add_ext(struct otx2_nic *pfvf, struct otx2_snd_queue *sq,
 
 static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 			     int alg, u64 iova, int ptp_offset,
-			     u64 base_ns, int udp_csum)
+			     u64 base_ns, bool udp_csum_crt)
 {
 	struct nix_sqe_mem_s *mem;
 
@@ -711,7 +712,7 @@ static void otx2_sqe_add_mem(struct otx2_snd_queue *sq, int *offset,
 
 	if (ptp_offset) {
 		mem->start_offset = ptp_offset;
-		mem->udp_csum_crt = udp_csum;
+		mem->udp_csum_crt = !!udp_csum_crt;
 		mem->base_ns = base_ns;
 		mem->step_type = 1;
 	}
@@ -986,10 +987,11 @@ static bool otx2_validate_network_transport(struct sk_buff *skb)
 	return false;
 }
 
-static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
+static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, bool *udp_csum_crt)
 {
 	struct ethhdr *eth = (struct ethhdr *)(skb->data);
 	u16 nix_offload_hlen = 0, inner_vhlen = 0;
+	bool udp_hdr_present = false, is_sync;
 	u8 *data = skb->data, *msgtype;
 	__be16 proto = eth->h_proto;
 	int network_depth = 0;
@@ -1029,45 +1031,83 @@ static bool otx2_ptp_is_sync(struct sk_buff *skb, int *offset, int *udp_csum)
 		if (!otx2_validate_network_transport(skb))
 			return false;
 
-		*udp_csum = 1;
 		*offset = nix_offload_hlen + skb_transport_offset(skb) +
 			  sizeof(struct udphdr);
+		udp_hdr_present = true;
+
 	}
 
 	msgtype = data + *offset;
-
 	/* Check PTP messageId is SYNC or not */
-	return (*msgtype & 0xf) == 0;
+	is_sync =  ((*msgtype & 0xf) == 0) ? true : false;
+	if (is_sync) {
+		if (udp_hdr_present)
+			*udp_csum_crt = true;
+	} else {
+		*offset = 0;
+	}
+
+	return is_sync;
 }
 
 static void otx2_set_txtstamp(struct otx2_nic *pfvf, struct sk_buff *skb,
 			      struct otx2_snd_queue *sq, int *offset)
 {
+	struct ethhdr	*eth = (struct ethhdr *)(skb->data);
 	struct ptpv2_tstamp *origin_tstamp;
-	int ptp_offset = 0, udp_csum = 0;
+	bool udp_csum_crt = false;
+	unsigned int udphoff;
 	struct timespec64 ts;
+	int ptp_offset = 0;
+	__wsum skb_csum;
 	u64 iova;
 
 	if (unlikely(!skb_shinfo(skb)->gso_size &&
 		     (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP))) {
-		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC)) {
-			if (otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum)) {
-				origin_tstamp = (struct ptpv2_tstamp *)
-						((u8 *)skb->data + ptp_offset +
-						 PTP_SYNC_SEC_OFFSET);
-				ts = ns_to_timespec64(pfvf->ptp->tstamp);
-				origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
-				origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
-				origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
-				/* Point to correction field in PTP packet */
-				ptp_offset += 8;
+		if (unlikely(pfvf->flags & OTX2_FLAG_PTP_ONESTEP_SYNC &&
+			     otx2_ptp_is_sync(skb, &ptp_offset, &udp_csum_crt))) {
+			origin_tstamp = (struct ptpv2_tstamp *)
+					((u8 *)skb->data + ptp_offset +
+					 PTP_SYNC_SEC_OFFSET);
+			ts = ns_to_timespec64(pfvf->ptp->tstamp);
+			origin_tstamp->seconds_msb = htons((ts.tv_sec >> 32) & 0xffff);
+			origin_tstamp->seconds_lsb = htonl(ts.tv_sec & 0xffffffff);
+			origin_tstamp->nanoseconds = htonl(ts.tv_nsec);
+			/* Point to correction field in PTP packet */
+			ptp_offset += 8;
+
+			/* When user disables hw checksum, stack calculates the csum,
+			 * but it does not cover ptp timestamp which is added later.
+			 * Recalculate the checksum manually considering the timestamp.
+			 */
+			if (udp_csum_crt) {
+				struct udphdr *uh = udp_hdr(skb);
+
+				if (skb->ip_summed != CHECKSUM_PARTIAL && uh->check != 0) {
+					udphoff = skb_transport_offset(skb);
+					uh->check = 0;
+					skb_csum = skb_checksum(skb, udphoff, skb->len - udphoff,
+								0);
+					if (ntohs(eth->h_proto) == ETH_P_IPV6)
+						uh->check = csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
+									    &ipv6_hdr(skb)->daddr,
+									    skb->len - udphoff,
+									    ipv6_hdr(skb)->nexthdr,
+									    skb_csum);
+					else
+						uh->check = csum_tcpudp_magic(ip_hdr(skb)->saddr,
+									      ip_hdr(skb)->daddr,
+									      skb->len - udphoff,
+									      IPPROTO_UDP,
+									      skb_csum);
+				}
 			}
 		} else {
 			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 		}
 		iova = sq->timestamps->iova + (sq->head * sizeof(u64));
 		otx2_sqe_add_mem(sq, offset, NIX_SENDMEMALG_E_SETTSTMP, iova,
-				 ptp_offset, pfvf->ptp->base_ns, udp_csum);
+				 ptp_offset, pfvf->ptp->base_ns, udp_csum_crt);
 	} else {
 		skb_tx_timestamp(skb);
 	}
-- 
2.25.1

