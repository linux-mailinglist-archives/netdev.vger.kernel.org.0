Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFAB7602037
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 03:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbiJRBJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 21:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbiJRBJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 21:09:46 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DC7E00
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 18:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666055364; x=1697591364;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=/fIBo7hgaZxh4uv3Wc6ZmEJ4CD1I02BsVLcw1qCiQyE=;
  b=bQGk1DJpbXG6miNKCSQuygTEUkSJBIIjJjb7UF+o4qfv/aiqxlir8iIa
   7obelDoKr5zU7mUwKOmxklKNXYFaUU/tYrpsgi+qEpJfNkmipjjExUS2v
   wLFsbMntChfDsx1JVqL3G9QfCPJXWdlBrG7VQbwGHdD06hYzNvzWlglxp
   CInVWSxo44k8l8nVV3Mm1qp1Ejpq9Y2Zhx9bXGme+NgDGwjFkmpv7hw1n
   savLkRMSJIov3pNqngGbUzRXnRFKoxSe0uy8hPqLa6m5g/nnsRec5hzRr
   Ls0+bXS4Vc6xjlnti/VCM8+GBUJC7um9NEyYmrV9vdgMxGi5zyywT1CWK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="392264217"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="392264217"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Oct 2022 18:09:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10503"; a="717704470"
X-IronPort-AV: E=Sophos;i="5.95,192,1661842800"; 
   d="scan'208";a="717704470"
Received: from zulkifl3-ilbpg0.png.intel.com ([10.88.229.82])
  by FMSMGA003.fm.intel.com with ESMTP; 17 Oct 2022 18:09:19 -0700
From:   Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
To:     intel-wired-lan@osuosl.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, aravindhan.gunasekaran@intel.com,
        richardcochran@gmail.com, gal@nvidia.com, saeed@kernel.org,
        leon@kernel.org, michael.chan@broadcom.com, andy@greyhouse.net,
        muhammad.husaini.zulkifli@intel.com, vinicius.gomes@intel.com
Subject: [PATCH v2 5/5] ethtool: Add support for HWTSTAMP_FILTER_DMA_TIMESTAMP
Date:   Tue, 18 Oct 2022 09:07:33 +0800
Message-Id: <20221018010733.4765-6-muhammad.husaini.zulkifli@intel.com>
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

Add new HWTSTAMP_FILTER_DMA_TIMESTAMP receive filters.
This filter can be configured for devices that support/allow the
DMA timestamp retrieval on receive side.

Signed-off-by: Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
---
 drivers/net/ethernet/intel/igc/igc_ptp.c | 1 +
 include/uapi/linux/net_tstamp.h          | 3 +++
 net/core/dev_ioctl.c                     | 1 +
 net/ethtool/common.c                     | 1 +
 4 files changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 631972d7e97b..39ed759f9057 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -637,6 +637,7 @@ static int igc_ptp_set_timestamp_mode(struct igc_adapter *adapter,
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
 	case HWTSTAMP_FILTER_NTP_ALL:
+	case HWTSTAMP_FILTER_DMA_TIMESTAMP:
 	case HWTSTAMP_FILTER_ALL:
 		igc_ptp_enable_rx_timestamp(adapter);
 		config->rx_filter = HWTSTAMP_FILTER_ALL;
diff --git a/include/uapi/linux/net_tstamp.h b/include/uapi/linux/net_tstamp.h
index c9e113cea883..e72261ed879f 100644
--- a/include/uapi/linux/net_tstamp.h
+++ b/include/uapi/linux/net_tstamp.h
@@ -177,6 +177,9 @@ enum hwtstamp_rx_filters {
 	/* NTP, UDP, all versions and packet modes */
 	HWTSTAMP_FILTER_NTP_ALL,
 
+	/* DMA time stamp packet */
+	HWTSTAMP_FILTER_DMA_TIMESTAMP,
+
 	/* add new constants above here */
 	__HWTSTAMP_FILTER_CNT
 };
diff --git a/net/core/dev_ioctl.c b/net/core/dev_ioctl.c
index 7674bb9f3076..963327472c26 100644
--- a/net/core/dev_ioctl.c
+++ b/net/core/dev_ioctl.c
@@ -229,6 +229,7 @@ static int net_hwtstamp_validate(struct ifreq *ifr)
 	case HWTSTAMP_FILTER_PTP_V2_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
+	case HWTSTAMP_FILTER_DMA_TIMESTAMP:
 		rx_filter_valid = 1;
 		break;
 	case __HWTSTAMP_FILTER_CNT:
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index 24f8e7f9b4a5..fe6e5dfdfcce 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -438,6 +438,7 @@ const char ts_rx_filter_names[][ETH_GSTRING_LEN] = {
 	[HWTSTAMP_FILTER_PTP_V2_SYNC]		= "ptpv2-sync",
 	[HWTSTAMP_FILTER_PTP_V2_DELAY_REQ]	= "ptpv2-delay-req",
 	[HWTSTAMP_FILTER_NTP_ALL]		= "ntp-all",
+	[HWTSTAMP_FILTER_DMA_TIMESTAMP]		= "dma-timestamp",
 };
 static_assert(ARRAY_SIZE(ts_rx_filter_names) == __HWTSTAMP_FILTER_CNT);
 
-- 
2.17.1

