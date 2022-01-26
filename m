Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FA749C495
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 08:36:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237945AbiAZHgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 02:36:07 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:45605 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229721AbiAZHfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 02:35:54 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0V2uc6mL_1643182549;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0V2uc6mL_1643182549)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 26 Jan 2022 15:35:50 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org
Subject: [PATCH v3 15/17] virtio_net: virtnet_tx_timeout() stop ref sq->vq
Date:   Wed, 26 Jan 2022 15:35:31 +0800
Message-Id: <20220126073533.44994-16-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
References: <20220126073533.44994-1-xuanzhuo@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make virtnet_tx_timeout() no longer refer to vq directly. Because sq->vq
may be equal to NULL after implementing rx/tx queue disable/enable.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 97eb4dddba1f..2add7fe749b8 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -2692,7 +2692,7 @@ static void virtnet_tx_timeout(struct net_device *dev, unsigned int txqueue)
 	u64_stats_update_end(&sq->stats.syncp);
 
 	netdev_err(dev, "TX timeout on queue: %u, sq: %s, vq: 0x%x, name: %s, %u usecs ago\n",
-		   txqueue, sq->name, sq->vq->index, sq->vq->name,
+		   txqueue, sq->name, txq2vq(sq - vi->sq), sq->name,
 		   jiffies_to_usecs(jiffies - READ_ONCE(txq->trans_start)));
 }
 
-- 
2.31.0

