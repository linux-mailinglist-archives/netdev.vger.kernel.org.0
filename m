Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB473D6595
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 16:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732944AbfJNOum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 10:50:42 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:13252 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732772AbfJNOum (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 10:50:42 -0400
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x9EEoY9B022083;
        Mon, 14 Oct 2019 07:50:35 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, Vishal Kulkarni <vishal@chelsio.com>,
        Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net] cxgb4: Fix panic when attaching to ULD fails
Date:   Mon, 14 Oct 2019 13:20:35 +0530
Message-Id: <1571039435-22495-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Release resources when attaching to ULD fail. Otherwise, data
mismatch is seen between LLD and ULD later on, which lead to
kernel panic when accessing resources that should not even
exist in the first place.

Fixes: 94cdb8bb993a ("cxgb4: Add support for dynamic allocation of resources for ULD")
Signed-off-by: Shahjada Abul Husain <shahjada@chelsio.com>
Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index 5b60224..0482ef8 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -692,10 +692,10 @@ static void uld_init(struct adapter *adap, struct cxgb4_lld_info *lld)
 	lld->write_cmpl_support = adap->params.write_cmpl_support;
 }
 
-static void uld_attach(struct adapter *adap, unsigned int uld)
+static int uld_attach(struct adapter *adap, unsigned int uld)
 {
-	void *handle;
 	struct cxgb4_lld_info lli;
+	void *handle;
 
 	uld_init(adap, &lli);
 	uld_queue_init(adap, uld, &lli);
@@ -705,7 +705,7 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
 		dev_warn(adap->pdev_dev,
 			 "could not attach to the %s driver, error %ld\n",
 			 adap->uld[uld].name, PTR_ERR(handle));
-		return;
+		return PTR_ERR(handle);
 	}
 
 	adap->uld[uld].handle = handle;
@@ -713,6 +713,8 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
 
 	if (adap->flags & CXGB4_FULL_INIT_DONE)
 		adap->uld[uld].state_change(handle, CXGB4_STATE_UP);
+
+	return 0;
 }
 
 /**
@@ -727,8 +729,8 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
 void cxgb4_register_uld(enum cxgb4_uld type,
 			const struct cxgb4_uld_info *p)
 {
-	int ret = 0;
 	struct adapter *adap;
+	int ret = 0;
 
 	if (type >= CXGB4_ULD_MAX)
 		return;
@@ -760,7 +762,9 @@ void cxgb4_register_uld(enum cxgb4_uld type,
 		if (ret)
 			goto free_irq;
 		adap->uld[type] = *p;
-		uld_attach(adap, type);
+		ret = uld_attach(adap, type);
+		if (ret)
+			goto free_irq;
 		continue;
 free_irq:
 		if (adap->flags & CXGB4_FULL_INIT_DONE)
-- 
1.8.3.1

