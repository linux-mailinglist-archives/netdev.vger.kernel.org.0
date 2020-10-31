Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23862A1950
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 19:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbgJaSOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 14:14:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728209AbgJaSOr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 14:14:47 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kYvOn-004XMV-Os; Sat, 31 Oct 2020 19:14:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next] drivers: net: wan: lmc: Fix W=1 set but used variable warnings
Date:   Sat, 31 Oct 2020 19:14:17 +0100
Message-Id: <20201031181417.1081511-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

drivers/net/wan/lmc/lmc_main.c: In function ‘lmc_ioctl’:
drivers/net/wan/lmc/lmc_main.c:356:25: warning: variable ‘mii’ set but not used [-Wunused-but-set-variable]
  356 |                     u16 mii;
      |                         ^~~
drivers/net/wan/lmc/lmc_main.c:427:25: warning: variable ‘mii’ set but not used [-Wunused-but-set-variable]
  427 |                     u16 mii;
      |                         ^~~
drivers/net/wan/lmc/lmc_main.c: In function ‘lmc_interrupt’:
drivers/net/wan/lmc/lmc_main.c:1188:9: warning: variable ‘firstcsr’ set but not used [-Wunused-but-set-variable]
 1188 |     u32 firstcsr;

This file has funky indentation, and makes little use of tabs. Keep
with this style in the patch, but that makes checkpatch unhappy.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/wan/lmc/lmc_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wan/lmc/lmc_main.c b/drivers/net/wan/lmc/lmc_main.c
index 36600b0a0ab0..93c7e8502845 100644
--- a/drivers/net/wan/lmc/lmc_main.c
+++ b/drivers/net/wan/lmc/lmc_main.c
@@ -353,9 +353,8 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
             switch(xc.command){
             case lmc_xilinx_reset: /*fold02*/
                 {
-                    u16 mii;
 		    spin_lock_irqsave(&sc->lmc_lock, flags);
-                    mii = lmc_mii_readreg (sc, 0, 16);
+                    lmc_mii_readreg (sc, 0, 16);
 
                     /*
                      * Make all of them 0 and make input
@@ -424,10 +423,9 @@ int lmc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd) /*fold00*/
                 break;
             case lmc_xilinx_load_prom: /*fold02*/
                 {
-                    u16 mii;
                     int timeout = 500000;
 		    spin_lock_irqsave(&sc->lmc_lock, flags);
-                    mii = lmc_mii_readreg (sc, 0, 16);
+                    lmc_mii_readreg (sc, 0, 16);
 
                     /*
                      * Make all of them 0 and make input
@@ -1185,7 +1183,6 @@ static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
     int i;
     s32 stat;
     unsigned int badtx;
-    u32 firstcsr;
     int max_work = LMC_RXDESCS;
     int handled = 0;
 
@@ -1203,8 +1200,6 @@ static irqreturn_t lmc_interrupt (int irq, void *dev_instance) /*fold00*/
         goto lmc_int_fail_out;
     }
 
-    firstcsr = csr;
-
     /* always go through this loop at least once */
     while (csr & sc->lmc_intrmask) {
 	handled = 1;
-- 
2.28.0

