Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A09841A654
	for <lists+netdev@lfdr.de>; Tue, 28 Sep 2021 06:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233014AbhI1EPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Sep 2021 00:15:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:12962 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232215AbhI1EPP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Sep 2021 00:15:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10120"; a="224682046"
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="224682046"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2021 21:13:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,328,1624345200"; 
   d="scan'208";a="587094659"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga004.jf.intel.com with ESMTP; 27 Sep 2021 21:13:36 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 5A01D58073D;
        Mon, 27 Sep 2021 21:13:34 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jose Abreu <Jose.Abreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wong Vee Khee <veekhee@gmail.com>
Subject: [PATCH net-next 1/2] net: pcs: xpcs: introduce xpcs_modify() helper function
Date:   Tue, 28 Sep 2021 12:19:37 +0800
Message-Id: <20210928041938.3936497-2-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210928041938.3936497-1-vee.khee.wong@linux.intel.com>
References: <20210928041938.3936497-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases we need to call mdiobus_modify() to avoid calling
mdiobus_write() when it is not required.

Introduce a xpcs_modify() helper function that allow us to call
mdiobus_modify() in the pcs-xpcs module.

Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/pcs/pcs-xpcs.c | 9 +++++++++
 drivers/net/pcs/pcs-xpcs.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index fb0a83dc09ac..da8c81d25edd 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -191,6 +191,15 @@ int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val)
 	return mdiobus_write(bus, addr, reg_addr, val);
 }
 
+int xpcs_modify(struct dw_xpcs *xpcs, int dev, u32 reg, u16 mask, u16 set)
+{
+	u32 reg_addr = mdiobus_c45_addr(dev, reg);
+	struct mii_bus *bus = xpcs->mdiodev->bus;
+	int addr = xpcs->mdiodev->addr;
+
+	return mdiobus_modify(bus, addr, reg_addr, mask, set);
+}
+
 static int xpcs_read_vendor(struct dw_xpcs *xpcs, int dev, u32 reg)
 {
 	return xpcs_read(xpcs, dev, DW_VENDOR | reg);
diff --git a/drivers/net/pcs/pcs-xpcs.h b/drivers/net/pcs/pcs-xpcs.h
index 35651d32a224..fdb870333395 100644
--- a/drivers/net/pcs/pcs-xpcs.h
+++ b/drivers/net/pcs/pcs-xpcs.h
@@ -109,6 +109,7 @@
 
 int xpcs_read(struct dw_xpcs *xpcs, int dev, u32 reg);
 int xpcs_write(struct dw_xpcs *xpcs, int dev, u32 reg, u16 val);
+int xpcs_modify(struct dw_xpcs *xpcs, int dev, u32 reg, u16 mask, u16 set);
 
 int nxp_sja1105_sgmii_pma_config(struct dw_xpcs *xpcs);
 int nxp_sja1110_sgmii_pma_config(struct dw_xpcs *xpcs);
-- 
2.25.1

