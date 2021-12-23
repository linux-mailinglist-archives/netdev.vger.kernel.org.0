Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE78147E742
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 18:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbhLWRvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Dec 2021 12:51:24 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58722 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhLWRvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Dec 2021 12:51:20 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 61C811F45B43
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1640281879;
        bh=vSHHzM172vviSgHfuy9G5kDiYvUz/KyNzVxzK+d+55s=;
        h=Date:From:To:Cc:Subject:From;
        b=Z96U0ih/lxwTzQ1z7q++gg8g8D9E3t56qzlFhKGr0wSnqorf543tJ0xXHwwq97fIv
         Zpzd5b9Vfh+oLhXniDkqQQ/xrPDZKcicbCJ5vXk4vbBoBCJ2G/HKoS3clPPkUPqo1L
         oLCCF6dRi2Fft3ejIw9fST/QYms1yiqlGSVmd4SBU1Ll0jWtl7Zf40zl9Bled4Xsep
         b5UNblnXF+A+Y6x9ZOJ8OF2egs999+KC4QaBd2Jyl0X1eWaMLbY+uab0/19uTyVvE6
         X6qr0BJRvcetA/Lf3x4IbXpEmtTFMT0BE4O48dbiCQzDDUJoXUr+xsCVDKbJQWCtgs
         azxWIRkHDUj/A==
Date:   Thu, 23 Dec 2021 22:51:11 +0500
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Po-Hao Huang <phhuang@realtek.com>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     usama.anjum@collabora.com, kernel@collabora.com
Subject: [PATCH] rtw88: check for validity before using pointer
Message-ID: <YcS3D2lwMd0Kox3z@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_probereq_get() can return NULL. Pointer skb should be checked
for validty before use.

Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2f7c036f9022..0fc05a810d05 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1866,6 +1866,8 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 					     req->ssids[i].ssid,
 					     req->ssids[i].ssid_len,
 					     req->ie_len);
+		if (!skb)
+			return -ENOMEM;
 		rtw_append_probe_req_ie(rtwdev, skb, &list, rtwvif);
 		kfree_skb(skb);
 	}
-- 
2.30.2

