Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0A1A2BB2C8
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729739AbgKTSZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:46914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728698AbgKTSZa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:25:30 -0500
Received: from embeddedor (187-162-31-110.static.axtel.net [187.162.31.110])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FF6A2224C;
        Fri, 20 Nov 2020 18:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896729;
        bh=W0doVExi+7l5tGvbjfwECBr+mScLF6o8Q5o+wMEAbOQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a8D/XtnmN3onvQ7+QylrGfLegFPEylbYocI6o4ld6v/HtHfOOwiQBKnNZKFmAHU/i
         9bU8O21b6Msl6ofAQR0dy9g8IGiEbQHFpMI6zAZmMSefS8f/70a6mIvxHAXwMSE5Hk
         HJg8K5Zzu0NSdWOKKoxzzOlG5u/zpNuGHa9t3pIM=
Date:   Fri, 20 Nov 2020 12:25:35 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 009/141] igb: Fix fall-through warnings for Clang
Message-ID: <f4696db7798ce0efd9e1d10ce28f6413a09c3c57.1605896059.git.gustavoars@kernel.org>
References: <cover.1605896059.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1605896059.git.gustavoars@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation to enable -Wimplicit-fallthrough for Clang, fix multiple
warnings by explicitly adding multiple break statements instead of just
letting the code fall through to the next case.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
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
index 28baf203459a..486d3e67d3a9 100644
--- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
+++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
@@ -3022,6 +3022,7 @@ static int igb_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
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
2.27.0

