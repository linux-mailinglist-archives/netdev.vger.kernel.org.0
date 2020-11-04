Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C3F2A680D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 16:49:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730802AbgKDPt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 10:49:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730625AbgKDPtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 10:49:25 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kaL2G-005Ebh-2E; Wed, 04 Nov 2020 16:49:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        David Laight <David.Laight@ACULAB.COM>,
        Lee Jones <lee.jones@linaro.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next v2 4/7] drivers: net: smc911x: Fix set but unused status because of DBG macro
Date:   Wed,  4 Nov 2020 16:48:55 +0100
Message-Id: <20201104154858.1247725-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201104154858.1247725-1-andrew@lunn.ch>
References: <20201104154858.1247725-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/ethernet/smsc/smc911x.c: In function ‘smc911x_timeout’:
drivers/net/ethernet/smsc/smc911x.c:1251:6: warning: variable ‘status’ set but not used [-Wunused-but-set-variable]
 1251 |  int status, mask;

The status is read in order to print it via the DBG macro. However,
due to the way DBG is disabled, the compiler never sees it being used.

Change the DBG macro to actually make use of the passed parameters,
and the leave the optimiser to remove the unwanted code inside the
while (0).

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 8f748a0c057e..6978050496ac 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -102,7 +102,10 @@ MODULE_ALIAS("platform:smc911x");
 
 #define PRINTK(dev, args...)   netdev_info(dev, args)
 #else
-#define DBG(n, dev, args...)   do { } while (0)
+#define DBG(n, dev, args...)			 \
+	while (0) {				 \
+		netdev_dbg(dev, args);		 \
+	}
 #define PRINTK(dev, args...)   netdev_dbg(dev, args)
 #endif
 
-- 
2.28.0

