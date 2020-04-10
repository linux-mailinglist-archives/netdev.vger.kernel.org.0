Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5261A4439
	for <lists+netdev@lfdr.de>; Fri, 10 Apr 2020 11:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726181AbgDJJIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Apr 2020 05:08:11 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:38696 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725858AbgDJJIK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Apr 2020 05:08:10 -0400
Received: by mail-pg1-f195.google.com with SMTP id p8so754138pgi.5
        for <netdev@vger.kernel.org>; Fri, 10 Apr 2020 02:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PjjdnMg4QIkDkQneXPUfUGV/MuHru1LtccSwLmV87Y4=;
        b=LBLWBNtlslDUqSp9Qe2U3Cr8/qBL+aPTCAgFSib7pw2CfG2k+AEy8XikYNLU7qQIhN
         YfNLkQk1y6idmvlU/M1rUUhlbubo3kqw3eycXU5h0ZMla0v5UV1fZkRVwUxxtrvydwMp
         iOi/zMMm1nO1MSZiVVzs17peirj2HmDQUvFKan/aD64ttvC1n6Ldy0bJB3QrYOCv7kd6
         tIYBGyctsQy6to0Zik0XYJzp2WYgs/b0NqEDMrfBCYKdQfV/gTRgeDTOplDiSKWI4du5
         ali9g/J2MUr/byCwlUEmWj4ADguMxNxFfdtb0j74Kxe8uo6mPixfNFHzfecNn9YCOnpM
         wP8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=PjjdnMg4QIkDkQneXPUfUGV/MuHru1LtccSwLmV87Y4=;
        b=pxCUduXhmWauG+IKQMZwk6ucm44VQ+MN1NfzjFogsSip/KiTe+cPAxZKb58K7B9UPy
         88NL7tje4bN+tAeUll1sE7ETfuFaUlcKHq1RuRUs4raujtoU1W5fAbX7dGlr0hKeL8M9
         oY4rETtupYxLLwpYi/ja/EEnHCMazM1TAjhP5jK5uSqoYB9V/c8KIqlaeounMbRQKsyD
         q0/A1h5GYSFm5E8lLj0a2JD3onZcvEwTbuWSo5hmSYqQdxsczxKonuen/p8Tcnm1+ck4
         ZEYuDTtOZNemq3OOQZB5kU4tjxXaS2m1BE++p30yfrQ/hGVKk2q2tQ0v1drA4qyLvtDv
         BNBQ==
X-Gm-Message-State: AGi0PuZmmZo9kKlYNCdP06IhtuOz4J2hWQ9ZrEV+VQFc4VXuBDBM4bFy
        yCpdlLUdXbvuTK31OUxeVCgjPivE
X-Google-Smtp-Source: APiQypJSzf6qBbk19UzDguAy4gjnOPVKfV5r6Dcf4TWvB9SnqMWCEUa3prpwCBlZRIc2LBbblesU5A==
X-Received: by 2002:a63:5d42:: with SMTP id o2mr3469734pgm.265.1586509685950;
        Fri, 10 Apr 2020 02:08:05 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 3sm1217698pfd.140.2020.04.10.02.08.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Apr 2020 02:08:05 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec] esp4: support ipv6 nexthdrs process for beet gso segment
Date:   Fri, 10 Apr 2020 17:07:58 +0800
Message-Id: <b1b39c63ff48deca9e7c8011d747dcf4db05a6c1.1586509678.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For beet mode, when it's ipv6 inner address with nexthdrs set,
the packet format might be:

    ----------------------------------------------------
    | outer  |     | dest |     |      |  ESP    | ESP |
    | IP hdr | ESP | opts.| TCP | Data | Trailer | ICV |
    ----------------------------------------------------

Before doing gso segment in xfrm4_beet_gso_segment(), the same
thing is needed as it does in xfrm6_beet_gso_segment() in last
patch 'esp6: support ipv6 nexthdrs process for beet gso segment'.

Fixes: 384a46ea7bdc ("esp4: add gso_segment for esp4 beet mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 731022c..9dde4e3 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -139,7 +139,7 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -148,10 +148,16 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 
 		skb->transport_header += ph->hdrlen * 8;
 		proto = ph->nexthdr;
-	} else if (x->sel.family != AF_INET6) {
+	} else if (x->sel.family == AF_INET6) {
+		int offset = skb_transport_offset(skb);
+		__be16 frag;
+
+		offset = ipv6_skip_exthdr(skb, offset, &proto, &frag);
+		skb->transport_header += offset;
+		if (proto == IPPROTO_TCP)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
+	} else {
 		skb->transport_header -= IPV4_BEET_PHMAXLEN;
-	} else if (proto == IPPROTO_TCP) {
-		skb_shinfo(skb)->gso_type |= SKB_GSO_TCPV4;
 	}
 
 	__skb_pull(skb, skb_transport_offset(skb));
-- 
2.1.0

