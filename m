Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 955D73EE424
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235953AbhHQCEa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:04:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30396 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233394AbhHQCE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 22:04:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629165837;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Oe74KUoqJHrJWPuwrj1dbWTw7Ns3p122axDxZOz+uFY=;
        b=CdyHxWdZocNS1El25dlLWmI3hnPYgj2A7TrtMepo0vlksTF6uG9FwBAdZDONA0QTJ9oz/L
        E2UHlk9E52wvijonaFYi8O1Szwo+hXVx0GnVHETpvWGi4IFUNYmmatz3o0PFcQDfynTXak
        6TLRfBl0GnW1kPG7UyWj2XD2pVdNmdY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-FppgmRmjMhGXea1rNUOKqw-1; Mon, 16 Aug 2021 22:03:55 -0400
X-MC-Unique: FppgmRmjMhGXea1rNUOKqw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2797687122E;
        Tue, 17 Aug 2021 02:03:54 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-226.pek2.redhat.com [10.72.12.226])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6C78B19C44;
        Tue, 17 Aug 2021 02:03:46 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     willemb@google.com, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivan@prestigetransportation.com, xiangxia.m.yue@gmail.com
Subject: [PATCH net] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
Date:   Tue, 17 Aug 2021 10:03:38 +0800
Message-Id: <20210817020338.6400-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO") tries to
advertise LRO on behalf of the guest offloading features and allow the
administrator to enable and disable those features via ethtool.

This may lead several issues:

- For the device that doesn't support control guest offloads, the
  "LRO" can't be disabled so we will get a warn in the
  dev_disable_lro()
- For the device that have the control guest offloads, the guest
  offloads were disabled in the case of bridge etc which may slow down
  the traffic.

Fixing this by using NETIF_F_GRO_HW instead. Though the spec does not
guaranteed to be re-segmented as original explicitly now, we can add
that to the spec and then we can catch the bad configuration and
setup.

Fixes: a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0416a7e00914..10c382b08bce 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -63,7 +63,7 @@ static const unsigned long guest_offloads[] = {
 	VIRTIO_NET_F_GUEST_CSUM
 };
 
-#define GUEST_OFFLOAD_LRO_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
+#define GUEST_OFFLOAD_GRO_HW_MASK ((1ULL << VIRTIO_NET_F_GUEST_TSO4) | \
 				(1ULL << VIRTIO_NET_F_GUEST_TSO6) | \
 				(1ULL << VIRTIO_NET_F_GUEST_ECN)  | \
 				(1ULL << VIRTIO_NET_F_GUEST_UFO))
@@ -2481,7 +2481,7 @@ static int virtnet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
 	        virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_ECN) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_UFO) ||
 		virtio_has_feature(vi->vdev, VIRTIO_NET_F_GUEST_CSUM))) {
-		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing LRO/CSUM, disable LRO/CSUM first");
+		NL_SET_ERR_MSG_MOD(extack, "Can't set XDP while host is implementing GRO_HW/CSUM, disable GRO_HW/CSUM first");
 		return -EOPNOTSUPP;
 	}
 
@@ -2612,15 +2612,15 @@ static int virtnet_set_features(struct net_device *dev,
 	u64 offloads;
 	int err;
 
-	if ((dev->features ^ features) & NETIF_F_LRO) {
+	if ((dev->features ^ features) & NETIF_F_GRO_HW) {
 		if (vi->xdp_enabled)
 			return -EBUSY;
 
-		if (features & NETIF_F_LRO)
+		if (features & NETIF_F_GRO_HW)
 			offloads = vi->guest_offloads_capable;
 		else
 			offloads = vi->guest_offloads_capable &
-				   ~GUEST_OFFLOAD_LRO_MASK;
+				   ~GUEST_OFFLOAD_GRO_HW_MASK;
 
 		err = virtnet_set_guest_offloads(vi, offloads);
 		if (err)
@@ -3100,9 +3100,9 @@ static int virtnet_probe(struct virtio_device *vdev)
 		dev->features |= NETIF_F_RXCSUM;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO4) ||
 	    virtio_has_feature(vdev, VIRTIO_NET_F_GUEST_TSO6))
-		dev->features |= NETIF_F_LRO;
+		dev->features |= NETIF_F_GRO_HW;
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_CTRL_GUEST_OFFLOADS))
-		dev->hw_features |= NETIF_F_LRO;
+		dev->hw_features |= NETIF_F_GRO_HW;
 
 	dev->vlan_features = dev->features;
 
-- 
2.25.1

