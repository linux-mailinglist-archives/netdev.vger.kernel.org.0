Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8ECB1E4B7A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731149AbgE0RIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731131AbgE0RIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:49 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25185C03E97D
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:49 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id s19so20849300edt.12
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ahk73YOLkvvyWYNMxGnkIqgt1nGRvSvFH7RHNXZ0uEw=;
        b=yMwj2pRf55N2y9Q+CDTDEsPGHWWn0C+hL1K5PqwdC2tegDWddI50xYnq5goVqcobvM
         n7ClDH5Wq3ADKW1kbS1q8D+1qVBIFOwR/jqcndidqd0V1feEi/pcuKpFDF2kZonaEiGY
         eDjolPjL3J/VJxp+f/EQoGaMvHZLqDMWVXoYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ahk73YOLkvvyWYNMxGnkIqgt1nGRvSvFH7RHNXZ0uEw=;
        b=VT4+Cev2O7uk/Roz5FtN2l5y1GNhJMuoq0oFzh9B5TqFqrr7aGGjLt1JXjSLWL8MLR
         a4niIHjr9+qLRREf/6ddZ1h0WVAtcXImTIkJCLQawUU7u+cRpzNVKS3ElmSP2LPELAom
         kizaapujuSr+mKnIySW2gy+xbQs9YSKI2H6Ra5SonWcMK1X18uOMtTS1w1uSL9niwYQB
         Xe5k5gj1llDWoX71gdEyDNRoGIUC10cojsQE0N9t+1LOfNAmgjCeGTqmh58YNSeqnd/p
         C5okE+Ro9i0vOFjS+cFXQDqBiYYCwJWN9rEHIqsvSEsaN3Z/mUlyWTMMjmNbRq1it0Vv
         XIlg==
X-Gm-Message-State: AOAM533QZYlq5eRTnmU7W9m4i/trLEe4C3d77FZGUmWOJfoHJr1dCJ2v
        sTv0LGfeGtDBLxNvqghf+KAJJw==
X-Google-Smtp-Source: ABdhPJwBDIdpZiJcwUtUgYDBGNfGLoDwQYI07xxyOYvNbZb0908lEoNEyk7sLecndvNtR1OeQdxA4A==
X-Received: by 2002:aa7:cb8d:: with SMTP id r13mr24600606edt.12.1590599327756;
        Wed, 27 May 2020 10:08:47 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id h20sm3260217eja.61.2020.05.27.10.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:47 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 4/8] flow_dissector: Move out netns_bpf prog callbacks
Date:   Wed, 27 May 2020 19:08:36 +0200
Message-Id: <20200527170840.1768178-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200527170840.1768178-1-jakub@cloudflare.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move functions to manage BPF programs attached to netns that are not
specific to flow dissector to a dedicated module named
bpf/net_namespace.c.

The set of functions will grow with the addition of bpf_link support for
netns attached programs. This patch prepares ground for it by creating a
place for it.

This is a code move with no functional changes intended.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/flow_dissector.h |   6 ++
 kernel/bpf/Makefile          |   1 +
 kernel/bpf/net_namespace.c   | 134 +++++++++++++++++++++++++++++++++++
 net/core/flow_dissector.c    | 126 ++------------------------------
 4 files changed, 145 insertions(+), 122 deletions(-)
 create mode 100644 kernel/bpf/net_namespace.c

diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
index 628383915827..9af143760e35 100644
--- a/include/net/flow_dissector.h
+++ b/include/net/flow_dissector.h
@@ -8,6 +8,8 @@
 #include <linux/string.h>
 #include <uapi/linux/if_ether.h>
 
+struct bpf_prog;
+struct net;
 struct sk_buff;
 
 /**
@@ -357,4 +359,8 @@ flow_dissector_init_keys(struct flow_dissector_key_control *key_control,
 	memset(key_basic, 0, sizeof(*key_basic));
 }
 
+#ifdef CONFIG_BPF_SYSCALL
+int flow_dissector_bpf_prog_attach(struct net *net, struct bpf_prog *prog);
+#endif /* CONFIG_BPF_SYSCALL */
+
 #endif
diff --git a/kernel/bpf/Makefile b/kernel/bpf/Makefile
index 375b933010dd..ccecb70bfaa0 100644
--- a/kernel/bpf/Makefile
+++ b/kernel/bpf/Makefile
@@ -13,6 +13,7 @@ ifeq ($(CONFIG_NET),y)
 obj-$(CONFIG_BPF_SYSCALL) += devmap.o
 obj-$(CONFIG_BPF_SYSCALL) += cpumap.o
 obj-$(CONFIG_BPF_SYSCALL) += offload.o
+obj-$(CONFIG_BPF_SYSCALL) += net_namespace.o
 endif
 ifeq ($(CONFIG_PERF_EVENTS),y)
 obj-$(CONFIG_BPF_SYSCALL) += stackmap.o
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
new file mode 100644
index 000000000000..fc89154aed27
--- /dev/null
+++ b/kernel/bpf/net_namespace.c
@@ -0,0 +1,134 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/bpf.h>
+#include <linux/filter.h>
+#include <net/net_namespace.h>
+
+/*
+ * Functions to manage BPF programs attached to netns
+ */
+
+/* Protects updates to netns_bpf */
+DEFINE_MUTEX(netns_bpf_mutex);
+
+int netns_bpf_prog_query(const union bpf_attr *attr,
+			 union bpf_attr __user *uattr)
+{
+	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
+	u32 prog_id, prog_cnt = 0, flags = 0;
+	enum netns_bpf_attach_type type;
+	struct bpf_prog *attached;
+	struct net *net;
+
+	if (attr->query.query_flags)
+		return -EINVAL;
+
+	type = to_netns_bpf_attach_type(attr->query.attach_type);
+	if (type < 0)
+		return -EINVAL;
+
+	net = get_net_ns_by_fd(attr->query.target_fd);
+	if (IS_ERR(net))
+		return PTR_ERR(net);
+
+	rcu_read_lock();
+	attached = rcu_dereference(net->bpf.progs[type]);
+	if (attached) {
+		prog_cnt = 1;
+		prog_id = attached->aux->id;
+	}
+	rcu_read_unlock();
+
+	put_net(net);
+
+	if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
+		return -EFAULT;
+	if (copy_to_user(&uattr->query.prog_cnt, &prog_cnt, sizeof(prog_cnt)))
+		return -EFAULT;
+
+	if (!attr->query.prog_cnt || !prog_ids || !prog_cnt)
+		return 0;
+
+	if (copy_to_user(prog_ids, &prog_id, sizeof(u32)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	enum netns_bpf_attach_type type;
+	struct net *net;
+	int ret;
+
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
+
+	return ret;
+}
+
+static int __netns_bpf_prog_detach(struct net *net,
+				   enum netns_bpf_attach_type type)
+{
+	struct bpf_prog *attached;
+
+	/* No need for update-side lock when net is going away. */
+	attached = rcu_dereference_protected(net->bpf.progs[type],
+					     !check_net(net) ||
+					     lockdep_is_held(&netns_bpf_mutex));
+	if (!attached)
+		return -ENOENT;
+	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
+	bpf_prog_put(attached);
+	return 0;
+}
+
+int netns_bpf_prog_detach(const union bpf_attr *attr)
+{
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
+}
+
+static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
+{
+	enum netns_bpf_attach_type type;
+
+	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
+		if (rcu_access_pointer(net->bpf.progs[type]))
+			__netns_bpf_prog_detach(net, type);
+	}
+}
+
+static struct pernet_operations netns_bpf_pernet_ops __net_initdata = {
+	.pre_exit = netns_bpf_pernet_pre_exit,
+};
+
+static int __init netns_bpf_init(void)
+{
+	return register_pernet_subsys(&netns_bpf_pernet_ops);
+}
+
+subsys_initcall(netns_bpf_init);
diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
index 5c978c87e6bc..9a42ac5114e3 100644
--- a/net/core/flow_dissector.c
+++ b/net/core/flow_dissector.c
@@ -33,9 +33,6 @@
 #endif
 #include <linux/bpf-netns.h>
 
-/* Protects updates to netns_bpf */
-DEFINE_MUTEX(netns_bpf_mutex);
-
 static void dissector_set_key(struct flow_dissector *flow_dissector,
 			      enum flow_dissector_key_id key_id)
 {
@@ -72,52 +69,8 @@ void skb_flow_dissector_init(struct flow_dissector *flow_dissector,
 }
 EXPORT_SYMBOL(skb_flow_dissector_init);
 
-int netns_bpf_prog_query(const union bpf_attr *attr,
-			 union bpf_attr __user *uattr)
-{
-	__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
-	u32 prog_id, prog_cnt = 0, flags = 0;
-	enum netns_bpf_attach_type type;
-	struct bpf_prog *attached;
-	struct net *net;
-
-	if (attr->query.query_flags)
-		return -EINVAL;
-
-	type = to_netns_bpf_attach_type(attr->query.attach_type);
-	if (type < 0)
-		return -EINVAL;
-
-	net = get_net_ns_by_fd(attr->query.target_fd);
-	if (IS_ERR(net))
-		return PTR_ERR(net);
-
-	rcu_read_lock();
-	attached = rcu_dereference(net->bpf.progs[type]);
-	if (attached) {
-		prog_cnt = 1;
-		prog_id = attached->aux->id;
-	}
-	rcu_read_unlock();
-
-	put_net(net);
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
-}
-
-static int flow_dissector_bpf_prog_attach(struct net *net,
-					  struct bpf_prog *prog)
+#ifdef CONFIG_BPF_SYSCALL
+int flow_dissector_bpf_prog_attach(struct net *net, struct bpf_prog *prog)
 {
 	enum netns_bpf_attach_type type = NETNS_BPF_FLOW_DISSECTOR;
 	struct bpf_prog *attached;
@@ -155,77 +108,7 @@ static int flow_dissector_bpf_prog_attach(struct net *net,
 		bpf_prog_put(attached);
 	return 0;
 }
-
-int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
-{
-	enum netns_bpf_attach_type type;
-	struct net *net;
-	int ret;
-
-	type = to_netns_bpf_attach_type(attr->attach_type);
-	if (type < 0)
-		return -EINVAL;
-
-	net = current->nsproxy->net_ns;
-	mutex_lock(&netns_bpf_mutex);
-	switch (type) {
-	case NETNS_BPF_FLOW_DISSECTOR:
-		ret = flow_dissector_bpf_prog_attach(net, prog);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
-	mutex_unlock(&netns_bpf_mutex);
-
-	return ret;
-}
-
-static int __netns_bpf_prog_detach(struct net *net,
-				   enum netns_bpf_attach_type type)
-{
-	struct bpf_prog *attached;
-
-	/* No need for update-side lock when net is going away. */
-	attached = rcu_dereference_protected(net->bpf.progs[type],
-					     !check_net(net) ||
-					     lockdep_is_held(&netns_bpf_mutex));
-	if (!attached)
-		return -ENOENT;
-	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
-	bpf_prog_put(attached);
-	return 0;
-}
-
-int netns_bpf_prog_detach(const union bpf_attr *attr)
-{
-	enum netns_bpf_attach_type type;
-	int ret;
-
-	type = to_netns_bpf_attach_type(attr->attach_type);
-	if (type < 0)
-		return -EINVAL;
-
-	mutex_lock(&netns_bpf_mutex);
-	ret = __netns_bpf_prog_detach(current->nsproxy->net_ns, type);
-	mutex_unlock(&netns_bpf_mutex);
-
-	return ret;
-}
-
-static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
-{
-	enum netns_bpf_attach_type type;
-
-	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
-		if (rcu_access_pointer(net->bpf.progs[type]))
-			__netns_bpf_prog_detach(net, type);
-	}
-}
-
-static struct pernet_operations netns_bpf_pernet_ops __net_initdata = {
-	.pre_exit = netns_bpf_pernet_pre_exit,
-};
+#endif /* CONFIG_BPF_SYSCALL */
 
 /**
  * __skb_flow_get_ports - extract the upper layer ports and return them
@@ -1886,7 +1769,6 @@ static int __init init_default_flow_dissectors(void)
 	skb_flow_dissector_init(&flow_keys_basic_dissector,
 				flow_keys_basic_dissector_keys,
 				ARRAY_SIZE(flow_keys_basic_dissector_keys));
-
-	return register_pernet_subsys(&netns_bpf_pernet_ops);
+	return 0;
 }
 core_initcall(init_default_flow_dissectors);
-- 
2.25.4

