Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7633E1E9645
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 10:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbgEaI3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 04:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727776AbgEaI26 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 04:28:58 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EAEC03E969
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:58 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id h21so6291375ejq.5
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 01:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RSFhg9HspNeJ3qQOPsunC8GvqiYYfETJuK2zjtAXCog=;
        b=YF8P548NAD+jZfUBP0mCAXFUuMR2L1wRooR2W+KqdvHO5UB8K6uzWv8q7twYzBLbYE
         7cUygW1Qrey/alyDp0uRzXxGAu+ThkM5sdHXcJ/3hf3Te/ItmeMQHqNhPcJisUwSJ5dn
         +x5UpQ7BtBV4X197/pvMotyxDaH10TBJiknho=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RSFhg9HspNeJ3qQOPsunC8GvqiYYfETJuK2zjtAXCog=;
        b=JIZY324R5rZLr7TqBcDHUwd4XHrITIiss7kv+1znpTeS+enRMDVkkXp7CHXxaShm6L
         FGgp9a7I16MQZNptoaVhvZI7vC3ixErJKfZR+7HkTTKG+oQEsHE9p0jokScyivP4V8Z2
         JeaVGDwYNxxaXXD+GSwipICMRu7gbwtVXcYD47eXjXHzwIxyice1GO9iUFFNbX3nS/uz
         wO9ViJknapkThNDMDGhivmtOJ3qH5tUZ6rVndKv7fylR1ZbLAAWKYNVxRuNIk78O1YPP
         LzKrluJZJhgXFgXdbZbnodS4okkSfCVYOSDLOOX3gzeGc0zwmJut0eZVbmNM6OB9tdMk
         yVmw==
X-Gm-Message-State: AOAM530qxgpxoGInG86k5+BFnq/UvjSmu9yBeJgPCH4G3Jci3ym+WbFU
        36wddUUSNVQ7TcrCjzGVTmwCeGPdNEk=
X-Google-Smtp-Source: ABdhPJxzsNHO7BMVbdl2mdjoWW1FCIxgwhPW0u7xqFA903rbPD+Cqw/x6Mnmv1ZnDpUmvayLE8082w==
X-Received: by 2002:a17:906:f28c:: with SMTP id gu12mr418090ejb.64.1590913736961;
        Sun, 31 May 2020 01:28:56 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id j21sm5999792ejv.36.2020.05.31.01.28.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 01:28:56 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next v2 04/12] bpf: Add link-based BPF program attachment to network namespace
Date:   Sun, 31 May 2020 10:28:38 +0200
Message-Id: <20200531082846.2117903-5-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200531082846.2117903-1-jakub@cloudflare.com>
References: <20200531082846.2117903-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend bpf() syscall subcommands that operate on bpf_link, that is
LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO, to accept attach types tied to
network namespaces (only flow dissector at the moment).

Link-based and prog-based attachment can be used interchangeably, but only
one can exist at a time. Attempts to attach a link when a prog is already
attached directly, and the other way around, will be met with -EEXIST.
Attempts to detach a program when link exists result in -EINVAL.

Attachment of multiple links of same attach type to one netns is not
supported with the intention to lift the restriction when a use-case
presents itself. Because of that link create returns -E2BIG when trying to
create another netns link, when one already exists.

Link-based attachments to netns don't keep a netns alive by holding a ref
to it. Instead links get auto-detached from netns when the latter is being
destroyed, using a pernet pre_exit callback.

When auto-detached, link lives in defunct state as long there are open FDs
for it. -ENOLINK is returned if a user tries to update a defunct link.

Because bpf_link to netns doesn't hold a ref to struct net, special care is
taken when releasing, updating, or filling link info. The netns might be
getting torn down when any of these link operations are in progress. That
is why auto-detach and update/release/fill_info are synchronized by the
same mutex. Also, link ops have to always check if auto-detach has not
happened yet and if netns is still alive (refcnt > 0).

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/bpf-netns.h      |   8 ++
 include/linux/bpf_types.h      |   3 +
 include/net/netns/bpf.h        |   1 +
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/net_namespace.c     | 244 ++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c           |   3 +
 tools/include/uapi/linux/bpf.h |   5 +
 7 files changed, 267 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf-netns.h b/include/linux/bpf-netns.h
index f3aec3d79824..4052d649f36d 100644
--- a/include/linux/bpf-netns.h
+++ b/include/linux/bpf-netns.h
@@ -34,6 +34,8 @@ int netns_bpf_prog_query(const union bpf_attr *attr,
 int netns_bpf_prog_attach(const union bpf_attr *attr,
 			  struct bpf_prog *prog);
 int netns_bpf_prog_detach(const union bpf_attr *attr);
+int netns_bpf_link_create(const union bpf_attr *attr,
+			  struct bpf_prog *prog);
 #else
 static inline int netns_bpf_prog_query(const union bpf_attr *attr,
 				       union bpf_attr __user *uattr)
@@ -51,6 +53,12 @@ static inline int netns_bpf_prog_detach(const union bpf_attr *attr)
 {
 	return -EOPNOTSUPP;
 }
+
+static inline int netns_bpf_link_create(const union bpf_attr *attr,
+					struct bpf_prog *prog)
+{
+	return -EOPNOTSUPP;
+}
 #endif
 
 #endif /* _BPF_NETNS_H */
diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index fa8e1b552acd..a18ae82a298a 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -126,3 +126,6 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_TRACING, tracing)
 BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
 #endif
 BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
+#ifdef CONFIG_NET
+BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
+#endif
diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
index a858d1c5b166..a8dce2a380c8 100644
--- a/include/net/netns/bpf.h
+++ b/include/net/netns/bpf.h
@@ -12,6 +12,7 @@ struct bpf_prog;
 
 struct netns_bpf {
 	struct bpf_prog __rcu *progs[MAX_NETNS_BPF_ATTACH_TYPE];
+	struct bpf_link *links[MAX_NETNS_BPF_ATTACH_TYPE];
 };
 
 #endif /* __NETNS_BPF_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 974ca6e948e3..d73d3d6596da 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -236,6 +236,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_TRACING = 2,
 	BPF_LINK_TYPE_CGROUP = 3,
 	BPF_LINK_TYPE_ITER = 4,
+	BPF_LINK_TYPE_NETNS = 5,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -3835,6 +3836,10 @@ struct bpf_link_info {
 			__u64 cgroup_id;
 			__u32 attach_type;
 		} cgroup;
+		struct  {
+			__u32 netns_ino;
+			__u32 attach_type;
+		} netns;
 	};
 } __attribute__((aligned(8)));
 
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index b37d81450c3a..78cf061f8179 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -8,9 +8,140 @@
  * Functions to manage BPF programs attached to netns
  */
 
+struct bpf_netns_link {
+	struct bpf_link	link;
+	enum bpf_attach_type type;
+	enum netns_bpf_attach_type netns_type;
+
+	/* We don't hold a ref to net in order to auto-detach the link
+	 * when netns is going away. Instead we rely on pernet
+	 * pre_exit callback to clear this pointer. Must be accessed
+	 * with netns_bpf_mutex held.
+	 */
+	struct net *net;
+};
+
 /* Protects updates to netns_bpf */
 DEFINE_MUTEX(netns_bpf_mutex);
 
+/* Must be called with netns_bpf_mutex held. */
+static void __net_exit bpf_netns_link_auto_detach(struct bpf_link *link)
+{
+	struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
+
+	net_link->net = NULL;
+}
+
+static void bpf_netns_link_release(struct bpf_link *link)
+{
+	struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
+	enum netns_bpf_attach_type type = net_link->netns_type;
+	struct net *net;
+
+	/* Link auto-detached by dying netns. */
+	if (!net_link->net)
+		return;
+
+	mutex_lock(&netns_bpf_mutex);
+
+	/* Recheck after potential sleep. We can race with cleanup_net
+	 * here, but if we see a non-NULL struct net pointer pre_exit
+	 * has not happened yet and will block on netns_bpf_mutex.
+	 */
+	net = net_link->net;
+	if (!net)
+		goto out_unlock;
+
+	net->bpf.links[type] = NULL;
+	RCU_INIT_POINTER(net->bpf.progs[type], NULL);
+
+out_unlock:
+	mutex_unlock(&netns_bpf_mutex);
+}
+
+static void bpf_netns_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
+
+	kfree(net_link);
+}
+
+static int bpf_netns_link_update_prog(struct bpf_link *link,
+				      struct bpf_prog *new_prog,
+				      struct bpf_prog *old_prog)
+{
+	struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
+	enum netns_bpf_attach_type type = net_link->netns_type;
+	struct net *net;
+	int ret = 0;
+
+	if (old_prog && old_prog != link->prog)
+		return -EPERM;
+	if (new_prog->type != link->prog->type)
+		return -EINVAL;
+
+	mutex_lock(&netns_bpf_mutex);
+
+	net = net_link->net;
+	if (!net || !check_net(net)) {
+		/* Link auto-detached or netns dying */
+		ret = -ENOLINK;
+		goto out_unlock;
+	}
+
+	old_prog = xchg(&link->prog, new_prog);
+	rcu_assign_pointer(net->bpf.progs[type], new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	mutex_unlock(&netns_bpf_mutex);
+	return ret;
+}
+
+static int bpf_netns_link_fill_info(const struct bpf_link *link,
+				    struct bpf_link_info *info)
+{
+	const struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
+	unsigned int inum = 0;
+	struct net *net;
+
+	mutex_lock(&netns_bpf_mutex);
+	net = net_link->net;
+	if (net && check_net(net))
+		inum = net->ns.inum;
+	mutex_unlock(&netns_bpf_mutex);
+
+	info->netns.netns_ino = inum;
+	info->netns.attach_type = net_link->type;
+	return 0;
+}
+
+static void bpf_netns_link_show_fdinfo(const struct bpf_link *link,
+				       struct seq_file *seq)
+{
+	struct bpf_link_info info = {};
+
+	bpf_netns_link_fill_info(link, &info);
+	seq_printf(seq,
+		   "netns_ino:\t%u\n"
+		   "attach_type:\t%u\n",
+		   info.netns.netns_ino,
+		   info.netns.attach_type);
+}
+
+static const struct bpf_link_ops bpf_netns_link_ops = {
+	.release = bpf_netns_link_release,
+	.dealloc = bpf_netns_link_dealloc,
+	.update_prog = bpf_netns_link_update_prog,
+	.fill_link_info = bpf_netns_link_fill_info,
+	.show_fdinfo = bpf_netns_link_show_fdinfo,
+};
+
 int netns_bpf_prog_query(const union bpf_attr *attr,
 			 union bpf_attr __user *uattr)
 {
@@ -67,6 +198,13 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 
 	net = current->nsproxy->net_ns;
 	mutex_lock(&netns_bpf_mutex);
+
+	/* Attaching prog directly is not compatible with links */
+	if (net->bpf.links[type]) {
+		ret = -EEXIST;
+		goto out_unlock;
+	}
+
 	switch (type) {
 	case NETNS_BPF_FLOW_DISSECTOR:
 		ret = flow_dissector_bpf_prog_attach(net, prog);
@@ -75,6 +213,7 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		ret = -EINVAL;
 		break;
 	}
+out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 
 	return ret;
@@ -86,6 +225,10 @@ static int __netns_bpf_prog_detach(struct net *net,
 {
 	struct bpf_prog *attached;
 
+	/* Progs attached via links cannot be detached */
+	if (net->bpf.links[type])
+		return -EINVAL;
+
 	attached = rcu_dereference_protected(net->bpf.progs[type],
 					     lockdep_is_held(&netns_bpf_mutex));
 	if (!attached)
@@ -111,13 +254,110 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
 	return ret;
 }
 
+static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
+				 enum netns_bpf_attach_type type)
+{
+	struct bpf_prog *prog;
+	int err;
+
+	mutex_lock(&netns_bpf_mutex);
+
+	/* Allow attaching only one prog or link for now */
+	if (net->bpf.links[type]) {
+		err = -E2BIG;
+		goto out_unlock;
+	}
+	/* Links are not compatible with attaching prog directly */
+	prog = rcu_dereference_protected(net->bpf.progs[type],
+					 lockdep_is_held(&netns_bpf_mutex));
+	if (prog) {
+		err = -EEXIST;
+		goto out_unlock;
+	}
+
+	switch (type) {
+	case NETNS_BPF_FLOW_DISSECTOR:
+		err = flow_dissector_bpf_prog_attach(net, link->prog);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	if (err)
+		goto out_unlock;
+
+	net->bpf.links[type] = link;
+
+out_unlock:
+	mutex_unlock(&netns_bpf_mutex);
+	return err;
+}
+
+int netns_bpf_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
+{
+	enum netns_bpf_attach_type netns_type;
+	struct bpf_link_primer link_primer;
+	struct bpf_netns_link *net_link;
+	enum bpf_attach_type type;
+	struct net *net;
+	int err;
+
+	if (attr->link_create.flags)
+		return -EINVAL;
+
+	type = attr->link_create.attach_type;
+	netns_type = to_netns_bpf_attach_type(type);
+	if (netns_type < 0)
+		return -EINVAL;
+
+	net = get_net_ns_by_fd(attr->link_create.target_fd);
+	if (IS_ERR(net))
+		return PTR_ERR(net);
+
+	net_link = kzalloc(sizeof(*net_link), GFP_USER);
+	if (!net_link) {
+		err = -ENOMEM;
+		goto out_put_net;
+	}
+	bpf_link_init(&net_link->link, BPF_LINK_TYPE_NETNS,
+		      &bpf_netns_link_ops, prog);
+	net_link->net = net;
+	net_link->type = type;
+	net_link->netns_type = netns_type;
+
+	err = bpf_link_prime(&net_link->link, &link_primer);
+	if (err) {
+		kfree(net_link);
+		goto out_put_net;
+	}
+
+	err = netns_bpf_link_attach(net, &net_link->link, netns_type);
+	if (err) {
+		bpf_link_cleanup(&link_primer);
+		goto out_put_net;
+	}
+
+	put_net(net);
+	return bpf_link_settle(&link_primer);
+
+out_put_net:
+	put_net(net);
+	return err;
+}
+
 static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 {
 	enum netns_bpf_attach_type type;
+	struct bpf_link *link;
 
 	mutex_lock(&netns_bpf_mutex);
-	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++)
-		__netns_bpf_prog_detach(net, type);
+	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
+		link = net->bpf.links[type];
+		if (link)
+			bpf_netns_link_auto_detach(link);
+		else
+			__netns_bpf_prog_detach(net, type);
+	}
 	mutex_unlock(&netns_bpf_mutex);
 }
 
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 5b2ae498cc3f..988ec43a4f39 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3887,6 +3887,9 @@ static int link_create(union bpf_attr *attr)
 	case BPF_PROG_TYPE_TRACING:
 		ret = tracing_bpf_link_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+		ret = netns_bpf_link_create(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 974ca6e948e3..d73d3d6596da 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -236,6 +236,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_TRACING = 2,
 	BPF_LINK_TYPE_CGROUP = 3,
 	BPF_LINK_TYPE_ITER = 4,
+	BPF_LINK_TYPE_NETNS = 5,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -3835,6 +3836,10 @@ struct bpf_link_info {
 			__u64 cgroup_id;
 			__u32 attach_type;
 		} cgroup;
+		struct  {
+			__u32 netns_ino;
+			__u32 attach_type;
+		} netns;
 	};
 } __attribute__((aligned(8)));
 
-- 
2.25.4

