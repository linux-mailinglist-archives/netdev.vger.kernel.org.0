Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081EF32E416
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhCEJAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:00:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:55512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229668AbhCEJAD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:00:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D963364EE8;
        Fri,  5 Mar 2021 09:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614934802;
        bh=dMsOIhXGuMLC9cmVk+Focv2+8LwcryL3ponccTcC2cU=;
        h=Date:From:To:Cc:Subject:From;
        b=qLF+qxaeLIRd6Zb1xbi53eTdZBZnFau505mva7w1lqm1lfQ3hRoLQkTrwSSXUXc2U
         NzidIRUcMV9UhZbka6Q5MxBeGxK2jkm8Jmt65Gf66nv+k4ovzQdodJU6XVtbgpu6Ik
         wlUuKkanOUoeWxP07f1Hl1cRiq93gSF7MN+85Wr70DRgZkYYqsfGGCNiMlp0nYbt3m
         QrGP7m64kToiN9IFu0OlD1UMwiuskA7zww0o5veNTxWo5WeIG+EaXTUdcwnjOvlmF5
         BkXk8IIpMPLz6El64DUfcQJlXmQqeDiAn98tn2ohe6wzm6p8MDxBSdNpQv7qSWITWG
         kt+S5t9nxrR+g==
Date:   Fri, 5 Mar 2021 03:00:00 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] ixgbe: Fix fall-through warnings for Clang
Message-ID: <20210305090000.GA138882@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c  | 2 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_common.c | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c    | 1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_ptp.c    | 1 +
 4 files changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c
index 8d3798a32f0e..cdfff510a27b 100644
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
index 62ddb452f862..8d5a01be1d99 100644
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
2.27.0

