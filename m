Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE9ED4A15B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729109AbfFRNBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:01:02 -0400
Received: from mail-lf1-f42.google.com ([209.85.167.42]:40691 "EHLO
        mail-lf1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfFRNA6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:00:58 -0400
Received: by mail-lf1-f42.google.com with SMTP id a9so9200722lff.7
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4zoEiLkDtwzjc6U3bVRixKs7Xrtw9gWwjosERuQdxp4=;
        b=FZMVB+N7Max3SAwanpu63K5nFenTnx1McVo6ElyOngU1hMMrp7KC8AfaxYYutHfFnd
         r7FUvvSrTCwYWkHr/JSiELapAR2EfObP/T595Kd2MOAqvZDuA3oxu6Cty+79KgP7+SQ8
         PbVdNbSxRXFl6zrqplTjpRvvQ3+G/dMcU7Qko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4zoEiLkDtwzjc6U3bVRixKs7Xrtw9gWwjosERuQdxp4=;
        b=B/ez06gJdbSX33TAYN+Yzp6aJBINuo0tV2qpIZ5HvKLGg+pztv4ia/JGRw0RQ0Uc+N
         sGVqHpLxZrnvwZPssG6yjiJlX0LEkCHZvN7YZJON0YCXubheQa1Wc4ib01M5evK+H86O
         /rHJlQkkwgjU6Y+jqeAi1+QiVcvOj6t8dDEIs0Trx4/KY0j8McuLeLTf3b+awAOsC+YZ
         T24Y8bwJUSENXGCdnoOHSPV0n5tvl+p5Xq7UmMFWpQn/nBcmMOzbjCFAQY76B5KwRFUs
         jV76B5sFMQhr5YFU/JGcvX5hL7SVwxqLJGKARTUXjKW0YUKpeKBD/sQ7lCGYynb23rzU
         rJfw==
X-Gm-Message-State: APjAAAVOuMJMZbOwp6n+NH+H5LgM71d0Mi6767Ed/fTGMkw6+naFb51j
        fwuTegXZvFxQnWrmjGeKJpIQEwmWxefbKw==
X-Google-Smtp-Source: APXvYqzycrMY0WSW1MH9BJbaSC4Hd3wrO9+DdIR8U9LAxvbH5szAGn4JF5ZI6Uv0Uujupz8yqVAhxw==
X-Received: by 2002:a19:c14f:: with SMTP id r76mr11057872lff.70.1560862855937;
        Tue, 18 Jun 2019 06:00:55 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id o74sm2193843lff.46.2019.06.18.06.00.55
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:55 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Subject: [RFC bpf-next 3/7] ipv6: Run inet_lookup bpf program on socket lookup
Date:   Tue, 18 Jun 2019 15:00:46 +0200
Message-Id: <20190618130050.8344-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following the ipv4 changes, run a BPF program attached to netns in context
of which we're doing the socket lookup so that it can rewrite the
destination IP and port we use as keys for the lookup.

The program is called before the listening socket lookup for TCP, and
before connected or not-connected socket lookup for UDP.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet6_hashtables.h | 39 ++++++++++++++++++++++++++++++++++
 net/ipv6/inet6_hashtables.c    | 11 ++++++----
 net/ipv6/udp.c                 |  6 ++++--
 3 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/include/net/inet6_hashtables.h b/include/net/inet6_hashtables.h
index 9db98af46985..ab06961d33a9 100644
--- a/include/net/inet6_hashtables.h
+++ b/include/net/inet6_hashtables.h
@@ -108,6 +108,45 @@ struct sock *inet6_lookup(struct net *net, struct inet_hashinfo *hashinfo,
 			  const int dif);
 
 int inet6_hash(struct sock *sk);
+
+#ifdef CONFIG_BPF_SYSCALL
+static inline void inet6_lookup_run_bpf(struct net *net,
+					const struct in6_addr *saddr,
+					const __be16 sport,
+					struct in6_addr *daddr,
+					unsigned short *hnum)
+{
+	struct bpf_inet_lookup_kern ctx = {
+		.family	= AF_INET6,
+		.saddr6	= *saddr,
+		.sport	= sport,
+		.daddr6	= *daddr,
+		.hnum	= *hnum,
+	};
+	struct bpf_prog *prog;
+	int ret = BPF_OK;
+
+	rcu_read_lock();
+	prog = rcu_dereference(net->inet_lookup_prog);
+	if (prog)
+		ret = BPF_PROG_RUN(prog, &ctx);
+	rcu_read_unlock();
+
+	if (ret == BPF_REDIRECT) {
+		*daddr = ctx.daddr6;
+		*hnum = ctx.hnum;
+	}
+}
+#else
+static inline void inet6_lookup_run_bpf(struct net *net,
+					const struct in6_addr *saddr,
+					const __be16 sport,
+					struct in6_addr *daddr,
+					unsigned short *hnum)
+{
+}
+#endif /* CONFIG_BPF_SYSCALL */
+
 #endif /* IS_ENABLED(CONFIG_IPV6) */
 
 #define INET6_MATCH(__sk, __net, __saddr, __daddr, __ports, __dif, __sdif) \
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index f3515ebe9b3a..280a9b8bf914 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -158,24 +158,27 @@ struct sock *inet6_lookup_listener(struct net *net,
 		const unsigned short hnum, const int dif, const int sdif)
 {
 	struct inet_listen_hashbucket *ilb2;
+	struct in6_addr daddr2 = *daddr;
+	unsigned short hnum2 = hnum;
 	struct sock *result = NULL;
 	unsigned int hash2;
 
-	hash2 = ipv6_portaddr_hash(net, daddr, hnum);
+	inet6_lookup_run_bpf(net, saddr, sport, &daddr2, &hnum2);
+	hash2 = ipv6_portaddr_hash(net, &daddr2, hnum2);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
 	result = inet6_lhash2_lookup(net, ilb2, skb, doff,
-				     saddr, sport, daddr, hnum,
+				     saddr, sport, &daddr2, hnum2,
 				     dif, sdif);
 	if (result)
 		goto done;
 
 	/* Lookup lhash2 with in6addr_any */
-	hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
+	hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum2);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
 	result = inet6_lhash2_lookup(net, ilb2, skb, doff,
-				     saddr, sport, &in6addr_any, hnum,
+				     saddr, sport, &in6addr_any, hnum2,
 				     dif, sdif);
 done:
 	if (unlikely(IS_ERR(result)))
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 07fa579dfb96..6c0030ba83c6 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -196,17 +196,19 @@ struct sock *__udp6_lib_lookup(struct net *net,
 			       struct sk_buff *skb)
 {
 	unsigned short hnum = ntohs(dport);
+	struct in6_addr daddr2 = *daddr;
 	unsigned int hash2, slot2;
 	struct udp_hslot *hslot2;
 	struct sock *result;
 	bool exact_dif = udp6_lib_exact_dif_match(net, skb);
 
-	hash2 = ipv6_portaddr_hash(net, daddr, hnum);
+	inet6_lookup_run_bpf(net, saddr, sport, &daddr2, &hnum);
+	hash2 = ipv6_portaddr_hash(net, &daddr2, hnum);
 	slot2 = hash2 & udptable->mask;
 	hslot2 = &udptable->hash2[slot2];
 
 	result = udp6_lib_lookup2(net, saddr, sport,
-				  daddr, hnum, dif, sdif, exact_dif,
+				  &daddr2, hnum, dif, sdif, exact_dif,
 				  hslot2, skb);
 	if (!result) {
 		hash2 = ipv6_portaddr_hash(net, &in6addr_any, hnum);
-- 
2.20.1

