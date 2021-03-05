Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2CB32E44E
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 10:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhCEJFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Mar 2021 04:05:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:57092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229589AbhCEJFO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Mar 2021 04:05:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B4664F4F;
        Fri,  5 Mar 2021 09:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614935114;
        bh=W0doVExi+7l5tGvbjfwECBr+mScLF6o8Q5o+wMEAbOQ=;
        h=Date:From:To:Cc:Subject:From;
        b=uPEEz0YF8G2J+UnsF0n3wskkD9GHvbdojuQlw9HujLPi/tL0CWTduYIx9gUtAORHt
         1KlxbV2H+A7t5odKqdJu/6HlauGlcAb9ekch/pK8U4ezhQBirL6ThTqYdCEmRNNSW3
         IDm8QUxOQxxBhmtYE/8rZun5yN1JzPZ2CZ+D3GuCYct9kXK3MVxXgPxq2gTm/1UhGl
         9dFuy14ShZfXp7STYqy/xWfuugwUnkHTOeWq2hjJgHvTjRVFBkFUPp1RCaj36yZhgQ
         S1Ouk2LD2wSqkL+ArCHVUH7/9jC+Nie9CnrYwTSB+EjVrcBKvrRGMESj2VJ82Jr5bT
         4fPgGPIRcsuVA==
Date:   Fri, 5 Mar 2021 03:05:11 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH RESEND][next] igb: Fix fall-through warnings for Clang
Message-ID: <20210305090511.GA139181@embeddedor>
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

