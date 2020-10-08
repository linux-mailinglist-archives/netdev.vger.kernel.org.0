Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8E92871D6
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 11:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729251AbgJHJsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 05:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbgJHJsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 05:48:39 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CB8C061755;
        Thu,  8 Oct 2020 02:48:39 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id f19so3526830pfj.11;
        Thu, 08 Oct 2020 02:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :in-reply-to:references;
        bh=kh+4Akzr9Y2ohk7JE0CkOp4rDs5Jp9+QPNorc2hZCXo=;
        b=nsIlcWKuCkIqMcdGqOpiNJenY/pLo9RMZQ5bG2Hy+YYTQW1T17+huElkV7qtiI6wrB
         oe9JS+e5kOYZ2t5y5BqD15uZu89PZdJYxuf1S86rFho9JM2VXcJbdS/sVX/e/XcU5MAl
         olEqQp50D0qQymnmEOoNhwNiCZNwrrywyxOxhhdmFzz2upik84A9YyTP4Q3LzcOoRbqJ
         4A2B/FQyEShDuxnjh/bHiiG5zomcCW1P9eDqlrka1rbPfXb2B64Y1so+rT0ErWZ2ebUZ
         5qwqzQsmZFBzwBQh8Je6e3Ci/VJmhHE68VK4BKLBudJ9j4Wqq4W3/LbQ6Squcpn1ETmF
         kwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:in-reply-to:references;
        bh=kh+4Akzr9Y2ohk7JE0CkOp4rDs5Jp9+QPNorc2hZCXo=;
        b=meJjzrwLgAlRIFFTZZ4uEstPdoa420vc8EqrjTA/2heiHRdxgFbF6GZ93UzWD141oN
         M0Xw+62yBaRo1c9s3Md9JfS6GpT5FFtP4S+c2wwcQoFDHuTM2M6nBLO1jRq2MQNhlmUr
         2VKG8eJKMC0PUzg8bctdyDpoG58orwZuTMJF5JEfa8PYtVhMOVHZ/PFLKLvSQzdshzuC
         6mEYQozyCYqDSri2VK1LyntrBeS5rL168Xz5Yim9c56qFHjpjv5WT/yOHqvD7CnteIq3
         ONRQUdDAt9ovKnc2v4E0t3PJuHesZG4GsZcZcQra9HEBTwj+5w3Nbm9p97cgm8Yajyuv
         u/oQ==
X-Gm-Message-State: AOAM530BR/4Wk6nTlpFB4O/HtKOobgH0881yHtzu2VbtgaxOWMWytiMk
        KSJkM0z+cn22pQfq47u+hrlrp40VVTg=
X-Google-Smtp-Source: ABdhPJyqHNpeQsVWK/Kmtvr2GSoKEebv6a/D5MloyARZ4agRBF77C8DnlQzNkNPwOqhAmuMq7KQXfw==
X-Received: by 2002:a17:90a:e553:: with SMTP id ei19mr3291457pjb.136.1602150518601;
        Thu, 08 Oct 2020 02:48:38 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h62sm6689123pjd.18.2020.10.08.02.48.37
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 08 Oct 2020 02:48:38 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, linux-sctp@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Michael Tuexen <tuexen@fh-muenster.de>, davem@davemloft.net
Subject: [PATCHv2 net-next 02/17] udp6: move the mss check after udp gso tunnel processing
Date:   Thu,  8 Oct 2020 17:47:58 +0800
Message-Id: <c36b016ee429980b9585144f4f9af31bcda467ee.1602150362.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
 <052acb63198c44df41c5db17f8397eeb7c8bacfe.1602150362.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1602150362.git.lucien.xin@gmail.com>
References: <cover.1602150362.git.lucien.xin@gmail.com>
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

