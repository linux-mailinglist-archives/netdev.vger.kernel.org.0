Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905D91EBB53
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 14:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726485AbgFBMNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 08:13:07 -0400
Received: from mx57.baidu.com ([61.135.168.57]:43342 "EHLO
        tc-sys-mailedm05.tc.baidu.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725940AbgFBMNH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 08:13:07 -0400
Received: from localhost (cp01-cos-dev01.cp01.baidu.com [10.92.119.46])
        by tc-sys-mailedm05.tc.baidu.com (Postfix) with ESMTP id 008001EBA00D;
        Tue,  2 Jun 2020 20:12:54 +0800 (CST)
From:   Li RongQing <lirongqing@baidu.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH][v2] i40e: fix wrong index in i40e_xsk_umem_dma_map
Date:   Tue,  2 Jun 2020 20:12:53 +0800
Message-Id: <1591099973-3091-1-git-send-email-lirongqing@baidu.com>
X-Mailer: git-send-email 1.7.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dma should be unmapped in rollback path from
umem->pages[0].dma till umem->pages[i-1].dma which
is last dma map address

Fixes: 0a714186d3c0 "(i40e: add AF_XDP zero-copy Rx support)"
Signed-off-by: Li RongQing <lirongqing@baidu.com>
---
diff with v1: add description

 drivers/net/ethernet/intel/i40e/i40e_xsk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index 0b7d29192b2c..c926438118ea 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -37,9 +37,9 @@ static int i40e_xsk_umem_dma_map(struct i40e_vsi *vsi, struct xdp_umem *umem)
 
 out_unmap:
 	for (j = 0; j < i; j++) {
-		dma_unmap_page_attrs(dev, umem->pages[i].dma, PAGE_SIZE,
+		dma_unmap_page_attrs(dev, umem->pages[j].dma, PAGE_SIZE,
 				     DMA_BIDIRECTIONAL, I40E_RX_DMA_ATTR);
-		umem->pages[i].dma = 0;
+		umem->pages[j].dma = 0;
 	}
 
 	return -1;
-- 
2.16.2

