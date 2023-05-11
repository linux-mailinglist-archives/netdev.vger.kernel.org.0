Return-Path: <netdev+bounces-1713-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 168036FEF9E
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 12:05:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25DA81C20F1B
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 10:05:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 133AA1C75F;
	Thu, 11 May 2023 10:05:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075D61C740
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 10:05:51 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8369F83FE
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 03:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683799550; x=1715335550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=paWnZIDznY5evHWj9QZsipeg+kJU08WXPYWHMmtoTpM=;
  b=AAY7S3XutoW1WTXfGwF0Rgx2XboADIRGT997q+pvZwTxnE9RbPjTS4l4
   JblKNmAuzHZLdtfgaMsumU+RuZiiKZwuRiSfsnk34sp4N/s6fbXsBqE/k
   8pN3+0HiyhgCe+ZBlCe7aadR7u+bGoQ+Kkv9hX6U7uBo8UMuqfSjoRCMB
   bkQjaywYzbWEdutbpi1CBUe6neN2LEm0+8rjcNGGeBGEAn3CGMnIJCKtn
   W6cQRnXdI5ni+433oFSXQYmgjiQbFemceba4/CHF3BfoTLWN0sJkc7Qxu
   KmtEcL4J8lPG5xUPp97yiUvCXS7cX8FYZpPwsiKTG5txCjUZE4UO6Cnv2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="436787565"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="436787565"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 03:05:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="699657331"
X-IronPort-AV: E=Sophos;i="5.99,266,1677571200"; 
   d="scan'208";a="699657331"
Received: from bswcg4446240.iind.intel.com ([10.224.174.140])
  by orsmga002.jf.intel.com with ESMTP; 11 May 2023 03:05:25 -0700
From: m.chetan.kumar@linux.intel.com
To: netdev@vger.kernel.org
Cc: kuba@kernel.org,
	davem@davemloft.net,
	johannes@sipsolutions.net,
	ryazanov.s.a@gmail.com,
	loic.poulain@linaro.org,
	linuxwwan@intel.com,
	m.chetan.kumar@intel.com,
	edumazet@google.com,
	pabeni@redhat.com,
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>,
	Samuel Wein PhD <sam@samwein.com>
Subject: [PATCH net] net: wwan: iosm: fix NULL pointer dereference when removing device
Date: Thu, 11 May 2023 15:34:44 +0530
Message-Id: <a9b0a086a7fc9de0994fd00cedf6bbbda34805b5.1683798621.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

In suspend and resume cycle, the removal and rescan of device ends
up in NULL pointer dereference.

During driver initialization, if the ipc_imem_wwan_channel_init()
fails to get the valid device capabilities it returns an error and
further no resource (wwan struct) will be allocated. Now in this
situation if driver removal procedure is initiated it would result
in NULL pointer exception since unallocated wwan struct is dereferenced
inside ipc_wwan_deinit().

ipc_imem_run_state_worker() to handle the called functions return value
and to release the resource in failure case. It also reports the link
down event in failure cases. The user space application can handle this
event to do a device reset for restoring the device communication.

Fixes: 3670970dd8c6 ("net: iosm: shared memory IPC interface")
Reported-by: Samuel Wein PhD <sam@samwein.com>
Closes: https://lore.kernel.org/netdev/20230427140819.1310f4bd@kernel.org/T/
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c     | 29 ++++++++++++++++++-----
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 12 ++++++----
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.h |  6 +++--
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index c066b0040a3f..0b4efd2571dd 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -565,24 +565,32 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	struct ipc_mux_config mux_cfg;
 	struct iosm_imem *ipc_imem;
 	u8 ctrl_chl_idx = 0;
+	int ret;
 
 	ipc_imem = container_of(instance, struct iosm_imem, run_state_worker);
 
 	if (ipc_imem->phase != IPC_P_RUN) {
 		dev_err(ipc_imem->dev,
 			"Modem link down. Exit run state worker.");
-		return;
+		goto err_cp_phase;
 	}
 
 	if (test_and_clear_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag))
 		ipc_devlink_deinit(ipc_imem->ipc_devlink);
 
-	if (!ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg))
-		ipc_imem->mux = ipc_mux_init(&mux_cfg, ipc_imem);
+	ret = ipc_imem_setup_cp_mux_cap_init(ipc_imem, &mux_cfg);
+	if (ret < 0)
+		goto err_cap_init;
+
+	ipc_imem->mux = ipc_mux_init(&mux_cfg, ipc_imem);
+	if (!ipc_imem->mux)
+		goto err_mux_init;
+
+	ret = ipc_imem_wwan_channel_init(ipc_imem, mux_cfg.protocol);
+	if (ret < 0)
+		goto err_channel_init;
 
-	ipc_imem_wwan_channel_init(ipc_imem, mux_cfg.protocol);
-	if (ipc_imem->mux)
-		ipc_imem->mux->wwan = ipc_imem->wwan;
+	ipc_imem->mux->wwan = ipc_imem->wwan;
 
 	while (ctrl_chl_idx < IPC_MEM_MAX_CHANNELS) {
 		if (!ipc_chnl_cfg_get(&chnl_cfg_port, ctrl_chl_idx)) {
@@ -622,6 +630,15 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 
 	/* Complete all memory stores after setting bit */
 	smp_mb__after_atomic();
+
+	return;
+
+err_channel_init:
+	ipc_mux_deinit(ipc_imem->mux);
+err_mux_init:
+err_cap_init:
+err_cp_phase:
+	ipc_uevent_send(ipc_imem->dev, UEVENT_CD_READY_LINK_DOWN);
 }
 
 static void ipc_imem_handle_irq(struct iosm_imem *ipc_imem, int irq)
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index 66b90cc4c346..109cf8930488 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -77,8 +77,8 @@ int ipc_imem_sys_wwan_transmit(struct iosm_imem *ipc_imem,
 }
 
 /* Initialize wwan channel */
-void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
-				enum ipc_mux_protocol mux_type)
+int ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
+			       enum ipc_mux_protocol mux_type)
 {
 	struct ipc_chnl_cfg chnl_cfg = { 0 };
 
@@ -87,7 +87,7 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 	/* If modem version is invalid (0xffffffff), do not initialize WWAN. */
 	if (ipc_imem->cp_version == -1) {
 		dev_err(ipc_imem->dev, "invalid CP version");
-		return;
+		return -EIO;
 	}
 
 	ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels);
@@ -104,9 +104,13 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 
 	/* WWAN registration. */
 	ipc_imem->wwan = ipc_wwan_init(ipc_imem, ipc_imem->dev);
-	if (!ipc_imem->wwan)
+	if (!ipc_imem->wwan) {
 		dev_err(ipc_imem->dev,
 			"failed to register the ipc_wwan interfaces");
+		return -ENOMEM;
+	}
+
+	return 0;
 }
 
 /* Map SKB to DMA for transfer */
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
index f8afb217d9e2..026c5bd0f999 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.h
@@ -91,9 +91,11 @@ int ipc_imem_sys_wwan_transmit(struct iosm_imem *ipc_imem, int if_id,
  *				MUX.
  * @ipc_imem:		Pointer to iosm_imem struct.
  * @mux_type:		Type of mux protocol.
+ *
+ * Return: 0 on success and failure value on error
  */
-void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
-				enum ipc_mux_protocol mux_type);
+int ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
+			       enum ipc_mux_protocol mux_type);
 
 /**
  * ipc_imem_sys_devlink_open - Open a Flash/CD Channel link to CP
-- 
2.34.1


