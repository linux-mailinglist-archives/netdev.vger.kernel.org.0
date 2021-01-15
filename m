Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48242F72BE
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 07:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbhAOGL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 01:11:29 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45894 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbhAOGL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 01:11:28 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210115061043epoutp014ae7905157d71a80ec063c8014a793f1~aUvhePThx2556025560epoutp01X
        for <netdev@vger.kernel.org>; Fri, 15 Jan 2021 06:10:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210115061043epoutp014ae7905157d71a80ec063c8014a793f1~aUvhePThx2556025560epoutp01X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610691043;
        bh=/ClZBDspCYZj+U5ATmBXmCgRr4LZt11VuernE0g7V68=;
        h=From:To:Cc:Subject:Date:References:From;
        b=EyiBgKkdOCPQGCAjJThu4qrAnUq3rGXYeG39VXnwMaNnFnB0qlJwZB1TBhEDFrTWz
         BzXFD+4LizRbkYuiaUbaLYiWzEEhkFQIgBG2Ezc3MQz6y6guYlaA3l0YC8+vFqDyj8
         xfUNUYRypxMBzZUgqnBl9BAxHIfHzTceC2Xd7/wg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210115061042epcas2p20b960fe46f842c0865ae9e21d1b6bb07~aUvg29chO2011920119epcas2p2t;
        Fri, 15 Jan 2021 06:10:42 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DH9lh3n3Dz4x9QM; Fri, 15 Jan
        2021 06:10:40 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        C1.1A.52511.0E131006; Fri, 15 Jan 2021 15:10:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704~aUveGCn4X2762527625epcas2p4p;
        Fri, 15 Jan 2021 06:10:39 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210115061039epsmtrp18a68105e92a576c0b2a89ac7dce5389d~aUveFQdVA2704227042epsmtrp1L;
        Fri, 15 Jan 2021 06:10:39 +0000 (GMT)
X-AuditID: b6c32a48-4f9ff7000000cd1f-56-600131e028f8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        4E.99.08745.FD131006; Fri, 15 Jan 2021 15:10:39 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210115061039epsmtip1370aaaa876c4e7f4df790d32f9dbc9d4~aUvd2JheV3029930299epsmtip1e;
        Fri, 15 Jan 2021 06:10:39 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     namkyu78.kim@samsung.com, Alexander Lobakin <alobakin@pm.me>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] udp: ipv4: manipulate network header of NATed UDP GRO
 fraglist
Date:   Fri, 15 Jan 2021 14:58:24 +0900
Message-Id: <1610690304-167832-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOKsWRmVeSWpSXmKPExsWy7bCmhe4DQ8YEg+2PBSxWPd7OYjHnfAuL
        xZVpfxgtLmzrY7W4vGsOm0XDnWY2i2MLxCx2d/5gt3i35Qi7xde9XSwOXB5bVt5k8liwqdRj
        06pONo+2a6uYPI7uOcfm0bdlFaPHptYlrB6fN8kFcETl2GSkJqakFimk5iXnp2TmpdsqeQfH
        O8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAnaikUJaYUwoUCkgsLlbSt7Mpyi8tSVXIyC8u
        sVVKLUjJKTA0LNArTswtLs1L10vOz7UyNDAwMgWqTMjJWPY4sOCPaMX3DzPZGxjPCXYxcnJI
        CJhIbPzUxtTFyMUhJLCDUeLavf0sEM4nRokdbdsYQaqEBD4zSjx+XwHT0f1lFVTRLkaJhq1X
        oJwfjBJv131nBaliE9CQ2P/uBZgtIhAn0XG0gxGkiFlgGpPE6untYGOFBUIlrjzqYQexWQRU
        Jabf+MYGYvMKuEqsevSWDWKdnMTNc53MEPY1dokjJ4C2cQDZLhK7FvlAhIUlXh3fwg5hS0m8
        7G9jhyipl2jtjgFZKyHQwyhxZd8TFogaY4lZz0BO4AC6R1Ni/S59iHJliSO3wCqYBfgkOg7/
        hZrCK9HRJgRhKklM/BIPMUNC4sXJyVDzPCS+dzwCO0tIIFbi/QLvCYyysxCmL2BkXMUollpQ
        nJueWmxUYIIcP5sYwSlOy2MH4+y3H/QOMTJxMB5ilOBgVhLhzVdmSBDiTUmsrEotyo8vKs1J
        LT7EaAoMqonMUqLJ+cAkm1cSb2hqZGZmYGlqYWpmZKEkzltk8CBeSCA9sSQ1OzW1ILUIpo+J
        g1OqgUnD+1xf89q2lStdCzKXmjlnFLIsExD+sOi/ybKqFcczN8i679HMUfxqEbhvud19bjH7
        UwotF48WPI7NCeN/fvrh1ItzfY/yu35ts/16KW/WfjfNJ/GHo15P3BaRsm+y7pmEkq0qHgkJ
        L5lMjpy9vb675/Myu+rGFnmN9F0ThVXZZ9wIE1pRXca9J6Zos8XedQ8Vn32d+GTCJZuoKct5
        dW9qc/HbBe8J2l0Q4OO4tvW6Tfmf9/Eb5OoeGb6Zme5ybldKbl/fw+iNWqL2x63/zto0i7lG
        LsPE+CO7Zr+WWNeejwcWZ3slTtN7PzNo9YqA6R9rj1+UDanpSVU8yJysr7tw0aso5o4nyyYv
        vVtyYokSS3FGoqEWc1FxIgDXGCK/+gMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsWy7bCSnO59Q8YEg2vz1S1WPd7OYjHnfAuL
        xZVpfxgtLmzrY7W4vGsOm0XDnWY2i2MLxCx2d/5gt3i35Qi7xde9XSwOXB5bVt5k8liwqdRj
        06pONo+2a6uYPI7uOcfm0bdlFaPHptYlrB6fN8kFcERx2aSk5mSWpRbp2yVwZSx7HFjwR7Ti
        +4eZ7A2M5wS7GDk5JARMJLq/rGLpYuTiEBLYwShxdGYbaxcjB1BCQmLXZleIGmGJ+y1HWCFq
        vjFKHPv2mxkkwSagIbH/3QtWEFtEIE7i0KxlYDazwDwmiQM3i0BsYYFgieevbrOB2CwCqhLT
        b3wDs3kFXCVWPXrLBrFATuLmuU7mCYw8CxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn
        525iBIeeltYOxj2rPugdYmTiYDzEKMHBrCTCm6/MkCDEm5JYWZValB9fVJqTWnyIUZqDRUmc
        90LXyXghgfTEktTs1NSC1CKYLBMHp1QDE2vtG60NshyCvqt6q8LO+uje1PTXsuNtXbZ7orvU
        XuXijxWqvxmt9h27sfjVpedZqZ+SZh5rTptrby14nf9SLfPqRWYv47/Gr7RcH3ZEPEjyQbXu
        WtXSxEsplldUWzd97okPdvnWf+pg9ISnKY7hWln1JnddH164elSoUeehz6QT5sc/Tfty647b
        lk/dHH2N3SvEk77rxz59ob5ug2BMkHTnpDhRy8dybUY1ugFPX/Tfuh9/6N4E+yPGXx47Vc1j
        OHb+UhiDYP/azht7gpM2315dnBxsYfLd30z/ffsJ671tf7TUDloEz9OU5D+f9InnzuGaFemb
        tZ03WvS2b2aeJTB1NbuyPIe5feNW6TdBSizFGYmGWsxFxYkAJuVp/awCAAA=
X-CMS-MailID: 20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704
References: <CGME20210115061039epcas2p479bc5f3dd3dad5a250c4e0fc42896704@epcas2p4.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
forwarding. Only the header of head_skb from ip_finish_output_gso ->
skb_gso_segment is updated but following frag_skbs are not updated.

A call path skb_mac_gso_segment -> inet_gso_segment ->
udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
does not try to update UDP/IP header of the segment list.

Update dport, daddr and checksums of each skb of the segment list
after __udp_gso_segment.

Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
Steffen Klassert said, there could be 2 options.
https://lore.kernel.org/patchwork/patch/1362257/

I was trying to write a quick fix, but it was not easy to forward
segmented list. Currently, assuming DNAT only. Should we consider
SNAT too?

 net/ipv4/udp_offload.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94..7e24928 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -309,10 +309,12 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 					 netdev_features_t features)
 {
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
+	struct sk_buff *seg;
 	unsigned int mss;
 	__wsum csum;
-	struct udphdr *uh;
-	struct iphdr *iph;
+	struct udphdr *uh, *uh2;
+	struct iphdr *iph, *iph2;
+	bool is_fraglist = false;
 
 	if (skb->encapsulation &&
 	    (skb_shinfo(skb)->gso_type &
@@ -327,8 +329,43 @@ static struct sk_buff *udp4_ufo_fragment(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, sizeof(struct udphdr)))
 		goto out;
 
-	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4)
-		return __udp_gso_segment(skb, features);
+	if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
+		if (skb_shinfo(skb)->gso_type & SKB_GSO_FRAGLIST)
+			is_fraglist = true;
+
+		segs = __udp_gso_segment(skb, features);
+		if (IS_ERR_OR_NULL(segs) || !is_fraglist)
+			return segs;
+
+		seg = segs;
+		uh = udp_hdr(seg);
+		iph = ip_hdr(seg);
+
+		while ((seg = seg->next)) {
+			uh2 = udp_hdr(seg);
+			iph2 = ip_hdr(seg);
+
+			if (uh->dest == uh2->dest && iph->daddr == iph2->daddr)
+				continue;
+
+			if (uh2->check) {
+				inet_proto_csum_replace4(&uh2->check, seg,
+							 iph2->daddr,
+							 iph->daddr, true);
+				inet_proto_csum_replace2(&uh2->check, seg,
+							 uh2->dest, uh->dest,
+							 false);
+				if (!uh2->check)
+					uh2->check = CSUM_MANGLED_0;
+			}
+			uh2->dest = uh->dest;
+
+			csum_replace4(&iph2->check, iph2->daddr, iph->daddr);
+			iph2->daddr = iph->daddr;
+		}
+
+		return segs;
+	}
 
 	mss = skb_shinfo(skb)->gso_size;
 	if (unlikely(skb->len <= mss))
-- 
2.7.4

