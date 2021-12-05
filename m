Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71E124689C3
	for <lists+netdev@lfdr.de>; Sun,  5 Dec 2021 07:47:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231948AbhLEGvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Dec 2021 01:51:09 -0500
Received: from mga04.intel.com ([192.55.52.120]:27975 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231951AbhLEGvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Dec 2021 01:51:07 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10188"; a="235902338"
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="235902338"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Dec 2021 22:47:41 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,288,1631602800"; 
   d="scan'208";a="514244061"
Received: from ccgwwan-desktop15.iind.intel.com ([10.224.174.19])
  by fmsmga007.fm.intel.com with ESMTP; 04 Dec 2021 22:47:38 -0800
From:   M Chetan Kumar <m.chetan.kumar@linux.intel.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        krishna.c.sudi@intel.com, m.chetan.kumar@intel.com,
        m.chetan.kumar@linux.intel.com, linuxwwan@intel.com
Subject: [PATCH net-next 3/7] net: wwan: iosm: wwan0 net interface nonfunctional after fw flash
Date:   Sun,  5 Dec 2021 12:25:24 +0530
Message-Id: <20211205065528.1613881-4-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
References: <20211205065528.1613881-1-m.chetan.kumar@linux.intel.com>
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
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 7 ++++++-
 drivers/net/wwan/iosm/iosm_ipc_imem.h     | 1 +
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 1 +
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 644a871585ea..ac36f9846731 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -537,6 +537,9 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 		return;
 	}
 
+	if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
+		ipc_devlink_deinit(ipc_imem->ipc_devlink);
+
 	if (!ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg))
 		ipc_imem->mux = ipc_mux_init(&mux_cfg, ipc_imem);
 
@@ -1184,7 +1187,7 @@ void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
 		ipc_port_deinit(ipc_imem->ipc_port);
 	}
 
-	if (ipc_imem->ipc_devlink)
+	if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
 		ipc_devlink_deinit(ipc_imem->ipc_devlink);
 
 	ipc_imem_device_ipc_uninit(ipc_imem);
@@ -1348,6 +1351,8 @@ struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,
 
 		if (ipc_flash_link_establish(ipc_imem))
 			goto devlink_channel_fail;
+
+		set_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag);
 	}
 	return ipc_imem;
 devlink_channel_fail:
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index cec38009c44a..d220f2611621 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -101,6 +101,7 @@ struct ipc_chnl_cfg;
 #define IOSM_CHIP_INFO_SIZE_MAX 100
 
 #define FULLY_FUNCTIONAL 0
+#define IOSM_DEVLINK_INIT 1
 
 /* List of the supported UL/DL pipes. */
 enum ipc_mem_pipes {
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 43f1796a8984..0757fd915437 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -471,6 +471,7 @@ void ipc_imem_sys_devlink_close(struct iosm_devlink *ipc_devlink)
 	/* Release the pipe resources */
 	ipc_imem_pipe_cleanup(ipc_imem, &channel->ul_pipe);
 	ipc_imem_pipe_cleanup(ipc_imem, &channel->dl_pipe);
+	ipc_imem->nr_of_channels--;
 }
 
 void ipc_imem_sys_devlink_notify_rx(struct iosm_devlink *ipc_devlink,
-- 
2.25.1

