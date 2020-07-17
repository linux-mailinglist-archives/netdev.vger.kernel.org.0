Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F72223966
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGQKfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726411AbgGQKfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:48 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45D8C08C5CE
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:47 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id j21so5755158lfe.6
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=18VU2vJv/3s6e5bZJvuk8ovpWWMChVGAJ0Wz7vvbo78=;
        b=PaV1S+aEzZW65mOIPn8LVsH9fisa7Iaa2GDct/ADO+RwuYwi2K9r+mChB1E/uRsQfy
         3gsr+Z0b8p9W6aA46Zy6MOHL5FNgq3kx0KVOmp0cLYtuJ+iiOLATPBQM6iwc2EVgQAd6
         wD13xGIpSwCFHh1y5yuZx1lDDbAXigKQDXhPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=18VU2vJv/3s6e5bZJvuk8ovpWWMChVGAJ0Wz7vvbo78=;
        b=EemFa81LlG4oNQtNJSpwPu7sTUs0ErmqRqIYICjnEOhhkzLTKhqfRLgV8Y3vEYxYVF
         B8BU8VGj5dDA6vVX8p6xvbvQkE+z+qy92OcJsMftH2B0UmGi0XJF2C88RcMEA3Vxr1Hu
         y+gcDsE6F/eQveL2wa7n0cQbUY0xqIMqrPSvZKIZt69mdcB4XFZ1yNTU45346GOS8gwo
         p0PQlnLQSHEzyiTFzsy67nON0MsRAV98Zwuw9oNNIjdO2w73bV2NnDpPFyhlHu9R4UH/
         UiFx7cvrf/MGw7LqIQ8L0osLARP9LGyft/Q08Cr3hho39x3HpVJjGMzMxjEgmGNa5AMY
         3VaQ==
X-Gm-Message-State: AOAM532kdM7p9vj+j0C9KVVdEXkN8Uf3LVV6NGf2bW5Hpw2+s2YhbH20
        hpXkKcyD1hPSnsigKKh/q1DXKfoA3RItAA==
X-Google-Smtp-Source: ABdhPJwUcehWR3vMc6WkUGmPdtprioX5XYxycYGWosDRxc17ZavysWefT6ckNt1pHUsKYLHJ0MueWQ==
X-Received: by 2002:a05:6512:10ca:: with SMTP id k10mr4429600lfg.177.1594982146182;
        Fri, 17 Jul 2020 03:35:46 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h189sm1783870lfd.47.2020.07.17.03.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:45 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v5 05/15] inet6: Extract helper for selecting socket from reuseport group
Date:   Fri, 17 Jul 2020 12:35:26 +0200
Message-Id: <20200717103536.397595-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for calling into reuseport from inet6_lookup_listener as well.

Acked-by: Andrii Nakryiko <andriin@fb.com>
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

