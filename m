Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02FFD47ECB2
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 08:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351828AbhLXHfk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 02:35:40 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:34422 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351823AbhLXHfk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 02:35:40 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: usama.anjum)
        with ESMTPSA id 6FA421F45C66
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1640331339;
        bh=WINHbJLV9eXPHd3DKDaRQMBzPBk5TS4eplE1U/AnVJk=;
        h=Date:From:To:Cc:Subject:From;
        b=YirKHeiET6IAA19/LQcKvEt/Rn/FgNuJu9JMVmK4ozo0uZCQhTo6k6rRT0pYusuay
         2Z131erpjaVflHXP+twKNaDU3LlF6/NXatdtZF4/6hXRruMRoH0usVq2VCRa37Gway
         yJxth6Eqef87XstOG/L/E5owdoc7DaTpu/EHFbblpbNuM5aG9So55rTLff2CSiw7tZ
         sR4/E267Huu55Z2E1zyNqLRWI/U/I86trr2UDfK93uWeeBUHvpzy9ULnNrLcJCWQGw
         6Pdbc4rjkYF38OcA/+t3f6hpaO9wdoRwr2PdBcTf2sQxSkwNxrhO5jJ7Gig75vVvhG
         zvgLcf9D0xX+w==
Date:   Fri, 24 Dec 2021 12:35:30 +0500
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Po-Hao Huang <phhuang@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        "open list:REALTEK WIRELESS DRIVER (rtw88)" 
        <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     usama.anjum@collabora.com, kernel@collabora.com
Subject: [PATCH v2] rtw88: check for validity before using a pointer
Message-ID: <YcV4Qkc9PrrmkOim@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ieee80211_probereq_get() can return NULL. Pointer skb should be checked
for validty before use. If it is not valid, list of skbs needs to be
freed to not memory leak.

Fixes: 10d162b2ed39 ("rtw88: 8822c: add ieee80211_ops::hw_scan")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>

---
v2:
Free the list in case of error
---
 drivers/net/wireless/realtek/rtw88/fw.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 2f7c036f9022..7e1fab7afb69 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -1857,7 +1857,7 @@ static int rtw_hw_scan_update_probe_req(struct rtw_dev *rtwdev,
 {
 	struct cfg80211_scan_request *req = rtwvif->scan_req;
 	struct sk_buff_head list;
-	struct sk_buff *skb;
+	struct sk_buff *skb, *tmp;
 	u8 num = req->n_ssids, i;
 
 	skb_queue_head_init(&list);
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
+	skb_queue_walk_safe(&list, skb, tmp)
+		kfree_skb(skb);
+
+	return -ENOMEM;
 }
 
 static int rtw_add_chan_info(struct rtw_dev *rtwdev, struct rtw_chan_info *info,
-- 
2.30.2

