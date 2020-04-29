Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 654F11BE21B
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 17:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2PJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 11:09:37 -0400
Received: from mga04.intel.com ([192.55.52.120]:51891 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgD2PJg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 11:09:36 -0400
IronPort-SDR: g/C3perDkehrVL4TL5JyXD+dzKmK3zHsRqslz72Mo64crlCsZMC54fUYld3VFvaXRy+1TmL6Vs
 GzVHMgtirgwA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2020 08:09:36 -0700
IronPort-SDR: WQ7JPyqiixk3tjGBb+d8JzMARm8zJ3Z8nbI5rSzN27DzgvK5Ll2064gPOKVaXONKiJQl6SOnyi
 w440qNlrbDiw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,332,1583222400"; 
   d="scan'208";a="293227924"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga002.fm.intel.com with ESMTP; 29 Apr 2020 08:09:34 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 41993166; Wed, 29 Apr 2020 18:09:32 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: [PATCH v1] stmmac: intel: Fix kernel crash due to wrong error path
Date:   Wed, 29 Apr 2020 18:09:32 +0300
Message-Id: <20200429150932.17927-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unfortunately sometimes ->probe() may fail. The commit b9663b7ca6ff
("net: stmmac: Enable SERDES power up/down sequence")
messed up with error handling and thus:

[   12.811311] ------------[ cut here ]------------
[   12.811993] kernel BUG at net/core/dev.c:9937!

Fix this by properly crafted error path.

Fixes: b9663b7ca6ff ("net: stmmac: Enable SERDES power up/down sequence")
Cc: Voon Weifeng <weifeng.voon@intel.com>
Cc: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 565da6498c846e..ff22f274aa43d6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4991,7 +4991,7 @@ int stmmac_dvr_probe(struct device *device,
 						 priv->plat->bsp_priv);
 
 		if (ret < 0)
-			return ret;
+			goto error_serdes_powerup;
 	}
 
 #ifdef CONFIG_DEBUG_FS
@@ -5000,6 +5000,8 @@ int stmmac_dvr_probe(struct device *device,
 
 	return ret;
 
+error_serdes_powerup:
+	unregister_netdev(ndev);
 error_netdev_register:
 	phylink_destroy(priv->phylink);
 error_phy_setup:
-- 
2.26.2

