Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5AB31F642
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 10:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbhBSJIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 04:08:41 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44428 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229924AbhBSJGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Feb 2021 04:06:07 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11J95BBG0013696, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs04.realtek.com.tw[172.21.6.97])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11J95BBG0013696
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 19 Feb 2021 17:05:11 +0800
Received: from fc32.localdomain (172.21.177.102) by RTEXMBS04.realtek.com.tw
 (172.21.6.97) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Fri, 19 Feb
 2021 17:05:10 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     <netdev@vger.kernel.org>
CC:     <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 2/4] r8152: check if the pointer of the function exists
Date:   Fri, 19 Feb 2021 17:04:41 +0800
Message-ID: <1394712342-15778-343-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <1394712342-15778-341-Taiwan-albertk@realtek.com>
References: <1394712342-15778-341-Taiwan-albertk@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [172.21.177.102]
X-ClientProxiedBy: RTEXMBS02.realtek.com.tw (172.21.6.95) To
 RTEXMBS04.realtek.com.tw (172.21.6.97)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Return error code if autosuspend_en, eee_get, or eee_set don't exist.

Signed-off-by: Hayes Wang <hayeswang@realtek.com>
---
 drivers/net/usb/r8152.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 4bfee289aa6f..baa63ea2590a 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -5757,6 +5757,9 @@ static int rtl8152_runtime_suspend(struct r8152 *tp)
 	struct net_device *netdev = tp->netdev;
 	int ret = 0;
 
+	if (!tp->rtl_ops.autosuspend_en)
+		return -EBUSY;
+
 	set_bit(SELECTIVE_SUSPEND, &tp->flags);
 	smp_mb__after_atomic();
 
@@ -6156,6 +6159,11 @@ rtl_ethtool_get_eee(struct net_device *net, struct ethtool_eee *edata)
 	struct r8152 *tp = netdev_priv(net);
 	int ret;
 
+	if (!tp->rtl_ops.eee_get) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
@@ -6178,6 +6186,11 @@ rtl_ethtool_set_eee(struct net_device *net, struct ethtool_eee *edata)
 	struct r8152 *tp = netdev_priv(net);
 	int ret;
 
+	if (!tp->rtl_ops.eee_set) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
 	ret = usb_autopm_get_interface(tp->intf);
 	if (ret < 0)
 		goto out;
-- 
2.26.2

