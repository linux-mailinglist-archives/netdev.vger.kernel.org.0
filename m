Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C18CA3416C8
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 08:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234142AbhCSHjE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 03:39:04 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:54443 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234158AbhCSHjB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 03:39:01 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 12J7cvltF005050, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 12J7cvltF005050
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Mar 2021 15:38:57 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Mar
 2021 15:38:57 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>,
        Robert Davies <robdavies1977@gmail.com>
Subject: [PATCH net] r8152: limit the RX buffer size of RTL8153A for USB 2.0
Date:   Fri, 19 Mar 2021 15:37:21 +0800
Message-ID: <1394712342-15778-349-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS01.realtek.com.tw (172.21.6.94) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the USB host controller is EHCI, the throughput is reduced from
300Mb/s to 60Mb/s, when the rx buffer size is modified from 16K to
32K.

According to the EHCI spec, the maximum size of the qTD is 20K.
Therefore, when the driver uses more than 20K buffer, the latency
time of EHCI would be increased. And, it let the RTL8153A get worse
throughput.

However, the driver uses alloc_pages() for rx buffer, so I limit
the rx buffer to 16K rather than 20K.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=205923
Fixes: ec5791c202ac ("r8152: separate the rx buffer size")
Reported-by: Robert Davies <robdavies1977@gmail.com>
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 90f1c0200042..20fb5638ac65 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -6553,7 +6553,10 @@ static int rtl_ops_init(struct r8152 *tp)
 		ops->in_nway		= rtl8153_in_nway;
 		ops->hw_phy_cfg		= r8153_hw_phy_cfg;
 		ops->autosuspend_en	= rtl8153_runtime_enable;
-		tp->rx_buf_sz		= 32 * 1024;
+		if (tp->udev->speed < USB_SPEED_SUPER)
+			tp->rx_buf_sz	= 16 * 1024;
+		else
+			tp->rx_buf_sz	= 32 * 1024;
 		tp->eee_en		= true;
 		tp->eee_adv		= MDIO_EEE_1000T | MDIO_EEE_100TX;
 		break;
-- 
2.26.2

