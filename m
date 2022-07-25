Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 048505803DE
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 20:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbiGYSPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 14:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiGYSPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 14:15:10 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 491C91FD
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:15:08 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id h8so17133787wrw.1
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 11:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Rkt8JOCzPF0ge9G4WeGOvtFXTIy575ZTWQM2pTtGuE=;
        b=BUoEkEulN1yMZqxstsRwZ3oxJlBOg792vfBQjm7njTBw1sU+RN75cw5HfvDz1UDp/u
         sIZuQI9o+Fb3HlBcH3GUc6QSBx65/7nQSKqeMvZFtZEqA8WbKWsNblzchmprR3U15ufG
         TR3GUn70FJP2AWqjn71QCpvyhNOWtElDGDonSK+EUqudtNcp92z3JxoGI84zAxyzK/hr
         uj6QHc3ELSTafoH0bMKoE+ph+NCa6bftKbgUDP2ZpudM14mSz8EweB2m3PDJThMw+uIQ
         BSHC/PV+fDab8bK8fFRPsVwcepQ/jlgVqTrCqZqYty9EZoqx22QKNeEIt2ltsqlk5Ij+
         D8YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1Rkt8JOCzPF0ge9G4WeGOvtFXTIy575ZTWQM2pTtGuE=;
        b=MlXQl84Ojg6glkZbuG5YitW0iPAsKQcu6h3viU4erttpzSD70rhVL9dsTMX02GOtz6
         fKlC4jumqGl3ARZehbKri98fBBh4j72mbQdkni3yQqFO80NsqWNRu8MbsBtt68qMSp2V
         n9vrALniEFzXi5xS9JiQNbvBLRtJktOEGZZJ8O3J+A6aV+SjxA+fBaDl67P7tI/+Yybc
         KvLuI/x2E92k1C4Nw1dRRDS8AhsZ3sm4Q1WZbwmh7MkqaeegYOpMt9FGKi8nbSO6JZDi
         pA5I7mWR9EuGTcyR3di4a09wVK/6tPiF2APahLcx/gEpNwGbywHeXBbVrTuvXyHJ9j1u
         XbeA==
X-Gm-Message-State: AJIora9/O1NDHM4xfMkPmMJGmmvXfQ7Vi2CQZ5rw3H6hzqWCSkDG7j06
        DAJtfhXq4RH2MNofEqjse8/tjZ24Udr3y1hwt1o=
X-Google-Smtp-Source: AGRyM1soOOXMO6Z0IWKlwawPIqG71Ofz3OU6UsPHJnR9/IJHOc7Kg4z4TgpkDbENDtBKhMuGGkWdmQ==
X-Received: by 2002:a05:6000:1d84:b0:20e:5fae:6e71 with SMTP id bk4-20020a0560001d8400b0020e5fae6e71mr8347956wrb.224.1658772906689;
        Mon, 25 Jul 2022 11:15:06 -0700 (PDT)
Received: from BRA-F155P12.Home ([90.215.167.125])
        by smtp.gmail.com with ESMTPSA id u7-20020a5d5147000000b0021e83cb98cbsm4934767wrt.106.2022.07.25.11.15.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jul 2022 11:15:06 -0700 (PDT)
From:   Mike Manning <mvrmanning@gmail.com>
To:     netdev@vger.kernel.org, dsahern@kernel.org, jluebbe@lasnet.de
Subject: [PATCH] net: allow unbound socket for packets in VRF when tcp_l3mdev_accept set
Date:   Mon, 25 Jul 2022 19:14:42 +0100
Message-Id: <20220725181442.18041-1-mvrmanning@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit 3c82a21f4320 ("net: allow binding socket in a VRF when
there's an unbound socket") changed the inet socket lookup to avoid
packets in a VRF from matching an unbound socket. This is to ensure the
necessary isolation between the default and other VRFs for routing and
forwarding. VRF-unaware processes running in the default VRF cannot
access another VRF and have to be run with 'ip vrf exec <vrf>'. This is
to be expected with tcp_l3mdev_accept disabled, but could be reallowed
when this sysctl option is enabled. So instead of directly checking dif
and sdif in inet[6]_match, here call inet_sk_bound_dev_eq(). This
allows a match on unbound socket for non-zero sdif i.e. for packets in
a VRF, if tcp_l3mdev_accept is enabled.

Fixes: 3c82a21f4320 ("net: allow binding socket in a VRF when there's an unbound socket")
Signed-off-by: Mike Manning <mvrmanning@gmail.com>
Link: https://lore.kernel.org/netdev/a54c149aed38fded2d3b5fdb1a6c89e36a083b74.camel@lasnet.de/
---

Nettest results for VRF testing remain unchanged:

$ diff nettest-baseline-502c6f8cedcc.txt nettest-fix.txt
$ tail -3 nettest-fix.txt
Tests passed: 869
Tests failed:   5

Disclaimer: While I do not think that there should be any noticeable
socket throughput degradation due to these changes, I am unable to
carry out any performance tests for this, nor provide any follow-up
support if there is any such degradation.

---
 include/net/inet6_hashtables.h |  7 +++----
 include/net/inet_hashtables.h  | 19 +++----------------
 include/net/inet_sock.h        | 11 +++++++++++
 3 files changed, 17 insertions(+), 20 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index f259e1ae14ba..56f1286583d3 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -110,8 +110,6 @@ static inline bool inet6_match(struct net *net, const struct sock *sk,
 			       const __portpair ports,
 			       const int dif, const int sdif)
 {
-	int bound_dev_if;
-
 	if (!net_eq(sock_net(sk), net) ||
 	    sk->sk_family != AF_INET6 ||
 	    sk->sk_portpair != ports ||
@@ -119,8 +117,9 @@ static inline bool inet6_match(struct net *net, const struct sock *sk,
 	    !ipv6_addr_equal(&sk->sk_v6_rcv_saddr, daddr))
 		return false;
 
-	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
-	return bound_dev_if == dif || bound_dev_if == sdif;
+	/* READ_ONCE() paired with WRITE_ONCE() in sock_bindtoindex_locked() */
+	return inet_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif,
+				    sdif);
 }
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index fd6b510d114b..e9cf2157ed8a 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -175,17 +175,6 @@ static inline void inet_ehash_locks_free(struct inet_hashinfo *hashinfo)
 	hashinfo->ehash_locks = NULL;
 }
 
-static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
-					int dif, int sdif)
-{
-#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
-				 bound_dev_if, dif, sdif);
-#else
-	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
-#endif
-}
-
 struct inet_bind_bucket *
 inet_bind_bucket_create(struct kmem_cache *cachep, struct net *net,
 			struct inet_bind_hashbucket *head,
@@ -271,16 +260,14 @@ static inline bool inet_match(struct net *net, const struct sock *sk,
 			      const __addrpair cookie, const __portpair ports,
 			      int dif, int sdif)
 {
-	int bound_dev_if;
-
 	if (!net_eq(sock_net(sk), net) ||
 	    sk->sk_portpair != ports ||
 	    sk->sk_addrpair != cookie)
 	        return false;
 
-	/* Paired with WRITE_ONCE() from sock_bindtoindex_locked() */
-	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
-	return bound_dev_if == dif || bound_dev_if == sdif;
+	/* READ_ONCE() paired with WRITE_ONCE() in sock_bindtoindex_locked() */
+	return inet_sk_bound_dev_eq(net, READ_ONCE(sk->sk_bound_dev_if), dif,
+				    sdif);
 }
 
 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 6395f6b9a5d2..bf5654ce711e 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -149,6 +149,17 @@ static inline bool inet_bound_dev_eq(bool l3mdev_accept, int bound_dev_if,
 	return bound_dev_if == dif || bound_dev_if == sdif;
 }
 
+static inline bool inet_sk_bound_dev_eq(struct net *net, int bound_dev_if,
+					int dif, int sdif)
+{
+#if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_tcp_l3mdev_accept),
+				 bound_dev_if, dif, sdif);
+#else
+	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
+#endif
+}
+
 struct inet_cork {
 	unsigned int		flags;
 	__be32			addr;
-- 
2.20.1

