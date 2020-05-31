Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63DB1E9643
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgEaI3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgEaI25 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:28:57 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BF5C061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:56 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id o26so2041716edq.0
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JqeOcTfxi+/jEUTSGvuPpEWYGbHJY96rjpElGQgfkI0=;
        b=Iu2GiqUZ1zYG+lnKE7a7iMP2qLb+DMjOPsgen/hwVoKmwf+1wbfwKtk594FXuCuzdF
         h6Rr2M0ge+LVp1PvPaWD3GkKXwMxJAlqSPAPD3jhXW5N3JYaAfMZD5W0mbf5SbcrkiQn
         nNYppZWoHk5bsGegKledniV6LuVS6TUbroFCU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JqeOcTfxi+/jEUTSGvuPpEWYGbHJY96rjpElGQgfkI0=;
        b=aPCOJLj99dJv1DMlEvKK0oWoCXloJw8FWncwkbb+emJB41tktXSPYm+1Crnf8OGhCn
         0sP6lfniAR5inosbV+J0hhV5OHwBHzQJgllnvjvm3D2/wRiOZ4cS+c99toZaqZQPhpG1
         M/0Mk4uHGLLWv4GuDZjPhhG0yHK5+YJ4deK5mNeyy9fIa2RPDLx3VzUCNT4Okx9bh+qF
         ud0EYhNjAMsYWNiCT6kczjJZLIZiEBPk+bkff7slN+qAa99WVV7dCquqJX3piWiEEzHg
         afbDrpn8HTVJ/D2YTg1RUuJxZ4IYdVP3stcZJTJ7R+RujI17tprE084gTbP53TITSQaB
         Ww1A==
X-Gm-Message-State: AOAM531uc3RAZH1CH/E3tjAyZBliTZafmZm+ZzygZZTxdLoDLslggv3x
        /vE+BbSrSyasBL64vZTiMtsMTg==
X-Google-Smtp-Source: ABdhPJyf4y5uE1SQQDB4d8HOb8eBOedANSlbwdP6aXnI39b8+jSChqJKxweiXzuXvNOhItXaLOUtGA==
X-Received: by 2002:a05:6402:31b1:: with SMTP id dj17mr16470669edb.142.1590913735125;
        Sun, 31 May 2020 01:28:55 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id m8sm11788196ejk.100.2020.05.31.01.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:28:54 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 03/12] flow_dissector: Move out netns_bpf prog callbacks
Date:   Sun, 31 May 2020 10:28:37 +0200
Message-Id: <20200531082846.2117903-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
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
netns attached programs. This patch prepares ground by creating a place
for it.

This is a code move with no functional changes intended.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/flow_dissector.h |   6 ++
 kernel/bpf/Makefile          |   1 +
 kernel/bpf/net_namespace.c   | 133 +++++++++++++++++++++++++++++++++++
 net/core/flow_dissector.c    | 125 ++------------------------------
 4 files changed, 144 insertions(+), 121 deletions(-)
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
index 8fca02f64811..1131a921e1a6 100644
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
index 000000000000..b37d81450c3a
--- /dev/null
+++ b/kernel/bpf/net_namespace.c
@@ -0,0 +1,133 @@
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
+/* Must be called with netns_bpf_mutex held. */
+static int __netns_bpf_prog_detach(struct net *net,
+				   enum netns_bpf_attach_type type)
+{
+	struct bpf_prog *attached;
+
+	attached = rcu_dereference_protected(net->bpf.progs[type],
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
+	mutex_lock(&netns_bpf_mutex);
+	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++)
+		__netns_bpf_prog_detach(net, type);
+	mutex_unlock(&netns_bpf_mutex);
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
index 91e2f5a1f8ad..9a42ac5114e3 100644
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
@@ -155,76 +108,7 @@ static int flow_dissector_bpf_prog_attach(struct net *net,
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
-/* Must be called with netns_bpf_mutex held. */
-static int __netns_bpf_prog_detach(struct net *net,
-				   enum netns_bpf_attach_type type)
-{
-	struct bpf_prog *attached;
-
-	attached = rcu_dereference_protected(net->bpf.progs[type],
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
-	mutex_lock(&netns_bpf_mutex);
-	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++)
-		__netns_bpf_prog_detach(net, type);
-	mutex_unlock(&netns_bpf_mutex);
-}
-
-static struct pernet_operations netns_bpf_pernet_ops __net_initdata = {
-	.pre_exit = netns_bpf_pernet_pre_exit,
-};
+#endif /* CONFIG_BPF_SYSCALL */
 
 /**
  * __skb_flow_get_ports - extract the upper layer ports and return them
@@ -1885,7 +1769,6 @@ static int __init init_default_flow_dissectors(void)
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

