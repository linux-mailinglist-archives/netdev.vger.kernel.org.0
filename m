Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7024619AB3
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 11:35:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727376AbfEJJfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 05:35:50 -0400
Received: from smtp-out.xnet.cz ([178.217.244.18]:33074 "EHLO smtp-out.xnet.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727298AbfEJJft (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 May 2019 05:35:49 -0400
Received: from meh.true.cz (meh.true.cz [108.61.167.218])
        (Authenticated sender: petr@true.cz)
        by smtp-out.xnet.cz (Postfix) with ESMTPSA id 48E0F434B;
        Fri, 10 May 2019 11:35:46 +0200 (CEST)
Received: by meh.true.cz (OpenSMTPD) with ESMTP id 7046f80c;
        Fri, 10 May 2019 11:35:45 +0200 (CEST)
From:   =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>
To:     netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh@kernel.org>,
        =?UTF-8?q?Petr=20=C5=A0tetiar?= <ynezz@true.cz>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH net 3/5] powerpc: tsi108: fix similar warning reported by kbuild test robot
Date:   Fri, 10 May 2019 11:35:16 +0200
Message-Id: <1557480918-9627-4-git-send-email-ynezz@true.cz>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1557480918-9627-1-git-send-email-ynezz@true.cz>
References: <1557480918-9627-1-git-send-email-ynezz@true.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes following (similar) warning reported by kbuild test robot:

 In function ‘memcpy’,
  inlined from ‘smsc75xx_init_mac_address’ at drivers/net/usb/smsc75xx.c:778:3,
  inlined from ‘smsc75xx_bind’ at drivers/net/usb/smsc75xx.c:1501:2:
  ./include/linux/string.h:355:9: warning: argument 2 null where non-null expected [-Wnonnull]
  return __builtin_memcpy(p, q, size);
         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
  drivers/net/usb/smsc75xx.c: In function ‘smsc75xx_bind’:
  ./include/linux/string.h:355:9: note: in a call to built-in function ‘__builtin_memcpy’

I've replaced the offending memcpy with ether_addr_copy, because I'm
100% sure, that of_get_mac_address can't return NULL as it returns valid
pointer or ERR_PTR encoded value, nothing else.

I'm hesitant to just change IS_ERR into IS_ERR_OR_NULL check, as this
would make the warning disappear also, but it would be confusing to
check for impossible return value just to make a compiler happy.

I'm now changing all occurencies of memcpy to ether_addr_copy after the
of_get_mac_address call, as it's very likely, that we're going to get
similar reports from kbuild test robot in the future.

Fixes: ea168cdf1299 ("powerpc: tsi108: support of_get_mac_address new ERR_PTR error")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Petr Štetiar <ynezz@true.cz>
---
 arch/powerpc/sysdev/tsi108_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/sysdev/tsi108_dev.c b/arch/powerpc/sysdev/tsi108_dev.c
index c92dcac85231..026619c9a8cb 100644
--- a/arch/powerpc/sysdev/tsi108_dev.c
+++ b/arch/powerpc/sysdev/tsi108_dev.c
@@ -18,6 +18,7 @@
 #include <linux/irq.h>
 #include <linux/export.h>
 #include <linux/device.h>
+#include <linux/etherdevice.h>
 #include <linux/platform_device.h>
 #include <linux/of_net.h>
 #include <asm/tsi108.h>
@@ -106,7 +107,7 @@ static int __init tsi108_eth_of_init(void)
 
 		mac_addr = of_get_mac_address(np);
 		if (!IS_ERR(mac_addr))
-			memcpy(tsi_eth_data.mac_addr, mac_addr, 6);
+			ether_addr_copy(tsi_eth_data.mac_addr, mac_addr);
 
 		ph = of_get_property(np, "mdio-handle", NULL);
 		mdio = of_find_node_by_phandle(*ph);
-- 
1.9.1

