Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41988186D38
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 15:38:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgCPOiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 10:38:05 -0400
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:51937 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731507AbgCPOiF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 10:38:05 -0400
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Mar 2020 10:33:07 EDT
Received: from localhost.localdomain (unknown [58.251.74.226])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id A5C8B664FF8;
        Mon, 16 Mar 2020 22:24:06 +0800 (CST)
From:   Zheng Wei <wei.zheng@vivo.com>
To:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Jon Mason <jdmason@kudzu.us>,
        "David S. Miller" <davem@davemloft.net>,
        Yunfeng Ye <yeyunfeng@huawei.com>,
        Hanjun Guo <guohanjun@huawei.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Enrico Weigelt <info@metux.net>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel@vivo.com, wenhu.wang@vivo.com,
        Zheng Wei <wei.zheng@vivo.com>
Subject: [PATCH] net: vxge: fix wrong __VA_ARGS__ usage
Date:   Mon, 16 Mar 2020 22:23:47 +0800
Message-Id: <20200316142354.95201-1-wei.zheng@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VCTktCQkJMSE1MQ05DQllXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Phg6PBw4EDg6CjYoCksYAxA5
        UUtPC0hVSlVKTkNPSE1DTU9MT0tJVTMWGhIXVQweElUBEx4VHDsNEg0UVRgUFkVZV1kSC1lBWU5D
        VUlOSlVMT1VJSU1ZV1kIAVlBT0xPSTcG
X-HM-Tid: 0a70e3bafc5a9373kuwsa5c8b664ff8
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

printk in macro vxge_debug_ll uses __VA_ARGS__ without "##" prefix,
it causes a build error when there is no variable 
arguments(e.g. only fmt is specified.).

Signed-off-by: Zheng Wei <wei.zheng@vivo.com>
---
 drivers/net/ethernet/neterion/vxge/vxge-config.h |  2 +-
 drivers/net/ethernet/neterion/vxge/vxge-main.h   | 14 +++++++-------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/neterion/vxge/vxge-config.h b/drivers/net/ethernet/neterion/vxge/vxge-config.h
index e678ba379598..077a527bb294 100644
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
index 59a57ff5e96a..9c86f4f9cd42 100644
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
2.17.1

