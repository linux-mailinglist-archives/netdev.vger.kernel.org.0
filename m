Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A7A47E0DA
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 10:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347465AbhLWJ2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 04:28:38 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:54649 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235992AbhLWJ2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 04:28:38 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BN9SU3s8024150, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BN9SU3s8024150
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 23 Dec 2021 17:28:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 23 Dec 2021 17:28:30 +0800
Received: from fc34.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.20; Thu, 23 Dec
 2021 17:28:29 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <nic_swsd@realtek.com>,
        <linux-kernel@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 1/2] r8152: fix the force speed doesn't work for RTL8156
Date:   Thu, 23 Dec 2021 17:27:01 +0800
Message-ID: <20211223092702.23841-387-nic_swsd@realtek.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211223092702.23841-386-nic_swsd@realtek.com>
References: <20211223092702.23841-386-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXH36504.realtek.com.tw (172.21.6.27) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
X-KSE-ServerInfo: RTEXMBS04.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: trusted connection
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 12/23/2021 09:07:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: =?big5?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzIzIKRXpMggMDc6MTU6MDA=?=
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It needs to set mdio force mode. Otherwise, link off always occurs when
setting force speed.

Fixes: 195aae321c82 ("r8152: support new chips")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index f9877a3e83ac..a817dfd5c9eb 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6584,6 +6584,21 @@ static bool rtl8153_in_nway(struct r8152 *tp)
 		return true;
 }
 
+static void r8156_mdio_force_mode(struct r8152 *tp)
+{
+	u16 data;
+
+	/* Select force mode through 0xa5b4 bit 15
+	 * 0: MDIO force mode
+	 * 1: MMD force mode
+	 */
+	data = ocp_reg_read(tp, 0xa5b4);
+	if (data & BIT(15)) {
+		data &= ~BIT(15);
+		ocp_reg_write(tp, 0xa5b4, data);
+	}
+}
+
 static void set_carrier(struct r8152 *tp)
 {
 	struct net_device *netdev = tp->netdev;
@@ -8016,6 +8031,7 @@ static void r8156_init(struct r8152 *tp)
 	ocp_data |= ACT_ODMA;
 	ocp_write_byte(tp, MCU_TYPE_USB, USB_BMU_CONFIG, ocp_data);
 
+	r8156_mdio_force_mode(tp);
 	rtl_tally_reset(tp);
 
 	tp->coalesce = 15000;	/* 15 us */
@@ -8145,6 +8161,7 @@ static void r8156b_init(struct r8152 *tp)
 	ocp_data &= ~(RX_AGG_DISABLE | RX_ZERO_EN);
 	ocp_write_word(tp, MCU_TYPE_USB, USB_USB_CTRL, ocp_data);
 
+	r8156_mdio_force_mode(tp);
 	rtl_tally_reset(tp);
 
 	tp->coalesce = 15000;	/* 15 us */
-- 
2.31.1

