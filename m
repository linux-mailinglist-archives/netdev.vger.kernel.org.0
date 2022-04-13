Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FEB4FEDE7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 05:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbiDMD5A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 23:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232126AbiDMD4t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 23:56:49 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDC3F273A;
        Tue, 12 Apr 2022 20:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649822068; x=1681358068;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qWnHsji0gnh/xDp7MQF81PbKycXAQAQAMMGE3n28kdA=;
  b=YlhoMOngZDWEyJon07RvXTvrthpaDc+N+wS0AqTD8UqmyKrHA2Jzq+eP
   bCxsTEddmO2VWcKEjnfypmWBBOU2QV+rgQY9mWqqwDBwT+azVS6dpvewZ
   rxMJx2vrHHs8Ltx59uEj83UlNpeG3Yc33hD/0BTUDuZL2CLFwWFjP+XE9
   VQz33zcwXCmHdnaIPm0rkHBD8lhZMW60qbGBa2TAoWH5UYejoZUD5ujEY
   eSwJP6GiQNO/VUioeEgUoawKVLeI5ObmJCKWgLMbe7rHVcJDUOXhz1DQM
   NAj0Jp5iSZxHPK15nkEKWcmizwabXjhZ4xHiFF2/4deaBj+Gi7+u6A0cJ
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10315"; a="249852148"
X-IronPort-AV: E=Sophos;i="5.90,255,1643702400"; 
   d="scan'208";a="249852148"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2022 20:54:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,255,1643702400"; 
   d="scan'208";a="724733855"
Received: from p12hl01tmin.png.intel.com ([10.158.65.75])
  by orsmga005.jf.intel.com with ESMTP; 12 Apr 2022 20:54:23 -0700
From:   Tan Tee Min <tee.min.tan@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Wei Feng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Song Yoong Siang <yoong.siang.song@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>
Subject: [PATCH net 1/1] net: stmmac: add fsleep() in HW Rx timestamp checking loop
Date:   Wed, 13 Apr 2022 12:01:15 +0800
Message-Id: <20220413040115.2351987-1-tee.min.tan@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.2 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possibility that the context descriptor still owned by the DMA
even the previous normal descriptor own bit is already cleared. Checking
the context descriptor readiness without delay might be not enough time
for the DMA to update the descriptor field, which causing failure in
getting HW Rx timestamp.

This patch introduces a 1us fsleep() in HW Rx timestamp checking loop
to give time for DMA to update/complete the context descriptor.

ptp4l Timestamp log without this patch:
-----------------------------------------------------------
$ echo 10000 > /sys/class/net/enp0s30f4/gro_flush_timeout
$ echo 10000 > /sys/class/net/enp0s30f4/napi_defer_hard_irqs
$ ptp4l -P2Hi enp0s30f4 --step_threshold=1 -m
ptp4l: selected /dev/ptp2 as PTP clock
ptp4l: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l: selected local clock 901210.fffe.b57df7 as best master
ptp4l: port 1: new foreign master 22bb22.fffe.bb22bb-1
ptp4l: selected best master clock 22bb22.fffe.bb22bb
ptp4l: port 1: LISTENING to UNCALIBRATED on RS_SLAVE
ptp4l: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l: port 1: received SYNC without timestamp
ptp4l: rms   49 max   63 freq  -9573 +/-  34 delay    71 +/-   1
ptp4l: rms   15 max   25 freq  -9553 +/-  20 delay    72 +/-   0
ptp4l: port 1: received SYNC without timestamp
ptp4l: rms    9 max   18 freq  -9540 +/-  11 delay    70 +/-   0
ptp4l: port 1: received PDELAY_REQ without timestamp
ptp4l: rms   16 max   29 freq  -9519 +/-  12 delay    72 +/-   0
ptp4l: port 1: received PDELAY_REQ without timestamp
ptp4l: rms    9 max   18 freq  -9527 +/-  12 delay    72 +/-   0
ptp4l: rms    5 max    9 freq  -9530 +/-   7 delay    70 +/-   0
ptp4l: rms   11 max   20 freq  -9530 +/-  16 delay    72 +/-   0
ptp4l: rms    5 max   11 freq  -9530 +/-   7 delay    74 +/-   0
ptp4l: rms    6 max    9 freq  -9522 +/-   7 delay    72 +/-   0
ptp4l: port 1: received PDELAY_REQ without timestamp
-----------------------------------------------------------

ptp4l Timestamp log with this patch:
-----------------------------------------------------------
$ echo 10000 > /sys/class/net/enp0s30f4/gro_flush_timeout
$ echo 10000 > /sys/class/net/enp0s30f4/napi_defer_hard_irqs
$ ptp4l -P2Hi enp0s30f4 --step_threshold=1 -m
ptp4l: selected /dev/ptp2 as PTP clock
ptp4l: port 1: INITIALIZING to LISTENING on INIT_COMPLETE
ptp4l: selected local clock 901210.fffe.b57df7 as best master
ptp4l: port 1: new foreign master 22bb22.fffe.bb22bb-1
ptp4l: selected best master clock 22bb22.fffe.bb22bb
ptp4l: port 1: LISTENING to UNCALIBRATED on RS_SLAVE
ptp4l: port 1: UNCALIBRATED to SLAVE on MASTER_CLOCK_SELECTED
ptp4l: rms   30 max   45 freq  -9400 +/-  23 delay    72 +/-   0
ptp4l: rms    7 max   16 freq  -9414 +/-  10 delay    70 +/-   0
ptp4l: rms    6 max    9 freq  -9422 +/-   6 delay    72 +/-   0
ptp4l: rms   13 max   20 freq  -9436 +/-  13 delay    74 +/-   0
ptp4l: rms   12 max   27 freq  -9446 +/-  11 delay    72 +/-   0
ptp4l: rms    9 max   12 freq  -9453 +/-   6 delay    74 +/-   0
ptp4l: rms    9 max   15 freq  -9438 +/-  11 delay    74 +/-   0
ptp4l: rms   10 max   16 freq  -9435 +/-  12 delay    74 +/-   0
ptp4l: rms    8 max   18 freq  -9428 +/-   8 delay    72 +/-   0
ptp4l: rms    8 max   18 freq  -9423 +/-   8 delay    72 +/-   0
ptp4l: rms    9 max   16 freq  -9431 +/-  12 delay    70 +/-   0
ptp4l: rms    9 max   18 freq  -9441 +/-   9 delay    72 +/-   0
-----------------------------------------------------------

Fixes: ba1ffd74df74 ("stmmac: fix PTP support for GMAC4")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
Signed-off-by: Tan Tee Min <tee.min.tan@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
index d3b4765c1a5b..289bf26a6105 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
@@ -279,10 +279,11 @@ static int dwmac4_wrback_get_rx_timestamp_status(void *desc, void *next_desc,
 			/* Check if timestamp is OK from context descriptor */
 			do {
 				ret = dwmac4_rx_check_timestamp(next_desc);
-				if (ret < 0)
+				if (ret <= 0)
 					goto exit;
 				i++;
 
+				fsleep(1);
 			} while ((ret == 1) && (i < 10));
 
 			if (i == 10)
-- 
2.25.1

