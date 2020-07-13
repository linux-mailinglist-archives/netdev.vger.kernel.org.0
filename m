Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97D4121DEFC
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 19:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbgGMRrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 13:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729826AbgGMRq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 13:46:59 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 312F9C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:46:59 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so18948453ljn.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 10:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=opL//BYzhcQPBoxrHchY4vZX82iC++4GHZTFlkl4Nb8=;
        b=vkij8c4eti22az1c2OF806pGH9GUJG7d3hmjrZ9M0KM7TyJqQtp3lBuyKJnpbZVhL1
         q70nFRE7LT9DO7jFOy0smkUdLcO/uWfJL75lqpLV/hVE2ONNY6upC3BqNAB4zmEGMoji
         BhJD1QHXBHoryQPm/NFBxFEUk2SN0CQQbRu0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=opL//BYzhcQPBoxrHchY4vZX82iC++4GHZTFlkl4Nb8=;
        b=FNPIQPtZXs8SgXMQNNX8xfgml7iOmbT3PuZDQFjyTktgTfOegX6o/Te/m7Iev5EdMX
         bHj4NKSQeP229FY3eW6MHY+MnHd/1+RYFvkC9TKAbOSxg4LUjnbVhC5pvoGZqsU6PfFs
         qZOwZgbN2uN6wh1kWXlrIJ9x6zLf9rIRqtkuyNtDk6OxPCt5vKC1YmUi4otBvV/E7iFS
         bmQuPn8VE3MNkfnbKGZfXjGgi5AvAYBszOmJRNPrNidFeUAp0dghWhVrTry7QA87cnnJ
         lk1ueCoUnVKpYIRDCaodyRbvUy8wp/UyCLn49wpi43vquN+ydwnxh3V5vVYnv/aBz7lR
         YxDQ==
X-Gm-Message-State: AOAM5321i8Hm65+iMzoKFEMBBo1OTcDUUr9IqL7pKoghKlCEHRlSP6Uf
        YFionb8T4galZBY1BT+0HRnrSQ==
X-Google-Smtp-Source: ABdhPJxOhso6OoTmlFc2xk0wErkRYTNkDXXkmvLn/bCi9OjuQp0edzUKBtoDNdgwmdQP1EAEXqDoSQ==
X-Received: by 2002:a2e:a544:: with SMTP id e4mr424887ljn.264.1594662417544;
        Mon, 13 Jul 2020 10:46:57 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id g22sm4741921lfb.43.2020.07.13.10.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 10:46:57 -0700 (PDT)
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH bpf-next v4 01/16] bpf, netns: Handle multiple link attachments
Date:   Mon, 13 Jul 2020 19:46:39 +0200
Message-Id: <20200713174654.642628-2-jakub@cloudflare.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200713174654.642628-1-jakub@cloudflare.com>
References: <20200713174654.642628-1-jakub@cloudflare.com>
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
    v4:
    - Document prog_array {delete_safe,update}_at() behavior. (Andrii)
    - Return -EINVAL/-ENOENT on failure in {delete_safe,update}_at(). (Andrii)
    - Return -ENOENT on index out of range in link_index(). (Andrii)
    
    v3:
    - New in v3 to support multi-prog attachments. (Alexei)

 include/linux/bpf.h        |  3 ++
 kernel/bpf/core.c          | 55 +++++++++++++++++++++++
 kernel/bpf/net_namespace.c | 90 ++++++++++++++++++++++++++++++++++----
 3 files changed, 139 insertions(+), 9 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 0cd7f6884c5c..ad9c61ae8640 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -928,6 +928,9 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
 
 void bpf_prog_array_delete_safe(struct bpf_prog_array *progs,
 				struct bpf_prog *old_prog);
+int bpf_prog_array_delete_safe_at(struct bpf_prog_array *array, int index);
+int bpf_prog_array_update_at(struct bpf_prog_array *array, int index,
+			     struct bpf_prog *prog);
 int bpf_prog_array_copy_info(struct bpf_prog_array *array,
 			     u32 *prog_ids, u32 request_cnt,
 			     u32 *prog_cnt);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 9df4cc9a2907..7be02e555ab9 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1958,6 +1958,61 @@ void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
 		}
 }
 
+/**
+ * bpf_prog_array_delete_safe_at() - Replaces the program at the given
+ *                                   index into the program array with
+ *                                   a dummy no-op program.
+ * @array: a bpf_prog_array
+ * @index: the index of the program to replace
+ *
+ * Skips over dummy programs, by not counting them, when calculating
+ * the the position of the program to replace.
+ *
+ * Return:
+ * * 0		- Success
+ * * -EINVAL	- Invalid index value. Must be a non-negative integer.
+ * * -ENOENT	- Index out of range
+ */
+int bpf_prog_array_delete_safe_at(struct bpf_prog_array *array, int index)
+{
+	return bpf_prog_array_update_at(array, index, &dummy_bpf_prog.prog);
+}
+
+/**
+ * bpf_prog_array_update_at() - Updates the program at the given index
+ *                              into the program array.
+ * @array: a bpf_prog_array
+ * @index: the index of the program to update
+ * @prog: the program to insert into the array
+ *
+ * Skips over dummy programs, by not counting them, when calculating
+ * the position of the program to update.
+ *
+ * Return:
+ * * 0		- Success
+ * * -EINVAL	- Invalid index value. Must be a non-negative integer.
+ * * -ENOENT	- Index out of range
+ */
+int bpf_prog_array_update_at(struct bpf_prog_array *array, int index,
+			     struct bpf_prog *prog)
+{
+	struct bpf_prog_array_item *item;
+
+	if (unlikely(index < 0))
+		return -EINVAL;
+
+	for (item = array->items; item->prog; item++) {
+		if (item->prog == &dummy_bpf_prog.prog)
+			continue;
+		if (!index) {
+			WRITE_ONCE(item->prog, prog);
+			return 0;
+		}
+		index--;
+	}
+	return -ENOENT;
+}
+
 int bpf_prog_array_copy(struct bpf_prog_array *old_array,
 			struct bpf_prog *exclude_prog,
 			struct bpf_prog *include_prog,
diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
index 247543380fa6..988c2766ec97 100644
--- a/kernel/bpf/net_namespace.c
+++ b/kernel/bpf/net_namespace.c
@@ -36,12 +36,50 @@ static void netns_bpf_run_array_detach(struct net *net,
 	bpf_prog_array_free(run_array);
 }
 
+static int link_index(struct net *net, enum netns_bpf_attach_type type,
+		      struct bpf_netns_link *link)
+{
+	struct bpf_netns_link *pos;
+	int i = 0;
+
+	list_for_each_entry(pos, &net->bpf.links[type], node) {
+		if (pos == link)
+			return i;
+		i++;
+	}
+	return -ENOENT;
+}
+
+static int link_count(struct net *net, enum netns_bpf_attach_type type)
+{
+	struct list_head *pos;
+	int i = 0;
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
 	struct net *net;
+	int cnt, idx;
 
 	mutex_lock(&netns_bpf_mutex);
 
@@ -53,9 +91,27 @@ static void bpf_netns_link_release(struct bpf_link *link)
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
+		WARN_ON(bpf_prog_array_delete_safe_at(old_array, idx));
+		goto out_unlock;
+	}
+	fill_prog_array(net, type, new_array);
+	rcu_assign_pointer(net->bpf.run_array[type], new_array);
+	bpf_prog_array_free(old_array);
+
 out_unlock:
 	mutex_unlock(&netns_bpf_mutex);
 }
@@ -77,7 +133,7 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 	enum netns_bpf_attach_type type = net_link->netns_type;
 	struct bpf_prog_array *run_array;
 	struct net *net;
-	int ret = 0;
+	int idx, ret;
 
 	if (old_prog && old_prog != link->prog)
 		return -EPERM;
@@ -95,7 +151,10 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
 
 	run_array = rcu_dereference_protected(net->bpf.run_array[type],
 					      lockdep_is_held(&netns_bpf_mutex));
-	WRITE_ONCE(run_array->items[0].prog, new_prog);
+	idx = link_index(net, type, net_link);
+	ret = bpf_prog_array_update_at(run_array, idx, new_prog);
+	if (ret)
+		goto out_unlock;
 
 	old_prog = xchg(&link->prog, new_prog);
 	bpf_prog_put(old_prog);
@@ -295,18 +354,28 @@ int netns_bpf_prog_detach(const union bpf_attr *attr)
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
-	int err;
+	int cnt, err;
 
 	mutex_lock(&netns_bpf_mutex);
 
-	/* Allow attaching only one prog or link for now */
-	if (!list_empty(&net->bpf.links[type])) {
+	cnt = link_count(net, type);
+	if (cnt >= netns_bpf_max_progs(type)) {
 		err = -E2BIG;
 		goto out_unlock;
 	}
@@ -327,16 +396,19 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
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

