Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2549E368326
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbhDVPQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:16:59 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:59214 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233106AbhDVPQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:16:58 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R321e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UWPw06N_1619104580;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UWPw06N_1619104580)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 22 Apr 2021 23:16:21 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     netdev@vger.kernel.org
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        virtualization@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next] virtio-net: fix use-after-free in skb_gro_receive
Date:   Thu, 22 Apr 2021 23:16:20 +0800
Message-Id: <20210422151620.58204-1-xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When "headroom" > 0, the actual allocated memory space is the entire
page, so the address of the page should be used when passing it to
build_skb().

BUG: KASAN: use-after-free in skb_gro_receive (net/core/skbuff.c:4260)
Write of size 16 at addr ffff88811619fffc by task kworker/u9:0/534
CPU: 2 PID: 534 Comm: kworker/u9:0 Not tainted 5.12.0-rc7-custom-16372-gb150be05b806 #3382
Hardware name: QEMU MSN2700, BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
Workqueue: xprtiod xs_stream_data_receive_workfn [sunrpc]
Call Trace:
 <IRQ>
dump_stack (lib/dump_stack.c:122)
print_address_description.constprop.0 (mm/kasan/report.c:233)
kasan_report.cold (mm/kasan/report.c:400 mm/kasan/report.c:416)
skb_gro_receive (net/core/skbuff.c:4260)
tcp_gro_receive (net/ipv4/tcp_offload.c:266 (discriminator 1))
tcp4_gro_receive (net/ipv4/tcp_offload.c:316)
inet_gro_receive (net/ipv4/af_inet.c:1545 (discriminator 2))
dev_gro_receive (net/core/dev.c:6075)
napi_gro_receive (net/core/dev.c:6168 net/core/dev.c:6198)
receive_buf (drivers/net/virtio_net.c:1151) virtio_net
virtnet_poll (drivers/net/virtio_net.c:1415 drivers/net/virtio_net.c:1519) virtio_net
__napi_poll (net/core/dev.c:6964)
net_rx_action (net/core/dev.c:7033 net/core/dev.c:7118)
__do_softirq (./arch/x86/include/asm/jump_label.h:25 ./include/linux/jump_label.h:200 ./include/trace/events/irq.h:142 kernel/softirq.c:346)
irq_exit_rcu (kernel/softirq.c:221 kernel/softirq.c:422 kernel/softirq.c:434)
common_interrupt (arch/x86/kernel/irq.c:240 (discriminator 14))
</IRQ>

Fixes: fb32856b16ad ("virtio-net: page_to_skb() use build_skb when there's sufficient tailroom")
Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Reported-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/virtio_net.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 74d2d49264f3..7fda2ae4c40f 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -387,7 +387,7 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	unsigned int copy, hdr_len, hdr_padded_len;
 	struct page *page_to_free = NULL;
 	int tailroom, shinfo_size;
-	char *p, *hdr_p;
+	char *p, *hdr_p, *buf;
 
 	p = page_address(page) + offset;
 	hdr_p = p;
@@ -403,11 +403,15 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 	 * space are aligned.
 	 */
 	if (headroom) {
-		/* The actual allocated space size is PAGE_SIZE. */
+		/* Buffers with headroom use PAGE_SIZE as alloc size,
+		 * see add_recvbuf_mergeable() + get_mergeable_buf_len()
+		 */
 		truesize = PAGE_SIZE;
 		tailroom = truesize - len - offset;
+		buf = page_address(page);
 	} else {
 		tailroom = truesize - len;
+		buf = p;
 	}
 
 	len -= hdr_len;
@@ -416,11 +420,13 @@ static struct sk_buff *page_to_skb(struct virtnet_info *vi,
 
 	shinfo_size = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
+	/* copy small packet so we can reuse these pages */
 	if (!NET_IP_ALIGN && len > GOOD_COPY_LEN && tailroom >= shinfo_size) {
-		skb = build_skb(p, truesize);
+		skb = build_skb(buf, truesize);
 		if (unlikely(!skb))
 			return NULL;
 
+		skb_reserve(skb, p - buf);
 		skb_put(skb, len);
 		goto ok;
 	}
-- 
2.31.0

