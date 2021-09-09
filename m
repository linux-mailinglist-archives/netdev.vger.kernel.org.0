Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A80405283
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347624AbhIIMn4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:43:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244780AbhIIMg7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:36:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68A7761BA5;
        Thu,  9 Sep 2021 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188452;
        bh=RPUn723YwuyKp0Qjlf9A2KJKCf03ZrJex2xjJmeSgd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SYLgQKkEE3nzvtjpgo68nxrAHGFq82ticwS031mDUT1TDHWm8KxvC46YndxJ2yA06
         2Oh8UlGwZ0xxBalj0V9GbxIQD+rp5a15Qdvj0u8PC8WuM+/HCyNyVq+tSMyfZ0Xc/j
         Q1An8wXDjz5+GtOY6K8RBQv5jOXTgpnVdu1gk9AdFs/wF87DVV9azt4NQOjmF7UVZb
         KGR1kntC3/ynME5W5QyzDXOalEYAVzqeEGHxmRmPAQvv6rty/16vkG8cAG7fAX33dM
         usMNpuqE/RXQycfsHnP1XxfyRrIDP/TQvw3PhFeNsaLH3Ue/ty++Sti3N8mVbCN6a7
         O3dFCvvC/spNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chin-Yen Lee <timlee@realtek.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 134/176] rtw88: wow: fix size access error of probe request
Date:   Thu,  9 Sep 2021 07:50:36 -0400
Message-Id: <20210909115118.146181-134-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index b2fd87834f23..0452630bcfac 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -684,7 +684,7 @@ static u16 rtw_get_rsvd_page_probe_req_size(struct rtw_dev *rtwdev,
 			continue;
 		if ((!ssid && !rsvd_pkt->ssid) ||
 		    rtw_ssid_equal(rsvd_pkt->ssid, ssid))
-			size = rsvd_pkt->skb->len;
+			size = rsvd_pkt->probe_req_size;
 	}
 
 	return size;
@@ -912,6 +912,8 @@ static struct sk_buff *rtw_get_rsvd_page_skb(struct ieee80211_hw *hw,
 							 ssid->ssid_len, 0);
 		else
 			skb_new = ieee80211_probereq_get(hw, vif->addr, NULL, 0, 0);
+		if (skb_new)
+			rsvd_pkt->probe_req_size = (u16)skb_new->len;
 		break;
 	case RSVD_NLO_INFO:
 		skb_new = rtw_nlo_info_get(hw);
@@ -1508,6 +1510,7 @@ int rtw_fw_dump_fifo(struct rtw_dev *rtwdev, u8 fifo_sel, u32 addr, u32 size,
 static void __rtw_fw_update_pkt(struct rtw_dev *rtwdev, u8 pkt_id, u16 size,
 				u8 location)
 {
+	struct rtw_chip_info *chip = rtwdev->chip;
 	u8 h2c_pkt[H2C_PKT_SIZE] = {0};
 	u16 total_size = H2C_PKT_HDR_SIZE + H2C_PKT_UPDATE_PKT_LEN;
 
@@ -1518,6 +1521,7 @@ static void __rtw_fw_update_pkt(struct rtw_dev *rtwdev, u8 pkt_id, u16 size,
 	UPDATE_PKT_SET_LOCATION(h2c_pkt, location);
 
 	/* include txdesc size */
+	size += chip->tx_pkt_desc_sz;
 	UPDATE_PKT_SET_SIZE(h2c_pkt, size);
 
 	rtw_fw_send_h2c_packet(rtwdev, h2c_pkt);
@@ -1527,7 +1531,7 @@ void rtw_fw_update_pkt_probe_req(struct rtw_dev *rtwdev,
 				 struct cfg80211_ssid *ssid)
 {
 	u8 loc;
-	u32 size;
+	u16 size;
 
 	loc = rtw_get_rsvd_page_probe_req_location(rtwdev, ssid);
 	if (!loc) {
diff --git a/drivers/net/wireless/realtek/rtw88/fw.h b/drivers/net/wireless/realtek/rtw88/fw.h
index 08644540d259..f4aed247e3bd 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.h
+++ b/drivers/net/wireless/realtek/rtw88/fw.h
@@ -117,6 +117,7 @@ struct rtw_rsvd_page {
 	u8 page;
 	bool add_txdesc;
 	struct cfg80211_ssid *ssid;
+	u16 probe_req_size;
 };
 
 enum rtw_keep_alive_pkt_type {
-- 
2.30.2

