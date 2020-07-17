Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D9B22397B
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 12:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgGQKgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 06:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGQKfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 06:35:55 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 268D5C08C5DE
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:54 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id r19so11956210ljn.12
        for <netdev@vger.kernel.org>; Fri, 17 Jul 2020 03:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eschEy53g/sALZZ57s8UKjarobS3HOdi5PTUrjQnJfg=;
        b=tW0U2y/HC9CMfXLuQIbhwms6hbzo+1g9TtKf0+IPSeujofEx7+9hbj4bg8eW3i8GZb
         aSP20/w+dQiLEupJkWGfVPR05A1Efgycbjq7yeRXXyuUlML4gPFj3DyiKOhcoiPv+tUZ
         z0TNd+flH2p+VVuJj4sll/QCPzEHKTFz6sku4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eschEy53g/sALZZ57s8UKjarobS3HOdi5PTUrjQnJfg=;
        b=bawvwJdImFMD6keH3Bb0aVbn4FRAp84XbqIYMY4RHv9n5NcH7FcSfLH6y1L/Fykg/l
         1+2ZGIT0Aoog+fQ8G0uZcSySncS1qucnHnfOcbNs8YTbDRl8drZtKX6LD2k8X6bjn1JN
         YLFnJVFr2XJtpIsOOrhbLBkq6/DPFc1Zvsb6h3ZxxvIEbk7FmC9S/KI89hfe7rmXU9pm
         qKz8+Xlpju9Wc2dk2lH7NlIZLh5O/XdVSmTbRv5pLsoTgEq3wTEvGKlmtEjZBmC58VhN
         Cj965YjkgVeNd9HywDIdb8xfxbzML3KpE98t+wiyquT9/hPs0ybcO6UvSPIFpTqKRWDy
         8Auw==
X-Gm-Message-State: AOAM533+FCrQTsZMaPqxebw+FsUPaKjIfvKLda0tbaYma0Tqx0zx8Z9O
        Yo3VYFrprvQrp7cjS3qpM4idHw==
X-Google-Smtp-Source: ABdhPJxFyv1+RIznDtI7Wo3fHMt61+PZGg8RLnUlfjR59ExA+UxISQJSVoNVycG5LHhSxgR2R0lVsA==
X-Received: by 2002:a05:651c:1057:: with SMTP id x23mr3872568ljm.116.1594982152548;
        Fri, 17 Jul 2020 03:35:52 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j17sm1788180lfk.31.2020.07.17.03.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 03:35:51 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v5 09/15] udp6: Extract helper for selecting socket from reuseport group
Date:   Fri, 17 Jul 2020 12:35:30 +0200
Message-Id: <20200717103536.397595-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200717103536.397595-1-jakub@cloudflare.com>
References: <20200717103536.397595-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for calling into reuseport from __udp6_lib_lookup as well.

Acked-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv6/udp.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 38c0d9350c6b..084205c18a33 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -141,6 +141,27 @@ static int compute_score(struct sock *sk, struct net *net,
 	return score;
 }
 
+static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
+					    struct sk_buff *skb,
+					    const struct in6_addr *saddr,
+					    __be16 sport,
+					    const struct in6_addr *daddr,
+					    unsigned int hnum)
+{
+	struct sock *reuse_sk = NULL;
+	u32 hash;
+
+	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
+		hash = udp6_ehashfn(net, daddr, hnum, saddr, sport);
+		reuse_sk = reuseport_select_sock(sk, hash, skb,
+						 sizeof(struct udphdr));
+		/* Fall back to scoring if group has connections */
+		if (reuseport_has_conns(sk, false))
+			return NULL;
+	}
+	return reuse_sk;
+}
+
 /* called with rcu_read_lock() */
 static struct sock *udp6_lib_lookup2(struct net *net,
 		const struct in6_addr *saddr, __be16 sport,
@@ -150,7 +171,6 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 {
 	struct sock *sk, *result;
 	int score, badness;
-	u32 hash = 0;
 
 	result = NULL;
 	badness = -1;
@@ -158,16 +178,11 @@ static struct sock *udp6_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			if (sk->sk_reuseport &&
-			    sk->sk_state != TCP_ESTABLISHED) {
-				hash = udp6_ehashfn(net, daddr, hnum,
-						    saddr, sport);
-
-				result = reuseport_select_sock(sk, hash, skb,
-							sizeof(struct udphdr));
-				if (result && !reuseport_has_conns(sk, false))
-					return result;
-			}
+			result = lookup_reuseport(net, sk, skb,
+						  saddr, sport, daddr, hnum);
+			if (result)
+				return result;
+
 			result = sk;
 			badness = score;
 		}
-- 
2.25.4

