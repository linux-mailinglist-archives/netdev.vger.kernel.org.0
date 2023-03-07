Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 176466AF858
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:15:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCGWO7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:14:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbjCGWO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:14:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069097FD46
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 14:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678227296; x=1709763296;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WLPF/ESYrR/pCIR9w3JERjGKOrD2FnxP7IGdZVcQ1rk=;
  b=m/+V4LmTW6PYgZi5Ug5KrqGzvsCaGtq5XWjlLIViTesBQHip5eKcdf9A
   6HdZIXmguKT6Flkd2DJ8lcU7VLUzmgiGcBWiqRRjaTg02UPa3LoPSRpTr
   dx2sz+gQY5r3J2mM2ub+t9fjYErFybAt4LdmS0KbS1KNZiHDUeVb2XqUX
   2q7TwmWDqv7FB54bVrUQ2b4rFYqA0QWX196FDEx+TQGnMydaT1L3Aq25v
   WFBnrzUAhI1x88YkKo61V9Uf+weKZ/EbBG+MJPJy0JKwWVGaJqSNdSPIF
   ++NAGe6Ul7036o0XaMfROMTRtnj9JZZCKIoKJX+LAKMwYZPsCpRpBPkWU
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338310793"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="338310793"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Mar 2023 14:14:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="626701500"
X-IronPort-AV: E=Sophos;i="5.98,242,1673942400"; 
   d="scan'208";a="626701500"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga003.jf.intel.com with ESMTP; 07 Mar 2023 14:14:55 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>,
        anthony.l.nguyen@intel.com, sasha.neftin@intel.com,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: [PATCH net-next v2 1/3] igc: Add qbv_config_change_errors counter
Date:   Tue,  7 Mar 2023 14:13:30 -0800
Message-Id: <20230307221332.3997881-2-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
References: <20230307221332.3997881-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>

Add ConfigChangeError(qbv_config_change_errors) when user try to set the
AdminBaseTime to past value while the current GCL is still running.

The ConfigChangeError counter should not be increased when a gate control
list is scheduled into the future.

User can use "ethtool -S <interface> | grep qbv_config_change_errors"
command to check the counter values.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Tested-by: Naama Meir <naamax.meir@linux.intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igc/igc.h         |  1 +
 drivers/net/ethernet/intel/igc/igc_ethtool.c |  1 +
 drivers/net/ethernet/intel/igc/igc_main.c    |  1 +
 drivers/net/ethernet/intel/igc/igc_tsn.c     | 12 ++++++++++++
 4 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc.h b/drivers/net/ethernet/intel/igc/igc.h
index df3e26c0cf01..79cc99af4317 100644
--- a/drivers/net/ethernet/intel/igc/igc.h
+++ b/drivers/net/ethernet/intel/igc/igc.h
@@ -185,6 +185,7 @@ struct igc_adapter {
 	ktime_t base_time;
 	ktime_t cycle_time;
 	bool qbv_enable;
+	u32 qbv_config_change_errors;
 
 	/* OS defined structs */
 	struct pci_dev *pdev;
diff --git a/drivers/net/ethernet/intel/igc/igc_ethtool.c b/drivers/net/ethernet/intel/igc/igc_ethtool.c
index 5a26a7805ef8..0e2cb00622d1 100644
--- a/drivers/net/ethernet/intel/igc/igc_ethtool.c
+++ b/drivers/net/ethernet/intel/igc/igc_ethtool.c
@@ -67,6 +67,7 @@ static const struct igc_stats igc_gstrings_stats[] = {
 	IGC_STAT("rx_hwtstamp_cleared", rx_hwtstamp_cleared),
 	IGC_STAT("tx_lpi_counter", stats.tlpic),
 	IGC_STAT("rx_lpi_counter", stats.rlpic),
+	IGC_STAT("qbv_config_change_errors", qbv_config_change_errors),
 };
 
 #define IGC_NETDEV_STAT(_net_stat) { \
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 2928a6c73692..4992cca4029d 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -6049,6 +6049,7 @@ static int igc_tsn_clear_schedule(struct igc_adapter *adapter)
 
 	adapter->base_time = 0;
 	adapter->cycle_time = NSEC_PER_SEC;
+	adapter->qbv_config_change_errors = 0;
 
 	for (i = 0; i < adapter->num_tx_queues; i++) {
 		struct igc_ring *ring = adapter->tx_ring[i];
diff --git a/drivers/net/ethernet/intel/igc/igc_tsn.c b/drivers/net/ethernet/intel/igc/igc_tsn.c
index a386c8d61dbf..94a2b0dfb54d 100644
--- a/drivers/net/ethernet/intel/igc/igc_tsn.c
+++ b/drivers/net/ethernet/intel/igc/igc_tsn.c
@@ -114,6 +114,7 @@ static int igc_tsn_disable_offload(struct igc_adapter *adapter)
 static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
+	bool tsn_mode_reconfig = false;
 	u32 tqavctrl, baset_l, baset_h;
 	u32 sec, nsec, cycle;
 	ktime_t base_time, systim;
@@ -226,6 +227,10 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 	}
 
 	tqavctrl = rd32(IGC_TQAVCTRL) & ~IGC_TQAVCTRL_FUTSCDDIS;
+
+	if (tqavctrl & IGC_TQAVCTRL_TRANSMIT_MODE_TSN)
+		tsn_mode_reconfig = true;
+
 	tqavctrl |= IGC_TQAVCTRL_TRANSMIT_MODE_TSN | IGC_TQAVCTRL_ENHANCED_QAV;
 
 	cycle = adapter->cycle_time;
@@ -239,6 +244,13 @@ static int igc_tsn_enable_offload(struct igc_adapter *adapter)
 		s64 n = div64_s64(ktime_sub_ns(systim, base_time), cycle);
 
 		base_time = ktime_add_ns(base_time, (n + 1) * cycle);
+
+		/* Increase the counter if scheduling into the past while
+		 * Gate Control List (GCL) is running.
+		 */
+		if ((rd32(IGC_BASET_H) || rd32(IGC_BASET_L)) &&
+		    tsn_mode_reconfig)
+			adapter->qbv_config_change_errors++;
 	} else {
 		/* According to datasheet section 7.5.2.9.3.3, FutScdDis bit
 		 * has to be configured before the cycle time and base time.
-- 
2.38.1

