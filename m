Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040323DD702
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 15:24:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhHBNYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233890AbhHBNYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 09:24:42 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69BDC0613D5;
        Mon,  2 Aug 2021 06:24:32 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id h13so8005757wrp.1;
        Mon, 02 Aug 2021 06:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vaJwQrK6XnCVWVz6C698P4rwrhO7Vqhi/zsjGqPX+Xc=;
        b=L7VkW0j0IxlED55V/FfQ3KOjn+EL57mpKEuFtKKnu9b3wgxwGYeUGdZF+e91lqzPN5
         pXnekoXPRtcV5V0MdNln17aPpTsDNA7g3Qx5Aony1L+PPYdvcQs8WYvtmpHK1H56EpPO
         OAahu5HgQweonzYRdMUhZ4/YjhMwp1v9JxewkSu5VTm6NpQ1Bl03S/o0pShu86G5MADL
         rn1jOAtjMv5oLOYnwBKerxo5xHy5vqNJ7cpJHAVIGO4Madx3mvdK1X2Bh3NoFS1t2eDf
         UwE1RtuSLg6NtiqfdjJmV1sAKqzGWKjiRaqGFLyMTBN7StSZrg2p6syWGvVU4A7NP7Jj
         7q1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vaJwQrK6XnCVWVz6C698P4rwrhO7Vqhi/zsjGqPX+Xc=;
        b=n2FC2s1qZJcQRq/bu2fAhC3Vs/ZBG4B31MiBr0EWQNTaGO+NhxyjvWelK5xeUK4aAt
         i2/Ksi14WQkgbtk8/khYtVmp10XV1dqvb92ukxk40ViXznp4rCwSjllAJ8sgx86kIWYl
         QVdfSs861DkPUZPzP6xrQA9adk2NgCIRE3dapeUg1U6GDBZ/k2h81Ali3iyssadvo6Zd
         jNuO7qUMoTzfyP2coKvIYYmHOgzjqSsUw8soxU1+lKpFrlBrDPnz38yXyxj3GGUCC66X
         EXV4QiJIDkbPzYXKqEHIOWy3aGay+QxCbS6H/jNWgePfX6MLUS82roN1hDWQJ5lB0JMS
         LC3w==
X-Gm-Message-State: AOAM531APYaTmKJDJsXkVRbGl3rlUuMPuLY4nJIzFeJC7vlLVY8uhCI5
        tWFDXaKYDu8e2F/9P0wxWpElxNu6mKJNRxw=
X-Google-Smtp-Source: ABdhPJzKn9BTNmQOIpnm6j2lWfHMcdaHU5HDiNivltBEP/D6ouisVbDj/dPKHHZ4Q6Psfog4H4QSig==
X-Received: by 2002:adf:d20a:: with SMTP id j10mr17682621wrh.152.1627910671017;
        Mon, 02 Aug 2021 06:24:31 -0700 (PDT)
Received: from localhost.localdomain ([77.109.191.101])
        by smtp.gmail.com with ESMTPSA id o28sm11731404wra.71.2021.08.02.06.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:24:30 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v4 4/6] devmap: Exclude XDP broadcast to master device
Date:   Wed, 28 Jul 2021 23:43:48 +0000
Message-Id: <20210728234350.28796-5-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728234350.28796-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210728234350.28796-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

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

