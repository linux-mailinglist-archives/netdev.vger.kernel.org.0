Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC8C72E8E84
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:43:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727880AbhACVkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:40:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727417AbhACVkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:40:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F2C3B206A1;
        Sun,  3 Jan 2021 21:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709967;
        bh=5Au9bstUkpXNeP9+yq4BsAUB++A4J8/hr2nJtbd9aHg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLnGyxrEsyNIV3LDmoJ0vYKPk5kaNyFAgwd58w/NiO1Nlh9L22hmZ53F4iwe+zLPv
         hNEmwWrBROW8IANEGCsB4KRUJYeyLhqrUPnEW0U2K9iP4ySHe3TL57gQBiBJomE4lI
         iXqm5fV6xHy/oENhYPZYvSaHBn/bKv4ezZbFhCmrkKPzhbrbfkoNkiYL8MnpHJXOnm
         yl3DheYvArYLoZnJO7G5INwzDcHELiHB1OACr8K7+oSsoOCI9I2cl4UvCDer+jl2d3
         Li91rmqUN+4CaXRXAjOZ1iQkNokFXZyRnKuTbl+4s9T0LqDIc50ur/4340a1HRoWzn
         HTcCcHxvQLkmA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zhao Qiang <qiang.zhao@nxp.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Xie He <xie.he.0141@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/7] wan: ds26522: select CONFIG_BITREVERSE
Date:   Sun,  3 Jan 2021 22:36:23 +0100
Message-Id: <20210103213645.1994783-7-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210103213645.1994783-1-arnd@kernel.org>
References: <20210103213645.1994783-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without this, the driver runs into a link failure

arm-linux-gnueabi-ld: drivers/net/wan/slic_ds26522.o: in function `slic_ds26522_probe':
slic_ds26522.c:(.text+0x100c): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: slic_ds26522.c:(.text+0x1cdc): undefined reference to `byte_rev_table'
arm-linux-gnueabi-ld: drivers/net/wan/slic_ds26522.o: in function `slic_write':
slic_ds26522.c:(.text+0x1e4c): undefined reference to `byte_rev_table'

Fixes: c37d4a0085c5 ("Maxim/driver: Add driver for maxim ds26522")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wan/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
index 8931ef529065..a187c814a4a6 100644
--- a/drivers/net/wan/Kconfig
+++ b/drivers/net/wan/Kconfig
@@ -282,6 +282,7 @@ config SLIC_DS26522
 	tristate "Slic Maxim ds26522 card support"
 	depends on SPI
 	depends on FSL_SOC || ARCH_MXC || ARCH_LAYERSCAPE || COMPILE_TEST
+	select BITREVERSE
 	help
 	  This module initializes and configures the slic maxim card
 	  in T1 or E1 mode.
-- 
2.29.2

