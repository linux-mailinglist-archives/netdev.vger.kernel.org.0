Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6320E27DE38
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 04:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729717AbgI3CFx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 22:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729322AbgI3CFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Sep 2020 22:05:52 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 785DAC061755
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 19:05:52 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id i17so7791442oig.10
        for <netdev@vger.kernel.org>; Tue, 29 Sep 2020 19:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=T0BMwdFvGafs3VXiDpg3UXiEW7pVRzc87P0d5q2TBSw=;
        b=rfEZt0EsfLeVlfr9Y0EFVsMkwVoZFtSaiWgPoSMR5Dys3AV0XJL8/J1SfbklZQVJO1
         4zLaaNyWrlO/LRAvMA783bjwht+c7XqGXmvbNW6MKrdaLJqiHV/YNGF+/PH+5Dj5uo3J
         74P3n7Aj+Ujms6lYPMC0Ifw9/L5QKSxCfZhnAbCFtflQ6vj5LUqdLjIzzVteJlg+Ccv3
         B+2ZAclsEFM+pYbHpmtnufGceNqajMB9KkKghdAJqBHhNbNKtH6lquHUI4FwoVb6M7hR
         QaqiV3RSt76Y4erhWW0bk/IuvHaS4zXP+ZSrfGXnuq0+I4rQRV1emyMdnf5XHsfGWsdi
         p6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=T0BMwdFvGafs3VXiDpg3UXiEW7pVRzc87P0d5q2TBSw=;
        b=shXoDRL+RjPwTA75yDeSvi0bh6deE0cTxCzbfDBvxg6zj8LSA1MqoJGV0h0fd37yk5
         43QW9kMNRyHRw6mhgs92vfAXCHPeZAClPWo/eNrnB+ybfTS6ODgaNeMo1n50eRjqAYKU
         YAr0H5t1JSPaN8jwOilCLHkxOaR+BQOqGlkJ5lemmQeGcEFlbqKXqSLkaTpAhk+zBToy
         txR4iZ+EjEFpL4rS8WhqqG8J9acDfVXAh75PPGrSxOUiZCrFhkygn5A/a+C22GnaQGHi
         gcYJJtnnBRM5NNTqg2LsXBMd7Ypf4HQl/en4sjB31ubE79zTyrFQS2J36pW3zFrMBYc0
         F96g==
X-Gm-Message-State: AOAM533LgdRqb1C/nzRV4E32kbPa20bt+4XN00QDt+AbwPF4nYAq1VIU
        cX1urm4FqdzZWPsFDXn41tw=
X-Google-Smtp-Source: ABdhPJwDBP1sGpK+4M36t3OTguXYgxpsLNwX0xpGzwSB2+d7eRx4I7S1neyDWbXiG5hKIHBhmo0m5g==
X-Received: by 2002:aca:913:: with SMTP id 19mr189541oij.169.1601431551697;
        Tue, 29 Sep 2020 19:05:51 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id n186sm28043oob.11.2020.09.29.19.05.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 29 Sep 2020 19:05:50 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     jasowang@redhat.com, mst@redhat.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v2] virtio-net: ethtool configurable RXCSUM
Date:   Wed, 30 Sep 2020 10:03:00 +0800
Message-Id: <20200930020300.62245-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Allow user configuring RXCSUM separately with ethtool -K,
reusing the existing virtnet_set_guest_offloads helper
that configures RXCSUM for XDP. This is conditional on
VIRTIO_NET_F_CTRL_GUEST_OFFLOADS.

If Rx checksum is disabled, LRO should also be disabled.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
---
v2:
* LRO depends the rx csum
* remove the unnecessary check
---
 drivers/net/virtio_net.c | 49 ++++++++++++++++++++++++++++++----------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..5407a0106771 100644
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
@@ -2522,29 +2524,49 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
 	return 0;
 }
 
+static netdev_features_t virtnet_fix_features(struct net_device *netdev,
+					      netdev_features_t features)
+{
+	/* If Rx checksum is disabled, LRO should also be disabled.
+	 * That is life. :)
+	 */
+	if (!(features & NETIF_F_RXCSUM))
+		features &= ~NETIF_F_LRO;
+
+	return features;
+}
+
 static int virtnet_set_features(struct net_device *dev,
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
 
+	err = virtnet_set_guest_offloads(vi, offloads);
+	if (err)
+		return err;
+
+	vi->guest_offloads = offloads;
 	return 0;
 }
 
@@ -2563,6 +2585,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
+	.ndo_fix_features	= virtnet_fix_features,
 };
 
 static void virtnet_config_changed_work(struct work_struct *work)
@@ -3013,8 +3036,10 @@ static int virtnet_probe(struct virtio_device *vdev)
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

