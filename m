Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C311CE33E
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 20:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731212AbgEKSxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 14:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731214AbgEKSwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 14:52:31 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA52C05BD09
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:31 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id m12so14247313wmc.0
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 11:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0vCBt1D4iC0eNJSSMfqS7W0wA2E5Kan2xeXfsA3ILU=;
        b=vGtK6+5IMQq2lXuqJCle4VpwFMNrCzuQ45bkU70sjzrX0aB/IzvNSrCP/uyR0uEDH4
         J++9ehUEcJy1GI6K4InFE9cWncot0Gmu9gs81y6G98x5NkCnN6Yw1PcL/9tofskOFj5k
         k0JdFguYx9bWxDmHE9oUwr4bzh1R3moJ0A6Bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0vCBt1D4iC0eNJSSMfqS7W0wA2E5Kan2xeXfsA3ILU=;
        b=atB2ZQigzGOvASxr2QHWYKB6ENcjmecmOOZzyx+QXjdxgv9m+iu4mneHMhrNbuWz8+
         IsWkoBNO81hOdMtpXnVohg1wqB6dT2K3J0LeMm2Py2bu75zQUewLBJuKdds/VBobRIEz
         Z7e+o8YX7tzUdgcBsQnVURyZtQJ4bWfLjFm/qrfJ0uACPi+uM3HiTZPzRqVLuPmOmksl
         u+KLgOAhEvZs/FKGNbucLcyGorhaMwFRf4pugIkHlTiyMZvFOwOco1ZhBKUDlM5P/nSn
         Mxh3DNwIGgvQF9bzOkEHNuli0bhK7/r9wIt2KPuP1drCQk8fE3zvHPD3D/v6Vwu8mNDG
         swnw==
X-Gm-Message-State: AGi0PuaR2FB039/Vauvd6RzbM16/sj95/FI80TpgLvJDnzrK4150xNTa
        QBm5JMO8wvJyHpxg4d4ffp7Z7KEG0dE=
X-Google-Smtp-Source: APiQypKw+cunp3PJFKZ9BE3HaSOt/lJ2FAuAJGIRZ2whrxILB22+1PKRkJk8LWco5pqyuzI75b1iEA==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr18978565wmb.65.1589223150101;
        Mon, 11 May 2020 11:52:30 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id b2sm15346343wrm.30.2020.05.11.11.52.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2020 11:52:29 -0700 (PDT)
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
        Martin KaFai Lau <kafai@fb.com>
Subject: [PATCH bpf-next v2 06/17] inet6: Extract helper for selecting socket from reuseport group
Date:   Mon, 11 May 2020 20:52:07 +0200
Message-Id: <20200511185218.1422406-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200511185218.1422406-1-jakub@cloudflare.com>
References: <20200511185218.1422406-1-jakub@cloudflare.com>
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

