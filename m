Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3561F47C5D8
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 19:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240934AbhLUSJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 13:09:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:9404 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240915AbhLUSJF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 13:09:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640110145; x=1671646145;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tHhS+lVwwEJxmbreQtokzAVl9+h5DkfiEkXvztMzB5w=;
  b=bQkj+iDtvB9470dArFvWuz92RArphQYF5HtvHjJInX9r8DBg/91+R5E8
   OBiyuRAP2FgsS79oy4N3qlWeMbGY3H0YFW4JEd4ve7vdCM//h4dApAfz/
   YcAUmh1k6dE4uhrgd4sTri8GN5QOL4Wr2faULSSLttxW+CMwyOB2b4pOe
   3rxFJTxgieNzkBE1kisw909DCyadNDfJErjWMlP8L622iCh5empEtW7eV
   MU5pg6yu4kuiY5WLx3nVyyuPrkqz0JV5ZmbQCBmZ/yvOJWJSxLMNnx1Ho
   nKfLVvj5shWhPEJqkG8/3qvlFdLWGdUNP+C9toSqct7QzKat9mRWYptI3
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240264836"
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="240264836"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 09:49:37 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,224,1635231600"; 
   d="scan'208";a="521342485"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by orsmga008.jf.intel.com with ESMTP; 21 Dec 2021 09:49:36 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        anthony.l.nguyen@intel.com, richardcochran@gmail.com,
        Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH net-next 03/10] ice: PTP: move setting of tstamp_config
Date:   Tue, 21 Dec 2021 09:48:38 -0800
Message-Id: <20211221174845.3063640-4-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
References: <20211221174845.3063640-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The tstamp_config structure is being set inside of
ice_ptp_cfg_timestamp, which is the function used to set Tx and
Rx timestamping during initialization.

This function is also used in order to set the PHY port timestamping
status. However, it makes sense to always set the tstamp_config directly
whenever the ice_set_tx_tstamp or ice_set_rx_tstamp functions are
called.

Move assignment of tstamp_config into the related functions and out of
ice_ptp_cfg_timestamp.

Now that we assign the timestamp mode in the relevant functions, we no
longer modify the config value in ice_set_timestamp_mode. In turn, we
no longer want to copy that config value into the PF cached structure.
Instead, this is now the source of truth for actual configuration. On
success of ice_set_timestamp_mode, copy the real configured mode back to
report it out to userspace.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 0afdcda2c8d2..686527c48977 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -281,6 +281,8 @@ static void ice_set_tx_tstamp(struct ice_pf *pf, bool on)
 	else
 		val &= ~PFINT_OICR_TSYN_TX_M;
 	wr32(&pf->hw, PFINT_OICR_ENA, val);
+
+	pf->ptp.tstamp_config.tx_type = on ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
 }
 
 /**
@@ -303,6 +305,9 @@ static void ice_set_rx_tstamp(struct ice_pf *pf, bool on)
 			continue;
 		vsi->rx_rings[i]->ptp_rx = on;
 	}
+
+	pf->ptp.tstamp_config.rx_filter = on ? HWTSTAMP_FILTER_ALL :
+					       HWTSTAMP_FILTER_NONE;
 }
 
 /**
@@ -317,14 +322,6 @@ void ice_ptp_cfg_timestamp(struct ice_pf *pf, bool ena)
 {
 	ice_set_tx_tstamp(pf, ena);
 	ice_set_rx_tstamp(pf, ena);
-
-	if (ena) {
-		pf->ptp.tstamp_config.rx_filter = HWTSTAMP_FILTER_ALL;
-		pf->ptp.tstamp_config.tx_type = HWTSTAMP_TX_ON;
-	} else {
-		pf->ptp.tstamp_config.rx_filter = HWTSTAMP_FILTER_NONE;
-		pf->ptp.tstamp_config.tx_type = HWTSTAMP_TX_OFF;
-	}
 }
 
 /**
@@ -1248,7 +1245,6 @@ ice_ptp_set_timestamp_mode(struct ice_pf *pf, struct hwtstamp_config *config)
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
 	case HWTSTAMP_FILTER_NTP_ALL:
 	case HWTSTAMP_FILTER_ALL:
-		config->rx_filter = HWTSTAMP_FILTER_ALL;
 		ice_set_rx_tstamp(pf, true);
 		break;
 	default:
@@ -1280,8 +1276,8 @@ int ice_ptp_set_ts_config(struct ice_pf *pf, struct ifreq *ifr)
 	if (err)
 		return err;
 
-	/* Save these settings for future reference */
-	pf->ptp.tstamp_config = config;
+	/* Return the actual configuration set */
+	config = pf->ptp.tstamp_config;
 
 	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
 		-EFAULT : 0;
-- 
2.31.1

