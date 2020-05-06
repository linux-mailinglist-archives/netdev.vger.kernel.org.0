Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89E71C7114
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbgEFMz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728735AbgEFMzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:33 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876FFC03C1AD
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:32 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id e26so2461366wmk.5
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ojEd/q/k+ui/tdlTtnZjdQdevINffYnK0fnxcI6+4Y=;
        b=vfyKlATuf/LFI/n6xfj3iUV9lQXr43envCxsoScR5zr9VEoDVA1iJIZZZNoL+3llaV
         hFN9fdEmA0//+Vg0QfVTBf5lAVeNhbVslZlWLkCd18elqWX2jpfbzOnvgDNg6+4be44Z
         C06mHa7wv5Jl4JgbAT563WLiH2s7cazSD1FZ0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ojEd/q/k+ui/tdlTtnZjdQdevINffYnK0fnxcI6+4Y=;
        b=YrtqTy6zn5YyAJwIFpQGMw3FrISJ3ZnJCWxampZByGY+3d6VuxquOS8sdfmoD1k6uu
         4vqaFXtCS2FXptRqZLOP4obRVWyBU2SCNS8WPf7ozENbgM3qSjV3rxEi1O6ZowuiQBLd
         3IvYDLlyHklsGYGqI7cSP24HFb7ud/47Cy5FaOMRAbj7jpbnsTU1G0thxv8m1Fb3Eo+P
         +JiF8JD9klUHrbjU1XW2HYIlMcolKUdbPsLfAhuWqbP002P8wzPgOXgMVpaR2KIX7GKG
         0n5tJ+7BwYkYTtsgdmlaG9W0jXHvJ6LA6ztmUOe33pe31stlx6b8FYatGUJcITLYg4Hu
         EdIw==
X-Gm-Message-State: AGi0Puaoxa0BKsjij73PUIYfWBJ9/seN04evX77el9P9eesXXOBs2HdU
        ED7pBFkLCRqWKATn0O18rPyy1852Wf8=
X-Google-Smtp-Source: APiQypKQ0k9vgnF1KV0teavc47v8HOdpdfqrCAIvaYSx2b/xa260H72pyxQYHS+XDHrrtyU3O3iMHA==
X-Received: by 2002:a1c:bc09:: with SMTP id m9mr4058016wmf.145.1588769730890;
        Wed, 06 May 2020 05:55:30 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id v131sm3079726wmb.19.2020.05.06.05.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:30 -0700 (PDT)
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
Subject: [PATCH bpf-next 10/17] udp: Run SK_LOOKUP BPF program on socket lookup
Date:   Wed,  6 May 2020 14:55:06 +0200
Message-Id: <20200506125514.1020829-11-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following INET/TCP socket lookup changes, modify UDP socket lookup to let
BPF program select a receiving socket before searching for a socket by
destination address and port as usual.

Lookup of connected sockets that match packet 4-tuple is unaffected by this
change. BPF program runs, and potentially overrides the lookup result, only
if a 4-tuple match was not found.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/udp.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index d4842f29294a..18d8432f6551 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -460,7 +460,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 		__be16 sport, __be32 daddr, __be16 dport, int dif,
 		int sdif, struct udp_table *udptable, struct sk_buff *skb)
 {
-	struct sock *result;
+	struct sock *result, *sk, *reuse_sk;
 	unsigned short hnum = ntohs(dport);
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
@@ -469,18 +469,38 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 	slot2 = hash2 & udptable->mask;
 	hslot2 = &udptable->hash2[slot2];
 
+	/* Lookup connected or non-wildcard socket */
 	result = udp4_lib_lookup2(net, saddr, sport,
 				  daddr, hnum, dif, sdif,
 				  hslot2, skb);
-	if (!result) {
-		hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum);
-		slot2 = hash2 & udptable->mask;
-		hslot2 = &udptable->hash2[slot2];
+	if (!IS_ERR_OR_NULL(result) && result->sk_state == TCP_ESTABLISHED)
+		goto done;
 
-		result = udp4_lib_lookup2(net, saddr, sport,
-					  htonl(INADDR_ANY), hnum, dif, sdif,
-					  hslot2, skb);
+	/* Lookup redirect from BPF */
+	sk = inet_lookup_run_bpf(net, udptable->protocol,
+				 saddr, sport, daddr, hnum);
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
+	hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum);
+	slot2 = hash2 & udptable->mask;
+	hslot2 = &udptable->hash2[slot2];
+
+	result = udp4_lib_lookup2(net, saddr, sport,
+				  htonl(INADDR_ANY), hnum, dif, sdif,
+				  hslot2, skb);
+done:
 	if (IS_ERR(result))
 		return NULL;
 	return result;
-- 
2.25.3

