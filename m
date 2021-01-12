Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64C2F300C
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391157AbhALNBq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:01:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390378AbhALM6t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A6E523131;
        Tue, 12 Jan 2021 12:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456308;
        bh=QJ0A0EhUashHLTJ1XMRAOnWqgYjJaaUrFi4eR/gRtEM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1BJ4Te/u9pGr3nfF2iGOMJKqMBX7ZIAWaHuZCtZtsF3kMaN3Spy3bkGibfXaqZFc
         fT5UtJteaPIBRiY1PE8R4npuQ3MYm9GZD8RAQ/OWj7LsfSkBtuBtqqUuc+Ypf/0OhF
         yY/tm8Yjhvty1xjh5ktzETZaagnpo+4d4TF8327qILT4fHFTofH2T2FdTrdXMNic+6
         rrsT7rzhobBs5bMIWNzUDVmh0xVcgixrPEl++6QsoZPEmMr4cJLG6SBgkFaSM7+Q7u
         tNTNT5jXXzlKlHSS0N94kDqm8cEqBrbKiaCCk7hXImsvYY2cIFctM1fWFB9sMcXxAi
         Z+FQSt2KNP3QQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roland Dreier <roland@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/8] CDC-NCM: remove "connected" log message
Date:   Tue, 12 Jan 2021 07:58:18 -0500
Message-Id: <20210112125823.71463-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125823.71463-1-sashal@kernel.org>
References: <20210112125823.71463-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roland Dreier <roland@kernel.org>

[ Upstream commit 59b4a8fa27f5a895582ada1ae5034af7c94a57b5 ]

The cdc_ncm driver passes network connection notifications up to
usbnet_link_change(), which is the right place for any logging.
Remove the netdev_info() duplicating this from the driver itself.

This stops devices such as my "TRENDnet USB 10/100/1G/2.5G LAN"
(ID 20f4:e02b) adapter from spamming the kernel log with

    cdc_ncm 2-2:2.0 enp0s2u2c2: network connection: connected

messages every 60 msec or so.

Signed-off-by: Roland Dreier <roland@kernel.org>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20201224032116.2453938-1-roland@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/cdc_ncm.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/usb/cdc_ncm.c b/drivers/net/usb/cdc_ncm.c
index bab13ccfb0850..e9f82b67c7edf 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1553,9 +1553,6 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
 		 * USB_CDC_NOTIFY_NETWORK_CONNECTION notification shall be
 		 * sent by device after USB_CDC_NOTIFY_SPEED_CHANGE.
 		 */
-		netif_info(dev, link, dev->net,
-			   "network connection: %sconnected\n",
-			   !!event->wValue ? "" : "dis");
 		usbnet_link_change(dev, !!event->wValue, 0);
 		break;
 
-- 
2.27.0

