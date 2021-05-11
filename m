Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C00137B23B
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhEKXL7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:11:59 -0400
Received: from saphodev.broadcom.com ([192.19.11.229]:46754 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhEKXL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 19:11:59 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D7B0B30997;
        Tue, 11 May 2021 16:10:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D7B0B30997
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1620774651;
        bh=y9ZkYZDsevFEWKRF0SQpfXiJMClNVK7g92NIlfe4MsQ=;
        h=From:To:Cc:Subject:Date:From;
        b=u3tbrghJ/EdqoIThmDX4U+srUs4xH2L2vHgLMzB23rD6xxzmHLPU3/xrOH3ZhcM44
         ruCVADQJXFWyXFbsJJ7nvHnWK+WwjfmvPIfSwEYrNJnk1UdhrMkKz+lYf3R6hQM3OF
         7hoH0GyNj8ZEw30FibjaCKT7DlItW3e/2szk0wo4=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com,
        alexander.duyck@gmail.com
Subject: [PATCH net v3] bnxt_en: Fix and improve .ndo_features_check().
Date:   Tue, 11 May 2021 19:10:50 -0400
Message-Id: <1620774650-4464-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski pointed out that we need to handle ipv6 extension headers
and to explicitly check for supported tunnel types in
.ndo_features_check().

For ipv6 extension headers, the hardware supports up to 2 ext. headers
and each must be <= 64 bytes.  For tunneled packets, the supported
packets are UDP with supported VXLAN and Geneve ports, GRE, and IPIP.

v3: More improvements based on Alexander Duyck's valuable feedback -
    Remove the jump lable in bnxt_features_check() and restructure it
    so that the TCP/UDP is check is consolidated in bnxt_exthdr_check().

v2: Add missing step to check inner ipv6 header for UDP and GRE tunnels.
    Check TCP/UDP next header after skipping ipv6 ext headers for
    non-tunneled packets and for inner ipv6.
    (Both feedback from Alexander Duyck)

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Fixes: 1698d600b361 ("bnxt_en: Implement .ndo_features_check().")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 126 ++++++++++++++++++----
 1 file changed, 107 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 39ac9e2f5118..a60c694d1c26 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10785,37 +10785,125 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	return rc;
 }
 
+static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
+			      u8 **nextp)
+{
+	struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
+	int hdr_count = 0;
+	u8 *nexthdr;
+	int start;
+
+	/* Check that there are at most 2 IPv6 extension headers, no
+	 * fragment header, and each is <= 64 bytes.
+	 */
+	start = nw_off + sizeof(*ip6h);
+	nexthdr = &ip6h->nexthdr;
+	while (ipv6_ext_hdr(*nexthdr)) {
+		struct ipv6_opt_hdr *hp;
+		int hdrlen;
+
+		if (hdr_count >= 3 || *nexthdr == NEXTHDR_NONE ||
+		    *nexthdr == NEXTHDR_FRAGMENT)
+			return false;
+		hp = __skb_header_pointer(NULL, start, sizeof(*hp), skb->data,
+					  skb_headlen(skb), NULL);
+		if (!hp)
+			return false;
+		if (*nexthdr == NEXTHDR_AUTH)
+			hdrlen = ipv6_authlen(hp);
+		else
+			hdrlen = ipv6_optlen(hp);
+
+		if (hdrlen > 64)
+			return false;
+		nexthdr = &hp->nexthdr;
+		start += hdrlen;
+		hdr_count++;
+	}
+	if (nextp) {
+		/* Caller will check inner protocol */
+		if (skb->encapsulation) {
+			*nextp = nexthdr;
+			return true;
+		}
+		*nextp = NULL;
+	}
+	/* Only support TCP/UDP for non-tunneled ipv6 and inner ipv6 */
+	return *nexthdr == IPPROTO_TCP || *nexthdr == IPPROTO_UDP;
+}
+
+/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
+static bool bnxt_udp_tunl_check(struct bnxt *bp, struct sk_buff *skb)
+{
+	struct udphdr *uh = udp_hdr(skb);
+	__be16 udp_port = uh->dest;
+
+	if (udp_port != bp->vxlan_port && udp_port != bp->nge_port)
+		return false;
+	if (skb->inner_protocol_type == ENCAP_TYPE_ETHER) {
+		struct ethhdr *eh = inner_eth_hdr(skb);
+
+		switch (eh->h_proto) {
+		case htons(ETH_P_IP):
+			return true;
+		case htons(ETH_P_IPV6):
+			return bnxt_exthdr_check(bp, skb,
+						 skb_inner_network_offset(skb),
+						 NULL);
+		}
+	}
+	return false;
+}
+
+static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
+{
+	switch (l4_proto) {
+	case IPPROTO_UDP:
+		return bnxt_udp_tunl_check(bp, skb);
+	case IPPROTO_IPIP:
+		return true;
+	case IPPROTO_GRE: {
+		switch (skb->inner_protocol) {
+		default:
+			return false;
+		case htons(ETH_P_IP):
+			return true;
+		case htons(ETH_P_IPV6):
+			fallthrough;
+		}
+	}
+	case IPPROTO_IPV6:
+		/* Check ext headers of inner ipv6 */
+		return bnxt_exthdr_check(bp, skb, skb_inner_network_offset(skb),
+					 NULL);
+	}
+	return false;
+}
+
 static netdev_features_t bnxt_features_check(struct sk_buff *skb,
 					     struct net_device *dev,
 					     netdev_features_t features)
 {
-	struct bnxt *bp;
-	__be16 udp_port;
-	u8 l4_proto = 0;
+	struct bnxt *bp = netdev_priv(dev);
+	u8 *l4_proto;
 
 	features = vlan_features_check(skb, features);
-	if (!skb->encapsulation)
-		return features;
-
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
-		l4_proto = ip_hdr(skb)->protocol;
+		if (!skb->encapsulation)
+			return features;
+		l4_proto = &ip_hdr(skb)->protocol;
+		if (bnxt_tunl_check(bp, skb, *l4_proto))
+			return features;
 		break;
 	case htons(ETH_P_IPV6):
-		l4_proto = ipv6_hdr(skb)->nexthdr;
+		if (!bnxt_exthdr_check(bp, skb, skb_network_offset(skb),
+				       &l4_proto))
+			break;
+		if (!l4_proto || bnxt_tunl_check(bp, skb, *l4_proto))
+			return features;
 		break;
-	default:
-		return features;
 	}
-
-	if (l4_proto != IPPROTO_UDP)
-		return features;
-
-	bp = netdev_priv(dev);
-	/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
-	udp_port = udp_hdr(skb)->dest;
-	if (udp_port == bp->vxlan_port || udp_port == bp->nge_port)
-		return features;
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-- 
2.18.1

