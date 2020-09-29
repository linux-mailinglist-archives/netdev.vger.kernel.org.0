Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C421627CFD4
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 15:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgI2Ntm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 09:49:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730283AbgI2Nti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 09:49:38 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B835BC061755;
        Tue, 29 Sep 2020 06:49:37 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id w7so4604916pfi.4;
        Tue, 29 Sep 2020 06:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=kh+4Akzr9Y2ohk7JE0CkOp4rDs5Jp9+QPNorc2hZCXo=;
        b=mrjFwkTl2E2VeXUMo5tIFObiJYgdyLpW2x1AnOsdFoUZAGX6DXUGdw+iShr2++QNKa
         X8Q+DfW2bUyNYAc7IhMCUpRCwADJNuV64sf+nB7OK+YatajXoqd+RxYGbCr+ToWHKP12
         EEN9xAEeKz7ph1GVPMB62pPMh8F5g3f7arV2gAADZyXakk93nQk/8wh+aQrdbngzfRFN
         o47gRYPppYNByyZDHCjlmGAnoArF91wDyTikS+7eXW95sSVX2mFhYJ9y9rO6fvzDigTK
         mORMlt+xzac1PjG2U+JFV5qJYgZFc4J9JNMJk3ZEBHLE9qjCN3cXAyOQiGXYOesmzgrA
         bUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=kh+4Akzr9Y2ohk7JE0CkOp4rDs5Jp9+QPNorc2hZCXo=;
        b=LZSlyjM1hqoQL6SePfFUmThWz02ZB9IHaLDjlLDjdvjdgSUCuV/QFWMUV2C8mjP4lY
         CGqwvOScZBBwdXqssW0uC++g022JxgGzDLWjIwNX9ryTryqSYgRvFrJf1/Z3ZnSKjncL
         kxohtsNSXquJMxCTbDE3VFHlr8qi9OISrlXyZpq0TKBIGFdo5i0KNTW0++bQFV/3kcW2
         k8PHfeIiAgxskDWPsjhTirMLuHwSlnqx1mwPTpkd+PXQ+md2p5npDWOdURKx5SqoEnha
         dWo3AZyW7BWQGvXs7QFkHVwAKeQSp+2L/cN19AoxYktvTUKa+TiI385BW2+7p7cJmwQz
         dotg==
X-Gm-Message-State: AOAM530F2BPWVBbFClz05bI8WsX6qDmgEvfeyKSH6bQg1RfLr8hPwwcz
        cW1JbU4+OrQXwotV9+TRkl6+LIMYVqU=
X-Google-Smtp-Source: ABdhPJzv7+P/ErpnFXgPsUr1GQZzuXGFXri8KKVMJtT7Ht9SW4hLRz0sDuDa5Y3K2p0NUHKT9stSgg==
X-Received: by 2002:a63:df02:: with SMTP id u2mr3300018pgg.270.1601387376745;
        Tue, 29 Sep 2020 06:49:36 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g24sm5703049pfk.65.2020.09.29.06.49.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 06:49:34 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>,
        Tom Herbert <therbert@google.com>, davem@davemloft.net
Subject: [PATCH net-next 02/15] udp6: move the mss check after udp gso tunnel processing
Date:   Tue, 29 Sep 2020 21:48:54 +0800
Message-Id: <65f713004ab546e0b6ec793572c72c1d0399f0fe.1601387231.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
 <51c1fdad515076f3014476711aec1c0a81c18d36.1601387231.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1601387231.git.lucien.xin@gmail.com>
References: <cover.1601387231.git.lucien.xin@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For some protocol's gso, like SCTP, it's using GSO_BY_FRAGS for
gso_size. When using UDP to encapsulate its packet, it will
return error in udp6_ufo_fragment() as skb->len < gso_size,
and it will never go to the gso tunnel processing.

So we should move this check after udp gso tunnel processing,
the same as udp4_ufo_fragment() does. While at it, also tidy
the variables up.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv6/udp_offload.c | 154 ++++++++++++++++++++++++-------------------------
 1 file changed, 76 insertions(+), 78 deletions(-)

diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index 584157a..3c5ec8e 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -17,96 +17,94 @@
 static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 					 netdev_features_t features)
 {
+	u8 nexthdr, frag_hdr_sz = sizeof(struct frag_hdr);
+	unsigned int unfrag_ip6hlen, unfrag_len, mss;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	unsigned int mss;
-	unsigned int unfrag_ip6hlen, unfrag_len;
-	struct frag_hdr *fptr;
+	const struct ipv6hdr *ipv6h;
 	u8 *packet_start, *prevhdr;
-	u8 nexthdr;
-	u8 frag_hdr_sz = sizeof(struct frag_hdr);
+	struct frag_hdr *fptr;
+	int tnl_hlen, err;
+	struct udphdr *uh;
 	__wsum csum;
-	int tnl_hlen;
-	int err;
 
-	mss = skb_shinfo(skb)->gso_size;
-	if (unlikely(skb->len <= mss))
+	if (skb->encapsulation &&
+	    (skb_shinfo(skb)->gso_type &
+	     (SKB_GSO_UDP_TUNNEL | SKB_GSO_UDP_TUNNEL_CSUM))) {
+		segs = skb_udp_tunnel_segment(skb, features, true);
 		goto out;
+	}
 
-	if (skb->encapsulation && skb_shinfo(skb)->gso_type &
-	    (SKB_GSO_UDP_TUNNEL|SKB_GSO_UDP_TUNNEL_CSUM))
-		segs = skb_udp_tunnel_segment(skb, features, true);
-	else {
-		const struct ipv6hdr *ipv6h;
-		struct udphdr *uh;
+	if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_UDP | SKB_GSO_UDP_L4)))
+		goto out;
 
-		if (!(skb_shinfo(skb)->gso_type & (SKB_GSO_UDP | SKB_GSO_UDP_L4)))
-			goto out;
+	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
+		goto out;
 
-		if (!pskb_may_pull(skb, sizeof(struct udphdr)))
-			goto out;
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
+		return __udp_gso_segment(skb, features);
 
-		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-			return __udp_gso_segment(skb, features);
-
-		/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
-		 * do checksum of UDP packets sent as multiple IP fragments.
-		 */
-
-		uh = udp_hdr(skb);
-		ipv6h = ipv6_hdr(skb);
-
-		uh->check = 0;
-		csum = skb_checksum(skb, 0, skb->len, 0);
-		uh->check = udp_v6_check(skb->len, &ipv6h->saddr,
-					  &ipv6h->daddr, csum);
-		if (uh->check == 0)
-			uh->check = CSUM_MANGLED_0;
-
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-
-		/* If there is no outer header we can fake a checksum offload
-		 * due to the fact that we have already done the checksum in
-		 * software prior to segmenting the frame.
-		 */
-		if (!skb->encap_hdr_csum)
-			features |= NETIF_F_HW_CSUM;
-
-		/* Check if there is enough headroom to insert fragment header. */
-		tnl_hlen = skb_tnl_header_len(skb);
-		if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
-			if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
-				goto out;
-		}
+	mss = skb_shinfo(skb)->gso_size;
+	if (unlikely(skb->len <= mss))
+		goto out;
 
-		/* Find the unfragmentable header and shift it left by frag_hdr_sz
-		 * bytes to insert fragment header.
-		 */
-		err = ip6_find_1stfragopt(skb, &prevhdr);
-		if (err < 0)
-			return ERR_PTR(err);
-		unfrag_ip6hlen = err;
-		nexthdr = *prevhdr;
-		*prevhdr = NEXTHDR_FRAGMENT;
-		unfrag_len = (skb_network_header(skb) - skb_mac_header(skb)) +
-			     unfrag_ip6hlen + tnl_hlen;
-		packet_start = (u8 *) skb->head + SKB_GSO_CB(skb)->mac_offset;
-		memmove(packet_start-frag_hdr_sz, packet_start, unfrag_len);
-
-		SKB_GSO_CB(skb)->mac_offset -= frag_hdr_sz;
-		skb->mac_header -= frag_hdr_sz;
-		skb->network_header -= frag_hdr_sz;
-
-		fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
-		fptr->nexthdr = nexthdr;
-		fptr->reserved = 0;
-		fptr->identification = ipv6_proxy_select_ident(dev_net(skb->dev), skb);
-
-		/* Fragment the skb. ipv6 header and the remaining fields of the
-		 * fragment header are updated in ipv6_gso_segment()
-		 */
-		segs = skb_segment(skb, features);
+	/* Do software UFO. Complete and fill in the UDP checksum as HW cannot
+	 * do checksum of UDP packets sent as multiple IP fragments.
+	 */
+
+	uh = udp_hdr(skb);
+	ipv6h = ipv6_hdr(skb);
+
+	uh->check = 0;
+	csum = skb_checksum(skb, 0, skb->len, 0);
+	uh->check = udp_v6_check(skb->len, &ipv6h->saddr,
+				 &ipv6h->daddr, csum);
+	if (uh->check == 0)
+		uh->check = CSUM_MANGLED_0;
+
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+	/* If there is no outer header we can fake a checksum offload
+	 * due to the fact that we have already done the checksum in
+	 * software prior to segmenting the frame.
+	 */
+	if (!skb->encap_hdr_csum)
+		features |= NETIF_F_HW_CSUM;
+
+	/* Check if there is enough headroom to insert fragment header. */
+	tnl_hlen = skb_tnl_header_len(skb);
+	if (skb->mac_header < (tnl_hlen + frag_hdr_sz)) {
+		if (gso_pskb_expand_head(skb, tnl_hlen + frag_hdr_sz))
+			goto out;
 	}
 
+	/* Find the unfragmentable header and shift it left by frag_hdr_sz
+	 * bytes to insert fragment header.
+	 */
+	err = ip6_find_1stfragopt(skb, &prevhdr);
+	if (err < 0)
+		return ERR_PTR(err);
+	unfrag_ip6hlen = err;
+	nexthdr = *prevhdr;
+	*prevhdr = NEXTHDR_FRAGMENT;
+	unfrag_len = (skb_network_header(skb) - skb_mac_header(skb)) +
+		     unfrag_ip6hlen + tnl_hlen;
+	packet_start = (u8 *)skb->head + SKB_GSO_CB(skb)->mac_offset;
+	memmove(packet_start - frag_hdr_sz, packet_start, unfrag_len);
+
+	SKB_GSO_CB(skb)->mac_offset -= frag_hdr_sz;
+	skb->mac_header -= frag_hdr_sz;
+	skb->network_header -= frag_hdr_sz;
+
+	fptr = (struct frag_hdr *)(skb_network_header(skb) + unfrag_ip6hlen);
+	fptr->nexthdr = nexthdr;
+	fptr->reserved = 0;
+	fptr->identification = ipv6_proxy_select_ident(dev_net(skb->dev), skb);
+
+	/* Fragment the skb. ipv6 header and the remaining fields of the
+	 * fragment header are updated in ipv6_gso_segment()
+	 */
+	segs = skb_segment(skb, features);
+
 out:
 	return segs;
 }
-- 
2.1.0

