Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2B4721DF04
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgGMRrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730043AbgGMRrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:06 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C5FC08C5DE
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:06 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so18948957lji.9
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QgMFjCP5Xlp83RyJSzaeuU80nMRVl3A4bF+6T6QGTNA=;
        b=fK+WlYQV0st4Lh29BoNg3l5x8IvT47Afy0ynaX5UT0Ty5cgrbkl7zxrGQtrGlM9Lha
         om5ZnhlOI6TRCLb9SmdhapWgKA47Blk48aTXly3nde4eThMk1/7K4t0ZJmUQaxqPx+2v
         sQy0pGDtuuEYMLMCtCjs0PhS1NzvXEPoHzDoM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QgMFjCP5Xlp83RyJSzaeuU80nMRVl3A4bF+6T6QGTNA=;
        b=W6EJZt2Gq9XChsv9QjtRuQf9AdKRZJpDUypv7AXJTyNmVpxmQnH6w2X4BpLU1Zh/zA
         PHA5G0JvLCYPtRFVizOp9DicWu+/cgj2h5z7zoLvwIXTtrF26Z2+6gWLfbcZgCPxOrOq
         OBdxYEENPRwRYo+kvhBibA8gjgo70v4TG69TA223yYFKg8jpM/v8L+YeKaw3af7r+hXW
         KV9sfkKOFHfS/OpxPxjooVRQAuMgg3cwdVhTPqxqKww4xbDrD5jPphwqL198FT7H9wQP
         2ntTHEWth/zHSaJihW2Gs+G5JPqfBapc/i9A4svGlgySOEv6Dc/v6Kl2fXv1WI+iLuJ7
         5l2A==
X-Gm-Message-State: AOAM530nvYDfhL/5Wf9sqJfJc9HAABHJQGLLM7x2QQmE/EW/iQNrd03w
        3NbPgB/jaR/J3dAz50t2bEJc3mfPqbsI3w==
X-Google-Smtp-Source: ABdhPJxR+0STxQ8suGDJqdTomUPYy155szqwQxy2Qj3XQA7yCHOqUdXVDdFUKEru44pwFZzseB07gg==
X-Received: by 2002:a05:651c:120d:: with SMTP id i13mr367008lja.153.1594662425025;
        Mon, 13 Jul 2020 10:47:05 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id g24sm4149166ljl.139.2020.07.13.10.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:04 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 05/16] inet6: Extract helper for selecting socket from reuseport group
Date:   Mon, 13 Jul 2020 19:46:43 +0200
Message-Id: <20200713174654.642628-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
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
2.25.4

