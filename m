Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2386D2A1231
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 01:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgJaAu0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 20:50:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55824 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgJaAuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 20:50:19 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYf5z-004RiY-FH; Sat, 31 Oct 2020 01:50:15 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Nicolas Pitre <nico@fluxnic.net>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/7] drivers: net: smc911x: Fix set but unused status because of DBG macro
Date:   Sat, 31 Oct 2020 01:49:55 +0100
Message-Id: <20201031004958.1059797-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201031004958.1059797-1-andrew@lunn.ch>
References: <20201031004958.1059797-1-andrew@lunn.ch>
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
and the leave the optimiser to remove the unwanted code inside the if
(0).

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/ethernet/smsc/smc911x.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/smsc/smc911x.c b/drivers/net/ethernet/smsc/smc911x.c
index 8f748a0c057e..33d0398c182e 100644
--- a/drivers/net/ethernet/smsc/smc911x.c
+++ b/drivers/net/ethernet/smsc/smc911x.c
@@ -102,7 +102,11 @@ MODULE_ALIAS("platform:smc911x");
 
 #define PRINTK(dev, args...)   netdev_info(dev, args)
 #else
-#define DBG(n, dev, args...)   do { } while (0)
+#define DBG(n, dev, args...)			 \
+	do {					 \
+		if (0)				 \
+			netdev_dbg(dev, args);	 \
+	} while (0)
 #define PRINTK(dev, args...)   netdev_dbg(dev, args)
 #endif
 
-- 
2.28.0

