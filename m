Return-Path: <netdev+bounces-9177-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BD56727C57
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:08:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 551551C20FC2
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:08:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0E7BBA36;
	Thu,  8 Jun 2023 10:08:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CA63B3FA
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:08:18 +0000 (UTC)
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1F9B1FE9
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 03:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686218896; x=1717754896;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Z4045QyoqPWLPTGouGyVm8MQuqusvAeuwC7pOKkRe2g=;
  b=XWh+dWyxgx2YEwMRd4SwR/usZhsVLegw14t8F8j2lAuW9Y38iXxD5N/0
   qb6nefLx+peCc5e+hemhlEFVmJNYCjjNn9qvfnWZyrHId8xymbH/74a0i
   KFeFWzyARFzl22npKg5XQZumLS/ro5kbo40yq5xpMi0JXkw9jzCzAdw5H
   IoYg46gRU4opMvWsaD1wcavl2OJvUMYNyAiTAKNSCqzxgij7n0B3Pnwgg
   yai/01y4UxGAFYSuXnasDV8u/S04NPENqJFmQI9CvghQL8LrFHdGj25XW
   AXYLJwOWCJ2UTp+Ep8qIXLG3IDX4YBTrDhc8r+z0tV7dVvdUOjbzllYa6
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="341923469"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="341923469"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2023 03:08:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10734"; a="709922941"
X-IronPort-AV: E=Sophos;i="6.00,226,1681196400"; 
   d="scan'208";a="709922941"
Received: from bswcg4446240.iind.intel.com ([10.224.174.140])
  by orsmga002.jf.intel.com with ESMTP; 08 Jun 2023 03:08:11 -0700
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
	M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net-next] net: wwan: iosm: enable runtime pm support for 7560
Date: Thu,  8 Jun 2023 15:38:03 +0530
Message-Id: <1b0829943267c30de27f271666cb7ce897f5b54a.1686218573.git.m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Adds runtime pm support for 7560.

As part of probe procedure auto suspend is enabled and auto suspend
delay is set to 5000 ms for runtime pm use. Later auto flag is set
to power manage the device at run time.

On successful communication establishment between host and device the
device usage counter is dropped and request to put the device into
sleep state (suspend).

In TX path, the device usage counter is raised and device is moved out
of sleep(resume) for data transmission. In RX path, if the device has
some data to be sent it request host platform to change the power state
by giving PCI PME message.

Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem.c  | 17 +++++++++++++++++
 drivers/net/wwan/iosm/iosm_ipc_imem.h  |  2 ++
 drivers/net/wwan/iosm/iosm_ipc_pcie.c  |  4 +++-
 drivers/net/wwan/iosm/iosm_ipc_port.c  | 17 ++++++++++++++++-
 drivers/net/wwan/iosm/iosm_ipc_trace.c |  8 ++++++++
 drivers/net/wwan/iosm/iosm_ipc_wwan.c  | 21 +++++++++++++++++++--
 6 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.c b/drivers/net/wwan/iosm/iosm_ipc_imem.c
index 829515a601b3..635301d677e1 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/delay.h>
+#include <linux/pm_runtime.h>
 
 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_devlink.h"
@@ -631,6 +632,11 @@ static void ipc_imem_run_state_worker(struct work_struct *instance)
 	/* Complete all memory stores after setting bit */
 	smp_mb__after_atomic();
 
+	if (ipc_imem->pcie->pci->device == INTEL_CP_DEVICE_7560_ID) {
+		pm_runtime_mark_last_busy(ipc_imem->dev);
+		pm_runtime_put_autosuspend(ipc_imem->dev);
+	}
+
 	return;
 
 err_ipc_mux_deinit:
@@ -1234,6 +1240,7 @@ void ipc_imem_cleanup(struct iosm_imem *ipc_imem)
 
 	/* forward MDM_NOT_READY to listeners */
 	ipc_uevent_send(ipc_imem->dev, UEVENT_MDM_NOT_READY);
+	pm_runtime_get_sync(ipc_imem->dev);
 
 	hrtimer_cancel(&ipc_imem->td_alloc_timer);
 	hrtimer_cancel(&ipc_imem->tdupdate_timer);
@@ -1419,6 +1426,16 @@ struct iosm_imem *ipc_imem_init(struct iosm_pcie *pcie, unsigned int device_id,
 
 		set_bit(IOSM_DEVLINK_INIT, &ipc_imem->flag);
 	}
+
+	if (!pm_runtime_enabled(ipc_imem->dev))
+		pm_runtime_enable(ipc_imem->dev);
+
+	pm_runtime_set_autosuspend_delay(ipc_imem->dev,
+					 IPC_MEM_AUTO_SUSPEND_DELAY_MS);
+	pm_runtime_use_autosuspend(ipc_imem->dev);
+	pm_runtime_allow(ipc_imem->dev);
+	pm_runtime_mark_last_busy(ipc_imem->dev);
+
 	return ipc_imem;
 devlink_channel_fail:
 	ipc_devlink_deinit(ipc_imem->ipc_devlink);
diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem.h b/drivers/net/wwan/iosm/iosm_ipc_imem.h
index 5664ac507c90..0144b45e2afb 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem.h
@@ -103,6 +103,8 @@ struct ipc_chnl_cfg;
 #define FULLY_FUNCTIONAL 0
 #define IOSM_DEVLINK_INIT 1
 
+#define IPC_MEM_AUTO_SUSPEND_DELAY_MS 5000
+
 /* List of the supported UL/DL pipes. */
 enum ipc_mem_pipes {
 	IPC_MEM_PIPE_0 = 0,
diff --git a/drivers/net/wwan/iosm/iosm_ipc_pcie.c b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
index 04517bd3325a..3a259c9abefd 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_pcie.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_pcie.c
@@ -6,6 +6,7 @@
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
 #include <linux/module.h>
+#include <linux/pm_runtime.h>
 #include <net/rtnetlink.h>
 
 #include "iosm_ipc_imem.h"
@@ -437,7 +438,8 @@ static int __maybe_unused ipc_pcie_resume_cb(struct device *dev)
 	return 0;
 }
 
-static SIMPLE_DEV_PM_OPS(iosm_ipc_pm, ipc_pcie_suspend_cb, ipc_pcie_resume_cb);
+static DEFINE_RUNTIME_DEV_PM_OPS(iosm_ipc_pm, ipc_pcie_suspend_cb,
+				 ipc_pcie_resume_cb, NULL);
 
 static struct pci_driver iosm_ipc_driver = {
 	.name = KBUILD_MODNAME,
diff --git a/drivers/net/wwan/iosm/iosm_ipc_port.c b/drivers/net/wwan/iosm/iosm_ipc_port.c
index 5d5b4183e14a..2ba1ddca3945 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_port.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_port.c
@@ -3,6 +3,8 @@
  * Copyright (C) 2020-21 Intel Corporation.
  */
 
+#include <linux/pm_runtime.h>
+
 #include "iosm_ipc_chnl_cfg.h"
 #include "iosm_ipc_imem_ops.h"
 #include "iosm_ipc_port.h"
@@ -13,12 +15,16 @@ static int ipc_port_ctrl_start(struct wwan_port *port)
 	struct iosm_cdev *ipc_port = wwan_port_get_drvdata(port);
 	int ret = 0;
 
+	pm_runtime_get_sync(ipc_port->ipc_imem->dev);
 	ipc_port->channel = ipc_imem_sys_port_open(ipc_port->ipc_imem,
 						   ipc_port->chl_id,
 						   IPC_HP_CDEV_OPEN);
 	if (!ipc_port->channel)
 		ret = -EIO;
 
+	pm_runtime_mark_last_busy(ipc_port->ipc_imem->dev);
+	pm_runtime_put_autosuspend(ipc_port->ipc_imem->dev);
+
 	return ret;
 }
 
@@ -27,15 +33,24 @@ static void ipc_port_ctrl_stop(struct wwan_port *port)
 {
 	struct iosm_cdev *ipc_port = wwan_port_get_drvdata(port);
 
+	pm_runtime_get_sync(ipc_port->ipc_imem->dev);
 	ipc_imem_sys_port_close(ipc_port->ipc_imem, ipc_port->channel);
+	pm_runtime_mark_last_busy(ipc_port->ipc_imem->dev);
+	pm_runtime_put_autosuspend(ipc_port->ipc_imem->dev);
 }
 
 /* transfer control data to modem */
 static int ipc_port_ctrl_tx(struct wwan_port *port, struct sk_buff *skb)
 {
 	struct iosm_cdev *ipc_port = wwan_port_get_drvdata(port);
+	int ret;
 
-	return ipc_imem_sys_cdev_write(ipc_port, skb);
+	pm_runtime_get_sync(ipc_port->ipc_imem->dev);
+	ret = ipc_imem_sys_cdev_write(ipc_port, skb);
+	pm_runtime_mark_last_busy(ipc_port->ipc_imem->dev);
+	pm_runtime_put_autosuspend(ipc_port->ipc_imem->dev);
+
+	return ret;
 }
 
 static const struct wwan_port_ops ipc_wwan_ctrl_ops = {
diff --git a/drivers/net/wwan/iosm/iosm_ipc_trace.c b/drivers/net/wwan/iosm/iosm_ipc_trace.c
index eeecfa3d10c5..4368373797b6 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_trace.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_trace.c
@@ -3,7 +3,9 @@
  * Copyright (C) 2020-2021 Intel Corporation.
  */
 
+#include <linux/pm_runtime.h>
 #include <linux/wwan.h>
+
 #include "iosm_ipc_trace.h"
 
 /* sub buffer size and number of sub buffer */
@@ -97,6 +99,8 @@ static ssize_t ipc_trace_ctrl_file_write(struct file *filp,
 	if (ret)
 		return ret;
 
+	pm_runtime_get_sync(ipc_trace->ipc_imem->dev);
+
 	mutex_lock(&ipc_trace->trc_mutex);
 	if (val == TRACE_ENABLE && ipc_trace->mode != TRACE_ENABLE) {
 		ipc_trace->channel = ipc_imem_sys_port_open(ipc_trace->ipc_imem,
@@ -117,6 +121,10 @@ static ssize_t ipc_trace_ctrl_file_write(struct file *filp,
 	ret = count;
 unlock:
 	mutex_unlock(&ipc_trace->trc_mutex);
+
+	pm_runtime_mark_last_busy(ipc_trace->ipc_imem->dev);
+	pm_runtime_put_autosuspend(ipc_trace->ipc_imem->dev);
+
 	return ret;
 }
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_wwan.c b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
index ff747fc79aaf..93d17de08786 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_wwan.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_wwan.c
@@ -6,6 +6,7 @@
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
 #include <linux/if_link.h>
+#include <linux/pm_runtime.h>
 #include <linux/rtnetlink.h>
 #include <linux/wwan.h>
 #include <net/pkt_sched.h>
@@ -51,11 +52,13 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 	struct iosm_netdev_priv *priv = wwan_netdev_drvpriv(netdev);
 	struct iosm_wwan *ipc_wwan = priv->ipc_wwan;
 	int if_id = priv->if_id;
+	int ret = 0;
 
 	if (if_id < IP_MUX_SESSION_START ||
 	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
 		return -EINVAL;
 
+	pm_runtime_get_sync(ipc_wwan->ipc_imem->dev);
 	/* get channel id */
 	priv->ch_id = ipc_imem_sys_wwan_open(ipc_wwan->ipc_imem, if_id);
 
@@ -63,7 +66,8 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 		dev_err(ipc_wwan->dev,
 			"cannot connect wwan0 & id %d to the IPC mem layer",
 			if_id);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto err_out;
 	}
 
 	/* enable tx path, DL data may follow */
@@ -72,7 +76,11 @@ static int ipc_wwan_link_open(struct net_device *netdev)
 	dev_dbg(ipc_wwan->dev, "Channel id %d allocated to if_id %d",
 		priv->ch_id, priv->if_id);
 
-	return 0;
+err_out:
+	pm_runtime_mark_last_busy(ipc_wwan->ipc_imem->dev);
+	pm_runtime_put_autosuspend(ipc_wwan->ipc_imem->dev);
+
+	return ret;
 }
 
 /* Bring-down the wwan net link */
@@ -82,9 +90,12 @@ static int ipc_wwan_link_stop(struct net_device *netdev)
 
 	netif_stop_queue(netdev);
 
+	pm_runtime_get_sync(priv->ipc_wwan->ipc_imem->dev);
 	ipc_imem_sys_wwan_close(priv->ipc_wwan->ipc_imem, priv->if_id,
 				priv->ch_id);
 	priv->ch_id = -1;
+	pm_runtime_mark_last_busy(priv->ipc_wwan->ipc_imem->dev);
+	pm_runtime_put_autosuspend(priv->ipc_wwan->ipc_imem->dev);
 
 	return 0;
 }
@@ -106,6 +117,7 @@ static netdev_tx_t ipc_wwan_link_transmit(struct sk_buff *skb,
 	    if_id >= ARRAY_SIZE(ipc_wwan->sub_netlist))
 		return -EINVAL;
 
+	pm_runtime_get(ipc_wwan->ipc_imem->dev);
 	/* Send the SKB to device for transmission */
 	ret = ipc_imem_sys_wwan_transmit(ipc_wwan->ipc_imem,
 					 if_id, priv->ch_id, skb);
@@ -119,9 +131,14 @@ static netdev_tx_t ipc_wwan_link_transmit(struct sk_buff *skb,
 		ret = NETDEV_TX_BUSY;
 		dev_err(ipc_wwan->dev, "unable to push packets");
 	} else {
+		pm_runtime_mark_last_busy(ipc_wwan->ipc_imem->dev);
+		pm_runtime_put_autosuspend(ipc_wwan->ipc_imem->dev);
 		goto exit;
 	}
 
+	pm_runtime_mark_last_busy(ipc_wwan->ipc_imem->dev);
+	pm_runtime_put_autosuspend(ipc_wwan->ipc_imem->dev);
+
 	return ret;
 
 exit:
-- 
2.34.1


