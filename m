Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5E14203C0E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 18:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgFVQDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 12:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729095AbgFVQDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 12:03:08 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D715C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:03:08 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id x18so19923371lji.1
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 09:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MwS3Q+JYpCt4mVhhOzw0IlTtz+uyLX5R51fo568EdZg=;
        b=ftLUlMtCFyAVK0uwv7KVintwAxeVthReX08phF194VIP12lP/iHEscC9xXvFYpONb4
         ejRqmVJ8qjYY7H6p5LWdi1K11huw3YkMt9d+fvSqgywLdIkLAMtRuudg/DDMI1WGaRBl
         2AVzCB9BLKvY6Y/i2SD2KFNf2f+BBpsK2Uae4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MwS3Q+JYpCt4mVhhOzw0IlTtz+uyLX5R51fo568EdZg=;
        b=T88YRbfmhNlZMt0SkgCC85hgSS4tPEPbn/KTe9PsoxP9I6QhImYFOU1YImwW8nJpvU
         s1wjey1FKnX8+FHUlhxg3+V9lqp6QD/G3ay9wm2n969rYIyGZ3QfDMsoCaaFgBDpb+4f
         kTBgzX7Q9wnxnVub8TOFuM5JodG09nv0PLP19jPjgZW7uUbH4NQm0jWKR4YIYSyFZvAz
         ezUe9XyojoUmSpFb+SuCuP/0khKcPDJKC2rb5eKdiEBD5oWUyDxb+qtotYx2l0ye2PX/
         2Q06vAa95CI91hXuWz3WV/lrA0MDEpuOKBStLzAwIq2uA8FNbK/EHEuW04QSGpMFPH2L
         tgOQ==
X-Gm-Message-State: AOAM530QRATlgibNqigM+i9n8hfcIc3mGkdHwoQEROx/vzDFis46kzSL
        TXACo0v75wUKOiMS/XwozliWJhdhWspu7Q==
X-Google-Smtp-Source: ABdhPJwOpsmfH41MyamD6KeyVxcL4sM2+04rfgFvlotz401W4nbuPI22ZzKbF+DvePJK0ZWMb+Yamg==
X-Received: by 2002:a05:651c:213:: with SMTP id y19mr8424408ljn.232.1592841786910;
        Mon, 22 Jun 2020 09:03:06 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a5sm3471361lfh.15.2020.06.22.09.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 09:03:06 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com
Subject: [PATCH bpf-next 3/3] bpf, netns: Keep a list of attached bpf_link's
Date:   Mon, 22 Jun 2020 18:03:00 +0200
Message-Id: <20200622160300.636567-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200622160300.636567-1-jakub@cloudflare.com>
References: <20200622160300.636567-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To support multi-prog link-based attachments for new netns attach types, we
need to keep track of more than one bpf_link per attach type. Hence,
convert net->bpf.links into a list, that currently can be either empty or
have just one item.

Instead of reusing bpf_prog_list from bpf-cgroup, we link together
bpf_netns_link's themselves. This makes list management simpler as we don't
have to allocate, initialize, and later release list elements. We can do
this because multi-prog attachment will be available only for bpf_link, and
we don't need to build a list of programs attached directly and indirectly
via links.

No functional changes intended.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---
 include/net/netns/bpf.h    |  2 +-
 kernel/bpf/net_namespace.c | 42 +++++++++++++++++++++-----------------
 2 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/include/net/netns/bpf.h b/include/net/netns/bpf.h
index a5015bda9979..0ca6a1b87185 100644
--- a/include/net/netns/bpf.h
+++ b/include/net/netns/bpf.h
@@ -15,7 +15,7 @@ struct netns_bpf {
 	/* Array of programs to run compiled from progs or links */
 	struct bpf_prog_array __rcu *run_array[MAX_NETNS_BPF_ATTACH_TYPE];
 	struct bpf_prog *progs[MAX_NETNS_BPF_ATTACH_TYPE];
-	struct bpf_link *links[MAX_NETNS_BPF_ATTACH_TYPE];
+	struct list_head links[MAX_NETNS_BPF_ATTACH_TYPE];
 };
 
 #endif /* __NETNS_BPF_H__ */
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 593523a22168..3e89c7ad42cb 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -19,20 +19,12 @@ struct bpf_netns_link {
 	 * with netns_bpf_mutex held.
 	 */
 	struct net *net;
+	struct list_head node; /* node in list of links attached to net */
 };
 
 /* Protects updates to netns_bpf */
 DEFINE_MUTEX(netns_bpf_mutex);
 
-/* Must be called with netns_bpf_mutex held. */
-static void __net_exit bpf_netns_link_auto_detach(struct bpf_link *link)
-{
-	struct bpf_netns_link *net_link =
-		container_of(link, struct bpf_netns_link, link);
-
-	net_link->net = NULL;
-}
-
 static void bpf_netns_link_release(struct bpf_link *link)
 {
 	struct bpf_netns_link *net_link =
@@ -69,7 +61,7 @@ static void bpf_netns_link_release(struct bpf_link *link)
 		bpf_prog_array_free(old_array);
 	}
 
-	net->bpf.links[type] = NULL;
+	list_del(&net_link->node);
 
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
@@ -233,7 +225,7 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	mutex_lock(&netns_bpf_mutex);
 
 	/* Attaching prog directly is not compatible with links */
-	if (net->bpf.links[type]) {
+	if (!list_empty(&net->bpf.links[type])) {
 		ret = -EEXIST;
 		goto out_unlock;
 	}
@@ -296,7 +288,7 @@ static int __netns_bpf_prog_detach(struct net *net,
 	struct bpf_prog *attached;
 
 	/* Progs attached via links cannot be detached */
-	if (net->bpf.links[type])
+	if (!list_empty(&net->bpf.links[type]))
 		return -EINVAL;
 
 	attached = net->bpf.progs[type];
@@ -327,13 +319,15 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
 static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 				 enum netns_bpf_attach_type type)
 {
+	struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
 	struct bpf_prog_array *old_array, *new_array;
 	int err;
 
 	mutex_lock(&netns_bpf_mutex);
 
 	/* Allow attaching only one prog or link for now */
-	if (net->bpf.links[type]) {
+	if (!list_empty(&net->bpf.links[type])) {
 		err = -E2BIG;
 		goto out_unlock;
 	}
@@ -362,7 +356,7 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 	rcu_assign_pointer(net->bpf.run_array[type], new_array);
 	bpf_prog_array_free(old_array);
 
-	net->bpf.links[type] = link;
+	list_add_tail(&net_link->node, &net->bpf.links[type]);
 
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
@@ -421,24 +415,34 @@ int netns_bpf_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
 	return err;
 }
 
+static int __net_init netns_bpf_pernet_init(struct net *net)
+{
+	int type;
+
+	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++)
+		INIT_LIST_HEAD(&net->bpf.links[type]);
+
+	return 0;
+}
+
 static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
 {
 	enum netns_bpf_attach_type type;
-	struct bpf_link *link;
+	struct bpf_netns_link *net_link;
 
 	mutex_lock(&netns_bpf_mutex);
 	for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
 		netns_bpf_run_array_detach(net, type);
-		link = net->bpf.links[type];
-		if (link)
-			bpf_netns_link_auto_detach(link);
-		else if (net->bpf.progs[type])
+		list_for_each_entry(net_link, &net->bpf.links[type], node)
+			net_link->net = NULL; /* auto-detach link */
+		if (net->bpf.progs[type])
 			bpf_prog_put(net->bpf.progs[type]);
 	}
 	mutex_unlock(&netns_bpf_mutex);
 }
 
 static struct pernet_operations netns_bpf_pernet_ops __net_initdata = {
+	.init = netns_bpf_pernet_init,
 	.pre_exit = netns_bpf_pernet_pre_exit,
 };
 
-- 
2.25.4

