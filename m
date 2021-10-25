Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3043439584
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 14:05:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232628AbhJYMIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 08:08:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:48744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230387AbhJYMIL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 08:08:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 473DB60EFE;
        Mon, 25 Oct 2021 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635163549;
        bh=7mZg2xUAW2p2PFxv1Ub+PcVCpHZ+A2nm8WFFfpdnc9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c05ctGXgIKVs9EOn2onvLzuWeivX0W1V0xN07UrfXT+dKDbfJhFUlsTTNq6tKIUrx
         dV08DORJYBDnzinfF4GfqNq1v9qQmPiqMqJ7PYb2MjIepQtRi68FipOmZ4neRokWt/
         aoeJk4MGV3tyVYRLDLlq+vR19TTWY1+2Qa7hIFqL0Amgb5iUf2dRu/oc+XsQGCrHfz
         3NbdlAXCwCgIwbbWeTlUrBqxUM0zDStilK7xQGBGPrXkAMK8NWc+i2mEulgkwnAs7e
         lOnFY4H9O0EZ2Dzc4yqfH+m6vwx24NEsXyR43+sT8M4beImuNhsNY25MluvuxVMpnn
         tTB5HL91encPA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1meyjM-0001aX-2R; Mon, 25 Oct 2021 14:05:32 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 4/4] rsi: fix control-message timeout
Date:   Mon, 25 Oct 2021 14:05:22 +0200
Message-Id: <20211025120522.6045-5-johan@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211025120522.6045-1-johan@kernel.org>
References: <20211025120522.6045-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

USB control-message timeouts are specified in milliseconds and should
specifically not vary with CONFIG_HZ.

Use the common control-message timeout define for the five-second
timeout.

Fixes: dad0d04fa7ba ("rsi: Add RS9113 wireless driver")
Cc: stable@vger.kernel.org      # 3.15
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 416976f09888..e97f92915ed9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -61,7 +61,7 @@ static int rsi_usb_card_write(struct rsi_hw *adapter,
 			      (void *)seg,
 			      (int)len,
 			      &transfer,
-			      HZ * 5);
+			      USB_CTRL_SET_TIMEOUT);
 
 	if (status < 0) {
 		rsi_dbg(ERR_ZONE,
-- 
2.32.0

