Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85B6C24255
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 22:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfETUzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 16:55:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:25739 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbfETUzF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 16:55:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 13:55:04 -0700
X-ExtLoop1: 1
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga008.jf.intel.com with ESMTP; 20 May 2019 13:55:01 -0700
From:   Weifeng Voon <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Weifeng Voon <weifeng.voon@intel.com>
Subject: [PATCH net] net: stmmac: fix ethtool flow control not able to get/set
Date:   Tue, 21 May 2019 12:55:42 +0800
Message-Id: <1558414542-28550-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Tan, Tee Min" <tee.min.tan@intel.com>

Currently ethtool was not able to get/set the flow control due to a
missing "!". It will always return -EOPNOTSUPP even the device is
flow control supported.

This patch fixes the condition check for ethtool flow control get/set
function for ETHTOOL_LINK_MODE_Asym_Pause_BIT.

Fixes: 3c1bcc8614db (“net: ethernet: Convert phydev advertize and supported from u32 to link mode”)
Signed-off-by: Tan, Tee Min <tee.min.tan@intel.com>
Reviewed-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon, Weifeng <weifeng.voon@intel.com@intel.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
index 3c749c3..e09522c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_ethtool.c
@@ -460,7 +460,7 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	} else {
 		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 				       netdev->phydev->supported) ||
-		    linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+		    !linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 				      netdev->phydev->supported))
 			return;
 	}
@@ -491,7 +491,7 @@ static void stmmac_ethtool_gregs(struct net_device *dev,
 	} else {
 		if (!linkmode_test_bit(ETHTOOL_LINK_MODE_Pause_BIT,
 				       phy->supported) ||
-		    linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+		    !linkmode_test_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
 				      phy->supported))
 			return -EOPNOTSUPP;
 	}
-- 
1.9.1

