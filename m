Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D31B63E5389
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236645AbhHJGaL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:30:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:31713 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234701AbhHJGaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 02:30:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="211738411"
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="211738411"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2021 23:29:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,309,1620716400"; 
   d="scan'208";a="671561223"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga006.fm.intel.com with ESMTP; 09 Aug 2021 23:29:46 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 66BD558090A;
        Mon,  9 Aug 2021 23:29:44 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net 1/1] net: dsa: sja1105: fix error handling on NULL returned by xpcs_create()
Date:   Tue, 10 Aug 2021 14:35:13 +0800
Message-Id: <20210810063513.1757614-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a possibility xpcs_create() returned a NULL and this is not
handled properly in the sja1105 driver.

Fixed this by using IS_ERR_ON_NULL() instead of IS_ERR().

Fixes: 3ad1d171548e ("net: dsa: sja1105: migrate to xpcs for SGMII")
Cc: Vladimir Olten <vladimir.oltean@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/dsa/sja1105/sja1105_mdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_mdio.c b/drivers/net/dsa/sja1105/sja1105_mdio.c
index 19aea8fb76f6..2c69a759ce6e 100644
--- a/drivers/net/dsa/sja1105/sja1105_mdio.c
+++ b/drivers/net/dsa/sja1105/sja1105_mdio.c
@@ -438,7 +438,7 @@ static int sja1105_mdiobus_pcs_register(struct sja1105_private *priv)
 		}
 
 		xpcs = xpcs_create(mdiodev, priv->phy_mode[port]);
-		if (IS_ERR(xpcs)) {
+		if (IS_ERR_OR_NULL(xpcs)) {
 			rc = PTR_ERR(xpcs);
 			goto out_pcs_free;
 		}
-- 
2.25.1

