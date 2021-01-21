Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4148C2FEC2D
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 14:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728708AbhAUNkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 08:40:55 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:48322 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726405AbhAUNh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 08:37:58 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210121133653epoutp0231b2270cd2863bc6d3eeb2986d28a158~cQsypEZG41659016590epoutp02J
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 13:36:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210121133653epoutp0231b2270cd2863bc6d3eeb2986d28a158~cQsypEZG41659016590epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611236213;
        bh=X5i27RZqeBfnLv9FxlZqOAV3EctupAsi0CuRgD+q5e8=;
        h=From:To:Cc:Subject:Date:References:From;
        b=AefvTSLSHW8dVZGViTkTtT/vHNODHJrsgnpX7wOpMebOWxJmM4jtrFnMTIBpG8ium
         eajnfossgqxH65IE0Cg63IhQzBXV9LQHD1aaUjVOYESAXgDzPFpunV8C1lIfuGueut
         0Bq2l586WcJsThZvjWbmPpqksTXveRlsFMha6hRI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210121133652epcas2p25105d55aa01a3b81607be6e9b8ca770e~cQsx4Ncmf2111721117epcas2p25;
        Thu, 21 Jan 2021 13:36:52 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DM3Mk4zh8z4x9Pp; Thu, 21 Jan
        2021 13:36:50 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        CD.EC.10621.27389006; Thu, 21 Jan 2021 22:36:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70~cQsvJwqJD3164131641epcas2p4A;
        Thu, 21 Jan 2021 13:36:49 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210121133649epsmtrp2432a2b8cc1bf7e266ddae305b2272c4d~cQsvJAwGG0720007200epsmtrp2Q;
        Thu, 21 Jan 2021 13:36:49 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-25-60098372a80f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        50.79.13470.17389006; Thu, 21 Jan 2021 22:36:49 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210121133649epsmtip10a0b143001ff593d50034b00234be82c~cQsu6dNSi0235902359epsmtip1d;
        Thu, 21 Jan 2021 13:36:49 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     namkyu78.kim@samsung.com, Dongseok Yi <dseok.yi@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v3] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Date:   Thu, 21 Jan 2021 22:24:39 +0900
Message-Id: <1611235479-39399-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLKsWRmVeSWpSXmKPExsWy7bCmmW5RM2eCwdmlqharHm9nsZhzvoXF
        4sq0P4wWF7b1sVpc3jWHzaLhTjObxbEFYha7O3+wW7zbcoTd4uveLhYHLo8tK28yeSzYVOqx
        aVUnm0fbtVVMHkf3nGPz6NuyitFjU+sSVo/Pm+QCOKJybDJSE1NSixRS85LzUzLz0m2VvIPj
        neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlRSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX
        2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJVJuRk7N2ynrngkXbF3MvTmRsYryt3MXJy
        SAiYSLy/+Ju9i5GLQ0hgB6PE9c1LmCGcT4wSH7seQGW+MUocOdbIDNNyu/MEVGIvo0TbjCYm
        COcHo8SKm3MYQarYBDQk9r97wQqSEBFoYpSY9vkIC4jDDDL46/ResFnCAhESt09/YwWxWQRU
        Je61bWQHsXkFXCT2PnvLBrFPTuLmuU6wqyQEbrFLHJ35nhEi4SLRdeYc1FHCEq+Ob2GHsKUk
        Pr/bC9TMAWTXS7R2x0D09jBKXNn3hAWixlhi1rN2RpAaZgFNifW79CHKlSWO3AKrYBbgk+g4
        /JcdIswr0dEmBGEqSUz8Eg8xQ0LixcnJUPM8JGa+3Au2X0ggVuL70U6mCYyysxDGL2BkXMUo
        llpQnJueWmxUYIgcS5sYwelOy3UH4+S3H/QOMTJxMB5ilOBgVhLhfWTJkSDEm5JYWZValB9f
        VJqTWnyI0RQYWhOZpUST84EJN68k3tDUyMzMwNLUwtTMyEJJnLfY4EG8kEB6YklqdmpqQWoR
        TB8TB6dUA9MREemZ3VNnHvhhFGVz4rgO65zd9bw+Hifnilxcn8Hl325fqCzbbnt5Ikdus+m9
        O07Jk/sPnot+qHbCypXbeNE2ySMC1uvVleNCy0vMdh6fuPex/fSeOEaz/WktUc1nZvX8YZ0o
        cLX9wM9ysezXUV5bndgK+VfLNi3lnvroz5zdS8MtWq4sFJMpmPK6bsLR2sYKFavvbIcvJ+mu
        8/Q9+m5nTPAxc+UEpqZqpx05Qu+Xlcn0xmgucm2WsPWc/s/98K+HZgv+zJxZdab9m6XzzPv+
        XK91HV8s0+8/YL392/VT4mv+HOGepLnSWWOJqXtkl5Xg7nMs/vtLe63DXlU8kTBVXnBF4rPa
        Hd5tkzy9NZRYijMSDbWYi4oTAdUXTDYABAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNLMWRmVeSWpSXmKPExsWy7bCSnG5hM2eCwaNeVYtVj7ezWMw538Ji
        cWXaH0aLC9v6WC0u75rDZtFwp5nN4tgCMYvdnT/YLd5tOcJu8XVvF4sDl8eWlTeZPBZsKvXY
        tKqTzaPt2iomj6N7zrF59G1ZxeixqXUJq8fnTXIBHFFcNimpOZllqUX6dglcGXu3rGcueKRd
        MffydOYGxuvKXYycHBICJhK3O0+wg9hCArsZJd6c1epi5ACKS0js2uwKUSIscb/lCGsXIxdQ
        yTdGicMH3rKBJNgENCT2v3sBlhARaGGU2Hr0IDOIwyzwg1HiZPt3JpAqYYEwie3bdjOC2CwC
        qhL32jaCbeMVcJHY+wxikoSAnMTNc53MExh5FjAyrGKUTC0ozk3PLTYsMMxLLdcrTswtLs1L
        10vOz93ECA4/Lc0djNtXfdA7xMjEwXiIUYKDWUmE95ElR4IQb0piZVVqUX58UWlOavEhRmkO
        FiVx3gtdJ+OFBNITS1KzU1MLUotgskwcnFINTJ2MPvmTuKwmXWCX2fndzP5CmwOj6PIap1BL
        3d1TPt9R1Z6rEju/2tb494wI92l/Ti04zsGQZ9cnMfXM/a/cLwxTItVLlqxj336q+NPrs0Ud
        vMm2huU7p5h5OOzl0fr30tGG876ydobn2agwxd8fDs6bejVk10/Bd8crwjltZyt0WhlfX7nl
        igrT4upZCkEuEbk7DwdcqI6S3Fh+0XiTj9T1F/W+X4ofb6s97Xje5f85lnTLiPyoIFbuAyv+
        FrXoRu6pct3D9zhJYfXLpU//1385uuio3cfoNy+/3M8IeHFFyo11R9YCheeP+yI4I5meM4lp
        X6+zr1BdybfyxSLvfGPhqpaIwi2Z/yM6S3eqKLEUZyQaajEXFScCAMA21jquAgAA
X-CMS-MailID: 20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70
References: <CGME20210121133649epcas2p493d5d59df1b48ee8e3282ab766f37a70@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
forwarding. Only the header of head_skb from ip_finish_output_gso ->
skb_gso_segment is updated but following frag_skbs are not updated.

A call path skb_mac_gso_segment -> inet_gso_segment ->
udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
does not try to update UDP/IP header of the segment list but copy
only the MAC header.

Update port, addr and check of each skb of the segment list in
__udp_gso_segment_list. It covers both SNAT and DNAT.

Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
v1:
Steffen Klassert said, there could be 2 options.
https://lore.kernel.org/patchwork/patch/1362257/
I was trying to write a quick fix, but it was not easy to forward
segmented list. Currently, assuming DNAT only.

v2:
Per Steffen Klassert request, moved the procedure from
udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.

v3:
Per Steffen Klassert request, applied fast return by comparing seg
and seg->next at the beginning of __udpv4_gso_segment_list_csum.

Fixed uh->dest = *newport and iph->daddr = *newip to
*oldport = *newport and *oldip = *newip.

 include/net/udp.h      |  2 +-
 net/ipv4/udp_offload.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++----
 net/ipv6/udp_offload.c |  2 +-
 3 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 877832b..01351ba 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -178,7 +178,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 int udp_gro_complete(struct sk_buff *skb, int nhoff, udp_lookup_t lookup);
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features);
+				  netdev_features_t features, bool is_ipv6);
 
 static inline struct udphdr *udp_gro_udphdr(struct sk_buff *skb)
 {
diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94..43660cf 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -187,8 +187,67 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_udp_tunnel_segment);
 
+static void __udpv4_gso_segment_csum(struct sk_buff *seg,
+				     __be32 *oldip, __be32 *newip,
+				     __be16 *oldport, __be16 *newport)
+{
+	struct udphdr *uh;
+	struct iphdr *iph;
+
+	if (*oldip == *newip && *oldport == *newport)
+		return;
+
+	uh = udp_hdr(seg);
+	iph = ip_hdr(seg);
+
+	if (uh->check) {
+		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
+					 true);
+		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
+					 false);
+		if (!uh->check)
+			uh->check = CSUM_MANGLED_0;
+	}
+	*oldport = *newport;
+
+	csum_replace4(&iph->check, *oldip, *newip);
+	*oldip = *newip;
+}
+
+static struct sk_buff *__udpv4_gso_segment_list_csum(struct sk_buff *segs)
+{
+	struct sk_buff *seg;
+	struct udphdr *uh, *uh2;
+	struct iphdr *iph, *iph2;
+
+	seg = segs;
+	uh = udp_hdr(seg);
+	iph = ip_hdr(seg);
+
+	if ((udp_hdr(seg)->dest == udp_hdr(seg->next)->dest) &&
+	    (udp_hdr(seg)->source == udp_hdr(seg->next)->source) &&
+	    (ip_hdr(seg)->daddr == ip_hdr(seg->next)->daddr) &&
+	    (ip_hdr(seg)->saddr == ip_hdr(seg->next)->saddr))
+		return segs;
+
+	while ((seg = seg->next)) {
+		uh2 = udp_hdr(seg);
+		iph2 = ip_hdr(seg);
+
+		__udpv4_gso_segment_csum(seg,
+					 &iph2->saddr, &iph->saddr,
+					 &uh2->source, &uh->source);
+		__udpv4_gso_segment_csum(seg,
+					 &iph2->daddr, &iph->daddr,
+					 &uh2->dest, &uh->dest);
+	}
+
+	return segs;
+}
+
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
-					      netdev_features_t features)
+					      netdev_features_t features,
+					      bool is_ipv6)
 {
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 
@@ -198,11 +257,14 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 
 	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
 
-	return skb;
+	if (is_ipv6)
+		return skb;
+	else
+		return __udpv4_gso_segment_list_csum(skb);
 }
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features)
+				  netdev_features_t features, bool is_ipv6)
 {
 	struct sock *sk = gso_skb->sk;
 	unsigned int sum_truesize = 0;
@@ -214,7 +276,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	__be16 newlen;
 
 	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __udp_gso_segment_list(gso_skb, features);
+		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
@@ -328,7 +390,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 		goto out;
 
 	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-		return __udp_gso_segment(skb, features);
+		return __udp_gso_segment(skb, features, false);
 
 	mss = skb_shinfo(skb)->gso_size;
 	if (unlikely(skb->len <= mss))
diff --git a/net/ipv6/udp_offload.c b/net/ipv6/udp_offload.c
index c7bd7b1..faa823c 100644
--- a/net/ipv6/udp_offload.c
+++ b/net/ipv6/udp_offload.c
@@ -42,7 +42,7 @@ static struct sk_buff *udp6_ufo_fragment(struct sk_buff *skb,
 			goto out;
 
 		if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-			return __udp_gso_segment(skb, features);
+			return __udp_gso_segment(skb, features, true);
 
 		mss = skb_shinfo(skb)->gso_size;
 		if (unlikely(skb->len <= mss))
-- 
2.7.4

