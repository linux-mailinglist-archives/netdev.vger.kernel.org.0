Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E431D6CBAC0
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232609AbjC1JaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:30:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232509AbjC1J31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:29:27 -0400
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF867298;
        Tue, 28 Mar 2023 02:29:00 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R731e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0Vesaxcb_1679995735;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0Vesaxcb_1679995735)
          by smtp.aliyun-inc.com;
          Tue, 28 Mar 2023 17:28:56 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        virtualization@lists.linux-foundation.org, bpf@vger.kernel.org
Subject: [PATCH 07/16] virtio_net: remove lock from virtnet_ack_link_announce()
Date:   Tue, 28 Mar 2023 17:28:38 +0800
Message-Id: <20230328092847.91643-8-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.32.0.3.g01195cf9f
In-Reply-To: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
References: <20230328092847.91643-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
X-Git-Hash: e880b402863c
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.0 required=5.0 tests=ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removing rtnl_lock() from virtnet_ack_link_announce(). This is to
facilitate separating cq-related functions into a separate file.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio/virtnet.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio/virtnet.c b/drivers/net/virtio/virtnet.c
index 6ad217af44d9..4a3b5efb674e 100644
--- a/drivers/net/virtio/virtnet.c
+++ b/drivers/net/virtio/virtnet.c
@@ -2083,11 +2083,9 @@ static void virtnet_stats(struct net_device *dev,
 
 static void virtnet_ack_link_announce(struct virtnet_info *vi)
 {
-	rtnl_lock();
 	if (!virtnet_send_command(vi, VIRTIO_NET_CTRL_ANNOUNCE,
 				  VIRTIO_NET_CTRL_ANNOUNCE_ACK, NULL))
 		dev_warn(&vi->dev->dev, "Failed to ack link announce.\n");
-	rtnl_unlock();
 }
 
 static int virtnet_ctrl_set_queues(struct virtnet_info *vi, u16 queue_pairs)
@@ -3187,7 +3185,10 @@ static void virtnet_config_changed_work(struct work_struct *work)
 
 	if (v & VIRTIO_NET_S_ANNOUNCE) {
 		netdev_notify_peers(vi->dev);
+
+		rtnl_lock();
 		virtnet_ack_link_announce(vi);
+		rtnl_unlock();
 	}
 
 	/* Ignore unknown (future) status bits */
-- 
2.32.0.3.g01195cf9f

