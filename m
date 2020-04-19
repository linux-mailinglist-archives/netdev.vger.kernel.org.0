Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1958B1AF89F
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 10:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725949AbgDSILM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 04:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725446AbgDSILM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 04:11:12 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6B6C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 01:11:10 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x26so3467812pgc.10
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 01:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6J/mPMYONo5gu7uLY9QKdJaHPBRNRwBNp5lkyS11tDs=;
        b=jKUneVDi+J09a9WDwWf00+VveVDLUDDaqkTMxqb3nt0ltwsNTcqMDXaPlOU2FqHhmk
         Qg8VpFTbeyD8EA28MB/ML07u2vvOIHbrdnOz32QEdEz0xG3Wt8ywMOpJsyPaXtQ5NcGO
         iULedyp+9TJA7dlwGw6s9/eSgseHwonLV7JL0Z3Jr0kr2y8l3BtNqvjPqu+DmAqrZyKF
         GBYPnZ4EeQxeYm3QJcuCyIwEdhIdZiCzaJksLizuidqTO4fBInEYKiEW72BtUyrSENo5
         DsyviPvQTQpczAvM+hsWjfLQ5ABAyBi3/sDqTCPGshOzJx0Vyim+j84to7VtBafSRMmu
         dyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6J/mPMYONo5gu7uLY9QKdJaHPBRNRwBNp5lkyS11tDs=;
        b=IV++fVxPqZ7g6mXaqhUbFMgbkRSj2D+gUqp/olJNmKWs/IIxSBL5s8W09qYI1WJwuT
         icncrhNuvSMorNh7VI12x+cuOIM7zE81vLPuLlCmZBUdEnSqXm+8fqmN+cf5kwI0arkv
         2JkrcDCbiQXPTIiYWsIaXFFZmuJL5s2NqugPaJTtra9d308ZxTL37DzENKAF9lUqRlT6
         L2h3/9UVUmeAt7R0gsoUxkOcPX6GKOHjF6HDZHRQ3qjubdwh6q8dFa76UzgolAcNmerm
         Q3BS58blO7Jgq6mesk14qCb7FwwiUEIkDS/LZqfK3cbfvNxp/IVQyiigfelfIob8rhZe
         pWJw==
X-Gm-Message-State: AGi0Pub7MPkHF1ga7cYrwhbDWIbJPzWPiu4H35y+4dn0BWWaqVR4O3Xo
        sd7wG2C8z/E4zZJgm4+ZZwg9t/gd
X-Google-Smtp-Source: APiQypKNmFS76F/FSwPdqHnxPBmZldAlLjaIDaLGg6Z6qDRo3ml3c5MRrzBMK5X/LryZy1PpE96EFA==
X-Received: by 2002:a62:7515:: with SMTP id q21mr11939467pfc.1.1587283870112;
        Sun, 19 Apr 2020 01:11:10 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y29sm7335037pfq.162.2020.04.19.01.11.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 19 Apr 2020 01:11:09 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCHv2 ipsec] esp4: support ipv6 nexthdrs process for beet gso segment
Date:   Sun, 19 Apr 2020 16:11:02 +0800
Message-Id: <234f0732bd3bff63ea88febcd4107a32ac4d9f95.1587283862.git.lucien.xin@gmail.com>
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

v1->v2:
  - remove skb_transport_offset(), as it will always return 0
    in xfrm6_beet_gso_segment(), thank Sabrina's check.

Fixes: 384a46ea7bdc ("esp4: add gso_segment for esp4 beet mode")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/ipv4/esp4_offload.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 731022c..31eb976 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -139,7 +139,7 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	const struct net_offload *ops;
-	int proto = xo->proto;
+	u8 proto = xo->proto;
 
 	skb->transport_header += x->props.header_len;
 
@@ -148,10 +148,15 @@ static struct sk_buff *xfrm4_beet_gso_segment(struct xfrm_state *x,
 
 		skb->transport_header += ph->hdrlen * 8;
 		proto = ph->nexthdr;
-	} else if (x->sel.family != AF_INET6) {
+	} else if (x->sel.family == AF_INET6) {
+		__be16 frag;
+
+		skb->transport_header +=
+			ipv6_skip_exthdr(skb, 0, &proto, &frag);
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

