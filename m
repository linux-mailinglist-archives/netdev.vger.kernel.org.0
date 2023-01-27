Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 682B767EFEB
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjA0UqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjA0UqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:46:18 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7A37E6EF;
        Fri, 27 Jan 2023 12:45:18 -0800 (PST)
Received: from lenovo-t14s.redhat.com ([82.142.8.70]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1MWSJJ-1pBMAk2xND-00XusM; Fri, 27 Jan 2023 21:45:05 +0100
From:   Laurent Vivier <lvivier@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        virtualization@lists.linux-foundation.org,
        Cindy Lu <lulu@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Eli Cohen <elic@nvidia.com>,
        Gautam Dawar <gautam.dawar@xilinx.com>,
        =?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>
Subject: [PATCH v3 2/2] virtio_net: notify MAC address change on device initialization
Date:   Fri, 27 Jan 2023 21:45:00 +0100
Message-Id: <20230127204500.51930-3-lvivier@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127204500.51930-1-lvivier@redhat.com>
References: <20230127204500.51930-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:vDP/sU3WbWB3aipv6spulG2sZ/1/Qx0NRvtEbQ/95jvDYBrgqmv
 ZN3NrtTNEg7/lbeTe7M8RMTYDDBTb50tIFBE5sKC1+dGcykmefRnplHi5Jj2SuoDef9L+k8
 JsT+qgN5H7TdT7yYUGdVrw20FOcRMzLIMrLttqxHXylaSE9B0r6WpmSiZaB3QykOyrbZxc9
 8csVaeU/XH5gJCpVVFPig==
UI-OutboundReport: notjunk:1;M01:P0:YlxfpHwCfKI=;F2Z0qtzUOVtZt2dyT7TyrApqXPl
 /OeE0Hrod1cbH/ILzhse+N7lHTWXmIgWXuf+n0WQUqw1sXa9Jz6i2+MFzbTmxKYl1S2i003tC
 YGBElKmIKyDskmmbVIS60/ls4uaMq2tvd/qDkPPlxj2SpTgEuz1WnUDbjXnuIXMVy71DBuPCW
 5b3zZxB8QgRHmcpbaxiHw3mtN1IYyQP8iiOiS7yM5oMu1hcQomQCjaGVYEst8rTpTRNPDCAOr
 uA+bYmu8jX0fWae/F9nClQ/NuCO/ssabz0eH17fhN1/3ldHjX8rFB0saoDU38165VHKapeV56
 DJ7xFCGdbiMP0JdJLZVQiOQ1/agp6bjCkJg7Gwf2A+NJifDJKbeICCpFU127adGM6ryff4aHU
 W8r8NvqB+LwFaLKu61vl8Ou2sjxsIk2IM8b1FnJoVJDHioGCuEf3A3X9ld3FTHw6p0ZV2dv1e
 CnO7jf0pMeuAuje7hEFFT9cfnlDwiob8JwRvgCRDQhHp4f7vz7lkNS+l2UEOXf9FVVWFIQjXl
 c+lhxAi4lc+CGVdL09P+VjeMFpLzfbZFSoh1cnggzCybxcJVKZ6OMaMp0iaqkFy1hcL7qX0jS
 t+hBDNoqIHPyBatsD/L2fpOgGL0pNwqy4jzmSTK+3B8bMydMflilJl/5FVKKCYB6r0Q2ZwkoN
 gW8zeTeUzg/PVIi1dnTOD94brO2eEEoPwf4dvNZtXw==
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
new MAC address has not been provided to the hardware:
RX packets are dropped since they don't go through the receive filters,
TX packets go through unaffected.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/net/virtio_net.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7d700f8e545a..704a05f1c279 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3806,6 +3806,8 @@ static int virtnet_probe(struct virtio_device *vdev)
 		eth_hw_addr_set(dev, addr);
 	} else {
 		eth_hw_addr_random(dev);
+		dev_info(&vdev->dev, "Assigned random MAC address %pM\n",
+			 dev->dev_addr);
 	}
 
 	/* Set up our device-specific information */
@@ -3933,6 +3935,24 @@ static int virtnet_probe(struct virtio_device *vdev)
 
 	virtio_device_ready(vdev);
 
+	/* a random MAC address has been assigned, notify the device.
+	 * We don't fail probe if VIRTIO_NET_F_CTRL_MAC_ADDR is not there
+	 * because many devices work fine without getting MAC explicitly
+	 */
+	if (!virtio_has_feature(vdev, VIRTIO_NET_F_MAC) &&
+	    virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_MAC_ADDR)) {
+		struct scatterlist sg;
+
+		sg_init_one(&sg, dev->dev_addr, dev->addr_len);
+		if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_MAC,
+					  VIRTIO_NET_CTRL_MAC_ADDR_SET, &sg)) {
+			pr_debug("virtio_net: setting MAC address failed\n");
+			rtnl_unlock();
+			err = -EINVAL;
+			goto free_unregister_netdev;
+		}
+	}
+
 	rtnl_unlock();
 
 	err = virtnet_cpu_notif_add(vi);
-- 
2.39.1

