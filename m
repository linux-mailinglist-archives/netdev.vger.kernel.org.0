Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA27F309096
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 00:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231716AbhA2X1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 18:27:41 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:30640 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhA2X1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 18:27:21 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210129232634epoutp012e5999eee48f9c3a2ede7dc3ed9f6da1~e158TmHU13269132691epoutp01H
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 23:26:34 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210129232634epoutp012e5999eee48f9c3a2ede7dc3ed9f6da1~e158TmHU13269132691epoutp01H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1611962794;
        bh=GpaxTK1PcNel8mKDpotmZm41VFmcjlDIa3AGnoWHghA=;
        h=From:To:Cc:Subject:Date:References:From;
        b=hQS5TZmVNwFK6e8An+0AO5fBm+7QQgYpdSN60eKjTq/A/SvO0pa4paiYbRT1oPXcY
         KdNAfGsXjNx9nuFcP2IBh/AIp1M5v0Og3jEiNt6s2Zu9yirX9bVzQiI4wT5/DF354A
         M8TOzBL1afrZhVvNLLqapcyr+nlc1GgIvvYpAG+I=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210129232634epcas2p4b347ab52a2588725c88a80b401c90d4a~e157i17-t2268122681epcas2p48;
        Fri, 29 Jan 2021 23:26:34 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.185]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4DSD4R6b9mz4x9Pv; Fri, 29 Jan
        2021 23:26:31 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.2A.52511.7A994106; Sat, 30 Jan 2021 08:26:31 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171~e1537gzDt0785907859epcas2p1r;
        Fri, 29 Jan 2021 23:26:30 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210129232630epsmtrp24acc8d1cef1646c2202b26e46ef1bd04~e15334-872829828298epsmtrp2l;
        Fri, 29 Jan 2021 23:26:30 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-91-601499a74854
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        61.61.13470.5A994106; Sat, 30 Jan 2021 08:26:29 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210129232629epsmtip1f215075157cb7462359e1308aeb1dd20~e153o-whJ3062930629epsmtip1M;
        Fri, 29 Jan 2021 23:26:29 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     namkyu78.kim@samsung.com, Dongseok Yi <dseok.yi@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [RESEND PATCH net v4] udp: ipv4: manipulate network header of NATed
 UDP GRO fraglist
Date:   Sat, 30 Jan 2021 08:13:27 +0900
Message-Id: <1611962007-80092-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA02Sf0xTVxTHc997vBZI3UtheEci4tt0YlJswZYroWwZBN/m/sA5Nuc0pYG3
        0qy0TV9rJpGtq4CA/NSFCVbFUUWIjKwwRBSIpYhulS2uUWAsYxlqQ6CjgD+Ic67lYbb/vuee
        z/fcc889QlzcQcYKtXoza9KrdTQZQfQMJcglrY3RudKef2So/c9LBHr89CSOlpZ/FaBF9wiJ
        Ws4+wpH9pxICfdtXiiFvw98A2XovYMg3Pw3Qg4FqDP3cUxOGfumzk8g6eZhE15tj0PKQB0dX
        Kp4IkL/bLUA+xwmAHvZXEm9GM91t4xhTf9gvYC43/SZgmp0WpnLsNs442ytIpuxOO8YMXx0l
        mZrudsA4Sx1hzKIzLjtyry6tgFXns6Z4Vp9nyNfqNUp6525VhkqukMoksu0ohY7XqwtZJZ35
        brYkS6sLvpGOP6DWWYJH2WqOo7emp5kMFjMbX2DgzEqaNebrjDKZMZFTF3IWvSYxz1CYKpNK
        k+RBMldXMNFdRxrtks9ujZ8hrcC6sRKECyG1DX7vdJOVIEIopnoBrL5xAueDBQDPev/CQ5SY
        egRgo339C8c5T+2qox/AkR+eAj54AuDMvXFBiCKpzXDQ7wsLJaIpG4ANi24iFOCUh4C3jweI
        EBVFqeDw3QAIaYLaCFs7HCtuEZUJ7VeGBPx9cXB8tGKlKUhdFcLfBzwYn8iE94+eAbyOgjMj
        3auGWLjo7w82KAzqL2Dp0X28twpA78A0wTPJsOn+ERBicCoBdvZt5fFXoXtihcCpNbB86JmA
        PxbB8jIxL2lYv6Tia0Dou3l8tR4Dv/qmH/DD2g+bvzsP6sC6pv/KNwPQDmJYI1eoYbkk47b/
        f5ITrOztFqYXnJybT3QBTAhcAApxOlo0ZxfnikX56oNFrMmgMll0LOcC8uC06vHYl/MMwcXX
        m1UyeZJCId0uR3JFEqLXikzSKZWY0qjN7Kcsa2RNL3yYMDzWipX/WHN+s3+2KSJKsrih5Jjo
        WfgGe6RvGmvLudhj7rE1du0re2D9oFig1Ca/jcGcVselMXIKjzsUKFvQXiueG/NoUgO24uQK
        X+mX2inuRsbz9LpzyymGHWsvJu58rej6S1WjuS1Z698jHk6ltN7q0nduSrft2lVnlQ87b46K
        vB9OLrweduHgK47nosh32ua9nhZLxDA38NEn9Uy1uSCnqCFFE8gYG5zS3anSn6Y7rTEf1wb0
        j+/63/8jpnbCdUjbNrijRJXVpfy8I+HItfnct2rm1uCZl2P33LNJ1n0NZw8osk+lsm90uHaf
        HliYmaUEe/a2dQ66J/ZrKpaIhvqZydk0muAK1LItuIlT/wtzeOQaQAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsWy7bCSnO6ymSIJBqsULFY93s5i8f33bGaL
        Lz9vs1t8PnKczWLxwm/MFnPOt7BYrNvVymRxZdofRoumHSuYLF58eMJo8XxfL5PFhW19rBaX
        d81hs2i408xmcWyBmMXPw2eYLXZ3/mC3eLflCLvFiyUzGC2+7u1icRDx2LLyJpPHxOZ37B47
        Z91l91iwqdSj68YlZo9NqzrZPNqurWLyOLrnHJtH35ZVjB6bWpewenzeJBfAHcVlk5Kak1mW
        WqRvl8CVcWvLBLaCOboVZ2/OZ2tgbFDtYuTkkBAwkVh6pp+ti5GLQ0hgN6PE1sY/zF2MHEAJ
        CYldm10haoQl7rccYYWo+cYocXraG1aQBJuAhsT+dy/AEiICLUDNRw8ygzjMAvdYJM7s6mQB
        qRIWiJU4//YumM0ioCqxfO0SdhCbV8BFYs7uw+wQK+Qkbp7rZJ7AyLOAkWEVo2RqQXFuem6x
        YYFhXmq5XnFibnFpXrpecn7uJkZwBGhp7mDcvuqD3iFGJg7GQ4wSHMxKIrxv5wglCPGmJFZW
        pRblxxeV5qQWH2KU5mBREue90HUyXkggPbEkNTs1tSC1CCbLxMEp1cAUKzP7/6z91kIJazqs
        2nljw85MFzPfX+q+t6z2QrII666vQlvEVNxfLFuaHbXuz0knWRu1zqNptjYu9cdv7fBfLVF0
        /vXSFx+PTP74NfrylOjnU9vj7xf/8L/Q7P3UyaG+M5n1uEdp7+Nv5eYK+ooHPrDoHeub1jHX
        8LhJ8+zAUJ2uDI2u8oedPEe4ZMvVvl2reex5pfXFzWUqMyMfGSVeFoiS26+4mkk0nmn949MP
        v/Wdnu++69I7j3tnj37pelMjf2j61KR/P9WMkj6+u6Cm9u5ZtsRcUcPw/ff/vn+0X2BdeVKc
        qlfq5IualmyeYuefcUw4w7yk4Mrv7hnMIfN2fi/qf/Bn0c3Z6ezKb/SMlFiKMxINtZiLihMB
        heGvu+8CAAA=
X-CMS-MailID: 20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171
References: <CGME20210129232630epcas2p1071e141ef8059c4d5c0e4b28c181a171@epcas2p1.samsung.com>
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
Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
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

v4:
Clear "Changes Requested" mark in
https://patchwork.kernel.org/project/netdevbpf

Simplified the return statement in __udp_gso_segment_list.

 include/net/udp.h      |  2 +-
 net/ipv4/udp_offload.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++----
 net/ipv6/udp_offload.c |  2 +-
 3 files changed, 66 insertions(+), 7 deletions(-)

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
index ff39e94..cfc8726 100644
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
 
@@ -198,11 +257,11 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 
 	udp_hdr(skb)->len = htons(sizeof(struct udphdr) + mss);
 
-	return skb;
+	return is_ipv6 ? skb : __udpv4_gso_segment_list_csum(skb);
 }
 
 struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
-				  netdev_features_t features)
+				  netdev_features_t features, bool is_ipv6)
 {
 	struct sock *sk = gso_skb->sk;
 	unsigned int sum_truesize = 0;
@@ -214,7 +273,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	__be16 newlen;
 
 	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __udp_gso_segment_list(gso_skb, features);
+		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
@@ -328,7 +387,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
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

