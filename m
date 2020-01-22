Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 905CA144CD7
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 09:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbgAVID2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 03:03:28 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:33417 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAVID0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 03:03:26 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID 00M83Mnf009279, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (smtpsrv.realtek.com[172.21.6.99])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id 00M83Mnf009279
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jan 2020 16:03:22 +0800
Received: from RTEXMB06.realtek.com.tw (172.21.6.99) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Wed, 22 Jan 2020 16:03:22 +0800
Received: from RTITCASV01.realtek.com.tw (172.21.6.18) by
 RTEXMB06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_0, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.1.1779.2
 via Frontend Transport; Wed, 22 Jan 2020 16:03:22 +0800
Received: from fc30.localdomain (172.21.177.138) by RTITCASV01.realtek.com.tw
 (172.21.6.18) with Microsoft SMTP Server id 14.3.468.0; Wed, 22 Jan 2020
 16:03:20 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <pmalani@chromium.org>,
        <grundler@chromium.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v3 2/9] r8152: reset flow control patch when linking on for RTL8153B
Date:   Wed, 22 Jan 2020 16:02:06 +0800
Message-ID: <1394712342-15778-360-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-358-Taiwan-albertk@realtek.com>
References: <1394712342-15778-338-Taiwan-albertk@realtek.com>
 <1394712342-15778-358-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.138]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When linking ON, the patch of flow control has to be reset. This
makes sure the patch works normally.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 115559707683..504db2348a3e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -2865,6 +2865,17 @@ static int rtl8153_enable(struct r8152 *tp)
 	r8153_set_rx_early_timeout(tp);
 	r8153_set_rx_early_size(tp);
 
+	if (tp->version == RTL_VER_09) {
+		u32 ocp_data;
+
+		ocp_data = ocp_read_word(tp, MCU_TYPE_USB, USB_FW_TASK);
+		ocp_data &= ~FC_PATCH_TASK;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+		usleep_range(1000, 2000);
+		ocp_data |= FC_PATCH_TASK;
+		ocp_write_word(tp, MCU_TYPE_USB, USB_FW_TASK, ocp_data);
+	}
+
 	return rtl_enable(tp);
 }
 
-- 
2.21.0

