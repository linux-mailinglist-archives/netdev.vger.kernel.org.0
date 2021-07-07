Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AB3A3BE8A3
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbhGGNQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 09:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbhGGNQd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 09:16:33 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E10BC061574;
        Wed,  7 Jul 2021 06:13:52 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id v14so4013508lfb.4;
        Wed, 07 Jul 2021 06:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=szhLgRNn2mxwQb9lPucnAU8zBhE18PLmOepuhR1I3UQ=;
        b=Jr8z3VOin9cYQ0bDcc8uijLJCLeqKPQNOmbcl3QbpNCwm3elRETn/Eb+jVlnfT6LUw
         AH06lMIeHQkk9Z9OmEV4ZQCAifqP7odXLnpZcHiH0pB4bgG214kcy/4ygDLWgDPHS8g6
         JyjClDKJsFw5F0WsUI+HJMT5UBSPtEgKt5Tu4oJ2USaWlyoejVzZn3+S4btkX+c4tTPk
         mY7e2s8DVhBl0TYbQMQkmlmhlOpqFwWWEaJ9bs3wnNL1UtgCwj1BPr4IFkd4N2mZbHZ5
         zkEz0SgsejL5RmKc2HUS7vJZFzPDwmLXIBknX47RmeW6LflMiq3TnuE0/6mXA6Rdsfq0
         Sp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=szhLgRNn2mxwQb9lPucnAU8zBhE18PLmOepuhR1I3UQ=;
        b=H1ymihZ18BGUOSdegcjM0V8zx+uVQJ7sl3UBfFT/P6uTgt1EuJ0faouGOnJH0/BhG/
         yL+AJifEN814iO3wt81MIq+XnkHU7YJ5E8ytn7v0/N5NXdL15zhbVQpMynLYNjgin9DN
         AyS8EF5j5IPrLieEcxDSrrfEORVLerJxsMx3+FtN6+xU4iaj4+GLWRjAoJlRyaJhYgtk
         58FDvg9ADzDc3rz64rU5xcg/jXL1jGhaBzcyUABi06iqvjAJaue3+QDunp31LSMJT66r
         7+s+pKO45tO8U1K3W4O32F0bQ5IOcM15iIyppoBw61XJXYPjDBOsM07up+vJwxkfemKm
         PPBA==
X-Gm-Message-State: AOAM531aPUfU1IRxk8tsno9dat3i90vCFyXtEmEuEVH/6r5fy01CaKbH
        kP6gVoKcgnYs9JqQZwfuidu9m2dvsmE73RtPlA==
X-Google-Smtp-Source: ABdhPJwDyMsBNV0tytFZIq/rZKQ6lqEE88NGMNS512fSlVvvrbdg+rsy9cMGaL2ct0UrmwKcQoTOtw==
X-Received: by 2002:a19:c508:: with SMTP id w8mr18719802lfe.446.1625663630124;
        Wed, 07 Jul 2021 06:13:50 -0700 (PDT)
Received: from localhost.localdomain ([89.42.43.188])
        by smtp.gmail.com with ESMTPSA id u9sm1423571lfm.127.2021.07.07.06.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 06:13:49 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v3 4/5] devmap: Exclude XDP broadcast to master device
Date:   Wed,  7 Jul 2021 11:25:50 +0000
Message-Id: <20210707112551.9782-5-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210707112551.9782-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210707112551.9782-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the ingress device is bond slave, do not broadcast back
through it or the bond master.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 kernel/bpf/devmap.c | 67 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 58 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2546dafd6672..c1a2dfb88724 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -513,10 +513,9 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
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
 
@@ -541,17 +540,48 @@ static int dev_map_enqueue_clone(struct bpf_dtab_netdev *obj,
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
@@ -559,7 +589,10 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = READ_ONCE(dtab->netdev_map[i]);
-			if (!is_valid_dst(dst, xdp, exclude_ifindex))
+			if (!is_valid_dst(dst, xdp))
+				continue;
+
+			if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -579,7 +612,10 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_rcu(dst, head, index_hlist,
 						 lockdep_is_held(&dtab->index_lock)) {
-				if (!is_valid_dst(dst, xdp, exclude_ifindex))
+				if (!is_valid_dst(dst, xdp))
+					continue;
+
+				if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
@@ -645,17 +681,26 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
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
 			dst = READ_ONCE(dtab->netdev_map[i]);
-			if (!dst || dst->dev->ifindex == exclude_ifindex)
+			if (!dst)
+				continue;
+
+			if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -669,12 +714,16 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
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
+				if (is_ifindex_excluded(excluded_devices, num_excluded, dst->dev->ifindex))
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
-- 
2.27.0

