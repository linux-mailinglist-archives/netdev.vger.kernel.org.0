Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA32939A767
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 19:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhFCRLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 13:11:17 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:50189 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232195AbhFCRKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 13:10:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UbAY0W._1622740141;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UbAY0W._1622740141)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 04 Jun 2021 01:09:01 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org,
        =?UTF-8?q?Corentin=20No=C3=ABl?= <corentin.noel@collabora.com>
Subject: [PATCH net] virtio-net: fix for skb_over_panic inside big mode
Date:   Fri,  4 Jun 2021 01:09:01 +0800
Message-Id: <20210603170901.66504-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In virtio-net's large packet mode, there is a hole in the space behind
buf.

    hdr_padded_len - hdr_len

We must take this into account when calculating tailroom.

[   44.544385] skb_put.cold (net/core/skbuff.c:5254 (discriminator 1) net/core/skbuff.c:5252 (discriminator 1))
[   44.544864] page_to_skb (drivers/net/virtio_net.c:485) [   44.545361] receive_buf (drivers/net/virtio_net.c:849 drivers/net/virtio_net.c:1131)
[   44.545870] ? netif_receive_skb_list_internal (net/core/dev.c:5714)
[   44.546628] ? dev_gro_receive (net/core/dev.c:6103)
[   44.547135] ? napi_complete_done (./include/linux/list.h:35 net/core/dev.c:5867 net/core/dev.c:5862 net/core/dev.c:6565)
[   44.547672] virtnet_poll (drivers/net/virtio_net.c:1427 drivers/net/virtio_net.c:1525)
[   44.548251] __napi_poll (net/core/dev.c:6985)
[   44.548744] net_rx_action (net/core/dev.c:7054 net/core/dev.c:7139)
[   44.549264] __do_softirq (./arch/x86/include/asm/jump_label.h:19 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:560)
[   44.549762] irq_exit_rcu (kernel/softirq.c:433 kernel/softirq.c:637 kernel/softirq.c:649)
[   44.551384] common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 13))
[   44.551991] ? asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)
[   44.552654] asm_common_interrupt (./arch/x86/include/asm/idtentry.h:638)

Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reported-by: Corentin Noël <corentin.noel@collabora.com>
Tested-by: Corentin Noël <corentin.noel@collabora.com>
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index fa407eb8b457..78a01c71a17c 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -406,7 +406,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	 * add_recvbuf_mergeable() + get_mergeable_buf_len()
 	 */
 	truesize = headroom ? PAGE_SIZE : truesize;
-	tailroom = truesize - len - headroom;
+	tailroom = truesize - len - headroom - (hdr_padded_len - hdr_len);
 	buf = p - headroom;
 
 	len -= hdr_len;
-- 
2.31.0

