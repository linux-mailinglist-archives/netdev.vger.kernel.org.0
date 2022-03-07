Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C201D4CF6C0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiCGJnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:43:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241145AbiCGJl4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:41:56 -0500
Received: from out199-5.us.a.mail.aliyun.com (out199-5.us.a.mail.aliyun.com [47.90.199.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C3C5FD1
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 01:40:46 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0V6UND1m_1646646042;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V6UND1m_1646646042)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 07 Mar 2022 17:40:43 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH vhost] virtio_net: fix build warnings
Date:   Mon,  7 Mar 2022 17:40:42 +0800
Message-Id: <20220307094042.22180-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
X-Git-Hash: b3c21a590cee
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These warnings appear on some platforms (arm multi_v7_defconfig). This
patch fixes these warnings.

drivers/net/virtio_net.c: In function 'virtnet_rx_vq_reset':
drivers/net/virtio_net.c:1823:63: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
 1823 |                    "reset rx reset vq fail: rx queue index: %ld err: %d\n",
      |                                                             ~~^
      |                                                               |
      |                                                               long int
      |                                                             %d
 1824 |                    rq - vi->rq, err);
      |                    ~~~~~~~~~~~
      |                       |
      |                       int
drivers/net/virtio_net.c: In function 'virtnet_tx_vq_reset':
drivers/net/virtio_net.c:1873:63: warning: format '%ld' expects argument of type 'long int', but argument 3 has type 'int' [-Wformat=]
 1873 |                    "reset tx reset vq fail: tx queue index: %ld err: %d\n",
      |                                                             ~~^
      |                                                               |
      |                                                               long int
      |                                                             %d
 1874 |                    sq - vi->sq, err);
      |                    ~~~~~~~~~~~
      |                       |
      |                       int

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 1fa2d632a994..4d629d1ea894 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1820,7 +1820,7 @@ static int virtnet_rx_vq_reset(struct virtnet_info *vi,
 
 err:
 	netdev_err(vi->dev,
-		   "reset rx reset vq fail: rx queue index: %ld err: %d\n",
+		   "reset rx reset vq fail: rx queue index: %td err: %d\n",
 		   rq - vi->rq, err);
 	virtnet_napi_enable(rq->vq, &rq->napi);
 	return err;
@@ -1870,7 +1870,7 @@ static int virtnet_tx_vq_reset(struct virtnet_info *vi,
 
 err:
 	netdev_err(vi->dev,
-		   "reset tx reset vq fail: tx queue index: %ld err: %d\n",
+		   "reset tx reset vq fail: tx queue index: %td err: %d\n",
 		   sq - vi->sq, err);
 	virtnet_napi_tx_enable(vi, sq->vq, &sq->napi);
 	return err;
-- 
2.31.0

