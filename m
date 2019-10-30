Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8005EA5AF
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727213AbfJ3VtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:49:10 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:51018 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727099AbfJ3VtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:49:09 -0400
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id x9ULn3B0024886;
        Wed, 30 Oct 2019 14:49:04 -0700
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>,
        Shahjada Abul Husain <shahjada@chelsio.com>
Subject: [PATCH net v2] cxgb4: fix panic when attaching to ULD fail
Date:   Wed, 30 Oct 2019 20:17:57 +0530
Message-Id: <1572446877-29202-1-git-send-email-vishal@chelsio.com>
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
v2:
- Added txq release if ULD fails to attach
- Changed comment of cxgb4_register_uld into correct format
v1:
- Added the ULD attach check
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c | 28 +++++++++++++++-----------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
index a4dead4..86b528d 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.c
@@ -695,10 +695,10 @@ static void uld_init(struct adapter *adap, struct cxgb4_lld_info *lld)
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
@@ -708,7 +708,7 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
 		dev_warn(adap->pdev_dev,
 			 "could not attach to the %s driver, error %ld\n",
 			 adap->uld[uld].name, PTR_ERR(handle));
-		return;
+		return PTR_ERR(handle);
 	}
 
 	adap->uld[uld].handle = handle;
@@ -716,22 +716,22 @@ static void uld_attach(struct adapter *adap, unsigned int uld)
 
 	if (adap->flags & CXGB4_FULL_INIT_DONE)
 		adap->uld[uld].state_change(handle, CXGB4_STATE_UP);
+
+	return 0;
 }
 
-/**
- *	cxgb4_register_uld - register an upper-layer driver
- *	@type: the ULD type
- *	@p: the ULD methods
+/* cxgb4_register_uld - register an upper-layer driver
+ * @type: the ULD type
+ * @p: the ULD methods
  *
- *	Registers an upper-layer driver with this driver and notifies the ULD
- *	about any presently available devices that support its type.  Returns
- *	%-EBUSY if a ULD of the same type is already registered.
+ * Registers an upper-layer driver with this driver and notifies the ULD
+ * about any presently available devices that support its type.
  */
 void cxgb4_register_uld(enum cxgb4_uld type,
 			const struct cxgb4_uld_info *p)
 {
-	int ret = 0;
 	struct adapter *adap;
+	int ret = 0;
 
 	if (type >= CXGB4_ULD_MAX)
 		return;
@@ -763,8 +763,12 @@ void cxgb4_register_uld(enum cxgb4_uld type,
 		if (ret)
 			goto free_irq;
 		adap->uld[type] = *p;
-		uld_attach(adap, type);
+		ret = uld_attach(adap, type);
+		if (ret)
+			goto free_txq;
 		continue;
+free_txq:
+		release_sge_txq_uld(adap, type);
 free_irq:
 		if (adap->flags & CXGB4_FULL_INIT_DONE)
 			quiesce_rx_uld(adap, type);
-- 
1.8.3.1

