Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A61704A156
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 15:01:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729056AbfFRNA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 09:00:58 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45922 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727105AbfFRNA4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 09:00:56 -0400
Received: by mail-lj1-f194.google.com with SMTP id m23so12999863lje.12
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 06:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5sOcMsDPhbVf9iBUCFYvG3YKCvRBKgejwbbZq0H8wxE=;
        b=JwDvo0IEuH7FBGYJlmimPDGSu1MEzfBVtoqrnBV5DKNqWrDjyJgynxesSVpn7xV9yK
         2uk19Qd8kyka8xL6j6jbY81L8zUnPmY+6+knqYHe9OtI5Wv5y9B6fObhetlrTACEBO8M
         nY3XnsZYlLimOCnXRQGAWlzJw93sP7yzWbOtE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5sOcMsDPhbVf9iBUCFYvG3YKCvRBKgejwbbZq0H8wxE=;
        b=T4bAg98vyEJ4ak/6XCfN6j3rgsIWmNeMNYM/SsXRmfRom4MgiPZb7wqqK7IXoBdcGU
         IMLhcIIEGDWYkg/QNEDFDNFZ6YFRy00qWImuEJnrBOl5WNrGtDIjl9VF8biMcNPmeTqf
         VAlU8s6C4/x0x58gW+QXyiapUCZdoCMGCAAPB7XAzj7PuApr/4Iw+K/IN6MPThcNEX/W
         5r67TQNux58Bx0UlyWkVpsrV/wY7mnyhd36wZl1B+TVniCDOK3sFN30JOem8UIgfNX+G
         Ev0WrM8U5N9dBwykGB1by384yFZEe962BcYb4Bs+MKCh5t9IyqhYuq5B/QJZ+ogpe5sq
         hVYA==
X-Gm-Message-State: APjAAAX6qKRrNpX1mFKN2vGiud/WajvoKPGFSLbjNd2nscgbuogoTpJy
        4SD2msDxgPPw9jQ9sOiDyH/gLMg1mrkulA==
X-Google-Smtp-Source: APXvYqyPIksQL+9vAj1t8upGSC5DTbR7FOzt0JhxoPyxjBGu9zl84x7bdxEimO9SIyePZdb0zg2qjg==
X-Received: by 2002:a2e:870f:: with SMTP id m15mr16495671lji.223.1560862854563;
        Tue, 18 Jun 2019 06:00:54 -0700 (PDT)
Received: from cloudflare.com ([176.221.114.230])
        by smtp.gmail.com with ESMTPSA id u9sm2180754lfb.38.2019.06.18.06.00.53
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 18 Jun 2019 06:00:54 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Marek Majkowski <marek@cloudflare.com>
Subject: [RFC bpf-next 2/7] ipv4: Run inet_lookup bpf program on socket lookup
Date:   Tue, 18 Jun 2019 15:00:45 +0200
Message-Id: <20190618130050.8344-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618130050.8344-1-jakub@cloudflare.com>
References: <20190618130050.8344-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run a BPF program before looking up the listening socket, or in case of udp
before looking up any socket, connected or not. The program is allowed to
change the destination address & port we use as keys for the lookup,
providing its return code is BPF_REDIRECT.

This allows us to redirect traffic destined to a set of addresses and ports
without bindings sockets to all the addresses and ports we want to receive
on.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet_hashtables.h | 39 +++++++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c    | 11 ++++++----
 net/ipv4/udp.c                |  1 +
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index babb14136705..7d8b58b2ded0 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -418,4 +418,43 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk);
+
+#ifdef CONFIG_BPF_SYSCALL
+static inline void inet_lookup_run_bpf(struct net *net,
+				       const __be32 saddr,
+				       const __be16 sport,
+				       __be32 *daddr,
+				       unsigned short *hnum)
+{
+	struct bpf_inet_lookup_kern ctx = {
+		.family	= AF_INET,
+		.saddr	= saddr,
+		.sport	= sport,
+		.daddr	= *daddr,
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
+		*daddr = ctx.daddr;
+		*hnum = ctx.hnum;
+	}
+}
+#else
+static inline void inet_lookup_run_bpf(struct sk_buff *skb,
+				       const __be32 saddr,
+				       const __be16 sport,
+				       __be32 *daddr,
+				       unsigned short *hnum)
+{
+}
+#endif	/* CONFIG_BPF_SYSCALL */
+
 #endif /* _INET_HASHTABLES_H */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 942265d65eb3..ae3f1da1b4f6 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -300,24 +300,27 @@ struct sock *__inet_lookup_listener(struct net *net,
 				    const int dif, const int sdif)
 {
 	struct inet_listen_hashbucket *ilb2;
+	unsigned short hnum2 = hnum;
 	struct sock *result = NULL;
+	__be32 daddr2 = daddr;
 	unsigned int hash2;
 
-	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
+	inet_lookup_run_bpf(net, saddr, sport, &daddr2, &hnum2);
+	hash2 = ipv4_portaddr_hash(net, daddr2, hnum2);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
 	result = inet_lhash2_lookup(net, ilb2, skb, doff,
-				    saddr, sport, daddr, hnum,
+				    saddr, sport, daddr2, hnum2,
 				    dif, sdif);
 	if (result)
 		goto done;
 
 	/* Lookup lhash2 with INADDR_ANY */
-	hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum);
+	hash2 = ipv4_portaddr_hash(net, htonl(INADDR_ANY), hnum2);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
 	result = inet_lhash2_lookup(net, ilb2, skb, doff,
-				    saddr, sport, htonl(INADDR_ANY), hnum,
+				    saddr, sport, htonl(INADDR_ANY), hnum2,
 				    dif, sdif);
 done:
 	if (unlikely(IS_ERR(result)))
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index 8fb250ed53d4..c4f4c94525ec 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -467,6 +467,7 @@ struct sock *__udp4_lib_lookup(struct net *net, __be32 saddr,
 	struct udp_hslot *hslot2;
 	bool exact_dif = udp_lib_exact_dif_match(net, skb);
 
+	inet_lookup_run_bpf(net, saddr, sport, &daddr, &hnum);
 	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
 	slot2 = hash2 & udptable->mask;
 	hslot2 = &udptable->hash2[slot2];
-- 
2.20.1

