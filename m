Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0B4C382D74
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 15:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbhEQNcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 09:32:39 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:54227 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236025AbhEQNci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 09:32:38 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xianting.tian@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0UZA5KT9_1621258279;
Received: from B-LB6YLVDL-0141.local(mailfrom:xianting.tian@linux.alibaba.com fp:SMTPD_---0UZA5KT9_1621258279)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 17 May 2021 21:31:20 +0800
From:   Xianting Tian <xianting.tian@linux.alibaba.com>
To:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] virtio_net: Use BUG_ON instead of if condition followed by
 BUG
Message-ID: <56270996-33a6-d71b-d935-452dad121df7@linux.alibaba.com>
Date:   Mon, 17 May 2021 21:31:19 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BUG_ON() uses unlikely in if(), which can be optimized at compile time.

Signed-off-by: Xianting Tian <xianting.tian@linux.alibaba.com>
---
  drivers/net/virtio_net.c | 5 ++---
  1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c921ebf3ae82..212d52204884 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1646,10 +1646,9 @@ static int xmit_skb(struct send_queue *sq, struct 
sk_buff *skb)
  	else
  		hdr = skb_vnet_hdr(skb);

-	if (virtio_net_hdr_from_skb(skb, &hdr->hdr,
+	BUG_ON(virtio_net_hdr_from_skb(skb, &hdr->hdr,
  				    virtio_is_little_endian(vi->vdev), false,
-				    0))
-		BUG();
+				    0));

  	if (vi->mergeable_rx_bufs)
  		hdr->num_buffers = 0;
-- 
2.17.1

