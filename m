Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3B7613B9E
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 17:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiJaQq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 12:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbiJaQqZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 12:46:25 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45426E00C
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667234784; x=1698770784;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=x/mWy1AVoeDYgDyRuNiLaXX6h6GN2w8sNbiq6fwRA4c=;
  b=gOokDu1OXNdAmUa6L/eIWl8Hk+lTxd+7JZnRTaD5NPMMNapSHL+BwZ4j
   xw3WNd09/wszTdxUPy+aAigMKl4gHuHthHZh88XiQiYe8SLw5e/McfRgL
   a+1Dmg9gg96vrC5Pzw9SZh1LQCiFgUgku5A81IAyk845X96bH5YaIr8ZV
   uSjc9kSk/RleMUndFb9erztCyAi2C08I9k7oCmsFNqfcKnCbOWEG4a0qv
   F31ZyN/Kw/zthOUo7gdyVRJsgvU7SdTlvOZQjf3avQNPguFbORdigwXd5
   uLIs09Pjx1PNEbuADf861pSuiEUAOz9g2OHLGFexpCl9JzA9RMQb4Uvw1
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="289337201"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="289337201"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2022 09:46:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10517"; a="702583376"
X-IronPort-AV: E=Sophos;i="5.95,228,1661842800"; 
   d="scan'208";a="702583376"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga004.fm.intel.com with ESMTP; 31 Oct 2022 09:46:21 -0700
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net 3/3] net: wwan: iosm: fix invalid mux header type
Date:   Mon, 31 Oct 2022 22:16:00 +0530
Message-Id: <20221031164600.1886866-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: M Chetan Kumar <m.chetan.kumar@linux.intel.com>

Data stall seen during peak DL throughput test & packets are
dropped by mux layer due to invalid header type in datagram.

During initlization Mux aggregration protocol is set to default
UL/DL size and TD count of Mux lite protocol. This configuration
mismatch between device and driver is resulting in data stall/packet
drops.

Override the UL/DL size and TD count for Mux aggregation protocol.

Fixes: 1f52d7b62285 ("net: wwan: iosm: Enable M.2 7360 WWAN card support")
Signed-off-by: M Chetan Kumar <m.chetan.kumar@linux.intel.com>
---
 drivers/net/wwan/iosm/iosm_ipc_imem_ops.c | 8 ++++++++
 drivers/net/wwan/iosm/iosm_ipc_mux.h      | 1 +
 2 files changed, 9 insertions(+)

diff --git a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
index b7f9237dedf7..66b90cc4c346 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
+++ b/drivers/net/wwan/iosm/iosm_ipc_imem_ops.c
@@ -91,6 +91,14 @@ void ipc_imem_wwan_channel_init(struct iosm_imem *ipc_imem,
 	}
 
 	ipc_chnl_cfg_get(&chnl_cfg, ipc_imem->nr_of_channels);
+
+	if (ipc_imem->mmio->mux_protocol == MUX_AGGREGATION &&
+	    ipc_imem->nr_of_channels == IPC_MEM_IP_CHL_ID_0) {
+		chnl_cfg.ul_nr_of_entries = IPC_MEM_MAX_TDS_MUX_AGGR_UL;
+		chnl_cfg.dl_nr_of_entries = IPC_MEM_MAX_TDS_MUX_AGGR_DL;
+		chnl_cfg.dl_buf_size = IPC_MEM_MAX_ADB_BUF_SIZE;
+	}
+
 	ipc_imem_channel_init(ipc_imem, IPC_CTYPE_WWAN, chnl_cfg,
 			      IRQ_MOD_OFF);
 
diff --git a/drivers/net/wwan/iosm/iosm_ipc_mux.h b/drivers/net/wwan/iosm/iosm_ipc_mux.h
index cd9d74cc097f..9968bb885c1f 100644
--- a/drivers/net/wwan/iosm/iosm_ipc_mux.h
+++ b/drivers/net/wwan/iosm/iosm_ipc_mux.h
@@ -10,6 +10,7 @@
 
 #define IPC_MEM_MAX_UL_DG_ENTRIES	100
 #define IPC_MEM_MAX_TDS_MUX_AGGR_UL	60
+#define IPC_MEM_MAX_TDS_MUX_AGGR_DL	60
 
 #define IPC_MEM_MAX_ADB_BUF_SIZE (16 * 1024)
 #define IPC_MEM_MAX_UL_ADB_BUF_SIZE IPC_MEM_MAX_ADB_BUF_SIZE
-- 
2.34.1

