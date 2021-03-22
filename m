Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E85CC343E3E
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 11:45:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhCVKpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 06:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhCVKpD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 06:45:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DAE2761931;
        Mon, 22 Mar 2021 10:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616409903;
        bh=zSlzhTb9+O7YX45ZK09VbrHld90WpzlBFw4V1GQ4JBA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M7J+pr2zXhZare1qLpPeu2g2PTWhQw5yYHBQ2W7k4u9qZK+C4eSmlGHD83+0rs12F
         56shnLHZG9zERgEWRgLiGZI4E4HhfjSF1Q58zdo6nuimaUZLA3bTikyt/x3wNp1l5i
         hg2uQ2Ixb6wFRArR8uHOS0ejrkEOCIKfhSNyKnyovh/1/lgkG9Y5AAN2LunlzwxYkV
         MFEwGp+7uXBi29JGHdQnzNw35DIJ8hjh31NnJ87M+Ca8OyLBQplv8x9q+rHYa17uXh
         YeHw7Ajir+/74iLpL0myyjR+dK5o/4grFXdanVXWeO44MktT3lisssE3+aVV/BaNFQ
         GbPxKt0lWnLjQ==
From:   Arnd Bergmann <arnd@kernel.org>
To:     netdev@vger.kernel.org, Stanislaw Gruszka <stf_xl@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, Lee Jones <lee.jones@linaro.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/5] iwlegacy: avoid -Wempty-body warning
Date:   Mon, 22 Mar 2021 11:43:33 +0100
Message-Id: <20210322104343.948660-3-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322104343.948660-1-arnd@kernel.org>
References: <20210322104343.948660-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

There are a couple of warnings in this driver when building with W=1:

drivers/net/wireless/intel/iwlegacy/common.c: In function 'il_power_set_mode':
drivers/net/wireless/intel/iwlegacy/common.c:1195:60: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
 1195 |                                 il->chain_noise_data.state);
      |                                                            ^
drivers/net/wireless/intel/iwlegacy/common.c: In function 'il_do_scan_abort':
drivers/net/wireless/intel/iwlegacy/common.c:1343:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]

Change the empty debug macros to no_printk(), which avoids the
warnings and adds useful format string checks.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlegacy/3945-mac.c | 2 --
 drivers/net/wireless/intel/iwlegacy/common.c   | 2 --
 drivers/net/wireless/intel/iwlegacy/common.h   | 2 +-
 3 files changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 4ca8212d4fa4..6ff2674f8466 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -751,9 +751,7 @@ il3945_hdl_alive(struct il_priv *il, struct il_rx_buf *rxb)
 static void
 il3945_hdl_add_sta(struct il_priv *il, struct il_rx_buf *rxb)
 {
-#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
-#endif
 
 	D_RX("Received C_ADD_STA: 0x%02X\n", pkt->u.status);
 }
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 0651a6a416d1..219fed91cac5 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -1430,10 +1430,8 @@ static void
 il_hdl_scan_complete(struct il_priv *il, struct il_rx_buf *rxb)
 {
 
-#ifdef CONFIG_IWLEGACY_DEBUG
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
 	struct il_scancomplete_notification *scan_notif = (void *)pkt->u.raw;
-#endif
 
 	D_SCAN("Scan complete: %d channels (TSF 0x%08X:%08X) - %d\n",
 	       scan_notif->scanned_channels, scan_notif->tsf_low,
diff --git a/drivers/net/wireless/intel/iwlegacy/common.h b/drivers/net/wireless/intel/iwlegacy/common.h
index ea1b1bb7ddcb..40877ef1fbf2 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.h
+++ b/drivers/net/wireless/intel/iwlegacy/common.h
@@ -2937,7 +2937,7 @@ do {									\
 } while (0)
 
 #else
-#define IL_DBG(level, fmt, args...)
+#define IL_DBG(level, fmt, args...) no_printk(fmt, ##args)
 static inline void
 il_print_hex_dump(struct il_priv *il, int level, const void *p, u32 len)
 {
-- 
2.29.2

