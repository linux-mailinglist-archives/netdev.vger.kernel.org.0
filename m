Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C792F3074
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:15:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405135AbhALM6V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 07:58:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390434AbhALM6T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB0B52332A;
        Tue, 12 Jan 2021 12:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456255;
        bh=vEfqYb1slQpDHscuOQ9ddy7UIs1M+3Umn9b/6Rq80p0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBIy5Djx3tHNMLxL4swrGWQpz+FbrpoojnGvyUAXrT9YXI5FoqsryI8zdT1fBwZdF
         rSng8GvlnUJAxu5lKDh3Na+AZIGsNzFZYKxa9jjwadem7kXZ1ONj3pFUrv9NwPHKNl
         OvacpTKh5xo54HNFaPDBlOIXgfDRZUCxIs6D6W+6jSC8XEnXc+hkiyp/qCyuvq2J/Z
         RtG+NNhadHLiORUQ+m+7UozEm5Rs3mghOcnvPtldnVz+YsDlWy0WNIpu2tscF3Qm4q
         Bt9osom35RH92cIzQPGaMNOWOic/6IJh04qPYhGKJy68bydH2L7r4OP4OaJqZX6TWF
         o6IqIEId+kedg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roland Dreier <roland@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 07/16] CDC-NCM: remove "connected" log message
Date:   Tue, 12 Jan 2021 07:57:16 -0500
Message-Id: <20210112125725.71014-7-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125725.71014-1-sashal@kernel.org>
References: <20210112125725.71014-1-sashal@kernel.org>
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
index 1f57a6a2b8a25..e0bbefcbefa17 100644
--- a/drivers/net/usb/cdc_ncm.c
+++ b/drivers/net/usb/cdc_ncm.c
@@ -1629,9 +1629,6 @@ static void cdc_ncm_status(struct usbnet *dev, struct urb *urb)
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

