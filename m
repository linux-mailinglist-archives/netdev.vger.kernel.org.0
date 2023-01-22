Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F4A676BFC
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 11:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbjAVKGg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 05:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjAVKGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 05:06:33 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A084B1CF6C;
        Sun, 22 Jan 2023 02:05:45 -0800 (PST)
Received: from lenovo-t14s.redhat.com ([82.142.8.70]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1MRVy9-1p53Hj1ciT-00NSmk; Sun, 22 Jan 2023 11:05:30 +0100
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Parav Pandit <parav@nvidia.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        Eli Cohen <elic@nvidia.com>, Jason Wang <jasowang@redhat.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        Cindy Lu <lulu@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>
Subject: [PATCH 1/4] virtio_net: notify MAC address change on device initialization
Date:   Sun, 22 Jan 2023 11:05:23 +0100
Message-Id: <20230122100526.2302556-2-lvivier@redhat.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230122100526.2302556-1-lvivier@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:OvJkQJpHxHaDCPIk3W9i4eIYijK92aR7qOa7YFbWU4FKa/YfJkR
 E/a6z8dxmCPAKztm0ukyh/oHdFFG7zYa7NElzj3pnNbO1BMzo/7IgFa9I1NikV6ZzztbCV3
 E2fJahWqrWBM5gzAUbZWhNFFhiRGzyTdLzqCq6fUs9xJ4pp7Ki6jrCSc0gh3nZNZ5YSb5mm
 D7PIF++SRA45BlYtN3wpw==
UI-OutboundReport: notjunk:1;M01:P0:uI0nKc6Xg14=;V2mW9Yjl2DK8tq+0C6gzIszIg/5
 o3q1eas0KF63Bj1HGMfGHZKC0xuc5cpaegmNi9jljig1AveJMDqZ+xRSp/3J5VSVrPcrY3PXw
 hDtqkTmTbonvTFiqsdrU/uFHuMUVr368KTf3JkgY3MbEtqrdlb46MPQ9ypvUaaoQo8LQF7AXW
 TX9MwGXOBJy2akXwI1VhwiWkPKGOzrAPdF2UT/GIOlfPoyyhwTMbmWf7pTMf+KPBz8sB3KwOx
 zyYQ877hiE8zBrwaehPa6PL7QLxIgTKbS9c1Ceo+I6rzs7prqVP7FhZQiixKmSXKIYMCKwa6m
 wj1A8adlm3mowJ8f5pTMW1LinSu0Swa7ErS0nmmq30z9SwufZx1imMcf1Xpv7OH6y9wnZ5GnW
 xdUGgBKDrqNc1jLJ/tV+PbkaVUtWTw+mifPUTFIn/rzXQowAqFZ/EPsCJ+s0/4wDQ3UM8zJS+
 +XicJtU2EGEPPRbvh9gE28qLvYHibQz7QOsaOMGTeuMViVPvMoR9/1wJPFLF7kaNeraAlvXA7
 db/rKUxbBngrNrndSgEK/wlhhXNM4U3wt4K3Ciij1pDt4XoMF65rSSN0Owb4x0fYQWgyN9YG5
 4V3MlTq/JdA643f4WoBmkCL7ISjkuQJR7VqL4fd3F/tcdKomV6mSHVy5Y5q3NHT7VAWymh/ry
 0Lewed5/mAWn7fJIz1fNou7E+NZoOGGS9SHTOAi8bw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In virtnet_probe(), if the device doesn't provide a MAC address the
driver assigns a random one.
As we modify the MAC address we need to notify the device to allow it
to update all the related information.

The problem can be seen with vDPA and mlx5_vdpa driver as it doesn't
assign a MAC address by default. The virtio_net device uses a random
MAC address (we can see it with "ip link"), but we can't ping a net
namespace from another one using the virtio-vdpa device because the
new MAC address has not been provided to the hardware.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/net/virtio_net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7723b2a49d8e..25511a86590e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3800,6 +3800,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		eth_hw_addr_set(dev, addr);
 	} else {
 		eth_hw_addr_random(dev);
+		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
+			 dev->dev_addr);
 	}
 
 	/* Set up our device-specific information */
@@ -3956,6 +3958,18 @@ static int virtnet_probe(struct virtio_device *vdev)
 	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
 		 dev->name, max_queue_pairs);
 
+	/* a random MAC address has been assigned, notify the device */
+	if (dev->addr_assign_type == NET_ADDR_RANDOM &&
+	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
+		struct scatterlist sg;
+
+		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
+		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
+					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
+			dev_warn(&vdev->dev, "Failed to update MAC address.\n");
+		}
+	}
+
 	return 0;
 
 free_unregister_netdev:
-- 
2.39.0

