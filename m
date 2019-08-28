Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DC5A024F
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 14:56:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbfH1M4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 08:56:38 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:41713 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726545AbfH1M4h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 08:56:37 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7SCuZ0N013841, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7SCuZ0N013841
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 28 Aug 2019 20:56:35 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 28 Aug 2019
 20:56:34 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v4 2/2] r8152: remove calling netif_napi_del
Date:   Wed, 28 Aug 2019 20:56:13 +0800
Message-ID: <1394712342-15778-325-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-323-Taiwan-albertk@realtek.com>
References: <1394712342-15778-314-Taiwan-albertk@realtek.com>
 <1394712342-15778-323-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unnecessary use of netif_napi_del. This also avoids to call
napi_disable() after netif_napi_del().

Fixes: ffa9fec30ca0 ("r8152: set RTL8152_UNPLUG only for real disconnection")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index ad3abe26b51b..04137ac373b0 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5352,7 +5352,6 @@ static int rtl8152_probe(struct usb_interface *intf,
 	return 0;
 
 out1:
-	netif_napi_del(&tp->napi);
 	usb_set_intfdata(intf, NULL);
 out:
 	free_netdev(netdev);
@@ -5367,7 +5366,6 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 	if (tp) {
 		rtl_set_unplug(tp);
 
-		netif_napi_del(&tp->napi);
 		unregister_netdev(tp->netdev);
 		cancel_delayed_work_sync(&tp->hw_phy_work);
 		tp->rtl_ops.unload(tp);
-- 
2.21.0

