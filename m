Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9209691DFE
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 12:17:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjBJLRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 06:17:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232085AbjBJLQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 06:16:50 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C54472DF1
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 03:16:43 -0800 (PST)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <sha@pengutronix.de>)
        id 1pQROO-0003KV-Ot; Fri, 10 Feb 2023 12:16:36 +0100
Received: from [2a0a:edc0:0:1101:1d::28] (helo=dude02.red.stw.pengutronix.de)
        by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pQROM-003xEW-CS; Fri, 10 Feb 2023 12:16:35 +0100
Received: from sha by dude02.red.stw.pengutronix.de with local (Exim 4.94.2)
        (envelope-from <sha@pengutronix.de>)
        id 1pQROM-008k9X-Mu; Fri, 10 Feb 2023 12:16:34 +0100
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
Subject: [PATCH v2 0/3] wifi: rtw88: USB fixes
Date:   Fri, 10 Feb 2023 12:16:29 +0100
Message-Id: <20230210111632.1985205-1-s.hauer@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

This series addresses issues for the recently added RTW88 USB support
reported by Andreas Henriksson and also our customer.

The hardware can't handle urbs that have a size of multiple of the
bulkout_size (usually 512 bytes). The symptom is that the hardware
stalls completely. The issue can be reproduced by sending a suitably
sized ping packet from the device:

ping -s 394 <somehost>

(It's 394 bytes here on a RTL8822CU and RTL8821CU, the actual size may
differ on other chips, it was 402 bytes on a RTL8723DU)

Other than that qsel was not set correctly. The sympton here is that
only one of multiple bulk endpoints was used to send data.

Changes since v1:
- Use URB_ZERO_PACKET to let the USB host controller handle it automatically
  rather than working around the issue.

Sascha Hauer (3):
  wifi: rtw88: usb: Set qsel correctly
  wifi: rtw88: usb: send Zero length packets if necessary
  wifi: rtw88: usb: drop now unnecessary URB size check

 drivers/net/wireless/realtek/rtw88/usb.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

-- 
2.30.2

