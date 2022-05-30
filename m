Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAC6D538462
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 17:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241575AbiE3Oov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 10:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240342AbiE3OnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 10:43:11 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6E014AF66
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 06:55:23 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrT-0007Ur-Iu; Mon, 30 May 2022 15:55:11 +0200
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrP-005SmX-3v; Mon, 30 May 2022 15:55:05 +0200
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1nvfrL-004dIo-Mn; Mon, 30 May 2022 15:55:03 +0200
From:   Sascha Hauer <s.hauer@pengutronix.de>
To:     linux-wireless@vger.kernel.org
Cc:     Neo Jou <neojou@gmail.com>, Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2 10/10] rtw88: disable powersave modes for USB devices
Date:   Mon, 30 May 2022 15:54:57 +0200
Message-Id: <20220530135457.1104091-11-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220530135457.1104091-1-s.hauer@pengutronix.de>
References: <20220530135457.1104091-1-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The powersave modes do not work with USB devices (tested with a
RTW8822CU) properly. With powersave modes enabled the driver issues
messages like:

rtw_8822cu 1-1:1.2: firmware failed to leave lps state
rtw_8822cu 1-1:1.2: timed out to flush queue 3

Also ping round trip times increase significantly from 1..2ms to
10..200ms.

Until this has been resolved disable the powersave modes for USB
devices.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/mac80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/mac80211.c b/drivers/net/wireless/realtek/rtw88/mac80211.c
index 3c07485d6ba47..fb5faf3bf1eed 100644
--- a/drivers/net/wireless/realtek/rtw88/mac80211.c
+++ b/drivers/net/wireless/realtek/rtw88/mac80211.c
@@ -89,7 +89,8 @@ static int rtw_ops_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_PS) {
-		if (hw->conf.flags & IEEE80211_CONF_PS) {
+		if (hw->conf.flags & IEEE80211_CONF_PS &&
+		    rtw_hci_type(rtwdev) != RTW_HCI_TYPE_USB) {
 			rtwdev->ps_enabled = true;
 		} else {
 			rtwdev->ps_enabled = false;
-- 
2.30.2

