Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E076B3E1922
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 18:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230340AbhHEQKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 12:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbhHEQKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 12:10:39 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FEFDC061765;
        Thu,  5 Aug 2021 09:10:24 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id o7-20020a05600c5107b0290257f956e02dso6747396wms.1;
        Thu, 05 Aug 2021 09:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=FwNUMow4yx8eykTioVcbeIXw0nALj5ZFKgzUGGqXCuI=;
        b=kWkJ6W9uRz9I2Kox3StSZblgI+rlpReZhZq1CMZbC4Ffmid1UCBkCQhPi2bwa5+TU5
         mApLEMt4BTKRywlukyd0iOp89gcClowrRLqXSqp8IozTVHOXGWMXrbUHaVEgKc7hnEkG
         oxRhL/okfVqs/NTdfmEZMlXpKTlUFDv4o2uFV0rC4ZtE2e754UZpTy2ERzw5ERWu/YCa
         HQjRmIJM27G9EqQVXS2plJT9UZLUYOysHRK0cRnP607uEX+EBlc+s1Pgwdp38gyGhJhm
         kH0mTyM+G4d/98o98xN8iZrp86JowcBA5rrAmpCzkKzeHH3RTEjwmgtF7rFeomBvTumx
         Pijg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=FwNUMow4yx8eykTioVcbeIXw0nALj5ZFKgzUGGqXCuI=;
        b=ssodPA55kkYkB41ZYnCeLr3bzaqMBz6btbk0gzmZWvAHZziBA3UvhPmiVCWjEOWWkH
         jNvv1hrHML2g/rFTiAAqeJXaA/O9glH1MJM+vY0Na+ddYymcd7pStXN/9L/Mkxc6jw6+
         8kIm/EEM1yc3vAwjFmFUuQC3Hmoa5mL6dsRCf2EV7k6ntJRNEkdegV5tniSU0h72np1o
         +anXbC+G1yPw0B5T41U+CxqbCns4z4I+VDkLWEHa/jtr/xMDsj9WN65SB9Bv7txVV3+0
         ZcL8jIrbvyKV/F769GcbGICJZynTBQ+6U7DJDNffNhBLPUdiZXMzZSFxJelGOkQYzgrP
         p9Fg==
X-Gm-Message-State: AOAM530d/+Z4ii6PCHZaOHGiC8tspu6qquxmTiSdlfU8sIx0yeXO+hud
        iMMiO0LE/RLxdSVybKdaxHMIMTNIfkRvjQc=
X-Google-Smtp-Source: ABdhPJwR9ng7EoM7VLl3TzR0+CUh7/XqLjmNV7+W388Ojy589rGnFzY6EL8sSTLTDQubXhxCnL3frQ==
X-Received: by 2002:a1c:9814:: with SMTP id a20mr5691429wme.158.1628179822810;
        Thu, 05 Aug 2021 09:10:22 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id n5sm5843968wme.47.2021.08.05.09.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Aug 2021 09:10:22 -0700 (PDT)
From:   Jussi Maki <joamaki@gmail.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v6 4/7] devmap: Exclude XDP broadcast to master device
Date:   Sat, 31 Jul 2021 05:57:35 +0000
Message-Id: <20210731055738.16820-5-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210731055738.16820-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210731055738.16820-1-joamaki@gmail.com>
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

