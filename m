Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A276E27A5D0
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 05:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgI1DmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 23:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgI1DmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 23:42:02 -0400
Received: from mail-ua1-x942.google.com (mail-ua1-x942.google.com [IPv6:2607:f8b0:4864:20::942])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B683C0613CE
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:42:02 -0700 (PDT)
Received: by mail-ua1-x942.google.com with SMTP id o64so1711085uao.1
        for <netdev@vger.kernel.org>; Sun, 27 Sep 2020 20:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5tf8R6j6ulK4E5b7bjR1T1ekmlta6QQ2PvHfvroeWjk=;
        b=EM54iXaY91q2HajRleaaczPoVQyPkZtt+3Gri/okZty+4lfRZAW3d1DE9IWUaD//L0
         KS9SlffXVdNbk6k9iglE87hUakp9eIxohYsPYByuIpP4UobzGO+CN+5ZIJDOIwAcztuS
         GsHTyrnaWZf4w+/GJNgORSfMdELcFYFJUi4sPSbwPTwIJ1pGCMflFpHO2AWk9i+lW27G
         VxSDK8b/7yXJfMY8dqVEBdTXDaI/6fjFYgetywD825D1yjgq4eO+EjHqd8h58NvS9v2t
         udcmCAhZPAtzbvxBGDmw45S5ViIITYF3hR+OYQVbFZcI/OCsLWGUUby2EnXar/C4g9w4
         BcmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5tf8R6j6ulK4E5b7bjR1T1ekmlta6QQ2PvHfvroeWjk=;
        b=NrijqdG1F3/csIZTOdYx8a/zuBsRM3X1pFmaqbi+qf0dJV6EWUfth+1eLRQSEKC8+K
         2thd/MEJgbigU8WsoZACoUb/FrGaBSaA5W8kpuqnN+CqtoPdcxoSEx8lme/IcMlJInm3
         AxnbtUFJFkZhIzciAqfcySpwNAZUH1qYX78MMT/KTXRvYMuxx8In6Pf00dXOAcEaW68R
         VBmNk3vZxBtw7JJX9psQh9sJGil5DF4tbMx5UyIw1E/0EUCtNch1N21riabIltTCyxhh
         jbP9hOElhJkfEgEFnA9H0WW/x3cQwP8m3eU23BamA+XscVzcBblGUsiVnhf6uHS9Ob4s
         VaSg==
X-Gm-Message-State: AOAM532Q57i3LkfbkGZwyi/dKrGmiRzmBSFlKuNWCkXRn8eyie/j6eP0
        Bt20SB5v5/c1LaG+D4wt+Ek=
X-Google-Smtp-Source: ABdhPJz4wgHxqorF8SymxYsgdMbcKMazO/YeVmbdARH513+nwqLFgXqj/M2+nsAmDOB16B58UweAiA==
X-Received: by 2002:a9f:24d4:: with SMTP id 78mr4051625uar.47.1601264521635;
        Sun, 27 Sep 2020 20:42:01 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id e3sm1363499vsa.8.2020.09.27.20.41.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 27 Sep 2020 20:42:01 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH 2/2] virtio-net: ethtool configurable RXCSUM
Date:   Mon, 28 Sep 2020 11:39:15 +0800
Message-Id: <20200928033915.82810-2-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
References: <20200928033915.82810-1-xiangxia.m.yue@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Allow user configuring RXCSUM separately with ethtool -K,
reusing the existing virtnet_set_guest_offloads helper
that configures RXCSUM for XDP. This is conditional on
VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
 drivers/net/virtio_net.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..2e3af0b2c281 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -68,6 +68,8 @@ static const unsigned long guest_offloads[] = {
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
 				(1ULL << VIRTIO_NET_F_GUEST_UFO))
 
+#define GUEST_OFFLOAD_CSUM_MASK (1ULL << VIRTIO_NET_F_GUEST_CSUM)
+
 struct virtnet_stat_desc {
 	char desc[ETH_GSTRING_LEN];
 	size_t offset;
@@ -2526,25 +2528,37 @@ static int virtnet_set_features(struct net_device *dev,
 				netdev_features_t features)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
-	u64 offloads;
+	u64 offloads = vi->guest_offloads &
+		       vi->guest_offloads_capable;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_LRO) {
-		if (vi->xdp_queue_pairs)
-			return -EBUSY;
+	/* Don't allow configuration while XDP is active. */
+	if (vi->xdp_queue_pairs)
+		return -EBUSY;
 
+	if ((dev->features ^ features) & NETIF_F_LRO) {
 		if (features & NETIF_F_LRO)
-			offloads = vi->guest_offloads_capable;
+			offloads |= GUEST_OFFLOAD_LRO_MASK;
 		else
-			offloads = vi->guest_offloads_capable &
-				   ~GUEST_OFFLOAD_LRO_MASK;
+			offloads &= ~GUEST_OFFLOAD_LRO_MASK;
+	}
 
-		err = virtnet_set_guest_offloads(vi, offloads);
-		if (err)
-			return err;
-		vi->guest_offloads = offloads;
+	if ((dev->features ^ features) & NETIF_F_RXCSUM) {
+		if (features & NETIF_F_RXCSUM)
+			offloads |= GUEST_OFFLOAD_CSUM_MASK;
+		else
+			offloads &= ~GUEST_OFFLOAD_CSUM_MASK;
 	}
 
+	if (offloads == (vi->guest_offloads &
+			 vi->guest_offloads_capable))
+		return 0;
+
+	err = virtnet_set_guest_offloads(vi, offloads);
+	if (err)
+		return err;
+
+	vi->guest_offloads = offloads;
 	return 0;
 }
 
@@ -3013,8 +3027,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
 		dev->features |= NETIF_F_LRO;
-	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS)) {
+		dev->hw_features |= NETIF_F_RXCSUM;
 		dev->hw_features |= NETIF_F_LRO;
+	}
 
 	dev->vlan_features = dev->features;
 
-- 
2.23.0

