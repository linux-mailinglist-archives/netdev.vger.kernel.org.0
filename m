Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD68C2CF7
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 07:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731358AbfJAFjC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 01:39:02 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:45247 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfJAFjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 01:39:02 -0400
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x915cjZf009329;
        Mon, 30 Sep 2019 22:38:46 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, indranil@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>,
        Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net] cxgb4: fix out-of-bounds MSI-X info array access
Date:   Tue,  1 Oct 2019 04:07:57 +0530
Message-Id: <1569883077-15909-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When fetching free MSI-X vectors for ULDs, check for the
error code before accessing MSI-X info array. Otherwise,
an out-of-bounds access is attempted, which results in
kernel panic.

Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of
resources for ULD")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 5b60224..399e579 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -137,13 +137,12 @@ static int uldrx_handler(struct sge_rspq *q, const __be64 *rsp,
 static int alloc_uld_rxqs(struct adapter *adap,
 			  struct sge_uld_rxq_info *rxq_info, bool lro)
 {
-	struct sge *s = &adap->sge;
 	unsigned int nq = rxq_info->nrxq + rxq_info->nciq;
+	int i, err, bmap_idx, msi_idx, que_idx = 0;
 	struct sge_ofld_rxq *q = rxq_info->uldrxq;
 	unsigned short *ids = rxq_info->rspq_id;
-	unsigned int bmap_idx = 0;
+	struct sge *s = &adap->sge;
 	unsigned int per_chan;
-	int i, err, msi_idx, que_idx = 0;
 
 	per_chan = rxq_info->nrxq / adap->params.nports;
 
@@ -161,6 +160,10 @@ static int alloc_uld_rxqs(struct adapter *adap,
 
 		if (msi_idx >= 0) {
 			bmap_idx = get_msix_idx_from_bmap(adap);
+			if (bmap_idx < 0) {
+				err = -ENOSPC;
+				goto freeout;
+			}
 			msi_idx = adap->msix_info_ulds[bmap_idx].idx;
 		}
 		err = t4_sge_alloc_rxq(adap, &q->rspq, false,
-- 
1.8.3.1

