Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 681A3374B4A
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 00:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232382AbhEEWf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 18:35:57 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:54230 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229712AbhEEWf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 May 2021 18:35:57 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 9EDC42432F;
        Wed,  5 May 2021 15:34:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 9EDC42432F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1620254099;
        bh=cjqBGI479MYoJIBLrdrFVz+pwMJtnMC7DhP1sSeHWH8=;
        h=From:To:Cc:Subject:Date:From;
        b=J+pYEqGzUvNPYBEoRedtNzP1fW0xixaOzqR6seHPAAWjmNiYn7rDQr6pjsGuuWdq+
         rtOFBOseCiNpa8Tnvb6+AaPBL8WUnRflKNDskPgB9kEyZTRNlp11kvCWKNm/syGyrt
         lScpKrEVHAvya2mB+wnGiN4aKo6cWx3EWIzCRtvM=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net] bnxt_en: Fix and improve .ndo_features_check().
Date:   Wed,  5 May 2021 18:34:59 -0400
Message-Id: <1620254099-5270-1-git-send-email-michael.chan@broadcom.com>
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

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Fixes: 1698d600b361 ("bnxt_en: Implement .ndo_features_check().")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 93 ++++++++++++++++++-----
 1 file changed, 76 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 39ac9e2f5118..c489089671fb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10785,37 +10785,96 @@ static int bnxt_set_features(struct net_device *dev, netdev_features_t features)
 	return rc;
 }
 
+/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
+static bool bnxt_udp_check(struct bnxt *bp, struct udphdr *uh)
+{
+	__be16 udp_port = uh->dest;
+
+	return udp_port == bp->vxlan_port || udp_port == bp->nge_port;
+}
+
+static bool bnxt_exthdr_check(struct bnxt *bp, struct sk_buff *skb, int nw_off,
+			      u8 *nextproto)
+{
+	struct ipv6hdr *ip6h = (struct ipv6hdr *)(skb->data + nw_off);
+	int hdr_count = 0;
+	u8 nexthdr;
+	int start;
+
+	/* Check that there are at most 2 IPv6 extension headers, no
+	 * fragment header, and each is <= 64 bytes.
+	 */
+	start = nw_off + sizeof(*ip6h);
+	nexthdr = ip6h->nexthdr;
+	while (ipv6_ext_hdr(nexthdr)) {
+		struct ipv6_opt_hdr _hdr, *hp;
+		int hdrlen;
+
+		if (hdr_count >= 3 || nexthdr == NEXTHDR_NONE ||
+		    nexthdr == NEXTHDR_FRAGMENT)
+			return false;
+		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
+		if (!hp)
+			return false;
+		if (nexthdr == NEXTHDR_AUTH)
+			hdrlen = ipv6_authlen(hp);
+		else
+			hdrlen = ipv6_optlen(hp);
+
+		if (hdrlen > 64)
+			return false;
+		nexthdr = hp->nexthdr;
+		start += hdrlen;
+		hdr_count++;
+	}
+	if (nextproto)
+		*nextproto = nexthdr;
+	return true;
+}
+
+static bool bnxt_tunl_check(struct bnxt *bp, struct sk_buff *skb, u8 l4_proto)
+{
+	switch (l4_proto) {
+	case IPPROTO_UDP:
+		return bnxt_udp_check(bp, udp_hdr(skb));
+	case IPPROTO_GRE:
+	case IPPROTO_IPIP:
+		return true;
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
+	struct bnxt *bp = netdev_priv(dev);
 	u8 l4_proto = 0;
 
 	features = vlan_features_check(skb, features);
-	if (!skb->encapsulation)
-		return features;
-
 	switch (vlan_get_protocol(skb)) {
 	case htons(ETH_P_IP):
+		if (!skb->encapsulation)
+			return features;
 		l4_proto = ip_hdr(skb)->protocol;
-		break;
+		if (!bnxt_tunl_check(bp, skb, l4_proto))
+			goto disable_offload;
+		return features;
 	case htons(ETH_P_IPV6):
-		l4_proto = ipv6_hdr(skb)->nexthdr;
-		break;
-	default:
+		if (!bnxt_exthdr_check(bp, skb, skb_network_offset(skb),
+				       &l4_proto))
+			goto disable_offload;
+		if (skb->encapsulation &&
+		    !bnxt_tunl_check(bp, skb, l4_proto))
+			goto disable_offload;
 		return features;
 	}
 
-	if (l4_proto != IPPROTO_UDP)
-		return features;
-
-	bp = netdev_priv(dev);
-	/* For UDP, we can only handle 1 Vxlan port and 1 Geneve port. */
-	udp_port = udp_hdr(skb)->dest;
-	if (udp_port == bp->vxlan_port || udp_port == bp->nge_port)
-		return features;
+disable_offload:
 	return features & ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
 }
 
-- 
2.18.1

