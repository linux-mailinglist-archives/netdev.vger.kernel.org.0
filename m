Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238BE4205DF
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 08:31:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhJDGcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 02:32:46 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:43209 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232131AbhJDGcp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 02:32:45 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1946Uj0J2014914, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36503.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1946Uj0J2014914
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 4 Oct 2021 14:30:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36503.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Mon, 4 Oct 2021 14:30:45 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Mon, 4 Oct 2021
 14:30:44 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <jason-ch.chen@mediatek.com>, <kuba@kernel.org>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net] r8152: avoid to resubmit rx immediately
Date:   Mon, 4 Oct 2021 14:28:58 +0800
Message-ID: <20211004062858.1679-381-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36503.realtek.com.tw (172.21.6.25) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/04/2021 06:21:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEwLzQgpFekyCAwNDo1MTowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36503.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 10/04/2021 06:17:40
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 166474 [Oct 04 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 463 463 5854868460de3f0d8e8c0a4df98aeb05fb764a09
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 10/04/2021 06:21:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For the situation that the disconnect event comes very late when the
device is unplugged, the driver would resubmit the RX bulk transfer
after getting the callback with -EPROTO immediately and continually.
Finally, soft lockup occurs.

This patch avoids to resubmit RX immediately. It uses a workqueue to
schedule the RX NAPI. And the NAPI would resubmit the RX. It let the
disconnect event have opportunity to stop the submission before soft
lockup.

Reported-by: Jason-ch Chen <jason-ch.chen@mediatek.com>
Tested-by: Jason-ch Chen <jason-ch.chen@mediatek.com>
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 60ba9b734055..f329e39100a7 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -767,6 +767,7 @@ enum rtl8152_flags {
 	PHY_RESET,
 	SCHEDULE_TASKLET,
 	GREEN_ETHERNET,
+	RX_EPROTO,
 };
 
 #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
@@ -1770,6 +1771,14 @@ static void read_bulk_callback(struct urb *urb)
 		rtl_set_unplug(tp);
 		netif_device_detach(tp->netdev);
 		return;
+	case -EPROTO:
+		urb->actual_length = 0;
+		spin_lock_irqsave(&tp->rx_lock, flags);
+		list_add_tail(&agg->list, &tp->rx_done);
+		spin_unlock_irqrestore(&tp->rx_lock, flags);
+		set_bit(RX_EPROTO, &tp->flags);
+		schedule_delayed_work(&tp->schedule, 1);
+		return;
 	case -ENOENT:
 		return;	/* the urb is in unlink state */
 	case -ETIME:
@@ -2425,6 +2434,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 	if (list_empty(&tp->rx_done))
 		goto out1;
 
+	clear_bit(RX_EPROTO, &tp->flags);
 	INIT_LIST_HEAD(&rx_queue);
 	spin_lock_irqsave(&tp->rx_lock, flags);
 	list_splice_init(&tp->rx_done, &rx_queue);
@@ -2441,7 +2451,7 @@ static int rx_bottom(struct r8152 *tp, int budget)
 
 		agg = list_entry(cursor, struct rx_agg, list);
 		urb = agg->urb;
-		if (urb->actual_length < ETH_ZLEN)
+		if (urb->status != 0 || urb->actual_length < ETH_ZLEN)
 			goto submit;
 
 		agg_free = rtl_get_free_rx(tp, GFP_ATOMIC);
@@ -6643,6 +6653,10 @@ static void rtl_work_func_t(struct work_struct *work)
 	    netif_carrier_ok(tp->netdev))
 		tasklet_schedule(&tp->tx_tl);
 
+	if (test_and_clear_bit(RX_EPROTO, &tp->flags) &&
+	    !list_empty(&tp->rx_done))
+		napi_schedule(&tp->napi);
+
 	mutex_unlock(&tp->control);
 
 out1:
-- 
2.31.1

