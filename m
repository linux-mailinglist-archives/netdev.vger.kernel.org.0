Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04770343E44
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhCVKpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230340AbhCVKp2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:45:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 878A56198C;
        Mon, 22 Mar 2021 10:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616409927;
        bh=0/w4RFVux1+2Ik/9qofr1ADX1qFjT5bWbNPjiWlo9uI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5SXCPcDzww3Ao0FayG8EFuUv6DkUgd6FVoe6PuvYAhTlhvm2rx8xlOOmfQI6L4IL
         Oj4L/uavPxTByS2DxTOEJvPBIegB3CaAPy5qe4cZJQGaQcwzoiJLwAVyPncPY/kj7i
         ETJRlDhPpucLQT45k7522iDr1EzyJzVxIfFnOuZ8MAXr+Ej5i1KbcvPx5pbPXvJDf5
         QrxV6IHPc9dUnxG+X8lcSRGwUAvLSNyQQKHOoztb1rV63bxnBGGTeToTzMWjH93laH
         0WYW9sYxUNZdszBegeptYydbO9vphfW0eyV4+Jy5QTmU8JQVWM+vMDkcr/NaFIir8s
         CT1co7/nGIrbA==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/5] vxge: avoid -Wemtpy-body warnings
Date:   Mon, 22 Mar 2021 11:43:35 +0100
Message-Id: <20210322104343.948660-5-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322104343.948660-1-arnd@kernel.org>
References: <20210322104343.948660-1-arnd@kernel.org>
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
 drivers/net/ethernet/neterion/vxge/vxge-main.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.h b/drivers/net/ethernet/neterion/vxge/vxge-main.h
index 9c86f4f9cd42..55673fdebe3e 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.h
@@ -454,49 +454,49 @@ int vxge_fw_upgrade(struct vxgedev *vdev, char *fw_name, int override);
 #define vxge_debug_ll_config(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_LL_CONFIG, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_ll_config(level, fmt, ...)
+#define vxge_debug_ll_config(level, fmt, ...) no_printk(fmt)
 #endif
 
 #if (VXGE_DEBUG_INIT & VXGE_DEBUG_MASK)
 #define vxge_debug_init(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_INIT, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_init(level, fmt, ...)
+#define vxge_debug_init(level, fmt, ...) no_printk(fmt)
 #endif
 
 #if (VXGE_DEBUG_TX & VXGE_DEBUG_MASK)
 #define vxge_debug_tx(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_TX, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_tx(level, fmt, ...)
+#define vxge_debug_tx(level, fmt, ...) no_printk(fmt)
 #endif
 
 #if (VXGE_DEBUG_RX & VXGE_DEBUG_MASK)
 #define vxge_debug_rx(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_RX, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_rx(level, fmt, ...)
+#define vxge_debug_rx(level, fmt, ...) no_printk(fmt)
 #endif
 
 #if (VXGE_DEBUG_MEM & VXGE_DEBUG_MASK)
 #define vxge_debug_mem(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_MEM, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_mem(level, fmt, ...)
+#define vxge_debug_mem(level, fmt, ...) no_printk(fmt)
 #endif
 
 #if (VXGE_DEBUG_ENTRYEXIT & VXGE_DEBUG_MASK)
 #define vxge_debug_entryexit(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_ENTRYEXIT, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_entryexit(level, fmt, ...)
+#define vxge_debug_entryexit(level, fmt, ...) no_printk(fmt)
 #endif
 
 #if (VXGE_DEBUG_INTR & VXGE_DEBUG_MASK)
 #define vxge_debug_intr(level, fmt, ...) \
 	vxge_debug_ll(level, VXGE_DEBUG_INTR, fmt, ##__VA_ARGS__)
 #else
-#define vxge_debug_intr(level, fmt, ...)
+#define vxge_debug_intr(level, fmt, ...) no_printk(fmt)
 #endif
 
 #define VXGE_DEVICE_DEBUG_LEVEL_SET(level, mask, vdev) {\
-- 
2.29.2

