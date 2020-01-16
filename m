Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93FAF13F66E
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:04:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388318AbgAPRCR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:02:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388308AbgAPRCQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:02:16 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD34E2087E;
        Thu, 16 Jan 2020 17:02:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194135;
        bh=rOBWmBUqsRKtqSJgMsVu02iSM9VhORwgoCJfqubhHAY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pON7C8X6geuB9UDERestAlQt29G+rIfXWcLm9aIWec8DSEAJukXIjoXUO86cnuFDO
         pYqJo01yF+Ay9J9tv+lFX9uGFo1MTl+rJDNDK483h4EzBZqo9ExGADmGg93KcW0+mG
         YNvNxaxkS6whAResfPjCgigqeKuXQBZCWgXG3o70=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Surabhi Vishnoi <svishnoi@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 224/671] ath10k: Fix length of wmi tlv command for protected mgmt frames
Date:   Thu, 16 Jan 2020 11:52:13 -0500
Message-Id: <20200116165940.10720-107-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Surabhi Vishnoi <svishnoi@codeaurora.org>

[ Upstream commit 761156ff573d1002983416e4fd1fe8d3489c4bd8 ]

The length of wmi tlv command for management tx send is calculated
incorrectly in case of protected management frames as there is addition
of IEEE80211_CCMP_MIC_LEN twice. This leads to improper behaviour of
firmware as the wmi tlv mgmt tx send command for protected mgmt frames
is formed wrongly.

Fix the length calculation of wmi tlv command for mgmt tx send in case
of protected management frames by adding the IEEE80211_CCMP_MIC_LEN only
once.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: 1807da49733e "ath10k: wmi: add management tx by reference support over wmi"
Signed-off-by: Surabhi Vishnoi <svishnoi@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index cdc1e64d52ad..a90990b8008d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2692,10 +2692,8 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control)) {
-		len += IEEE80211_CCMP_MIC_LEN;
+	     ieee80211_has_protected(hdr->frame_control))
 		buf_len += IEEE80211_CCMP_MIC_LEN;
-	}
 
 	buf_len = min_t(u32, buf_len, WMI_TLV_MGMT_TX_FRAME_MAX_LEN);
 	buf_len = round_up(buf_len, 4);
-- 
2.20.1

