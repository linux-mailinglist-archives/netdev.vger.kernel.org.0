Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E42EA3DEC6C
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:42:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbhHCLmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:42:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235947AbhHCLlu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:41:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E63B60EE9;
        Tue,  3 Aug 2021 11:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627990899;
        bh=uMSPGBXE9/m0q1YDMsyru60MbMwNd+TxQc3v8teCMV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRsAHGPTDlnnIsSPq+eYjaZuk/YIacirHSY8ex+0in4g5IlHnbTxghSgyH5W1Umiw
         d3otqc1nLNuri//i57hV8XdPx5unUUds/Icjecnc6GBYPGLvL1hgcvgwHrEOe4j+3J
         yU2ZzlCYBr77rDeDVAqQhPdot9nabLOa4MkGWGMi8hvNrwxx40EXV3gMAHfESz1+gv
         ZV81og91zKjWtjI/19j4li6Bcy0ypWNtjuJ/qrhKygJxa4KNhNbmoKQH+TPAApupgu
         u4Iwp5DM+hDoOKh20NQW74cp2cVWI5CrvJq+Y22qhmH+Iv8GBlhNg0sXzLdXvwIUa3
         qoNEPtpHT6ESQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Doug Berger <opendmb@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>, Jessica Yu <jeyu@kernel.org>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Sam Creasey <sammy@sammy.net>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: [PATCH v2 08/14] [net-next] xsurf100: drop include of lib8390.c
Date:   Tue,  3 Aug 2021 13:40:45 +0200
Message-Id: <20210803114051.2112986-9-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210803114051.2112986-1-arnd@kernel.org>
References: <20210803114051.2112986-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Schmitz <schmitzmic@gmail.com>

Now that ax88796.c exports the ax_NS8390_reinit() symbol, we can
include 8390.h instead of lib8390.c, avoiding duplication of that
function and killing a few compile warnings in the bargain.

Fixes: 861928f4e60e826c ("net-next: New ax88796 platform
driver for Amiga X-Surf 100 Zorro board (m68k)")

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/8390/xsurf100.c | 9 ++-------
 init/main.c                          | 6 +++---
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/8390/xsurf100.c b/drivers/net/ethernet/8390/xsurf100.c
index e2c963821ffe..fe7a74707aa4 100644
--- a/drivers/net/ethernet/8390/xsurf100.c
+++ b/drivers/net/ethernet/8390/xsurf100.c
@@ -22,8 +22,6 @@
 #define XS100_8390_DATA_WRITE32_BASE 0x0C80
 #define XS100_8390_DATA_AREA_SIZE 0x80
 
-#define __NS8390_init ax_NS8390_init
-
 /* force unsigned long back to 'void __iomem *' */
 #define ax_convert_addr(_a) ((void __force __iomem *)(_a))
 
@@ -42,10 +40,7 @@
 /* Ensure we have our RCR base value */
 #define AX88796_PLATFORM
 
-static unsigned char version[] =
-		"ax88796.c: Copyright 2005,2007 Simtec Electronics\n";
-
-#include "lib8390.c"
+#include "8390.h"
 
 /* from ne.c */
 #define NE_CMD		EI_SHIFT(0x00)
@@ -232,7 +227,7 @@ static void xs100_block_output(struct net_device *dev, int count,
 		if (jiffies - dma_start > 2 * HZ / 100) {	/* 20ms */
 			netdev_warn(dev, "timeout waiting for Tx RDC.\n");
 			ei_local->reset_8390(dev);
-			ax_NS8390_init(dev, 1);
+			ax_NS8390_reinit(dev);
 			break;
 		}
 	}
diff --git a/init/main.c b/init/main.c
index f5b8246e8aa1..11cbbec309fa 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1221,7 +1221,7 @@ trace_initcall_start_cb(void *data, initcall_t fn)
 {
 	ktime_t *calltime = (ktime_t *)data;
 
-	printk(KERN_DEBUG "calling  %pS @ %i\n", fn, task_pid_nr(current));
+	printk(KERN_DEBUG "calling  %pS @ %i irqs_disabled() %d\n", fn, task_pid_nr(current), irqs_disabled());
 	*calltime = ktime_get();
 }
 
@@ -1235,8 +1235,8 @@ trace_initcall_finish_cb(void *data, initcall_t fn, int ret)
 	rettime = ktime_get();
 	delta = ktime_sub(rettime, *calltime);
 	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-	printk(KERN_DEBUG "initcall %pS returned %d after %lld usecs\n",
-		 fn, ret, duration);
+	printk(KERN_DEBUG "initcall %pS returned %d after %lld usecs, irqs_disabled() %d\n",
+		 fn, ret, duration, irqs_disabled());
 }
 
 static ktime_t initcall_calltime;
-- 
2.29.2

