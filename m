Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59AC445BF5B
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 13:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343679AbhKXM5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 07:57:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:60972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345208AbhKXMzL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 07:55:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 48DC96135F;
        Wed, 24 Nov 2021 12:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757106;
        bh=RvhLvZ/ApkAe4kgJ3nlQ6+LY5y0knpUdvM3VTNWyh6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8ZInfY2ydr7QNq56g/YjX/l6uaszJEbLOO+4UMPSB2ofJkeckxdNQPWAlEuqHsk/
         TfCy/9vQUaL+zpCk97unKBy/zJHN4mys4/pJHujhgJWfTvmeGf4YVrMqK9ZV6JGNkP
         rOoeuVTX9poGUgnkj1n8NG1fbCDb8s9Lci4bKZsc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org
Subject: [PATCH 4.19 061/323] rsi: Fix module dev_oper_mode parameter description
Date:   Wed, 24 Nov 2021 12:54:11 +0100
Message-Id: <20211124115720.922099162@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

commit 31f97cf9f0c31143a2a6fcc89c4a1286ce20157e upstream.

The module parameters are missing dev_oper_mode 12, BT classic alone,
add it. Moreover, the parameters encode newlines, which ends up being
printed malformed e.g. by modinfo, so fix that too.

However, the module parameter string is duplicated in both USB and SDIO
modules and the dev_oper_mode mode enumeration in those module parameters
is a duplicate of macros used by the driver. Furthermore, the enumeration
is confusing.

So, deduplicate the module parameter string and use __stringify() to
encode the correct mode enumeration values into the module parameter
string. Finally, replace 'Wi-Fi' with 'Wi-Fi alone' and 'BT' with
'BT classic alone' to clarify what those modes really mean.

Fixes: 898b255339310 ("rsi: add module parameter operating mode")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Karun Eagalapati <karun256@gmail.com>
Cc: Martin Fuzzey <martin.fuzzey@flowbird.group>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: netdev@vger.kernel.org
Cc: <stable@vger.kernel.org> # 4.17+
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210916144245.10181-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c |    5 +----
 drivers/net/wireless/rsi/rsi_91x_usb.c  |    5 +----
 drivers/net/wireless/rsi/rsi_hal.h      |   11 +++++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -24,10 +24,7 @@
 /* Default operating mode is wlan STA + BT */
 static u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL;
 module_param(dev_oper_mode, ushort, 0444);
-MODULE_PARM_DESC(dev_oper_mode,
-		 "1[Wi-Fi], 4[BT], 8[BT LE], 5[Wi-Fi STA + BT classic]\n"
-		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
-		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
+MODULE_PARM_DESC(dev_oper_mode, DEV_OPMODE_PARAM_DESC);
 
 /**
  * rsi_sdio_set_cmd52_arg() - This function prepares cmd 52 read/write arg.
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -25,10 +25,7 @@
 /* Default operating mode is wlan STA + BT */
 static u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL;
 module_param(dev_oper_mode, ushort, 0444);
-MODULE_PARM_DESC(dev_oper_mode,
-		 "1[Wi-Fi], 4[BT], 8[BT LE], 5[Wi-Fi STA + BT classic]\n"
-		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
-		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
+MODULE_PARM_DESC(dev_oper_mode, DEV_OPMODE_PARAM_DESC);
 
 static int rsi_rx_urb_submit(struct rsi_hw *adapter, u8 ep_num, gfp_t flags);
 
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -28,6 +28,17 @@
 #define DEV_OPMODE_AP_BT		6
 #define DEV_OPMODE_AP_BT_DUAL		14
 
+#define DEV_OPMODE_PARAM_DESC		\
+	__stringify(DEV_OPMODE_WIFI_ALONE)	"[Wi-Fi alone], "	\
+	__stringify(DEV_OPMODE_BT_ALONE)	"[BT classic alone], "	\
+	__stringify(DEV_OPMODE_BT_LE_ALONE)	"[BT LE alone], "	\
+	__stringify(DEV_OPMODE_BT_DUAL)		"[BT classic + BT LE alone], " \
+	__stringify(DEV_OPMODE_STA_BT)		"[Wi-Fi STA + BT classic], " \
+	__stringify(DEV_OPMODE_STA_BT_LE)	"[Wi-Fi STA + BT LE], "	\
+	__stringify(DEV_OPMODE_STA_BT_DUAL)	"[Wi-Fi STA + BT classic + BT LE], " \
+	__stringify(DEV_OPMODE_AP_BT)		"[Wi-Fi AP + BT classic], "	\
+	__stringify(DEV_OPMODE_AP_BT_DUAL)	"[Wi-Fi AP + BT classic + BT LE]"
+
 #define FLASH_WRITE_CHUNK_SIZE		(4 * 1024)
 #define FLASH_SECTOR_SIZE		(4 * 1024)
 


