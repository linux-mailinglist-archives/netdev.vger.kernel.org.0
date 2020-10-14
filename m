Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A90728E023
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 13:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388521AbgJNL6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 07:58:46 -0400
Received: from mailout08.rmx.de ([94.199.90.85]:56329 "EHLO mailout08.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgJNL6q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Oct 2020 07:58:46 -0400
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout08.rmx.de (Postfix) with ESMTPS id 4CB9tB12XQzMpJl;
        Wed, 14 Oct 2020 13:58:42 +0200 (CEST)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4CB9sg2QcMz2TSBr;
        Wed, 14 Oct 2020 13:58:15 +0200 (CEST)
Received: from N95HX1G2.wgnetz.xx (192.168.54.83) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.408.0; Wed, 14 Oct
 2020 13:58:14 +0200
From:   Christian Eggers <ceggers@arri.de>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Halasa <khalasa@piap.pl>,
        Richard Cochran <richardcochran@gmail.com>
CC:     Vishal Kulkarni <vishal@chelsio.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next] net: ptp: get rid of IPV4_HLEN() and OFF_IHL macros
Date:   Wed, 14 Oct 2020 13:58:05 +0200
Message-ID: <20201014115805.23905-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.83]
X-RMX-ID: 20201014-135815-4CB9sg2QcMz2TSBr-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both macros are already marked for removal. IPV4_HLEN(data) is
misleading as it expects an Ethernet header instead of an IPv4 header as
argument. Because it is defined (and only used) within PTP, it should be
named PTP_IPV4_HLEN or similar.

As the whole rest of the IPv4 stack has no problems using iphdr->ihl
directly, also PTP should be able to do so.

OFF_IHL has only been used by IPV4_HLEN. Additionally it is superfluous
as ETH_HLEN already exists for the same.

Signed-off-by: Christian Eggers <ceggers@arri.de>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c       | 4 ++--
 drivers/net/ethernet/chelsio/cxgb4/sge.c             | 5 ++++-
 drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c | 4 +++-
 drivers/net/ethernet/xscale/ixp4xx_eth.c             | 4 +++-
 include/linux/ptp_classify.h                         | 2 --
 net/core/ptp_classifier.c                            | 6 +++---
 6 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
index 70dbee89118e..b32a9006b222 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_ptp.c
@@ -83,8 +83,8 @@ bool is_ptp_enabled(struct sk_buff *skb, struct net_device *dev)
  */
 bool cxgb4_ptp_is_ptp_rx(struct sk_buff *skb)
 {
-	struct udphdr *uh = (struct udphdr *)(skb->data + ETH_HLEN +
-					      IPV4_HLEN(skb->data));
+	struct iphdr *ih = (struct iphdr *)(skb->data + ETH_HLEN);
+	struct udphdr *uh = (struct udphdr *)((char *)ih + (ih->ihl << 2));
 
 	return  uh->dest == htons(PTP_EVENT_PORT) &&
 		uh->source == htons(PTP_EVENT_PORT);
diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index a9e9c7ae565d..c8bec874bc66 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -40,6 +40,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/jiffies.h>
 #include <linux/prefetch.h>
+#include <linux/ptp_classify.h>
 #include <linux/export.h>
 #include <net/xfrm.h>
 #include <net/ipv6.h>
@@ -3386,7 +3387,9 @@ static noinline int t4_systim_to_hwstamp(struct adapter *adapter,
 
 	data = skb->data + sizeof(*cpl);
 	skb_pull(skb, 2 * sizeof(u64) + sizeof(struct cpl_rx_mps_pkt));
-	offset = ETH_HLEN + IPV4_HLEN(skb->data) + UDP_HLEN;
+	offset = ETH_HLEN;
+	offset += ((struct iphdr *)(skb->data + offset))->ihl << 2;
+	offset += UDP_HLEN;
 	if (skb->len < offset + OFF_PTP_SEQUENCE_ID + sizeof(short))
 		return RX_PTP_PKT_ERR;
 
diff --git a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
index ade8c44c01cd..4e95621997d1 100644
--- a/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
+++ b/drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c
@@ -113,7 +113,9 @@ static int pch_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 	if (ptp_classify_raw(skb) == PTP_CLASS_NONE)
 		return 0;
 
-	offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+	offset = ETH_HLEN;
+	offset += ((struct iphdr *)(data + offset))->ihl << 2;
+	offset += UDP_HLEN;
 
 	if (skb->len < offset + OFF_PTP_SEQUENCE_ID + sizeof(seqid))
 		return 0;
diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 2e5202923510..7443bc1f9bec 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -264,7 +264,9 @@ static int ixp_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
 	if (ptp_classify_raw(skb) != PTP_CLASS_V1_IPV4)
 		return 0;
 
-	offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+	offset = ETH_HLEN;
+	offset += ((struct iphdr *)(data + offset))->ihl << 2;
+	offset += UDP_HLEN;
 
 	if (skb->len < offset + OFF_PTP_SEQUENCE_ID + sizeof(seqid))
 		return 0;
diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index c6487b7ab026..56b2d7d66177 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -40,8 +40,6 @@
 /* Below defines should actually be removed at some point in time. */
 #define IP6_HLEN	40
 #define UDP_HLEN	8
-#define OFF_IHL		14
-#define IPV4_HLEN(data) (((struct iphdr *)(data + OFF_IHL))->ihl << 2)
 
 struct clock_identity {
 	u8 id[8];
diff --git a/net/core/ptp_classifier.c b/net/core/ptp_classifier.c
index e33fde06d528..6a964639b704 100644
--- a/net/core/ptp_classifier.c
+++ b/net/core/ptp_classifier.c
@@ -114,9 +114,11 @@ struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
 	if (type & PTP_CLASS_VLAN)
 		ptr += VLAN_HLEN;
 
+	ptr += ETH_HLEN;
+
 	switch (type & PTP_CLASS_PMASK) {
 	case PTP_CLASS_IPV4:
-		ptr += IPV4_HLEN(ptr) + UDP_HLEN;
+		ptr += (((struct iphdr *)ptr)->ihl << 2) + UDP_HLEN;
 		break;
 	case PTP_CLASS_IPV6:
 		ptr += IP6_HLEN + UDP_HLEN;
@@ -127,8 +129,6 @@ struct ptp_header *ptp_parse_header(struct sk_buff *skb, unsigned int type)
 		return NULL;
 	}
 
-	ptr += ETH_HLEN;
-
 	/* Ensure that the entire header is present in this packet. */
 	if (ptr + sizeof(struct ptp_header) > skb->data + skb->len)
 		return NULL;
-- 
Christian Eggers
Embedded software developer

Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRA 57918
Persoenlich haftender Gesellschafter: Arnold & Richter Cine Technik GmbH
Sitz: Muenchen - Registergericht: Amtsgericht Muenchen - Handelsregisternummer: HRB 54477
Geschaeftsfuehrer: Dr. Michael Neuhaeuser; Stephan Schenk; Walter Trauninger; Markus Zeiler

