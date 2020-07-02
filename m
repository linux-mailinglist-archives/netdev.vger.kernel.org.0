Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3C9211FC3
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgGBJYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728237AbgGBJYc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:32 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DEC7C08C5DD
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:32 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id p20so28415881ejd.13
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dWS55m6tjKFIXvF8FfZLoHa8RJokM3hk5iam/MiuzJ0=;
        b=Q8umSu7cmwPd6jEFw6ZnIhcJ38auitt9WijRWXZrfF+h09UuIrUzgyz1xuxryDNMMB
         hAKBz2izLJXjWVUovgM9BGZyA8lgivW3cGC5Xi8jdYlWUxiBsAHPA6a9BeC/qV33Lvtx
         rofm9imkTA5L47Q6T1NQxiL17Fs0fszeA074g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dWS55m6tjKFIXvF8FfZLoHa8RJokM3hk5iam/MiuzJ0=;
        b=mWrZ26KWbqMIU13XPVbN8pSdCtbi5JKOVYEyIwJlkYE4xFT66sMXtbAq4WFoVusKnm
         6QIaxCtnd2igyI9hJCCWI9pObFmxk5TfNdPsgGp9DbP6gtbeTQT2ppgR01MToeqzzhUV
         k7YwXLLPBKCxSG2iAwyfSjClDNDDBOFsnXTCDrT390mFQ78vSi7HylN/XwGKabwPpLI+
         43w6OREr2XZtMQWi1kiX46QywG78z6PMLrHnBF7TBSA9Mg7JWBTQcdYzd6B513QPqyiY
         8F4jNOnE0qYHiQ9h71Phi1B4U78O5G4GknBHF4nAOv6h+isBjqUZfk+vdG80dFTH5zLn
         bnPw==
X-Gm-Message-State: AOAM530/ADAOKvYbgOcs9T1AF//RZLRDGmkto/JQKg3VlPa8Z9YLRCV1
        WFhOReW1n8LICsIqeW9eUjfOu9h28GGz7g==
X-Google-Smtp-Source: ABdhPJyiglgLFJjLuWkYzTFXXoiRW5v70w8qmarTgG7PsUsuJky7UxZWkebxgbLepMrbI1nDE+nwNA==
X-Received: by 2002:a17:906:dbcf:: with SMTP id yc15mr17411999ejb.222.1593681870819;
        Thu, 02 Jul 2020 02:24:30 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a2sm5947246edt.48.2020.07.02.02.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:30 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 07/16] udp: Extract helper for selecting socket from reuseport group
Date:   Thu,  2 Jul 2020 11:24:07 +0200
Message-Id: <20200702092416.11961-8-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for calling into reuseport from __udp4_lib_lookup as well.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 net/ipv4/udp.c | 34 ++++++++++++++++++++++++----------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 31530129f137..0d03e0277263 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -408,6 +408,25 @@ static u32 udp_ehashfn(const struct net *net, const __be32 laddr,
 			      udp_ehash_secret + net_hash_mix(net));
 }
 
+static inline struct sock *lookup_reuseport(struct net *net, struct sock *sk,
+					    struct sk_buff *skb,
+					    __be32 saddr, __be16 sport,
+					    __be32 daddr, unsigned short hnum)
+{
+	struct sock *reuse_sk = NULL;
+	u32 hash;
+
+	if (sk->sk_reuseport && sk->sk_state != TCP_ESTABLISHED) {
+		hash = udp_ehashfn(net, daddr, hnum, saddr, sport);
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
 static struct sock *udp4_lib_lookup2(struct net *net,
 				     __be32 saddr, __be16 sport,
@@ -418,7 +437,6 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 {
 	struct sock *sk, *result;
 	int score, badness;
-	u32 hash = 0;
 
 	result = NULL;
 	badness = 0;
@@ -426,15 +444,11 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 		score = compute_score(sk, net, saddr, sport,
 				      daddr, hnum, dif, sdif);
 		if (score > badness) {
-			if (sk->sk_reuseport &&
-			    sk->sk_state != TCP_ESTABLISHED) {
-				hash = udp_ehashfn(net, daddr, hnum,
-						   saddr, sport);
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
 			badness = score;
 			result = sk;
 		}
-- 
2.25.4

