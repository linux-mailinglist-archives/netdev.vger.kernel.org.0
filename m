Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC8C32D336
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:34:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbhCDMd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:33:27 -0500
Received: from mga03.intel.com ([134.134.136.65]:7096 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240804AbhCDMdS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:33:18 -0500
IronPort-SDR: 3B8ta3DjdgKemkJHkmCdOIENWWb5IwgaVR7Lfz6Jt1Mg8HfZuYPnjcB5CCmD6zInhvDtrJ3yk1
 ExOToNAUSGBQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="187458396"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="187458396"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: TgOHlBOLtg0uXIgwllcPWspByUaBsi7hlnnZV29ENJhC4pzoRDNdTblHIpBrtTJOpqWzQ6TwRZ
 tV+R+bVlfXNQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="384428151"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id A3B8E4E4; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Isaac Hazan <isaac.hazan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lukas Wunner <lukas@wunner.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 12/18] thunderbolt: Drop unused tb_port_set_initial_credits()
Date:   Thu,  4 Mar 2021 15:31:19 +0300
Message-Id: <20210304123125.43630-13-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function is not used anymore in the driver so we can remove it.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/switch.c | 22 ----------------------
 drivers/thunderbolt/tb.h     |  1 -
 2 files changed, 23 deletions(-)

diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 218869c6ee21..7ac37a1f95e1 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -626,28 +626,6 @@ int tb_port_add_nfc_credits(struct tb_port *port, int credits)
 			     TB_CFG_PORT, ADP_CS_4, 1);
 }
 
-/**
- * tb_port_set_initial_credits() - Set initial port link credits allocated
- * @port: Port to set the initial credits
- * @credits: Number of credits to to allocate
- *
- * Set initial credits value to be used for ingress shared buffering.
- */
-int tb_port_set_initial_credits(struct tb_port *port, u32 credits)
-{
-	u32 data;
-	int ret;
-
-	ret = tb_port_read(port, &data, TB_CFG_PORT, ADP_CS_5, 1);
-	if (ret)
-		return ret;
-
-	data &= ~ADP_CS_5_LCA_MASK;
-	data |= (credits << ADP_CS_5_LCA_SHIFT) & ADP_CS_5_LCA_MASK;
-
-	return tb_port_write(port, &data, TB_CFG_PORT, ADP_CS_5, 1);
-}
-
 /**
  * tb_port_clear_counter() - clear a counter in TB_CFG_COUNTER
  * @port: Port whose counters to clear
diff --git a/drivers/thunderbolt/tb.h b/drivers/thunderbolt/tb.h
index d6ad45686488..ec8cdbc761fa 100644
--- a/drivers/thunderbolt/tb.h
+++ b/drivers/thunderbolt/tb.h
@@ -860,7 +860,6 @@ static inline bool tb_switch_tmu_is_enabled(const struct tb_switch *sw)
 
 int tb_wait_for_port(struct tb_port *port, bool wait_if_unplugged);
 int tb_port_add_nfc_credits(struct tb_port *port, int credits);
-int tb_port_set_initial_credits(struct tb_port *port, u32 credits);
 int tb_port_clear_counter(struct tb_port *port, int counter);
 int tb_port_unlock(struct tb_port *port);
 int tb_port_enable(struct tb_port *port);
-- 
2.30.1

