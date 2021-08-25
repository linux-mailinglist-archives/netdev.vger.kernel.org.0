Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2B93F7DBF
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 23:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbhHYVcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 17:32:21 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:26520 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhHYVcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 17:32:20 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 17PLVOdg031286;
        Wed, 25 Aug 2021 14:31:24 -0700
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, rajur@chelsio.com
Subject: [PATCH net] cxgb4: dont touch blocked freelist bitmap after free
Date:   Thu, 26 Aug 2021 02:59:42 +0530
Message-Id: <1629926982-6393-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adapter init fails, the blocked freelist bitmap is already freed
up and should not be touched. So, move the bitmap zeroing closer to
where it was successfully allocated. Also handle adapter init failure
unwind path immediately and avoid setting up RDMA memory windows.

Fixes: 5b377d114f2b ("cxgb4: Add debugfs facility to inject FL starvation")
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index dbf9a0e6601d..710cb00ce3a3 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -5068,6 +5068,7 @@ static int adap_init0(struct adapter *adap, int vpd_skip)
 		ret = -ENOMEM;
 		goto bye;
 	}
+	bitmap_zero(adap->sge.blocked_fl, adap->sge.egr_sz);
 #endif
 
 	params[0] = FW_PARAM_PFVF(CLIP_START);
@@ -6788,13 +6789,11 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	setup_memwin(adapter);
 	err = adap_init0(adapter, 0);
-#ifdef CONFIG_DEBUG_FS
-	bitmap_zero(adapter->sge.blocked_fl, adapter->sge.egr_sz);
-#endif
-	setup_memwin_rdma(adapter);
 	if (err)
 		goto out_unmap_bar;
 
+	setup_memwin_rdma(adapter);
+
 	/* configure SGE_STAT_CFG_A to read WC stats */
 	if (!is_t4(adapter->params.chip))
 		t4_write_reg(adapter, SGE_STAT_CFG_A, STATSOURCE_T5_V(7) |
-- 
2.27.0

