Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDCD1A022F
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:04:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727991AbgDGACO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:02:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727905AbgDGACN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0D4420857;
        Tue,  7 Apr 2020 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217732;
        bh=aJGDApDJxafW+Vlm41KJkKg+iMU290np3OMqekDT3+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJgn7cwNK80ew1beaj5NYHwrUm8U/ZeJY/vHvlYGiLOgLrpAvpnH/IlsGlPho+3OQ
         CxJyHS8ZIbE24OdrT2e0lcac2O8vfCwT1pT8D7AzEQKxPFGvkuXvO0Wl/lmmvwNNFu
         Ul1SJohX9IAXjQ3lqnKXBR2oa3nvleyRYrRotXmE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheng Wei <wei.zheng@vivo.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/32] net: vxge: fix wrong __VA_ARGS__ usage
Date:   Mon,  6 Apr 2020 20:01:34 -0400
Message-Id: <20200407000151.16768-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Wei <wei.zheng@vivo.com>

[ Upstream commit b317538c47943f9903860d83cc0060409e12d2ff ]

printk in macro vxge_debug_ll uses __VA_ARGS__ without "##" prefix,
it causes a build error when there is no variable
arguments(e.g. only fmt is specified.).

Signed-off-by: Zheng Wei <wei.zheng@vivo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.h |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h   | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.h b/drivers/net/ethernet/neterion/vxge/vxge-config.h
index e678ba379598e..628fa9b2f7416 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-config.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-config.h
@@ -2045,7 +2045,7 @@ vxge_hw_vpath_strip_fcs_check(struct __vxge_hw_device *hldev, u64 vpath_mask);
 	if ((level >= VXGE_ERR && VXGE_COMPONENT_LL & VXGE_DEBUG_ERR_MASK) ||  \
 	    (level >= VXGE_TRACE && VXGE_COMPONENT_LL & VXGE_DEBUG_TRACE_MASK))\
 		if ((mask & VXGE_DEBUG_MASK) == mask)			       \
-			printk(fmt "\n", __VA_ARGS__);			       \
+			printk(fmt "\n", ##__VA_ARGS__);		       \
 } while (0)
 #else
 #define vxge_debug_ll(level, mask, fmt, ...)
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.h b/drivers/net/ethernet/neterion/vxge/vxge-main.h
index 59a57ff5e96af..9c86f4f9cd424 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.h
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.h
@@ -452,49 +452,49 @@ int vxge_fw_upgrade(struct vxgedev *vdev, char *fw_name, int override);
 
 #if (VXGE_DEBUG_LL_CONFIG & VXGE_DEBUG_MASK)
 #define vxge_debug_ll_config(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_LL_CONFIG, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_LL_CONFIG, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_ll_config(level, fmt, ...)
 #endif
 
 #if (VXGE_DEBUG_INIT & VXGE_DEBUG_MASK)
 #define vxge_debug_init(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_INIT, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_INIT, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_init(level, fmt, ...)
 #endif
 
 #if (VXGE_DEBUG_TX & VXGE_DEBUG_MASK)
 #define vxge_debug_tx(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_TX, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_TX, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_tx(level, fmt, ...)
 #endif
 
 #if (VXGE_DEBUG_RX & VXGE_DEBUG_MASK)
 #define vxge_debug_rx(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_RX, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_RX, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_rx(level, fmt, ...)
 #endif
 
 #if (VXGE_DEBUG_MEM & VXGE_DEBUG_MASK)
 #define vxge_debug_mem(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_MEM, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_MEM, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_mem(level, fmt, ...)
 #endif
 
 #if (VXGE_DEBUG_ENTRYEXIT & VXGE_DEBUG_MASK)
 #define vxge_debug_entryexit(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_ENTRYEXIT, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_ENTRYEXIT, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_entryexit(level, fmt, ...)
 #endif
 
 #if (VXGE_DEBUG_INTR & VXGE_DEBUG_MASK)
 #define vxge_debug_intr(level, fmt, ...) \
-	vxge_debug_ll(level, VXGE_DEBUG_INTR, fmt, __VA_ARGS__)
+	vxge_debug_ll(level, VXGE_DEBUG_INTR, fmt, ##__VA_ARGS__)
 #else
 #define vxge_debug_intr(level, fmt, ...)
 #endif
-- 
2.20.1

