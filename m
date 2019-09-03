Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECCAA68C5
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 14:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729100AbfICMnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 08:43:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:37579 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728571AbfICMnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 08:43:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Sep 2019 05:43:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,463,1559545200"; 
   d="scan'208";a="382107082"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmsmga005.fm.intel.com with ESMTP; 03 Sep 2019 05:43:00 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id D5964115; Tue,  3 Sep 2019 15:42:59 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/4] can: mcp251x: Call wrapper instead of regulator_disable()
Date:   Tue,  3 Sep 2019 15:42:58 +0300
Message-Id: <20190903124259.60920-4-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
References: <20190903124259.60920-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is no need to check for regulator presence in the ->suspend()
since a wrapper does it for us. Due to this we may unconditionally set
AFTER_SUSPEND_POWER flag.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/can/spi/mcp251x.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 0b7e743ca0a0..6ee0ea51399a 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1162,10 +1162,8 @@ static int __maybe_unused mcp251x_can_suspend(struct device *dev)
 		priv->after_suspend = AFTER_SUSPEND_DOWN;
 	}
 
-	if (!IS_ERR_OR_NULL(priv->power)) {
-		regulator_disable(priv->power);
-		priv->after_suspend |= AFTER_SUSPEND_POWER;
-	}
+	mcp251x_power_enable(priv->power, 0);
+	priv->after_suspend |= AFTER_SUSPEND_POWER;
 
 	return 0;
 }
-- 
2.23.0.rc1

