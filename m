Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0EF9109BDA
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfKZKJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:09:30 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43964 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727838AbfKZKJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:09:29 -0500
Received: by mail-pl1-f193.google.com with SMTP id q16so3746383plr.10;
        Tue, 26 Nov 2019 02:09:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=04y2jMBz+TniBsSijixdhxAgItaCRW1Bg/M7TEdqtZw=;
        b=qNxv9romfmc3q9HrRe1SsyMGoaUYYBfCAqMUu5CAK2O3s3+yZxepf2025cJPH3wVaq
         YdPZyUS+KjlG/AyXxckpOaJIFC/CznF+s9mOw22e/xJsgsAaSfC+QzI6FDrXI81xPOtl
         jHxPnXyPvnymn3KeFZk8QSD+AqaskNH3wrtAVq4sk73gCruVUF8q2EL+osao+obGfuXa
         E4Yvk9grWBs1sV7Ecjvmb2aJXX2sdhUMcocV9tdygaC/9AnOyqH6hyLQHPQRz4EYZYed
         OROth7uyN6VTu0xFGEmoI2bu6lRMgCUIYSq4c1GTkIT6StqdUJfKPl1MlLtm9JNoEsMG
         eJtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=04y2jMBz+TniBsSijixdhxAgItaCRW1Bg/M7TEdqtZw=;
        b=WuOt0R5P+aHp0NvYE6cx4qY6SXX1uIYItAvDicP83V2CYKFZh+tvSlKrJpytXbveK3
         Vw+xGU6pr5Gur6eEmCA7MSBoGsnh5rO27wBUpgOvAQN9S56/kFpzWLp/V4PFpgDGohbc
         DmJ7oiLB1uJ3ptLLNCGzNouRdzNRrCIhWVH8ZGaQz7SlekmfyRbWpB+FH6jXscp9cYOP
         c3q1iXAy+uPpn9Mu+J9I2n5DOzl5rZe8duKeV9Qh4HaOVU5233TQNeaeZ5xi97Tw2VMG
         FMLpFpcHCV18wRkDQD4oUR/9wIu/uqKwwwzH3tJaBlBDDsAMyUOjP5Hqqc8y/H4huEe5
         KzEw==
X-Gm-Message-State: APjAAAVAI1d9oMvZoF8JHT500prMlK0YcDxWxtlGuaziRh30HNhFdj+q
        rThK9ZAfEuPIWehLIwhNCwo=
X-Google-Smtp-Source: APXvYqwRnyofw+ROJrA/0vdTheynnaSCjgx1858Q2XAMEgN8s0N0WdIa2wiPcUAvtMOS75RBHUMq6A==
X-Received: by 2002:a17:902:758a:: with SMTP id j10mr34601161pll.29.1574762968666;
        Tue, 26 Nov 2019 02:09:28 -0800 (PST)
Received: from localhost.localdomain ([222.151.198.97])
        by smtp.gmail.com with ESMTPSA id s24sm11848485pfh.108.2019.11.26.02.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Nov 2019 02:09:28 -0800 (PST)
From:   Prashant Bhole <prashantbhole.linux@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        "Michael S . Tsirkin" <mst@redhat.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Prashant Bhole <prashantbhole.linux@gmail.com>
Subject: [RFC net-next 12/18] virtio-net: store xdp_prog in device
Date:   Tue, 26 Nov 2019 19:07:38 +0900
Message-Id: <20191126100744.5083-13-prashantbhole.linux@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
References: <20191126100744.5083-1-prashantbhole.linux@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>

This is a preparation for adding XDP offload support in virtio_net
driver. By storing XDP program in virtionet_info will make it
consistent with the offloaded program which will introduce in next
patches.

Signed-off-by: Jason Wang <jasowang@redhat.com>
Co-developed-by: Prashant Bhole <prashantbhole.linux@gmail.com>
Signed-off-by: Prashant Bhole <prashantbhole.linux@gmail.com>
---
 drivers/net/virtio_net.c | 62 ++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 37 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 4d7d5434cc5d..c8bbb1b90c1c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -137,8 +137,6 @@ struct receive_queue {
 
 	struct napi_struct napi;
 
-	struct bpf_prog __rcu *xdp_prog;
-
 	struct virtnet_rq_stats stats;
 
 	/* Chain pages by the private ptr. */
@@ -229,6 +227,8 @@ struct virtnet_info {
 
 	/* failover when STANDBY feature enabled */
 	struct failover *failover;
+
+	struct bpf_prog __rcu *xdp_prog;
 };
 
 struct padded_vnet_hdr {
@@ -486,7 +486,6 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 			    int n, struct xdp_frame **frames, u32 flags)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	struct receive_queue *rq = vi->rq;
 	struct bpf_prog *xdp_prog;
 	struct send_queue *sq;
 	unsigned int len;
@@ -501,7 +500,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 	/* Only allow ndo_xdp_xmit if XDP is loaded on dev, as this
 	 * indicate XDP resources have been successfully allocated.
 	 */
-	xdp_prog = rcu_dereference(rq->xdp_prog);
+	xdp_prog = rcu_dereference(vi->xdp_prog);
 	if (!xdp_prog)
 		return -ENXIO;
 
@@ -649,7 +648,7 @@ static struct sk_buff *receive_small(struct net_device *dev,
 	stats->bytes += len;
 
 	rcu_read_lock();
-	xdp_prog = rcu_dereference(rq->xdp_prog);
+	xdp_prog = rcu_dereference(vi->xdp_prog);
 	if (xdp_prog) {
 		struct virtio_net_hdr_mrg_rxbuf *hdr = buf + header_offset;
 		struct xdp_frame *xdpf;
@@ -798,7 +797,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	stats->bytes += len - vi->hdr_len;
 
 	rcu_read_lock();
-	xdp_prog = rcu_dereference(rq->xdp_prog);
+	xdp_prog = rcu_dereference(vi->xdp_prog);
 	if (xdp_prog) {
 		struct xdp_frame *xdpf;
 		struct page *xdp_page;
@@ -2060,7 +2059,7 @@ static int virtnet_set_channels(struct net_device *dev,
 	 * also when XDP is loaded all RX queues have XDP programs so we only
 	 * need to check a single RX queue.
 	 */
-	if (vi->rq[0].xdp_prog)
+	if (vi->xdp_prog)
 		return -EINVAL;
 
 	get_online_cpus();
@@ -2441,13 +2440,10 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		return -ENOMEM;
 	}
 
-	old_prog = rtnl_dereference(vi->rq[0].xdp_prog);
+	old_prog = rtnl_dereference(vi->xdp_prog);
 	if (!prog && !old_prog)
 		return 0;
 
-	if (prog)
-		bpf_prog_add(prog, vi->max_queue_pairs - 1);
-
 	/* Make sure NAPI is not using any XDP TX queues for RX. */
 	if (netif_running(dev)) {
 		for (i = 0; i < vi->max_queue_pairs; i++) {
@@ -2457,11 +2453,8 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	}
 
 	if (!prog) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
-			if (i == 0)
-				virtnet_restore_guest_offloads(vi);
-		}
+		rcu_assign_pointer(vi->xdp_prog, prog);
+		virtnet_restore_guest_offloads(vi);
 		synchronize_net();
 	}
 
@@ -2472,16 +2465,12 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	vi->xdp_queue_pairs = xdp_qp;
 
 	if (prog) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			rcu_assign_pointer(vi->rq[i].xdp_prog, prog);
-			if (i == 0 && !old_prog)
-				virtnet_clear_guest_offloads(vi);
-		}
+		rcu_assign_pointer(vi->xdp_prog, prog);
+		if (!old_prog)
+			virtnet_clear_guest_offloads(vi);
 	}
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
-		if (old_prog)
-			bpf_prog_put(old_prog);
 		if (netif_running(dev)) {
 			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
 			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
@@ -2489,13 +2478,15 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 		}
 	}
 
+	if (old_prog)
+		bpf_prog_put(old_prog);
+
 	return 0;
 
 err:
 	if (!prog) {
 		virtnet_clear_guest_offloads(vi);
-		for (i = 0; i < vi->max_queue_pairs; i++)
-			rcu_assign_pointer(vi->rq[i].xdp_prog, old_prog);
+		rcu_assign_pointer(vi->xdp_prog, old_prog);
 	}
 
 	if (netif_running(dev)) {
@@ -2514,13 +2505,11 @@ static u32 virtnet_xdp_query(struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	const struct bpf_prog *xdp_prog;
-	int i;
 
-	for (i = 0; i < vi->max_queue_pairs; i++) {
-		xdp_prog = rtnl_dereference(vi->rq[i].xdp_prog);
-		if (xdp_prog)
-			return xdp_prog->aux->id;
-	}
+	xdp_prog = rtnl_dereference(vi->xdp_prog);
+	if (xdp_prog)
+		return xdp_prog->aux->id;
+
 	return 0;
 }
 
@@ -2657,18 +2646,17 @@ static void virtnet_free_queues(struct virtnet_info *vi)
 
 static void _free_receive_bufs(struct virtnet_info *vi)
 {
-	struct bpf_prog *old_prog;
+	struct bpf_prog *old_prog = rtnl_dereference(vi->xdp_prog);
 	int i;
 
 	for (i = 0; i < vi->max_queue_pairs; i++) {
 		while (vi->rq[i].pages)
 			__free_pages(get_a_page(&vi->rq[i], GFP_KERNEL), 0);
-
-		old_prog = rtnl_dereference(vi->rq[i].xdp_prog);
-		RCU_INIT_POINTER(vi->rq[i].xdp_prog, NULL);
-		if (old_prog)
-			bpf_prog_put(old_prog);
 	}
+
+	RCU_INIT_POINTER(vi->xdp_prog, NULL);
+	if (old_prog)
+		bpf_prog_put(old_prog);
 }
 
 static void free_receive_bufs(struct virtnet_info *vi)
-- 
2.20.1

