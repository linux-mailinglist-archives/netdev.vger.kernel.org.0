Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D726EFE39
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 14:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389003AbfKENTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 08:19:30 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:52082 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388782AbfKENT3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 08:19:29 -0500
Received: from dalmore.blr.asicdesigners.com ([10.193.186.161])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xA5DJFQr007785;
        Tue, 5 Nov 2019 05:19:16 -0800
From:   Vishal Kulkarni <vishal@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Vishal Kulkarni <vishal@chelsio.com>
Subject: [PATCH net-next] cxgb4: Add pci reset handler
Date:   Tue,  5 Nov 2019 11:49:15 +0530
Message-Id: <1572934755-21576-1-git-send-email-vishal@chelsio.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch implements reset_prepare and reset_done, which are used
for handling FLR.

Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c | 105 ++++++++++++++++++++++--
 1 file changed, 96 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 3802487..33a923cf 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -184,6 +184,8 @@
 LIST_HEAD(adapter_list);
 DEFINE_MUTEX(uld_mutex);
 
+static int cfg_queues(struct adapter *adap);
+
 static void link_report(struct net_device *dev)
 {
 	if (!netif_carrier_ok(dev))
@@ -4286,14 +4288,14 @@ static struct fw_info *find_fw_info(int chip)
 /*
  * Phase 0 of initialization: contact FW, obtain config, perform basic init.
  */
-static int adap_init0(struct adapter *adap)
+static int adap_init0(struct adapter *adap, int vpd_skip)
 {
-	int ret;
-	u32 v, port_vec;
-	enum dev_state state;
-	u32 params[7], val[7];
 	struct fw_caps_config_cmd caps_cmd;
+	u32 params[7], val[7];
+	enum dev_state state;
+	u32 v, port_vec;
 	int reset = 1;
+	int ret;
 
 	/* Grab Firmware Device Log parameters as early as possible so we have
 	 * access to it for debugging, etc.
@@ -4448,9 +4450,11 @@ static int adap_init0(struct adapter *adap)
 	 * could have FLASHed a new VPD which won't be read by the firmware
 	 * until we do the RESET ...
 	 */
-	ret = t4_get_vpd_params(adap, &adap->params.vpd);
-	if (ret < 0)
-		goto bye;
+	if (!vpd_skip) {
+		ret = t4_get_vpd_params(adap, &adap->params.vpd);
+		if (ret < 0)
+			goto bye;
+	}
 
 	/* Find out what ports are available to us.  Note that we need to do
 	 * this before calling adap_init0_no_config() since it needs nports
@@ -5050,10 +5054,93 @@ static void eeh_resume(struct pci_dev *pdev)
 	rtnl_unlock();
 }
 
+static void eeh_reset_prepare(struct pci_dev *pdev)
+{
+	struct adapter *adapter = pci_get_drvdata(pdev);
+	int i;
+
+	if (adapter->pf != 4)
+		return;
+
+	adapter->flags &= ~CXGB4_FW_OK;
+
+	notify_ulds(adapter, CXGB4_STATE_DOWN);
+
+	for_each_port(adapter, i)
+		if (adapter->port[i]->reg_state == NETREG_REGISTERED)
+			cxgb_close(adapter->port[i]);
+
+	disable_interrupts(adapter);
+	cxgb4_free_mps_ref_entries(adapter);
+
+	adap_free_hma_mem(adapter);
+
+	if (adapter->flags & CXGB4_FULL_INIT_DONE)
+		cxgb_down(adapter);
+}
+
+static void eeh_reset_done(struct pci_dev *pdev)
+{
+	struct adapter *adapter = pci_get_drvdata(pdev);
+	int err, i;
+
+	if (adapter->pf != 4)
+		return;
+
+	err = t4_wait_dev_ready(adapter->regs);
+	if (err < 0) {
+		dev_err(adapter->pdev_dev,
+			"Device not ready, err %d", err);
+		return;
+	}
+
+	setup_memwin(adapter);
+
+	err = adap_init0(adapter, 1);
+	if (err) {
+		dev_err(adapter->pdev_dev,
+			"Adapter init failed, err %d", err);
+		return;
+	}
+
+	setup_memwin_rdma(adapter);
+
+	if (adapter->flags & CXGB4_FW_OK) {
+		err = t4_port_init(adapter, adapter->pf, adapter->pf, 0);
+		if (err) {
+			dev_err(adapter->pdev_dev,
+				"Port init failed, err %d", err);
+			return;
+		}
+	}
+
+	err = cfg_queues(adapter);
+	if (err) {
+		dev_err(adapter->pdev_dev,
+			"Config queues failed, err %d", err);
+		return;
+	}
+
+	cxgb4_init_mps_ref_entries(adapter);
+
+	err = setup_fw_sge_queues(adapter);
+	if (err) {
+		dev_err(adapter->pdev_dev,
+			"FW sge queue allocation failed, err %d", err);
+		return;
+	}
+
+	for_each_port(adapter, i)
+		if (adapter->port[i]->reg_state == NETREG_REGISTERED)
+			cxgb_open(adapter->port[i]);
+}
+
 static const struct pci_error_handlers cxgb4_eeh = {
 	.error_detected = eeh_err_detected,
 	.slot_reset     = eeh_slot_reset,
 	.resume         = eeh_resume,
+	.reset_prepare  = eeh_reset_prepare,
+	.reset_done     = eeh_reset_done,
 };
 
 /* Return true if the Link Configuration supports "High Speeds" (those greater
@@ -5837,7 +5924,7 @@ static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	setup_memwin(adapter);
-	err = adap_init0(adapter);
+	err = adap_init0(adapter, 0);
 #ifdef CONFIG_DEBUG_FS
 	bitmap_zero(adapter->sge.blocked_fl, adapter->sge.egr_sz);
 #endif
-- 
1.8.3.1

