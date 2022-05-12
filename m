Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F7F525314
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 18:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356832AbiELQ4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 12:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356764AbiELQ4J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 12:56:09 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272762BCE
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:56:07 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q18so5447436pln.12
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 09:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WBgcATWUNDcFr4pm0D/otzLtgH6+iEUvIQJx2JEg2IE=;
        b=QOSEMzCvxoEU8VUSppZAhjBwbW6TXx+3umPqVbr5plmJwozfbXCUHV1fwp06WuJybv
         dADNaJu7Ujr4uYm9cpDdsDGAGju6ruoB6FxXg9kUkJtd5D5TTylxCiimabyI7YFCtEMX
         2DdIWnYWFkfIiHNUIPDXNtJx/gt0XD0B25hZLSAC30DL6RVDasPTYEPKZFlMDVPUmDYw
         vEPZaTWwrw3a/Yzg5LPgLobeIKai3W3rTHb9kv141zMZqb9nhKX8X42N+T5m2gjrPSlL
         2jKWyO6sgsBRDL7n24k/GCkO+xbF4BNCYvWm8A2YPnayenoCPf+WyjRPMCugSvvyIizf
         90KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WBgcATWUNDcFr4pm0D/otzLtgH6+iEUvIQJx2JEg2IE=;
        b=zRLjh3uJXavx4GAgVo6DNvXZ4Wzuq1ZGCWg031Dh3qjwQCopOyUQnyJlEr5QrJ9rj4
         A6MnF3ZDhIkBtSx7Ih11zPoqbNiG5m8s0bO7EOlzNevau2WcJK1KVH42Qf5zkgeitvHd
         6axiI70U2KqcIeuyeb5711EVXVQu0AhUZ7RaVRNcWsSV8zXxIkBsd4nmM0/mvzcbx5f0
         lq5PFokWOG7LychHBkQlcRsR8jwWmbnpqVguZsaglSs2A4SURmj2Ay9DDH0W3/iTjWr0
         YU0/hTnWDkI/d8b+yM3LJYIHhaEG8f03ETn6yf1f5KghhQL2/5b6I+muvBs3FVzCHi4+
         GWPQ==
X-Gm-Message-State: AOAM531k82fZgfAizwWi08r05UWDxAnqrt/QyxlrtRTj4ZJhulcYmWef
        AFOCzGeI/eYnQOMuhzBjd+Y=
X-Google-Smtp-Source: ABdhPJzw0gvtcnDRmAa3u+JyepUvJpdf9w23xlHge6Gb9RXVc/tocToOtS85NMWUIVuS7dznhZTL8A==
X-Received: by 2002:a17:903:41c9:b0:15e:ae15:294f with SMTP id u9-20020a17090341c900b0015eae15294fmr820843ple.44.1652374566607;
        Thu, 12 May 2022 09:56:06 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c0b4:779e:76dd:6916])
        by smtp.gmail.com with ESMTPSA id f125-20020a62db83000000b0050dc762812csm91362pfg.6.2022.05.12.09.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 09:56:05 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net-next] inet: add READ_ONCE(sk->sk_bound_dev_if) in INET_MATCH()
Date:   Thu, 12 May 2022 09:56:01 -0700
Message-Id: <20220512165601.2326659-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
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

INET_MATCH() runs without holding a lock on the socket.

We probably need to annotate most reads.

This patch makes INET_MATCH() an inline function
to ease our changes.

v2:

We remove the 32bit version of it, as modern compilers
should generate the same code really, no need to
try to be smarter.

Also make 'struct net *net' the first argument.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---

Sent as a standalone patch to not spam netdev@ list.

 include/net/inet_hashtables.h | 33 +++++++++++++++------------------
 include/net/sock.h            |  3 ---
 net/ipv4/inet_hashtables.c    | 15 +++++----------
 net/ipv4/udp.c                |  3 +--
 4 files changed, 21 insertions(+), 33 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 98e1ec1a14f0382d1f4f8e85fe5ac2a056d2d6bc..e44e410813d0f469131f54cf3372458a0340d5cf 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -295,7 +295,6 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 	((__force __portpair)(((__u32)(__dport) << 16) | (__force __u32)(__be16)(__sport)))
 #endif
 
-#if (BITS_PER_LONG == 64)
 #ifdef __BIG_ENDIAN
 #define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
 	const __addrpair __name = (__force __addrpair) ( \
@@ -307,24 +306,22 @@ static inline struct sock *inet_lookup_listener(struct net *net,
 				   (((__force __u64)(__be32)(__daddr)) << 32) | \
 				   ((__force __u64)(__be32)(__saddr)))
 #endif /* __BIG_ENDIAN */
-#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))			&&	\
-	 ((__sk)->sk_addrpair == (__cookie))			&&	\
-	 (((__sk)->sk_bound_dev_if == (__dif))			||	\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))		&&	\
-	 net_eq(sock_net(__sk), (__net)))
-#else /* 32-bit arch */
-#define INET_ADDR_COOKIE(__name, __saddr, __daddr) \
-	const int __name __deprecated __attribute__((unused))
 
-#define INET_MATCH(__sk, __net, __cookie, __saddr, __daddr, __ports, __dif, __sdif) \
-	(((__sk)->sk_portpair == (__ports))		&&		\
-	 ((__sk)->sk_daddr	== (__saddr))		&&		\
-	 ((__sk)->sk_rcv_saddr	== (__daddr))		&&		\
-	 (((__sk)->sk_bound_dev_if == (__dif))		||		\
-	  ((__sk)->sk_bound_dev_if == (__sdif)))	&&		\
-	 net_eq(sock_net(__sk), (__net)))
-#endif /* 64-bit arch */
+static inline bool INET_MATCH(struct net *net, const struct sock *sk,
+			      const __addrpair cookie, const __portpair ports,
+			      int dif, int sdif)
+{
+	int bound_dev_if;
+
+	if (!net_eq(sock_net(sk), net) ||
+	    sk->sk_portpair != ports ||
+	    sk->sk_addrpair != cookie)
+	        return false;
+
+	/* Paired with WRITE_ONCE() from sock_bindtoindex_locked() */
+	bound_dev_if = READ_ONCE(sk->sk_bound_dev_if);
+	return bound_dev_if == dif || bound_dev_if == sdif;
+}
 
 /* Sockets in TCP_CLOSE state are _always_ taken out of the hash, so we need
  * not check it for lookups anymore, thanks Alexey. -DaveM
diff --git a/include/net/sock.h b/include/net/sock.h
index 73063c88a2499b31c1e8d25dc157d21f93b02bf5..01edfde4257d697f2a2c88ef704a3849af4e5305 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -161,9 +161,6 @@ typedef __u64 __bitwise __addrpair;
  *	for struct sock and struct inet_timewait_sock.
  */
 struct sock_common {
-	/* skc_daddr and skc_rcv_saddr must be grouped on a 8 bytes aligned
-	 * address on 64bit arches : cf INET_MATCH()
-	 */
 	union {
 		__addrpair	skc_addrpair;
 		struct {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index a5d57fa679caa47ec31ea4b1de3c45f93be4cd13..16a8440083f7e4bebd5de51ddb41b3d886b233cd 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -410,13 +410,11 @@ struct sock *__inet_lookup_established(struct net *net,
 	sk_nulls_for_each_rcu(sk, node, &head->chain) {
 		if (sk->sk_hash != hash)
 			continue;
-		if (likely(INET_MATCH(sk, net, acookie,
-				      saddr, daddr, ports, dif, sdif))) {
+		if (likely(INET_MATCH(net, sk, acookie, ports, dif, sdif))) {
 			if (unlikely(!refcount_inc_not_zero(&sk->sk_refcnt)))
 				goto out;
-			if (unlikely(!INET_MATCH(sk, net, acookie,
-						 saddr, daddr, ports,
-						 dif, sdif))) {
+			if (unlikely(!INET_MATCH(net, sk, acookie,
+						 ports, dif, sdif))) {
 				sock_gen_put(sk);
 				goto begin;
 			}
@@ -465,8 +463,7 @@ static int __inet_check_established(struct inet_timewait_death_row *death_row,
 		if (sk2->sk_hash != hash)
 			continue;
 
-		if (likely(INET_MATCH(sk2, net, acookie,
-					 saddr, daddr, ports, dif, sdif))) {
+		if (likely(INET_MATCH(net, sk2, acookie, ports, dif, sdif))) {
 			if (sk2->sk_state == TCP_TIME_WAIT) {
 				tw = inet_twsk(sk2);
 				if (twsk_unique(sk, sk2, twp))
@@ -532,9 +529,7 @@ static bool inet_ehash_lookup_by_sk(struct sock *sk,
 		if (esk->sk_hash != sk->sk_hash)
 			continue;
 		if (sk->sk_family == AF_INET) {
-			if (unlikely(INET_MATCH(esk, net, acookie,
-						sk->sk_daddr,
-						sk->sk_rcv_saddr,
+			if (unlikely(INET_MATCH(net, esk, acookie,
 						ports, dif, sdif))) {
 				return true;
 			}
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 9d5071c79c9599aa973b80869b7768a68a508cc2..53342ce17172722d51a5db34ca9f1d5c61fb82de 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -2563,8 +2563,7 @@ static struct sock *__udp4_lib_demux_lookup(struct net *net,
 	struct sock *sk;
 
 	udp_portaddr_for_each_entry_rcu(sk, &hslot2->head) {
-		if (INET_MATCH(sk, net, acookie, rmt_addr,
-			       loc_addr, ports, dif, sdif))
+		if (INET_MATCH(net, sk, acookie, ports, dif, sdif))
 			return sk;
 		/* Only check first socket in chain */
 		break;
-- 
2.36.0.550.gb090851708-goog

