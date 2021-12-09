Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 777FD46E64C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233004AbhLIKMU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:12:20 -0500
Received: from mga18.intel.com ([134.134.136.126]:6778 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232999AbhLIKMU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:12:20 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="224933569"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="224933569"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 02:08:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="516236623"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga008.jf.intel.com with ESMTP; 09 Dec 2021 02:08:44 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net 3/3] net: wwan: iosm: fixes unable to send AT command during mbim tx
Date:   Thu,  9 Dec 2021 15:46:29 +0530
Message-Id: <20211209101629.2940877-4-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
References: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
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
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 1 -
 drivers/net/wwan/iosm/iosm_ipc_imem.h     | 3 ---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 6 ------
 3 files changed, 10 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index e2c096863488..12c03dacb5dd 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -1270,7 +1270,6 @@ struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,
 
 	ipc_imem->pci_device_id = device_id;
 
-	ipc_imem->ev_cdev_write_pending = false;
 	ipc_imem->cp_version = 0;
 	ipc_imem->device_sleep = IPC_HOST_SLEEP_ENTER_SLEEP;
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 6b479fe23a42..6b8a837faef2 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -336,8 +336,6 @@ enum ipc_phase {
  *				process the irq actions.
  * @flag:			Flag to monitor the state of driver
  * @td_update_timer_suspended:	if true then td update timer suspend
- * @ev_cdev_write_pending:	0 means inform the IPC tasklet to pass
- *				the accumulated uplink buffers to CP.
  * @ev_mux_net_transmit_pending:0 means inform the IPC tasklet to pass
  * @reset_det_n:		Reset detect flag
  * @pcie_wake_n:		Pcie wake flag
@@ -375,7 +373,6 @@ struct iosm_imem {
 	u8 ev_irq_pending[IPC_IRQ_VECTORS];
 	unsigned long flag;
 	u8 td_update_timer_suspended:1,
-	   ev_cdev_write_pending:1,
 	   ev_mux_net_transmit_pending:1,
 	   reset_det_n:1,
 	   pcie_wake_n:1;
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 09261fbb79c1..831cdae28e8a 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -41,7 +41,6 @@ void ipc_imem_sys_wwan_close(struct iosm_imem *ipc_imem, int if_id,
 static int ipc_imem_tq_cdev_write(struct iosm_imem *ipc_imem, int arg,
 				  void *msg, size_t size)
 {
-	ipc_imem->ev_cdev_write_pending = false;
 	ipc_imem_ul_send(ipc_imem);
 
 	return 0;
@@ -50,11 +49,6 @@ static int ipc_imem_tq_cdev_write(struct iosm_imem *ipc_imem, int arg,
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

