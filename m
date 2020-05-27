Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D321E4B78
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 19:08:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731135AbgE0RIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 13:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731140AbgE0RIv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 13:08:51 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E3FC08C5C1
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:50 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id d7so28972632eja.7
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 10:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NRufhQKkMUDdRL0tS4oIuBxx8mnNfg6jqoiG3Ma23lg=;
        b=MQOsyiqM6QuArvMLYfUm0pmhyAiOnNoZdx4b64niy2pQzp0hlf+qZeCkhwDi5sQkmZ
         ckhkhOPF6wkX8RIOJve7CJvVtWO1RlNSDiXaaIYZ/Zzozw9magS9zZYWxIZZ/6OMf/oC
         nLXgeUh1imIQni0P7/Mkyi/D7aVyhRnJ93qFw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NRufhQKkMUDdRL0tS4oIuBxx8mnNfg6jqoiG3Ma23lg=;
        b=r2tYFL6LFmwdxkvOiXK+tFpP2oBqYspxROIb2TtY0MwYEXsB2SAonuBuRL/44TTrNu
         qG30W5djS5Jm8ti7jg45uIchTAzTneJxoIR4F+b5jYlfJ7yr8GSWcX7W/XzmjHeotzYE
         D3LtC1eJPmvXUfS33gVDNPvdUs3Df2xM+sweLB5EygUmbGylyD3Cp+TVDKsCPK4B0sW8
         rhhZ6HKlTEdEK14Y3yxvITvBPiKUtOIzP/H8qK+QMe/netJEk7wa8jj95gssctc8vJ/q
         3svxiRTkQ1r6L1eIB5lkWwl+s30AuM3rgeEg9HJSq1xSmVzE8jgwotB8Sv7gcDXYNAfB
         HmEQ==
X-Gm-Message-State: AOAM532YMc0d+1xtW89W4E9jWaYA7HMi4FusR2/Q77Aw30NZY3R5SXoJ
        YTM6B+6VhTEh5KOwYJDbGcXC3w==
X-Google-Smtp-Source: ABdhPJxfwrVTIeSYabZaNBbvTE70ml2+QR5ey8wuFPtHHojXXqc4feYF8LHWggETcYigSIGDQZCXrQ==
X-Received: by 2002:a17:906:934e:: with SMTP id p14mr6902961ejw.502.1590599329360;
        Wed, 27 May 2020 10:08:49 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id s19sm3336713eja.91.2020.05.27.10.08.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 10:08:48 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 5/8] bpf: Add link-based BPF program attachment to network namespace
Date:   Wed, 27 May 2020 19:08:37 +0200
Message-Id: <20200527170840.1768178-6-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200527170840.1768178-1-jakub@cloudflare.com>
References: <20200527170840.1768178-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for bpf() syscall subcommands that operate on
bpf_link (LINK_CREATE, LINK_UPDATE, OBJ_GET_INFO) for attach points tied to
network namespaces (that is flow dissector at the moment).

Link-based and prog-based attachment can be used interchangeably, but only
one can be in use at a time. Attempts to attach a link when a prog is
already attached directly, and the other way around, will be met with
-EBUSY.

Attachment of multiple links of same attach type to one netns is not
supported, with the intention to lift it when a use-case presents
itself. Because of that attempts to create a netns link, when one already
exists result in -E2BIG error, signifying that there is no space left for
another attachment.

Link-based attachments to netns don't keep a netns alive by holding a ref
to it. Instead links get auto-detached from netns when the latter is being
destroyed by a pernet pre_exit callback.

When auto-detached, link lives in defunct state as long there are open FDs
for it. -ENOLINK is returned if a user tries to update a defunct link.

Because bpf_link to netns doesn't hold a ref to struct net, special care is
taken when releasing the link. The netns might be getting torn down when
the release function tries to access it to detach the link.

To ensure the struct net object is alive when release function accesses it
we rely on the fact that cleanup_net(), struct net destructor, calls
synchronize_rcu() after invoking pre_exit callbacks. If auto-detach from
pre_exit happens first, link release will not attempt to access struct net.

Same applies the other way around, network namespace doesn't keep an
attached link alive because by not holding a ref to it. Instead bpf_links
to netns are RCU-freed, so that pernet pre_exit callback can safely access
and auto-detach the link when racing with link release/free.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/linux/bpf-netns.h      |   8 +
 include/net/netns/bpf.h        |   1 +
 include/uapi/linux/bpf.h       |   5 +
 kernel/bpf/net_namespace.c     | 257 ++++++++++++++++++++++++++++++++-
 kernel/bpf/syscall.c           |   3 +
 net/core/filter.c              |   1 +
 tools/include/uapi/linux/bpf.h |   5 +
 7 files changed, 278 insertions(+), 2 deletions(-)

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
diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
index a858d1c5b166..baabefdeb10c 100644
--- a/include/net/netns/bpf.h
+++ b/include/net/netns/bpf.h
@@ -12,6 +12,7 @@ struct bpf_prog;
 
 struct netns_bpf {
 	struct bpf_prog __rcu *progs[MAX_NETNS_BPF_ATTACH_TYPE];
+	struct bpf_link __rcu *links[MAX_NETNS_BPF_ATTACH_TYPE];
 };
 
 #endif /* __NETNS_BPF_H__ */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index 54b93f8b49b8..05469d3c5c82 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -235,6 +235,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_TRACING = 2,
 	BPF_LINK_TYPE_CGROUP = 3,
 	BPF_LINK_TYPE_ITER = 4,
+	BPF_LINK_TYPE_NETNS = 5,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -3753,6 +3754,10 @@ struct bpf_link_info {
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
index fc89154aed27..1c6009ab93c5 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -8,9 +8,155 @@
  * Functions to manage BPF programs attached to netns
  */
 
-/* Protects updates to netns_bpf */
+struct bpf_netns_link {
+	struct bpf_link	link;
+	enum bpf_attach_type type;
+	enum netns_bpf_attach_type netns_type;
+
+	/* struct net is not RCU-freed but we treat it as such because
+	 * our pre_exit callback will NULL this pointer before
+	 * cleanup_net() calls synchronize_rcu().
+	 */
+	struct net __rcu *net;
+
+	/* bpf_netns_link is RCU-freed for pre_exit callback invoked
+	 * by cleanup_net() to safely access the link.
+	 */
+	struct rcu_head	rcu;
+};
+
+/* Protects updates to netns_bpf. */
 DEFINE_MUTEX(netns_bpf_mutex);
 
+static inline struct bpf_netns_link *to_bpf_netns_link(struct bpf_link *link)
+{
+	return container_of(link, struct bpf_netns_link, link);
+}
+
+/* Called with RCU read lock. */
+static void __net_exit
+bpf_netns_link_auto_detach(struct net *net, enum netns_bpf_attach_type type)
+{
+	struct bpf_netns_link *net_link;
+	struct bpf_link *link;
+
+	link = rcu_dereference(net->bpf.links[type]);
+	if (!link)
+		return;
+	net_link = to_bpf_netns_link(link);
+	RCU_INIT_POINTER(net_link->net, NULL);
+}
+
+static void bpf_netns_link_release(struct bpf_link *link)
+{
+	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
+	enum netns_bpf_attach_type type = net_link->netns_type;
+	struct net *net;
+
+	/* Link auto-detached by dying netns. */
+	if (!rcu_access_pointer(net_link->net))
+		return;
+
+	mutex_lock(&netns_bpf_mutex);
+
+	/* Recheck after potential sleep. We can race with cleanup_net
+	 * here, but if we see a non-NULL struct net pointer pre_exit
+	 * and following synchronize_rcu() has not happened yet, and
+	 * we have until the end of grace period to access net.
+	 */
+	rcu_read_lock();
+	net = rcu_dereference(net_link->net);
+	if (net) {
+		RCU_INIT_POINTER(net->bpf.links[type], NULL);
+		RCU_INIT_POINTER(net->bpf.progs[type], NULL);
+	}
+	rcu_read_unlock();
+
+	mutex_unlock(&netns_bpf_mutex);
+}
+
+static void bpf_netns_link_dealloc(struct bpf_link *link)
+{
+	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
+
+	/* Delay kfree in case we're racing with cleanup_net. */
+	kfree_rcu(net_link, rcu);
+}
+
+static int bpf_netns_link_update_prog(struct bpf_link *link,
+				      struct bpf_prog *new_prog,
+				      struct bpf_prog *old_prog)
+{
+	struct bpf_netns_link *net_link = to_bpf_netns_link(link);
+	struct net *net;
+	int ret = 0;
+
+	if (old_prog && old_prog != link->prog)
+		return -EPERM;
+	if (new_prog->type != link->prog->type)
+		return -EINVAL;
+
+	mutex_lock(&netns_bpf_mutex);
+	rcu_read_lock();
+
+	net = rcu_dereference(net_link->net);
+	if (!net || !check_net(net)) {
+		/* Link auto-detached or netns dying */
+		ret = -ENOLINK;
+		goto out_unlock;
+	}
+
+	old_prog = xchg(&link->prog, new_prog);
+	bpf_prog_put(old_prog);
+
+out_unlock:
+	rcu_read_unlock();
+	mutex_unlock(&netns_bpf_mutex);
+
+	return ret;
+}
+
+static int bpf_netns_link_fill_info(const struct bpf_link *link,
+				    struct bpf_link_info *info)
+{
+	const struct bpf_netns_link *net_link;
+	unsigned int inum;
+	struct net *net;
+
+	net_link = container_of(link, struct bpf_netns_link, link);
+
+	rcu_read_lock();
+	net = rcu_dereference(net_link->net);
+	if (net)
+		inum = net->ns.inum;
+	rcu_read_unlock();
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
@@ -67,6 +213,13 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 
 	net = current->nsproxy->net_ns;
 	mutex_lock(&netns_bpf_mutex);
+
+	/* Attaching prog directly is not compatible with links */
+	if (rcu_access_pointer(net->bpf.links[type])) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	switch (type) {
 	case NETNS_BPF_FLOW_DISSECTOR:
 		ret = flow_dissector_bpf_prog_attach(net, prog);
@@ -75,6 +228,7 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 		ret = -EINVAL;
 		break;
 	}
+unlock:
 	mutex_unlock(&netns_bpf_mutex);
 
 	return ret;
@@ -85,6 +239,10 @@ static int __netns_bpf_prog_detach(struct net *net,
 {
 	struct bpf_prog *attached;
 
+	/* Progs attached via links cannot be detached */
+	if (rcu_access_pointer(net->bpf.links[type]))
+		return -EBUSY;
+
 	/* No need for update-side lock when net is going away. */
 	attached = rcu_dereference_protected(net->bpf.progs[type],
 					     !check_net(net) ||
@@ -112,14 +270,109 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
 	return ret;
 }
 
+static int __netns_bpf_link_attach(struct net *net, struct bpf_link *link,
+				   enum netns_bpf_attach_type type)
+{
+	int err;
+
+	/* Allow attaching only one prog or link for now */
+	if (rcu_access_pointer(net->bpf.links[type]))
+		return -E2BIG;
+	/* Links are not compatible with attaching prog directly */
+	if (rcu_access_pointer(net->bpf.progs[type]))
+		return -EBUSY;
+
+	switch (type) {
+	case NETNS_BPF_FLOW_DISSECTOR:
+		err = flow_dissector_bpf_prog_attach(net, link->prog);
+		break;
+	default:
+		err = -EINVAL;
+		break;
+	}
+	if (!err)
+		rcu_assign_pointer(net->bpf.links[type], link);
+	return err;
+}
+
+static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
+				 enum netns_bpf_attach_type type)
+{
+	int ret;
+
+	mutex_lock(&netns_bpf_mutex);
+	ret = __netns_bpf_link_attach(net, link, type);
+	mutex_unlock(&netns_bpf_mutex);
+
+	return ret;
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
+	rcu_assign_pointer(net_link->net, net);
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
+	err = bpf_link_settle(&link_primer);
+out_put_net:
+	/* To auto-detach the link from netns when it is getting
+	 * destroyed, we can't hold a ref to it. Instead, we rely on
+	 * RCU when accessing link->net pointer.
+	 */
+	put_net(net);
+	return err;
+}
+
 static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 {
 	enum netns_bpf_attach_type type;
 
+	rcu_read_lock();
 	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
-		if (rcu_access_pointer(net->bpf.progs[type]))
+		if (rcu_access_pointer(net->bpf.links[type]))
+			bpf_netns_link_auto_detach(net, type);
+		else if (rcu_access_pointer(net->bpf.progs[type]))
 			__netns_bpf_prog_detach(net, type);
 	}
+	rcu_read_unlock();
 }
 
 static struct pernet_operations netns_bpf_pernet_ops __net_initdata = {
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 93f329a6736d..47a7b426d75c 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3874,6 +3874,9 @@ static int link_create(union bpf_attr *attr)
 	case BPF_PROG_TYPE_TRACING:
 		ret = tracing_bpf_link_attach(attr, prog);
 		break;
+	case BPF_PROG_TYPE_FLOW_DISSECTOR:
+		ret = netns_bpf_link_create(attr, prog);
+		break;
 	default:
 		ret = -EINVAL;
 	}
diff --git a/net/core/filter.c b/net/core/filter.c
index a6fc23447f12..b77391a1adb1 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9081,6 +9081,7 @@ const struct bpf_verifier_ops sk_reuseport_verifier_ops = {
 
 const struct bpf_prog_ops sk_reuseport_prog_ops = {
 };
+
 #endif /* CONFIG_INET */
 
 DEFINE_BPF_DISPATCHER(xdp)
diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 54b93f8b49b8..05469d3c5c82 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -235,6 +235,7 @@ enum bpf_link_type {
 	BPF_LINK_TYPE_TRACING = 2,
 	BPF_LINK_TYPE_CGROUP = 3,
 	BPF_LINK_TYPE_ITER = 4,
+	BPF_LINK_TYPE_NETNS = 5,
 
 	MAX_BPF_LINK_TYPE,
 };
@@ -3753,6 +3754,10 @@ struct bpf_link_info {
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

