Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFBF1C70FA
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728746AbgEFMzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728669AbgEFMz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:27 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3057EC03C1A8
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:26 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r26so2549988wmh.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0vCBt1D4iC0eNJSSMfqS7W0wA2E5Kan2xeXfsA3ILU=;
        b=UE4qUCpB3QcvaopioCmKxgmeQd+CF8OgSaSq2JxiPYHo0me0TBchSDid8lG8nR+wh5
         t7oYQGkBnGlvYD5Ojgty/nUWq+gN/BDyMl1myB5fto8uVvv+UmaL/z9VPsXqshxl3IHm
         lajX1G5Yb2UG6qT5D5YNBvs9HxO2mlT9mx2g8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0vCBt1D4iC0eNJSSMfqS7W0wA2E5Kan2xeXfsA3ILU=;
        b=grfyidH/O+qyz0izHIynLb3VRz0wmnWqHMgJFccuBrhyRTjnMXsfLG5iwL4dRdo4e7
         JKJWEu2/SnFEwWwMgpxsLR61kfwJFuafIrt4ofZBfOOo6Eit6J9k09TE60NoYCqUS/n0
         ZXtRYYiurz/SIXkTV2QmwYeb8pht0yAJpLfID52e1Mab7CdMJQbQhv2hzm0/aEHz7vdk
         nXok5HXLWaw3CL1Wzh8oyoyHcQ54+E8MXjJK6vhGnR5LTQILDU+qqrBwzEQFNVhml53h
         WE2NFKoPkVoKrGgxgqHmxOs4ESrdyOoXj+DbQWbASsJkoOan6pIQcAojw5A/EC0wnrgX
         e8Ig==
X-Gm-Message-State: AGi0PuYlm7VnA0kKSKa5pOW2aLmLnodJEnizSZ/2bVjqTuacrLTVLIg9
        7+Eu1xIqGWe6Oy6YJn7Gf4ogl7ezAuY=
X-Google-Smtp-Source: APiQypJDwc2PBaZsoVwHVgKBeAQsDkD0eARL6AjcO2Hnwdbdy3qYGpRiLcApYAx6KNl55w/0Aq8SgQ==
X-Received: by 2002:a05:600c:224a:: with SMTP id a10mr4609483wmm.174.1588769724590;
        Wed, 06 May 2020 05:55:24 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id 19sm2818849wmo.3.2020.05.06.05.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:24 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 06/17] inet6: Extract helper for selecting socket from reuseport group
Date:   Wed,  6 May 2020 14:55:02 +0200
Message-Id: <20200506125514.1020829-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for calling into reuseport from inet6_lookup_listener as well.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv6/inet6_hashtables.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index fbe9d4295eac..03942eef8ab6 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -111,6 +111,23 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
+					    struct sk_buff *skb, int doff,
+					    const struct in6_addr *saddr,
+					    __be16 sport,
+					    const struct in6_addr *daddr,
+					    unsigned short hnum)
+{
+	struct sock *reuse_sk = NULL;
+	u32 phash;
+
+	if (sk->sk_reuseport) {
+		phash = inet6_ehashfn(net, daddr, hnum, saddr, sport);
+		reuse_sk = reuseport_select_sock(sk, phash, skb, doff);
+	}
+	return reuse_sk;
+}
+
 /* called with rcu_read_lock() */
 static struct sock *inet6_lhash2_lookup(struct net *net,
 		struct inet_listen_hashbucket *ilb2,
@@ -123,21 +140,17 @@ static struct sock *inet6_lhash2_lookup(struct net *net,
 	struct inet_connection_sock *icsk;
 	struct sock *sk, *result = NULL;
 	int score, hiscore = 0;
-	u32 phash = 0;
 
 	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
 		sk = (struct sock *)icsk;
 		score = compute_score(sk, net, hnum, daddr, dif, sdif,
 				      exact_dif);
 		if (score > hiscore) {
-			if (sk->sk_reuseport) {
-				phash = inet6_ehashfn(net, daddr, hnum,
-						      saddr, sport);
-				result = reuseport_select_sock(sk, phash,
-							       skb, doff);
-				if (result)
-					return result;
-			}
+			result = lookup_reuseport(net, sk, skb, doff,
+						  saddr, sport, daddr, hnum);
+			if (result)
+				return result;
+
 			result = sk;
 			hiscore = score;
 		}
-- 
2.25.3

