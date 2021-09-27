Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B6FA419606
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhI0OPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:56542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234679AbhI0OPD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:15:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF34461058;
        Mon, 27 Sep 2021 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632752005;
        bh=qutSCrwy/TT4wgeyz+HTZUEPac23W4EAi0SlC5tJV48=;
        h=From:To:Cc:Subject:Date:From;
        b=niGwl4EUMEsR98A9zj/PC7A7tRl37LIdqflHqGLpJqiPrbr+rtK9Krg6ke9AumMA8
         /SjQ57Aih5K0xCFvs2UYe6ivv9DnnxvAj1w+L0vfYBztjFH4+ezTEMPplcdZVZD0Bc
         lXZ13wW79ZP5ucacjfW9wuN8K37purxLARvUSJ+9+2JYzNSpWQxP93KlS9vbz/08eY
         nkWnh1rkcvo52v5DV2brFsuQvRMVPltO9VQqV+dCEFWDUnmD3hV5SkpU46zLoLPskK
         Xe+fAp6i1yACjV8H/u5tZtRvd70JYUF2JJlkXL4u8ex2wIClWBiVNwxWQ4Ibbb3utN
         TYcN73affchGA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Marek Vasut <marex@denx.de>
Cc:     Arnd Bergmann <arnd@arndb.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [RESEND] net: ks8851: fix link error
Date:   Mon, 27 Sep 2021 16:13:02 +0200
Message-Id: <20210927141321.1598251-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

An object file cannot be built for both loadable module and built-in
use at the same time:

arm-linux-gnueabi-ld: drivers/net/ethernet/micrel/ks8851_common.o: in function `ks8851_probe_common':
ks8851_common.c:(.text+0xf80): undefined reference to `__this_module'

Change the ks8851_common code to be a standalone module instead,
and use Makefile logic to ensure this is built-in if at least one
of its two users is.

Fixes: 797047f875b5 ("net: ks8851: Implement Parallel bus operations")
Link: https://lore.kernel.org/netdev/20210125121937.3900988-1-arnd@kernel.org/
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marek Vasut <marex@denx.de>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
Marek sent two other patches to address the problem:
https://lore.kernel.org/netdev/20210116164828.40545-1-marex@denx.de/
https://lore.kernel.org/netdev/20210115134239.126152-1-marex@denx.de/

My version is what I applied locally to my randconfig tree, and
I think this is the cleanest solution.
---
 drivers/net/ethernet/micrel/Makefile        | 6 ++----
 drivers/net/ethernet/micrel/ks8851_common.c | 8 ++++++++
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/micrel/Makefile b/drivers/net/ethernet/micrel/Makefile
index 5cc00d22c708..6ecc4eb30e74 100644
--- a/drivers/net/ethernet/micrel/Makefile
+++ b/drivers/net/ethernet/micrel/Makefile
@@ -4,8 +4,6 @@
 #
 
 obj-$(CONFIG_KS8842) += ks8842.o
-obj-$(CONFIG_KS8851) += ks8851.o
-ks8851-objs = ks8851_common.o ks8851_spi.o
-obj-$(CONFIG_KS8851_MLL) += ks8851_mll.o
-ks8851_mll-objs = ks8851_common.o ks8851_par.o
+obj-$(CONFIG_KS8851) += ks8851_common.o ks8851_spi.o
+obj-$(CONFIG_KS8851_MLL) += ks8851_common.o ks8851_par.o
 obj-$(CONFIG_KSZ884X_PCI) += ksz884x.o
diff --git a/drivers/net/ethernet/micrel/ks8851_common.c b/drivers/net/ethernet/micrel/ks8851_common.c
index 3f69bb59ba49..a6db1a8156e1 100644
--- a/drivers/net/ethernet/micrel/ks8851_common.c
+++ b/drivers/net/ethernet/micrel/ks8851_common.c
@@ -1057,6 +1057,7 @@ int ks8851_suspend(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_suspend);
 
 int ks8851_resume(struct device *dev)
 {
@@ -1070,6 +1071,7 @@ int ks8851_resume(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_resume);
 #endif
 
 static int ks8851_register_mdiobus(struct ks8851_net *ks, struct device *dev)
@@ -1243,6 +1245,7 @@ int ks8851_probe_common(struct net_device *netdev, struct device *dev,
 err_reg_io:
 	return ret;
 }
+EXPORT_SYMBOL_GPL(ks8851_probe_common);
 
 int ks8851_remove_common(struct device *dev)
 {
@@ -1261,3 +1264,8 @@ int ks8851_remove_common(struct device *dev)
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(ks8851_remove_common);
+
+MODULE_DESCRIPTION("KS8851 Network driver");
+MODULE_AUTHOR("Ben Dooks <ben@simtec.co.uk>");
+MODULE_LICENSE("GPL");
-- 
2.29.2

