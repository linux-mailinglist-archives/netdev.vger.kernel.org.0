Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D65E01F70A0
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 00:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgFKWvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 18:51:12 -0400
Received: from mga18.intel.com ([134.134.136.126]:54987 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726331AbgFKWvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 18:51:05 -0400
IronPort-SDR: YY1M8Jhghf/RWG73btUHsFe8vxoyQV72ukl2DtQQtm/mpqI26XMaQZ7tUbIKdEa06IJMFGREXD
 KE2DwnnhaQBQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 15:51:03 -0700
IronPort-SDR: 5GCY8dwiKrsiMfOtzRXgDi1rH8jaq3wMMTU733qdioKizjAgGnA7YvKOZM2IfxQtSbwEuLgg8t
 H+YA7Ysf9M2A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="296755896"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 11 Jun 2020 15:51:02 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Brett Creeley <brett.creeley@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Witold Fijalkowski <witoldx.fijalkowski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net 3/4] iavf: Fix reporting 2.5 Gb and 5Gb speeds
Date:   Thu, 11 Jun 2020 15:50:59 -0700
Message-Id: <20200611225100.326062-4-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
References: <20200611225100.326062-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Brett Creeley <brett.creeley@intel.com>

Commit 4ae4916b5643 ("i40e: fix 'Unknown bps' in dmesg for 2.5Gb/5Gb
speeds") added the ability for the PF to report 2.5 and 5Gb speeds,
however, the iavf driver does not recognize those speeds as the values were
not added there. Add the proper enums and values so that iavf can properly
deal with those speeds.

Fixes: 4ae4916b5643 ("i40e: fix 'Unknown bps' in dmesg for 2.5Gb/5Gb speeds")
Signed-off-by: Brett Creeley <brett.creeley@intel.com>
Signed-off-by: Witold Fijalkowski <witoldx.fijalkowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/iavf/iavf_ethtool.c |  6 ++++++
 drivers/net/ethernet/intel/iavf/iavf_main.c    | 18 ++++++++++++------
 .../net/ethernet/intel/iavf/iavf_virtchnl.c    |  6 ++++++
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
index b29a5979cce2..181573822942 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -303,6 +303,12 @@ static int iavf_get_link_ksettings(struct net_device *netdev,
 	case VIRTCHNL_LINK_SPEED_10GB:
 		cmd->base.speed = SPEED_10000;
 		break;
+	case VIRTCHNL_LINK_SPEED_5GB:
+		cmd->base.speed = SPEED_5000;
+		break;
+	case VIRTCHNL_LINK_SPEED_2_5GB:
+		cmd->base.speed = SPEED_2500;
+		break;
 	case VIRTCHNL_LINK_SPEED_1GB:
 		cmd->base.speed = SPEED_1000;
 		break;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 922f20962a29..06c481e9ac5c 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -2499,22 +2499,28 @@ static int iavf_validate_tx_bandwidth(struct iavf_adapter *adapter,
 
 	switch (adapter->link_speed) {
 	case VIRTCHNL_LINK_SPEED_40GB:
-		speed = 40000;
+		speed = SPEED_40000;
 		break;
 	case VIRTCHNL_LINK_SPEED_25GB:
-		speed = 25000;
+		speed = SPEED_25000;
 		break;
 	case VIRTCHNL_LINK_SPEED_20GB:
-		speed = 20000;
+		speed = SPEED_20000;
 		break;
 	case VIRTCHNL_LINK_SPEED_10GB:
-		speed = 10000;
+		speed = SPEED_10000;
+		break;
+	case VIRTCHNL_LINK_SPEED_5GB:
+		speed = SPEED_5000;
+		break;
+	case VIRTCHNL_LINK_SPEED_2_5GB:
+		speed = SPEED_2500;
 		break;
 	case VIRTCHNL_LINK_SPEED_1GB:
-		speed = 1000;
+		speed = SPEED_1000;
 		break;
 	case VIRTCHNL_LINK_SPEED_100MB:
-		speed = 100;
+		speed = SPEED_100;
 		break;
 	default:
 		break;
diff --git a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
index c4735589a296..ed08ace4f05a 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_virtchnl.c
@@ -933,6 +933,12 @@ static void iavf_print_link_message(struct iavf_adapter *adapter)
 	case VIRTCHNL_LINK_SPEED_10GB:
 		link_speed_mbps = SPEED_10000;
 		break;
+	case VIRTCHNL_LINK_SPEED_5GB:
+		link_speed_mbps = SPEED_5000;
+		break;
+	case VIRTCHNL_LINK_SPEED_2_5GB:
+		link_speed_mbps = SPEED_2500;
+		break;
 	case VIRTCHNL_LINK_SPEED_1GB:
 		link_speed_mbps = SPEED_1000;
 		break;
-- 
2.26.2

