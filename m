Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF380676BFD
	for <lists+netdev@lfdr.de>; Sun, 22 Jan 2023 11:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbjAVKGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Jan 2023 05:06:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbjAVKGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Jan 2023 05:06:33 -0500
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC8F1CF69;
        Sun, 22 Jan 2023 02:05:45 -0800 (PST)
Received: from lenovo-t14s.redhat.com ([82.142.8.70]) by
 mrelayeu.kundenserver.de (mreue012 [212.227.15.167]) with ESMTPSA (Nemesis)
 id 1Mv3M8-1oSwdn1I24-00r0FP; Sun, 22 Jan 2023 11:05:31 +0100
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
Subject: [PATCH 2/4] virtio_net: add a timeout in virtnet_send_command()
Date:   Sun, 22 Jan 2023 11:05:24 +0100
Message-Id: <20230122100526.2302556-3-lvivier@redhat.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230122100526.2302556-1-lvivier@redhat.com>
References: <20230122100526.2302556-1-lvivier@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:Q/I/cga4nZOLWJZ6626JLw2DTN8BqDTEy/TTN7AmLPPbAvv4s/x
 3Mb+7W/tWh2hPzaySdoOxxbH2k0Iq67YvdoSX7Dy/+p2/8WeDpQc94lfaAGKtjv1tyBixOT
 y23u7MmcoQ0e7tZLyBsqOQfI0xHlC5Abzxl7uPydBZiPyOdJhnFQarIJhyt9uTi0wD/VXiK
 DrR/t3vOSm/bCjw6SHx7w==
UI-OutboundReport: notjunk:1;M01:P0:HM0lcQr5Jvs=;mzd2YF4kR7weYP6YA3EqDZLTl2j
 A/oWHtswsjYt5zeLBta83WIk2hmbo/2M4lwL+uRMaFO680jdbnFH/qJ1SEIVOfc4kdFZzO0MC
 0IStB76FO8D90jh28K5SndhKkJlx0ufbU5Fa4c67couM3raVz+8TIMpe2RVLI6nvJd7BwdcLY
 fgNq0EdlP/dSQt84R3QRYJWOOy72MfZZyOd1K4ZmKdLLeu/myBHU83vzrXLYIM73p/s6QKQzE
 vrZGMnzViOj1b8+HGW47AHla/36LMPiLkSe1O3szv57s9vjJnV7dAWltB/UXqBTU8Bw1a0wtL
 KUr2NwWuSjq5JnalEn1A7Gu9up6cZDc0+GrNaKHfUSNZj6eXl77N4oq0ebxPYWsDHeo9luLG8
 1dsOYnD7xSvb09yVpH+V2fGnxgAi+urXAW+UE87MIG1Mi1FjcQJoOLNUm9f6MR18cWak1wamO
 s9z2jKhwkblBXG7JYw7pK2IR5+5lYOvUCW4h7u0Ev97bWBUfFeQG/pJZXAqiKBleW5Q45nI1X
 9Iwnd5yFJNHLOVaqsb2l4UfrIp5ltMYm+/RcTu9OOs2qSRMPBa/QHhx3KslOiwAMb46HQdlxK
 zyHw7iP1Zsd/17wwDqDUe59QVyEz2tZkBJkIiK4n+R5QE1he4/uZ7ftHBqmkeB0L5eJmeWDgk
 5Fi7qCAtfgPFvPBqdDKEzHRYfVWzVwwUX6SEQvo6kw==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

if the device control queue is buggy, don't crash the kernel by
waiting for ever the response.

Signed-off-by: Laurent Vivier <lvivier@redhat.com>
---
 drivers/net/virtio_net.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 25511a86590e..29b3cc72082d 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1974,6 +1974,7 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	struct scatterlist *sgs[4], hdr, stat;
 	unsigned out_num = 0, tmp;
 	int ret;
+	unsigned long timeout;
 
 	/* Caller should know better */
 	BUG_ON(!virtio_has_feature(vi->vdev, VIRTIO_NET_F_CTRL_VQ));
@@ -2006,8 +2007,10 @@ static bool virtnet_send_command(struct virtnet_info *vi, u8 class, u8 cmd,
 	/* Spin for a response, the kick causes an ioport write, trapping
 	 * into the hypervisor, so the request should be handled immediately.
 	 */
+	timeout = jiffies + 20 * HZ;
 	while (!virtqueue_get_buf(vi->cvq, &tmp) &&
-	       !virtqueue_is_broken(vi->cvq))
+	       !virtqueue_is_broken(vi->cvq) &&
+	       !time_after(jiffies, timeout))
 		cpu_relax();
 
 	return vi->ctrl->status == VIRTIO_NET_OK;
-- 
2.39.0

