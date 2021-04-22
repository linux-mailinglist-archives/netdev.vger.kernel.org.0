Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AF836836C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237421AbhDVPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:36:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:34676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234158AbhDVPg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Apr 2021 11:36:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85F7961450;
        Thu, 22 Apr 2021 15:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619105751;
        bh=qZkLO17uZzZLFgGvf3mPigG2N3yGL0dvWGWJs4dQJFI=;
        h=From:To:Cc:Subject:Date:From;
        b=rGkxmdrBFMxVi+ekVrQyqKXHwgGnE0dX8mODFlz3kc5a411oNGe8P22LZYSCQsNuy
         v4RvZS5S39bYn1gSwaplaYLpo3bU6Vh3LcnM8TDqAwcpxYD+0Er+81kpUYgoeSeMxF
         44NVcmstOA5HKuJs8Dxk3Qfr7IoTDMFuq3kMfGeshbMlHiVkM3T4IH24oVgYo98xAL
         NkzsoVPZCbyT2hyztNUUesTbKmcZDghbNy4paChsqYq4UHnFRsqSDQe06W4mYss2+N
         djjBXUxdZOwttELAG42Orr4jGIrhLFvAhOnUpQAgvlvKk4vJiU0VRD58juzI3HAFRD
         YZgdJKKucddqQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [v2] vxge: avoid -Wemtpy-body warnings
Date:   Thu, 22 Apr 2021 17:35:33 +0200
Message-Id: <20210422153543.3378150-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are a few warnings about empty debug macros in this driver:

drivers/net/ethernet/neterion/vxge/vxge-main.c: In function 'vxge_probe':
drivers/net/ethernet/neterion/vxge/vxge-main.c:4480:76: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
 4480 |                                 "Failed in enabling SRIOV mode: %d\n", ret);

Change them to proper 'do { } while (0)' expressions to make the
code a little more robust and avoid the warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
v2: correctly pass va_args to avoid warnings
---
 drivers/net/ethernet/neterion/vxge/vxge-main.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.h b/drivers/net/ethernet/neterion/vxge/vxge-main.h
index 9c86f4f9cd42..63f65193dd49 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.h
@@ -454,49 +454,49 @@ int vxge_fw_upgrade(struct vxgedev *vdev, char *fw_name, int override);
 #define vxge_debug_ll_config(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_LL_CONFIG, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_ll_config(level, fmt, ...)
+#define vxge_debug_ll_config(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #if (VXGE_DEBUG_INIT & VXGE_DEBUG_MASK)
 #define vxge_debug_init(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_INIT, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_init(level, fmt, ...)
+#define vxge_debug_init(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #if (VXGE_DEBUG_TX & VXGE_DEBUG_MASK)
 #define vxge_debug_tx(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_TX, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_tx(level, fmt, ...)
+#define vxge_debug_tx(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #if (VXGE_DEBUG_RX & VXGE_DEBUG_MASK)
 #define vxge_debug_rx(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_RX, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_rx(level, fmt, ...)
+#define vxge_debug_rx(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #if (VXGE_DEBUG_MEM & VXGE_DEBUG_MASK)
 #define vxge_debug_mem(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_MEM, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_mem(level, fmt, ...)
+#define vxge_debug_mem(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #if (VXGE_DEBUG_ENTRYEXIT & VXGE_DEBUG_MASK)
 #define vxge_debug_entryexit(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_ENTRYEXIT, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_entryexit(level, fmt, ...)
+#define vxge_debug_entryexit(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #if (VXGE_DEBUG_INTR & VXGE_DEBUG_MASK)
 #define vxge_debug_intr(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_INTR, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_intr(level, fmt, ...)
+#define vxge_debug_intr(level, fmt, ...) no_printk(fmt, ##__VA_ARGS__)
 #endif
 
 #define VXGE_DEVICE_DEBUG_LEVEL_SET(level, mask, vdev) {\
-- 
2.29.2

