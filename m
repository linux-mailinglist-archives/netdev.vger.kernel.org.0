Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7284223963
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgGQKfs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726322AbgGQKfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:44 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFD1C08C5CE
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:44 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id e8so12071641ljb.0
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dH6rtV/lmGIlcwWhCwUK9MNUhNnz7g2tna/YmaB32Ks=;
        b=Utf6LlJhKyUd9h3DrRs6mXI0sUkQzJcct+ZgvttLqOI+DcWFaqbmlzTyFymTz05a/B
         EXnSX61fVvG2maSoFpLNIKJRuZF5roR+zcYVSzBG5GTYgvGfhvUiD1wXI9R2mSSHcRFx
         g45aVSTfU7DQyp1ZDos03s71RmQPBj8cxeKIs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dH6rtV/lmGIlcwWhCwUK9MNUhNnz7g2tna/YmaB32Ks=;
        b=WjMUSLP9U2MBXbJCnbeirTxv3+EywTvSxSLdglG8c8CTIgJOFxhbpq9XL1Wte9L8AE
         x6jn1B/IanJqIxunMThAbLzLLYV2Vk02IM6ivbmQLX+a7nhS6rssWtCa+PId2VSBskI7
         9AEVbkghTlKtarVN5pObd6XbU+ik7wxxNw2id5qTdOKgcXOonxYEOikUKZoZn2exRobk
         Q6e1n47kP3B5szyu0D9SI8EWR/aeOnvKjen6/X4sQwu9M3Qtz0cyOybgif44cVuW6L8u
         AT36HkXFtVVYz9N4e7DIZJ+qcgMVPHXV9E3MuWLZoDzBtgUyZ+DARgNS0yWbKXdbyrrf
         /xbw==
X-Gm-Message-State: AOAM530MBqSoG9TlcXGC8nmUURGBFaIK4LLbev0luIHpWbNbE9S8WqBi
        dLZHfTpJrLs0moFRtwKA9g1iNg==
X-Google-Smtp-Source: ABdhPJwUOhwRl+xh41oP5bQwi5PddfSaQo8ItdcquBvS3MpX5TOsZwgj8RFWCeaiQl6Zd+OkXYzIUg==
X-Received: by 2002:a2e:8992:: with SMTP id c18mr4040958lji.388.1594982142965;
        Fri, 17 Jul 2020 03:35:42 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a16sm1873590ljj.108.2020.07.17.03.35.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:42 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v5 03/15] inet: Extract helper for selecting socket from reuseport group
Date:   Fri, 17 Jul 2020 12:35:24 +0200
Message-Id: <20200717103536.397595-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for calling into reuseport from __inet_lookup_listener as well.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/inet_hashtables.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2bbaaf0c7176..ab64834837c8 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -246,6 +246,21 @@ static inline int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
+					    struct sk_buff *skb, int doff,
+					    __be32 saddr, __be16 sport,
+					    __be32 daddr, unsigned short hnum)
+{
+	struct sock *reuse_sk = NULL;
+	u32 phash;
+
+	if (sk->sk_reuseport) {
+		phash = inet_ehashfn(net, daddr, hnum, saddr, sport);
+		reuse_sk = reuseport_select_sock(sk, phash, skb, doff);
+	}
+	return reuse_sk;
+}
+
 /*
  * Here are some nice properties to exploit here. The BSD API
  * does not allow a listening sock to specify the remote port nor the
@@ -265,21 +280,17 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 	struct inet_connection_sock *icsk;
 	struct sock *sk, *result = NULL;
 	int score, hiscore = 0;
-	u32 phash = 0;
 
 	inet_lhash2_for_each_icsk_rcu(icsk, &ilb2->head) {
 		sk = (struct sock *)icsk;
 		score = compute_score(sk, net, hnum, daddr,
 				      dif, sdif, exact_dif);
 		if (score > hiscore) {
-			if (sk->sk_reuseport) {
-				phash = inet_ehashfn(net, daddr, hnum,
-						     saddr, sport);
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

