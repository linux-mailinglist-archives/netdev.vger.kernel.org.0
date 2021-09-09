Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542E1404FD6
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353519AbhIIMXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:58738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351502AbhIIMTL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:19:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1CF261A61;
        Thu,  9 Sep 2021 11:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188210;
        bh=6FDQBhcItzQbsWO+IHXEjY8lZVlNaOGGqGUti7G3Zo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOYpiL5mds7GYCVUw3gHdjufZXJj5f5gP6lOxwSlssn697JOgKOksqyCH8RO/1RjT
         g8hq/Wz/rHHqDfqjUR3XOtlzibxYD+mX+ruXZEbH2VStm1MY/LwvPu3RcAf4JHmXFQ
         kX+Ff8tjON1ADvN/SLYtlvt/0PJwpc0oJPyEWw2XoL6gSjB2BaXxYrc5igHd3Dz1Th
         B+bpcsd74ncxx7IopkVrOW5M7/toPX+NZRB+losmxYvbsylLu9IaAa9I2ZpQ6jFFk4
         vkF7wp8ZNfsWT8HGbMsENxQ15k8PBn8py4EJ7XD2bH2epp9rGObfp1+jetX3GGClWJ
         /FaPIZUmW6PmQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chin-Yen Lee <timlee@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 166/219] rtw88: wow: fix size access error of probe request
Date:   Thu,  9 Sep 2021 07:45:42 -0400
Message-Id: <20210909114635.143983-166-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 69c7044526d984df672b8d9b6d6998c34617cde4 ]

Current flow will lead to null ptr access because of trying
to get the size of freed probe-request packets. We store the
information of packet size into rsvd page instead and also fix
the size error issue, which will cause unstable behavoir of
sending probe request by wow firmware.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20210728014335.8785-6-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 8 ++++++--
 drivers/net/wireless/realtek/rtw88/fw.h | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index ea2cd4db1d3c..ce57932e38a4 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -715,7 +715,7 @@ static u16 rtw_get_rsvd_page_probe_req_size(struct rtw_dev *rtwdev,
 			continue;
 		if ((!ssid && !rsvd_pkt->ssid) ||
 		    rtw_ssid_equal(rsvd_pkt->ssid, ssid))
-			size = rsvd_pkt->skb->len;
+			size = rsvd_pkt->probe_req_size;
 	}
 
 	return size;
@@ -943,6 +943,8 @@ static struct sk_buff *rtw_get_rsvd_page_skb(struct ieee80211_hw *hw,
 							 ssid->ssid_len, 0);
 		else
 			skb_new = ieee80211_probereq_get(hw, vif->addr, NULL, 0, 0);
+		if (skb_new)
+			rsvd_pkt->probe_req_size = (u16)skb_new->len;
 		break;
 	case RSVD_NLO_INFO:
 		skb_new = rtw_nlo_info_get(hw);
@@ -1539,6 +1541,7 @@ int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8 fifo_sel, u32 addr, u32 size,
 static void __rtw_fw_update_pkt(struct rtw_dev *rtwdev, u8 pkt_id, u16 size,
 				u8 location)
 {
+	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
 	u16 total_size = H2C_PKT_HDR_SIZE + H2C_PKT_UPDATE_PKT_LEN;
 
@@ -1549,6 +1552,7 @@ static void __rtw_fw_update_pkt(struct rtw_dev *rtwdev, u8 pkt_id, u16 size,
 	UPDATE_PKT_SET_LOCATION(h2c_pkt, location);
 
 	/* include txdesc size */
+	size += chip->tx_pkt_desc_sz;
 	UPDATE_PKT_SET_SIZE(h2c_pkt, size);
 
 	rtw_fw_send_h2c_packet(rtwdev, h2c_pkt);
@@ -1558,7 +1562,7 @@ void rtw_fw_update_pkt_probe_req(struct rtw_dev *rtwdev,
 				 struct cfg80211_ssid *ssid)
 {
 	u8 loc;
-	u32 size;
+	u16 size;
 
 	loc = rtw_get_rsvd_page_probe_req_location(rtwdev, ssid);
 	if (!loc) {
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 7c5b1d75e26f..35bc9e10dcba 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -126,6 +126,7 @@ struct rtw_rsvd_page {
 	u8 page;
 	bool add_txdesc;
 	struct cfg80211_ssid *ssid;
+	u16 probe_req_size;
 };
 
 enum rtw_keep_alive_pkt_type {
-- 
2.30.2

