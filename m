Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2CC293A50
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 13:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393868AbgJTLyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 07:54:11 -0400
Received: from ZXSHCAS2.zhaoxin.com ([203.148.12.82]:60142 "EHLO
        ZXSHCAS2.zhaoxin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393793AbgJTLyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 07:54:10 -0400
X-Greylist: delayed 902 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Oct 2020 07:54:09 EDT
Received: from zxbjmbx1.zhaoxin.com (10.29.252.163) by ZXSHCAS2.zhaoxin.com
 (10.28.252.162) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 20 Oct
 2020 19:39:04 +0800
Received: from localhost.localdomain (61.148.243.73) by zxbjmbx1.zhaoxin.com
 (10.29.252.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 20 Oct
 2020 19:39:02 +0800
From:   WeitaoWangoc <WeitaoWang-oc@zhaoxin.com>
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <tonywwang@zhaoxin.com>, <weitaowang@zhaoxin.com>,
        <CobeChen@zhaoxin.com>, <TimGuo@zhaoxin.com>, <wwt8723@163.com>
Subject: [PATCH] Net/Usb:Fix realtek wireless NIC non-canonical address access issues
Date:   Tue, 20 Oct 2020 19:38:59 +0800
Message-ID: <1603193939-3458-1-git-send-email-WeitaoWang-oc@zhaoxin.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [61.148.243.73]
X-ClientProxiedBy: ZXSHCAS2.zhaoxin.com (10.28.252.162) To
 zxbjmbx1.zhaoxin.com (10.29.252.163)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During realtek USB wireless NIC initialization, it's unexpected
disconnection will cause urb sumbmit fail.On the one hand,
_rtl_usb_cleanup_rx will be called to clean up rx stuff, especially
for rtl_wq. On the other hand, disconnection will cause rtl_usb_disconnect
and _rtl_usb_cleanup_rx to be called.Finnally,rtl_wq will be flush/destroy
twice,which will cause non-canonical address 0xdead000000000122 access and
general protection fault.

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

