Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06C3647ED85
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 09:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343732AbhLXIy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 03:54:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbhLXIy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 03:54:56 -0500
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972C4C061401;
        Fri, 24 Dec 2021 00:54:56 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id AD4C21F41522
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1640336094;
        bh=HYXUD2wnC2nF4d9aLRWZznmW4plKGdtTk8jipb8l4G4=;
        h=Date:From:To:Cc:Subject:From;
        b=NnkOxKJEBhFI0hM3hgO9HogchwfXxb8jS/LjlM36wHc/cOc1xmyup+sPdL/K5B9Es
         qCK1gqTBjmyMXPJP2f3sJjk+JAJ47at7XcNiHvY68uiGnWjitWFwa/9t7iSa3gXzlw
         kChQVei5Yv/eiOCPf5tCHk2fOnlklu8uKNcPFaahQixRXbSUSmCN5eRxw4kcjjtm/o
         XNSM/yB3ahPPCRP02H8MOmstkxps+F/Wr5MmcsbOFMG7qb9j01nekBV3pVItfnpTZX
         c/G/tORm5xjGOI+ISvQwFTh+GTYVQovFI+XbA3xFb37NNGKM3NmFGEGY2wIuhr3IhG
         V3eZ6XqLlnmnQ==
Date:   Fri, 24 Dec 2021 13:54:46 +0500
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
Subject: [PATCH v3] rtw88: check for validity before using a pointer
Message-ID: <YcWK1jxnd3vGdmCq@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_probereq_get() can return NULL. Pointer skb should be checked
for validty before use. If it is not valid, list of skbs needs to be
freed.

Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

---
v3:
Use skb_queue_walk instead of skb_queue_walk_safe
v2:
Free the list in case of error
---
 drivers/net/wireless/realtek/rtw88/fw.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2f7c036f9022..b56dc43229d2 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1866,11 +1866,19 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 					     req->ssids[i].ssid,
 					     req->ssids[i].ssid_len,
 					     req->ie_len);
+		if (!skb)
+			goto out;
 		rtw_append_probe_req_ie(rtwdev, skb, &list, rtwvif);
 		kfree_skb(skb);
 	}
 
 	return _rtw_hw_scan_update_probe_req(rtwdev, num, &list);
+
+out:
+	skb_queue_walk(&list, skb)
+		kfree_skb(skb);
+
+	return -ENOMEM;
 }
 
 static int rtw_add_chan_info(struct rtw_dev *rtwdev, struct rtw_chan_info *info,
-- 
2.30.2

