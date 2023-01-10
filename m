Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231266643E6
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 16:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbjAJPBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 10:01:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjAJPAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 10:00:35 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305F5A880
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:00:02 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w3so13440409ply.3
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 07:00:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jcXvLYljUcmFKUEgt48wrQ4OYeQUE8Uq1+aTTsnB8go=;
        b=IhEQtU6Plea63hShwU94Pgf5zCMmZS22U0kJZXchd8hVU44FRrdcTBgMZdUgyaAr74
         y2Te3IFL6lF6HkD71g/D2r+AwkpUeSzXPBq2rLMu+q4roPFxsZCUJzgu0e5WpFwiRdfY
         z1LxG+QVkRWYq2iFe3eHhlzwVVzotpqAl/xEAL1n7BdIT7bUJMINYeN1IiFRz/k77cG8
         YX3IuxqZOgY9+nCPCw4Pvc3z5D3xz+wBg/iSOFr1nxR24H2V6/XVZqw339DIhXz9QQ3O
         8IeRc0GTMsBmxUE4ooszSSac5ZkEZ8IDP0J+Lgg2zkvmKhMsAExobIR0/0PhB6rPVcFH
         JX3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jcXvLYljUcmFKUEgt48wrQ4OYeQUE8Uq1+aTTsnB8go=;
        b=qV6EN6OG5m136Y3+itA2C1ejKwtWuECyJ24/zmFFSpzLsOSpebVGZqxboBrHMPEceY
         4dqk0nka3zthKDrmhwLPMRFgtLmpsGAuHS9IIRvyZ4iMa9ZVFdloWTdaR3Sc6QQLpg/5
         f5cAD1JkrHzqnZ/+GTiGp+jEyIw9EmRjtKVfyfa55BTVpXkVSQmabvAMMralWnEdMdfh
         s3T8XS1/OZp05I6Mvxhohw9eDQXofycMX+a3nlu3j2sRU1aMbQO8MAG+Yjlz45bRA7qe
         0ir/GYfgwEnYO9twK89IXKycqruV66AskEFGWYlPmfhGfjY3ASaD9NUqAEasSeoRpngd
         jCUw==
X-Gm-Message-State: AFqh2kqtI4ZNXNkmkZmPSNNybczgbAyOtdbMHn5lPd6nGIZZdIKRiSd5
        Utfl/1mJJzuhG4YFsT1kVZRR2GULG5E=
X-Google-Smtp-Source: AMrXdXsivo9zRpo59jiZiLjCPxy4pU3QMxwu5UpvUC8JlA48bZx9T/jABFIziZ37SIe5/BDUTPO3Aw==
X-Received: by 2002:a17:903:26cf:b0:193:236:3a2b with SMTP id jg15-20020a17090326cf00b0019302363a2bmr17945928plb.3.1673362801353;
        Tue, 10 Jan 2023 07:00:01 -0800 (PST)
Received: from tucXMD6R.vmware.com.com ([2607:fb91:158f:3583:f060:5224:ab91:6e21])
        by smtp.gmail.com with ESMTPSA id l13-20020a170903244d00b00186b758c9fasm8272079pls.33.2023.01.10.06.59.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 10 Jan 2023 07:00:00 -0800 (PST)
From:   William Tu <u9012063@gmail.com>
To:     netdev@vger.kernel.org
Cc:     tuc@vmware.com, gyang@vmware.com, doshir@vmware.com,
        alexander.duyck@gmail.com, gerhard@engleder-embedded.com,
        alexandr.lobakin@intel.com, bang@vmware.com
Subject: [RFC PATCH net-next v12] vmxnet3: Add XDP support.
Date:   Tue, 10 Jan 2023 06:59:54 -0800
Message-Id: <20230110145954.32183-1-u9012063@gmail.com>
X-Mailer: git-send-email 2.32.0 (Apple Git-132)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adds native-mode XDP support: XDP DROP, PASS, TX, and REDIRECT.

Background:
The vmxnet3 rx consists of three rings: ring0, ring1, and dataring.
For r0 and r1, buffers at r0 are allocated using alloc_skb APIs and dma
mapped to the ring's descriptor. If LRO is enabled and packet size larger
than 3K, VMXNET3_MAX_SKB_BUF_SIZE, then r1 is used to mapped the rest of
the buffer larger than VMXNET3_MAX_SKB_BUF_SIZE. Each buffer in r1 is
allocated using alloc_page. So for LRO packets, the payload will be in one
buffer from r0 and multiple from r1, for non-LRO packets, only one
descriptor in r0 is used for packet size less than 3k.

When receiving a packet, the first descriptor will have the sop (start of
packet) bit set, and the last descriptor will have the eop (end of packet)
bit set. Non-LRO packets will have only one descriptor with both sop and
eop set.

Other than r0 and r1, vmxnet3 dataring is specifically designed for
handling packets with small size, usually 128 bytes, defined in
VMXNET3_DEF_RXDATA_DESC_SIZE, by simply copying the packet from the backend
driver in ESXi to the ring's memory region at front-end vmxnet3 driver, in
order to avoid memory mapping/unmapping overhead. In summary, packet size:
    A. < 128B: use dataring
    B. 128B - 3K: use ring0 (VMXNET3_RX_BUF_SKB)
    C. > 3K: use ring0 and ring1 (VMXNET3_RX_BUF_SKB + VMXNET3_RX_BUF_PAGE)
As a result, the patch adds XDP support for packets using dataring
and r0 (case A and B), not the large packet size when LRO is enabled.

XDP Implementation:
When user loads and XDP prog, vmxnet3 driver checks configurations, such
as mtu, lro, and re-allocate the rx buffer size for reserving the extra
headroom, XDP_PACKET_HEADROOM, for XDP frame. The XDP prog will then be
associated with every rx queue of the device. Note that when using dataring
for small packet size, vmxnet3 (front-end driver) doesn't control the
buffer allocation, as a result we allocate a new page and copy packet
from the dataring to XDP frame.

The receive side of XDP is implemented for case A and B, by invoking the
bpf program at vmxnet3_rq_rx_complete and handle its returned action.
The vmxnet3_process_xdp(), vmxnet3_process_xdp_small() function handles
the ring0 and dataring case separately, and decides the next journey of
the packet afterward.

For TX, vmxnet3 has split header design. Outgoing packets are parsed
first and protocol headers (L2/L3/L4) are copied to the backend. The
rest of the payload are dma mapped. Since XDP_TX does not parse the
packet protocol, the entire XDP frame is dma mapped for transmission
and transmitted in a batch. Later on, the frame is freed and recycled
back to the memory pool.

Performance:
Tested using two VMs inside one ESXi vSphere 7.0 machine, using single
core on each vmxnet3 device, sender using DPDK testpmd tx-mode attached
to vmxnet3 device, sending 64B or 512B UDP packet.

VM1 txgen:
$ dpdk-testpmd -l 0-3 -n 1 -- -i --nb-cores=3 \
--forward-mode=txonly --eth-peer=0,<mac addr of vm2>
option: add "--txonly-multi-flow"
option: use --txpkts=512 or 64 byte

VM2 running XDP:
$ ./samples/bpf/xdp_rxq_info -d ens160 -a <options> --skb-mode
$ ./samples/bpf/xdp_rxq_info -d ens160 -a <options>
options: XDP_DROP, XDP_PASS, XDP_TX

To test REDIRECT to cpu 0, use
$ ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop

Single core performance comparison with skb-mode.
64B:      skb-mode -> native-mode
XDP_DROP: 1.6Mpps -> 2.4Mpps
XDP_PASS: 338Kpps -> 367Kpps
XDP_TX:   1.1Mpps -> 2.3Mpps
REDIRECT-drop: 1.3Mpps -> 2.3Mpps

512B:     skb-mode -> native-mode
XDP_DROP: 863Kpps -> 1.3Mpps
XDP_PASS: 275Kpps -> 376Kpps
XDP_TX:   554Kpps -> 1.2Mpps
REDIRECT-drop: 659Kpps -> 1.2Mpps

Limitations:
a. LRO will be disabled when users load XDP program
b. MTU will be checked and limit to
   VMXNET3_MAX_SKB_BUF_SIZE(3K) - XDP_PACKET_HEADROOM(256) -
   SKB_DATA_ALIGN(sizeof(struct skb_shared_info))

Signed-off-by: William Tu <u9012063@gmail.com>
---
v11 -> v12:
work on feedbacks from Alexander Duyck
- fix issues and refactor the vmxnet3_unmap_tx_buf and
  unmap_pkt
- mark RFC as waiting for internal testing
- diff of v11..v12
https://github.com/williamtu/net-next/compare/162e8849903b..fd39d09824b4

v10 -> v11:
work on feedbacks from Alexander Duyck
internal feedback from Guolin and Ronak
- fix the issue of xdp_return_frame_bulk, move to up level
  of vmxnet3_unmap_tx_buf and some refactoring
- refactor and simplify vmxnet3_tq_cleanup
- disable XDP when LRO is enabled, suggested by Ronak

v9 -> v10:
- Mark as RFC as we're waiting for internal review
Feedback from Alexander Duyck
- fix dma mapping leak of ndo_xdp_xmit case
- remove unused MAP_INVALID and adjist bitfield

v8 -> v9:
new
- add rxdataring support (need extra copy but still fast)
- update performance number (much better than v8!)
  https://youtu.be/4lm1CSCi78Q

- work on feedbacks from Alexander Duyck and Alexander Lobakin
Alexander Lobakin
- use xdp_return_frame_bulk and see some performance improvement
- use xdp_do_flush not xdp_do_flush_map
- fix several alignment issues, formatting issues, minor code
  restructure, remove 2 dead functions, unrelated add/del of
  new lines, add braces when logical ops nearby, endianness
  conversion
- remove several oneliner goto label
- anonymous union of skb and xdpf
- remove xdp_enabled and use xdp prog directly to check
- use bitsfields macro --> I decide to do it later as
  there are many unrelated places needed to change.

Alexander Duyck
- use bitfield for tbi map type
- anonymous union of skb and xdpf
- remove use of modulus ops, cpu % tq_number

others
- fix issue reported from kernel test robot using sparse

v7 -> v8:
- work on feedbacks from Gerhard Engleder and Alexander
- change memory model to use page pool API, rewrite some of the
  XDP processing code
- attach bpf xdp prog to adapter, not per rx queue
- I reference some of the XDP implementation from
  drivers/net/ethernet/mediatek and
  drivers/net/ethernet/stmicro/stmmac/
- drop support for rxdataring for this version
- redo performance evaluation and demo here
  https://youtu.be/T7_0yrCXCe0
- check using /sys/kernel/debug/kmemleak

v6 -> v7:
work on feedbacks from Alexander Duyck on XDP_TX and XDP_REDIRECT
- fix memleak of xdp frame when doing ndo_xdp_xmit (vmxnet3_xdp_xmit)
- at vmxnet3_xdp_xmit_frame, fix return value, -NOSPC and ENOMEM,
  and free skb when dma map fails
- add xdp_buff_clean_frags_flag since we don't support frag
- update experiements of XDP_TX and XDP_REDIRECT
- for XDP_REDIRECT, I assume calling xdp_do_redirect will take
the buffer and free it, so I need to allocate a new buffer to
refill the rx ring. However, I hit some OOM when testing using
./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e <drop or pass>
- I couldn't find the reason so mark this patch as RFC

v5 -> v6:
work on feedbacks from Alexander Duyck
- remove unused skb parameter at vmxnet3_xdp_xmit
- add trace point for XDP_ABORTED
- avoid TX packet buffer being overwritten by allocatin
  new skb and memcpy (TX performance drop from 2.3 to 1.8Mpps)
- update some of the performance number and a demo video
  https://youtu.be/I3nx5wQDTXw
- pass VMware internal regression test using non-ENS: vmxnet3v2,
  vmxnet3v3, vmxnet3v4, so remove RFC tag.

v4 -> v5:
- move XDP code to separate file: vmxnet3_xdp.{c, h},
  suggested by Guolin
- expose vmxnet3_rq_create_all and vmxnet3_adjust_rx_ring_size
- more test using samples/bpf/{xdp1, xdp2, xdp_adjust_tail}
- add debug print
- rebase on commit 65e6af6cebe

v3 -> v4:
- code refactoring and improved commit message
- make dataring and non-dataring case clear
- in XDP_PASS, handle xdp.data and xdp.data_end change after
  bpf program executed
- now still working on internal testing
- v4 applied on net-next commit 65e6af6cebef

v2 -> v3:
- code refactoring: move the XDP processing to the front
  of the vmxnet3_rq_rx_complete, and minimize the places
  of changes to existing code.
- Performance improvement over BUF_SKB (512B) due to skipping
  skb allocation when DROP and TX.

v1 -> v2:
- Avoid skb allocation for small packet size (when dataring is used)
- Use rcu_read_lock unlock instead of READ_ONCE
- Peroformance improvement over v1
- Merge xdp drop, tx, pass, and redirect into 1 patch

I tested the patch using below script:
while [ true ]; do
timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP --skb-mode
timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_DROP
timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_PASS --skb-mode
timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_PASS
timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_TX --skb-mode
timeout 20 ./samples/bpf/xdp_rxq_info -d ens160 -a XDP_TX
timeout 20 ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e drop
timeout 20 ./samples/bpf/xdp_redirect_cpu -d ens160 -c 0 -e pass
done
---
 drivers/net/Kconfig                   |   1 +
 drivers/net/vmxnet3/Makefile          |   2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c     | 225 ++++++++++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c |  14 +
 drivers/net/vmxnet3/vmxnet3_int.h     |  44 ++-
 drivers/net/vmxnet3/vmxnet3_xdp.c     | 425 ++++++++++++++++++++++++++
 drivers/net/vmxnet3/vmxnet3_xdp.h     |  41 +++
 7 files changed, 708 insertions(+), 44 deletions(-)
 create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.c
 create mode 100644 drivers/net/vmxnet3/vmxnet3_xdp.h

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 9e63b8c43f3e..a4419d661bdd 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -571,6 +571,7 @@ config VMXNET3
 	tristate "VMware VMXNET3 ethernet driver"
 	depends on PCI && INET
 	depends on PAGE_SIZE_LESS_THAN_64KB
+	select PAGE_POOL
 	help
 	  This driver supports VMware's vmxnet3 virtual ethernet NIC.
 	  To compile this driver as a module, choose M here: the
diff --git a/drivers/net/vmxnet3/Makefile b/drivers/net/vmxnet3/Makefile
index a666a88ac1ff..f82870c10205 100644
--- a/drivers/net/vmxnet3/Makefile
+++ b/drivers/net/vmxnet3/Makefile
@@ -32,4 +32,4 @@
 
 obj-$(CONFIG_VMXNET3) += vmxnet3.o
 
-vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o
+vmxnet3-objs := vmxnet3_drv.o vmxnet3_ethtool.o vmxnet3_xdp.o
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index d3e7b27eb933..0c3b8f6bae22 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -28,6 +28,7 @@
 #include <net/ip6_checksum.h>
 
 #include "vmxnet3_int.h"
+#include "vmxnet3_xdp.h"
 
 char vmxnet3_driver_name[] = "vmxnet3";
 #define VMXNET3_DRIVER_DESC "VMware vmxnet3 virtual NIC driver"
@@ -323,17 +324,18 @@ static u32 get_bitfield32(const __le32 *bitfield, u32 pos, u32 size)
 
 
 static void
-vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
-		     struct pci_dev *pdev)
+vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi, struct pci_dev *pdev)
 {
-	if (tbi->map_type == VMXNET3_MAP_SINGLE)
+	u32 map_type = tbi->map_type;
+
+	if (map_type & VMXNET3_MAP_SINGLE)
 		dma_unmap_single(&pdev->dev, tbi->dma_addr, tbi->len,
 				 DMA_TO_DEVICE);
-	else if (tbi->map_type == VMXNET3_MAP_PAGE)
+	else if (map_type & VMXNET3_MAP_PAGE)
 		dma_unmap_page(&pdev->dev, tbi->dma_addr, tbi->len,
 			       DMA_TO_DEVICE);
 	else
-		BUG_ON(tbi->map_type != VMXNET3_MAP_NONE);
+		BUG_ON((map_type & ~VMXNET3_MAP_XDP));
 
 	tbi->map_type = VMXNET3_MAP_NONE; /* to help debugging */
 }
@@ -341,25 +343,25 @@ vmxnet3_unmap_tx_buf(struct vmxnet3_tx_buf_info *tbi,
 
 static int
 vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
-		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter)
+		  struct pci_dev *pdev,	struct vmxnet3_adapter *adapter,
+		  struct xdp_frame_bulk *bq)
 {
-	struct sk_buff *skb;
+	struct vmxnet3_tx_buf_info *tbi;
 	int entries = 0;
+	u32 map_type;
 
 	/* no out of order completion */
 	BUG_ON(tq->buf_info[eop_idx].sop_idx != tq->tx_ring.next2comp);
 	BUG_ON(VMXNET3_TXDESC_GET_EOP(&(tq->tx_ring.base[eop_idx].txd)) != 1);
 
-	skb = tq->buf_info[eop_idx].skb;
-	BUG_ON(skb == NULL);
-	tq->buf_info[eop_idx].skb = NULL;
-
+	tbi = &tq->buf_info[eop_idx];
+	BUG_ON(tbi->skb == NULL);
+	map_type = tbi->map_type;
 	VMXNET3_INC_RING_IDX_ONLY(eop_idx, tq->tx_ring.size);
 
 	while (tq->tx_ring.next2comp != eop_idx) {
 		vmxnet3_unmap_tx_buf(tq->buf_info + tq->tx_ring.next2comp,
 				     pdev);
-
 		/* update next2comp w/o tx_lock. Since we are marking more,
 		 * instead of less, tx ring entries avail, the worst case is
 		 * that the tx routine incorrectly re-queues a pkt due to
@@ -369,7 +371,14 @@ vmxnet3_unmap_pkt(u32 eop_idx, struct vmxnet3_tx_queue *tq,
 		entries++;
 	}
 
-	dev_kfree_skb_any(skb);
+	if (map_type & VMXNET3_MAP_XDP)
+		xdp_return_frame_bulk(tbi->xdpf, bq);
+	else
+		dev_kfree_skb_any(tbi->skb);
+
+	/* xdpf and skb are in an anonymous union. */
+	tbi->skb = NULL;
+
 	return entries;
 }
 
@@ -379,8 +388,10 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
 			struct vmxnet3_adapter *adapter)
 {
 	int completed = 0;
+	struct xdp_frame_bulk bq;
 	union Vmxnet3_GenericDesc *gdesc;
 
+	xdp_frame_bulk_init(&bq);
 	gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
 	while (VMXNET3_TCD_GET_GEN(&gdesc->tcd) == tq->comp_ring.gen) {
 		/* Prevent any &gdesc->tcd field from being (speculatively)
@@ -390,11 +401,12 @@ vmxnet3_tq_tx_complete(struct vmxnet3_tx_queue *tq,
 
 		completed += vmxnet3_unmap_pkt(VMXNET3_TCD_GET_TXIDX(
 					       &gdesc->tcd), tq, adapter->pdev,
-					       adapter);
+					       adapter, &bq);
 
 		vmxnet3_comp_ring_adv_next2proc(&tq->comp_ring);
 		gdesc = tq->comp_ring.base + tq->comp_ring.next2proc;
 	}
+	xdp_flush_frame_bulk(&bq);
 
 	if (completed) {
 		spin_lock(&tq->tx_lock);
@@ -414,26 +426,34 @@ static void
 vmxnet3_tq_cleanup(struct vmxnet3_tx_queue *tq,
 		   struct vmxnet3_adapter *adapter)
 {
+	struct xdp_frame_bulk bq;
+	u32 map_type;
 	int i;
 
+	xdp_frame_bulk_init(&bq);
+
 	while (tq->tx_ring.next2comp != tq->tx_ring.next2fill) {
 		struct vmxnet3_tx_buf_info *tbi;
 
 		tbi = tq->buf_info + tq->tx_ring.next2comp;
+		map_type = tbi->map_type;
 
 		vmxnet3_unmap_tx_buf(tbi, adapter->pdev);
 		if (tbi->skb) {
-			dev_kfree_skb_any(tbi->skb);
+			if (map_type & VMXNET3_MAP_XDP)
+				xdp_return_frame_bulk(tbi->xdpf, &bq);
+			else
+				dev_kfree_skb_any(tbi->skb);
 			tbi->skb = NULL;
 		}
 		vmxnet3_cmd_ring_adv_next2comp(&tq->tx_ring);
 	}
 
-	/* sanity check, verify all buffers are indeed unmapped and freed */
-	for (i = 0; i < tq->tx_ring.size; i++) {
-		BUG_ON(tq->buf_info[i].skb != NULL ||
-		       tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
-	}
+	xdp_flush_frame_bulk(&bq);
+
+	/* sanity check, verify all buffers are indeed unmapped */
+	for (i = 0; i < tq->tx_ring.size; i++)
+		BUG_ON(tq->buf_info[i].map_type != VMXNET3_MAP_NONE);
 
 	tq->tx_ring.gen = VMXNET3_INIT_GEN;
 	tq->tx_ring.next2fill = tq->tx_ring.next2comp = 0;
@@ -587,7 +607,17 @@ vmxnet3_rq_alloc_rx_buf(struct vmxnet3_rx_queue *rq, u32 ring_idx,
 		gd = ring->base + ring->next2fill;
 		rbi->comp_state = VMXNET3_RXD_COMP_PENDING;
 
-		if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
+		if (rbi->buf_type == VMXNET3_RX_BUF_XDP) {
+			void *data = vmxnet3_pp_get_buff(rq->page_pool,
+							 &rbi->dma_addr,
+							 GFP_KERNEL);
+			if (!data) {
+				rq->stats.rx_buf_alloc_failure++;
+				break;
+			}
+			rbi->pp_page = virt_to_head_page(data);
+			val = VMXNET3_RXD_BTYPE_HEAD << VMXNET3_RXD_BTYPE_SHIFT;
+		} else if (rbi->buf_type == VMXNET3_RX_BUF_SKB) {
 			if (rbi->skb == NULL) {
 				rbi->skb = __netdev_alloc_skb_ip_align(adapter->netdev,
 								       rbi->len,
@@ -1253,6 +1283,60 @@ vmxnet3_tq_xmit(struct sk_buff *skb, struct vmxnet3_tx_queue *tq,
 	return NETDEV_TX_OK;
 }
 
+static int
+vmxnet3_create_pp(struct vmxnet3_adapter *adapter,
+		  struct vmxnet3_rx_queue *rq, int size)
+{
+	const struct page_pool_params pp_params = {
+		.order = 0,
+		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
+		.pool_size = size,
+		.nid = NUMA_NO_NODE,
+		.dev = &adapter->pdev->dev,
+		.offset = XDP_PACKET_HEADROOM,
+		.max_len = VMXNET3_XDP_MAX_MTU,
+		.dma_dir = DMA_BIDIRECTIONAL,
+	};
+	struct page_pool *pp;
+	int err;
+
+	pp = page_pool_create(&pp_params);
+	if (IS_ERR(pp))
+		return PTR_ERR(pp);
+
+	err = xdp_rxq_info_reg(&rq->xdp_rxq, adapter->netdev, rq->qid,
+			       rq->napi.napi_id);
+	if (err < 0)
+		goto err_free_pp;
+
+	err = xdp_rxq_info_reg_mem_model(&rq->xdp_rxq, MEM_TYPE_PAGE_POOL, pp);
+	if (err)
+		goto err_unregister_rxq;
+
+	rq->page_pool = pp;
+	return 0;
+
+err_unregister_rxq:
+	xdp_rxq_info_unreg(&rq->xdp_rxq);
+err_free_pp:
+	page_pool_destroy(pp);
+
+	return err;
+}
+
+void *
+vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
+		    gfp_t gfp_mask)
+{
+	struct page *page;
+
+	page = page_pool_alloc_pages(pp, gfp_mask | __GFP_NOWARN);
+	if (!page)
+		return NULL;
+
+	*dma_addr = page_pool_get_dma_addr(page) + XDP_PACKET_HEADROOM;
+	return page_address(page);
+}
 
 static netdev_tx_t
 vmxnet3_xmit_frame(struct sk_buff *skb, struct net_device *netdev)
@@ -1404,6 +1488,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 	struct Vmxnet3_RxDesc rxCmdDesc;
 	struct Vmxnet3_RxCompDesc rxComp;
 #endif
+	bool need_flush = 0;
+
 	vmxnet3_getRxComp(rcd, &rq->comp_ring.base[rq->comp_ring.next2proc].rcd,
 			  &rxComp);
 	while (rcd->gen == rq->comp_ring.gen) {
@@ -1444,6 +1530,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			goto rcd_done;
 		}
 
+		if (rcd->sop && rcd->eop && vmxnet3_xdp_enabled(adapter)) {
+			struct sk_buff *skb_xdp_pass;
+			int act;
+
+			if (VMXNET3_RX_DATA_RING(adapter, rcd->rqID)) {
+				ctx->skb = NULL;
+				goto skip_xdp; /* Handle it later. */
+			}
+
+			if (rbi->buf_type != VMXNET3_RX_BUF_XDP)
+				goto rcd_done;
+
+			act = vmxnet3_process_xdp(adapter, rq, rcd, rbi, rxd,
+						  &skb_xdp_pass);
+			if (act == XDP_PASS) {
+				ctx->skb = skb_xdp_pass;
+				goto sop_done;
+			}
+			ctx->skb = NULL;
+			if (act == XDP_REDIRECT)
+				need_flush = true;
+			goto rcd_done;
+		}
+skip_xdp:
+
 		if (rcd->sop) { /* first buf of the pkt */
 			bool rxDataRingUsed;
 			u16 len;
@@ -1452,7 +1563,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			       (rcd->rqID != rq->qid &&
 				rcd->rqID != rq->dataRingQid));
 
-			BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB);
+			BUG_ON(rbi->buf_type != VMXNET3_RX_BUF_SKB &&
+			       rbi->buf_type != VMXNET3_RX_BUF_XDP);
 			BUG_ON(ctx->skb != NULL || rbi->skb == NULL);
 
 			if (unlikely(rcd->len == 0)) {
@@ -1470,6 +1582,26 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			rxDataRingUsed =
 				VMXNET3_RX_DATA_RING(adapter, rcd->rqID);
 			len = rxDataRingUsed ? rcd->len : rbi->len;
+
+			if (rxDataRingUsed && vmxnet3_xdp_enabled(adapter)) {
+				struct sk_buff *skb_xdp_pass;
+				size_t sz;
+				int act;
+
+				sz = rcd->rxdIdx * rq->data_ring.desc_size;
+				act = vmxnet3_process_xdp_small(adapter, rq,
+								&rq->data_ring.base[sz],
+								rcd->len,
+								&skb_xdp_pass);
+				if (act == XDP_PASS) {
+					ctx->skb = skb_xdp_pass;
+					goto sop_done;
+				}
+				if (act == XDP_REDIRECT)
+					need_flush = true;
+
+				goto rcd_done;
+			}
 			new_skb = netdev_alloc_skb_ip_align(adapter->netdev,
 							    len);
 			if (new_skb == NULL) {
@@ -1622,6 +1754,7 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		}
 
 
+sop_done:
 		skb = ctx->skb;
 		if (rcd->eop) {
 			u32 mtu = adapter->netdev->mtu;
@@ -1730,6 +1863,8 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 		vmxnet3_getRxComp(rcd,
 				  &rq->comp_ring.base[rq->comp_ring.next2proc].rcd, &rxComp);
 	}
+	if (need_flush)
+		xdp_do_flush();
 
 	return num_pkts;
 }
@@ -1755,13 +1890,20 @@ vmxnet3_rq_cleanup(struct vmxnet3_rx_queue *rq,
 				&rq->rx_ring[ring_idx].base[i].rxd, &rxDesc);
 
 			if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
-					rq->buf_info[ring_idx][i].skb) {
+			    rq->buf_info[ring_idx][i].pp_page &&
+			    rq->buf_info[ring_idx][i].buf_type ==
+			    VMXNET3_RX_BUF_XDP) {
+				page_pool_recycle_direct(rq->page_pool,
+							 rq->buf_info[ring_idx][i].pp_page);
+				rq->buf_info[ring_idx][i].pp_page = NULL;
+			} else if (rxd->btype == VMXNET3_RXD_BTYPE_HEAD &&
+				   rq->buf_info[ring_idx][i].skb) {
 				dma_unmap_single(&adapter->pdev->dev, rxd->addr,
 						 rxd->len, DMA_FROM_DEVICE);
 				dev_kfree_skb(rq->buf_info[ring_idx][i].skb);
 				rq->buf_info[ring_idx][i].skb = NULL;
 			} else if (rxd->btype == VMXNET3_RXD_BTYPE_BODY &&
-					rq->buf_info[ring_idx][i].page) {
+				   rq->buf_info[ring_idx][i].page) {
 				dma_unmap_page(&adapter->pdev->dev, rxd->addr,
 					       rxd->len, DMA_FROM_DEVICE);
 				put_page(rq->buf_info[ring_idx][i].page);
@@ -1786,9 +1928,9 @@ vmxnet3_rq_cleanup_all(struct vmxnet3_adapter *adapter)
 
 	for (i = 0; i < adapter->num_rx_queues; i++)
 		vmxnet3_rq_cleanup(&adapter->rx_queue[i], adapter);
+	rcu_assign_pointer(adapter->xdp_bpf_prog, NULL);
 }
 
-
 static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 			       struct vmxnet3_adapter *adapter)
 {
@@ -1815,6 +1957,13 @@ static void vmxnet3_rq_destroy(struct vmxnet3_rx_queue *rq,
 		}
 	}
 
+	if (rq->page_pool) {
+		if (xdp_rxq_info_is_reg(&rq->xdp_rxq))
+			xdp_rxq_info_unreg(&rq->xdp_rxq);
+		page_pool_destroy(rq->page_pool);
+		rq->page_pool = NULL;
+	}
+
 	if (rq->data_ring.base) {
 		dma_free_coherent(&adapter->pdev->dev,
 				  rq->rx_ring[0].size * rq->data_ring.desc_size,
@@ -1858,14 +2007,16 @@ static int
 vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 		struct vmxnet3_adapter  *adapter)
 {
-	int i;
+	int i, err;
 
 	/* initialize buf_info */
 	for (i = 0; i < rq->rx_ring[0].size; i++) {
 
-		/* 1st buf for a pkt is skbuff */
+		/* 1st buf for a pkt is skbuff or xdp page */
 		if (i % adapter->rx_buf_per_pkt == 0) {
-			rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_SKB;
+			rq->buf_info[0][i].buf_type = vmxnet3_xdp_enabled(adapter) ?
+						      VMXNET3_RX_BUF_XDP :
+						      VMXNET3_RX_BUF_SKB;
 			rq->buf_info[0][i].len = adapter->skb_buf_size;
 		} else { /* subsequent bufs for a pkt is frag */
 			rq->buf_info[0][i].buf_type = VMXNET3_RX_BUF_PAGE;
@@ -1886,6 +2037,12 @@ vmxnet3_rq_init(struct vmxnet3_rx_queue *rq,
 		rq->rx_ring[i].gen = VMXNET3_INIT_GEN;
 		rq->rx_ring[i].isOutOfOrder = 0;
 	}
+
+	err = vmxnet3_create_pp(adapter, rq,
+				rq->rx_ring[0].size + rq->rx_ring[1].size);
+	if (err)
+		return err;
+
 	if (vmxnet3_rq_alloc_rx_buf(rq, 0, rq->rx_ring[0].size - 1,
 				    adapter) == 0) {
 		/* at least has 1 rx buffer for the 1st ring */
@@ -1989,7 +2146,7 @@ vmxnet3_rq_create(struct vmxnet3_rx_queue *rq, struct vmxnet3_adapter *adapter)
 }
 
 
-static int
+int
 vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter)
 {
 	int i, err = 0;
@@ -2585,7 +2742,7 @@ vmxnet3_setup_driver_shared(struct vmxnet3_adapter *adapter)
 	if (adapter->netdev->features & NETIF_F_RXCSUM)
 		devRead->misc.uptFeatures |= UPT1_F_RXCSUM;
 
-	if (adapter->netdev->features & NETIF_F_LRO) {
+	if ((adapter->netdev->features & NETIF_F_LRO)) {
 		devRead->misc.uptFeatures |= UPT1_F_LRO;
 		devRead->misc.maxNumRxSG = cpu_to_le16(1 + MAX_SKB_FRAGS);
 	}
@@ -3026,7 +3183,7 @@ vmxnet3_free_pci_resources(struct vmxnet3_adapter *adapter)
 }
 
 
-static void
+void
 vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 {
 	size_t sz, i, ring0_size, ring1_size, comp_size;
@@ -3035,7 +3192,8 @@ vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter)
 		if (adapter->netdev->mtu <= VMXNET3_MAX_SKB_BUF_SIZE -
 					    VMXNET3_MAX_ETH_HDR_SIZE) {
 			adapter->skb_buf_size = adapter->netdev->mtu +
-						VMXNET3_MAX_ETH_HDR_SIZE;
+						VMXNET3_MAX_ETH_HDR_SIZE +
+						vmxnet3_xdp_headroom(adapter);
 			if (adapter->skb_buf_size < VMXNET3_MIN_T0_BUF_SIZE)
 				adapter->skb_buf_size = VMXNET3_MIN_T0_BUF_SIZE;
 
@@ -3563,7 +3721,6 @@ vmxnet3_reset_work(struct work_struct *data)
 	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
 }
 
-
 static int
 vmxnet3_probe_device(struct pci_dev *pdev,
 		     const struct pci_device_id *id)
@@ -3585,6 +3742,8 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 		.ndo_poll_controller = vmxnet3_netpoll,
 #endif
+		.ndo_bpf = vmxnet3_xdp,
+		.ndo_xdp_xmit = vmxnet3_xdp_xmit,
 	};
 	int err;
 	u32 ver;
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 18cf7c723201..6f542236b26e 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -76,6 +76,10 @@ vmxnet3_tq_driver_stats[] = {
 					 copy_skb_header) },
 	{ "  giant hdr",	offsetof(struct vmxnet3_tq_driver_stats,
 					 oversized_hdr) },
+	{ "  xdp xmit",		offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit) },
+	{ "  xdp xmit err",	offsetof(struct vmxnet3_tq_driver_stats,
+					 xdp_xmit_err) },
 };
 
 /* per rq stats maintained by the device */
@@ -106,6 +110,16 @@ vmxnet3_rq_driver_stats[] = {
 					 drop_fcs) },
 	{ "  rx buf alloc fail", offsetof(struct vmxnet3_rq_driver_stats,
 					  rx_buf_alloc_failure) },
+	{ "     xdp packets", offsetof(struct vmxnet3_rq_driver_stats,
+				       xdp_packets) },
+	{ "     xdp tx", offsetof(struct vmxnet3_rq_driver_stats,
+				  xdp_tx) },
+	{ "     xdp redirects", offsetof(struct vmxnet3_rq_driver_stats,
+					 xdp_redirects) },
+	{ "     xdp drops", offsetof(struct vmxnet3_rq_driver_stats,
+				     xdp_drops) },
+	{ "     xdp aborted", offsetof(struct vmxnet3_rq_driver_stats,
+				       xdp_aborted) },
 };
 
 /* global stats maintained by the driver */
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index 3367db23aa13..e2fda61f3d01 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -56,6 +56,9 @@
 #include <linux/if_arp.h>
 #include <linux/inetdevice.h>
 #include <linux/log2.h>
+#include <linux/bpf.h>
+#include <linux/skbuff.h>
+#include <net/page_pool.h>
 
 #include "vmxnet3_defs.h"
 
@@ -188,19 +191,20 @@ struct vmxnet3_tx_data_ring {
 	dma_addr_t          basePA;
 };
 
-enum vmxnet3_buf_map_type {
-	VMXNET3_MAP_INVALID = 0,
-	VMXNET3_MAP_NONE,
-	VMXNET3_MAP_SINGLE,
-	VMXNET3_MAP_PAGE,
-};
+#define VMXNET3_MAP_NONE	0
+#define VMXNET3_MAP_SINGLE	BIT(0)
+#define VMXNET3_MAP_PAGE	BIT(1)
+#define VMXNET3_MAP_XDP		BIT(2)
 
 struct vmxnet3_tx_buf_info {
 	u32      map_type;
 	u16      len;
 	u16      sop_idx;
 	dma_addr_t  dma_addr;
-	struct sk_buff *skb;
+	union {
+		struct sk_buff *skb;
+		struct xdp_frame *xdpf;
+	};
 };
 
 struct vmxnet3_tq_driver_stats {
@@ -217,6 +221,9 @@ struct vmxnet3_tq_driver_stats {
 	u64 linearized;         /* # of pkts linearized */
 	u64 copy_skb_header;    /* # of times we have to copy skb header */
 	u64 oversized_hdr;
+
+	u64 xdp_xmit;
+	u64 xdp_xmit_err;
 };
 
 struct vmxnet3_tx_ctx {
@@ -253,12 +260,13 @@ struct vmxnet3_tx_queue {
 						    * stopped */
 	int				qid;
 	u16				txdata_desc_size;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+} ____cacheline_aligned;
 
 enum vmxnet3_rx_buf_type {
 	VMXNET3_RX_BUF_NONE = 0,
 	VMXNET3_RX_BUF_SKB = 1,
-	VMXNET3_RX_BUF_PAGE = 2
+	VMXNET3_RX_BUF_PAGE = 2,
+	VMXNET3_RX_BUF_XDP = 3
 };
 
 #define VMXNET3_RXD_COMP_PENDING        0
@@ -271,6 +279,7 @@ struct vmxnet3_rx_buf_info {
 	union {
 		struct sk_buff *skb;
 		struct page    *page;
+		struct page    *pp_page; /* Page Pool for XDP frame */
 	};
 	dma_addr_t dma_addr;
 };
@@ -285,6 +294,12 @@ struct vmxnet3_rq_driver_stats {
 	u64 drop_err;
 	u64 drop_fcs;
 	u64 rx_buf_alloc_failure;
+
+	u64 xdp_packets;	/* Total packets processed by XDP. */
+	u64 xdp_tx;
+	u64 xdp_redirects;
+	u64 xdp_drops;
+	u64 xdp_aborted;
 };
 
 struct vmxnet3_rx_data_ring {
@@ -307,7 +322,9 @@ struct vmxnet3_rx_queue {
 	struct vmxnet3_rx_buf_info     *buf_info[2];
 	struct Vmxnet3_RxQueueCtrl            *shared;
 	struct vmxnet3_rq_driver_stats  stats;
-} __attribute__((__aligned__(SMP_CACHE_BYTES)));
+	struct page_pool *page_pool;
+	struct xdp_rxq_info xdp_rxq;
+} ____cacheline_aligned;
 
 #define VMXNET3_DEVICE_MAX_TX_QUEUES 32
 #define VMXNET3_DEVICE_MAX_RX_QUEUES 32   /* Keep this value as a power of 2 */
@@ -415,6 +432,7 @@ struct vmxnet3_adapter {
 	u16    tx_prod_offset;
 	u16    rx_prod_offset;
 	u16    rx_prod2_offset;
+	struct bpf_prog __rcu *xdp_bpf_prog;
 };
 
 #define VMXNET3_WRITE_BAR0_REG(adapter, reg, val)  \
@@ -490,6 +508,12 @@ vmxnet3_tq_destroy_all(struct vmxnet3_adapter *adapter);
 void
 vmxnet3_rq_destroy_all(struct vmxnet3_adapter *adapter);
 
+int
+vmxnet3_rq_create_all(struct vmxnet3_adapter *adapter);
+
+void
+vmxnet3_adjust_rx_ring_size(struct vmxnet3_adapter *adapter);
+
 netdev_features_t
 vmxnet3_fix_features(struct net_device *netdev, netdev_features_t features);
 
diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.c b/drivers/net/vmxnet3/vmxnet3_xdp.c
new file mode 100644
index 000000000000..e0875768b40e
--- /dev/null
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.c
@@ -0,0 +1,425 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Linux driver for VMware's vmxnet3 ethernet NIC.
+ * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
+ * Maintained by: pv-drivers@vmware.com
+ *
+ */
+
+#include "vmxnet3_int.h"
+#include "vmxnet3_xdp.h"
+
+static void
+vmxnet3_xdp_exchange_program(struct vmxnet3_adapter *adapter,
+			     struct bpf_prog *prog)
+{
+	rcu_assign_pointer(adapter->xdp_bpf_prog, prog);
+}
+
+static int
+vmxnet3_xdp_set(struct net_device *netdev, struct netdev_bpf *bpf,
+		struct netlink_ext_ack *extack)
+{
+	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
+	struct bpf_prog *new_bpf_prog = bpf->prog;
+	struct bpf_prog *old_bpf_prog;
+	bool need_update;
+	bool running;
+	int err = 0;
+
+	if (new_bpf_prog && netdev->mtu > VMXNET3_XDP_MAX_MTU) {
+		NL_SET_ERR_MSG_MOD(extack, "MTU too large for XDP");
+		return -EOPNOTSUPP;
+	}
+
+	if ((adapter->netdev->features & NETIF_F_LRO)) {
+		NL_SET_ERR_MSG_MOD(extack, "LRO not supported for XDP");
+		return -EOPNOTSUPP;
+	}
+
+	old_bpf_prog = rcu_dereference(adapter->xdp_bpf_prog);
+	if (!new_bpf_prog && !old_bpf_prog)
+		return 0;
+
+	running = netif_running(netdev);
+	need_update = !!old_bpf_prog != !!new_bpf_prog;
+
+	if (running && need_update)
+		vmxnet3_quiesce_dev(adapter);
+
+	vmxnet3_xdp_exchange_program(adapter, new_bpf_prog);
+	if (old_bpf_prog)
+		bpf_prog_put(old_bpf_prog);
+
+	if (!running || !need_update)
+		return 0;
+
+	vmxnet3_reset_dev(adapter);
+	vmxnet3_rq_destroy_all(adapter);
+	vmxnet3_adjust_rx_ring_size(adapter);
+	err = vmxnet3_rq_create_all(adapter);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "failed to re-create rx queues for XDP.");
+		err = -EOPNOTSUPP;
+		return err;
+	}
+	err = vmxnet3_activate_dev(adapter);
+	if (err) {
+		NL_SET_ERR_MSG_MOD(extack,
+				   "failed to activate device for XDP.");
+		err = -EOPNOTSUPP;
+		return err;
+	}
+	clear_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state);
+	return err;
+}
+
+/* This is the main xdp call used by kernel to set/unset eBPF program. */
+int
+vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf)
+{
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return vmxnet3_xdp_set(netdev, bpf, bpf->extack);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+bool
+vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter)
+{
+	return !!rcu_access_pointer(adapter->xdp_bpf_prog);
+}
+
+int
+vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter)
+{
+	return vmxnet3_xdp_enabled(adapter) ? VMXNET3_XDP_PAD : 0;
+}
+
+static int
+vmxnet3_xdp_xmit_frame(struct vmxnet3_adapter *adapter,
+		       struct xdp_frame *xdpf,
+		       struct vmxnet3_tx_queue *tq, bool dma_map)
+{
+	struct vmxnet3_tx_buf_info *tbi = NULL;
+	union Vmxnet3_GenericDesc *gdesc;
+	struct vmxnet3_tx_ctx ctx;
+	int tx_num_deferred;
+	struct page *page;
+	u32 buf_size;
+	int ret = 0;
+	u32 dw2;
+
+	dw2 = (tq->tx_ring.gen ^ 0x1) << VMXNET3_TXD_GEN_SHIFT;
+	dw2 |= xdpf->len;
+	ctx.sop_txd = tq->tx_ring.base + tq->tx_ring.next2fill;
+	gdesc = ctx.sop_txd;
+
+	buf_size = xdpf->len;
+	tbi = tq->buf_info + tq->tx_ring.next2fill;
+
+	if (vmxnet3_cmd_ring_desc_avail(&tq->tx_ring) == 0) {
+		tq->stats.tx_ring_full++;
+		return -ENOSPC;
+	}
+
+	tbi->map_type = VMXNET3_MAP_XDP;
+	if (dma_map) { /* ndo_xdp_xmit */
+		tbi->dma_addr = dma_map_single(&adapter->pdev->dev,
+					       xdpf->data, buf_size,
+					       DMA_TO_DEVICE);
+		if (dma_mapping_error(&adapter->pdev->dev, tbi->dma_addr))
+			return -EFAULT;
+		tbi->map_type |= VMXNET3_MAP_SINGLE;
+	} else { /* XDP buffer from page pool */
+		page = virt_to_head_page(xdpf->data);
+		tbi->dma_addr = page_pool_get_dma_addr(page) +
+				XDP_PACKET_HEADROOM;
+		dma_sync_single_for_device(&adapter->pdev->dev,
+					   tbi->dma_addr, buf_size,
+					   DMA_BIDIRECTIONAL);
+	}
+	tbi->xdpf = xdpf;
+	tbi->len = buf_size;
+
+	gdesc = tq->tx_ring.base + tq->tx_ring.next2fill;
+	WARN_ON_ONCE(gdesc->txd.gen == tq->tx_ring.gen);
+
+	gdesc->txd.addr = cpu_to_le64(tbi->dma_addr);
+	gdesc->dword[2] = cpu_to_le32(dw2);
+
+	/* Setup the EOP desc */
+	gdesc->dword[3] = cpu_to_le32(VMXNET3_TXD_CQ | VMXNET3_TXD_EOP);
+
+	gdesc->txd.om = 0;
+	gdesc->txd.msscof = 0;
+	gdesc->txd.hlen = 0;
+	gdesc->txd.ti = 0;
+
+	tx_num_deferred = le32_to_cpu(tq->shared->txNumDeferred);
+	le32_add_cpu(&tq->shared->txNumDeferred, 1);
+	tx_num_deferred++;
+
+	vmxnet3_cmd_ring_adv_next2fill(&tq->tx_ring);
+
+	/* set the last buf_info for the pkt */
+	tbi->sop_idx = ctx.sop_txd - tq->tx_ring.base;
+
+	dma_wmb();
+	gdesc->dword[2] = cpu_to_le32(le32_to_cpu(gdesc->dword[2]) ^
+						  VMXNET3_TXD_GEN);
+
+	if (tx_num_deferred >= le32_to_cpu(tq->shared->txThreshold)) {
+		tq->shared->txNumDeferred = 0;
+		VMXNET3_WRITE_BAR0_REG(adapter,
+				       VMXNET3_REG_TXPROD + tq->qid * 8,
+				       tq->tx_ring.next2fill);
+	}
+	return ret;
+}
+
+static int
+vmxnet3_xdp_xmit_back(struct vmxnet3_adapter *adapter,
+		      struct xdp_frame *xdpf)
+{
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int err = 0, cpu;
+	int tq_number;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	if (likely(cpu < tq_number))
+		tq = &adapter->tx_queue[cpu];
+	else
+		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
+	if (tq->stopped)
+		return -ENETDOWN;
+
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	__netif_tx_lock(nq, cpu);
+	err = vmxnet3_xdp_xmit_frame(adapter, xdpf, tq, false);
+	__netif_tx_unlock(nq);
+	return err;
+}
+
+/* ndo_xdp_xmit */
+int
+vmxnet3_xdp_xmit(struct net_device *dev,
+		 int n, struct xdp_frame **frames, u32 flags)
+{
+	struct vmxnet3_adapter *adapter;
+	struct vmxnet3_tx_queue *tq;
+	struct netdev_queue *nq;
+	int i, err, cpu;
+	int tq_number;
+
+	adapter = netdev_priv(dev);
+
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_QUIESCED, &adapter->state)))
+		return -ENETDOWN;
+	if (unlikely(test_bit(VMXNET3_STATE_BIT_RESETTING, &adapter->state)))
+		return -EINVAL;
+
+	tq_number = adapter->num_tx_queues;
+	cpu = smp_processor_id();
+	if (likely(cpu < tq_number))
+		tq = &adapter->tx_queue[cpu];
+	else
+		tq = &adapter->tx_queue[reciprocal_scale(cpu, tq_number)];
+	if (tq->stopped)
+		return -ENETDOWN;
+
+	nq = netdev_get_tx_queue(adapter->netdev, tq->qid);
+
+	for (i = 0; i < n; i++) {
+		err = vmxnet3_xdp_xmit_frame(adapter, frames[i], tq, true);
+		if (err) {
+			tq->stats.xdp_xmit_err++;
+			break;
+		}
+	}
+	tq->stats.xdp_xmit += i;
+
+	return i;
+}
+
+static int
+vmxnet3_run_xdp(struct vmxnet3_rx_queue *rq, struct xdp_buff *xdp)
+{
+	struct xdp_frame *xdpf;
+	struct bpf_prog *prog;
+	int err;
+	u32 act;
+
+	prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
+	act = bpf_prog_run_xdp(prog, xdp);
+	rq->stats.xdp_packets++;
+
+	switch (act) {
+	case XDP_PASS:
+		return act;
+	case XDP_REDIRECT:
+		err = xdp_do_redirect(rq->adapter->netdev, xdp, prog);
+		if (!err)
+			rq->stats.xdp_redirects++;
+		else
+			rq->stats.xdp_drops++;
+		return act;
+	case XDP_TX:
+		xdpf = xdp_convert_buff_to_frame(xdp);
+		if (!xdpf || vmxnet3_xdp_xmit_back(rq->adapter, xdpf)) {
+			rq->stats.xdp_drops++;
+			page_pool_recycle_direct(rq->page_pool,
+				 virt_to_head_page(xdp->data_hard_start));
+		} else {
+			rq->stats.xdp_tx++;
+		}
+		return act;
+	default:
+		bpf_warn_invalid_xdp_action(rq->adapter->netdev, prog, act);
+		fallthrough;
+	case XDP_ABORTED:
+		trace_xdp_exception(rq->adapter->netdev, prog, act);
+		rq->stats.xdp_aborted++;
+		break;
+	case XDP_DROP:
+		rq->stats.xdp_drops++;
+		break;
+	}
+
+	page_pool_recycle_direct(rq->page_pool,
+				 virt_to_head_page(xdp->data_hard_start));
+	return act;
+}
+
+static struct sk_buff *
+vmxnet3_build_skb(struct vmxnet3_rx_queue *rq, struct page *page,
+		  const struct xdp_buff *xdp)
+{
+	struct sk_buff *skb;
+
+	skb = build_skb(page_address(page), PAGE_SIZE);
+	if (unlikely(!skb)) {
+		page_pool_recycle_direct(rq->page_pool, page);
+		rq->stats.rx_buf_alloc_failure++;
+		return NULL;
+	}
+
+	/* bpf prog might change len and data position. */
+	skb_reserve(skb, xdp->data - xdp->data_hard_start);
+	skb_put(skb, xdp->data_end - xdp->data);
+	skb_mark_for_recycle(skb);
+
+	return skb;
+}
+
+/* Handle packets from DataRing. */
+int
+vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
+			  struct vmxnet3_rx_queue *rq,
+			  void *data, int len,
+			  struct sk_buff **skb_xdp_pass)
+{
+	struct bpf_prog *xdp_prog;
+	struct xdp_buff xdp;
+	struct page *page;
+	int act;
+
+	page = page_pool_alloc_pages(rq->page_pool, GFP_ATOMIC);
+	if (!page) {
+		rq->stats.rx_buf_alloc_failure++;
+		return XDP_DROP;
+	}
+
+	xdp_init_buff(&xdp, PAGE_SIZE, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
+			 len, false);
+	xdp_buff_clear_frags_flag(&xdp);
+
+	/* Must copy the data because it's at dataring. */
+	memcpy(xdp.data, data, len);
+
+	rcu_read_lock();
+	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		page_pool_recycle_direct(rq->page_pool, page);
+		act = XDP_PASS;
+		goto out_skb;
+	}
+	act = vmxnet3_run_xdp(rq, &xdp);
+	rcu_read_unlock();
+
+out_skb:
+	if (act == XDP_PASS) {
+		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
+		if (!skb_xdp_pass)
+			return XDP_DROP;
+	}
+
+	/* No need to refill. */
+	return act;
+}
+
+int
+vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
+		    struct vmxnet3_rx_queue *rq,
+		    struct Vmxnet3_RxCompDesc *rcd,
+		    struct vmxnet3_rx_buf_info *rbi,
+		    struct Vmxnet3_RxDesc *rxd,
+		    struct sk_buff **skb_xdp_pass)
+{
+	struct bpf_prog *xdp_prog;
+	dma_addr_t new_dma_addr;
+	struct xdp_buff xdp;
+	struct page *page;
+	void *new_data;
+	int act;
+
+	page = rbi->pp_page;
+	dma_sync_single_for_cpu(&adapter->pdev->dev,
+				page_pool_get_dma_addr(page) +
+				XDP_PACKET_HEADROOM, rcd->len,
+				page_pool_get_dma_dir(rq->page_pool));
+
+	xdp_init_buff(&xdp, rbi->len, &rq->xdp_rxq);
+	xdp_prepare_buff(&xdp, page_address(page), XDP_PACKET_HEADROOM,
+			 rcd->len, false);
+	xdp_buff_clear_frags_flag(&xdp);
+
+	rcu_read_lock();
+	xdp_prog = rcu_dereference(rq->adapter->xdp_bpf_prog);
+	if (!xdp_prog) {
+		rcu_read_unlock();
+		act = XDP_PASS;
+		goto refill;
+	}
+	act = vmxnet3_run_xdp(rq, &xdp);
+	rcu_read_unlock();
+
+	if (act == XDP_PASS) {
+		*skb_xdp_pass = vmxnet3_build_skb(rq, page, &xdp);
+		if (!skb_xdp_pass)
+			act = XDP_DROP;
+	}
+
+refill:
+	new_data = vmxnet3_pp_get_buff(rq->page_pool, &new_dma_addr,
+				       GFP_ATOMIC);
+	if (!new_data) {
+		rq->stats.rx_buf_alloc_failure++;
+		return XDP_DROP;
+	}
+	rbi->pp_page = virt_to_head_page(new_data);
+	rbi->dma_addr = new_dma_addr;
+	rxd->addr = cpu_to_le64(rbi->dma_addr);
+	rxd->len = rbi->len;
+
+	return act;
+}
diff --git a/drivers/net/vmxnet3/vmxnet3_xdp.h b/drivers/net/vmxnet3/vmxnet3_xdp.h
new file mode 100644
index 000000000000..c182f811cf5f
--- /dev/null
+++ b/drivers/net/vmxnet3/vmxnet3_xdp.h
@@ -0,0 +1,41 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later
+ *
+ * Linux driver for VMware's vmxnet3 ethernet NIC.
+ * Copyright (C) 2008-2023, VMware, Inc. All Rights Reserved.
+ * Maintained by: pv-drivers@vmware.com
+ *
+ */
+
+#ifndef _VMXNET3_XDP_H
+#define _VMXNET3_XDP_H
+
+#include <linux/filter.h>
+#include <linux/bpf_trace.h>
+#include <linux/netlink.h>
+#include <net/page_pool.h>
+#include <net/xdp.h>
+
+#include "vmxnet3_int.h"
+
+#define VMXNET3_XDP_PAD (SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
+			 XDP_PACKET_HEADROOM)
+#define VMXNET3_XDP_MAX_MTU (PAGE_SIZE - VMXNET3_XDP_PAD)
+
+int vmxnet3_xdp(struct net_device *netdev, struct netdev_bpf *bpf);
+bool vmxnet3_xdp_enabled(struct vmxnet3_adapter *adapter);
+int vmxnet3_xdp_headroom(struct vmxnet3_adapter *adapter);
+int vmxnet3_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **frames,
+		     u32 flags);
+int vmxnet3_process_xdp(struct vmxnet3_adapter *adapter,
+			struct vmxnet3_rx_queue *rq,
+			struct Vmxnet3_RxCompDesc *rcd,
+			struct vmxnet3_rx_buf_info *rbi,
+			struct Vmxnet3_RxDesc *rxd,
+			struct sk_buff **skb_xdp_pass);
+int vmxnet3_process_xdp_small(struct vmxnet3_adapter *adapter,
+			      struct vmxnet3_rx_queue *rq,
+			      void *data, int len,
+			      struct sk_buff **skb_xdp_pass);
+void *vmxnet3_pp_get_buff(struct page_pool *pp, dma_addr_t *dma_addr,
+			  gfp_t gfp_mask);
+#endif
-- 
2.25.1

