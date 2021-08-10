Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31AF63E5600
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbhHJIxP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:53:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:50893 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238379AbhHJIxJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:53:09 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10070"; a="214848951"
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="214848951"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 01:52:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,310,1620716400"; 
   d="scan'208";a="674839874"
Received: from linux.intel.com ([10.54.29.200])
  by fmsmga005.fm.intel.com with ESMTP; 10 Aug 2021 01:52:45 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id 1EE15580922;
        Tue, 10 Aug 2021 01:52:42 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 1/1] net: pcs: xpcs: fix error handling on failed to allocate memory
Date:   Tue, 10 Aug 2021 16:58:12 +0800
Message-Id: <20210810085812.1808466-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drivers such as sja1105 and stmmac that call xpcs_create() expects an
error returned by the pcs-xpcs module, but this was not the case on
failed to allocate memory.

Fixed this by returning an -ENOMEM instead of a NULL pointer.

Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/pcs/pcs-xpcs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 63fda3fc40aa..4bd61339823c 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -1089,7 +1089,7 @@ struct dw_xpcs *xpcs_create(struct mdio_device *mdiodev,
 
 	xpcs = kzalloc(sizeof(*xpcs), GFP_KERNEL);
 	if (!xpcs)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 
 	xpcs->mdiodev = mdiodev;
 
-- 
2.25.1

