Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D04B11CE32F
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731268AbgEKSwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731254AbgEKSwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:52:41 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45BDC05BD0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:40 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id v12so12271375wrp.12
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8WE1/NXkJ1oiNDFE1ccGrf0FZFLSI3Tv3ZVU0NC0J4=;
        b=mJTTujAeLdpvRQavFE8LWxfo+/Gaf/M9rO8A2DoWoyF83fRPbWLtKCr+IS8iV4a7ll
         XnIB/iintPC0HE+jgsMM0GrH+Z6NRhkB+TXK1Hs7dQYbgQJ5hX2wkbavWIz5Qf1nMo8D
         lKZFugKkxcrKWDNwkaZElYRm4MKF2RIZr0vWI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8WE1/NXkJ1oiNDFE1ccGrf0FZFLSI3Tv3ZVU0NC0J4=;
        b=aqgJSvwFHxKLRJXbCyeD4A1ddf6X7DvkkiIZQWM+5L4mP+BJg/75YJAy+oUkqznF7/
         cLCoJ7fgeUV/M4i3hWTXoP87m3DYoTh2FyNIC6M5XbHZGtWo0PFsVACcTCSfG2D6Gu0w
         3/ePNQYWvLMtEcyzVFaXw/WNc9q8qCSZ08DeZvsvof3nuLcZtD4AtUi80gLrq6hSqDfZ
         AlYqp2LoI/Xhllpt1Kicgind82txG5UstZPeAZO3p4kHn0I+nVknJ26OISuuHINxiXym
         tvZoDmRR68fOR/K+JLtH37Cb83vnmpalxHeTGgNX7Ge/EWszjoRtHNhiZxL/1u6O5cNl
         k7pA==
X-Gm-Message-State: AGi0PubL9kzsGFE/CzPDuNQiulhHsodiT0ldFoh7wnO+Kn0ZmnGSa/ht
        AR1V2eiTwxmo1k71xpQzWwwe8FZpO3o=
X-Google-Smtp-Source: APiQypIKAayQ0sDnnQ59JMryw8SwjrFGB12lkr1ilPLtGJjlfTltShk4mOiUJmVpVBmhqPItVOsVdQ==
X-Received: by 2002:adf:dc81:: with SMTP id r1mr22282396wrj.0.1589223159219;
        Mon, 11 May 2020 11:52:39 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 2sm18708398wre.25.2020.05.11.11.52.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:52:38 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next v2 12/17] udp6: Run SK_LOOKUP BPF program on socket lookup
Date:   Mon, 11 May 2020 20:52:13 +0200
Message-Id: <20200511185218.1422406-13-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Same as for udp4, let BPF program override the socket lookup result, by
selecting a receiving socket of its choice or failing the lookup, if no
connected UDP socket matched packet 4-tuple.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv6/udp.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index ee2073329d25..934f41a5e6ca 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -197,28 +197,47 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       int dif, int sdif, struct udp_table *udptable,
 			       struct sk_buff *skb)
 {
+	struct sock *result, *sk, *reuse_sk;
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
-	struct sock *result;
 
 	hash2 = ipv6_portaddr_hash(net, daddr, hnum);
 	slot2 = hash2 & udptable->mask;
 	hslot2 = &udptable->hash2[slot2];
 
+	/* Lookup connected or non-wildcard sockets */
 	result = udp6_lib_lookup2(net, saddr, sport,
 				  daddr, hnum, dif, sdif,
 				  hslot2, skb);
-	if (!result) {
-		hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
-		slot2 = hash2 & udptable->mask;
+	if (!IS_ERR_OR_NULL(result) && result->sk_state == TCP_ESTABLISHED)
+		goto done;
 
-		hslot2 = &udptable->hash2[slot2];
-
-		result = udp6_lib_lookup2(net, saddr, sport,
-					  &in6addr_any, hnum, dif, sdif,
-					  hslot2, skb);
+	/* Lookup redirect from BPF */
+	sk = inet6_lookup_run_bpf(net, udptable->protocol,
+				  saddr, sport, daddr, hnum);
+	if (IS_ERR(sk))
+		return NULL;
+	if (sk) {
+		reuse_sk = lookup_reuseport(net, sk, skb,
+					    saddr, sport, daddr, hnum);
+		result = reuse_sk ? : sk;
+		goto done;
 	}
+
+	/* Got non-wildcard socket or error on first lookup */
+	if (result)
+		goto done;
+
+	/* Lookup wildcard sockets */
+	hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
+	slot2 = hash2 & udptable->mask;
+	hslot2 = &udptable->hash2[slot2];
+
+	result = udp6_lib_lookup2(net, saddr, sport,
+				  &in6addr_any, hnum, dif, sdif,
+				  hslot2, skb);
+done:
 	if (IS_ERR(result))
 		return NULL;
 	return result;
-- 
2.25.3

