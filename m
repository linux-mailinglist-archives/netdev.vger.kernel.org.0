Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E23E34685C
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232598AbhCWTBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:01:05 -0400
Received: from mga07.intel.com ([134.134.136.100]:10824 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232926AbhCWTA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:27 -0400
IronPort-SDR: IMJUzHZSHf2PgvSf4MQnh5jt/LHIIP9UeDEzT6VLvm2uEZ4/TI+4YALd6NRjH6QWaVfEdyplC3
 K4rTvMVDhFDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545854"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545854"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:25 -0700
IronPort-SDR: RbXEqch94fE9sn2QkhqDoWfVQPMqkLjvrrwDPUNltVug3QptmvrNIXhPEqvZb5r99mWdpcC85q
 b7Yg8hQBYoLw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460669"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 08/10] igb: Fix fall-through warnings for Clang
Date:   Tue, 23 Mar 2021 12:01:47 -0700
Message-Id: <20210323190149.3160859-9-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
References: <20210323190149.3160859-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavoars@kernel.org>

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/igb/e1000_phy.c   | 1 +
 drivers/net/ethernet/intel/igb/igb_ethtool.c | 1 +
 drivers/net/ethernet/intel/igb/igb_ptp.c     | 1 +
 3 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/igb/e1000_phy.c b/drivers/net/ethernet/intel/igb/e1000_phy.c
index 8c8eb82e6272..a018000f7db9 100644
--- a/drivers/net/ethernet/intel/igb/e1000_phy.c
+++ b/drivers/net/ethernet/intel/igb/e1000_phy.c
@@ -836,6 +836,7 @@ s32 igb_copper_link_setup_igp(struct e1000_hw *hw)
 			break;
 		case e1000_ms_auto:
 			data &= ~CR_1000T_MS_ENABLE;
+			break;
 		default:
 			break;
 		}
diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/ethernet/intel/igb/igb_ethtool.c
index 4ab9f468f08e..7545da216d8b 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -3010,6 +3010,7 @@ static int igb_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 		break;
 	case ETHTOOL_SRXCLSRLDEL:
 		ret = igb_del_ethtool_nfc_entry(adapter, cmd);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/igb/igb_ptp.c b/drivers/net/ethernet/intel/igb/igb_ptp.c
index 7cc5428c3b3d..f3ff565da0a1 100644
--- a/drivers/net/ethernet/intel/igb/igb_ptp.c
+++ b/drivers/net/ethernet/intel/igb/igb_ptp.c
@@ -1008,6 +1008,7 @@ static int igb_ptp_set_timestamp_mode(struct igb_adapter *adapter,
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tsync_tx_ctl = 0;
+		break;
 	case HWTSTAMP_TX_ON:
 		break;
 	default:
-- 
2.26.2

