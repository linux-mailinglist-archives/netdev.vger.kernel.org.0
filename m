Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF88020A0AF
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405367AbgFYOOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405207AbgFYOOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:14:08 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA75C08C5DE
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:08 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id m26so3282581lfo.13
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 07:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2WRoV9X9kFx4tH/O9RiGcHsAYeLr9yIqCeeMhhCgrJ8=;
        b=AJuVkJrj4JMoYvcFwn5bfoxKUOySLhe1Qu5NKfks5fX+n1gllAAdCDc9dSpOuBabba
         GcocTip1EVSfQlyzS0amHO+YHW5QvCyZW/RS/WYjniAJbRDOaiiPT2KEBU2p6ZrIfONG
         7A9jUM9f0NpveaIxpV20HI6aTHj6Fb3AVglns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2WRoV9X9kFx4tH/O9RiGcHsAYeLr9yIqCeeMhhCgrJ8=;
        b=cN+qk8Em/bmdv6aIqoHqWgm+PjE2iI/F35YTdCaHx5TvApxC09nCXx5m/zvTWHmzTd
         XR+dkshrRaoeTLGE20qQEewXPf9Abs1nqC5ljxpjTK2qNy1hcQdsLxSsKEqpcMM+jzZr
         E5uMgH5uIR4exWwDIdmx09uu7Ub5NoFn92yfbMfzrVrmvLcput7rGYzBSgrflTzICQoo
         iGRte3lMjBGlIaAt6Q4iFOKNjoaj/X7uJM9Zfbwmb3frbub3MwhTEqH+Hgz31rJV5PSv
         CNqMFNN8keZ9YJ+awBe6EXwRVVwkuSkQ3bIKwWhxmWGtrb1r9Mgk9eoIeiiaTpCZXss7
         /KCg==
X-Gm-Message-State: AOAM533za9XWZ8qx3Lo+ci5TtH0BffVwPZ8QyGF6fcoUwRz2UTLZ94m+
        MFraTLByKKMsQB2FASmYgSEj7w==
X-Google-Smtp-Source: ABdhPJyIAnEr+JggWl+wWJkg38pE7pCLXRu45g3xASJ7fSJb5hEwCwaDzNobxf3LfbiiuYrKXW5fpQ==
X-Received: by 2002:a19:701:: with SMTP id 1mr18265306lfh.138.1593094446807;
        Thu, 25 Jun 2020 07:14:06 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id a17sm5988539lfo.73.2020.06.25.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 07:14:06 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH bpf-next v3 3/4] bpf, netns: Keep a list of attached bpf_link's
Date:   Thu, 25 Jun 2020 16:13:56 +0200
Message-Id: <20200625141357.910330-4-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200625141357.910330-1-jakub@cloudflare.com>
References: <20200625141357.910330-1-jakub@cloudflare.com>
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

Acked-by: Andrii Nakryiko <andriin@fb.com>
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
index 0dba97202357..7a34a8caf954 100644
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
 /* Must be called with netns_bpf_mutex held. */
 static void netns_bpf_run_array_detach(struct net *net,
 				       enum netns_bpf_attach_type type)
@@ -66,7 +58,7 @@ static void bpf_netns_link_release(struct bpf_link *link)
 		goto out_unlock;
 
 	netns_bpf_run_array_detach(net, type);
-	net->bpf.links[type] = NULL;
+	list_del(&net_link->node);
 
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
@@ -225,7 +217,7 @@ int netns_bpf_prog_attach(const union bpf_attr *attr, struct bpf_prog *prog)
 	mutex_lock(&netns_bpf_mutex);
 
 	/* Attaching prog directly is not compatible with links */
-	if (net->bpf.links[type]) {
+	if (!list_empty(&net->bpf.links[type])) {
 		ret = -EEXIST;
 		goto out_unlock;
 	}
@@ -279,7 +271,7 @@ static int __netns_bpf_prog_detach(struct net *net,
 	struct bpf_prog *attached;
 
 	/* Progs attached via links cannot be detached */
-	if (net->bpf.links[type])
+	if (!list_empty(&net->bpf.links[type]))
 		return -EINVAL;
 
 	attached = net->bpf.progs[type];
@@ -310,13 +302,15 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
 static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 				 enum netns_bpf_attach_type type)
 {
+	struct bpf_netns_link *net_link =
+		container_of(link, struct bpf_netns_link, link);
 	struct bpf_prog_array *run_array;
 	int err;
 
 	mutex_lock(&netns_bpf_mutex);
 
 	/* Allow attaching only one prog or link for now */
-	if (net->bpf.links[type]) {
+	if (!list_empty(&net->bpf.links[type])) {
 		err = -E2BIG;
 		goto out_unlock;
 	}
@@ -345,7 +339,7 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 	run_array->items[0].prog = link->prog;
 	rcu_assign_pointer(net->bpf.run_array[type], run_array);
 
-	net->bpf.links[type] = link;
+	list_add_tail(&net_link->node, &net->bpf.links[type]);
 
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
@@ -404,24 +398,34 @@ int netns_bpf_link_create(const union bpf_attr *attr, struct bpf_prog *prog)
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

