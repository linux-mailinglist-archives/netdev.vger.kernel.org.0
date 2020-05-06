Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E23501C711D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgEFM4J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728704AbgEFMz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:55:27 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6B5C061BD3
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 05:55:24 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x17so2074275wrt.5
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 05:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oLe4Rujwy2vUFJip5GQFe5EbeF/yzhx7q0Dlr8Akcec=;
        b=j4sNptzT+9kPOCQ8TEUHJo/IBR9XVpPN8xn0iIS7qsJyowoCWesuD5pEe6YePoklfs
         UYbWaTHFnsorW3B0hDSatO19wz3p9keorrDeeFlthNLxK3ZKAyS6b2L+4YZXO4x0WfMe
         5IiCKXibn+YpnJEYpSgzGi6yndoD87QYzq7VM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oLe4Rujwy2vUFJip5GQFe5EbeF/yzhx7q0Dlr8Akcec=;
        b=l9C/dv94+H/F4gH/Iw3nzYDrsE/iPs1rKCQdzcqWN8KYyw10/738nYuyGSaXHQYvqw
         ivE2GVHCqXe4T8ISpAmUnVH9emNUSH9OXeGCGtFt/Onod1ZBdmrjwAdA2A7o4R7uBFiy
         aLs89qWivWrdbIi/it8tX4h7rjGW6/cWhoZzfeOz7TRy9Jxbr8dakWU1noL2YXLQLzfl
         BIKvII3WH5j/HULgPc6UO8bClMTaU+HUaPh1UO561CEqr0wPGNEPdWU9CNLu+GGfbzsv
         BjDsIGRA/WkHCJ18HdHm2CmGgko8xZGRIC1W5BYk5HqDHwA8hD3keVDUqxBFjGA8EpOJ
         a0AQ==
X-Gm-Message-State: AGi0PuZQaFFmrTZBVLc+qxLNmQD8isDvedR2WyNn84M0034/LHwaiC+k
        Jb5z51NWjX9NhRJB42h2R601taHpoQU=
X-Google-Smtp-Source: APiQypKOAUfyFWUthAbfYGptMBhI51yOAsOumVS8RM08bvO7mcZ3eo+cgmXvlbaNTc3Ssd0SOB8HOQ==
X-Received: by 2002:adf:f1c4:: with SMTP id z4mr10269329wro.25.1588769723224;
        Wed, 06 May 2020 05:55:23 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id u188sm2969924wmg.37.2020.05.06.05.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 05:55:22 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     dccp@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH bpf-next 05/17] inet: Run SK_LOOKUP BPF program on socket lookup
Date:   Wed,  6 May 2020 14:55:01 +0200
Message-Id: <20200506125514.1020829-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200506125514.1020829-1-jakub@cloudflare.com>
References: <20200506125514.1020829-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run a BPF program before looking up a listening socket on the receive path.
Program selects a listening socket to yield as result of socket lookup by
calling bpf_sk_assign() helper and returning BPF_REDIRECT code.

Alternatively, program can also fail the lookup by returning with BPF_DROP,
or let the lookup continue as usual with BPF_OK on return.

This lets the user match packets with listening sockets freely at the last
possible point on the receive path, where we know that packets are destined
for local delivery after undergoing policing, filtering, and routing.

With BPF code selecting the socket, directing packets destined to an IP
range or to a port range to a single socket becomes possible.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/inet_hashtables.h | 36 +++++++++++++++++++++++++++++++++++
 net/ipv4/inet_hashtables.c    | 15 ++++++++++++++-
 2 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/include/net/inet_hashtables.h b/include/net/inet_hashtables.h
index 6072dfbd1078..3fcbc8f66f88 100644
--- a/include/net/inet_hashtables.h
+++ b/include/net/inet_hashtables.h
@@ -422,4 +422,40 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 
 int inet_hash_connect(struct inet_timewait_death_row *death_row,
 		      struct sock *sk);
+
+static inline struct sock *bpf_sk_lookup_run(struct net *net,
+					     struct bpf_sk_lookup_kern *ctx)
+{
+	struct bpf_prog *prog;
+	int ret = BPF_OK;
+
+	rcu_read_lock();
+	prog = rcu_dereference(net->sk_lookup_prog);
+	if (prog)
+		ret = BPF_PROG_RUN(prog, ctx);
+	rcu_read_unlock();
+
+	if (ret == BPF_DROP)
+		return ERR_PTR(-ECONNREFUSED);
+	if (ret == BPF_REDIRECT)
+		return ctx->selected_sk;
+	return NULL;
+}
+
+static inline struct sock *inet_lookup_run_bpf(struct net *net, u8 protocol,
+					       __be32 saddr, __be16 sport,
+					       __be32 daddr, u16 dport)
+{
+	struct bpf_sk_lookup_kern ctx = {
+		.family		= AF_INET,
+		.protocol	= protocol,
+		.v4.saddr	= saddr,
+		.v4.daddr	= daddr,
+		.sport		= sport,
+		.dport		= dport,
+	};
+
+	return bpf_sk_lookup_run(net, &ctx);
+}
+
 #endif /* _INET_HASHTABLES_H */
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ab64834837c8..f4d07285591a 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -307,9 +307,22 @@ struct sock *__inet_lookup_listener(struct net *net,
 				    const int dif, const int sdif)
 {
 	struct inet_listen_hashbucket *ilb2;
-	struct sock *result = NULL;
+	struct sock *result, *reuse_sk;
 	unsigned int hash2;
 
+	/* Lookup redirect from BPF */
+	result = inet_lookup_run_bpf(net, hashinfo->protocol,
+				     saddr, sport, daddr, hnum);
+	if (IS_ERR(result))
+		return NULL;
+	if (result) {
+		reuse_sk = lookup_reuseport(net, result, skb, doff,
+					    saddr, sport, daddr, hnum);
+		if (reuse_sk)
+			result = reuse_sk;
+		goto done;
+	}
+
 	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
-- 
2.25.3

