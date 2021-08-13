Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26C743EB580
	for <lists+netdev@lfdr.de>; Fri, 13 Aug 2021 14:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240203AbhHMMaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Aug 2021 08:30:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:59658 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhHMMaG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Aug 2021 08:30:06 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10074"; a="237594553"
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="237594553"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Aug 2021 05:29:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,318,1620716400"; 
   d="scan'208";a="571791078"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga004.jf.intel.com with ESMTP; 13 Aug 2021 05:29:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 76753F9; Fri, 13 Aug 2021 15:29:37 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH v1 net-next 1/7] ptp_pch: use mac_pton()
Date:   Fri, 13 Aug 2021 15:29:26 +0300
Message-Id: <20210813122932.46152-1-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use mac_pton() instead of custom approach.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/ptp/ptp_pch.c | 41 ++++++++++-------------------------------
 1 file changed, 10 insertions(+), 31 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index a17e8cc642c5..76ba94f419ff 100644
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
2.30.2

