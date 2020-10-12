Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8128E28AB94
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 04:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726773AbgJLCDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 22:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgJLCDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 22:03:42 -0400
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB0DC0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:03:42 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id h10so4501188oie.5
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 19:03:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=j13Tylr9YBkdZ0Q6y1P4zQEjpOu1kWVXCB0vaRAU130=;
        b=ACNIBePjoAnvCfSd8s6z6kT8Js7T1Vq8g5oAhpnPtxIFeCpdFE4v/k2DUyARLJ53k7
         Fi/I672QmETEm/7L59US6zBtJgm5feW8XfCvfGsnr53Ybbw5ONXV0UDxa9U1OC2ogGPo
         D0Oi5XUTwPgOil4yyxWQiKvHzigAjPtRyAXivyL0A8Rh0Nq4JCkXCqgb3DCAuruzZy4b
         EjDhj4RGTAfmlBlGiUYBvE0OOHC4khrVj/N064OEuklRLtIsE7eocTE8JrhFKkYV6UQu
         0AeuKbw2UOX+EQN9u+aCXtqbmPqvp57iOEdrzVgHNYvviyHdM+UUixpdeeqZ3bfXhemR
         P3aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=j13Tylr9YBkdZ0Q6y1P4zQEjpOu1kWVXCB0vaRAU130=;
        b=S0Kq2VUkkoWu7ypzTXLMDw2p6eIdm2KCyS2ucS2ZygPHv9SJ0p60bNm4gJTEWaUFWo
         B8EwxjiOFhJkZnu5nrTihromsJybRyezvGECGvQ6H2xV/MRevbBkm67yl+s6k1ON+e1w
         1eiZDhX54GQHOyJT4XycKYhfpTUkvYeKVrP146xXDDH+lPNJcYyKlgOm8bxH6otIreb1
         nexxLN4IryjX6tku/bcHZvTk+viExdz/+ZSdI2mlY32OSpA+kGgPZaaoasIx5qcuoSJm
         +tnIHP3JjISggKYDxNT2XRScS53Q4Mx2MfExL3pRXAkUblBX9Vj4/4gd7604a3l48+ft
         bN8Q==
X-Gm-Message-State: AOAM5315N37l4/x8WPjTvQ8GIPU4tTFpknf0T5iQOkC0A4I3cEn8+niG
        OpNaO5kOYJeTn1DUtRcwFhlh3oeCRoo=
X-Google-Smtp-Source: ABdhPJzbSZngaFCV4YYKgEgA+zeTPsGl4ocGWWpONXc9jQ04lXVYHQZD/kFhwp5l2bt+VbTQZSy97g==
X-Received: by 2002:aca:3a57:: with SMTP id h84mr9778654oia.95.1602468220426;
        Sun, 11 Oct 2020 19:03:40 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id t12sm1560471oth.13.2020.10.11.19.03.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Oct 2020 19:03:39 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     jasowang@redhat.com, mst@redhat.com, willemb@google.com
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3] virtio-net: ethtool configurable RXCSUM
Date:   Mon, 12 Oct 2020 09:58:20 +0800
Message-Id: <20201012015820.62042-1-xiangxia.m.yue@gmail.com>
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
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c | 48 ++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 21b71148c532..d2d2c4a53cf2 100644
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
@@ -2522,29 +2524,48 @@ static int virtnet_get_phys_port_name(struct net_device *dev, char *buf,
 	return 0;
 }
 
+static netdev_features_t virtnet_fix_features(struct net_device *netdev,
+					      netdev_features_t features)
+{
+	/* If Rx checksum is disabled, LRO should also be disabled. */
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
+	u64 offloads = vi->guest_offloads;
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
+			offloads |= GUEST_OFFLOAD_LRO_MASK &
+				    vi->guest_offloads_capable;
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
+			offloads |= GUEST_OFFLOAD_CSUM_MASK &
+				    vi->guest_offloads_capable;
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
 
@@ -2563,6 +2584,7 @@ static const struct net_device_ops virtnet_netdev = {
 	.ndo_features_check	= passthru_features_check,
 	.ndo_get_phys_port_name	= virtnet_get_phys_port_name,
 	.ndo_set_features	= virtnet_set_features,
+	.ndo_fix_features	= virtnet_fix_features,
 };
 
 static void virtnet_config_changed_work(struct work_struct *work)
@@ -3013,8 +3035,10 @@ static int virtnet_probe(struct virtio_device *vdev)
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

