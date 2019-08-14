Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D86EC8CE77
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 10:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbfHNIak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 04:30:40 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:58191 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbfHNIak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 04:30:40 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7E8Uc0Y027914, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7E8Uc0Y027914
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Wed, 14 Aug 2019 16:30:38 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 14 Aug 2019
 16:30:36 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: divide the tx and rx bottom functions
Date:   Wed, 14 Aug 2019 16:30:17 +0800
Message-ID: <1394712342-15778-301-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move the tx bottom function from NAPI to a new tasklet. Then, for
multi-cores, the bottom functions of tx and rx may be run at same
time with different cores. This is used to improve performance.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 40d18e866269..3ed9f8e082c9 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -619,7 +619,7 @@ enum rtl8152_flags {
 	RTL8152_LINK_CHG,
 	SELECTIVE_SUSPEND,
 	PHY_RESET,
-	SCHEDULE_NAPI,
+	SCHEDULE_TASKLET,
 	GREEN_ETHERNET,
 	DELL_TB_RX_AGG_BUG,
 };
@@ -733,6 +733,7 @@ struct r8152 {
 #ifdef CONFIG_PM_SLEEP
 	struct notifier_block pm_notifier;
 #endif
+	struct tasklet_struct tx_tl;
 
 	struct rtl_ops {
 		void (*init)(struct r8152 *);
@@ -1401,7 +1402,7 @@ static void write_bulk_callback(struct urb *urb)
 		return;
 
 	if (!skb_queue_empty(&tp->tx_queue))
-		napi_schedule(&tp->napi);
+		tasklet_schedule(&tp->tx_tl);
 }
 
 static void intr_callback(struct urb *urb)
@@ -2179,8 +2180,12 @@ static void tx_bottom(struct r8152 *tp)
 	} while (res == 0);
 }
 
-static void bottom_half(struct r8152 *tp)
+static void bottom_half(unsigned long data)
 {
+	struct r8152 *tp;
+
+	tp = (struct r8152 *)data;
+
 	if (test_bit(RTL8152_UNPLUG, &tp->flags))
 		return;
 
@@ -2192,7 +2197,7 @@ static void bottom_half(struct r8152 *tp)
 	if (!netif_carrier_ok(tp->netdev))
 		return;
 
-	clear_bit(SCHEDULE_NAPI, &tp->flags);
+	clear_bit(SCHEDULE_TASKLET, &tp->flags);
 
 	tx_bottom(tp);
 }
@@ -2203,16 +2208,12 @@ static int r8152_poll(struct napi_struct *napi, int budget)
 	int work_done;
 
 	work_done = rx_bottom(tp, budget);
-	bottom_half(tp);
 
 	if (work_done < budget) {
 		if (!napi_complete_done(napi, work_done))
 			goto out;
 		if (!list_empty(&tp->rx_done))
 			napi_schedule(napi);
-		else if (!skb_queue_empty(&tp->tx_queue) &&
-			 !list_empty(&tp->tx_free))
-			napi_schedule(napi);
 	}
 
 out:
@@ -2366,11 +2367,11 @@ static netdev_tx_t rtl8152_start_xmit(struct sk_buff *skb,
 
 	if (!list_empty(&tp->tx_free)) {
 		if (test_bit(SELECTIVE_SUSPEND, &tp->flags)) {
-			set_bit(SCHEDULE_NAPI, &tp->flags);
+			set_bit(SCHEDULE_TASKLET, &tp->flags);
 			schedule_delayed_work(&tp->schedule, 0);
 		} else {
 			usb_mark_last_busy(tp->udev);
-			napi_schedule(&tp->napi);
+			tasklet_schedule(&tp->tx_tl);
 		}
 	} else if (skb_queue_len(&tp->tx_queue) > tp->tx_qlen) {
 		netif_stop_queue(netdev);
@@ -4020,9 +4021,11 @@ static void set_carrier(struct r8152 *tp)
 	} else {
 		if (netif_carrier_ok(netdev)) {
 			netif_carrier_off(netdev);
+			tasklet_disable(&tp->tx_tl);
 			napi_disable(napi);
 			tp->rtl_ops.disable(tp);
 			napi_enable(napi);
+			tasklet_enable(&tp->tx_tl);
 			netif_info(tp, link, netdev, "carrier off\n");
 		}
 	}
@@ -4055,10 +4058,10 @@ static void rtl_work_func_t(struct work_struct *work)
 	if (test_and_clear_bit(RTL8152_SET_RX_MODE, &tp->flags))
 		_rtl8152_set_rx_mode(tp->netdev);
 
-	/* don't schedule napi before linking */
-	if (test_and_clear_bit(SCHEDULE_NAPI, &tp->flags) &&
+	/* don't schedule tasket before linking */
+	if (test_and_clear_bit(SCHEDULE_TASKLET, &tp->flags) &&
 	    netif_carrier_ok(tp->netdev))
-		napi_schedule(&tp->napi);
+		tasklet_schedule(&tp->tx_tl);
 
 	mutex_unlock(&tp->control);
 
@@ -4144,6 +4147,7 @@ static int rtl8152_open(struct net_device *netdev)
 		goto out_unlock;
 	}
 	napi_enable(&tp->napi);
+	tasklet_enable(&tp->tx_tl);
 
 	mutex_unlock(&tp->control);
 
@@ -4171,6 +4175,7 @@ static int rtl8152_close(struct net_device *netdev)
 #ifdef CONFIG_PM_SLEEP
 	unregister_pm_notifier(&tp->pm_notifier);
 #endif
+	tasklet_disable(&tp->tx_tl);
 	if (!test_bit(RTL8152_UNPLUG, &tp->flags))
 		napi_disable(&tp->napi);
 	clear_bit(WORK_ENABLE, &tp->flags);
@@ -4440,6 +4445,7 @@ static int rtl8152_pre_reset(struct usb_interface *intf)
 		return 0;
 
 	netif_stop_queue(netdev);
+	tasklet_disable(&tp->tx_tl);
 	napi_disable(&tp->napi);
 	clear_bit(WORK_ENABLE, &tp->flags);
 	usb_kill_urb(tp->intr_urb);
@@ -4483,6 +4489,7 @@ static int rtl8152_post_reset(struct usb_interface *intf)
 	}
 
 	napi_enable(&tp->napi);
+	tasklet_enable(&tp->tx_tl);
 	netif_wake_queue(netdev);
 	usb_submit_urb(tp->intr_urb, GFP_KERNEL);
 
@@ -4636,10 +4643,12 @@ static int rtl8152_system_suspend(struct r8152 *tp)
 
 		clear_bit(WORK_ENABLE, &tp->flags);
 		usb_kill_urb(tp->intr_urb);
+		tasklet_disable(&tp->tx_tl);
 		napi_disable(napi);
 		cancel_delayed_work_sync(&tp->schedule);
 		tp->rtl_ops.down(tp);
 		napi_enable(napi);
+		tasklet_enable(&tp->tx_tl);
 	}
 
 	return 0;
@@ -5499,6 +5508,8 @@ static int rtl8152_probe(struct usb_interface *intf,
 	mutex_init(&tp->control);
 	INIT_DELAYED_WORK(&tp->schedule, rtl_work_func_t);
 	INIT_DELAYED_WORK(&tp->hw_phy_work, rtl_hw_phy_work_func_t);
+	tasklet_init(&tp->tx_tl, bottom_half, (unsigned long)tp);
+	tasklet_disable(&tp->tx_tl);
 
 	netdev->netdev_ops = &rtl8152_netdev_ops;
 	netdev->watchdog_timeo = RTL8152_TX_TIMEOUT;
@@ -5585,6 +5596,7 @@ static int rtl8152_probe(struct usb_interface *intf,
 
 out1:
 	netif_napi_del(&tp->napi);
+	tasklet_kill(&tp->tx_tl);
 	usb_set_intfdata(intf, NULL);
 out:
 	free_netdev(netdev);
@@ -5601,6 +5613,7 @@ static void rtl8152_disconnect(struct usb_interface *intf)
 
 		netif_napi_del(&tp->napi);
 		unregister_netdev(tp->netdev);
+		tasklet_kill(&tp->tx_tl);
 		cancel_delayed_work_sync(&tp->hw_phy_work);
 		tp->rtl_ops.unload(tp);
 		free_netdev(tp->netdev);
-- 
2.21.0

