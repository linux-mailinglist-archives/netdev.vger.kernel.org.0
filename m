Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303932EF2D8
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 14:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbhAHNFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 08:05:01 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:54091 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbhAHNFB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 08:05:01 -0500
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210108130417epoutp02abd36c1ba3e3dcc6b9e738b1b6e588f4~YQ3nYZ3nB2631526315epoutp02R
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 13:04:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210108130417epoutp02abd36c1ba3e3dcc6b9e738b1b6e588f4~YQ3nYZ3nB2631526315epoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610111057;
        bh=yb1t3lNqbCL3Nqp7DWuL9oagOsemytre08Dx52vmkE4=;
        h=From:To:Cc:Subject:Date:References:From;
        b=cp7v9pugOhOBIPyPNmnhuaH3VQHAnLUKW+GAiMDER+2n2ShJOZT+I0yrKjm/SR3/E
         Gp0eQiS+lIQIK1gj/Mi1uhhPvAaqHfdwQxsKjkojGC7NhLF+smbMAMNDkh3AQwjqH0
         Go9bbyZIHisPHtlS4psgI0HKQqKcXBcftZAbXcwc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210108130416epcas2p315eceb18ed8b6b8d19f939d2cf91f371~YQ3mlcyfs3150431504epcas2p3Z;
        Fri,  8 Jan 2021 13:04:16 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DC3G725SNz4x9Ps; Fri,  8 Jan
        2021 13:04:15 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        17.5E.10621.F4858FF5; Fri,  8 Jan 2021 22:04:15 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134~YQ3lDbVzT0173001730epcas2p3D;
        Fri,  8 Jan 2021 13:04:14 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210108130414epsmtrp19191f67cc9c95c1f0a8815bffec03fdb~YQ3lCmKXG2492724927epsmtrp1l;
        Fri,  8 Jan 2021 13:04:14 +0000 (GMT)
X-AuditID: b6c32a45-337ff7000001297d-91-5ff8584fba62
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.23.08745.E4858FF5; Fri,  8 Jan 2021 22:04:14 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210108130414epsmtip136ab199d368afbc5f67768065e310dc9~YQ3kyDt2l1414414144epsmtip1q;
        Fri,  8 Jan 2021 13:04:14 +0000 (GMT)
From:   Dongseok Yi <dseok.yi@samsung.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     namkyu78.kim@samsung.com, Dongseok Yi <dseok.yi@samsung.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH net] udp: check sk for UDP GRO fraglist
Date:   Fri,  8 Jan 2021 21:52:28 +0900
Message-Id: <1610110348-119768-1-git-send-email-dseok.yi@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsWy7bCmqa5/xI94g797eS3mnG9hsbgy7Q+j
        xYVtfawWF9pesVpc3jWHzaLhTjObxbEFYha7O3+wW7zbcoTd4uveLhYHLo8tK28yeSzYVOqx
        aVUnm0fbtVVMHlt+f2fz6NuyitFjU+sSVo/Pm+QCOKJybDJSE1NSixRS85LzUzLz0m2VvIPj
        neNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOATlRSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX
        2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgYmQJVJuRk7Jo3laWgSbBi5qJTTA2Mk/i6GDk5
        JARMJC7euMoGYgsJ7GCU6Pwb2sXIBWR/YpS4sKifFcL5zCjx++dZZpiOxYdvMkEkdjFK7Ju3
        lAWi/QejxOu36SA2m4CGxP53L1hBbBEBbYl1B3rAJjELXGCS+Dd7Ldg+YQFrid0T5jN2MXJw
        sAioStyYmwwS5hVwlfh34zQ7xDI5iZvnOplBeiUEbrFLHHnXzwiRcJFY2f8CqkhY4tXxLVC2
        lMTL/jZ2kJkSAvUSrd0xEL09jBJX9j1hgagxlpj1rB1sL7OApsT6XfoQ5coSR26BVTAL8El0
        HP4LNYVXoqNNCMJUkpj4JR5ihoTEi5OToeZ5SFw9dZkdEgixEg9fb2ScwCg7C2H8AkbGVYxi
        qQXFuempxUYFhsgxtIkRnOa0XHcwTn77Qe8QIxMH4yFGCQ5mJRFei2Nf4oV4UxIrq1KL8uOL
        SnNSiw8xmgIDayKzlGhyPjDR5pXEG5oamZkZWJpamJoZWSiJ8xYbPIgXEkhPLEnNTk0tSC2C
        6WPi4JRqYGJy/8Xvff/vDl7WuHqzV69K6gw6i/l3RE1fvszP/deLexOXM87qDdAIar0Y053u
        ljYjebc19xT1XyU/1vR8XOe7/tq/43slc5/27/1+wIN5o9Weqcvfycvz29q+CbsSKfU4Y07z
        pn9eVo5vn7AwHDx541sEw5Osuw2b8mWvXBDemqZx64rzybabhQt+bfMrbviXmX4n85LWddmn
        tb8vL/Rrq9PNDFjuELqvUeuex393vXWfjyy3+JYyR9vwhtmykCS96W8SPrAcerbNpzJSz2il
        hOxGizuyh3IfOMwu68t5Y+QjV3xYRPc0cxIX77IN8iHFYvZT49VfZ92/1zo5+LTA92PZ+scU
        e46/WlyZ3ajEUpyRaKjFXFScCACKrMO//AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJLMWRmVeSWpSXmKPExsWy7bCSnK5fxI94g0WftSzmnG9hsbgy7Q+j
        xYVtfawWF9pesVpc3jWHzaLhTjObxbEFYha7O3+wW7zbcoTd4uveLhYHLo8tK28yeSzYVOqx
        aVUnm0fbtVVMHlt+f2fz6NuyitFjU+sSVo/Pm+QCOKK4bFJSczLLUov07RK4MnbNm8pS0CRY
        MXPRKaYGxkl8XYycHBICJhKLD99kArGFBHYwShzsCe9i5ACKS0js2uwKUSIscb/lCGsXIxdQ
        yTdGiS2b3rGAJNgENCT2v3vBCmKLCGhLrDvQA1bELHCNSaLxciMzSEJYwFpi94T5jCBDWQRU
        JW7MTQYJ8wq4Svy7cZodYoGcxM1zncwTGHkWMDKsYpRMLSjOTc8tNiwwykst1ytOzC0uzUvX
        S87P3cQIDj0trR2Me1Z90DvEyMTBeIhRgoNZSYTX4tiXeCHelMTKqtSi/Pii0pzU4kOM0hws
        SuK8F7pOxgsJpCeWpGanphakFsFkmTg4pRqYLqTm7jk7cUruFV6nLzuXWV9uaNzMsX6zbMOR
        PiPfny5RaRPP1La5bel6tvE957xZBZbffk2qNJ+8f4fuv9TER8E1pnm5/stPK3ME8V9m+Kux
        Y32WUuv0s8YlV+bk5J+tS65hMY5Ocu0I4TRc5xwuN11K6l7o/Zm6x1Ljis/NXKDPd7arV2Pn
        /91BTTci/UwmqARx9UyYu3jVWSvWe2GcdZ9m/Fj0uvPxwaNH2KomzNt90JPr41y/aQcVtI8H
        X9LhcL174+COBd/uJ83dsYXZ/tXNPYVFkfJlvsY7Ds98uPaIwM1SoUlTFTneJa+2Kf+S4bVJ
        fPs6nhv7FpxhUuY+7WGrcU3yyde6/tBJXefUK5VYijMSDbWYi4oTAQ1dbHasAgAA
X-CMS-MailID: 20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134
References: <CGME20210108130414epcas2p3217d7b6ac8a8094c5b3b6c5e52480134@epcas2p3.samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is a workaround patch.

UDP/IP header of UDP GROed frag_skbs are not updated even after NAT
forwarding. Only the header of head_skb from ip_finish_output_gso ->
skb_gso_segment is updated but following frag_skbs are not updated.

A call path skb_mac_gso_segment -> inet_gso_segment ->
udp4_ufo_fragment -> __udp_gso_segment -> __udp_gso_segment_list
does not try to update any UDP/IP header of the segment list.

It might make sense because each skb of frag_skbs is converted to a
list of regular packets. Header update with checksum calculation may
be not needed for UDP GROed frag_skbs.

But UDP GRO frag_list is started from udp_gro_receive, we don't know
whether the skb will be NAT forwarded at that time. For workaround,
try to get sock always when call udp4_gro_receive -> udp_gro_receive
to check if the skb is for local.

I'm still not sure if UDP GRO frag_list is really designed for local
session only. Can kernel support NAT forward for UDP GRO frag_list?
What am I missing?

Fixes: 9fd1ff5d2ac7 (udp: Support UDP fraglist GRO/GSO.)
Signed-off-by: Dongseok Yi <dseok.yi@samsung.com>
---
 net/ipv4/udp_offload.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index ff39e94..d476216 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -457,7 +457,7 @@ struct sk_buff *udp_gro_receive(struct list_head *head, struct sk_buff *skb,
 	int flush = 1;
 
 	NAPI_GRO_CB(skb)->is_flist = 0;
-	if (skb->dev->features & NETIF_F_GRO_FRAGLIST)
+	if (sk && (skb->dev->features & NETIF_F_GRO_FRAGLIST))
 		NAPI_GRO_CB(skb)->is_flist = sk ? !udp_sk(sk)->gro_enabled: 1;
 
 	if ((sk && udp_sk(sk)->gro_enabled) || NAPI_GRO_CB(skb)->is_flist) {
@@ -537,8 +537,7 @@ struct sk_buff *udp4_gro_receive(struct list_head *head, struct sk_buff *skb)
 	NAPI_GRO_CB(skb)->is_ipv6 = 0;
 	rcu_read_lock();
 
-	if (static_branch_unlikely(&udp_encap_needed_key))
-		sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);
+	sk = udp4_gro_lookup_skb(skb, uh->source, uh->dest);
 
 	pp = udp_gro_receive(head, skb, uh, sk);
 	rcu_read_unlock();
-- 
2.7.4

