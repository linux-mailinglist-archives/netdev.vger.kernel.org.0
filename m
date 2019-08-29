Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66DC1A234B
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728982AbfH2SOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:14:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:56352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbfH2SOn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:14:43 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 860152339E;
        Thu, 29 Aug 2019 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102483;
        bh=G/rydemY/se9oRI2oc9ftz0a3FwIJOnjndeX+QAiB20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gOCbRoOsMZEqosza4vZyH+k1uR4tVJF0Wz5YCD3fYYJ66giH9WGCRK5mojF6iOLXC
         AlVAvd1AzfZQ7wkJPIf98YZOFK2U7oR+aqDSO9qpAfdb0KPfySx9Nwg0mLa35tY8gE
         NKCmF6sDYyj4c6rBNoIgmbsd9pn1RR3gXaa+q03A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        "Devesh K . Singh" <devesh_singh@in.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 43/76] ibmvnic: Unmap DMA address of TX descriptor buffers after use
Date:   Thu, 29 Aug 2019 14:12:38 -0400
Message-Id: <20190829181311.7562-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181311.7562-1-sashal@kernel.org>
References: <20190829181311.7562-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 80f0fe0934cd3daa13a5e4d48a103f469115b160 ]

There's no need to wait until a completion is received to unmap
TX descriptor buffers that have been passed to the hypervisor.
Instead unmap it when the hypervisor call has completed. This patch
avoids the possibility that a buffer will not be unmapped because
a TX completion is lost or mishandled.

Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Tested-by: Devesh K. Singh <devesh_singh@in.ibm.com>
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
index 3da6800732656..cebd20f3128d4 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1568,6 +1568,8 @@ static netdev_tx_t ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		lpar_rc = send_subcrq_indirect(adapter, handle_array[queue_num],
 					       (u64)tx_buff->indir_dma,
 					       (u64)num_entries);
+		dma_unmap_single(dev, tx_buff->indir_dma,
+				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
 	} else {
 		tx_buff->num_entries = num_entries;
 		lpar_rc = send_subcrq(adapter, handle_array[queue_num],
@@ -2788,7 +2790,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	union sub_crq *next;
 	int index;
 	int i, j;
-	u8 *first;
 
 restart_loop:
 	while (pending_scrq(adapter, scrq)) {
@@ -2818,14 +2819,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 
 				txbuff->data_dma[j] = 0;
 			}
-			/* if sub_crq was sent indirectly */
-			first = &txbuff->indir_arr[0].generic.first;
-			if (*first == IBMVNIC_CRQ_CMD) {
-				dma_unmap_single(dev, txbuff->indir_dma,
-						 sizeof(txbuff->indir_arr),
-						 DMA_TO_DEVICE);
-				*first = 0;
-			}
 
 			if (txbuff->last_frag) {
 				dev_kfree_skb_any(txbuff->skb);
-- 
2.20.1

