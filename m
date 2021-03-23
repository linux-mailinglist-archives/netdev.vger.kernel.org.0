Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAA734685D
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbhCWTBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:01:06 -0400
Received: from mga07.intel.com ([134.134.136.100]:10829 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232917AbhCWTA1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 15:00:27 -0400
IronPort-SDR: 72jk0o4oupJK7QqkTveSgaWL8xv2r5Sqp6AI+h3lh68p/gs8wTKopB62jDFq2tA0DrdJDEyQwS
 6l1743g3p7QA==
X-IronPort-AV: E=McAfee;i="6000,8403,9932"; a="254545852"
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="254545852"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2021 12:00:25 -0700
IronPort-SDR: eXbwu4/IH8noAyeEaZTJrDIAvlwAOh3R6/LDEQlgRspmi4H1xaleR2XKRer7Rbg/EpieOk1MyK
 IO1Jq2Lkf/SQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,272,1610438400"; 
   d="scan'208";a="381460666"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga007.fm.intel.com with ESMTP; 23 Mar 2021 12:00:25 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        anthony.l.nguyen@intel.com
Subject: [PATCH net-next 07/10] ixgbe: Fix fall-through warnings for Clang
Date:   Tue, 23 Mar 2021 12:01:46 -0700
Message-Id: <20210323190149.3160859-8-anthony.l.nguyen@intel.com>
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c  | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c    | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c    | 1 +
 4 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index f9a31f1ac7bc..e324e42fab2d 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
@@ -1542,6 +1542,7 @@ s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 	switch (input_mask->formatted.vm_pool & 0x7F) {
 	case 0x0:
 		fdirm |= IXGBE_FDIRM_POOL;
+		break;
 	case 0x7F:
 		break;
 	default:
@@ -1557,6 +1558,7 @@ s32 ixgbe_fdir_set_input_mask_82599(struct ixgbe_hw *hw,
 			hw_dbg(hw, " Error on src/dst port mask\n");
 			return IXGBE_ERR_CONFIG;
 		}
+		break;
 	case IXGBE_ATR_L4TYPE_MASK:
 		break;
 	default:
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
index 9521d335ea07..03ccbe6b66d2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_common.c
@@ -93,6 +93,7 @@ bool ixgbe_device_supports_autoneg_fc(struct ixgbe_hw *hw)
 		default:
 			break;
 		}
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
index df389a11d3af..0218f6c9b925 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c
@@ -132,6 +132,7 @@ static void ixgbe_get_first_reg_idx(struct ixgbe_adapter *adapter, u8 tc,
 			else
 				*tx = (tc + 4) << 4;	/* 96, 112 */
 		}
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
index 22a874eee2e8..23ddfd79fc8b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c
@@ -999,6 +999,7 @@ static int ixgbe_ptp_set_timestamp_mode(struct ixgbe_adapter *adapter,
 	switch (config->tx_type) {
 	case HWTSTAMP_TX_OFF:
 		tsync_tx_ctl = 0;
+		break;
 	case HWTSTAMP_TX_ON:
 		break;
 	default:
-- 
2.26.2

