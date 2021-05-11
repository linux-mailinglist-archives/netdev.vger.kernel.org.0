Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73A1137A005
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 08:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhEKGwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 02:52:07 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:45157 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbhEKGwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 02:52:07 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210511065059epoutp033c637097bc5a35aa137b2bab3f418e8b~98Hy_AZEd1499314993epoutp03g
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 06:50:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210511065059epoutp033c637097bc5a35aa137b2bab3f418e8b~98Hy_AZEd1499314993epoutp03g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620715859;
        bh=1ZZQwBOGeu8uekno2BLelsyca/RkRfVZ3WSZ6YzujrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FYJbrrDwSm7hXgRCG/QXstKBSsaSp59HoLuhyCylpoGYoF29S9GsaCrBSRWK2Fffz
         b6hk4jm0gDDzrTDNRfXyTakLbDCbHeVxZbXhcpGPcWKYmlcUnpTiEUyMMzuArG+FzR
         cilrNRFZNIFxQRh4VH9Pc1UNrMQ9uuE1wnj6Z+3U=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20210511065058epcas2p1474564a69434b88d4767e643ad2e08b4~98HyNkJnm1838818388epcas2p1D;
        Tue, 11 May 2021 06:50:58 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.181]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4FfT8d4L6fz4x9Pq; Tue, 11 May
        2021 06:50:57 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        81.D1.09717.0592A906; Tue, 11 May 2021 15:50:57 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0~98HvxZexz1537715377epcas2p1V;
        Tue, 11 May 2021 06:50:56 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210511065056epsmtrp1154f42734008e77b75124006a195c029~98HvvtR5r2914829148epsmtrp1b;
        Tue, 11 May 2021 06:50:56 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-6c-609a295067c4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        3A.96.08637.F492A906; Tue, 11 May 2021 15:50:55 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20210511065055epsmtip23f9a9e7dd8a093cde3a8a426606b3c7f~98HvfyhHp0092600926epsmtip2E;
        Tue, 11 May 2021 06:50:55 +0000 (GMT)
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
Subject: [PATCH bpf v2] bpf: check BPF_F_ADJ_ROOM_FIXED_GSO when upgrading
 mss in 6 to 4
Date:   Tue, 11 May 2021 15:36:37 +0900
Message-Id: <1620714998-120657-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplk+LIzCtJLcpLzFFi42LZdljTQjdQc1aCwYnfjBbff89mtvjy8za7
        xecjx9ksFi/8xmwx53wLi8WVaX8YLZp2rGCyePHhCaPF8329TBYXtvWxWlzeNYfN4tgCMYuf
        h88wWyz+uQGoYskMRgd+jy0rbzJ5TGx+x+6xc9Zddo+uG5eYPTat6mTz6NuyitHj8ya5APao
        HJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUXnwBdt8wcoLuVFMoS
        c0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQWGhgV6xYm5xaV56XrJ+blWhgYGRqZAlQk5
        GQsXLGMq+CRW0dC8nrGBcalQFyMnh4SAicSjJ0vZQWwhgR2MEr2rnLoYuYDsT0D226WMEM43
        Ron29ReZYTomTz/FDJHYyygxY+IEqKofjBJ9jUdYQarYBDQk9r97AWaLCJhJbDxygwWkiFng
        MbNEz57lLCAJYYEoiYOPDoGNZRFQlWjZdwCsgVfAVWLahitMEOvkJG6e6wSr4RRwkfg04wPY
        agmBiRwSzVM/skAUuUicfbefFcIWlnh1fAs7hC0l8bK/DcjmALLrJVq7YyB6exglrux7AtVr
        LDHrWTsjSA2zgKbE+l36EOXKEkdugVUwC/BJdBz+CzWFV6KjTQjCVJKY+CUeYoaExIuTk6Hm
        eUj8nXKRFRIk0xklZnV0MU9glJuFMH8BI+MqRrHUguLc9NRiowIT5AjbxAhOl1oeOxhnv/2g
        d4iRiYPxEKMEB7OSCK9ox7QEId6UxMqq1KL8+KLSnNTiQ4ymwKCbyCwlmpwPTNh5JfGGpkZm
        ZgaWphamZkYWSuK8P1PrEoQE0hNLUrNTUwtSi2D6mDg4pRqYUk/8FVAx3Zi4vX239/qiwvaV
        LK/UN3mWV3v80086nyzxsN6o2mrt1cIp3/runWQSaGmeJrFc4GT0uvJNs7X7/qdej/5gM2XJ
        lTvidtM1Pro1G4v/vmcbxzRp3dabx7zdb2/W33rv4e5urV+/D6iZi1sdCxGyTSo6VP5FOGH9
        ++vMyW8+cc1MzbaaLDfR/dei6R6LmBdlxf0Xf1Tu3P4mwTiieEGO4dJ9Kdtdj+Wcc7l2hXW1
        2+9XLH+dbh1r3937vftl4e+UmnuZTqe9NOUu2bJ+WLxdbJWy+YobZvNTvQ5M7Vu4yUdm58+g
        fYZZM6LLTbTXrBBivL7KYMOnZ/efepyy3HJ0gV1a+a1ljcE3ryuxFGckGmoxFxUnAgChS3g1
        IAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWy7bCSvK6/5qwEgytfTS2+/57NbPHl5212
        i89HjrNZLF74jdlizvkWFosr0/4wWjTtWMFk8eLDE0aL5/t6mSwubOtjtbi8aw6bxbEFYhY/
        D59htlj8cwNQxZIZjA78HltW3mTymNj8jt1j56y77B5dNy4xe2xa1cnm0bdlFaPH501yAexR
        XDYpqTmZZalF+nYJXBkLFyxjKvgkVtHQvJ6xgXGpUBcjJ4eEgInE5OmnmEFsIYHdjBJHd7B2
        MXIAxSUkdm12hSgRlrjfcgQozAVU8o1R4viGZ2D1bAIaEvvfvWAFsUUEzCQ2HrnBAlLELPCR
        WeLotbdMIAlhgQiJkx2zGEFsFgFViZZ9B8AaeAVcJaZtuMIEsUFO4ua5TrChnAIuEp9mfIA6
        yFni3eFPLBMY+RYwMqxilEwtKM5Nzy02LDDMSy3XK07MLS7NS9dLzs/dxAgOay3NHYzbV33Q
        O8TIxMF4iFGCg1lJhFe0Y1qCEG9KYmVValF+fFFpTmrxIUZpDhYlcd4LXSfjhQTSE0tSs1NT
        C1KLYLJMHJxSDUyrGz/fDuk7b/SkfckdEfeeGefX58ytvZ9nZroxfaeMgrLJE6ZEGdM7t0qU
        N99deb/vyXvRlBzjOx2Ns573ZWk0/g6JcNw3i6n4uI/Fik/6l88kp1x7bnu4cMeJH7y2v6Zd
        3Xq58kGselWJ5Gmup3cYL3Nc6NKVa7IKO2nOvYF19q2qLC+pcvP9e/9/+bQqmHHLDmkOldby
        Ns3XQrOPTLvEdVM2dtHFFIfHtXzRH+pXXr78cifrhZpK/nXrkpQDZ082j+yf845FJGvaEelL
        abc25LpNn71xWqA6z2NlP7n/1RxTjqwJWDjD8bPHBd0VTyM+XnHLdOFMWXhhluZV9wUBr6fM
        aKxqTcn13cV+++Q3JZbijERDLeai4kQAE3Jh69oCAAA=
X-CMS-MailID: 20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0
References: <1619690903-1138-1-git-send-email-dseok.yi@samsung.com>
        <CGME20210511065056epcas2p1788505019deb274f5c57650a2f5d7ef0@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the forwarding path GRO -> BPF 6 to 4 -> GSO for TCP traffic, the
coalesced packet payload can be > MSS, but < MSS + 20.
bpf_skb_proto_6_to_4 will increase the MSS and it can be > the payload
length. After then tcp_gso_segment checks for the payload length if it
is <= MSS. The condition is causing the packet to be dropped.

tcp_gso_segment():
        [...]
        mss = skb_shinfo(skb)->gso_size;
        if (unlikely(skb->len <= mss))
                goto out;
        [...]

Allow to increase MSS when BPF_F_ADJ_ROOM_FIXED_GSO is not set.

Fixes: 6578171a7ff0 (bpf: add bpf_skb_change_proto helper)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
 net/core/filter.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

v2:
per Willem de Bruijn request,
checked the flag instead of a generic approach.

diff --git a/net/core/filter.c b/net/core/filter.c
index cae56d0..a98b28d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3276,7 +3276,7 @@ static int bpf_skb_proto_4_to_6(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
+static int bpf_skb_proto_6_to_4(struct sk_buff *skb, u64 flags)
 {
 	const u32 len_diff = sizeof(struct ipv6hdr) - sizeof(struct iphdr);
 	u32 off = skb_mac_header_len(skb);
@@ -3305,7 +3305,8 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 		}
 
 		/* Due to IPv4 header, MSS can be upgraded. */
-		skb_increase_gso_size(shinfo, len_diff);
+		if (!(flags & BPF_F_ADJ_ROOM_FIXED_GSO))
+			skb_increase_gso_size(shinfo, len_diff);
 		/* Header must be checked, and gso_segs recomputed. */
 		shinfo->gso_type |= SKB_GSO_DODGY;
 		shinfo->gso_segs = 0;
@@ -3317,7 +3318,7 @@ static int bpf_skb_proto_6_to_4(struct sk_buff *skb)
 	return 0;
 }
 
-static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
+static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto, u64 flags)
 {
 	__be16 from_proto = skb->protocol;
 
@@ -3327,7 +3328,7 @@ static int bpf_skb_proto_xlat(struct sk_buff *skb, __be16 to_proto)
 
 	if (from_proto == htons(ETH_P_IPV6) &&
 	      to_proto == htons(ETH_P_IP))
-		return bpf_skb_proto_6_to_4(skb);
+		return bpf_skb_proto_6_to_4(skb, flags);
 
 	return -ENOTSUPP;
 }
@@ -3337,7 +3338,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
 {
 	int ret;
 
-	if (unlikely(flags))
+	if (unlikely(flags & ~(BPF_F_ADJ_ROOM_FIXED_GSO)))
 		return -EINVAL;
 
 	/* General idea is that this helper does the basic groundwork
@@ -3357,7 +3358,7 @@ BPF_CALL_3(bpf_skb_change_proto, struct sk_buff *, skb, __be16, proto,
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

