Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60911A249C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 20:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729758AbfH2SQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 14:16:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729741AbfH2SQY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 14:16:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80D80233FF;
        Thu, 29 Aug 2019 18:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567102583;
        bh=kpxGeaYPhUCPQgVAFxP07kUxK+mXZySJRP9I+uMrh8k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtEhSwZsMe3c/k2zOYrsZ5nSCcbFH5hMoomuoJmRBCxgv1tl+ORIP78Jl5E1q5GAI
         IJTwyJb/MUfJ4wGQpL0in448zfXrVF0DK9O+VfhnMAk92M9uV3r7uH2VsCo6mRKuET
         CCriI+h/IzUqMlF0t32cJaLzLd91syO1OZF5rIY0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        Abdul Haleem <abdhalee@linux.vnet.ibm.com>,
        "Devesh K . Singh" <devesh_singh@in.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 25/45] ibmvnic: Unmap DMA address of TX descriptor buffers after use
Date:   Thu, 29 Aug 2019 14:15:25 -0400
Message-Id: <20190829181547.8280-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
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
index 0ae43d27cdcff..255de7d68cd33 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.c
+++ b/drivers/net/ethernet/ibm/ibmvnic.c
@@ -1586,6 +1586,8 @@ static int ibmvnic_xmit(struct sk_buff *skb, struct net_device *netdev)
 		lpar_rc = send_subcrq_indirect(adapter, handle_array[queue_num],
 					       (u64)tx_buff->indir_dma,
 					       (u64)num_entries);
+		dma_unmap_single(dev, tx_buff->indir_dma,
+				 sizeof(tx_buff->indir_arr), DMA_TO_DEVICE);
 	} else {
 		tx_buff->num_entries = num_entries;
 		lpar_rc = send_subcrq(adapter, handle_array[queue_num],
@@ -2747,7 +2749,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 	union sub_crq *next;
 	int index;
 	int i, j;
-	u8 *first;
 
 restart_loop:
 	while (pending_scrq(adapter, scrq)) {
@@ -2777,14 +2778,6 @@ static int ibmvnic_complete_tx(struct ibmvnic_adapter *adapter,
 
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

