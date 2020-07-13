Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D5121DF03
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730420AbgGMRrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730306AbgGMRrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:47:05 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BBC9C08C5DB
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:05 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t74so9597782lff.2
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dcblGvWhBWCzM643yO1GenYw1yXlx9Mn/KsJt0ZGcP4=;
        b=a1ct+skdVvh1aO+JIKVD9+N25TdD+eLWjFfuh96vrpH+GfEr3P/7OCAOojRnelTgs9
         rJS6H9nFEcedN6kk3ttMiHCYzOVOmR3XzgnQDjU50uGHk8N5dTBeyIjInb7xEN+DWzSN
         NORcgZtRZr4uo/Unc4D7VUPV5wT/Og5akrkt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dcblGvWhBWCzM643yO1GenYw1yXlx9Mn/KsJt0ZGcP4=;
        b=XdYnaOf9zniLqfkcCc/Fs3vad3yZnfNc2siWNZ0373Zlwh0r+XQ5+lT/yb1mUZMrAT
         7VOOQdN9T1lF1zLvvGoUyk8qKkADmIfz0y0+K5hOm43j7ScnPp57fxjr5sq73OK9OXUa
         XaItSfDgtPmlcvqFdTkKM/9XLcZkUPNNN9kAWMkZhbPJr5ZZjqgsh2HvtlA0e0VUF2o4
         FdNbWNDcNV7UjBPGI8kfiucd5I01Ybk/gJJ1nQ1iJk3XgHxKlfw5igbmsRwxTmE6Nnuc
         tTGwJGZQBiP8VR4OAwnFMgwox3qoYgV227xb9cJhdP5vOs4v4D7bYYSFRG0oN3JdTNzl
         jHAA==
X-Gm-Message-State: AOAM5301q1UJ6yvoEd8jGIjwGh8Ec5/ntkG2TogiGMCMAlXk6fnXXuXi
        q73tLvRvUZs8C2ISoITTSCZGVQ==
X-Google-Smtp-Source: ABdhPJzgtWnsFDRcL2v+crbBG+Jw4Sf07C9czStdGuHZanBVUu43t1WqdYkZH0Ovv+5NU9SJmtgtIg==
X-Received: by 2002:a19:e05d:: with SMTP id g29mr142258lfj.217.1594662423437;
        Mon, 13 Jul 2020 10:47:03 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id l22sm5752360lje.81.2020.07.13.10.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:47:02 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH bpf-next v4 04/16] inet: Run SK_LOOKUP BPF program on socket lookup
Date:   Mon, 13 Jul 2020 19:46:42 +0200
Message-Id: <20200713174654.642628-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run a BPF program before looking up a listening socket on the receive path.
Program selects a listening socket to yield as result of socket lookup by
calling bpf_sk_assign() helper and returning SK_PASS code. Program can
revert its decision by assigning a NULL socket with bpf_sk_assign().

Alternatively, BPF program can also fail the lookup by returning with
SK_DROP, or let the lookup continue as usual with SK_PASS on return, when
no socket has not been selected with bpf_sk_assign(). Other return values
are treated the same as SK_DROP.

This lets the user match packets with listening sockets freely at the last
possible point on the receive path, where we know that packets are destined
for local delivery after undergoing policing, filtering, and routing.

With BPF code selecting the socket, directing packets destined to an IP
range or to a port range to a single socket becomes possible.

In case multiple programs are attached, they are run in series in the order
in which they were attached. The end result is determined from return codes
of all the programs according to following rules:

 1. If any program returned SK_PASS and selected a valid socket, the socket
    is used as result of socket lookup.
 2. If more than one program returned SK_PASS and selected a socket,
    last selection takes effect.
 3. If any program returned SK_DROP or an invalid return code, and no
    program returned SK_PASS and selected a socket, socket lookup fails
    with -ECONNREFUSED.
 4. If all programs returned SK_PASS and none of them selected a socket,
    socket lookup continues to htable-based lookup.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v4:
    - Reduce BPF sk_lookup prog return codes to SK_PASS/SK_DROP. (Lorenz)
    - Default to drop & warn on illegal return value from BPF prog. (Lorenz)
    - Rename netns_bpf_attach_type_enable/disable to _need/unneed. (Lorenz)
    - Export bpf_sk_lookup_enabled symbol for CONFIG_IPV6=m (kernel test robot)
    - Invert return value from bpf_sk_lookup_run_v4 to true on skip reuseport.
    - Move dedicated prog_array runner close to its callers in filter.h.
    
    v3:
    - Use a static_key to minimize the hook overhead when not used. (Alexei)
    - Adapt for running an array of attached programs. (Alexei)
    - Adapt for optionally skipping reuseport selection. (Martin)

 include/linux/filter.h     | 102 +++++++++++++++++++++++++++++++++++++
 kernel/bpf/net_namespace.c |  32 +++++++++++-
 net/core/filter.c          |   3 ++
 net/ipv4/inet_hashtables.c |  31 +++++++++++
 4 files changed, 167 insertions(+), 1 deletion(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 380746f47fa1..b9ad0fdabca5 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1295,4 +1295,106 @@ struct bpf_sk_lookup_kern {
 	bool		no_reuseport;
 };
 
+extern struct static_key_false bpf_sk_lookup_enabled;
+
+/* Runners for BPF_SK_LOOKUP programs to invoke on socket lookup.
+ *
+ * Allowed return values for a BPF SK_LOOKUP program are SK_PASS and
+ * SK_DROP. Any other return value is treated as SK_DROP. Their
+ * meaning is as follows:
+ *
+ *  SK_PASS && ctx.selected_sk != NULL: use selected_sk as lookup result
+ *  SK_PASS && ctx.selected_sk == NULL: continue to htable-based socket lookup
+ *  SK_DROP                           : terminate lookup with -ECONNREFUSED
+ *
+ * This macro aggregates return values and selected sockets from
+ * multiple BPF programs according to following rules:
+ *
+ *  1. If any program returned SK_PASS and a non-NULL ctx.selected_sk,
+ *     macro result is SK_PASS and last ctx.selected_sk is used.
+ *  2. If any program returned non-SK_PASS return value,
+ *     macro result is the last non-SK_PASS return value.
+ *  3. Otherwise result is SK_PASS and ctx.selected_sk is NULL.
+ *
+ * Caller must ensure that the prog array is non-NULL, and that the
+ * array as well as the programs it contains remain valid.
+ */
+#define BPF_PROG_SK_LOOKUP_RUN_ARRAY(array, ctx, func)			\
+	({								\
+		struct bpf_sk_lookup_kern *_ctx = &(ctx);		\
+		struct bpf_prog_array_item *_item;			\
+		struct sock *_selected_sk;				\
+		struct bpf_prog *_prog;					\
+		u32 _ret, _last_ret;					\
+		bool _no_reuseport;					\
+									\
+		migrate_disable();					\
+		_last_ret = SK_PASS;					\
+		_selected_sk = NULL;					\
+		_no_reuseport = false;					\
+		_item = &(array)->items[0];				\
+		while ((_prog = READ_ONCE(_item->prog))) {		\
+			/* restore most recent selection */		\
+			_ctx->selected_sk = _selected_sk;		\
+			_ctx->no_reuseport = _no_reuseport;		\
+									\
+			_ret = func(_prog, _ctx);			\
+			if (_ret == SK_PASS) {				\
+				/* remember last non-NULL socket */	\
+				if (_ctx->selected_sk) {		\
+					_selected_sk = _ctx->selected_sk;	\
+					_no_reuseport = _ctx->no_reuseport;	\
+				}					\
+			} else {					\
+				/* remember last non-PASS ret code */	\
+				_last_ret = _ret;			\
+			}						\
+			_item++;					\
+		}							\
+		_ctx->selected_sk = _selected_sk;			\
+		_ctx->no_reuseport = _no_reuseport;			\
+		migrate_enable();					\
+		_ctx->selected_sk ? SK_PASS : _last_ret;		\
+	 })
+
+static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
+					const __be32 saddr, const __be16 sport,
+					const __be32 daddr, const u16 dport,
+					struct sock **psk)
+{
+	struct bpf_prog_array *run_array;
+	struct sock *selected_sk = NULL;
+	bool no_reuseport = false;
+
+	rcu_read_lock();
+	run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
+	if (run_array) {
+		struct bpf_sk_lookup_kern ctx = {
+			.family		= AF_INET,
+			.protocol	= protocol,
+			.v4.saddr	= saddr,
+			.v4.daddr	= daddr,
+			.sport		= sport,
+			.dport		= dport,
+		};
+		u32 act;
+
+		act = BPF_PROG_SK_LOOKUP_RUN_ARRAY(run_array, ctx, BPF_PROG_RUN);
+		if (act == SK_PASS) {
+			selected_sk = ctx.selected_sk;
+			no_reuseport = ctx.no_reuseport;
+			goto unlock;
+		}
+
+		selected_sk = ERR_PTR(-ECONNREFUSED);
+		WARN_ONCE(act != SK_DROP,
+			  "Illegal BPF SK_LOOKUP return value %u, expect packet loss!\n",
+			  act);
+	}
+unlock:
+	rcu_read_unlock();
+	*psk = selected_sk;
+	return no_reuseport;
+}
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 596c30b963f3..ee3599a51891 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -25,6 +25,28 @@ struct bpf_netns_link {
 /* Protects updates to netns_bpf */
 DEFINE_MUTEX(netns_bpf_mutex);
 
+static void netns_bpf_attach_type_unneed(enum netns_bpf_attach_type type)
+{
+	switch (type) {
+	case NETNS_BPF_SK_LOOKUP:
+		static_branch_dec(&bpf_sk_lookup_enabled);
+		break;
+	default:
+		break;
+	}
+}
+
+static void netns_bpf_attach_type_need(enum netns_bpf_attach_type type)
+{
+	switch (type) {
+	case NETNS_BPF_SK_LOOKUP:
+		static_branch_inc(&bpf_sk_lookup_enabled);
+		break;
+	default:
+		break;
+	}
+}
+
 /* Must be called with netns_bpf_mutex held. */
 static void netns_bpf_run_array_detach(struct net *net,
 				       enum netns_bpf_attach_type type)
@@ -91,6 +113,9 @@ static void bpf_netns_link_release(struct bpf_link *link)
 	if (!net)
 		goto out_unlock;
 
+	/* Mark attach point as unused */
+	netns_bpf_attach_type_unneed(type);
+
 	/* Remember link position in case of safe delete */
 	idx = link_index(net, type, net_link);
 	list_del(&net_link->node);
@@ -414,6 +439,9 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 					lockdep_is_held(&netns_bpf_mutex));
 	bpf_prog_array_free(run_array);
 
+	/* Mark attach point as used */
+	netns_bpf_attach_type_need(type);
+
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 	return err;
@@ -489,8 +517,10 @@ static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 	mutex_lock(&netns_bpf_mutex);
 	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
 		netns_bpf_run_array_detach(net, type);
-		list_for_each_entry(net_link, &net->bpf.links[type], node)
+		list_for_each_entry(net_link, &net->bpf.links[type], node) {
 			net_link->net = NULL; /* auto-detach link */
+			netns_bpf_attach_type_unneed(type);
+		}
 		if (net->bpf.progs[type])
 			bpf_prog_put(net->bpf.progs[type]);
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 81c462881133..3fcb9c8cec4c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9221,6 +9221,9 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
 
+DEFINE_STATIC_KEY_FALSE(bpf_sk_lookup_enabled);
+EXPORT_SYMBOL(bpf_sk_lookup_enabled);
+
 BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
 	   struct sock *, sk, u64, flags)
 {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ab64834837c8..4eb4cd8d20dd 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -299,6 +299,29 @@ static struct sock *inet_lhash2_lookup(struct net *net,
 	return result;
 }
 
+static inline struct sock *inet_lookup_run_bpf(struct net *net,
+					       struct inet_hashinfo *hashinfo,
+					       struct sk_buff *skb, int doff,
+					       __be32 saddr, __be16 sport,
+					       __be32 daddr, u16 hnum)
+{
+	struct sock *sk, *reuse_sk;
+	bool no_reuseport;
+
+	if (hashinfo != &tcp_hashinfo)
+		return NULL; /* only TCP is supported */
+
+	no_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP,
+					    saddr, sport, daddr, hnum, &sk);
+	if (no_reuseport || IS_ERR_OR_NULL(sk))
+		return sk;
+
+	reuse_sk = lookup_reuseport(net, sk, skb, doff, saddr, sport, daddr, hnum);
+	if (reuse_sk)
+		sk = reuse_sk;
+	return sk;
+}
+
 struct sock *__inet_lookup_listener(struct net *net,
 				    struct inet_hashinfo *hashinfo,
 				    struct sk_buff *skb, int doff,
@@ -310,6 +333,14 @@ struct sock *__inet_lookup_listener(struct net *net,
 	struct sock *result = NULL;
 	unsigned int hash2;
 
+	/* Lookup redirect from BPF */
+	if (static_branch_unlikely(&bpf_sk_lookup_enabled)) {
+		result = inet_lookup_run_bpf(net, hashinfo, skb, doff,
+					     saddr, sport, daddr, hnum);
+		if (result)
+			goto done;
+	}
+
 	hash2 = ipv4_portaddr_hash(net, daddr, hnum);
 	ilb2 = inet_lhash2_bucket(hashinfo, hash2);
 
-- 
2.25.4

