Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6096D691E03
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:17:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjBJLRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:17:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjBJLQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:16:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5499E72DEF
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:16:43 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pQROO-0003KX-Ok; Fri, 10 Feb 2023 12:16:36 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pQROM-003xEb-EO; Fri, 10 Feb 2023 12:16:35 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pQROM-008k9f-P8; Fri, 10 Feb 2023 12:16:34 +0100
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
        Andreas Henriksson <andreas@fatal.se>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH v2 3/3] wifi: rtw88: usb: drop now unnecessary URB size check
Date:   Fri, 10 Feb 2023 12:16:32 +0100
Message-Id: <20230210111632.1985205-4-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230210111632.1985205-1-s.hauer@pengutronix.de>
References: <20230210111632.1985205-1-s.hauer@pengutronix.de>
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

Now that we send URBs with the URB_ZERO_PACKET flag set we no longer
need to make sure that the URB sizes are not multiple of the
bulkout_size. Drop the check.

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/net/wireless/realtek/rtw88/usb.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
index 1a09c9288198a..2a8336b1847a5 100644
--- a/drivers/net/wireless/realtek/rtw88/usb.c
+++ b/drivers/net/wireless/realtek/rtw88/usb.c
@@ -414,24 +414,11 @@ static int rtw_usb_write_data_rsvd_page(struct rtw_dev *rtwdev, u8 *buf,
 					u32 size)
 {
 	const struct rtw_chip_info *chip = rtwdev->chip;
-	struct rtw_usb *rtwusb;
 	struct rtw_tx_pkt_info pkt_info = {0};
-	u32 len, desclen;
-
-	rtwusb = rtw_get_usb_priv(rtwdev);
 
 	pkt_info.tx_pkt_size = size;
 	pkt_info.qsel = TX_DESC_QSEL_BEACON;
-
-	desclen = chip->tx_pkt_desc_sz;
-	len = desclen + size;
-	if (len % rtwusb->bulkout_size == 0) {
-		len += RTW_USB_PACKET_OFFSET_SZ;
-		pkt_info.offset = desclen + RTW_USB_PACKET_OFFSET_SZ;
-		pkt_info.pkt_offset = 1;
-	} else {
-		pkt_info.offset = desclen;
-	}
+	pkt_info.offset = chip->tx_pkt_desc_sz;
 
 	return rtw_usb_write_data(rtwdev, &pkt_info, buf);
 }
-- 
2.30.2

