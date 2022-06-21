Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 024785531BD
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349469AbiFUMMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348842AbiFUMMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:12:38 -0400
X-Greylist: delayed 1339 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 21 Jun 2022 05:12:36 PDT
Received: from mx.kernkonzept.com (serv1.kernkonzept.com [159.69.200.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D15E2BB07;
        Tue, 21 Jun 2022 05:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=kernkonzept.com; s=mx1; h=Content-Transfer-Encoding:MIME-Version:Message-Id
        :Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=njJuoA2Sc/56TeF9U5fuCJ1Q1iYeeVXupfO3Z71rmfU=; b=N20iD1j4QJpCbcdtTtf0vx4SfS
        v9vaHEUavFbJcnwamVJjVHTPAgSNlSJXTH6poPimDs9+bULGexIuzt+l9cAjUpktSS0RCyKacIuCp
        7mkrrtulA3TPEdxbQGC4sc5Fem19JxPiWAcf5N2zGRLSh38enkeRCc5KY2ypcoD+ovxYLed2+JLKv
        qD/IM8Xp/H194fGBE9LyVjxnqVy20zgwo5GUcbzjiUCR/QtX66QNX/o2nRLpjiZGWuqRSCMCEp5sY
        Qwl4QveMpiaAd3HMniNlZ1tVnv3oVi371F+FhewiOTracn0ddYLjmA3dk5eXCF63MrB9E/zqurcjw
        LYtHnsDA==;
Received: from [10.22.3.24] (helo=kernkonzept.com)
        by mx.kernkonzept.com with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2)
        id 1o3cOK-005hVa-SB; Tue, 21 Jun 2022 13:49:56 +0200
From:   Stephan Gerhold <stephan.gerhold@kernkonzept.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Stephan Gerhold <stephan.gerhold@kernkonzept.com>,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH net] virtio_net: fix xdp_rxq_info bug after suspend/resume
Date:   Tue, 21 Jun 2022 13:48:44 +0200
Message-Id: <20220621114845.3650258-1-stephan.gerhold@kernkonzept.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following sequence currently causes a driver bug warning
when using virtio_net:

  # ip link set eth0 up
  # echo mem > /sys/power/state (or e.g. # rtcwake -s 10 -m mem)
  <resume>
  # ip link set eth0 down

  Missing register, driver bug
  WARNING: CPU: 0 PID: 375 at net/core/xdp.c:138 xdp_rxq_info_unreg+0x58/0x60
  Call trace:
   xdp_rxq_info_unreg+0x58/0x60
   virtnet_close+0x58/0xac
   __dev_close_many+0xac/0x140
   __dev_change_flags+0xd8/0x210
   dev_change_flags+0x24/0x64
   do_setlink+0x230/0xdd0
   ...

This happens because virtnet_freeze() frees the receive_queue
completely (including struct xdp_rxq_info) but does not call
xdp_rxq_info_unreg(). Similarly, virtnet_restore() sets up the
receive_queue again but does not call xdp_rxq_info_reg().

Actually, parts of virtnet_freeze_down() and virtnet_restore_up()
are almost identical to virtnet_close() and virtnet_open(): only
the calls to xdp_rxq_info_(un)reg() are missing. This means that
we can fix this easily and avoid such problems in the future by
just calling virtnet_close()/open() from the freeze/restore handlers.

Aside from adding the missing xdp_rxq_info calls the only difference
is that the refill work is only cancelled if netif_running(). However,
this should not make any functional difference since the refill work
should only be active if the network interface is actually up.

Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
Signed-off-by: Stephan Gerhold <stephan.gerhold@kernkonzept.com>
---
 drivers/net/virtio_net.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index db05b5e930be..969a67970e71 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2768,7 +2768,6 @@ static const struct ethtool_ops virtnet_ethtool_ops = {
 static void virtnet_freeze_down(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int i;
 
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
@@ -2776,14 +2775,8 @@ static void virtnet_freeze_down(struct virtio_device *vdev)
 	netif_tx_lock_bh(vi->dev);
 	netif_device_detach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
-	cancel_delayed_work_sync(&vi->refill);
-
-	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			napi_disable(&vi->rq[i].napi);
-			virtnet_napi_tx_disable(&vi->sq[i].napi);
-		}
-	}
+	if (netif_running(vi->dev))
+		virtnet_close(vi->dev);
 }
 
 static int init_vqs(struct virtnet_info *vi);
@@ -2791,7 +2784,7 @@ static int init_vqs(struct virtnet_info *vi);
 static int virtnet_restore_up(struct virtio_device *vdev)
 {
 	struct virtnet_info *vi = vdev->priv;
-	int err, i;
+	int err;
 
 	err = init_vqs(vi);
 	if (err)
@@ -2800,15 +2793,9 @@ static int virtnet_restore_up(struct virtio_device *vdev)
 	virtio_device_ready(vdev);
 
 	if (netif_running(vi->dev)) {
-		for (i = 0; i < vi->curr_queue_pairs; i++)
-			if (!try_fill_recv(vi, &vi->rq[i], GFP_KERNEL))
-				schedule_delayed_work(&vi->refill, 0);
-
-		for (i = 0; i < vi->max_queue_pairs; i++) {
-			virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
-			virtnet_napi_tx_enable(vi, vi->sq[i].vq,
-					       &vi->sq[i].napi);
-		}
+		err = virtnet_open(vi->dev);
+		if (err)
+			return err;
 	}
 
 	netif_tx_lock_bh(vi->dev);
-- 
2.30.2

