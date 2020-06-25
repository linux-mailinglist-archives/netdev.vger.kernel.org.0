Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3FF120A0B1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405399AbgFYOOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405366AbgFYOOG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:14:06 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302F1C08C5DC
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:06 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y11so6669192ljm.9
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MQPngL9TiDnLWfORRYBLFIi1xFMCbQlZKd+Xog1DvxE=;
        b=u2+ylto/ovSGT5iefFuJsUGRzvGZLtwZaNCsGBgtB2hTuuI8GVjS/h41uJXFAlHW+N
         nHgU0w9tp4b8YGYV2tDXG+PDkykvyeC2cfCRvDyS1Dn0HOMZq/qtJ8taOsEUujnWgfbN
         9nWN+7C6N5Wljd5a3xBFs9Oyetv6qrkBvFW7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MQPngL9TiDnLWfORRYBLFIi1xFMCbQlZKd+Xog1DvxE=;
        b=JzxcNk3Sg52Am6bqaFxsLE86+smJFSscOHNbmsfQ/ItbYENkmvzpOQy4c4+3Dt+fjF
         f1Za67KUrhqhDVD3MHX1pXvvaSFEl3tpRBAkLHipFVlYuaiIU0ueIw6uw6JTV3EhxOEc
         26lQIPA91/kCnW5LgiSujzuuF9sSmVrH+bFh6Dqf1275OFuFIBiksQMiunVjLozIsV2b
         Be3aTxpY24hlnxLI/TwPe9TJJGzZeZx7BZ46WgpIg5CYz8sMuereeH6PzHr6cLLxsdeV
         K2vrWwf+VWkKMyeSLB27LixFYZYEb6CiUB70f89sPbjLqIO8uLkq/uiqaylo6d5KA8Lo
         0pgQ==
X-Gm-Message-State: AOAM532D4snopSq6X1U7xmJV60Mz5uRcbfNXr15T/qpk/Ac8KAbiF9/7
        BkMSC5LvdSgd4w6rN9+Tvu/wrpCg1KAn+Q==
X-Google-Smtp-Source: ABdhPJxQOekBLwIU8lBZQFf1Hxrb9rQaWgLeZXy61XCUyHu9B470HBm0dUbxZtrIhSBQLRsce3pBKw==
X-Received: by 2002:a2e:8150:: with SMTP id t16mr16595105ljg.160.1593094444556;
        Thu, 25 Jun 2020 07:14:04 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id w20sm4817269ljo.68.2020.06.25.07.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 07:14:03 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v3 2/4] bpf, netns: Keep attached programs in bpf_prog_array
Date:   Thu, 25 Jun 2020 16:13:55 +0200
Message-Id: <20200625141357.910330-3-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200625141357.910330-1-jakub@cloudflare.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prepare for having multi-prog attachments for new netns attach types by
storing programs to run in a bpf_prog_array, which is well suited for
iterating over programs and running them in sequence.

After this change bpf(PROG_QUERY) may block to allocate memory in
bpf_prog_array_copy_to_user() for collected program IDs. This forces a
change in how we protect access to the attached program in the query
callback. Because bpf_prog_array_copy_to_user() can sleep, we switch from
an RCU read lock to holding a mutex that serializes updaters.

Because we allow only one BPF flow_dissector program to be attached to
netns at all times, the bpf_prog_array pointed by net->bpf.run_array is
always either detached (null) or one element long.

No functional changes intended.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/netns/bpf.h    |   5 +-
 kernel/bpf/net_namespace.c | 120 +++++++++++++++++++++++++------------
 net/core/flow_dissector.c  |  19 +++---
 3 files changed, 96 insertions(+), 48 deletions(-)

diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
index a8dce2a380c8..a5015bda9979 100644
--- a/include/net/netns/bpf.h
+++ b/include/net/netns/bpf.h
@@ -9,9 +9,12 @@
 #include <linux/bpf-netns.h>
 
 struct bpf_prog;
+struct bpf_prog_array;
 
 struct netns_bpf {
-	struct bpf_prog __rcu *progs[MAX_NETNS_BPF_ATTACH_TYPE];
+	/* Array of programs to run compiled from progs or links */
+	struct bpf_prog_array __rcu *run_array[MAX_NETNS_BPF_ATTACH_TYPE];
+	struct bpf_prog *progs[MAX_NETNS_BPF_ATTACH_TYPE];
 	struct bpf_link *links[MAX_NETNS_BPF_ATTACH_TYPE];
 };
 
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index b951dab2687f..0dba97202357 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -33,6 +33,17 @@ static void __net_exit bpf_netns_link_auto_detach(struct bpf_link *link)
 	net_link->net = NULL;
 }
 
+/* Must be called with netns_bpf_mutex held. */
+static void netns_bpf_run_array_detach(struct net *net,
+				       enum netns_bpf_attach_type type)
+{
+	struct bpf_prog_array *run_array;
+
+	run_array = rcu_replace_pointer(net->bpf.run_array[type], NULL,
+					lockdep_is_held(&netns_bpf_mutex));
+	bpf_prog_array_free(run_array);
+}
+
 static void bpf_netns_link_release(struct bpf_link *link)
 {
 	struct bpf_netns_link *net_link =
@@ -54,8 +65,8 @@ static void bpf_netns_link_release(struct bpf_link *link)
 	if (!net)
 		goto out_unlock;
 
+	netns_bpf_run_array_detach(net, type);
 	net->bpf.links[type] = NULL;
-	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
 
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
@@ -76,6 +87,7 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 	struct bpf_netns_link *net_link =
 		container_of(link, struct bpf_netns_link, link);
 	enum netns_bpf_attach_type type = net_link->netns_type;
+	struct bpf_prog_array *run_array;
 	struct net *net;
 	int ret = 0;
 
@@ -93,8 +105,11 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 		goto out_unlock;
 	}
 
+	run_array = rcu_dereference_protected(net->bpf.run_array[type],
+					      lockdep_is_held(&netns_bpf_mutex));
+	WRITE_ONCE(run_array->items[0].prog, new_prog);
+
 	old_prog = xchg(&link->prog, new_prog);
-	rcu_assign_pointer(net->bpf.progs[type], new_prog);
 	bpf_prog_put(old_prog);
 
 out_unlock:
@@ -142,14 +157,38 @@ static const struct bpf_link_ops bpf_netns_link_ops = {
 	.show_fdinfo = bpf_netns_link_show_fdinfo,
 };
 
+/* Must be called with netns_bpf_mutex held. */
+static int __netns_bpf_prog_query(const union bpf_attr *attr,
+				  union bpf_attr __user *uattr,
+				  struct net *net,
+				  enum netns_bpf_attach_type type)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	struct bpf_prog_array *run_array;
+	u32 prog_cnt = 0, flags = 0;
+
+	run_array = rcu_dereference_protected(net->bpf.run_array[type],
+					      lockdep_is_held(&netns_bpf_mutex));
+	if (run_array)
+		prog_cnt = bpf_prog_array_length(run_array);
+
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
+		return -EFAULT;
+	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
+		return 0;
+
+	return bpf_prog_array_copy_to_user(run_array, prog_ids,
+					   attr->query.prog_cnt);
+}
+
 int netns_bpf_prog_query(const union bpf_attr *attr,
 			 union bpf_attr __user *uattr)
 {
-	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
-	u32 prog_id, prog_cnt = 0, flags = 0;
 	enum netns_bpf_attach_type type;
-	struct bpf_prog *attached;
 	struct net *net;
+	int ret;
 
 	if (attr->query.query_flags)
 		return -EINVAL;
@@ -162,32 +201,17 @@ int netns_bpf_prog_query(const union bpf_attr *attr,
 	if (IS_ERR(net))
 		return PTR_ERR(net);
 
-	rcu_read_lock();
-	attached = rcu_dereference(net->bpf.progs[type]);
-	if (attached) {
-		prog_cnt = 1;
-		prog_id = attached->aux->id;
-	}
-	rcu_read_unlock();
+	mutex_lock(&netns_bpf_mutex);
+	ret = __netns_bpf_prog_query(attr, uattr, net, type);
+	mutex_unlock(&netns_bpf_mutex);
 
 	put_net(net);
-
-	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
-		return -EFAULT;
-	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
-		return -EFAULT;
-
-	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
-		return 0;
-
-	if (copy_to_user(prog_ids, &prog_id, sizeof(u32)))
-		return -EFAULT;
-
-	return 0;
+	return ret;
 }
 
 int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 {
+	struct bpf_prog_array *run_array;
 	enum netns_bpf_attach_type type;
 	struct bpf_prog *attached;
 	struct net *net;
@@ -217,14 +241,28 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	if (ret)
 		goto out_unlock;
 
-	attached = rcu_dereference_protected(net->bpf.progs[type],
-					     lockdep_is_held(&netns_bpf_mutex));
+	attached = net->bpf.progs[type];
 	if (attached == prog) {
 		/* The same program cannot be attached twice */
 		ret = -EINVAL;
 		goto out_unlock;
 	}
-	rcu_assign_pointer(net->bpf.progs[type], prog);
+
+	run_array = rcu_dereference_protected(net->bpf.run_array[type],
+					      lockdep_is_held(&netns_bpf_mutex));
+	if (run_array) {
+		WRITE_ONCE(run_array->items[0].prog, prog);
+	} else {
+		run_array = bpf_prog_array_alloc(1, GFP_KERNEL);
+		if (!run_array) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
+		run_array->items[0].prog = prog;
+		rcu_assign_pointer(net->bpf.run_array[type], run_array);
+	}
+
+	net->bpf.progs[type] = prog;
 	if (attached)
 		bpf_prog_put(attached);
 
@@ -244,11 +282,11 @@ static int __netns_bpf_prog_detach(struct net *net,
 	if (net->bpf.links[type])
 		return -EINVAL;
 
-	attached = rcu_dereference_protected(net->bpf.progs[type],
-					     lockdep_is_held(&netns_bpf_mutex));
+	attached = net->bpf.progs[type];
 	if (!attached)
 		return -ENOENT;
-	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
+	netns_bpf_run_array_detach(net, type);
+	net->bpf.progs[type] = NULL;
 	bpf_prog_put(attached);
 	return 0;
 }
@@ -272,7 +310,7 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
 static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 				 enum netns_bpf_attach_type type)
 {
-	struct bpf_prog *prog;
+	struct bpf_prog_array *run_array;
 	int err;
 
 	mutex_lock(&netns_bpf_mutex);
@@ -283,9 +321,7 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 		goto out_unlock;
 	}
 	/* Links are not compatible with attaching prog directly */
-	prog = rcu_dereference_protected(net->bpf.progs[type],
-					 lockdep_is_held(&netns_bpf_mutex));
-	if (prog) {
+	if (net->bpf.progs[type]) {
 		err = -EEXIST;
 		goto out_unlock;
 	}
@@ -301,7 +337,14 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 	if (err)
 		goto out_unlock;
 
-	rcu_assign_pointer(net->bpf.progs[type], link->prog);
+	run_array = bpf_prog_array_alloc(1, GFP_KERNEL);
+	if (!run_array) {
+		err = -ENOMEM;
+		goto out_unlock;
+	}
+	run_array->items[0].prog = link->prog;
+	rcu_assign_pointer(net->bpf.run_array[type], run_array);
+
 	net->bpf.links[type] = link;
 
 out_unlock:
@@ -368,11 +411,12 @@ static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 
 	mutex_lock(&netns_bpf_mutex);
 	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
+		netns_bpf_run_array_detach(net, type);
 		link = net->bpf.links[type];
 		if (link)
 			bpf_netns_link_auto_detach(link);
-		else
-			__netns_bpf_prog_detach(net, type);
+		else if (net->bpf.progs[type])
+			bpf_prog_put(net->bpf.progs[type]);
 	}
 	mutex_unlock(&netns_bpf_mutex);
 }
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index b57fb1359395..142a8824f0a8 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -86,14 +86,14 @@ int flow_dissector_bpf_prog_attach_check(struct net *net,
 		for_each_net(ns) {
 			if (ns == &init_net)
 				continue;
-			if (rcu_access_pointer(ns->bpf.progs[type]))
+			if (rcu_access_pointer(ns->bpf.run_array[type]))
 				return -EEXIST;
 		}
 	} else {
 		/* Make sure root flow dissector is not attached
 		 * when attaching to the non-root namespace.
 		 */
-		if (rcu_access_pointer(init_net.bpf.progs[type]))
+		if (rcu_access_pointer(init_net.bpf.run_array[type]))
 			return -EEXIST;
 	}
 
@@ -894,7 +894,6 @@ bool __skb_flow_dissect(const struct net *net,
 	struct flow_dissector_key_addrs *key_addrs;
 	struct flow_dissector_key_tags *key_tags;
 	struct flow_dissector_key_vlan *key_vlan;
-	struct bpf_prog *attached = NULL;
 	enum flow_dissect_ret fdret;
 	enum flow_dissector_key_id dissector_vlan = FLOW_DISSECTOR_KEY_MAX;
 	bool mpls_el = false;
@@ -951,14 +950,14 @@ bool __skb_flow_dissect(const struct net *net,
 	WARN_ON_ONCE(!net);
 	if (net) {
 		enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
+		struct bpf_prog_array *run_array;
 
 		rcu_read_lock();
-		attached = rcu_dereference(init_net.bpf.progs[type]);
+		run_array = rcu_dereference(init_net.bpf.run_array[type]);
+		if (!run_array)
+			run_array = rcu_dereference(net->bpf.run_array[type]);
 
-		if (!attached)
-			attached = rcu_dereference(net->bpf.progs[type]);
-
-		if (attached) {
+		if (run_array) {
 			struct bpf_flow_keys flow_keys;
 			struct bpf_flow_dissector ctx = {
 				.flow_keys = &flow_keys,
@@ -966,6 +965,7 @@ bool __skb_flow_dissect(const struct net *net,
 				.data_end = data + hlen,
 			};
 			__be16 n_proto = proto;
+			struct bpf_prog *prog;
 
 			if (skb) {
 				ctx.skb = skb;
@@ -976,7 +976,8 @@ bool __skb_flow_dissect(const struct net *net,
 				n_proto = skb->protocol;
 			}
 
-			ret = bpf_flow_dissect(attached, &ctx, n_proto, nhoff,
+			prog = READ_ONCE(run_array->items[0].prog);
+			ret = bpf_flow_dissect(prog, &ctx, n_proto, nhoff,
 					       hlen, flags);
 			__skb_flow_bpf_to_target(&flow_keys, flow_dissector,
 						 target_container);
-- 
2.25.4

