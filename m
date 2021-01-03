Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2A92E8E74
	for <lists+netdev@lfdr.de>; Sun,  3 Jan 2021 22:39:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbhACVha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jan 2021 16:37:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbhACVh3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 3 Jan 2021 16:37:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E83B020780;
        Sun,  3 Jan 2021 21:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609709809;
        bh=qVglGCnEzhllmV9UmCv6wplmqZDMihZ1DsBawNGAj1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=t97m8l/wX34nha4xhO5OFUsTyxNjRL+k6TA+/SHdqduWF2umxVbiScd40qxIuT6ut
         RtKZjzmHLLy4X0SRkFTBtgcqUoiZG8J+Mu8jioOSsJ5YMbHJOlAQ/+A/kp+i7t23ca
         jSw68Ypp1vU41B9uiRuQShBCi9Z4p0+0OS85O5JBzwLQeZg5E5vUExAGyymWPAPlCJ
         K7ZJZadhaMuCLHHiofhLtOc9nSdLITaeP2fGwJN50tPM5Jrki+K8/wOJsJibIJZcp4
         dwW9kXQvBb50pGntV+bjk/0yCTuzP53GPZUp752OcGHOa85TCgZvjHol9bATjw2ThA
         TJQCLdhswNlag==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Mintz, Yuval" <Yuval.Mintz@cavium.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] qed: select CONFIG_CRC32
Date:   Sun,  3 Jan 2021 22:36:17 +0100
Message-Id: <20210103213645.1994783-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

Without this, the driver fails to link:

lpc_eth.c:(.text+0x1934): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_grc_dump':
qed_debug.c:(.text+0x4068): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_idle_chk_dump':
qed_debug.c:(.text+0x51fc): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_mcp_trace_dump':
qed_debug.c:(.text+0x6000): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o: in function `qed_dbg_reg_fifo_dump':
qed_debug.c:(.text+0x66cc): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/ethernet/qlogic/qed/qed_debug.o:qed_debug.c:(.text+0x6aa4): more undefined references to `crc32_le' follow

Fixes: 7a4b21b7d1f0 ("qed: Add nvram selftest")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/ethernet/qlogic/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/qlogic/Kconfig b/drivers/net/ethernet/qlogic/Kconfig
index 4366c7a8de95..6b5ddb07ee83 100644
--- a/drivers/net/ethernet/qlogic/Kconfig
+++ b/drivers/net/ethernet/qlogic/Kconfig
@@ -78,6 +78,7 @@ config QED
 	depends on PCI
 	select ZLIB_INFLATE
 	select CRC8
+	select CRC32
 	select NET_DEVLINK
 	help
 	  This enables the support for Marvell FastLinQ adapters family.
-- 
2.29.2

