Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8904ACAE2
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 22:09:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236191AbiBGVHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 16:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233961AbiBGVHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 16:07:19 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ED7C061355;
        Mon,  7 Feb 2022 13:07:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644268038; x=1675804038;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=IsKQb5WzONKIwPxjcBemKckXmF3G3s2lwGN3DJvVYfA=;
  b=eZYtM0901GafQTb78UtEJEURSm0JbQUuPSeAEWk9KuzoEX0adWnflPIr
   FS+VAYLHmincrtRlJMu0D3Hpu52bNmjFwnnU8ONsGDTSTqBxdRj14p1nW
   /fo2z90Jh8zAFQrIOAFvYOmnH6d3I1UzsdroRyApglm6qOpnNmNYQssFr
   89r8Gb6/jFJor2ePeG1PbOhdaPhW3BKeZkILYlDdd085DprQP/dFYmNjs
   mSuCeyORmwOoOzQoqump2u+/nRczZa6Ag3daLtk8X8/5mR8aspB6kYDTF
   RaRfR7PofcFlO5RFvo7ikUROt2rT0RUhLkcp3bcjIQ2n7v+WZHDSvq5JN
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="247644788"
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="247644788"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 13:07:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,350,1635231600"; 
   d="scan'208";a="499335212"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga002.jf.intel.com with ESMTP; 07 Feb 2022 13:07:16 -0800
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 44D1B31D; Mon,  7 Feb 2022 23:07:31 +0200 (EET)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v2 net-next 1/6] ptp_pch: use mac_pton()
Date:   Mon,  7 Feb 2022 23:07:25 +0200
Message-Id: <20220207210730.75252-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mac_pton() instead of custom approach.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
v2: no changes
 drivers/ptp/ptp_pch.c | 41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 8070f3fd98f0..cbf7ce3db93a 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -100,7 +100,6 @@ struct pch_ts_regs {
 #define PCH_ECS_ETH		(1 << 0)
 
 #define PCH_ECS_CAN		(1 << 1)
-#define PCH_STATION_BYTES	6
 
 #define PCH_IEEE1588_ETH	(1 << 0)
 #define PCH_IEEE1588_CAN	(1 << 1)
@@ -292,8 +291,9 @@ static void pch_reset(struct pch_dev *chip)
  */
 int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
 {
-	s32 i;
 	struct pch_dev *chip = pci_get_drvdata(pdev);
+	bool valid;
+	u64 mac;
 
 	/* Verify the parameter */
 	if ((chip->regs == NULL) || addr == (u8 *)NULL) {
@@ -301,37 +301,16 @@ int pch_set_station_address(u8 *addr, struct pci_dev *pdev)
 			"invalid params returning PCH_INVALIDPARAM\n");
 		return PCH_INVALIDPARAM;
 	}
-	/* For all station address bytes */
-	for (i = 0; i < PCH_STATION_BYTES; i++) {
-		u32 val;
-		s32 tmp;
 
-		tmp = hex_to_bin(addr[i * 3]);
-		if (tmp < 0) {
-			dev_err(&pdev->dev,
-				"invalid params returning PCH_INVALIDPARAM\n");
-			return PCH_INVALIDPARAM;
-		}
-		val = tmp * 16;
-		tmp = hex_to_bin(addr[(i * 3) + 1]);
-		if (tmp < 0) {
-			dev_err(&pdev->dev,
-				"invalid params returning PCH_INVALIDPARAM\n");
-			return PCH_INVALIDPARAM;
-		}
-		val += tmp;
-		/* Expects ':' separated addresses */
-		if ((i < 5) && (addr[(i * 3) + 2] != ':')) {
-			dev_err(&pdev->dev,
-				"invalid params returning PCH_INVALIDPARAM\n");
-			return PCH_INVALIDPARAM;
-		}
-
-		/* Ideally we should set the address only after validating
-							 entire string */
-		dev_dbg(&pdev->dev, "invoking pch_station_set\n");
-		iowrite32(val, &chip->regs->ts_st[i]);
+	valid = mac_pton(addr, (u8 *)&mac);
+	if (!valid) {
+		dev_err(&pdev->dev, "invalid params returning PCH_INVALIDPARAM\n");
+		return PCH_INVALIDPARAM;
 	}
+
+	dev_dbg(&pdev->dev, "invoking pch_station_set\n");
+	iowrite32(lower_32_bits(mac), &chip->regs->ts_st[0]);
+	iowrite32(upper_32_bits(mac), &chip->regs->ts_st[4]);
 	return 0;
 }
 EXPORT_SYMBOL(pch_set_station_address);
-- 
2.34.1

