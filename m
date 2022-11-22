Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 775CA63360B
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 08:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbiKVHoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 02:44:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232467AbiKVHn6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 02:43:58 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66B110B6E;
        Mon, 21 Nov 2022 23:43:56 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045168;MF=hengqi@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VVRCo6W_1669103032;
Received: from localhost(mailfrom:hengqi@linux.alibaba.com fp:SMTPD_---0VVRCo6W_1669103032)
          by smtp.aliyun-inc.com;
          Tue, 22 Nov 2022 15:43:53 +0800
From:   Heng Qi <hengqi@linux.alibaba.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [RFC PATCH 3/9] virtio_net: update bytes calculation for xdp_frame
Date:   Tue, 22 Nov 2022 15:43:42 +0800
Message-Id: <20221122074348.88601-4-hengqi@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <20221122074348.88601-1-hengqi@linux.alibaba.com>
References: <20221122074348.88601-1-hengqi@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update relative record value for xdp_frame as basis
for multi-buffer xdp transmission.

Signed-off-by: Heng Qi <hengqi@linux.alibaba.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 8f7d207d58d6..d3e8c63b9c4b 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -658,7 +658,7 @@ static int virtnet_xdp_xmit(struct net_device *dev,
 		if (likely(is_xdp_frame(ptr))) {
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
-			bytes += frame->len;
+			bytes += xdp_get_frame_len(frame);
 			xdp_return_frame(frame);
 		} else {
 			struct sk_buff *skb = ptr;
@@ -1604,7 +1604,7 @@ static void free_old_xmit_skbs(struct send_queue *sq, bool in_napi)
 		} else {
 			struct xdp_frame *frame = ptr_to_xdp(ptr);
 
-			bytes += frame->len;
+			bytes += xdp_get_frame_len(frame);
 			xdp_return_frame(frame);
 		}
 		packets++;
-- 
2.19.1.6.gb485710b

