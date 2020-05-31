Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6FD81E9642
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727809AbgEaI26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:28:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgEaI24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:28:56 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7707EC05BD43
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:54 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id n24so6302778ejd.0
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nHVONxREBhR6d0p+vj24wm/Uj5g9XQgatFZOrI1Q14o=;
        b=X7pKmNXGG65zs/Q3cdrtN9mTWJNXIJb7AHNKkzgPx7YhpxsBXhQqyCqdDw9oQjRTDC
         ddYZshF4RcX0KJ72qo9WXpH8LjtHCPgWVwmHSKNevJ+/yr+xiLN/KsRHfL/S4Uz4ZLFU
         W64NlCEVz9BZSaByry0IwXpLj92eFIsj69xpU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nHVONxREBhR6d0p+vj24wm/Uj5g9XQgatFZOrI1Q14o=;
        b=Bczm5RArF+bagVICtLNpYNg4yrYjDxUFQBrt289tBfG6o2snkYqPFp8WkSVCoM0AOV
         Mg/zyrEpqRA3Q/4IB+5BYuUnmOSdH/kx6o+6s0QeMmb4KluvwceMnxmsAdSROBA51OAX
         rqyLgq6fhE394sGT//osCK474U+mYT9O64O4fbEJFOCdmF905xJsK0R3hF6EDcdIj2Vc
         cNmbQYwBWwg+SAvzV2XJ6ijnNCgexdxRRBAehelrYB3PzgANNcfz8d/rhdvnk2N0GX/r
         ACztWLeg7L1Cb0afimqZpTSu8kmfU+40/jR25v44lsKmf+PxWaONrcunqkBDR9yf56ZV
         UI7A==
X-Gm-Message-State: AOAM531w5UZcagv22qasQDpYVIRAd0N7TchVC7wcvzuBXCHPtaErWi5a
        yhLynns5ZZjjL+sXw27vZhn2JQ==
X-Google-Smtp-Source: ABdhPJwa6tcctaIwqYTGSmb/7iEoo382LF7QlmBrLms2CIhsTUn5P6VUa90WuMs5mOzI9ZI1o5o/DQ==
X-Received: by 2002:a17:906:370a:: with SMTP id d10mr1259144ejc.433.1590913733107;
        Sun, 31 May 2020 01:28:53 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id da17sm12212036edb.11.2020.05.31.01.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:28:52 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Stanislav Fomichev <sdf@google.com>
Subject: [PATCH bpf-next v2 02/12] net: Introduce netns_bpf for BPF programs attached to netns
Date:   Sun, 31 May 2020 10:28:36 +0200
Message-Id: <20200531082846.2117903-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to:

 (1) attach more than one BPF program type to netns, or
 (2) support attaching BPF programs to netns with bpf_link, or
 (3) support multi-prog attach points for netns

we will need to keep more state per netns than a single pointer like we
have now for BPF flow dissector program.

Prepare for the above by extracting netns_bpf that is part of struct net,
for storing all state related to BPF programs attached to netns.

Turn flow dissector callbacks for querying/attaching/detaching a program
into generic ones that operate on netns_bpf. Next patch will move the
generic callbacks into their own module.

This is similar to how it is organized for cgroup with cgroup_bpf.

Cc: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    Stanislav, this patch has changed slightly so I didn't carry over your
    Reviewed-by tag. Notice, pernet pre_exit callback now grabs the mutex.

 include/linux/bpf-netns.h   |  56 +++++++++++++++++++
 include/linux/skbuff.h      |  26 ---------
 include/net/net_namespace.h |   4 +-
 include/net/netns/bpf.h     |  17 ++++++
 kernel/bpf/syscall.c        |   7 +--
 net/core/flow_dissector.c   | 105 +++++++++++++++++++++++-------------
 6 files changed, 149 insertions(+), 66 deletions(-)
 create mode 100644 include/linux/bpf-netns.h
 create mode 100644 include/net/netns/bpf.h

diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
new file mode 100644
index 000000000000..f3aec3d79824
--- /dev/null
+++ b/include/linux/bpf-netns.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _BPF_NETNS_H
+#define _BPF_NETNS_H
+
+#include <linux/mutex.h>
+#include <uapi/linux/bpf.h>
+
+enum netns_bpf_attach_type {
+	NETNS_BPF_INVALID = -1,
+	NETNS_BPF_FLOW_DISSECTOR = 0,
+	MAX_NETNS_BPF_ATTACH_TYPE
+};
+
+static inline enum netns_bpf_attach_type
+to_netns_bpf_attach_type(enum bpf_attach_type attach_type)
+{
+	switch (attach_type) {
+	case BPF_FLOW_DISSECTOR:
+		return NETNS_BPF_FLOW_DISSECTOR;
+	default:
+		return NETNS_BPF_INVALID;
+	}
+}
+
+/* Protects updates to netns_bpf */
+extern struct mutex netns_bpf_mutex;
+
+union bpf_attr;
+struct bpf_prog;
+
+#ifdef CONFIG_NET
+int netns_bpf_prog_query(const union bpf_attr *attr,
+			 union bpf_attr __user *uattr);
+int netns_bpf_prog_attach(const union bpf_attr *attr,
+			  struct bpf_prog *prog);
+int netns_bpf_prog_detach(const union bpf_attr *attr);
+#else
+static inline int netns_bpf_prog_query(const union bpf_attr *attr,
+				       union bpf_attr __user *uattr)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int netns_bpf_prog_attach(const union bpf_attr *attr,
+					struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline int netns_bpf_prog_detach(const union bpf_attr *attr)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
+#endif /* _BPF_NETNS_H */
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 531843952809..a0d5c2760103 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1283,32 +1283,6 @@ void skb_flow_dissector_init(struct flow_dissector *flow_dissector,
 			     const struct flow_dissector_key *key,
 			     unsigned int key_count);
 
-#ifdef CONFIG_NET
-int skb_flow_dissector_prog_query(const union bpf_attr *attr,
-				  union bpf_attr __user *uattr);
-int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
-				       struct bpf_prog *prog);
-
-int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr);
-#else
-static inline int skb_flow_dissector_prog_query(const union bpf_attr *attr,
-						union bpf_attr __user *uattr)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
-						     struct bpf_prog *prog)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
-{
-	return -EOPNOTSUPP;
-}
-#endif
-
 struct bpf_flow_dissector;
 bool bpf_flow_dissect(struct bpf_prog *prog, struct bpf_flow_dissector *ctx,
 		      __be16 proto, int nhoff, int hlen, unsigned int flags);
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index 8e001e049497..2ee5901bec7a 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -33,6 +33,7 @@
 #include <net/netns/mpls.h>
 #include <net/netns/can.h>
 #include <net/netns/xdp.h>
+#include <net/netns/bpf.h>
 #include <linux/ns_common.h>
 #include <linux/idr.h>
 #include <linux/skbuff.h>
@@ -162,7 +163,8 @@ struct net {
 #endif
 	struct net_generic __rcu	*gen;
 
-	struct bpf_prog __rcu	*flow_dissector_prog;
+	/* Used to store attached BPF programs */
+	struct netns_bpf	bpf;
 
 	/* Note : following structs are cache line aligned */
 #ifdef CONFIG_XFRM
diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
new file mode 100644
index 000000000000..a858d1c5b166
--- /dev/null
+++ b/include/net/netns/bpf.h
@@ -0,0 +1,17 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * BPF programs attached to network namespace
+ */
+
+#ifndef __NETNS_BPF_H__
+#define __NETNS_BPF_H__
+
+#include <linux/bpf-netns.h>
+
+struct bpf_prog;
+
+struct netns_bpf {
+	struct bpf_prog __rcu *progs[MAX_NETNS_BPF_ATTACH_TYPE];
+};
+
+#endif /* __NETNS_BPF_H__ */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 9de3540fa90c..5b2ae498cc3f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -27,6 +27,7 @@
 #include <uapi/linux/btf.h>
 #include <linux/bpf_lsm.h>
 #include <linux/poll.h>
+#include <linux/bpf-netns.h>
 
 #define IS_FD_ARRAY(map) ((map)->map_type == BPF_MAP_TYPE_PERF_EVENT_ARRAY || \
 			  (map)->map_type == BPF_MAP_TYPE_CGROUP_ARRAY || \
@@ -2868,7 +2869,7 @@ static int bpf_prog_attach(const union bpf_attr *attr)
 		ret = lirc_prog_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
-		ret = skb_flow_dissector_bpf_prog_attach(attr, prog);
+		ret = netns_bpf_prog_attach(attr, prog);
 		break;
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SKB:
@@ -2908,7 +2909,7 @@ static int bpf_prog_detach(const union bpf_attr *attr)
 	case BPF_PROG_TYPE_FLOW_DISSECTOR:
 		if (!capable(CAP_NET_ADMIN))
 			return -EPERM;
-		return skb_flow_dissector_bpf_prog_detach(attr);
+		return netns_bpf_prog_detach(attr);
 	case BPF_PROG_TYPE_CGROUP_DEVICE:
 	case BPF_PROG_TYPE_CGROUP_SKB:
 	case BPF_PROG_TYPE_CGROUP_SOCK:
@@ -2961,7 +2962,7 @@ static int bpf_prog_query(const union bpf_attr *attr,
 	case BPF_LIRC_MODE2:
 		return lirc_prog_query(attr, uattr);
 	case BPF_FLOW_DISSECTOR:
-		return skb_flow_dissector_prog_query(attr, uattr);
+		return netns_bpf_prog_query(attr, uattr);
 	default:
 		return -EINVAL;
 	}
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index ad08b51c781e..91e2f5a1f8ad 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -31,8 +31,10 @@
 #include <net/netfilter/nf_conntrack_core.h>
 #include <net/netfilter/nf_conntrack_labels.h>
 #endif
+#include <linux/bpf-netns.h>
 
-static DEFINE_MUTEX(flow_dissector_mutex);
+/* Protects updates to netns_bpf */
+DEFINE_MUTEX(netns_bpf_mutex);
 
 static void dissector_set_key(struct flow_dissector *flow_dissector,
 			      enum flow_dissector_key_id key_id)
@@ -70,23 +72,28 @@ void skb_flow_dissector_init(struct flow_dissector *flow_dissector,
 }
 EXPORT_SYMBOL(skb_flow_dissector_init);
 
-int skb_flow_dissector_prog_query(const union bpf_attr *attr,
-				  union bpf_attr __user *uattr)
+int netns_bpf_prog_query(const union bpf_attr *attr,
+			 union bpf_attr __user *uattr)
 {
 	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
 	u32 prog_id, prog_cnt = 0, flags = 0;
+	enum netns_bpf_attach_type type;
 	struct bpf_prog *attached;
 	struct net *net;
 
 	if (attr->query.query_flags)
 		return -EINVAL;
 
+	type = to_netns_bpf_attach_type(attr->query.attach_type);
+	if (type < 0)
+		return -EINVAL;
+
 	net = get_net_ns_by_fd(attr->query.target_fd);
 	if (IS_ERR(net))
 		return PTR_ERR(net);
 
 	rcu_read_lock();
-	attached = rcu_dereference(net->flow_dissector_prog);
+	attached = rcu_dereference(net->bpf.progs[type]);
 	if (attached) {
 		prog_cnt = 1;
 		prog_id = attached->aux->id;
@@ -112,6 +119,7 @@ int skb_flow_dissector_prog_query(const union bpf_attr *attr,
 static int flow_dissector_bpf_prog_attach(struct net *net,
 					  struct bpf_prog *prog)
 {
+	enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
 	struct bpf_prog *attached;
 
 	if (net == &init_net) {
@@ -125,74 +133,97 @@ static int flow_dissector_bpf_prog_attach(struct net *net,
 		for_each_net(ns) {
 			if (ns == &init_net)
 				continue;
-			if (rcu_access_pointer(ns->flow_dissector_prog))
+			if (rcu_access_pointer(ns->bpf.progs[type]))
 				return -EEXIST;
 		}
 	} else {
 		/* Make sure root flow dissector is not attached
 		 * when attaching to the non-root namespace.
 		 */
-		if (rcu_access_pointer(init_net.flow_dissector_prog))
+		if (rcu_access_pointer(init_net.bpf.progs[type]))
 			return -EEXIST;
 	}
 
-	attached = rcu_dereference_protected(net->flow_dissector_prog,
-					     lockdep_is_held(&flow_dissector_mutex));
+	attached = rcu_dereference_protected(net->bpf.progs[type],
+					     lockdep_is_held(&netns_bpf_mutex));
 	if (attached == prog)
 		/* The same program cannot be attached twice */
 		return -EINVAL;
 
-	rcu_assign_pointer(net->flow_dissector_prog, prog);
+	rcu_assign_pointer(net->bpf.progs[type], prog);
 	if (attached)
 		bpf_prog_put(attached);
 	return 0;
 }
 
-int skb_flow_dissector_bpf_prog_attach(const union bpf_attr *attr,
-				       struct bpf_prog *prog)
+int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
+	enum netns_bpf_attach_type type;
+	struct net *net;
 	int ret;
 
-	mutex_lock(&flow_dissector_mutex);
-	ret = flow_dissector_bpf_prog_attach(current->nsproxy->net_ns, prog);
-	mutex_unlock(&flow_dissector_mutex);
+	type = to_netns_bpf_attach_type(attr->attach_type);
+	if (type < 0)
+		return -EINVAL;
+
+	net = current->nsproxy->net_ns;
+	mutex_lock(&netns_bpf_mutex);
+	switch (type) {
+	case NETNS_BPF_FLOW_DISSECTOR:
+		ret = flow_dissector_bpf_prog_attach(net, prog);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	mutex_unlock(&netns_bpf_mutex);
 
 	return ret;
 }
 
-static int flow_dissector_bpf_prog_detach(struct net *net)
+/* Must be called with netns_bpf_mutex held. */
+static int __netns_bpf_prog_detach(struct net *net,
+				   enum netns_bpf_attach_type type)
 {
 	struct bpf_prog *attached;
 
-	mutex_lock(&flow_dissector_mutex);
-	attached = rcu_dereference_protected(net->flow_dissector_prog,
-					     lockdep_is_held(&flow_dissector_mutex));
-	if (!attached) {
-		mutex_unlock(&flow_dissector_mutex);
+	attached = rcu_dereference_protected(net->bpf.progs[type],
+					     lockdep_is_held(&netns_bpf_mutex));
+	if (!attached)
 		return -ENOENT;
-	}
-	RCU_INIT_POINTER(net->flow_dissector_prog, NULL);
+	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
 	bpf_prog_put(attached);
-	mutex_unlock(&flow_dissector_mutex);
 	return 0;
 }
 
-int skb_flow_dissector_bpf_prog_detach(const union bpf_attr *attr)
+int netns_bpf_prog_detach(const union bpf_attr *attr)
 {
-	return flow_dissector_bpf_prog_detach(current->nsproxy->net_ns);
+	enum netns_bpf_attach_type type;
+	int ret;
+
+	type = to_netns_bpf_attach_type(attr->attach_type);
+	if (type < 0)
+		return -EINVAL;
+
+	mutex_lock(&netns_bpf_mutex);
+	ret = __netns_bpf_prog_detach(current->nsproxy->net_ns, type);
+	mutex_unlock(&netns_bpf_mutex);
+
+	return ret;
 }
 
-static void __net_exit flow_dissector_pernet_pre_exit(struct net *net)
+static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 {
-	/* We're not racing with attach/detach because there are no
-	 * references to netns left when pre_exit gets called.
-	 */
-	if (rcu_access_pointer(net->flow_dissector_prog))
-		flow_dissector_bpf_prog_detach(net);
+	enum netns_bpf_attach_type type;
+
+	mutex_lock(&netns_bpf_mutex);
+	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++)
+		__netns_bpf_prog_detach(net, type);
+	mutex_unlock(&netns_bpf_mutex);
 }
 
-static struct pernet_operations flow_dissector_pernet_ops __net_initdata = {
-	.pre_exit = flow_dissector_pernet_pre_exit,
+static struct pernet_operations netns_bpf_pernet_ops __net_initdata = {
+	.pre_exit = netns_bpf_pernet_pre_exit,
 };
 
 /**
@@ -1030,11 +1061,13 @@ bool __skb_flow_dissect(const struct net *net,
 
 	WARN_ON_ONCE(!net);
 	if (net) {
+		enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
+
 		rcu_read_lock();
-		attached = rcu_dereference(init_net.flow_dissector_prog);
+		attached = rcu_dereference(init_net.bpf.progs[type]);
 
 		if (!attached)
-			attached = rcu_dereference(net->flow_dissector_prog);
+			attached = rcu_dereference(net->bpf.progs[type]);
 
 		if (attached) {
 			struct bpf_flow_keys flow_keys;
@@ -1853,6 +1886,6 @@ static int __init init_default_flow_dissectors(void)
 				flow_keys_basic_dissector_keys,
 				ARRAY_SIZE(flow_keys_basic_dissector_keys));
 
-	return register_pernet_subsys(&flow_dissector_pernet_ops);
+	return register_pernet_subsys(&netns_bpf_pernet_ops);
 }
 core_initcall(init_default_flow_dissectors);
-- 
2.25.4

