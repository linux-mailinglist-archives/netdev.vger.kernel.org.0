Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9AA40DD11
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 16:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238671AbhIPOoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 10:44:23 -0400
Received: from phobos.denx.de ([85.214.62.61]:48444 "EHLO phobos.denx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238822AbhIPOoV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 10:44:21 -0400
Received: from tr.lan (ip-89-176-112-137.net.upcbroadband.cz [89.176.112.137])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CE79982F4D;
        Thu, 16 Sep 2021 16:42:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1631803379;
        bh=bnMsJPLuWwIRnmw7gfZ0rhRZu+JFrCunlfK7f2oGpH8=;
        h=From:To:Cc:Subject:Date:From;
        b=mUED4WfwUqKXpis41D9HlgdJqmJsKkV6LoWj17fZxZ/434NSh9Gxpw8426nUNOV11
         EatYdo6b4yfWzWkxcxfZAMd31+CgWTcXAblAV+O3tbfMgzC/Z7speTMJhI+R9KDTuL
         5P/QC8r8FZWg3K/69hE5DVuETEjnEgcvRs6AA2JFGEUD/64R8TQOX8FAeuaug8cvR5
         2hSSEdHby2Q55i9WY5+/t11gDmXxu82AIEByh2l5fY5K5mLnKbOwjsx6AZRutnIQ/D
         4PnukQ+GnfDcbFZcaoECb9i2LyYB9/RgPBXUM2+CT3N0NYKKSi8opb+1gjAQ3EZRlg
         cphvtCqlqBTNg==
From:   Marek Vasut <marex@denx.de>
To:     linux-wireless@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Karun Eagalapati <karun256@gmail.com>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH v2] rsi: Fix module dev_oper_mode parameter description
Date:   Thu, 16 Sep 2021 16:42:45 +0200
Message-Id: <20210916144245.10181-1-marex@denx.de>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
--
V2: - Update description of DEV_OPMODE_BT_LE_ALONE DEV_OPMODE_BT_DUAL
      DEV_OPMODE_AP_BT DEV_OPMODE_AP_BT_DUAL to include "alone" and
      "Wi-Fi" consistently.
    - Cc netdev and to linux-wireless
---
 drivers/net/wireless/rsi/rsi_91x_sdio.c |  5 +----
 drivers/net/wireless/rsi/rsi_91x_usb.c  |  5 +----
 drivers/net/wireless/rsi/rsi_hal.h      | 11 +++++++++++
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index e0c502bc42707..9f16128e4ffab 100644
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
diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 416976f098882..6a120211800db 100644
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
 
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index d044a440fa080..5b07262a97408 100644
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
 
-- 
2.33.0

