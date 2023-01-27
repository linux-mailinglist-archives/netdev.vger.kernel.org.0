Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E46CA67EFE9
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 21:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjA0UqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 15:46:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbjA0UqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 15:46:16 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4856B17CDC;
        Fri, 27 Jan 2023 12:45:18 -0800 (PST)
Received: from lenovo-t14s.redhat.com ([82.142.8.70]) by
 mrelayeu.kundenserver.de (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis)
 id 1M58OQ-1pKP8G3WNA-0018pB; Fri, 27 Jan 2023 21:45:05 +0100
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
Subject: [PATCH v3 1/2] virtio_net: disable VIRTIO_NET_F_STANDBY if VIRTIO_NET_F_MAC is not set
Date:   Fri, 27 Jan 2023 21:44:59 +0100
Message-Id: <20230127204500.51930-2-lvivier@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230127204500.51930-1-lvivier@redhat.com>
References: <20230127204500.51930-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:dDynSjXZJgzJ6rJ90EiWqku5tMQFKKlPs/g0iszfvcj489W0tYY
 M/vXu6qUMHmP17ThNfHhcYYFzfce031ZX/FXDX2fIw3STSTDtsdSwqOe39QsY052PmuEEde
 WJ0jKGPMCZbtNnc6HsuayP4zSzWRJTYtAlbHwoJj+CEsZQv6zSuqnvqpKCrgX7Fz/Cjwc9f
 bKayJwTW1BtSunSJ/1GDQ==
UI-OutboundReport: notjunk:1;M01:P0:YSRiWra10ag=;NKQnSarxFDt067Ku9TJc+7zxNck
 h9kzScSbWvaVcSwSGpUtyC01vMz6C73hZ7seUqPOuALdGFaO1B2dmc8kp2fUnmTcNy4y4aCdi
 nHam2FG+Zr4bVaPMsCxoGk4sAO0Mi9AQQuomKTOoV5+W3THRiOnjbBWoPwr6c4hjE89djTT5p
 744xlGjzpEwrH78e/sSY54HZ2/1vGagtXlN6/ojEi98ZSoMzuELRS5y+voiq8MK6Msq0kxVNo
 xtC05/+KgGzD8u/chsW689xvfiXfTtFvrN25LF5AOUPKhWovlQ/Ruok5S+c4kHa2kkvIfq9Bo
 eIpTdn/c+TwhFZ83JR3m9duQ8OZbuEmj+52GvJ6GoGwSEGI2pJi4pgai84gwW4o8gT9c7QRlf
 Gkb7Au6OU94Uvv4WpwkyAa0Acj9KFjnJqtudC6XyBWMgBEAEwN46KrKcEb+nVKRQYpp8Euql7
 cmSY4HHvTspiIWkl4euRLJqo434JuRlCHBlFVen2vJLf2yolj6Pfzl4v1H3HH0u0yH13bRQul
 SNOnCDAjE6A/AoDvldKhmXNTYaa6QPM4ayIx7PlbalHWnR3f0fLfUc6vfBkExUCqUCg0kOioU
 IyosR9+pX1ezChe1ylB33IC0CcYzGC+oF9rpDNDclBvlY6Vaqy9KEfNEFe1A+gPztZKD3UlXM
 hTwN4+Awzl2tT8Sc7p0o5KpuAhfCMlgIB2NCYxyrVA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

failover relies on the MAC address to pair the primary and the standby
devices:

  "[...] the hypervisor needs to enable VIRTIO_NET_F_STANDBY
   feature on the virtio-net interface and assign the same MAC address
   to both virtio-net and VF interfaces."

  Documentation/networking/net_failover.rst

This patch disables the STANDBY feature if the MAC address is not
provided by the hypervisor.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/net/virtio_net.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 7723b2a49d8e..7d700f8e545a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -3688,6 +3688,12 @@ static int virtnet_validate(struct virtio_device *vdev)
 			__virtio_clear_bit(vdev, VIRTIO_NET_F_MTU);
 	}
 
+	if (virtio_has_feature(vdev, VIRTIO_NET_F_STANDBY) &&
+	    !virtio_has_feature(vdev, VIRTIO_NET_F_MAC)) {
+		dev_warn(&vdev->dev, "device advertises feature VIRTIO_NET_F_STANDBY but not VIRTIO_NET_F_MAC, disabling standby");
+		__virtio_clear_bit(vdev, VIRTIO_NET_F_STANDBY);
+	}
+
 	return 0;
 }
 
-- 
2.39.1

