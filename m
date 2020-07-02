Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AA5C211FBA
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgGBJYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:24:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbgGBJYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:24:21 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE06AC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 02:24:20 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so22900121edz.0
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 02:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mqfnfJJKZnD4xkXXASNxfx/Woxfc4PgUsJYA2lOa5FU=;
        b=jQjSbckZ2Au7WO1UXPAD9AlKSCiuxyN4LE/LIatzt/3bAeEriQkTv+xMKZMshbWvsy
         5cImimp8hZ3jByNMa4byBjH78fh7l3zWRG6tvcyu7RAYM0gi/PMyn7jOCNzF4GDmgPmA
         E0AwCwlceK6Kkb4OtNd0+B66/aynmEeQC+RZI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mqfnfJJKZnD4xkXXASNxfx/Woxfc4PgUsJYA2lOa5FU=;
        b=H2KEyGcXQ/kwZbECwPkzm1hVcqbhZiDDKUEB4J46Xt9wDknGxqeFKSC+ImrJD3XQLk
         uyYPKCGAIAl7Sjqm6UWk1HcdDGTjhGvryAgWKzz881zoN3CWBqBy3WNyA0RIDkCEmu/N
         6hStIA8xlfo0Op+GSVEhvuIKRwEGhJVgJlQ+TxB2w3FDqmp538bqc34XYqxzupdd7bvF
         iDzCp5MYPPyXmQEyewxixV7c+eNCeKxBCRog1lzWfKOZm1qWZWqQP90CfYiAJMCzKKAF
         vpgifPyRB3zetvIJHXM2MZ51SmV+9QYrT9pqYbWPrFe/NM+sB9VFTrQDLvM/b4rk1iTz
         fLUg==
X-Gm-Message-State: AOAM531dRBsuhck8HXASHHT4gm75BuIghviB341lJ17aKsDZLE4alnRV
        LFu+EYu2vuLzHMB1cBhscG1kLw==
X-Google-Smtp-Source: ABdhPJzLuT1sExLTB5sbUDzyXm7aWMYmX6xPT9aLpwWRscjM8rI77WbUlyNMhPruWSLXW87zkeIxzg==
X-Received: by 2002:a05:6402:1805:: with SMTP id g5mr24254483edy.357.1593681859648;
        Thu, 02 Jul 2020 02:24:19 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id q17sm6363797ejd.20.2020.07.02.02.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 02:24:19 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v3 01/16] bpf, netns: Handle multiple link attachments
Date:   Thu,  2 Jul 2020 11:24:01 +0200
Message-Id: <20200702092416.11961-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200702092416.11961-1-jakub@cloudflare.com>
References: <20200702092416.11961-1-jakub@cloudflare.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend the BPF netns link callbacks to rebuild (grow/shrink) or update the
prog_array at given position when link gets attached/updated/released.

This let's us lift the limit of having just one link attached for the new
attach type introduced by subsequent patch.

No functional changes intended.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
---

Notes:
    v3:
    - New in v3 to support multi-prog attachments. (Alexei)

 include/linux/bpf.h        |  4 ++
 kernel/bpf/core.c          | 22 ++++++++++
 kernel/bpf/net_namespace.c | 88 +++++++++++++++++++++++++++++++++++---
 3 files changed, 107 insertions(+), 7 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 3d2ade703a35..26bc70533db0 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -928,6 +928,10 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
 
 void bpf_prog_array_delete_safe(struct bpf_prog_array *progs,
 				struct bpf_prog *old_prog);
+void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
+				   unsigned int index);
+void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
+			      struct bpf_prog *prog);
 int bpf_prog_array_copy_info(struct bpf_prog_array *array,
 			     u32 *prog_ids, u32 request_cnt,
 			     u32 *prog_cnt);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9df4cc9a2907..d4b3b9ee6bf1 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1958,6 +1958,28 @@ void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
 		}
 }
 
+void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
+				   unsigned int index)
+{
+	bpf_prog_array_update_at(array, index, &dummy_bpf_prog.prog);
+}
+
+void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
+			      struct bpf_prog *prog)
+{
+	struct bpf_prog_array_item *item;
+
+	for (item = array->items; item->prog; item++) {
+		if (item->prog == &dummy_bpf_prog.prog)
+			continue;
+		if (!index) {
+			WRITE_ONCE(item->prog, prog);
+			break;
+		}
+		index--;
+	}
+}
+
 int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 			struct bpf_prog *exclude_prog,
 			struct bpf_prog *include_prog,
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 247543380fa6..6011122c35b6 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -36,11 +36,51 @@ static void netns_bpf_run_array_detach(struct net *net,
 	bpf_prog_array_free(run_array);
 }
 
+static unsigned int link_index(struct net *net,
+			       enum netns_bpf_attach_type type,
+			       struct bpf_netns_link *link)
+{
+	struct bpf_netns_link *pos;
+	unsigned int i = 0;
+
+	list_for_each_entry(pos, &net->bpf.links[type], node) {
+		if (pos == link)
+			return i;
+		i++;
+	}
+	return UINT_MAX;
+}
+
+static unsigned int link_count(struct net *net,
+			       enum netns_bpf_attach_type type)
+{
+	struct list_head *pos;
+	unsigned int i = 0;
+
+	list_for_each(pos, &net->bpf.links[type])
+		i++;
+	return i;
+}
+
+static void fill_prog_array(struct net *net, enum netns_bpf_attach_type type,
+			    struct bpf_prog_array *prog_array)
+{
+	struct bpf_netns_link *pos;
+	unsigned int i = 0;
+
+	list_for_each_entry(pos, &net->bpf.links[type], node) {
+		prog_array->items[i].prog = pos->link.prog;
+		i++;
+	}
+}
+
 static void bpf_netns_link_release(struct bpf_link *link)
 {
 	struct bpf_netns_link *net_link =
 		container_of(link, struct bpf_netns_link, link);
 	enum netns_bpf_attach_type type = net_link->netns_type;
+	struct bpf_prog_array *old_array, *new_array;
+	unsigned int cnt, idx;
 	struct net *net;
 
 	mutex_lock(&netns_bpf_mutex);
@@ -53,9 +93,27 @@ static void bpf_netns_link_release(struct bpf_link *link)
 	if (!net)
 		goto out_unlock;
 
-	netns_bpf_run_array_detach(net, type);
+	/* Remember link position in case of safe delete */
+	idx = link_index(net, type, net_link);
 	list_del(&net_link->node);
 
+	cnt = link_count(net, type);
+	if (!cnt) {
+		netns_bpf_run_array_detach(net, type);
+		goto out_unlock;
+	}
+
+	old_array = rcu_dereference_protected(net->bpf.run_array[type],
+					      lockdep_is_held(&netns_bpf_mutex));
+	new_array = bpf_prog_array_alloc(cnt, GFP_KERNEL);
+	if (!new_array) {
+		bpf_prog_array_delete_safe_at(old_array, idx);
+		goto out_unlock;
+	}
+	fill_prog_array(net, type, new_array);
+	rcu_assign_pointer(net->bpf.run_array[type], new_array);
+	bpf_prog_array_free(old_array);
+
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 }
@@ -76,6 +134,7 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 		container_of(link, struct bpf_netns_link, link);
 	enum netns_bpf_attach_type type = net_link->netns_type;
 	struct bpf_prog_array *run_array;
+	unsigned int idx;
 	struct net *net;
 	int ret = 0;
 
@@ -95,7 +154,8 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 
 	run_array = rcu_dereference_protected(net->bpf.run_array[type],
 					      lockdep_is_held(&netns_bpf_mutex));
-	WRITE_ONCE(run_array->items[0].prog, new_prog);
+	idx = link_index(net, type, net_link);
+	bpf_prog_array_update_at(run_array, idx, new_prog);
 
 	old_prog = xchg(&link->prog, new_prog);
 	bpf_prog_put(old_prog);
@@ -295,18 +355,29 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
 	return ret;
 }
 
+static int netns_bpf_max_progs(enum netns_bpf_attach_type type)
+{
+	switch (type) {
+	case NETNS_BPF_FLOW_DISSECTOR:
+		return 1;
+	default:
+		return 0;
+	}
+}
+
 static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 				 enum netns_bpf_attach_type type)
 {
 	struct bpf_netns_link *net_link =
 		container_of(link, struct bpf_netns_link, link);
 	struct bpf_prog_array *run_array;
+	unsigned int cnt;
 	int err;
 
 	mutex_lock(&netns_bpf_mutex);
 
-	/* Allow attaching only one prog or link for now */
-	if (!list_empty(&net->bpf.links[type])) {
+	cnt = link_count(net, type);
+	if (cnt >= netns_bpf_max_progs(type)) {
 		err = -E2BIG;
 		goto out_unlock;
 	}
@@ -327,16 +398,19 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
 	if (err)
 		goto out_unlock;
 
-	run_array = bpf_prog_array_alloc(1, GFP_KERNEL);
+	run_array = bpf_prog_array_alloc(cnt + 1, GFP_KERNEL);
 	if (!run_array) {
 		err = -ENOMEM;
 		goto out_unlock;
 	}
-	run_array->items[0].prog = link->prog;
-	rcu_assign_pointer(net->bpf.run_array[type], run_array);
 
 	list_add_tail(&net_link->node, &net->bpf.links[type]);
 
+	fill_prog_array(net, type, run_array);
+	run_array = rcu_replace_pointer(net->bpf.run_array[type], run_array,
+					lockdep_is_held(&netns_bpf_mutex));
+	bpf_prog_array_free(run_array);
+
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 	return err;
-- 
2.25.4

