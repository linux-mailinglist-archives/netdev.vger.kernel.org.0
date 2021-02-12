Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0A9319758
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 01:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBLAUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 19:20:13 -0500
Received: from ex13-edg-ou-002.vmware.com ([208.91.0.190]:19989 "EHLO
        EX13-EDG-OU-002.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229647AbhBLAUK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 19:20:10 -0500
Received: from sc9-mailhost2.vmware.com (10.113.161.72) by
 EX13-EDG-OU-002.vmware.com (10.113.208.156) with Microsoft SMTP Server id
 15.0.1156.6; Thu, 11 Feb 2021 16:18:38 -0800
Received: from htb-1n-eng-dhcp122.eng.vmware.com (unknown [10.20.114.3])
        by sc9-mailhost2.vmware.com (Postfix) with ESMTP id EC13420641;
        Thu, 11 Feb 2021 16:18:42 -0800 (PST)
Received: by htb-1n-eng-dhcp122.eng.vmware.com (Postfix, from userid 0)
        id E502CAA023; Thu, 11 Feb 2021 16:18:42 -0800 (PST)
From:   Ronak Doshi <doshir@vmware.com>
To:     <netdev@vger.kernel.org>
CC:     Ronak Doshi <doshir@vmware.com>, Todd Sabin <tsabin@vmware.com>,
        "maintainer:VMWARE VMXNET3 ETHERNET DRIVER" <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Dexuan Cui <decui@microsoft.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Dongseok Yi <dseok.yi@samsung.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] avoid fragmenting page memory with netdev_alloc_cache
Date:   Thu, 11 Feb 2021 16:18:29 -0800
Message-ID: <20210212001842.32714-1-doshir@vmware.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-002.vmware.com: doshir@vmware.com does not
 designate permitted sender hosts)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Todd Sabin <tsabin@vmware.com>

Linux network stack uses an allocation page cache for skbs.  The
purpose is to reduce the number of page allocations that it needs to
make, and it works by allocating a group of pages, and then
sub-allocating skb memory from them.  When all skbs referencing the
shared pages are freed, then the block of pages is finally freed.

When these skbs are all freed close together in time, this works fine.
However, what can happen is that there are multiple nics (or multiple
rx-queues in a single nic), and the skbs are allocated to fill the rx
ring(s). If some nics or queues are far more active than others, the
entries in the less busy nic/queue may end up referencing a page
block, while all of the other packets that referenced that block of
pages are freed.

The result of this is that the memory used by an appliance for its rx
rings can slowly grow to be much greater than it was originally.

This patch fixes that by giving each vmxnet3 device a per-rx-queue page
cache.

Signed-off-by: Todd Sabin <tsabin@vmware.com>
Signed-off-by: Ronak Doshi <doshir@vmware.com>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 30 ++++++++++++++++++++++++------
 drivers/net/vmxnet3/vmxnet3_int.h |  2 ++
 include/linux/skbuff.h            |  2 ++
 net/core/skbuff.c                 | 21 +++++++++++++++------
 4 files changed, 43 insertions(+), 12 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 6e87f1fc4874..edcbc38c3ff6 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -574,9 +574,11 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 
 		if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
 			if (rbi->skb == NULL) {
-				rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
-								       rbi->len,
-								       GFP_KERNEL);
+				rbi->skb = ___netdev_alloc_skb(adapter->netdev,
+							       rbi->len + NET_IP_ALIGN, GFP_KERNEL,
+							       &adapter->frag_cache[rq->qid]);
+				if (NET_IP_ALIGN && rbi->skb)
+					skb_reserve(rbi->skb, NET_IP_ALIGN);
 				if (unlikely(rbi->skb == NULL)) {
 					rq->stats.rx_buf_alloc_failure++;
 					break;
@@ -1421,8 +1423,11 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			rxDataRingUsed =
 				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
 			len = rxDataRingUsed ? rcd->len : rbi->len;
-			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
-							    len);
+			new_skb = ___netdev_alloc_skb(adapter->netdev,
+						      rbi->len + NET_IP_ALIGN, GFP_ATOMIC,
+						      &adapter->frag_cache[rq->qid]);
+			if (NET_IP_ALIGN && new_skb)
+				skb_reserve(new_skb, NET_IP_ALIGN);
 			if (new_skb == NULL) {
 				/* Skb allocation failed, do not handover this
 				 * skb to stack. Reuse it. Drop the existing pkt
@@ -1483,6 +1488,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 					     le32_to_cpu(rcd->rssHash),
 					     PKT_HASH_TYPE_L3);
 #endif
+			skb_record_rx_queue(ctx->skb, rq->qid);
 			skb_put(ctx->skb, rcd->len);
 
 			if (VMXNET3_VERSION_GE_2(adapter) &&
@@ -3652,7 +3658,7 @@ vmxnet3_remove_device(struct pci_dev *pdev)
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
-	int size = 0;
+	int size = 0, i;
 	int num_rx_queues;
 
 #ifdef VMXNET3_RSS
@@ -3691,6 +3697,18 @@ vmxnet3_remove_device(struct pci_dev *pdev)
 			  adapter->shared, adapter->shared_pa);
 	dma_unmap_single(&adapter->pdev->dev, adapter->adapter_pa,
 			 sizeof(struct vmxnet3_adapter), PCI_DMA_TODEVICE);
+	for (i = 0; i < VMXNET3_DEVICE_MAX_RX_QUEUES; i++) {
+		struct page *page;
+		struct page_frag_cache *nc;
+
+		nc = &adapter->frag_cache[i];
+		if (unlikely(!nc->va)) {
+			/* nothing to do */
+			continue;
+		}
+		page = virt_to_page(nc->va);
+		__page_frag_cache_drain(page, nc->pagecnt_bias);
+	}
 	free_netdev(netdev);
 }
 
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index e910596b79cf..7e8767007203 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -42,6 +42,7 @@
 #include <linux/interrupt.h>
 #include <linux/workqueue.h>
 #include <linux/uaccess.h>
+#include <linux/mm.h>
 #include <asm/dma.h>
 #include <asm/page.h>
 
@@ -362,6 +363,7 @@ struct vmxnet3_adapter {
 	dma_addr_t			shared_pa;
 	dma_addr_t queue_desc_pa;
 	dma_addr_t coal_conf_pa;
+	struct page_frag_cache          frag_cache[VMXNET3_DEVICE_MAX_RX_QUEUES];
 
 	/* Wake-on-LAN */
 	u32     wol;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0a4e91a2f873..b57485016e04 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2841,6 +2841,8 @@ static inline void *netdev_alloc_frag_align(unsigned int fragsz,
 
 struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int length,
 				   gfp_t gfp_mask);
+struct sk_buff *___netdev_alloc_skb(struct net_device *dev, unsigned int length,
+				    gfp_t gfp_mask, struct page_frag_cache *nc);
 
 /**
  *	netdev_alloc_skb - allocate an skbuff for rx on a specific device
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index d380c7b5a12d..ee0611345f6c 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -409,10 +409,11 @@ void *__netdev_alloc_frag_align(unsigned int fragsz, unsigned int align_mask)
 EXPORT_SYMBOL(__netdev_alloc_frag_align);
 
 /**
- *	__netdev_alloc_skb - allocate an skbuff for rx on a specific device
+ *	___netdev_alloc_skb - allocate an skbuff for rx on a specific device
  *	@dev: network device to receive on
  *	@len: length to allocate
  *	@gfp_mask: get_free_pages mask, passed to alloc_skb
+ *	@nc: page frag cache
  *
  *	Allocate a new &sk_buff and assign it a usage count of one. The
  *	buffer has NET_SKB_PAD headroom built in. Users should allocate
@@ -421,10 +422,9 @@ EXPORT_SYMBOL(__netdev_alloc_frag_align);
  *
  *	%NULL is returned if there is no free memory.
  */
-struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
-				   gfp_t gfp_mask)
+struct sk_buff *___netdev_alloc_skb(struct net_device *dev, unsigned int len,
+				    gfp_t gfp_mask, struct page_frag_cache *nc)
 {
-	struct page_frag_cache *nc;
 	struct sk_buff *skb;
 	bool pfmemalloc;
 	void *data;
@@ -450,12 +450,14 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 		gfp_mask |= __GFP_MEMALLOC;
 
 	if (in_irq() || irqs_disabled()) {
-		nc = this_cpu_ptr(&netdev_alloc_cache);
+		if (!nc)
+			nc = this_cpu_ptr(&netdev_alloc_cache);
 		data = page_frag_alloc(nc, len, gfp_mask);
 		pfmemalloc = nc->pfmemalloc;
 	} else {
 		local_bh_disable();
-		nc = this_cpu_ptr(&napi_alloc_cache.page);
+		if (!nc)
+			nc = this_cpu_ptr(&napi_alloc_cache.page);
 		data = page_frag_alloc(nc, len, gfp_mask);
 		pfmemalloc = nc->pfmemalloc;
 		local_bh_enable();
@@ -481,6 +483,13 @@ struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
 skb_fail:
 	return skb;
 }
+EXPORT_SYMBOL(___netdev_alloc_skb);
+
+struct sk_buff *__netdev_alloc_skb(struct net_device *dev, unsigned int len,
+				   gfp_t gfp_mask)
+{
+	return ___netdev_alloc_skb(dev, len, gfp_mask, NULL);
+}
 EXPORT_SYMBOL(__netdev_alloc_skb);
 
 /**
-- 
2.11.0

