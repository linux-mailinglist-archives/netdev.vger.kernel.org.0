Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A11029A311
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504500AbgJ0DQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:16:27 -0400
Received: from ZXSHCAS1.zhaoxin.com ([203.148.12.81]:13683 "EHLO
        ZXSHCAS1.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504094AbgJ0DQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 23:16:26 -0400
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS1.zhaoxin.com
 (10.28.252.161) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 27 Oct
 2020 11:16:23 +0800
Received: from localhost.localdomain (124.64.18.151) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 27 Oct
 2020 11:16:21 +0800
From:   WeitaoWangoc <WeitaoWang-oc@zhaoxin.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <tonywwang@zhaoxin.com>, <weitaowang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <TimGuo@zhaoxin.com>, <wwt8723@163.com>
Subject: [PATCH] rtlwifi: Fix non-canonical address access issues
Date:   Tue, 27 Oct 2020 11:16:20 +0800
Message-ID: <1603768580-2798-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [124.64.18.151]
X-ClientProxiedBy: ZXSHCAS1.zhaoxin.com (10.28.252.161) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During realtek USB wireless NIC initialization, it's unexpected
disconnection will cause urb sumbmit fail. On the one hand,
_rtl_usb_cleanup_rx will be called to clean up rx stuff, especially for
rtl_wq. On the other hand, disconnection will cause rtl_usb_disconnect
and _rtl_usb_cleanup_rx to be called. So, rtl_wq will be flush/destroy
twice, which will cause non-canonical address 0xdead000000000122 access
and general protection fault.

Fixed this issue by remove _rtl_usb_cleanup_rx when urb sumbmit fail.

Signed-off-by: WeitaoWangoc <WeitaoWang-oc@zhaoxin.com>
---
 drivers/net/wireless/realtek/rtlwifi/usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 06e073d..d62b87f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -731,7 +731,6 @@ static int _rtl_usb_receive(struct ieee80211_hw *hw)
 
 err_out:
 	usb_kill_anchored_urbs(&rtlusb->rx_submitted);
-	_rtl_usb_cleanup_rx(hw);
 	return err;
 }
 
-- 
2.7.4

