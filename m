Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42DE69D4E5
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 19:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732384AbfHZR02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 13:26:28 -0400
Received: from mga07.intel.com ([134.134.136.100]:28145 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729131AbfHZR02 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Aug 2019 13:26:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Aug 2019 10:26:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,433,1559545200"; 
   d="scan'208";a="185020492"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga006.jf.intel.com with ESMTP; 26 Aug 2019 10:26:25 -0700
Received: by black.fi.intel.com (Postfix, from userid 1003)
        id 8707A10B; Mon, 26 Aug 2019 20:26:24 +0300 (EEST)
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 3/3] can: mcp251x: Call wrapper instead of regulator_disable()
Date:   Mon, 26 Aug 2019 20:26:23 +0300
Message-Id: <20190826172623.79378-3-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.23.0.rc1
In-Reply-To: <20190826172623.79378-1-andriy.shevchenko@linux.intel.com>
References: <20190826172623.79378-1-andriy.shevchenko@linux.intel.com>
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

