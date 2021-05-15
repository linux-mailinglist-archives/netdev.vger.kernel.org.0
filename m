Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E7F381B75
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 00:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235265AbhEOWSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 18:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235386AbhEOWQa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 18:16:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A460613BE;
        Sat, 15 May 2021 22:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621116916;
        bh=s7CSIpvZHbOWXeWkAI+whfYDuggnhcGoY3rP609LlF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJk3QfQE7NcUQ6w6PZrDI4pgoJPfuoPKVEZMcVNlUuesR0XObHzObKw6Ugyx/xY5T
         wulTApabqCl0KlRoU0JkEUhX1oIckpa1CFKfMp/2jTfoElVVgYOh3TXH80ozUKWf7O
         qUfFMEMJQ5qZ3DjxATAaFu22UnOpfL4kd001RHfO1sHW15DxBPt9ZbeqTkU7DFgtfV
         IKE7fp1SgvOrL1aJLtjFTieJF5V5zyk35wp9bulSsi21GY+CMS6TD0WhkeWEUlIR+/
         LDiG6ozsZakv5mhUo2rLOby2+HknV/OOj6d2ND0O6BFrGR3Z6I/xWu4tTg6uuUrDP/
         i03KK4ealUYZw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sam Creasey <sammy@sammy.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Finn Thain <fthain@telegraphics.com.au>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andrew Lunn <andrew@lunn.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        linux-kernel@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com
Subject: [RFC 13/13] [net-next] 8390: xsurf100: avoid including lib8390.c
Date:   Sun, 16 May 2021 00:13:20 +0200
Message-Id: <20210515221320.1255291-14-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210515221320.1255291-1-arnd@kernel.org>
References: <20210515221320.1255291-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

This driver always warns about unused functions because it includes
an file that it doesn't actually need:

In file included from drivers/net/ethernet/8390/xsurf100.c:48:
drivers/net/ethernet/8390/lib8390.c:995:27: error: '____alloc_ei_netdev' defined but not used [-Werror=unused-function]
  995 | static struct net_device *____alloc_ei_netdev(int size)
      |                           ^~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:957:13: error: '__ei_set_multicast_list' defined but not used [-Werror=unused-function]
  957 | static void __ei_set_multicast_list(struct net_device *dev)
      |             ^~~~~~~~~~~~~~~~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:857:33: error: '__ei_get_stats' defined but not used [-Werror=unused-function]
  857 | static struct net_device_stats *__ei_get_stats(struct net_device *dev)
      |                                 ^~~~~~~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:512:13: error: '__ei_poll' defined but not used [-Werror=unused-function]
  512 | static void __ei_poll(struct net_device *dev)
      |             ^~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:303:20: error: '__ei_start_xmit' defined but not used [-Werror=unused-function]
  303 | static netdev_tx_t __ei_start_xmit(struct sk_buff *skb,
      |                    ^~~~~~~~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:257:13: error: '__ei_tx_timeout' defined but not used [-Werror=unused-function]
  257 | static void __ei_tx_timeout(struct net_device *dev, unsigned int txqueue)
      |             ^~~~~~~~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:233:12: error: '__ei_close' defined but not used [-Werror=unused-function]
  233 | static int __ei_close(struct net_device *dev)
      |            ^~~~~~~~~~
drivers/net/ethernet/8390/lib8390.c:204:12: error: '__ei_open' defined but not used [-Werror=unused-function]
  204 | static int __ei_open(struct net_device *dev)
      |            ^~~~~~~~~

Use the normal library module instead and call the NS8390p_init()
function.

Fixes: 861928f4e60e ("net-next: New ax88796 platform driver for Amiga X-Surf 100 Zorro board (m68k)")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/8390/Makefile   | 2 +-
 drivers/net/ethernet/8390/xsurf100.c | 7 ++-----
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/8390/Makefile b/drivers/net/ethernet/8390/Makefile
index 85c83c566ec6..304897d5f0f9 100644
--- a/drivers/net/ethernet/8390/Makefile
+++ b/drivers/net/ethernet/8390/Makefile
@@ -16,5 +16,5 @@ obj-$(CONFIG_PCMCIA_PCNET) += pcnet_cs.o 8390.o
 obj-$(CONFIG_STNIC) += stnic.o 8390.o
 obj-$(CONFIG_ULTRA) += smc-ultra.o 8390.o
 obj-$(CONFIG_WD80x3) += wd.o 8390.o
-obj-$(CONFIG_XSURF100) += xsurf100.o
+obj-$(CONFIG_XSURF100) += xsurf100.o 8390.o
 obj-$(CONFIG_ZORRO8390) += zorro8390.o
diff --git a/drivers/net/ethernet/8390/xsurf100.c b/drivers/net/ethernet/8390/xsurf100.c
index e2c963821ffe..11d5d43e7202 100644
--- a/drivers/net/ethernet/8390/xsurf100.c
+++ b/drivers/net/ethernet/8390/xsurf100.c
@@ -42,10 +42,7 @@
 /* Ensure we have our RCR base value */
 #define AX88796_PLATFORM
 
-static unsigned char version[] =
-		"ax88796.c: Copyright 2005,2007 Simtec Electronics\n";
-
-#include "lib8390.c"
+#include "8390.h"
 
 /* from ne.c */
 #define NE_CMD		EI_SHIFT(0x00)
@@ -232,7 +229,7 @@ static void xs100_block_output(struct net_device *dev, int count,
 		if (jiffies - dma_start > 2 * HZ / 100) {	/* 20ms */
 			netdev_warn(dev, "timeout waiting for Tx RDC.\n");
 			ei_local->reset_8390(dev);
-			ax_NS8390_init(dev, 1);
+			NS8390p_init(dev, 1);
 			break;
 		}
 	}
-- 
2.29.2

