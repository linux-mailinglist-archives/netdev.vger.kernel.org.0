Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E39A3AB0CB
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 12:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbhFQKCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 06:02:47 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:60396 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbhFQKCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 06:02:45 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 15HA0PfK4010237, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 15HA0PfK4010237
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 17 Jun 2021 18:00:26 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 17 Jun 2021 18:00:25 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Thu, 17 Jun
 2021 18:00:24 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next] r8152: store the information of the pipes
Date:   Thu, 17 Jun 2021 18:00:15 +0800
Message-ID: <1394712342-15778-367-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/17/2021 09:38:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzYvMTcgpFekyCAwNzo1MDowMA==?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/17/2021 09:36:41
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164440 [Jun 17 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: hayeswang@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/17/2021 09:38:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Store the information of the pipes to avoid calling usb_rcvctrlpipe(),
usb_sndctrlpipe(), usb_rcvbulkpipe(), usb_sndbulkpipe(), and
usb_rcvintpipe() frequently.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 85039e17f4cd..62cd48dc2878 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -931,6 +931,8 @@ struct r8152 {
 	u32 rx_pending;
 	u32 fc_pause_on, fc_pause_off;
 
+	unsigned int pipe_in, pipe_out, pipe_intr, pipe_ctrl_in, pipe_ctrl_out;
+
 	u32 support_2500full:1;
 	u32 lenovo_macpassthru:1;
 	u32 dell_tb_rx_agg_bug:1;
@@ -1198,7 +1200,7 @@ int get_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 	if (!tmp)
 		return -ENOMEM;
 
-	ret = usb_control_msg(tp->udev, usb_rcvctrlpipe(tp->udev, 0),
+	ret = usb_control_msg(tp->udev, tp->pipe_ctrl_in,
 			      RTL8152_REQ_GET_REGS, RTL8152_REQT_READ,
 			      value, index, tmp, size, 500);
 	if (ret < 0)
@@ -1221,7 +1223,7 @@ int set_registers(struct r8152 *tp, u16 value, u16 index, u16 size, void *data)
 	if (!tmp)
 		return -ENOMEM;
 
-	ret = usb_control_msg(tp->udev, usb_sndctrlpipe(tp->udev, 0),
+	ret = usb_control_msg(tp->udev, tp->pipe_ctrl_out,
 			      RTL8152_REQ_SET_REGS, RTL8152_REQT_WRITE,
 			      value, index, tmp, size, 500);
 
@@ -2041,7 +2043,7 @@ static int alloc_all_mem(struct r8152 *tp)
 		goto err1;
 
 	tp->intr_interval = (int)ep_intr->desc.bInterval;
-	usb_fill_int_urb(tp->intr_urb, tp->udev, usb_rcvintpipe(tp->udev, 3),
+	usb_fill_int_urb(tp->intr_urb, tp->udev, tp->pipe_intr,
 			 tp->intr_buff, INTBUFSIZE, intr_callback,
 			 tp, tp->intr_interval);
 
@@ -2305,7 +2307,7 @@ static int r8152_tx_agg_fill(struct r8152 *tp, struct tx_agg *agg)
 	if (ret < 0)
 		goto out_tx_fill;
 
-	usb_fill_bulk_urb(agg->urb, tp->udev, usb_sndbulkpipe(tp->udev, 2),
+	usb_fill_bulk_urb(agg->urb, tp->udev, tp->pipe_out,
 			  agg->head, (int)(tx_data - (u8 *)agg->head),
 			  (usb_complete_t)write_bulk_callback, agg);
 
@@ -2620,7 +2622,7 @@ int r8152_submit_rx(struct r8152 *tp, struct rx_agg *agg, gfp_t mem_flags)
 	    !test_bit(WORK_ENABLE, &tp->flags) || !netif_carrier_ok(tp->netdev))
 		return 0;
 
-	usb_fill_bulk_urb(agg->urb, tp->udev, usb_rcvbulkpipe(tp->udev, 1),
+	usb_fill_bulk_urb(agg->urb, tp->udev, tp->pipe_in,
 			  agg->buffer, tp->rx_buf_sz,
 			  (usb_complete_t)read_bulk_callback, agg);
 
@@ -9507,6 +9509,12 @@ static int rtl8152_probe(struct usb_interface *intf,
 	tp->intf = intf;
 	tp->version = version;
 
+	tp->pipe_ctrl_in = usb_rcvctrlpipe(udev, 0);
+	tp->pipe_ctrl_out = usb_sndctrlpipe(udev, 0);
+	tp->pipe_in = usb_rcvbulkpipe(udev, 1);
+	tp->pipe_out = usb_sndbulkpipe(udev, 2);
+	tp->pipe_intr = usb_rcvintpipe(udev, 3);
+
 	switch (version) {
 	case RTL_VER_01:
 	case RTL_VER_02:
-- 
2.26.3

