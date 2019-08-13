Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF8F8B808
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727965AbfHMMHo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:07:44 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36289 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725953AbfHMMHo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 08:07:44 -0400
Received: by mail-pf1-f196.google.com with SMTP id w2so682030pfi.3;
        Tue, 13 Aug 2019 05:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h5aBwQYBhYYm8ip0wUptHajj4CQWnHke2rSosOEwaMg=;
        b=LyKc1qJyP7aBy9ENhdsWpGjI2HOcy3pcqIEEWKujnzVqlBZDtYedPalwj85b5Qrv1m
         qzwpKe5d9nGe6YsGqw1QkOc3qHsQn8YGu+PlE9ag2vnbIlJ2m8LT1NEne8vcQtZvhkOc
         c3Ieqnre2ZI78uluTMHInv0Z5LBj3y1rmEBY+TcZ78XkfBm9cztL6P+hHq4KtS8mSfoj
         4e62M/XBNTuJNhF47ZB8Stlf0llvwAsr9mKOnem258LD33m8MLYd4onC9XxJISJUPSA3
         kth54A06Ke657YptEzerQJql2/+WYwmPGIObZbq+/rUr7/iuNjKJtLmuzGjIniCayYsv
         xmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h5aBwQYBhYYm8ip0wUptHajj4CQWnHke2rSosOEwaMg=;
        b=Zhsj/tPfKEWUG1nW/q0VKa8WBrO8lXmnPR39mx7N0NQvud0vsZVI4KbWTs/ZfXrR0o
         7hLMWUu67nA0SRuwkfhnsRTmD3RoFDo4nDeDcXN4lOc6CTgZNmtR0Mm22vrO3SeQF7Sr
         D3jKuJkicMqGFdgJMG/6UTM0OTgtjeM1rymL4tSblXbAdLI1Xp9KecArq/ENjq5dmFmD
         4RTUzyLay/Gjxc6VsJRW95Q5Q/P34gOKeJTZt7cX2rKVxSNJfs7Nz/Lh9s2dt3ppvFxB
         GSF6ky0ZSFapi1vQoyjowNvcZd/MMt7L+vbkygEEm72G7eF8lvQyw7e+tazCm39SvftA
         GEyw==
X-Gm-Message-State: APjAAAVZ3SqrD739KPwa81USpyQ7/Ow2CSazK2u9ZhzdrKsGd+tdampt
        KjvpYvZvcMrTs5pBxSrMEWguGxHc
X-Google-Smtp-Source: APXvYqyPIHQSnx5i/Di00DhakF4CYHHke4RyPIm1iMnNzmdo33J8VdvjcUgp7B2Kyd1d2eyGIjzOvg==
X-Received: by 2002:aa7:8a92:: with SMTP id a18mr41198769pfc.216.1565698062776;
        Tue, 13 Aug 2019 05:07:42 -0700 (PDT)
Received: from z400-fedora29.kern.oss.ntt.co.jp ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id o9sm73251099pgv.19.2019.08.13.05.07.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 05:07:42 -0700 (PDT)
From:   Toshiaki Makita <toshiaki.makita1@gmail.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Cc:     Toshiaki Makita <toshiaki.makita1@gmail.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        William Tu <u9012063@gmail.com>
Subject: [RFC PATCH bpf-next 06/14] xdp_flow: Add flow entry insertion/deletion logic in UMH
Date:   Tue, 13 Aug 2019 21:05:50 +0900
Message-Id: <20190813120558.6151-7-toshiaki.makita1@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
References: <20190813120558.6151-1-toshiaki.makita1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This logic will be used when xdp_flow kmod requests flow
insertion/deleteion.

On insertion, find a free entry and populate it, then update next index
pointer of its previous entry. On deletion, set the next index pointer
of the prev entry to the next index of the entry to be deleted.

Signed-off-by: Toshiaki Makita <toshiaki.makita1@gmail.com>
---
 net/xdp_flow/umh_bpf.h      |  15 ++
 net/xdp_flow/xdp_flow_umh.c | 470 +++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 483 insertions(+), 2 deletions(-)

diff --git a/net/xdp_flow/umh_bpf.h b/net/xdp_flow/umh_bpf.h
index b4fe0c6..4e4633f 100644
--- a/net/xdp_flow/umh_bpf.h
+++ b/net/xdp_flow/umh_bpf.h
@@ -15,4 +15,19 @@ struct xdp_flow_mask_entry {
 	int next;
 };
 
+static inline bool flow_equal(const struct xdp_flow_key *key1,
+			      const struct xdp_flow_key *key2)
+{
+	long *lkey1 = (long *)key1;
+	long *lkey2 = (long *)key2;
+	int i;
+
+	for (i = 0; i < sizeof(*key1); i += sizeof(long)) {
+		if (*lkey1++ != *lkey2++)
+			return false;
+	}
+
+	return true;
+}
+
 #endif
diff --git a/net/xdp_flow/xdp_flow_umh.c b/net/xdp_flow/xdp_flow_umh.c
index e35666a..9a4769b 100644
--- a/net/xdp_flow/xdp_flow_umh.c
+++ b/net/xdp_flow/xdp_flow_umh.c
@@ -19,6 +19,8 @@
 extern char xdp_flow_bpf_end;
 int progfile_fd;
 
+#define zalloc(size) calloc(1, (size))
+
 /* FIXME: syslog is used for easy debugging. As writing /dev/log can be stuck
  * due to reader side, should use another log mechanism like kmsg.
  */
@@ -38,6 +40,8 @@ struct netdev_info {
 	struct netdev_info_key key;
 	struct hlist_node node;
 	struct bpf_object *obj;
+	int free_slot_top;
+	int free_slots[MAX_FLOW_MASKS];
 };
 
 DEFINE_HASHTABLE(netdev_info_table, 16);
@@ -268,6 +272,57 @@ static struct netdev_info *get_netdev_info(const struct mbox_request *req)
 	return netdev_info;
 }
 
+static void init_flow_masks_free_slot(struct netdev_info *netdev_info)
+{
+	int i;
+
+	for (i = 0; i < MAX_FLOW_MASKS; i++)
+		netdev_info->free_slots[MAX_FLOW_MASKS - 1 - i] = i;
+	netdev_info->free_slot_top = MAX_FLOW_MASKS - 1;
+}
+
+static int get_flow_masks_free_slot(const struct netdev_info *netdev_info)
+{
+	if (netdev_info->free_slot_top < 0)
+		return -ENOBUFS;
+
+	return netdev_info->free_slots[netdev_info->free_slot_top];
+}
+
+static int add_flow_masks_free_slot(struct netdev_info *netdev_info, int slot)
+{
+	if (unlikely(netdev_info->free_slot_top >= MAX_FLOW_MASKS - 1)) {
+		pr_warn("BUG: free_slot overflow: top=%d, slot=%d\n",
+			netdev_info->free_slot_top, slot);
+		return -EOVERFLOW;
+	}
+
+	netdev_info->free_slots[++netdev_info->free_slot_top] = slot;
+
+	return 0;
+}
+
+static void delete_flow_masks_free_slot(struct netdev_info *netdev_info,
+					int slot)
+{
+	int top_slot;
+
+	if (unlikely(netdev_info->free_slot_top < 0)) {
+		pr_warn("BUG: free_slot underflow: top=%d, slot=%d\n",
+			netdev_info->free_slot_top, slot);
+		return;
+	}
+
+	top_slot = netdev_info->free_slots[netdev_info->free_slot_top];
+	if (unlikely(top_slot != slot)) {
+		pr_warn("BUG: inconsistent free_slot top: top_slot=%d, slot=%d\n",
+			top_slot, slot);
+		return;
+	}
+
+	netdev_info->free_slot_top--;
+}
+
 static int handle_load(const struct mbox_request *req, __u32 *prog_id)
 {
 	struct netdev_info *netdev_info;
@@ -291,6 +346,8 @@ static int handle_load(const struct mbox_request *req, __u32 *prog_id)
 	}
 	netdev_info->key.ifindex = key.ifindex;
 
+	init_flow_masks_free_slot(netdev_info);
+
 	prog_fd = load_bpf(req->ifindex, &netdev_info->obj);
 	if (prog_fd < 0) {
 		err = prog_fd;
@@ -331,14 +388,423 @@ static int handle_unload(const struct mbox_request *req)
 	return 0;
 }
 
+static int get_table_fd(const struct netdev_info *netdev_info,
+			const char *table_name)
+{
+	char errbuf[ERRBUF_SIZE];
+	struct bpf_map *map;
+	int map_fd;
+	int err;
+
+	map = bpf_object__find_map_by_name(netdev_info->obj, table_name);
+	if (!map) {
+		pr_err("BUG: %s map not found.\n", table_name);
+		return -ENOENT;
+	}
+
+	map_fd = bpf_map__fd(map);
+	if (map_fd < 0) {
+		err = libbpf_err(map_fd, errbuf);
+		pr_err("Invalid map fd: %s\n", errbuf);
+		return err;
+	}
+
+	return map_fd;
+}
+
+static int get_flow_masks_head_fd(const struct netdev_info *netdev_info)
+{
+	return get_table_fd(netdev_info, "flow_masks_head");
+}
+
+static int get_flow_masks_head(int head_fd, int *head)
+{
+	int err, zero = 0;
+
+	if (bpf_map_lookup_elem(head_fd, &zero, head)) {
+		err = -errno;
+		pr_err("Cannot get flow_masks_head: %s\n", strerror(errno));
+		return err;
+	}
+
+	return 0;
+}
+
+static int update_flow_masks_head(int head_fd, int head)
+{
+	int err, zero = 0;
+
+	if (bpf_map_update_elem(head_fd, &zero, &head, 0)) {
+		err = -errno;
+		pr_err("Cannot update flow_masks_head: %s\n", strerror(errno));
+		return err;
+	}
+
+	return 0;
+}
+
+static int get_flow_masks_fd(const struct netdev_info *netdev_info)
+{
+	return get_table_fd(netdev_info, "flow_masks");
+}
+
+static int get_flow_tables_fd(const struct netdev_info *netdev_info)
+{
+	return get_table_fd(netdev_info, "flow_tables");
+}
+
+static int __flow_table_insert_elem(int flow_table_fd,
+				    const struct xdp_flow *flow)
+{
+	int err = 0;
+
+	if (bpf_map_update_elem(flow_table_fd, &flow->key, &flow->actions, 0)) {
+		err = -errno;
+		pr_err("Cannot insert flow entry: %s\n",
+		       strerror(errno));
+	}
+
+	return err;
+}
+
+static void __flow_table_delete_elem(int flow_table_fd,
+				     const struct xdp_flow *flow)
+{
+	bpf_map_delete_elem(flow_table_fd, &flow->key);
+}
+
+static int flow_table_insert_elem(struct netdev_info *netdev_info,
+				  const struct xdp_flow *flow)
+{
+	int masks_fd, head_fd, flow_tables_fd, flow_table_fd, free_slot, head;
+	struct xdp_flow_mask_entry *entry, *pentry;
+	int err, cnt, idx, pidx;
+
+	masks_fd = get_flow_masks_fd(netdev_info);
+	if (masks_fd < 0)
+		return masks_fd;
+
+	head_fd = get_flow_masks_head_fd(netdev_info);
+	if (head_fd < 0)
+		return head_fd;
+
+	err = get_flow_masks_head(head_fd, &head);
+	if (err)
+		return err;
+
+	flow_tables_fd = get_flow_tables_fd(netdev_info);
+	if (flow_tables_fd < 0)
+		return flow_tables_fd;
+
+	entry = zalloc(sizeof(*entry));
+	if (!entry) {
+		pr_err("Memory allocation for flow_masks entry failed\n");
+		return -ENOMEM;
+	}
+
+	pentry = zalloc(sizeof(*pentry));
+	if (!pentry) {
+		flow_table_fd = -ENOMEM;
+		pr_err("Memory allocation for flow_masks prev entry failed\n");
+		goto err_entry;
+	}
+
+	idx = head;
+	for (cnt = 0; cnt < MAX_FLOW_MASKS; cnt++) {
+		if (idx == FLOW_MASKS_TAIL)
+			break;
+
+		if (bpf_map_lookup_elem(masks_fd, &idx, entry)) {
+			err = -errno;
+			pr_err("Cannot lookup flow_masks: %s\n",
+			       strerror(errno));
+			goto err;
+		}
+
+		if (entry->priority == flow->priority &&
+		    flow_equal(&entry->mask, &flow->mask)) {
+			__u32 id;
+
+			if (bpf_map_lookup_elem(flow_tables_fd, &idx, &id)) {
+				err = -errno;
+				pr_err("Cannot lookup flow_tables: %s\n",
+				       strerror(errno));
+				goto err;
+			}
+
+			flow_table_fd = bpf_map_get_fd_by_id(id);
+			if (flow_table_fd < 0) {
+				err = -errno;
+				pr_err("Cannot get flow_table fd by id: %s\n",
+				       strerror(errno));
+				goto err;
+			}
+
+			err = __flow_table_insert_elem(flow_table_fd, flow);
+			if (err)
+				goto out;
+
+			entry->count++;
+			if (bpf_map_update_elem(masks_fd, &idx, entry, 0)) {
+				err = -errno;
+				pr_err("Cannot update flow_masks count: %s\n",
+				       strerror(errno));
+				__flow_table_delete_elem(flow_table_fd, flow);
+				goto out;
+			}
+
+			goto out;
+		}
+
+		if (entry->priority > flow->priority)
+			break;
+
+		*pentry = *entry;
+		pidx = idx;
+		idx = entry->next;
+	}
+
+	if (unlikely(cnt == MAX_FLOW_MASKS && idx != FLOW_MASKS_TAIL)) {
+		err = -EINVAL;
+		pr_err("Cannot lookup flow_masks: Broken flow_masks list\n");
+		goto out;
+	}
+
+	/* Flow mask was not found. Create a new one */
+
+	free_slot = get_flow_masks_free_slot(netdev_info);
+	if (free_slot < 0) {
+		err = free_slot;
+		goto err;
+	}
+
+	entry->mask = flow->mask;
+	entry->priority = flow->priority;
+	entry->count = 1;
+	entry->next = idx;
+	if (bpf_map_update_elem(masks_fd, &free_slot, entry, 0)) {
+		err = -errno;
+		pr_err("Cannot update flow_masks: %s\n", strerror(errno));
+		goto err;
+	}
+
+	flow_table_fd = bpf_create_map(BPF_MAP_TYPE_HASH,
+				       sizeof(struct xdp_flow_key),
+				       sizeof(struct xdp_flow_actions),
+				       MAX_FLOWS, 0);
+	if (flow_table_fd < 0) {
+		err = -errno;
+		pr_err("map creation for flow_table failed: %s\n",
+		       strerror(errno));
+		goto err;
+	}
+
+	err = __flow_table_insert_elem(flow_table_fd, flow);
+	if (err)
+		goto out;
+
+	if (bpf_map_update_elem(flow_tables_fd, &free_slot, &flow_table_fd, 0)) {
+		err = -errno;
+		pr_err("Failed to insert flow_table into flow_tables: %s\n",
+		       strerror(errno));
+		goto out;
+	}
+
+	if (cnt == 0) {
+		err = update_flow_masks_head(head_fd, free_slot);
+		if (err)
+			goto err_flow_table;
+	} else {
+		pentry->next = free_slot;
+		/* This effectively only updates one byte of entry->next */
+		if (bpf_map_update_elem(masks_fd, &pidx, pentry, 0)) {
+			err = -errno;
+			pr_err("Cannot update flow_masks prev entry: %s\n",
+			       strerror(errno));
+			goto err_flow_table;
+		}
+	}
+	delete_flow_masks_free_slot(netdev_info, free_slot);
+out:
+	close(flow_table_fd);
+err:
+	free(pentry);
+err_entry:
+	free(entry);
+
+	return err;
+
+err_flow_table:
+	bpf_map_delete_elem(flow_tables_fd, &free_slot);
+
+	goto out;
+}
+
+static int flow_table_delete_elem(struct netdev_info *netdev_info,
+				  const struct xdp_flow *flow)
+{
+	int masks_fd, head_fd, flow_tables_fd, flow_table_fd, head;
+	struct xdp_flow_mask_entry *entry, *pentry;
+	int err, cnt, idx, pidx;
+	__u32 id;
+
+	masks_fd = get_flow_masks_fd(netdev_info);
+	if (masks_fd < 0)
+		return masks_fd;
+
+	head_fd = get_flow_masks_head_fd(netdev_info);
+	if (head_fd < 0)
+		return head_fd;
+
+	err = get_flow_masks_head(head_fd, &head);
+	if (err)
+		return err;
+
+	flow_tables_fd = get_flow_tables_fd(netdev_info);
+	if (flow_tables_fd < 0)
+		return flow_tables_fd;
+
+	entry = zalloc(sizeof(*entry));
+	if (!entry) {
+		pr_err("Memory allocation for flow_masks entry failed\n");
+		return -ENOMEM;
+	}
+
+	pentry = zalloc(sizeof(*pentry));
+	if (!pentry) {
+		err = -ENOMEM;
+		pr_err("Memory allocation for flow_masks prev entry failed\n");
+		goto err_pentry;
+	}
+
+	idx = head;
+	for (cnt = 0; cnt < MAX_FLOW_MASKS; cnt++) {
+		if (idx == FLOW_MASKS_TAIL) {
+			err = -ENOENT;
+			pr_err("Cannot lookup flow_masks: %s\n",
+			       strerror(-err));
+			goto out;
+		}
+
+		if (bpf_map_lookup_elem(masks_fd, &idx, entry)) {
+			err = -errno;
+			pr_err("Cannot lookup flow_masks: %s\n",
+			       strerror(errno));
+			goto out;
+		}
+
+		if (entry->priority > flow->priority) {
+			err = -ENOENT;
+			pr_err("Cannot lookup flow_masks: %s\n",
+			       strerror(-err));
+			goto out;
+		}
+
+		if (entry->priority == flow->priority &&
+		    flow_equal(&entry->mask, &flow->mask))
+			break;
+
+		*pentry = *entry;
+		pidx = idx;
+		idx = entry->next;
+	}
+
+	if (unlikely(cnt == MAX_FLOW_MASKS)) {
+		err = -ENOENT;
+		pr_err("Cannot lookup flow_masks: Broken flow_masks list\n");
+		goto out;
+	}
+
+	if (bpf_map_lookup_elem(flow_tables_fd, &idx, &id)) {
+		err = -errno;
+		pr_err("Cannot lookup flow_tables: %s\n",
+		       strerror(errno));
+		goto out;
+	}
+
+	flow_table_fd = bpf_map_get_fd_by_id(id);
+	if (flow_table_fd < 0) {
+		err = -errno;
+		pr_err("Cannot get flow_table fd by id: %s\n",
+		       strerror(errno));
+		goto out;
+	}
+
+	__flow_table_delete_elem(flow_table_fd, flow);
+	close(flow_table_fd);
+
+	if (--entry->count > 0) {
+		if (bpf_map_update_elem(masks_fd, &idx, entry, 0)) {
+			err = -errno;
+			pr_err("Cannot update flow_masks count: %s\n",
+			       strerror(errno));
+		}
+
+		goto out;
+	}
+
+	if (unlikely(entry->count < 0)) {
+		pr_warn("flow_masks has negative count: %d\n",
+			entry->count);
+	}
+
+	if (cnt == 0) {
+		err = update_flow_masks_head(head_fd, entry->next);
+		if (err)
+			goto out;
+	} else {
+		pentry->next = entry->next;
+		/* This effectively only updates one byte of entry->next */
+		if (bpf_map_update_elem(masks_fd, &pidx, pentry, 0)) {
+			err = -errno;
+			pr_err("Cannot update flow_masks prev entry: %s\n",
+			       strerror(errno));
+			goto out;
+		}
+	}
+
+	bpf_map_delete_elem(flow_tables_fd, &idx);
+	err = add_flow_masks_free_slot(netdev_info, idx);
+	if (err)
+		pr_err("Cannot add flow_masks free slot: %s\n", strerror(-err));
+out:
+	free(pentry);
+err_pentry:
+	free(entry);
+
+	return err;
+}
+
 static int handle_replace(struct mbox_request *req)
 {
-	return -EOPNOTSUPP;
+	struct netdev_info *netdev_info;
+	int err;
+
+	netdev_info = get_netdev_info(req);
+	if (IS_ERR(netdev_info))
+		return PTR_ERR(netdev_info);
+
+	err = flow_table_insert_elem(netdev_info, &req->flow);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 static int handle_delete(const struct mbox_request *req)
 {
-	return -EOPNOTSUPP;
+	struct netdev_info *netdev_info;
+	int err;
+
+	netdev_info = get_netdev_info(req);
+	if (IS_ERR(netdev_info))
+		return PTR_ERR(netdev_info);
+
+	err = flow_table_delete_elem(netdev_info, &req->flow);
+	if (err)
+		return err;
+
+	return 0;
 }
 
 static void loop(void)
-- 
1.8.3.1

