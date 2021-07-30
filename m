Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62DAD3E016B
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 14:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238272AbhHDMqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 08:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238212AbhHDMqY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 08:46:24 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB6BC0617A5;
        Wed,  4 Aug 2021 05:45:51 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id p5so2099266wro.7;
        Wed, 04 Aug 2021 05:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FwNUMow4yx8eykTioVcbeIXw0nALj5ZFKgzUGGqXCuI=;
        b=iqigE/qpNtNi4z//7iL6mOm4SslaiugFIMkW0jN02Ww+RdS4UlYCTXZG5klmdKiiSD
         grHyc9bVXLKQr8MfocTLimBPDMVe4wGL5Kkxr8OhVLKTk1dv1DKLVM4MUFsJek40uwzZ
         EBg5T6e4nOhFwGFB5DtYBN2cjClbaPfEbySrxk/IaGMeKLU9zGJ/6RyxKLU0ZNigOvQJ
         mccAWmh050yug3cASmRaLfbxT10yp7sg8rGBm9tw9kfIGKWwM6OgBXNr2CbpDeboi+e4
         LJJy9Aj/PX/YWC8QM1sIfFrgDtQbfFpqKlRNvk71Tq++2I09+Lm30Gx2z77vNBwaVzT/
         DMLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FwNUMow4yx8eykTioVcbeIXw0nALj5ZFKgzUGGqXCuI=;
        b=Mpf2jYBlxaVLp4Agl6UpvPW9BjVjZnItvQGIL85YyaLYqnlU6oCggSxA0noWnawEgE
         BsCWVhm8mfvQPj6WXxDLXp6+dTXlIym68tknLmkKXXV1ZwFjSPlD8yTG4GIWfinJuEmW
         ImAIS4VgbbWzM7xmlj5L895wKI6g4rtXKpt6fgNfLXwvxn/cHdX8w5PMEkuCZonHCmOR
         KBWMZn8FbAzxLcTZgErTBFNH0fAjgbYa0Vb8JvXvO32y13lO5ervMJK5ynSmJYoBssjV
         RkPRC35A7PuoM72MdOp4ucStvedWJ+pkYr6VWV4jmvRtnXA77Ngtlz7lY0alubES+ry3
         ru2g==
X-Gm-Message-State: AOAM530JI0iaz0TH+EydxKdI/mZ6ELJigmnYb30YocJNd+Fh+D2eUizp
        Y8dA2eNkstssAGKYI560ApGsdkbO3hAofFk=
X-Google-Smtp-Source: ABdhPJzJJrD1RQ9ztGi79k09b4fIYXYyXWW86QrOp0Ng2p1eZVx0KH/JbctGhHmHA8SuG2HBj0+SPA==
X-Received: by 2002:adf:f5d1:: with SMTP id k17mr29043590wrp.123.1628081149740;
        Wed, 04 Aug 2021 05:45:49 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id y4sm2257923wmi.22.2021.08.04.05.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 05:45:49 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v5 4/7] devmap: Exclude XDP broadcast to master device
Date:   Fri, 30 Jul 2021 06:18:19 +0000
Message-Id: <20210730061822.6600-5-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210730061822.6600-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210730061822.6600-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the ingress device is bond slave, do not broadcast back
through it or the bond master.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 kernel/bpf/devmap.c | 69 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 60 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 542e94fa30b4..f02d04540c0c 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -534,10 +534,9 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 	return __xdp_enqueue(dev, xdp, dev_rx, dst->xdp_prog);
 }
 
-static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp,
-			 int exclude_ifindex)
+static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp)
 {
-	if (!obj || obj->dev->ifindex == exclude_ifindex ||
+	if (!obj ||
 	    !obj->dev->netdev_ops->ndo_xdp_xmit)
 		return false;
 
@@ -562,17 +561,48 @@ static int dev_map_enqueue_clone(struct bpf_dtab_netdev *obj,
 	return 0;
 }
 
+static inline bool is_ifindex_excluded(int *excluded, int num_excluded, int ifindex)
+{
+	while (num_excluded--) {
+		if (ifindex == excluded[num_excluded])
+			return true;
+	}
+	return false;
+}
+
+/* Get ifindex of each upper device. 'indexes' must be able to hold at
+ * least MAX_NEST_DEV elements.
+ * Returns the number of ifindexes added.
+ */
+static int get_upper_ifindexes(struct net_device *dev, int *indexes)
+{
+	struct net_device *upper;
+	struct list_head *iter;
+	int n = 0;
+
+	netdev_for_each_upper_dev_rcu(dev, upper, iter) {
+		indexes[n++] = upper->ifindex;
+	}
+	return n;
+}
+
 int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 			  struct bpf_map *map, bool exclude_ingress)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
+	int excluded_devices[1+MAX_NEST_DEV];
 	struct hlist_head *head;
 	struct xdp_frame *xdpf;
+	int num_excluded = 0;
 	unsigned int i;
 	int err;
 
+	if (exclude_ingress) {
+		num_excluded = get_upper_ifindexes(dev_rx, excluded_devices);
+		excluded_devices[num_excluded++] = dev_rx->ifindex;
+	}
+
 	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
@@ -581,7 +611,10 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 		for (i = 0; i < map->max_entries; i++) {
 			dst = rcu_dereference_check(dtab->netdev_map[i],
 						    rcu_read_lock_bh_held());
-			if (!is_valid_dst(dst, xdp, exclude_ifindex))
+			if (!is_valid_dst(dst, xdp))
+				continue;
+
+			if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -601,7 +634,11 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_rcu(dst, head, index_hlist,
 						 lockdep_is_held(&dtab->index_lock)) {
-				if (!is_valid_dst(dst, xdp, exclude_ifindex))
+				if (!is_valid_dst(dst, xdp))
+					continue;
+
+				if (is_ifindex_excluded(excluded_devices, num_excluded,
+							dst->dev->ifindex))
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
@@ -675,18 +712,27 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 			   bool exclude_ingress)
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
-	int exclude_ifindex = exclude_ingress ? dev->ifindex : 0;
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
+	int excluded_devices[1+MAX_NEST_DEV];
 	struct hlist_head *head;
 	struct hlist_node *next;
+	int num_excluded = 0;
 	unsigned int i;
 	int err;
 
+	if (exclude_ingress) {
+		num_excluded = get_upper_ifindexes(dev, excluded_devices);
+		excluded_devices[num_excluded++] = dev->ifindex;
+	}
+
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = rcu_dereference_check(dtab->netdev_map[i],
 						    rcu_read_lock_bh_held());
-			if (!dst || dst->dev->ifindex == exclude_ifindex)
+			if (!dst)
+				continue;
+
+			if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -700,12 +746,17 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 				return err;
 
 			last_dst = dst;
+
 		}
 	} else { /* BPF_MAP_TYPE_DEVMAP_HASH */
 		for (i = 0; i < dtab->n_buckets; i++) {
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
-				if (!dst || dst->dev->ifindex == exclude_ifindex)
+				if (!dst)
+					continue;
+
+				if (is_ifindex_excluded(excluded_devices, num_excluded,
+							dst->dev->ifindex))
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
-- 
2.17.1

