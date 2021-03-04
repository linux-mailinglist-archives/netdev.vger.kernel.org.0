Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D897E32D34C
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 13:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240988AbhCDMfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 07:35:02 -0500
Received: from mga04.intel.com ([192.55.52.120]:10302 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240999AbhCDMei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 07:34:38 -0500
IronPort-SDR: byBEoBVaIeCv0zXBxX6fwbzPRJdf+VyNY66Dz0iOGK/d3l3CP+QGueVrw7Yb7qGTDioG1HMH8p
 7Zcwa29Qdt9g==
X-IronPort-AV: E=McAfee;i="6000,8403,9912"; a="184994144"
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="184994144"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2021 04:31:32 -0800
IronPort-SDR: DaQZieLEaGw+ejFw2pBBS5j1M5Y3GwVgbmYpioTP7xt/jzPBg4BEVetYvMXZDyl9NmgsmzIwhf
 FDqgeK4cO4tw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,222,1610438400"; 
   d="scan'208";a="374534676"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga007.fm.intel.com with ESMTP; 04 Mar 2021 04:31:29 -0800
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 69CFF3C1; Thu,  4 Mar 2021 14:31:26 +0200 (EET)
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
Subject: [PATCH 06/18] thunderbolt: Do not re-establish XDomain DMA paths automatically
Date:   Thu,  4 Mar 2021 15:31:13 +0300
Message-Id: <20210304123125.43630-7-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
References: <20210304123125.43630-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This step is actually not needed. The service drivers themselves will
handle this once they have negotiated the service up and running again
with the remote side. Also dropping this makes it easier to add support
for multiple DMA tunnels over a single XDomain connection.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/thunderbolt/xdomain.c | 35 ++---------------------------------
 include/linux/thunderbolt.h   |  2 --
 2 files changed, 2 insertions(+), 35 deletions(-)

diff --git a/drivers/thunderbolt/xdomain.c b/drivers/thunderbolt/xdomain.c
index 584bb5ec06f8..a1657663a95e 100644
--- a/drivers/thunderbolt/xdomain.c
+++ b/drivers/thunderbolt/xdomain.c
@@ -946,19 +946,6 @@ static int populate_properties(struct tb_xdomain *xd,
 	return 0;
 }
 
-/* Called with @xd->lock held */
-static void tb_xdomain_restore_paths(struct tb_xdomain *xd)
-{
-	if (!xd->resume)
-		return;
-
-	xd->resume = false;
-	if (xd->transmit_path) {
-		dev_dbg(&xd->dev, "re-establishing DMA path\n");
-		tb_domain_approve_xdomain_paths(xd->tb, xd);
-	}
-}
-
 static inline struct tb_switch *tb_xdomain_parent(struct tb_xdomain *xd)
 {
 	return tb_to_switch(xd->dev.parent);
@@ -1084,16 +1071,8 @@ static void tb_xdomain_get_properties(struct work_struct *work)
 	mutex_lock(&xd->lock);
 
 	/* Only accept newer generation properties */
-	if (xd->properties && gen <= xd->property_block_gen) {
-		/*
-		 * On resume it is likely that the properties block is
-		 * not changed (unless the other end added or removed
-		 * services). However, we need to make sure the existing
-		 * DMA paths are restored properly.
-		 */
-		tb_xdomain_restore_paths(xd);
+	if (xd->properties && gen <= xd->property_block_gen)
 		goto err_free_block;
-	}
 
 	dir = tb_property_parse_dir(block, ret);
 	if (!dir) {
@@ -1118,8 +1097,6 @@ static void tb_xdomain_get_properties(struct work_struct *work)
 
 	tb_xdomain_update_link_attributes(xd);
 
-	tb_xdomain_restore_paths(xd);
-
 	mutex_unlock(&xd->lock);
 
 	kfree(block);
@@ -1332,15 +1309,7 @@ static int __maybe_unused tb_xdomain_suspend(struct device *dev)
 
 static int __maybe_unused tb_xdomain_resume(struct device *dev)
 {
-	struct tb_xdomain *xd = tb_to_xdomain(dev);
-
-	/*
-	 * Ask tb_xdomain_get_properties() restore any existing DMA
-	 * paths after properties are re-read.
-	 */
-	xd->resume = true;
-	start_handshake(xd);
-
+	start_handshake(tb_to_xdomain(dev));
 	return 0;
 }
 
diff --git a/include/linux/thunderbolt.h b/include/linux/thunderbolt.h
index 659a0a810fa1..7ec977161f5c 100644
--- a/include/linux/thunderbolt.h
+++ b/include/linux/thunderbolt.h
@@ -185,7 +185,6 @@ void tb_unregister_property_dir(const char *key, struct tb_property_dir *dir);
  * @link_speed: Speed of the link in Gb/s
  * @link_width: Width of the link (1 or 2)
  * @is_unplugged: The XDomain is unplugged
- * @resume: The XDomain is being resumed
  * @needs_uuid: If the XDomain does not have @remote_uuid it will be
  *		queried first
  * @transmit_path: HopID which the remote end expects us to transmit
@@ -231,7 +230,6 @@ struct tb_xdomain {
 	unsigned int link_speed;
 	unsigned int link_width;
 	bool is_unplugged;
-	bool resume;
 	bool needs_uuid;
 	u16 transmit_path;
 	u16 transmit_ring;
-- 
2.30.1

