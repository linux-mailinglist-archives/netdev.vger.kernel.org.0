Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E47E46E64B
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 11:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232994AbhLIKMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 05:12:17 -0500
Received: from mga18.intel.com ([134.134.136.126]:6778 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232870AbhLIKMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 05:12:17 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10192"; a="224933563"
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="224933563"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2021 02:08:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,192,1635231600"; 
   d="scan'208";a="516236615"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by orsmga008.jf.intel.com with ESMTP; 09 Dec 2021 02:08:40 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net 2/3] net: wwan: iosm: fixes net interface nonfunctional after fw flash
Date:   Thu,  9 Dec 2021 15:46:28 +0530
Message-Id: <20211209101629.2940877-3-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
References: <20211209101629.2940877-1-m.chetan.kumar@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Devlink initialization flow was overwriting the IP traffic
channel configuration. This was causing wwan0 network interface
to be unusable after fw flash.

When device boots to fully functional mode restore the IP channel
configuration.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Reviewed-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 7 ++++++-
 drivers/net/wwan/iosm/iosm_ipc_imem.h     | 1 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index b4d47b31ba91..e2c096863488 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -531,6 +531,9 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		return;
 	}
 
+	if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
+		ipc_devlink_deinit(ipc_imem->ipc_devlink);
+
 	if (!ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg))
 		ipc_imem->mux = ipc_mux_init(&mux_cfg, ipc_imem);
 
@@ -1171,7 +1174,7 @@ void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
 		ipc_port_deinit(ipc_imem->ipc_port);
 	}
 
-	if (ipc_imem->ipc_devlink)
+	if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
 		ipc_devlink_deinit(ipc_imem->ipc_devlink);
 
 	ipc_imem_device_ipc_uninit(ipc_imem);
@@ -1335,6 +1338,8 @@ struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,
 
 		if (ipc_flash_link_establish(ipc_imem))
 			goto devlink_channel_fail;
+
+		set_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag);
 	}
 	return ipc_imem;
 devlink_channel_fail:
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 6be6708b4eec..6b479fe23a42 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -101,6 +101,7 @@ struct ipc_chnl_cfg;
 #define IOSM_CHIP_INFO_SIZE_MAX 100
 
 #define FULLY_FUNCTIONAL 0
+#define IOSM_DEVLINK_INIT 1
 
 /* List of the supported UL/DL pipes. */
 enum ipc_mem_pipes {
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 825e8e5ffb2a..09261fbb79c1 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -450,6 +450,7 @@ void ipc_imem_sys_devlink_close(struct iosm_devlink *ipc_devlink)
 	/* Release the pipe resources */
 	ipc_imem_pipe_cleanup(ipc_imem, &channel->ul_pipe);
 	ipc_imem_pipe_cleanup(ipc_imem, &channel->dl_pipe);
+	ipc_imem->nr_of_channels--;
 }
 
 void ipc_imem_sys_devlink_notify_rx(struct iosm_devlink *ipc_devlink,
-- 
2.25.1

