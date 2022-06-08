Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED752542FB3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 14:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238577AbiFHMEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 08:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbiFHMD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 08:03:58 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B578115CB9;
        Wed,  8 Jun 2022 05:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654689838; x=1686225838;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8+59vdbtwdJ9mUcZg9lTLgsNCEcr0zI48wsgtLiBnQg=;
  b=htn9Btg1aKEEiORnPH6UoK69drkvWNxU1avV8ASC+ZSXwmd9A3kye3Wq
   wvYk7vhGAsGqgsYc5e3J2vjxRpn9YiRdTayeaZTIwmzXV/pU/tNpZ/SYO
   iJWeqTJ/hJqaIyUnoqdbgVE+ygSNIF0Met6Ka028Yo1Iv7cTzTBJDAx5m
   ZT6K4/oWyzs8JEaJRbvR3v+X7REiW5ZoB7QyFkF1zHzABFf7cYJKZUEVG
   EviuJ2K5iPzJN+pKl3GSm78nj8DGWrK7PMQe867uARAPnLrMLDkFEjvVN
   ygKE28BLPQJbRENzRD1/ZwCySZqMLHN8mi16n64aC8b/dy7k0TIdT6b5Y
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10371"; a="274397797"
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="274397797"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2022 05:03:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,286,1647327600"; 
   d="scan'208";a="648576519"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga004.fm.intel.com with ESMTP; 08 Jun 2022 05:03:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id C60074E5; Wed,  8 Jun 2022 15:03:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 net-next 3/5] ptp_ocp: drop duplicate NULL check in ptp_ocp_detach()
Date:   Wed,  8 Jun 2022 15:03:56 +0300
Message-Id: <20220608120358.81147-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
References: <20220608120358.81147-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since platform_device_unregister() is NULL-aware, we don't need to duplicate
this check. Remove it and fold the rest of the code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_ocp.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_ocp.c b/drivers/ptp/ptp_ocp.c
index 926add7be9a2..4e237f806085 100644
--- a/drivers/ptp/ptp_ocp.c
+++ b/drivers/ptp/ptp_ocp.c
@@ -3701,10 +3701,8 @@ ptp_ocp_detach(struct ptp_ocp *bp)
 		serial8250_unregister_port(bp->mac_port);
 	if (bp->nmea_port != -1)
 		serial8250_unregister_port(bp->nmea_port);
-	if (bp->spi_flash)
-		platform_device_unregister(bp->spi_flash);
-	if (bp->i2c_ctrl)
-		platform_device_unregister(bp->i2c_ctrl);
+	platform_device_unregister(bp->spi_flash);
+	platform_device_unregister(bp->i2c_ctrl);
 	if (bp->i2c_clk)
 		clk_hw_unregister_fixed_rate(bp->i2c_clk);
 	if (bp->n_irqs)
-- 
2.35.1

