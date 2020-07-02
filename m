Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 407D0211FC0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgGBJYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgGBJY1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:27 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0114C08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:26 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id by13so13001672edb.11
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aGo5nid/hfBUHWq6lrIh2NaGfda62QuT55dVBU8uaaU=;
        b=jy7i5EPlLRhd3d+b3/C4GVALpNxlAPA4Vr6Xd6dqidyzUSLztAnB4kTVOJkj+XU8PU
         MpKz1bq+nqTFvllH0s7UezUfia3dH+zrEbkbIH32yDyFenLMRCHdEdAaqUPiFd3uCKSU
         QNh8hzJtN73oMtatmTSPJYCOamEmuOQEy8jJg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aGo5nid/hfBUHWq6lrIh2NaGfda62QuT55dVBU8uaaU=;
        b=hJz660G9N+7pClq1BbMVwAzX986iPytHUtYe5aoVU45HYApy7gnu0DJbcXiW+aZcC3
         9ZHD+O7VjycdyWSM0rnR3N0zCNTXOcgi9ree+RmBFVXyXbZ2pnBnLbOor0MsuoO68rR2
         wNkECFGBq4Inxj4UctG0OLKOhifyMNwrCumdXIPFjCl2T12YZ8B1l+Q21M/mhQB573/J
         Qd/TW2tCcK15HGajgvPbefGWUMOwXm8HLNebwlXrTrjOL8z3B1FakuhQ/R5QAfGxPkLC
         sTOdogGxznqLZJkC5Wdv0XlWOE1T/bxjfzqHRGFwBrsvQlCMUgSBy/xoo/wqytB13j/a
         45Tw==
X-Gm-Message-State: AOAM532AQhPpmHlmO8nAROkXCbeGn0mSxgcgE0zwgLFj+YKOBGiAWkk7
        ol8+eT/+t2+abfDeUDIj4a92QV8s2lNseA==
X-Google-Smtp-Source: ABdhPJyAxQ4IFAGI9KJTIcyz2FfF/kncDjwucN6MUaEQRWJIPElQxr4Bo3HAnjQww2RSo5HyzlnxLQ==
X-Received: by 2002:a50:ee01:: with SMTP id g1mr26219523eds.264.1593681865478;
        Thu, 02 Jul 2020 02:24:25 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id p14sm6159270ejl.115.2020.07.02.02.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:24 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: [PATCH bpf-next v3 04/16] inet: Run SK_LOOKUP BPF program on socket lookup
Date:   Thu,  2 Jul 2020 11:24:04 +0200
Message-Id: <20200702092416.11961-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Run a BPF program before looking up a listening socket on the receive path.
Program selects a listening socket to yield as result of socket lookup by
calling bpf_sk_assign() helper and returning BPF_REDIRECT (7) code.

Alternatively, program can also fail the lookup by returning with
BPF_DROP (1), or let the lookup continue as usual with BPF_OK (0) on
return. Other return values are treated the same as BPF_OK.

This lets the user match packets with listening sockets freely at the last
possible point on the receive path, where we know that packets are destined
for local delivery after undergoing policing, filtering, and routing.

With BPF code selecting the socket, directing packets destined to an IP
range or to a port range to a single socket becomes possible.

In case multiple programs are attached, they are run in series in the order
in which they were attached. The end result gets determined from return
code from each program according to following rules.

 1. If any program returned BPF_REDIRECT and selected a valid socket, this
    socket will be used as result of the lookup.
 2. If more than one program returned BPF_REDIRECT and selected a socket,
    last selection takes effect.
 3. If any program returned BPF_DROP and none returned BPF_REDIRECT, the
    socket lookup will fail with -ECONNREFUSED.
 4. If no program returned neither BPF_DROP nor BPF_REDIRECT, socket lookup
    continues to htable-based lookup.

Suggested-by: Marek Majkowski <marek@cloudflare.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - Use a static_key to minimize the hook overhead when not used. (Alexei)
    - Adapt for running an array of attached programs. (Alexei)
    - Adapt for optionally skipping reuseport selection. (Martin)

 include/linux/bpf.h        | 29 ++++++++++++++++++++++++++++
 include/linux/filter.h     | 39 ++++++++++++++++++++++++++++++++++++++
 kernel/bpf/net_namespace.c | 32 ++++++++++++++++++++++++++++++-
 net/core/filter.c          |  2 ++
 net/ipv4/inet_hashtables.c | 31 ++++++++++++++++++++++++++++++
 5 files changed, 132 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 26bc70533db0..98f79d39eaa1 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1013,6 +1013,35 @@ _out:							\
 		_ret;					\
 	})
 
+/* Runner for BPF_SK_LOOKUP programs to invoke on socket lookup.
+ *
+ * Valid return codes for SK_LOOKUP programs are:
+ * - BPF_REDIRECT (7) to use selected socket as result of the lookup,
+ * - BPF_DROP (1) to fail the socket lookup with no result,
+ * - BPF_OK (0) to continue on to regular htable-based socket lookup.
+ *
+ * Runner returns an u32 value that has a bit set for each code
+ * returned by any of the programs. Bit position corresponds to the
+ * return code.
+ *
+ * Caller must ensure that array is non-NULL.
+ */
+#define BPF_PROG_SK_LOOKUP_RUN_ARRAY(array, ctx, func)		\
+	({							\
+		struct bpf_prog_array_item *_item;		\
+		struct bpf_prog *_prog;				\
+		u32 _bit, _ret = 0;				\
+		migrate_disable();				\
+		_item = &(array)->items[0];			\
+		while ((_prog = READ_ONCE(_item->prog))) {	\
+			_bit = func(_prog, ctx);		\
+			_ret |= 1U << (_bit & 31);		\
+			_item++;				\
+		}						\
+		migrate_enable();				\
+		_ret;						\
+	 })
+
 #define BPF_PROG_RUN_ARRAY(array, ctx, func)		\
 	__BPF_PROG_RUN_ARRAY(array, ctx, func, false)
 
diff --git a/include/linux/filter.h b/include/linux/filter.h
index ba4f8595fa54..ff7721d862c2 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -1297,4 +1297,43 @@ struct bpf_sk_lookup_kern {
 	bool		no_reuseport;
 };
 
+extern struct static_key_false bpf_sk_lookup_enabled;
+
+static inline bool bpf_sk_lookup_run_v4(struct net *net, int protocol,
+					const __be32 saddr, const __be16 sport,
+					const __be32 daddr, const u16 dport,
+					struct sock **psk)
+{
+	struct bpf_prog_array *run_array;
+	bool do_reuseport = false;
+	struct sock *sk = NULL;
+
+	rcu_read_lock();
+	run_array = rcu_dereference(net->bpf.run_array[NETNS_BPF_SK_LOOKUP]);
+	if (run_array) {
+		const struct bpf_sk_lookup_kern ctx = {
+			.family		= AF_INET,
+			.protocol	= protocol,
+			.v4.saddr	= saddr,
+			.v4.daddr	= daddr,
+			.sport		= sport,
+			.dport		= dport,
+		};
+		u32 ret;
+
+		ret = BPF_PROG_SK_LOOKUP_RUN_ARRAY(run_array, &ctx,
+						   BPF_PROG_RUN);
+		if (ret & (1U << BPF_REDIRECT)) {
+			sk = ctx.selected_sk;
+			do_reuseport = sk && !ctx.no_reuseport;
+		} else if (ret & (1U << BPF_DROP)) {
+			sk = ERR_PTR(-ECONNREFUSED);
+		}
+	}
+	rcu_read_unlock();
+
+	*psk = sk;
+	return do_reuseport;
+}
+
 #endif /* __LINUX_FILTER_H__ */
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 090166824ca4..a7768feb3ade 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -25,6 +25,28 @@ struct bpf_netns_link {
 /* Protects updates to netns_bpf */
 DEFINE_MUTEX(netns_bpf_mutex);
 
+static void netns_bpf_attach_type_disable(enum netns_bpf_attach_type type)
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
+static void netns_bpf_attach_type_enable(enum netns_bpf_attach_type type)
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
@@ -93,6 +115,9 @@ static void bpf_netns_link_release(struct bpf_link *link)
 	if (!net)
 		goto out_unlock;
 
+	/* Mark attach point as unused */
+	netns_bpf_attach_type_disable(type);
+
 	/* Remember link position in case of safe delete */
 	idx = link_index(net, type, net_link);
 	list_del(&net_link->node);
@@ -416,6 +441,9 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 					lockdep_is_held(&netns_bpf_mutex));
 	bpf_prog_array_free(run_array);
 
+	/* Mark attach point as used */
+	netns_bpf_attach_type_enable(type);
+
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 	return err;
@@ -491,8 +519,10 @@ static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 	mutex_lock(&netns_bpf_mutex);
 	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
 		netns_bpf_run_array_detach(net, type);
-		list_for_each_entry(net_link, &net->bpf.links[type], node)
+		list_for_each_entry(net_link, &net->bpf.links[type], node) {
 			net_link->net = NULL; /* auto-detach link */
+			netns_bpf_attach_type_disable(type);
+		}
 		if (net->bpf.progs[type])
 			bpf_prog_put(net->bpf.progs[type]);
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index 286f90e0c824..c0146977a6d1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9220,6 +9220,8 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
 
+DEFINE_STATIC_KEY_FALSE(bpf_sk_lookup_enabled);
+
 BPF_CALL_3(bpf_sk_lookup_assign, struct bpf_sk_lookup_kern *, ctx,
 	   struct sock *, sk, u64, flags)
 {
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index ab64834837c8..2b1fc194efaf 100644
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
+	bool do_reuseport;
+
+	if (hashinfo != &tcp_hashinfo)
+		return NULL; /* only TCP is supported */
+
+	do_reuseport = bpf_sk_lookup_run_v4(net, IPPROTO_TCP,
+					    saddr, sport, daddr, hnum, &sk);
+	if (do_reuseport) {
+		reuse_sk = lookup_reuseport(net, sk, skb, doff,
+					    saddr, sport, daddr, hnum);
+		if (reuse_sk)
+			sk = reuse_sk;
+	}
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

