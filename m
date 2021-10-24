Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F0E6438C66
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 00:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231733AbhJXWhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 18:37:36 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52011 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231840AbhJXWhb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 18:37:31 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id AD08D5C049C;
        Sun, 24 Oct 2021 02:41:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 24 Oct 2021 02:41:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=KU1wrUEWrB7Dk9gp4
        yE8KimKwjnsqXFYKvrk+twmNsY=; b=TeBrAxnSIH1pHCuw4AVSfDY8uaYqhBRx2
        uFU4C6qWjkdPE8Fw6OKLcggpVYHBkgNT8lYvfCp0I7oCaww3SKC0quPc8j7fuQrn
        /gvLWrHDsBdlMLu0dT+8g4NEjaSxKyTPXSpQFlceArDXVKwEg4tAPBbZ6JUx625m
        jVh8W1o/CsSalYxENRsOffshboDkwuHvVBghNXXH/NKf/mGmnRGz8Xm0fpaBjVLG
        tZB6iTZMc77tfvGY9LSAQo4+Uk4vYXKdOIxQTRVxNoZUpOSi94OtzQM9VOEMzeBr
        2gQ+VFlKk9eWYNAjoQZycTmCC6mGa2tvOkYWIkq5SlUijUh1oyCHQ==
X-ME-Sender: <xms:BAB1YaGz6_4SQCRxm4Hb7Y2zJqvzGOklTa92XZ6ZZbNg_C5VUTVVTA>
    <xme:BAB1YbU9IMwOjzHo6RNBoAKzQser_X_ViFnUdwLQyNOn5V7YDDGPflwwQyNeSszJE
    aOeNCrpt-JKFMk>
X-ME-Received: <xmr:BAB1YUI8Z7F-w4q2bAz55f71lmiJW7NHvXeLde42yNWIaRi1y8h-zbi0p-Ni_DSQmr_gY_4dIccM978a5rnHnL4cuNu12HM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefvddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiughoshgt
    hhdrohhrgheqnecuggftrfgrthhtvghrnhepteevgefhvefggfffkeeuffeuvdfhueehhe
    etffeikeegheevfedvgeelvdffudfhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:BAB1YUFg01ajTCWS2pNnawIov_T9zNeT32iEV4rt77GRbqoRKQoKhA>
    <xmx:BAB1YQUmqjb3vsu4XfmvwCIdkTA1zzI3MieyddBOux-I6frf37DjEg>
    <xmx:BAB1YXNKHQj1pfk9jk8VqmRL25291bZFMyXBZYZZu1t7K0CFhpWDcQ>
    <xmx:BAB1YeyXKkyNWecXiX76KXtswsHLk3ggFAjdDhvqlg1M9sE_QwvIpQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 24 Oct 2021 02:41:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] mlxsw: pci: Recycle received packet upon allocation failure
Date:   Sun, 24 Oct 2021 09:40:14 +0300
Message-Id: <20211024064014.1060919-1-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When the driver fails to allocate a new Rx buffer, it passes an empty Rx
descriptor (contains zero address and size) to the device and marks it
as invalid by setting the skb pointer in the descriptor's metadata to
NULL.

After processing enough Rx descriptors, the driver will try to process
the invalid descriptor, but will return immediately seeing that the skb
pointer is NULL. Since the driver no longer passes new Rx descriptors to
the device, the Rx queue will eventually become full and the device will
start to drop packets.

Fix this by recycling the received packet if allocation of the new
packet failed. This means that allocation is no longer performed at the
end of the Rx routine, but at the start, before tearing down the DMA
mapping of the received packet.

Remove the comment about the descriptor being zeroed as it is no longer
correct. This is OK because we either use the descriptor as-is (when
recycling) or overwrite its address and size fields with that of the
newly allocated Rx buffer.

The issue was discovered when a process ("perf") consumed too much
memory and put the system under memory pressure. It can be reproduced by
injecting slab allocation failures [1]. After the fix, the Rx queue no
longer comes to a halt.

[1]
 # echo 10 > /sys/kernel/debug/failslab/times
 # echo 1000 > /sys/kernel/debug/failslab/interval
 # echo 100 > /sys/kernel/debug/failslab/probability

 FAULT_INJECTION: forcing a failure.
 name failslab, interval 1000, probability 100, space 0, times 8
 [...]
 Call Trace:
  <IRQ>
  dump_stack_lvl+0x34/0x44
  should_fail.cold+0x32/0x37
  should_failslab+0x5/0x10
  kmem_cache_alloc_node+0x23/0x190
  __alloc_skb+0x1f9/0x280
  __netdev_alloc_skb+0x3a/0x150
  mlxsw_pci_rdq_skb_alloc+0x24/0x90
  mlxsw_pci_cq_tasklet+0x3dc/0x1200
  tasklet_action_common.constprop.0+0x9f/0x100
  __do_softirq+0xb5/0x252
  irq_exit_rcu+0x7a/0xa0
  common_interrupt+0x83/0xa0
  </IRQ>
  asm_common_interrupt+0x1e/0x40
 RIP: 0010:cpuidle_enter_state+0xc8/0x340
 [...]
 mlxsw_spectrum2 0000:06:00.0: Failed to alloc skb for RDQ

Fixes: eda6500a987a ("mlxsw: Add PCI bus implementation")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/pci.c | 25 +++++++++++------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index 13b0259f7ea6..fcace73eae40 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -353,13 +353,10 @@ static int mlxsw_pci_rdq_skb_alloc(struct mlxsw_pci *mlxsw_pci,
 	struct sk_buff *skb;
 	int err;
 
-	elem_info->u.rdq.skb = NULL;
 	skb = netdev_alloc_skb_ip_align(NULL, buf_len);
 	if (!skb)
 		return -ENOMEM;
 
-	/* Assume that wqe was previously zeroed. */
-
 	err = mlxsw_pci_wqe_frag_map(mlxsw_pci, wqe, 0, skb->data,
 				     buf_len, DMA_FROM_DEVICE);
 	if (err)
@@ -597,21 +594,26 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 	struct pci_dev *pdev = mlxsw_pci->pdev;
 	struct mlxsw_pci_queue_elem_info *elem_info;
 	struct mlxsw_rx_info rx_info = {};
-	char *wqe;
+	char wqe[MLXSW_PCI_WQE_SIZE];
 	struct sk_buff *skb;
 	u16 byte_count;
 	int err;
 
 	elem_info = mlxsw_pci_queue_elem_info_consumer_get(q);
-	skb = elem_info->u.sdq.skb;
-	if (!skb)
-		return;
-	wqe = elem_info->elem;
-	mlxsw_pci_wqe_frag_unmap(mlxsw_pci, wqe, 0, DMA_FROM_DEVICE);
+	skb = elem_info->u.rdq.skb;
+	memcpy(wqe, elem_info->elem, MLXSW_PCI_WQE_SIZE);
 
 	if (q->consumer_counter++ != consumer_counter_limit)
 		dev_dbg_ratelimited(&pdev->dev, "Consumer counter does not match limit in RDQ\n");
 
+	err = mlxsw_pci_rdq_skb_alloc(mlxsw_pci, elem_info);
+	if (err) {
+		dev_err_ratelimited(&pdev->dev, "Failed to alloc skb for RDQ\n");
+		goto out;
+	}
+
+	mlxsw_pci_wqe_frag_unmap(mlxsw_pci, wqe, 0, DMA_FROM_DEVICE);
+
 	if (mlxsw_pci_cqe_lag_get(cqe_v, cqe)) {
 		rx_info.is_lag = true;
 		rx_info.u.lag_id = mlxsw_pci_cqe_lag_id_get(cqe_v, cqe);
@@ -647,10 +649,7 @@ static void mlxsw_pci_cqe_rdq_handle(struct mlxsw_pci *mlxsw_pci,
 	skb_put(skb, byte_count);
 	mlxsw_core_skb_receive(mlxsw_pci->core, skb, &rx_info);
 
-	memset(wqe, 0, q->elem_size);
-	err = mlxsw_pci_rdq_skb_alloc(mlxsw_pci, elem_info);
-	if (err)
-		dev_dbg_ratelimited(&pdev->dev, "Failed to alloc skb for RDQ\n");
+out:
 	/* Everything is set up, ring doorbell to pass elem to HW */
 	q->producer_counter++;
 	mlxsw_pci_queue_doorbell_producer_ring(mlxsw_pci, q);
-- 
2.31.1

