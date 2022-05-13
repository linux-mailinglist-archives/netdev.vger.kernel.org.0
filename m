Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2D715269A5
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383455AbiEMS4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383442AbiEMS4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:56:13 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A4156C0C9
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so8573168pjq.2
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=te+u4FfgicEd58cMsjJAmr9WZSRf/aUyr9MHF39R4zI=;
        b=qZYQ9mVAalUkB3anjAFE9hUcbXlkJUzRCuTdur0ihkUIi2V8jjq5FJlTHjGe7zwXMS
         qt0mioqrY1RWYLbUDwyi24KrkXaBXtTU+rzVWf3BLn4ZSwyz6Geinw+NZXFzxvACe2P1
         pN8soSAa1jtAYOdlrZrMXK4GdpNBT8VJ/LvbokrK0s2nE5H9/cslPizUH2Dxdp+EWBZT
         FRByB7yPXMQtgxX1gq7nkiTQQby2Ojt94wYdhYWQDTPQQibAUqshpEy2kG4By3VAnxYF
         EWRSvWV10IY33nFYRV9p2BNIDlUz0JHySlIirc0sVn+YKyIRSLIjbzNOrJEP+GpY4yaJ
         cnFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=te+u4FfgicEd58cMsjJAmr9WZSRf/aUyr9MHF39R4zI=;
        b=Cfvj92rZz9kqTANHII3P+m1PA1hSvWnz8dX+AzeCtzZKtwmOm0GjToH+Tm2IolI0Gc
         xsXbqqH2MGSVihe6llgSDeSRyYA3IduXIgiQ4AdhouvBrpzj+QjdSUbqvPRBabu0+1+5
         p/RGqp+q20qNyNo41/8LOtxmxRbcnalfwKxwJ2dRFcc6QBF2gvhIi7MZCoPb81i2qSPT
         ofHjt+Kj5+Y61yi7Eg52fq2HxxE5RS/Z3TNsh8jocJQbObzW41yaGcoueST5bWQlJZkp
         ZmAvoAPzHh43U7vFXVmqx27Q72SlFwtCatJfnPhpUBKen+RTKIkUoOvnvETyQ1ccWM7G
         vIoQ==
X-Gm-Message-State: AOAM531Wlve7EqdRD4n8Bod+Wd2IE05UEQQDwWDQVVLDHt9/We6vf4Aw
        WI7NnT4IK1me/P+ArYd8ovU=
X-Google-Smtp-Source: ABdhPJyhjAyK+JC5l22IwX2xG5pbhJ1f/8/PQn3kn64Keeq8ql0iFHXWe7rbm9MQBeFJg4WszncbEA==
X-Received: by 2002:a17:90a:7645:b0:1dd:2482:e4b3 with SMTP id s5-20020a17090a764500b001dd2482e4b3mr6216602pjl.204.1652468166752;
        Fri, 13 May 2022 11:56:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id 2-20020a170902c10200b0015e8d4eb2absm2159537pli.245.2022.05.13.11.56.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:56:06 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next 09/10] ipv6: add READ_ONCE(sk->sk_bound_dev_if) in INET6_MATCH()
Date:   Fri, 13 May 2022 11:55:49 -0700
Message-Id: <20220513185550.844558-10-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513185550.844558-1-eric.dumazet@gmail.com>
References: <20220513185550.844558-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

INET6_MATCH() runs without holding a lock on the socket.

We probably need to annotate most reads.

This patch makes INET6_MATCH() an inline function
to ease our changes.

v2: inline function only defined if IS_ENABLED(CONFIG_IPV6)
    Change the name to inet6_match(), this is no longer a macro.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/inet6_hashtables.h | 28 +++++++++++++++++++---------
 net/ipv4/inet_hashtables.c     |  2 +-
 net/ipv6/inet6_hashtables.c    |  6 +++---
 net/ipv6/udp.c                 |  2 +-
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 81b96595303680dee9c43f8c64d97b71fb4c4977..f259e1ae14ba012f9c91a406b5ca83c6876f4934 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -103,15 +103,25 @@ struct sock *inet6_lookup(struct net *net, struct inet_hashinfo *hashinfo,
 			  const int dif);
 
 int inet6_hash(struct sock *sk);
+
+static inline bool inet6_match(struct net *net, const struct sock *sk,
+			       const struct in6_addr *saddr,
+			       const struct in6_addr *daddr,
+			       const __portpair ports,
+			       const int dif, const int sdif)
+{
+	int bound_dev_if;
+
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_family != AF_INET6 ||
+	    sk->sk_portpair != ports ||
+	    !ipv6_addr_equal(&sk->sk_v6_daddr, saddr) ||
+	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
+		return false;
+
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
-#define INET6_MATCH(__sk, __net, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))			&&	\
-	 ((__sk)->sk_family == AF_INET6)			&&	\
-	 ipv6_addr_equal(&(__sk)->sk_v6_daddr, (__saddr))		&&	\
-	 ipv6_addr_equal(&(__sk)->sk_v6_rcv_saddr, (__daddr))	&&	\
-	 (((__sk)->sk_bound_dev_if == (__dif))	||			\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
-	 net_eq(sock_net(__sk), (__net)))
-
 #endif /* _INET6_HASHTABLES_H */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 5257a75756497e08b504d92e76ac604904f9c3a0..acec83ef8220025f129194dee83c3a465bf3915e 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -499,7 +499,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
 		}
 #if IS_ENABLED(CONFIG_IPV6)
 		else if (sk->sk_family == AF_INET6) {
-			if (unlikely(INET6_MATCH(esk, net,
+			if (unlikely(inet6_match(net, esk,
 						 &sk->sk_v6_daddr,
 						 &sk->sk_v6_rcv_saddr,
 						 ports, dif, sdif))) {
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index a758f2ab7b519e0aecf19ad2b6d5d3f91a9957cc..7d53d62783b1bb3f2ec4318526d06da16a7d0c28 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -71,12 +71,12 @@ struct sock *__inet6_lookup_established(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &head->chain) {
 		if (sk->sk_hash != hash)
 			continue;
-		if (!INET6_MATCH(sk, net, saddr, daddr, ports, dif, sdif))
+		if (!inet6_match(net, sk, saddr, daddr, ports, dif, sdif))
 			continue;
 		if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 			goto out;
 
-		if (unlikely(!INET6_MATCH(sk, net, saddr, daddr, ports, dif, sdif))) {
+		if (unlikely(!inet6_match(net, sk, saddr, daddr, ports, dif, sdif))) {
 			sock_gen_put(sk);
 			goto begin;
 		}
@@ -268,7 +268,7 @@ static int __inet6_check_established(struct inet_timewait_death_row *death_row,
 		if (sk2->sk_hash != hash)
 			continue;
 
-		if (likely(INET6_MATCH(sk2, net, saddr, daddr, ports,
+		if (likely(inet6_match(net, sk2, saddr, daddr, ports,
 				       dif, sdif))) {
 			if (sk2->sk_state == TCP_TIME_WAIT) {
 				tw = inet_twsk(sk2);
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 960cfea820160614f3606ce4f407b7aa89fc70e1..55afd7f39c0450ff442a0499b7f8e42bf1a613bc 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1044,7 +1044,7 @@ static struct sock *__udp6_lib_demux_lookup(struct net *net,
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
 		if (sk->sk_state == TCP_ESTABLISHED &&
-		    INET6_MATCH(sk, net, rmt_addr, loc_addr, ports, dif, sdif))
+		    inet6_match(net, sk, rmt_addr, loc_addr, ports, dif, sdif))
 			return sk;
 		/* Only check first socket in chain */
 		break;
-- 
2.36.0.550.gb090851708-goog

