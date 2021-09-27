Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B383541960C
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234710AbhI0ORL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234682AbhI0ORL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Sep 2021 10:17:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E82DF6113A;
        Mon, 27 Sep 2021 14:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632752133;
        bh=JMUuQhsPUSWFNQbmuQaLIk/pVKNby0xD64MgB2oLDWQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ZN24zF99o/cDwJxYkoVnMpPZUTKXpZv2w3I2wweizbjQD0sS03ZSvVA36Yh8D5dKG
         daV0bBJHJ3Tx7r+FLCT1RXjuND3FkNs44azOWwPpuuSrQY3MIwtF1h1kH6Qy5bVzit
         mRCco9OYW3Jyy7lb/mpBetauBH1rh7vCu+Hw2Njdk2bKptxik0FG5dXGaSt8OSvY5o
         kZ3BuehrG75BPFZhdLxouUgmAE7HkVy0W5zaTk3RzlhKLm4qoavpuhTs41flzkuKeM
         P2iI52MA+xr/RO5dN27ACLy9x4OMHr/7v1crUZ/1HNvjfjbEi9ariZBYuO37Ro/R5i
         opB4OKc6pSXlA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dmascc: add CONFIG_VIRT_TO_BUS dependency
Date:   Mon, 27 Sep 2021 16:15:24 +0200
Message-Id: <20210927141529.1614679-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Many architectures don't define virt_to_bus() any more, as drivers
should be using the dma-mapping interfaces where possible:

In file included from drivers/net/hamradio/dmascc.c:27:
drivers/net/hamradio/dmascc.c: In function 'tx_on':
drivers/net/hamradio/dmascc.c:976:30: error: implicit declaration of function 'virt_to_bus'; did you mean 'virt_to_fix'? [-Werror=implicit-function-declaration]
  976 |                              virt_to_bus(priv->tx_buf[priv->tx_tail]) + n);
      |                              ^~~~~~~~~~~
arch/arm/include/asm/dma.h:109:52: note: in definition of macro 'set_dma_addr'
  109 |         __set_dma_addr(chan, (void *)__bus_to_virt(addr))
      |                                                    ^~~~

Add the Kconfig dependency to prevent this from being built on
architectures without virt_to_bus().

Fixes: bc1abb9e55ce ("dmascc: use proper 'virt_to_bus()' rather than casting to 'int'")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/hamradio/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/Kconfig b/drivers/net/hamradio/Kconfig
index f4843f9672c1..441da03c23ee 100644
--- a/drivers/net/hamradio/Kconfig
+++ b/drivers/net/hamradio/Kconfig
@@ -48,6 +48,7 @@ config BPQETHER
 config DMASCC
 	tristate "High-speed (DMA) SCC driver for AX.25"
 	depends on ISA && AX25 && BROKEN_ON_SMP && ISA_DMA_API
+	depends on VIRT_TO_BUS
 	help
 	  This is a driver for high-speed SCC boards, i.e. those supporting
 	  DMA on one port. You usually use those boards to connect your
-- 
2.29.2

