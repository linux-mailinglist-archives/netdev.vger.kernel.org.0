Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216DD234AB1
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 20:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387520AbgGaSM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 14:12:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730040AbgGaSM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 14:12:28 -0400
Received: from lore-desk.redhat.com (unknown [151.48.137.169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A9B32177B;
        Fri, 31 Jul 2020 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596219148;
        bh=JWnoBxsAAWk2LrW6+MS1vaGHu6NRAG6hG2y+Oyp34RA=;
        h=From:To:Cc:Subject:Date:From;
        b=BeRXFbAF22W7hdIfKYPWKz0ve/YzuVTaDDcBGeb+uRfP1zq5talnGG5mnJCYAm9bq
         8LJgfRTUZ3CX5oDeMcTxfrSLKSIDp8lUaTmT/4mT1RPIv0N2UwojPkP0e8Ms1a7mHu
         rakOc7eDNaSFfBJlqOWzFstLW9sx8OnwANs2gD/w=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, lorenzo.bianconi@redhat.com,
        tom@herbertland.com
Subject: [PATCH net] net: gre: recompute gre csum for sctp over gre tunnels
Date:   Fri, 31 Jul 2020 20:12:05 +0200
Message-Id: <6722d2c4fe1b9b376a277b3f35cdf3eb3345874e.1596218124.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GRE tunnel can be used to transport traffic that does not rely on a
Internet checksum (e.g. SCTP). The issue can be triggered creating a GRE
or GRETAP tunnel and transmitting SCTP traffic ontop of it where CRC
offload has been disabled. In order to fix the issue we need to
recompute the GRE csum in gre_gso_segment() not relying on the inner
checksum.
The issue is still present when we have the CRC offload enabled.
In this case we need to disable the CRC offload if we require GRE
checksum since otherwise skb_checksum() will report a wrong value.

Fixes: 4749c09c37030 ("gre: Call gso_make_checksum")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 net/ipv4/gre_offload.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/gre_offload.c b/net/ipv4/gre_offload.c
index 2e6d1b7a7bc9..e0a246575887 100644
--- a/net/ipv4/gre_offload.c
+++ b/net/ipv4/gre_offload.c
@@ -15,12 +15,12 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 				       netdev_features_t features)
 {
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
+	bool need_csum, need_recompute_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int gre_offset, outer_hlen;
-	bool need_csum, gso_partial;
 
 	if (!skb->encapsulation)
 		goto out;
@@ -41,6 +41,7 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 	skb->protocol = skb->inner_protocol;
 
 	need_csum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_GRE_CSUM);
+	need_recompute_csum = skb->csum_not_inet;
 	skb->encap_hdr_csum = need_csum;
 
 	features &= skb->dev->hw_enc_features;
@@ -98,7 +99,15 @@ static struct sk_buff *gre_gso_segment(struct sk_buff *skb,
 		}
 
 		*(pcsum + 1) = 0;
-		*pcsum = gso_make_checksum(skb, 0);
+		if (need_recompute_csum && !skb_is_gso(skb)) {
+			__wsum csum;
+
+			csum = skb_checksum(skb, gre_offset,
+					    skb->len - gre_offset, 0);
+			*pcsum = csum_fold(csum);
+		} else {
+			*pcsum = gso_make_checksum(skb, 0);
+		}
 	} while ((skb = skb->next));
 out:
 	return segs;
-- 
2.26.2

