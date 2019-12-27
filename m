Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFC0012B6CD
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 18:45:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728716AbfL0RpP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Dec 2019 12:45:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728703AbfL0RpN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Dec 2019 12:45:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD23A24654;
        Fri, 27 Dec 2019 17:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468712;
        bh=bwX9MQGqz4h2Vatpd3JQoK5wQ8WUS1FdeURgY28UWGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QSr9nxVBHtnJOzceesMdsUS/TQ0TiHM4uymMPDyYT6U8YMUsp7WIfz10+aTKfxTD8
         3QoLQEvcC2a8ZAW4Qy8vjuEkS4Lf1c7Del9NSfu5vnWL5g6Mr1JooOVqWRBr9KC131
         q0gtkJzVeRNFuHeM6jLn1Kwv9GnaIRqcSs+s+mTA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Hutchings <ben@decadent.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 67/84] net: qlogic: Fix error paths in ql_alloc_large_buffers()
Date:   Fri, 27 Dec 2019 12:43:35 -0500
Message-Id: <20191227174352.6264-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>

[ Upstream commit cad46039e4c99812db067c8ac22a864960e7acc4 ]

ql_alloc_large_buffers() has the usual RX buffer allocation
loop where it allocates skbs and maps them for DMA.  It also
treats failure as a fatal error.

There are (at least) three bugs in the error paths:

1. ql_free_large_buffers() assumes that the lrg_buf[] entry for the
first buffer that couldn't be allocated will have .skb == NULL.
But the qla_buf[] array is not zero-initialised.

2. ql_free_large_buffers() DMA-unmaps all skbs in lrg_buf[].  This is
incorrect for the last allocated skb, if DMA mapping failed.

3. Commit 1acb8f2a7a9f ("net: qlogic: Fix memory leak in
ql_alloc_large_buffers") added a direct call to dev_kfree_skb_any()
after the skb is recorded in lrg_buf[], so ql_free_large_buffers()
will double-free it.

The bugs are somewhat inter-twined, so fix them all at once:

* Clear each entry in qla_buf[] before attempting to allocate
  an skb for it.  This goes half-way to fixing bug 1.
* Set the .skb field only after the skb is DMA-mapped.  This
  fixes the rest.

Fixes: 1357bfcf7106 ("qla3xxx: Dynamically size the rx buffer queue ...")
Fixes: 0f8ab89e825f ("qla3xxx: Check return code from pci_map_single() ...")
Fixes: 1acb8f2a7a9f ("net: qlogic: Fix memory leak in ql_alloc_large_buffers")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 783ee6a32b5d..1b5e098b2367 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2757,6 +2757,9 @@ static int ql_alloc_large_buffers(struct ql3_adapter *qdev)
 	int err;
 
 	for (i = 0; i < qdev->num_large_buffers; i++) {
+		lrg_buf_cb = &qdev->lrg_buf[i];
+		memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
+
 		skb = netdev_alloc_skb(qdev->ndev,
 				       qdev->lrg_buffer_len);
 		if (unlikely(!skb)) {
@@ -2767,11 +2770,7 @@ static int ql_alloc_large_buffers(struct ql3_adapter *qdev)
 			ql_free_large_buffers(qdev);
 			return -ENOMEM;
 		} else {
-
-			lrg_buf_cb = &qdev->lrg_buf[i];
-			memset(lrg_buf_cb, 0, sizeof(struct ql_rcv_buf_cb));
 			lrg_buf_cb->index = i;
-			lrg_buf_cb->skb = skb;
 			/*
 			 * We save some space to copy the ethhdr from first
 			 * buffer
@@ -2793,6 +2792,7 @@ static int ql_alloc_large_buffers(struct ql3_adapter *qdev)
 				return -ENOMEM;
 			}
 
+			lrg_buf_cb->skb = skb;
 			dma_unmap_addr_set(lrg_buf_cb, mapaddr, map);
 			dma_unmap_len_set(lrg_buf_cb, maplen,
 					  qdev->lrg_buffer_len -
-- 
2.20.1

