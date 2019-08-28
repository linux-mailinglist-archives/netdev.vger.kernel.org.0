Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE4619FB81
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 09:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbfH1HXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 03:23:07 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:34286 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726429AbfH1HXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 03:23:05 -0400
Received: by mail-lf1-f67.google.com with SMTP id z21so1252407lfe.1
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 00:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bUOQ5oa1ZHxkv7QVhvg7zNwIQm1dIN9rUB7dlg1DwGU=;
        b=aqGvTP9fAIyReK8/fPYCFrDrtPsWF2xlKWNBmrCXzGsK+uRSv6lXRYCnbAsLKhnZRu
         bApNJexfTCTD7qWgpHnGRBrDo3WvoQQHhXBejHeVUU9O9F53OS5OjBN7TpYH8sfxIVrU
         KaaJTTW+GqRnU9YWif+t70Z9pEYpHA+2jz70k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bUOQ5oa1ZHxkv7QVhvg7zNwIQm1dIN9rUB7dlg1DwGU=;
        b=jH8IJ5ktHZi+dIChZbXi7sJ59enwMKGyEE3hqYSewLwoiP0ATDI9KuVGRnWxAtyloE
         Php/+d52b8kzmykinunigPfyLXK+/KJJMm3nM/CmYhEyc8abTymPEIue20PurAZIn+Vu
         c3sqEXUJakO34uXH8P3L1kPWSRiHaNyRQYQvCz2zkAW3/duj/8Gl4fZGR0tUCQRUfgR+
         /aJKxXzuo6IrgcF2l771GG0PpweeTcZ3We8I5Hgb8GvTogXSyPrvh+pBI8mnCKoFRaoP
         S9DNnRwp6MeJK2/IACtNrN6wEeBEEjpICeLuHAewdWmNxpcC8dMhgwNH3vy9Dia2Pzx+
         PXWw==
X-Gm-Message-State: APjAAAV4X64tQiV6Zg99Vh6rHudXWAP7V3G8TnL3AkhF0/+SdzpUZlig
        G7EHNk81T2Lbuboi0ZkVOt3reg==
X-Google-Smtp-Source: APXvYqwlE+EtT2/p7367j86OfDaPYOt8ajL8OKE5nB8hwq3maKuNvxpyFZxyGnKn3Y1cISSrgY6FZw==
X-Received: by 2002:ac2:5df7:: with SMTP id z23mr875407lfq.105.1566976983387;
        Wed, 28 Aug 2019 00:23:03 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id t2sm486554lfl.33.2019.08.28.00.23.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:23:02 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-team@cloudflare.com, Lorenz Bauer <lmb@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [RFCv2 bpf-next 06/12] inet: Run inet_lookup bpf program on socket lookup
Date:   Wed, 28 Aug 2019 09:22:44 +0200
Message-Id: <20190828072250.29828-7-jakub@cloudflare.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190828072250.29828-1-jakub@cloudflare.com>
References: <20190828072250.29828-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run a BPF program before looking up the listening socket. The program can
redirect the skb to a listening socket of its choice, providing it calls
bpf_redirect_lookup() helper and returns BPF_REDIRECT.

This lets the user-space program mappings between packet 4-tuple and
listening sockets. With the possibility to override the socket lookup from
BPF, applications don't need to bind sockets to every addresses they
receive on, or resort to listening on all addresses with INADDR_ANY.

Also port sharing conflicts become a non-issue. Application can listen on
any free port and still receive traffic destined to its assigned service
port.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet_hashtables.h | 33 +++++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c    |  5 +++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index b2d43ee72dc1..c9c7efb961cb 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -417,4 +417,37 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk);
+
+static inline struct sock *__inet_lookup_run_bpf(const struct net *net,
+						 struct bpf_inet_lookup_kern *ctx)
+{
+	struct bpf_prog *prog;
+	int ret = BPF_OK;
+
+	rcu_read_lock();
+	prog = rcu_dereference(net->inet_lookup_prog);
+	if (prog)
+		ret = BPF_PROG_RUN(prog, ctx);
+	rcu_read_unlock();
+
+	return ret == BPF_REDIRECT ? ctx->redir_sk : NULL;
+}
+
+static inline struct sock *inet_lookup_run_bpf(const struct net *net, u8 proto,
+					       __be32 saddr, __be16 sport,
+					       __be32 daddr,
+					       unsigned short hnum)
+{
+	struct bpf_inet_lookup_kern ctx = {
+		.family		= AF_INET,
+		.protocol	= proto,
+		.saddr		= saddr,
+		.sport		= sport,
+		.daddr		= daddr,
+		.hnum		= hnum,
+	};
+
+	return __inet_lookup_run_bpf(net, &ctx);
+}
+
 #endif /* _INET_HASHTABLES_H */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 97824864e40d..ab6d89c27c94 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -299,6 +299,11 @@ struct sock *__inet_lookup_listener(struct net *net,
 	struct sock *result = NULL;
 	unsigned int hash2;
 
+	result = inet_lookup_run_bpf(net, hashinfo->protocol,
+				     saddr, sport, daddr, hnum);
+	if (result)
+		goto done;
+
 	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
-- 
2.20.1

