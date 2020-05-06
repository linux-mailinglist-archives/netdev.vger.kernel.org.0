Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AF7E1C70FE
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbgEFMzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728751AbgEFMzf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:35 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C7DC061A41
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so2477583wmc.2
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I8WE1/NXkJ1oiNDFE1ccGrf0FZFLSI3Tv3ZVU0NC0J4=;
        b=vJqpIFvIdjfNdH75kDprqDO+mjIG+Cm/rhjejwTGgaY2RjpgztIP8UK0BvhHG7OkJ8
         LL1BNuo+Mh+woslyPxZwzp/SlyXt8YDblImegei/Mj2BrYWHYK1xbnWbN2nIQdoemrfC
         BBgYKncMiyKbbSQLVINQu+A8MIOcL7vdeEoGw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8WE1/NXkJ1oiNDFE1ccGrf0FZFLSI3Tv3ZVU0NC0J4=;
        b=Sc3nPhelEU+Gi39PHNuoBw1nZ6D4jyyAepzqao8nU7gs21w7dHuc92jeQ8HmZqUcMt
         jR8kF+0ctsGkuNA8LYv5H/MHy9KIwJLmGcr457UKuZJlbn7ARDyJmUxzA83xgz/aLXVP
         GovNalBAOuEaTjpJxnb7CskbotydGBzIXU+SMvtvY1OO/JVsgK0SM4IJcievXeTKXaYm
         +1PrmzGXkNhKw06WMuk6/sEnt5U0cBi6aZ2sbmRV/OOytQ+0Is9pQAwLUiGy0oakiT5i
         lILHQ3dHYUOktWL8Z6QmwcfNHlPcAMPmCfbuTmOgFdETrrQnjv4jg2fK7D8WS/L+iPmZ
         v5iA==
X-Gm-Message-State: AGi0PubBK42UYKvyrkO3+nlfV9LOc89Jv23NCZaes7gqaYA8hY50sNCX
        XZf85/ICdIsVZV5reVFiSW4p/aLscN8=
X-Google-Smtp-Source: APiQypKyb9NWd4RZpo2w2igJyW92k4+REaa3lSb9rWnhn87GO0MIVFLKHyKnYE7lyQm8fFxMBLhk9g==
X-Received: by 2002:a1c:7d15:: with SMTP id y21mr4183443wmc.57.1588769733770;
        Wed, 06 May 2020 05:55:33 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j17sm3025622wrb.46.2020.05.06.05.55.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:33 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 12/17] udp6: Run SK_LOOKUP BPF program on socket lookup
Date:   Wed,  6 May 2020 14:55:08 +0200
Message-Id: <20200506125514.1020829-13-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
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

