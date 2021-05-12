Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D7A37B702
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 09:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbhELHmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 03:42:12 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29457 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbhELHmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 May 2021 03:42:10 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210512074101epoutp025f5532c6db5dd381ad236fe5ab9637a2~_QcxJbQrf1928819288epoutp02V
        for <netdev@vger.kernel.org>; Wed, 12 May 2021 07:41:01 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210512074101epoutp025f5532c6db5dd381ad236fe5ab9637a2~_QcxJbQrf1928819288epoutp02V
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620805261;
        bh=/5P0zVOAr68kzqqUZDGocRqA+7GX6RlmDAKCV49cpCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eRABht2Ied/mguI2cXG+XDo3vV02UFSBWijay+Kz92oUV/E0p5QQczmK4ROJxiyV6
         ktqqhjL66RVsy/T0hKpk6hFKm57Um6+0Flv5fOeIqtxLgTg5gMqCGEVJB+Uf8V5dLM
         0F/F4BSmr+CWnnqlPO7/UbO7+3bbGvPNJcyXAPfI=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210512074100epcas2p3572a8172bad93d908359a3aa657982e8~_QcwE-Iui2163021630epcas2p3Y;
        Wed, 12 May 2021 07:41:00 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.187]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Fg6Cv0S4cz4x9Px; Wed, 12 May
        2021 07:40:59 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        CF.C0.09433.A868B906; Wed, 12 May 2021 16:40:58 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210512074058epcas2p35536c27bdfafaa6431e164c142007f96~_QcuIN9se0074500745epcas2p3q;
        Wed, 12 May 2021 07:40:58 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210512074058epsmtrp1e8697b5bad8f956032fdf36cf7c5d626~_QcuHVWhm2316423164epsmtrp1N;
        Wed, 12 May 2021 07:40:58 +0000 (GMT)
X-AuditID: b6c32a47-f61ff700000024d9-a5-609b868a27a5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.8A.08163.A868B906; Wed, 12 May 2021 16:40:58 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210512074058epsmtip25071f1599a52de422c0db1bc8ecd4f91~_Qct615bx0633106331epsmtip26;
        Wed, 12 May 2021 07:40:58 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Dongseok Yi <dseok.yi@samsung.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next v3] bpf: check for BPF_F_ADJ_ROOM_FIXED_GSO when
 bpf_skb_change_proto
Date:   Wed, 12 May 2021 16:27:33 +0900
Message-Id: <1620804453-57566-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1620714998-120657-1-git-send-email-dseok.yi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdljTXLerbXaCwbEHOhbff89mtvjy8za7
        xecjx9ksFi/8xmwx53wLi8WVaX8YLZp2rGCyePHhCaPF8329TBYXtvWxWlzeNYfN4tgCMYuf
        h88wWyz+uQGoYskMRgd+jy0rbzJ5TGx+x+6xc9Zddo+uG5eYPTat6mTz6NuyitHj8ya5APao
        HJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLuVFMoS
        c0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5
        GX8bFrAUvJOtuL2uja2B8YN4FyMnh4SAiUT3k6fsXYxcHEICOxgl1j1/yQzhfGKUmP36F1Tm
        M6PEg++zWGFaPt35DZXYBZRYPQ+q5QejxK0N39hAqtgENCT2v3sB1iEiYCax8cgNFpAiZoHH
        zBI9e5azgCSEBRIkpqw8zAxiswioSpx494Kpi5GDg1fARWLWnDyIbXISN891gpVwCrhJdM08
        ADZHQmAqh8S2zs/sEEUuEocWbWGGsIUlXh3fAhWXknjZ38YOMlNCoF6itTsGoreHUeLKvics
        EDXGErOetTOC1DALaEqs36UPUa4sceQWWAWzAJ9Ex+G/UFN4JTrahCBMJYmJX+IhZkhIvDg5
        GWqeh8SXU42skBCZySixe0MzywRGuVkI8xcwMq5iFEstKM5NTy02KjBGjrBNjOB0qeW+g3HG
        2w96hxiZOBgPMUpwMCuJ8IolzU4Q4k1JrKxKLcqPLyrNSS0+xGgKDLmJzFKiyfnAhJ1XEm9o
        amRmZmBpamFqZmShJM77M7UuQUggPbEkNTs1tSC1CKaPiYNTqoFpk/2zdCfHg2zPefOb+dav
        P72rxO3KIT2rQ8wpUxX/WC3fsSz9z/e1601nHBSdbcbgyff17JUXZ2axy6vKN7eyTus02BP/
        /mE49/Z9eyo41BSMbJyXpTl+5b4lJO2lr+MpuGx7TNuLO09ljK9/rT13TvaWwN55cdrfLkzh
        e5Sk63+ms/HAxUOHm+2vcf7777j7n8lSgWonNY8iRsdI/ZLz1+7wuVXOvPliXm8xl6q9Rv8q
        wZsF8m3P5JlKnHd2VU6fu17cvWPthDsVK8OfiM+UOOzZkuffWjzrq9ib7V/j+Nzb1SMq9TrU
        YuqUPfp7vBKdBPU7/8lt2a6xxPqQkGbjMVcTJZ5Pc78KdBxedFGJpTgj0VCLuag4EQCaBI06
        IAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGLMWRmVeSWpSXmKPExsWy7bCSvG5X2+wEg4sLeC2+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFosr0/4wWjTtWMFk8eLDE0aL5/t6mSwubOtjtbi8aw6bxbEFYhY/
        D59htlj8cwNQxZIZjA78HltW3mTymNj8jt1j56y77B5dNy4xe2xa1cnm0bdlFaPH501yAexR
        XDYpqTmZZalF+nYJXBl/GxawFLyTrbi9ro2tgfGDeBcjJ4eEgInEpzu/2bsYuTiEBHYwShw5
        9Y2xi5EDKCEhsWuzK0SNsMT9liOsEDXfGCX23Z7GDpJgE9CQ2P/uBSuILSJgJrHxyA0WkCJm
        gY/MEkevvWUCSQgLxEnMX3yGBcRmEVCVOPHuBRPIAl4BF4lZc/IgFshJ3DzXyQxicwq4SXTN
        PMACUiIk4Cpx9wjTBEa+BYwMqxglUwuKc9Nziw0LjPJSy/WKE3OLS/PS9ZLzczcxgoNaS2sH
        455VH/QOMTJxMB5ilOBgVhLhFUuanSDEm5JYWZValB9fVJqTWnyIUZqDRUmc90LXyXghgfTE
        ktTs1NSC1CKYLBMHp1QDk937nNPZ4TYex9Z67zPY6qfzS5Jh0a2VEc2qV1rauY6+VvLYUai3
        RvWtZPb8+Q7R9+PdFgn/uxDSsc/m3MRVa4pZec7EGJt8tnkjOov7a/hl5lqG2/V2KW5iq/Z+
        dXwXwmoVkR1v78744GHv+r2dHI2MO9d6l1pNif87/W1M5fruLUUtDiYPtBTv7t2q1RY39d7+
        BHlgeAT9t7VsSPw7d9uHZv2UpLyz82XP58ft0rsY8TuRy16FQV/ia/bdCnk27VU/C/+0/db0
        XXRfJFXq+6l917urHoqY6V7km1Vt17X2W/fOaPblE56n/WLRi5vgKnnsyxp7J+f1rHfYX34P
        c6lOk3g1c5Wh/YYASy4lluKMREMt5qLiRABxpG712QIAAA==
X-CMS-MailID: 20210512074058epcas2p35536c27bdfafaa6431e164c142007f96
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210512074058epcas2p35536c27bdfafaa6431e164c142007f96
References: <1620714998-120657-1-git-send-email-dseok.yi@samsung.com>
        <CGME20210512074058epcas2p35536c27bdfafaa6431e164c142007f96@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
coalesced packet payload can be > MSS, but < MSS + 20.
bpf_skb_proto_6_to_4 will upgrade the MSS and it can be > the payload
length. After then tcp_gso_segment checks for the payload length if it
is <= MSS. The condition is causing the packet to be dropped.

tcp_gso_segment():
        [...]
        mss = skb_shinfo(skb)->gso_size;
        if (unlikely(skb->len <= mss))
                goto out;
        [...]

Allow to upgrade/downgrade MSS only when BPF_F_ADJ_ROOM_FIXED_GSO is
not set.

Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
 net/core/filter.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

v2:
per Willem de Bruijn request,
checked the flag instead of a generic approach.

v3:
per Willem de Bruijn request,
moved to bpf-next, supported for both 6_to_4 and 4_to_6.

diff --git a/net/core/filter.c b/net/core/filter.c
index cae56d0..582ac19 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3235,7 +3235,7 @@ static int bpf_skb_net_hdr_pop(struct sk_buff *skb, u32 off, u32 len)
 	return ret;
 }
 
-static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
+static int bpf_skb_proto_4_to_6(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3264,7 +3264,9 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 		}
 
 		/* Due to IPv6 header, MSS needs to be downgraded. */
-		skb_decrease_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_decrease_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3276,7 +3278,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3305,7 +3307,9 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_increase_gso_size(shinfo, len_diff);
+
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3317,17 +3321,17 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
+static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u64 flags)
 {
 	__be16 from_proto = skb->protocol;
 
 	if (from_proto == htons(ETH_P_IP) &&
 	      to_proto == htons(ETH_P_IPV6))
-		return bpf_skb_proto_4_to_6(skb);
+		return bpf_skb_proto_4_to_6(skb, flags);
 
 	if (from_proto == htons(ETH_P_IPV6) &&
 	      to_proto == htons(ETH_P_IP))
-		return bpf_skb_proto_6_to_4(skb);
+		return bpf_skb_proto_6_to_4(skb, flags);
 
 	return -ENOTSUPP;
 }
@@ -3337,7 +3341,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 {
 	int ret;
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -3357,7 +3361,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 	 * that. For offloads, we mark packet as dodgy, so that headers
 	 * need to be verified first.
 	 */
-	ret = bpf_skb_proto_xlat(skb, proto);
+	ret = bpf_skb_proto_xlat(skb, proto, flags);
 	bpf_compute_data_pointers(skb);
 	return ret;
 }
-- 
2.7.4

