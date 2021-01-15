Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0784E2F7CBE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:34:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbhAONca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:32:30 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:16565 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731503AbhAONc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:32:29 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210115133203epoutp0226fa5d51d0555b6f80f76a400c697460~aaw2yiLui2378723787epoutp02o
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 13:32:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210115133203epoutp0226fa5d51d0555b6f80f76a400c697460~aaw2yiLui2378723787epoutp02o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610717523;
        bh=mkzX2Z7+8QKr2X7xIAP/6icPPC1yyAT/i04pPJ5qkFE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=NPjFOSNOqGWnrexkABw5IVDJeJBh6do/NOU3+/Yd1b4mL2102HSCrCs3+GiKQok+A
         TWlR/cx+M5jz0kmCIk0fr8zSBkhVcsDM2eAfQ9D39KntolJrCcxkZPo6lONGlZ1TSP
         OVv+NjNXJ6flLgpRNIwgeiwKDEes0SMP2EesnZJs=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210115133202epcas2p14ef596c8a20f2a972cba38efa311fea8~aaw2CpW2R1427714277epcas2p1U;
        Fri, 15 Jan 2021 13:32:02 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4DHMXw51KLz4x9Pp; Fri, 15 Jan
        2021 13:32:00 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        D6.9B.52511.05991006; Fri, 15 Jan 2021 22:32:00 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2~aawz7kFkm1427714277epcas2p1O;
        Fri, 15 Jan 2021 13:32:00 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210115133200epsmtrp155b483b6507b823dc904f4db30d938a6~aawz6zgY50635706357epsmtrp1I;
        Fri, 15 Jan 2021 13:32:00 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-b5-600199504370
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        93.4C.13470.05991006; Fri, 15 Jan 2021 22:32:00 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210115133159epsmtip17d9781d744e425e76a0be994756589ce~aawzp9fl90875308753epsmtip1Z;
        Fri, 15 Jan 2021 13:31:59 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Alexander Lobakin <alobakin@pm.me>
Cc:     namkyu78.kim@samsung.com, Dongseok Yi <dseok.yi@samsung.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2] udp: ipv4: manipulate network header of NATed UDP
 GRO fraglist
Date:   Fri, 15 Jan 2021 22:20:35 +0900
Message-Id: <1610716836-140533-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsWy7bCmuW7ATMYEg01XVS1WPd7OYjHnfAuL
        xZVpfxgtLmzrY7W4vGsOm0XDnWY2i2MLxCx2d/5gt3i35Qi7xde9XSwOXB5bVt5k8liwqdRj
        06pONo+2a6uYPI7uOcfm0bdlFaPHptYlrB6fN8kFcETl2GSkJqakFimk5iXnp2TmpdsqeQfH
        O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaikUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8u
        sVVKLUjJKTA0LNArTswtLs1L10vOz7UyNDAwMgWqTMjJmN//j7FgilbFrpPzGBsYtyl1MXJy
        SAiYSEz5+Iexi5GLQ0hgB6PEv8YZ7CAJIYFPjBLvL2dCJL4xSszeuYmpi5EDrOPPOVaI+F5G
        iTk/b7NDOD8YJU43bwLrZhPQkNj/7gVYlYhAE6PEtM9HWEAcZpCxX6f3MoNUCQtESNw53swC
        YrMIqEpMmTiXGWQFr4CrxIrXthD3yUncPNfJDNIrIXCLXeLe/n9sEAkXiXeNS6FsYYlXx7ew
        Q9hSEi/729ghTq2XaO2OgejtYZS4su8JC0SNscSsZ+2MIDXMApoS63fpQ5QrSxy5BVbBLMAn
        0XH4L9QUXomONiEIU0li4pd4iBkSEi9OToaa5yHxbG0XNNxiJf4+2cw4gVF2FsL4BYyMqxjF
        UguKc9NTi40KTJCjaBMjONFpeexgnP32g94hRiYOxkOMEhzMSiK8+coMCUK8KYmVValF+fFF
        pTmpxYcYTYGBNZFZSjQ5H5hq80riDU2NzMwMLE0tTM2MLJTEeYsMHsQLCaQnlqRmp6YWpBbB
        9DFxcEo1MJXun1eZKeM413ON+W3zB4u37Z8Vqyzk/md76Vq/89zJi/Kc0nwNSq1+yfk9qeVX
        i1V3bzTO1s40rZxr7Tot7lyX56ZXYlxM5xwND5z4rDZ5xrti9fv/nSdJG25eZjzd2ezoLeV5
        +/oefzh6xejHiagLOd8f8xZOKPU7t+LrBtn3f81ci6oX3Xis7/PwMnOw3ZLEU5cd7zcoKsev
        CZyi3iuw4lc8S4Tzr4WBl6aLL4xdtiD762uRIwXnLvn7B+UWa3yLMs5pEy9bZPP6aaG5FKM3
        n2iCXWbchLsRG85mbGr1dlHcX3j6qKVJqFdiyGenONVTG/vfbXJcIitokJETvFEiopJ9439v
        J/+1s+3mKLEUZyQaajEXFScCAKffPmn9AwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFLMWRmVeSWpSXmKPExsWy7bCSnG7ATMYEg2ebWS1WPd7OYjHnfAuL
        xZVpfxgtLmzrY7W4vGsOm0XDnWY2i2MLxCx2d/5gt3i35Qi7xde9XSwOXB5bVt5k8liwqdRj
        06pONo+2a6uYPI7uOcfm0bdlFaPHptYlrB6fN8kFcERx2aSk5mSWpRbp2yVwZczv/8dYMEWr
        YtfJeYwNjNuUuhg5OCQETCT+nGPtYuTiEBLYzShxeccyFoi4hMSuza5djJxAprDE/ZYjUDXf
        GCVWP+tiB0mwCWhI7H/3AiwhItDCKLH16EFmEIdZ4AejxMn270wgVcICYRJP3twE62ARUJWY
        MnEuM8gGXgFXiRWvbSE2yEncPNfJPIGRZwEjwypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k
        /NxNjODg09Lcwbh91Qe9Q4xMHIyHGCU4mJVEePOVGRKEeFMSK6tSi/Lji0pzUosPMUpzsCiJ
        817oOhkvJJCeWJKanZpakFoEk2Xi4JRqYDp73uhRXf/fq/LV11Q/H1n5a56FxlaHxAYdNqPp
        LZZGSwLT+8LdDbJfRziefe/l8vryVIUfDOz3JhznLvPJnGN4z6Tn8GNTlqRvCzJnbXB68Y2n
        K/vz6/jltx5W3JweoFu43nVjLOOqzWcKKhVq8yY539qoneA/38tl01yzRVeXNKnH1Pzij940
        wXnOptrwuzPys9fuOSunLdFcav3rgW79g/l2zLcOV6k/Xt87a+u6sGJOl1dL3i2M9+0VnPk3
        WLHm4g9B/iol55RDpv5yKze4TS269fbzyS2X3k46XFX6Z/GfQq81Z+aXBEhZlBzm1fuVefy1
        F6+Z+aSiVzM39mU/arU1XaB9ee3jtD+Vj5WVWIozEg21mIuKEwGCIk/UrQIAAA==
X-CMS-MailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2
References: <CGME20210115133200epcas2p1f52efe7bbc2826ed12da2fde4e03e3b2@epcas2p1.samsung.com>
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

Update dport, daddr and checksums of each skb of the segment list
in __udp_gso_segment_list. It covers both SNAT and DNAT.

Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
v1:
Steffen Klassert said, there could be 2 options.
https://lore.kernel.org/patchwork/patch/1362257/
I was trying to write a quick fix, but it was not easy to forward
segmented list. Currently, assuming DNAT only.

v2:
Per Steffen Klassert request, move the procedure from
udp4_ufo_fragment to __udp_gso_segment_list and support SNAT.

To Alexander Lobakin, I've checked your email late. Just use this
patch as a reference. It support SNAT too, but does not support IPv6
yet. I cannot make IPv6 header changes in __udp_gso_segment_list due
to the file is in IPv4 directory.

 include/net/udp.h      |  2 +-
 net/ipv4/udp_offload.c | 62 ++++++++++++++++++++++++++++++++++++++++++++++----
 net/ipv6/udp_offload.c |  2 +-
 3 files changed, 59 insertions(+), 7 deletions(-)

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
index ff39e94..c532d3b 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -187,8 +187,57 @@ struct sk_buff *skb_udp_tunnel_segment(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(skb_udp_tunnel_segment);
 
+static void __udpv4_gso_segment_csum(struct sk_buff *seg,
+				     __be32 *oldip, __be32 *newip,
+				     __be16 *oldport, __be16 *newport)
+{
+	struct udphdr *uh = udp_hdr(seg);
+	struct iphdr *iph = ip_hdr(seg);
+
+	if (uh->check) {
+		inet_proto_csum_replace4(&uh->check, seg, *oldip, *newip,
+					 true);
+		inet_proto_csum_replace2(&uh->check, seg, *oldport, *newport,
+					 false);
+		if (!uh->check)
+			uh->check = CSUM_MANGLED_0;
+	}
+	uh->dest = *newport;
+
+	csum_replace4(&iph->check, *oldip, *newip);
+	iph->daddr = *newip;
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
+	while ((seg = seg->next)) {
+		uh2 = udp_hdr(seg);
+		iph2 = ip_hdr(seg);
+
+		if (uh->source != uh2->source || iph->saddr != iph2->saddr)
+			__udpv4_gso_segment_csum(seg,
+						 &iph2->saddr, &iph->saddr,
+						 &uh2->source, &uh->source);
+
+		if (uh->dest != uh2->dest || iph->daddr != iph2->daddr)
+			__udpv4_gso_segment_csum(seg,
+						 &iph2->daddr, &iph->daddr,
+						 &uh2->dest, &uh->dest);
+	}
+
+	return segs;
+}
+
 static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
-					      netdev_features_t features)
+					      netdev_features_t features, bool is_ipv6)
 {
 	unsigned int mss = skb_shinfo(skb)->gso_size;
 
@@ -198,11 +247,14 @@ static struct sk_buff *__udp_gso_segment_list(struct sk_buff *skb,
 
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
@@ -214,7 +266,7 @@ struct sk_buff *__udp_gso_segment(struct sk_buff *gso_skb,
 	__be16 newlen;
 
 	if (skb_shinfo(gso_skb)->gso_type & SKB_GSO_FRAGLIST)
-		return __udp_gso_segment_list(gso_skb, features);
+		return __udp_gso_segment_list(gso_skb, features, is_ipv6);
 
 	mss = skb_shinfo(gso_skb)->gso_size;
 	if (gso_skb->len <= sizeof(*uh) + mss)
@@ -328,7 +380,7 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
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

