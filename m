Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2A9F61EC28
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 08:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiKGHf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 02:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiKGHfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 02:35:51 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DE7D5F8C
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 23:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667806550; x=1699342550;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=cqAL1mb7WsNpRNgxXU3Crgm6BmqLtBXu5eKVs11cjQA=;
  b=VdHeGN7fb2p8R+Q0VQF9ORulfH77U8WE4OfWLMcg/COkHqYpRzTLzLfD
   ddZFLi+KSrEdvwuQyTbM+TbUoyIge/gdf/hx5jSLmA2W21geTXQ2jRsSr
   pDQ1O3N45xCV4h6P4yt0tU06jyegM/r5HUMDfFwQzR+jiW1Gmfd3IwcPe
   tatE6o+lntERO1JXm84hhM+sv5azspAvIqor4ox8uTW/XBZZFpSu4Y2Nd
   0tQ69Y3yadEd+uvAHcKzWwqQS6CDJBaKDC6Gl5aKYWVNV2ne93D9ogP5n
   g8IBvdUsAFAphhp6gOD0n5Tj3OnMOKI2amBxBDsR/uM2ErwXJThQq1eCk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="337064296"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="337064296"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 23:35:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="638268628"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="638268628"
Received: from bswcg005.iind.intel.com ([10.224.174.25])
  by fmsmga007.fm.intel.com with ESMTP; 06 Nov 2022 23:35:46 -0800
From:   m.chetan.kumar@linux.intel.com
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, davem@davemloft.net, johannes@sipsolutions.net,
        ryazanov.s.a@gmail.com, loic.poulain@linaro.org,
        m.chetan.kumar@intel.com, edumazet@google.com, pabeni@redhat.com,
        linuxwwan@intel.com,
        M Chetan Kumar <m.chetan.kumar@linux.intel.com>
Subject: [PATCH net V2 3/4] net: wwan: iosm: fix invalid mux header type
Date:   Mon,  7 Nov 2022 13:05:13 +0530
Message-Id: <20221107073513.1978209-1-m.chetan.kumar@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
--
v2:
 * No Change.
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

