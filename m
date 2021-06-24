Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFCD23B2B42
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231757AbhFXJV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:21:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231656AbhFXJVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:21:19 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C21EC061760;
        Thu, 24 Jun 2021 02:19:00 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j1so5801720wrn.9;
        Thu, 24 Jun 2021 02:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DuciXB8pC/S/cafIAkU7rNe3wfMQWIg6ua/o3EYWQgk=;
        b=YirveEKm5nW9Advs2EgBG4r4bLB00qOAjhdq6hMtC7BZOACkjyZTPKaPgF0Tmo5smE
         01A334WlLy6ddUAGtMgaOi5dqZKCjXEruCAiBN0rqV9bcHE0c3q6QMMj4DzLDbZe3vNc
         ++qslY10Lw9MwojPhKgB38LjEJpjBGZomcH793J79lJVW0uMkHS/wkczqjkPW9nuVIQ9
         EZe+5ofEYj2vYtbbWqvdow/nDz0Hj74YsYmBDdDTkWDAnd/Ul7rLG9EZUj7t+YvkX2DA
         OE4vndkwKu3s0z/VPLy+kahTJ0yHwjVCFt1ohxCiRII0DAR9aCnk28BWgfRfc5rZdvbb
         ZLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DuciXB8pC/S/cafIAkU7rNe3wfMQWIg6ua/o3EYWQgk=;
        b=E4RJ5wY32DewtX/6ZVzt4bkgFNgB/Cd/PpK7XL7Cyso2tnNiY+gmBYDkporRs9sbb1
         UQi/Ju6dY3DvRMV5EtCvzeTgaycMy1lb6myHTdnpbpXI7sOp56GKSLQdFQjTK8nSRr08
         7RchqKBGV6oD8aeCJ7Do8wwThlX7e+BkOx07QwB8/N0zCG+72p052A2HVA8IOYO20oow
         Q5eZLiXFheaN054XgCp4rVitnSexGHqQ4OB0Qt9iezXck41SAvahNH4hXBss92UCy3B3
         PutHNvmVLrzPJ1G3wy6JkmGFdW2KzssjQH0CSmglWdidCOV45oV9Nj3vObsmvY36CSM/
         fFBQ==
X-Gm-Message-State: AOAM5336M13UghnKNhnSNv7djsOKz7unl7xvuN0LorGAJvOXRskYD802
        TRpwxtgS+cQ2d+m0RRG8/Q2YH06YCg9bZr4=
X-Google-Smtp-Source: ABdhPJzIhL8DwCPWubiRYfU6YG5cV/d3+8cp6149ytNIu3E1a91PUCgAWwjLTXTkIK7Z7wff2p+iug==
X-Received: by 2002:a5d:69c3:: with SMTP id s3mr3323656wrw.235.1624526338829;
        Thu, 24 Jun 2021 02:18:58 -0700 (PDT)
Received: from localhost.localdomain (212-51-151-130.fiber7.init7.net. [212.51.151.130])
        by smtp.gmail.com with ESMTPSA id r1sm2456216wmh.32.2021.06.24.02.18.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 02:18:58 -0700 (PDT)
From:   joamaki@gmail.com
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, daniel@iogearbox.net, j.vosburgh@gmail.com,
        andy@greyhouse.net, vfalico@gmail.com, andrii@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        Jussi Maki <joamaki@gmail.com>
Subject: [PATCH bpf-next v2 4/4] devmap: Exclude XDP broadcast to master device
Date:   Thu, 24 Jun 2021 09:18:43 +0000
Message-Id: <20210624091843.5151-5-joamaki@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210624091843.5151-1-joamaki@gmail.com>
References: <20210609135537.1460244-1-joamaki@gmail.com>
 <20210624091843.5151-1-joamaki@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jussi Maki <joamaki@gmail.com>

If the ingress device is bond slave, do not broadcast back
through it or the bond master.

Signed-off-by: Jussi Maki <joamaki@gmail.com>
---
 kernel/bpf/devmap.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 2a75e6c2d27d..0864fb28c8b5 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -514,9 +514,11 @@ int dev_map_enqueue(struct bpf_dtab_netdev *dst, struct xdp_buff *xdp,
 }
 
 static bool is_valid_dst(struct bpf_dtab_netdev *obj, struct xdp_buff *xdp,
-			 int exclude_ifindex)
+			 int exclude_ifindex, int exclude_ifindex_master)
 {
-	if (!obj || obj->dev->ifindex == exclude_ifindex ||
+	if (!obj ||
+	    obj->dev->ifindex == exclude_ifindex ||
+	    obj->dev->ifindex == exclude_ifindex_master ||
 	    !obj->dev->netdev_ops->ndo_xdp_xmit)
 		return false;
 
@@ -546,12 +548,19 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	int exclude_ifindex = exclude_ingress ? dev_rx->ifindex : 0;
+	int exclude_ifindex_master = 0;
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
 	struct hlist_head *head;
 	struct xdp_frame *xdpf;
 	unsigned int i;
 	int err;
 
+	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
+		struct net_device *master = netdev_master_upper_dev_get_rcu(dev_rx);
+
+		exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
+	}
+
 	xdpf = xdp_convert_buff_to_frame(xdp);
 	if (unlikely(!xdpf))
 		return -EOVERFLOW;
@@ -559,7 +568,7 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = READ_ONCE(dtab->netdev_map[i]);
-			if (!is_valid_dst(dst, xdp, exclude_ifindex))
+			if (!is_valid_dst(dst, xdp, exclude_ifindex, exclude_ifindex_master))
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -579,7 +588,9 @@ int dev_map_enqueue_multi(struct xdp_buff *xdp, struct net_device *dev_rx,
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_rcu(dst, head, index_hlist,
 						 lockdep_is_held(&dtab->index_lock)) {
-				if (!is_valid_dst(dst, xdp, exclude_ifindex))
+				if (!is_valid_dst(dst, xdp,
+						  exclude_ifindex,
+						  exclude_ifindex_master))
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
@@ -646,16 +657,25 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 {
 	struct bpf_dtab *dtab = container_of(map, struct bpf_dtab, map);
 	int exclude_ifindex = exclude_ingress ? dev->ifindex : 0;
+	int exclude_ifindex_master = 0;
 	struct bpf_dtab_netdev *dst, *last_dst = NULL;
 	struct hlist_head *head;
 	struct hlist_node *next;
 	unsigned int i;
 	int err;
 
+	if (static_branch_unlikely(&bpf_master_redirect_enabled_key)) {
+		struct net_device *master = netdev_master_upper_dev_get_rcu(dev);
+
+		exclude_ifindex_master = (master && exclude_ingress) ? master->ifindex : 0;
+	}
+
 	if (map->map_type == BPF_MAP_TYPE_DEVMAP) {
 		for (i = 0; i < map->max_entries; i++) {
 			dst = READ_ONCE(dtab->netdev_map[i]);
-			if (!dst || dst->dev->ifindex == exclude_ifindex)
+			if (!dst ||
+			    dst->dev->ifindex == exclude_ifindex ||
+			    dst->dev->ifindex == exclude_ifindex_master)
 				continue;
 
 			/* we only need n-1 clones; last_dst enqueued below */
@@ -674,7 +694,9 @@ int dev_map_redirect_multi(struct net_device *dev, struct sk_buff *skb,
 		for (i = 0; i < dtab->n_buckets; i++) {
 			head = dev_map_index_hash(dtab, i);
 			hlist_for_each_entry_safe(dst, next, head, index_hlist) {
-				if (!dst || dst->dev->ifindex == exclude_ifindex)
+				if (!dst ||
+				    dst->dev->ifindex == exclude_ifindex ||
+				    dst->dev->ifindex == exclude_ifindex_master)
 					continue;
 
 				/* we only need n-1 clones; last_dst enqueued below */
-- 
2.27.0

