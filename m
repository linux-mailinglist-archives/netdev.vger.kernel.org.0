Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 148EC3EE801
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 10:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238873AbhHQIIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 04:08:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43986 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234693AbhHQIHv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 04:07:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629187638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=qVcE6UPf0wuZej4sXtxd/Uc1SmN5uwlN7K2SA3aUFHE=;
        b=cmxmFHSn4oX60oA/ngOIqp+/QcdSyqQ+YHItTLOfsDF1I+nFdRgg3Z4VWe/gxmsBQi/wrU
        VA4tFJtSoQhqvpNuy0ymVjdbu+/IFK+RjCPvK/HIslCEWl6zYwU8xJndzzF5viz2Aj/Dqw
        thH/UYeFMsSw8GJ5gGYE1vujBDYodIw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-MGS0Ta-MPLayX6UyW_gr_Q-1; Tue, 17 Aug 2021 04:07:13 -0400
X-MC-Unique: MGS0Ta-MPLayX6UyW_gr_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3CB731008065;
        Tue, 17 Aug 2021 08:07:12 +0000 (UTC)
Received: from localhost.localdomain (ovpn-13-175.pek2.redhat.com [10.72.13.175])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 010405C1B4;
        Tue, 17 Aug 2021 08:07:04 +0000 (UTC)
From:   Jason Wang <jasowang@redhat.com>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ivan@prestigetransportation.com,
        xiangxia.m.yue@gmail.com, willemb@google.com, edumazet@google.com
Subject: [PATCH V2 net] virtio-net: use NETIF_F_GRO_HW instead of NETIF_F_LRO
Date:   Tue, 17 Aug 2021 16:06:59 +0800
Message-Id: <20210817080659.16223-1-jasowang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
maps LRO to virtio guest offloading features and allows the
administrator to enable and disable those features via ethtool.

This leads to several issues:

- For a device that doesn't support control guest offloads, the "LRO"
  can't be disabled triggering WARN in dev_disable_lro() when turning
  off LRO or when enabling forwarding bridging etc.

- For a device that supports control guest offloads, the guest
  offloads are disabled in cases of bridging, forwarding etc slowing
  down the traffic.

Fix this by using NETIF_F_GRO_HW instead. Though the spec does not
guarantee packets to be re-segmented as the original ones,
we can add that to the spec, possibly with a flag for devices to
differentiate between GRO and LRO.

Further, we never advertised LRO historically before a02e8964eaf92
("virtio-net: ethtool configurable LRO") and so bridged/forwarded
configs effectively always relied on virtio receive offloads behaving
like GRO - thus even if this breaks any configs it is at least not
a regression.

Fixes: a02e8964eaf92 ("virtio-net: ethtool configurable LRO")
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Reported-by: Ivan <ivan@prestigetransportation.com>
Tested-by: Ivan <ivan@prestigetransportation.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
Changes from V1:
- Tweak the commit log
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

