Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8371C7113
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbgEFMz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728733AbgEFMzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:33 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56070C03C1AC
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:32 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id x25so2486747wmc.0
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fqZSv5iRURJG8P51i+cIZ/1WA6SqrjwO2OnTuk3Zhrk=;
        b=gGayzqMnTYhOi5Dq4DF7HLW45jyR+5AnfaSpeDLXgkOPJKLLPwV/a3xscswIL2EEoV
         xBLLz9GRKnhwaQ7T8Sa9surF0SHZq7THS3ShSEXIEhXCngSNufQy+GwHxnE20Sdh17WJ
         Rr2q8c3gJ4DAM0syY6J++0HdfKOSgwIDeZVoU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fqZSv5iRURJG8P51i+cIZ/1WA6SqrjwO2OnTuk3Zhrk=;
        b=lTMzE7G4E6qXOoxMHvzE3sG+Vlv2RV2fOFC6wBTmT6d8FMpWCBfx+Qh8BRRYy4+9EE
         5ngwi+2IswH88MyQjfUWaxXHlpkMIXco661+TR/PZGp7647UzRZ4G59fuY+UG/k02A+a
         rrZHaeCRXA9WxQ6BGOCm+RTgQoWN1PYAqKonRO5TscNDfpsEHUkOqK3azx66cm2cHtPc
         WuvDOl9+bAOFApdZ2OsojFfRT3+b727vH32+W/PC8PYbVPkI5XyGJmr6clWhmVLU/bFo
         //4mA89/V3xtm6IcsLQxm8wYNET//1TsB28nl7c4zRgn8Jc1/LWbO6BaYK4mqV3Px5Jn
         IjmA==
X-Gm-Message-State: AGi0PuYS/hmX7VCMumosjwdpzNHdZB1rGOLmCorJqeJNLsPSkhm4VUnU
        vSxyoUFWJ8DZMz0M7wxO35IfXmGxA4M=
X-Google-Smtp-Source: APiQypJHmskS+fbDwY1rZn1h6p3uCoQGMzxBnKonBTVYTkdp6BR9ELW04uugvuZRis+4Bhc6iD/FwQ==
X-Received: by 2002:a7b:c390:: with SMTP id s16mr4109377wmj.14.1588769729490;
        Wed, 06 May 2020 05:55:29 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s11sm2555763wrp.79.2020.05.06.05.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:28 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next 09/17] udp: Extract helper for selecting socket from reuseport group
Date:   Wed,  6 May 2020 14:55:05 +0200
Message-Id: <20200506125514.1020829-10-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
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
index ce96b1746ddf..d4842f29294a 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -405,6 +405,25 @@ static u32 udp_ehashfn(const struct net *net, const __be32 laddr,
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
@@ -415,7 +434,6 @@ static struct sock *udp4_lib_lookup2(struct net *net,
 {
 	struct sock *sk, *result;
 	int score, badness;
-	u32 hash = 0;
 
 	result = NULL;
 	badness = 0;
@@ -423,15 +441,11 @@ static struct sock *udp4_lib_lookup2(struct net *net,
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
2.25.3

