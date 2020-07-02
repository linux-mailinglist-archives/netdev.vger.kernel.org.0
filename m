Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49888211FC1
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728239AbgGBJYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgGBJY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:29 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A33C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:28 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id a8so21679122edy.1
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QgMFjCP5Xlp83RyJSzaeuU80nMRVl3A4bF+6T6QGTNA=;
        b=avNTKtpBW9nfSSv6BV6PYCk+96uqSvnW4ssxtjeFo0Rq0VaMLopq07mS/IsPPVCDl5
         v1fImJ8E66w8G5om5czNrN/14at7CQZWMjBBCuplcFwRP/++wzpZNs+EorFyXdBUEJgi
         SOLPTwa5CE4rlxSWI9x/qv3o6dw6ilMiAk3xo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QgMFjCP5Xlp83RyJSzaeuU80nMRVl3A4bF+6T6QGTNA=;
        b=icfMcnVvIUVtcKgGILML1WzTvmgUXGQuZD+UF50+0CDljNE2B1rdGEAvgqLFiFVenK
         1EikjCU/4pIqigkgx06p9qDBuhKzhJgJKe6K4O3UMpqzZHKiS2y5Dn2/kINmP+fM+krl
         oMImAD84k1J8w2iuB6ZtWfqsnnoWWxVw+O5orn98ntlKLFAd7tLX6lgnZ1Toll6yx/mE
         PdKpSzYg/kYtoabw1iSRm9MHGyKvDNxVTkRvdo6O+ruYmVRTqbtIJNJ4J1r0bcMx3krd
         c9dFNRGmI8UaCWRz0yri7qZvX0Ih86gromcUIH9+35E7XNXXzisku3PMTTrKoAYeHwFp
         +7Jw==
X-Gm-Message-State: AOAM5330J1bMegW8Pf2F6i2PX6t+wbo3OlRHMncBpb9A1j/MhRu8xc+x
        gLrYPlOuUPm78shvJLYv0wgW9g==
X-Google-Smtp-Source: ABdhPJyb6Kxev9giEuVM2NrUpM/ntqpXcE7A86m4Q1mEj78/QmNCxnZB8abZP+hEBkvBAlsYsW7L0A==
X-Received: by 2002:a05:6402:787:: with SMTP id d7mr32715197edy.46.1593681867291;
        Thu, 02 Jul 2020 02:24:27 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j5sm9324327edk.53.2020.07.02.02.24.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:26 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 05/16] inet6: Extract helper for selecting socket from reuseport group
Date:   Thu,  2 Jul 2020 11:24:05 +0200
Message-Id: <20200702092416.11961-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
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

