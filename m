Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B556401B5
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:12:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiLBIMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:12:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbiLBIMj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:12:39 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44358CD7
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 00:12:34 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1p119p-0005A7-GV; Fri, 02 Dec 2022 09:12:29 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119o-001lGd-0F; Fri, 02 Dec 2022 09:12:28 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1p119m-00BfDa-O6; Fri, 02 Dec 2022 09:12:26 +0100
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v5 01/11] wifi: rtw88: print firmware type in info message
Date:   Fri,  2 Dec 2022 09:12:14 +0100
Message-Id: <20221202081224.2779981-2-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221202081224.2779981-1-s.hauer@pengutronix.de>
References: <20221202081224.2779981-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's confusing to read two different firmware versions in the syslog
for the same device:

rtw_8822cu 2-1:1.2: Firmware version 9.9.4, H2C version 15
rtw_8822cu 2-1:1.2: Firmware version 9.9.11, H2C version 15

Print the firmware type in this message to make clear these are really
two different firmwares for different purposes:

rtw_8822cu 1-1.4:1.2: WOW Firmware version 9.9.4, H2C version 15
rtw_8822cu 1-1.4:1.2: Firmware version 9.9.11, H2C version 15

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes since v2:
    - new patch

 drivers/net/wireless/realtek/rtw88/main.c | 4 +++-
 drivers/net/wireless/realtek/rtw88/main.h | 1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.c b/drivers/net/wireless/realtek/rtw88/main.c
index 67151dbf83842..a7331872e8530 100644
--- a/drivers/net/wireless/realtek/rtw88/main.c
+++ b/drivers/net/wireless/realtek/rtw88/main.c
@@ -1731,7 +1731,8 @@ static void rtw_load_firmware_cb(const struct firmware *firmware, void *context)
 	update_firmware_info(rtwdev, fw);
 	complete_all(&fw->completion);
 
-	rtw_info(rtwdev, "Firmware version %u.%u.%u, H2C version %u\n",
+	rtw_info(rtwdev, "%sFirmware version %u.%u.%u, H2C version %u\n",
+		 fw->type == RTW_WOWLAN_FW ? "WOW " : "",
 		 fw->version, fw->sub_version, fw->sub_index, fw->h2c_version);
 }
 
@@ -1757,6 +1758,7 @@ static int rtw_load_firmware(struct rtw_dev *rtwdev, enum rtw_fw_type type)
 		return -ENOENT;
 	}
 
+	fw->type = type;
 	fw->rtwdev = rtwdev;
 	init_completion(&fw->completion);
 
diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index bccd7b28f60c7..6e5875f6d07f4 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -1851,6 +1851,7 @@ struct rtw_fw_state {
 	u16 h2c_version;
 	u32 feature;
 	u32 feature_ext;
+	enum rtw_fw_type type;
 };
 
 enum rtw_sar_sources {
-- 
2.30.2

