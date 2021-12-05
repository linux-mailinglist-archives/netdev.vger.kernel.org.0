Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA501468B8B
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 15:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhLEPAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 10:00:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:20600 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235114AbhLEPAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 10:00:47 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="237132505"
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="237132505"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2021 06:57:20 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,289,1631602800"; 
   d="scan'208";a="514507324"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 05 Dec 2021 06:57:17 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH V2 net-next 6/7] net: wwan: iosm: AT port is not working while MBIM TX is ongoing
Date:   Sun,  5 Dec 2021 20:34:54 +0530
Message-Id: <20211205150455.1829929-7-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
References: <20211205150455.1829929-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ev_cdev_write_pending flag is preventing a TX message post for
AT port while MBIM transfer is ongoing.

Removed the unnecessary check around control port TX transfer.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
v2: No Change.
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 1 -
 drivers/net/wwan/iosm/iosm_ipc_imem.h     | 3 ---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 6 ------
 3 files changed, 10 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 96dcd2445bce..b947f548983a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -1282,7 +1282,6 @@ struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,

 	ipc_imem->pci_device_id = device_id;

-	ipc_imem->ev_cdev_write_pending = false;
 	ipc_imem->cp_version = 0;
 	ipc_imem->device_sleep = IPC_HOST_SLEEP_ENTER_SLEEP;

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index d220f2611621..a8ec896f217b 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -337,8 +337,6 @@ enum ipc_phase {
  *				process the irq actions.
  * @flag:			Flag to monitor the state of driver
  * @td_update_timer_suspended:	if true then td update timer suspend
- * @ev_cdev_write_pending:	0 means inform the IPC tasklet to pass
- *				the accumulated uplink buffers to CP.
  * @ev_mux_net_transmit_pending:0 means inform the IPC tasklet to pass
  * @reset_det_n:		Reset detect flag
  * @pcie_wake_n:		Pcie wake flag
@@ -377,7 +375,6 @@ struct iosm_imem {
 	u8 ev_irq_pending[IPC_IRQ_VECTORS];
 	unsigned long flag;
 	u8 td_update_timer_suspended:1,
-	   ev_cdev_write_pending:1,
 	   ev_mux_net_transmit_pending:1,
 	   reset_det_n:1,
 	   pcie_wake_n:1;
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 0757fd915437..28dfd4468760 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -42,7 +42,6 @@ void ipc_imem_sys_wwan_close(struct iosm_imem *ipc_imem, int if_id,
 static int ipc_imem_tq_cdev_write(struct iosm_imem *ipc_imem, int arg,
 				  void *msg, size_t size)
 {
-	ipc_imem->ev_cdev_write_pending = false;
 	ipc_imem_ul_send(ipc_imem);

 	return 0;
@@ -51,11 +50,6 @@ static int ipc_imem_tq_cdev_write(struct iosm_imem *ipc_imem, int arg,
 /* Through tasklet to do sio write. */
 static int ipc_imem_call_cdev_write(struct iosm_imem *ipc_imem)
 {
-	if (ipc_imem->ev_cdev_write_pending)
-		return -1;
-
-	ipc_imem->ev_cdev_write_pending = true;
-
 	return ipc_task_queue_send_task(ipc_imem, ipc_imem_tq_cdev_write, 0,
 					NULL, 0, false);
 }
--
2.25.1

