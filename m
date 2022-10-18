Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6D5602035
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbiJRBJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231315AbiJRBJS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:09:18 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 778469411D
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666055355; x=1697591355;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=/X3NJNpAFZpLCntiaxyaosrbSVJWej2PE7E93BgbBVk=;
  b=HRJkeCxaU00NnxnMnlfjFES60Ey2zbacwRefkvO+eZ1BEIYomyxsXTsI
   hPmzoIntcPXvlzIunq8cCygmHdg7BYSKQOsr0aa1aTPwjAt9b+sO638p0
   RtEsAyr0uo3mRyDl1rU/GEPJdzdyDjt68R4QSqF8LBLjTxg8qpMhfHkgI
   VSOjDztIWPXnqNieOslBvbTUvwfP8NU6cU4mTaMYGyc8j8x+FFBV4AkiO
   fsXnl6u1LgaBBdaRelDiCPuaQ0Udgo3VEbxCL5BMV39FEq0v9xEDXijiz
   xCC+E6Yve8E7lZHSG0fWFsFjZHST7RfM2JSQ1CylLF5t77U5N/chSxXX/
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="392264193"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="392264193"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:09:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="717704428"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="717704428"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Oct 2022 18:09:12 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, aravindhan.gunasekaran@intel.com,
        richardcochran@gmail.com, gal@nvidia.com, saeed@kernel.org,
        leon@kernel.org, michael.chan@broadcom.com, andy@greyhouse.net,
        muhammad.husaini.zulkifli@intel.com, vinicius.gomes@intel.com
Subject: [PATCH v2 3/5] net: sock: extend SO_TIMESTAMPING for DMA Fetch
Date:   Tue, 18 Oct 2022 09:07:31 +0800
Message-Id: <20221018010733.4765-4-muhammad.husaini.zulkifli@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
References: <20221018010733.4765-1-muhammad.husaini.zulkifli@intel.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch is to extend SO_TIMESTAMPING API to support the DMA Time
Stamp by adding a new flag SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH.
User space application can configure this flag into hwtstamp_config flag
if require to use the DMA Time Stamp for that socket application.

Suggested-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 include/linux/skbuff.h          | 3 +++
 include/uapi/linux/net_tstamp.h | 6 ++++--
 net/ethtool/common.c            | 1 +
 net/socket.c                    | 3 +++
 4 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9fcf534f2d92..49f0ef60701a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -485,6 +485,9 @@ enum {
 
 	/* generate software time stamp when entering packet scheduling */
 	SKBTX_SCHED_TSTAMP = 1 << 6,
+
+	/* generate hardware DMA time stamp */
+	SKBTX_HW_DMA_TSTAMP = 1 << 7,
 };
 
 #define SKBTX_ANY_SW_TSTAMP	(SKBTX_SW_TSTAMP    | \
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index 4966d5ca521f..c9e113cea883 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -31,8 +31,9 @@ enum {
 	SOF_TIMESTAMPING_OPT_PKTINFO = (1<<13),
 	SOF_TIMESTAMPING_OPT_TX_SWHW = (1<<14),
 	SOF_TIMESTAMPING_BIND_PHC = (1 << 15),
+	SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH = (1 << 16),
 
-	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_BIND_PHC,
+	SOF_TIMESTAMPING_LAST = SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH,
 	SOF_TIMESTAMPING_MASK = (SOF_TIMESTAMPING_LAST - 1) |
 				 SOF_TIMESTAMPING_LAST
 };
@@ -45,7 +46,8 @@ enum {
 #define SOF_TIMESTAMPING_TX_RECORD_MASK	(SOF_TIMESTAMPING_TX_HARDWARE | \
 					 SOF_TIMESTAMPING_TX_SOFTWARE | \
 					 SOF_TIMESTAMPING_TX_SCHED | \
-					 SOF_TIMESTAMPING_TX_ACK)
+					 SOF_TIMESTAMPING_TX_ACK | \
+					 SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH)
 
 /**
  * struct so_timestamping - SO_TIMESTAMPING parameter
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index f2a178d162ef..24f8e7f9b4a5 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -403,6 +403,7 @@ const char sof_timestamping_names[][ETH_GSTRING_LEN] = {
 	[const_ilog2(SOF_TIMESTAMPING_OPT_PKTINFO)]  = "option-pktinfo",
 	[const_ilog2(SOF_TIMESTAMPING_OPT_TX_SWHW)]  = "option-tx-swhw",
 	[const_ilog2(SOF_TIMESTAMPING_BIND_PHC)]     = "bind-phc",
+	[const_ilog2(SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH)]	= "hardware-dma-transmit",
 };
 static_assert(ARRAY_SIZE(sof_timestamping_names) == __SOF_TIMESTAMPING_CNT);
 
diff --git a/net/socket.c b/net/socket.c
index ab5d8973e719..9e2175685f4e 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -695,6 +695,9 @@ void __sock_tx_timestamp(__u32 tsflags, __u8 *tx_flags)
 			flags |= SKBTX_HW_TSTAMP_USE_CYCLES;
 	}
 
+	if (tsflags & SOF_TIMESTAMPING_TX_HARDWARE_DMA_FETCH)
+		flags |= SKBTX_HW_DMA_TSTAMP;
+
 	if (tsflags & SOF_TIMESTAMPING_TX_SOFTWARE)
 		flags |= SKBTX_SW_TSTAMP;
 
-- 
2.17.1

