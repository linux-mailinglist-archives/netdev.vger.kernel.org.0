Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C12F81067AE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 09:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbfKVIV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 03:21:27 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:38645 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfKVIV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 03:21:27 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xAM8LNA3012514, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xAM8LNA3012514
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Fri, 22 Nov 2019 16:21:23 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Fri, 22 Nov 2019
 16:21:21 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <pmalani@chromium.org>, <grundler@chromium.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: avoid to call napi_disable twice
Date:   Fri, 22 Nov 2019 16:21:09 +0800
Message-ID: <1394712342-15778-337-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call napi_disable() twice would cause dead lock. There are three situations
may result in the issue.

1. rtl8152_pre_reset() and set_carrier() are run at the same time.
2. Call rtl8152_set_tunable() after rtl8152_close().
3. Call rtl8152_set_ringparam() after rtl8152_close().

For #1, use the same solution as commit 84811412464d ("r8152: Re-order
napi_disable in rtl8152_close"). For #2 and #3, add checking the flag
of IFF_UP and using napi_disable/napi_enable during mutex.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4d34c01826f3..b2507c59ba8b 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -4552,10 +4552,10 @@ static int rtl8152_pre_reset(struct usb_interface *intf)
 
 	netif_stop_queue(netdev);
 	tasklet_disable(&tp->tx_tl);
-	napi_disable(&tp->napi);
 	clear_bit(WORK_ENABLE, &tp->flags);
 	usb_kill_urb(tp->intr_urb);
 	cancel_delayed_work_sync(&tp->schedule);
+	napi_disable(&tp->napi);
 	if (netif_carrier_ok(netdev)) {
 		mutex_lock(&tp->control);
 		tp->rtl_ops.disable(tp);
@@ -4673,7 +4673,7 @@ static int rtl8152_system_resume(struct r8152 *tp)
 
 	netif_device_attach(netdev);
 
-	if (netif_running(netdev) && netdev->flags & IFF_UP) {
+	if (netif_running(netdev) && (netdev->flags & IFF_UP)) {
 		tp->rtl_ops.up(tp);
 		netif_carrier_off(netdev);
 		set_bit(WORK_ENABLE, &tp->flags);
@@ -5244,9 +5244,15 @@ static int rtl8152_set_tunable(struct net_device *netdev,
 		}
 
 		if (tp->rx_copybreak != val) {
-			napi_disable(&tp->napi);
-			tp->rx_copybreak = val;
-			napi_enable(&tp->napi);
+			if (netdev->flags & IFF_UP) {
+				mutex_lock(&tp->control);
+				napi_disable(&tp->napi);
+				tp->rx_copybreak = val;
+				napi_enable(&tp->napi);
+				mutex_unlock(&tp->control);
+			} else {
+				tp->rx_copybreak = val;
+			}
 		}
 		break;
 	default:
@@ -5274,9 +5280,15 @@ static int rtl8152_set_ringparam(struct net_device *netdev,
 		return -EINVAL;
 
 	if (tp->rx_pending != ring->rx_pending) {
-		napi_disable(&tp->napi);
-		tp->rx_pending = ring->rx_pending;
-		napi_enable(&tp->napi);
+		if (netdev->flags & IFF_UP) {
+			mutex_lock(&tp->control);
+			napi_disable(&tp->napi);
+			tp->rx_pending = ring->rx_pending;
+			napi_enable(&tp->napi);
+			mutex_unlock(&tp->control);
+		} else {
+			tp->rx_pending = ring->rx_pending;
+		}
 	}
 
 	return 0;
-- 
2.21.0

