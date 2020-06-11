Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81321F709E
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgFKWvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:51:06 -0400
Received: from mga18.intel.com ([134.134.136.126]:54987 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbgFKWvE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:51:04 -0400
IronPort-SDR: JLP0ZLRL7SLrFmw6BMbv0bqMZ3A9BoKHUki4xqQV20WYloEMZZOTFstOpeV4Kw/E5FfZ4d4ZDY
 UvId6GXIWRGg==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 15:51:02 -0700
IronPort-SDR: z1eu16PophvneANCi0nDXG4Nz03GERzTo8SUVg50+wiBusLajd/BsKJvNr2fsIOTSfyCu6jv90
 wCL5N6cfmCmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="296755893"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2020 15:51:02 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Piotr Kwapulinski <piotr.kwapulinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 2/4] iavf: use appropriate enum for comparison
Date:   Thu, 11 Jun 2020 15:50:58 -0700
Message-Id: <20200611225100.326062-3-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
References: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>

adapter->link_speed has type enum virtchnl_link_speed but our comparisons
are against enum iavf_aq_link_speed. Though they are, currently, the same
values, change the comparison to the matching enum virtchnl_link_speed
since that may not always be the case.

Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Piotr Kwapulinski <piotr.kwapulinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c  | 17 ++++++-----------
 drivers/net/ethernet/intel/iavf/iavf_main.c     | 12 ++++++------
 drivers/net/ethernet/intel/iavf/iavf_txrx.c     | 12 ++++++------
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c | 12 ++++++------
 4 files changed, 24 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index 40a3fc7c5ea5..b29a5979cce2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -291,27 +291,22 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
 	}
 
 	switch (adapter->link_speed) {
-	case IAVF_LINK_SPEED_40GB:
+	case VIRTCHNL_LINK_SPEED_40GB:
 		cmd->base.speed = SPEED_40000;
 		break;
-	case IAVF_LINK_SPEED_25GB:
-#ifdef SPEED_25000
+	case VIRTCHNL_LINK_SPEED_25GB:
 		cmd->base.speed = SPEED_25000;
-#else
-		netdev_info(netdev,
-			    "Speed is 25G, display not supported by this version of ethtool.\n");
-#endif
 		break;
-	case IAVF_LINK_SPEED_20GB:
+	case VIRTCHNL_LINK_SPEED_20GB:
 		cmd->base.speed = SPEED_20000;
 		break;
-	case IAVF_LINK_SPEED_10GB:
+	case VIRTCHNL_LINK_SPEED_10GB:
 		cmd->base.speed = SPEED_10000;
 		break;
-	case IAVF_LINK_SPEED_1GB:
+	case VIRTCHNL_LINK_SPEED_1GB:
 		cmd->base.speed = SPEED_1000;
 		break;
-	case IAVF_LINK_SPEED_100MB:
+	case VIRTCHNL_LINK_SPEED_100MB:
 		cmd->base.speed = SPEED_100;
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a21ae74bcd1b..922f20962a29 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2498,22 +2498,22 @@ static int iavf_validate_tx_bandwidth(struct iavf_adapter *adapter,
 	}
 
 	switch (adapter->link_speed) {
-	case IAVF_LINK_SPEED_40GB:
+	case VIRTCHNL_LINK_SPEED_40GB:
 		speed = 40000;
 		break;
-	case IAVF_LINK_SPEED_25GB:
+	case VIRTCHNL_LINK_SPEED_25GB:
 		speed = 25000;
 		break;
-	case IAVF_LINK_SPEED_20GB:
+	case VIRTCHNL_LINK_SPEED_20GB:
 		speed = 20000;
 		break;
-	case IAVF_LINK_SPEED_10GB:
+	case VIRTCHNL_LINK_SPEED_10GB:
 		speed = 10000;
 		break;
-	case IAVF_LINK_SPEED_1GB:
+	case VIRTCHNL_LINK_SPEED_1GB:
 		speed = 1000;
 		break;
-	case IAVF_LINK_SPEED_100MB:
+	case VIRTCHNL_LINK_SPEED_100MB:
 		speed = 100;
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/iavf/iavf_txrx.c b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
index 7a30d5d5ef53..e091bab7e770 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_txrx.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_txrx.c
@@ -379,19 +379,19 @@ static inline unsigned int iavf_itr_divisor(struct iavf_q_vector *q_vector)
 	unsigned int divisor;
 
 	switch (q_vector->adapter->link_speed) {
-	case IAVF_LINK_SPEED_40GB:
+	case VIRTCHNL_LINK_SPEED_40GB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 1024;
 		break;
-	case IAVF_LINK_SPEED_25GB:
-	case IAVF_LINK_SPEED_20GB:
+	case VIRTCHNL_LINK_SPEED_25GB:
+	case VIRTCHNL_LINK_SPEED_20GB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 512;
 		break;
 	default:
-	case IAVF_LINK_SPEED_10GB:
+	case VIRTCHNL_LINK_SPEED_10GB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 256;
 		break;
-	case IAVF_LINK_SPEED_1GB:
-	case IAVF_LINK_SPEED_100MB:
+	case VIRTCHNL_LINK_SPEED_1GB:
+	case VIRTCHNL_LINK_SPEED_100MB:
 		divisor = IAVF_ITR_ADAPTIVE_MIN_INC * 32;
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index ca79bec4ebd9..c4735589a296 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -921,22 +921,22 @@ static void iavf_print_link_message(struct iavf_adapter *adapter)
 	}
 
 	switch (adapter->link_speed) {
-	case IAVF_LINK_SPEED_40GB:
+	case VIRTCHNL_LINK_SPEED_40GB:
 		link_speed_mbps = SPEED_40000;
 		break;
-	case IAVF_LINK_SPEED_25GB:
+	case VIRTCHNL_LINK_SPEED_25GB:
 		link_speed_mbps = SPEED_25000;
 		break;
-	case IAVF_LINK_SPEED_20GB:
+	case VIRTCHNL_LINK_SPEED_20GB:
 		link_speed_mbps = SPEED_20000;
 		break;
-	case IAVF_LINK_SPEED_10GB:
+	case VIRTCHNL_LINK_SPEED_10GB:
 		link_speed_mbps = SPEED_10000;
 		break;
-	case IAVF_LINK_SPEED_1GB:
+	case VIRTCHNL_LINK_SPEED_1GB:
 		link_speed_mbps = SPEED_1000;
 		break;
-	case IAVF_LINK_SPEED_100MB:
+	case VIRTCHNL_LINK_SPEED_100MB:
 		link_speed_mbps = SPEED_100;
 		break;
 	default:
-- 
2.26.2

