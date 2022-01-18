Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFA2491652
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345717AbiARCb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:31:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39212 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244979AbiARCZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:25:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B893B81247;
        Tue, 18 Jan 2022 02:25:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA130C36AE3;
        Tue, 18 Jan 2022 02:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472722;
        bh=sdOOB4UKo5fjVxrk5O+5GVl9Uq6JG4ZrtYrtaSgng6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gFfOelCrT4nQIYBGyn98lI97BcFpU432QKUXlV+zan+2XA5Dm58hcjqMS+4ItNGJs
         +Czh5dQMI2fSt1f5+qcVbepymyFFwhJrY5WVFUpFC59vKM1f2ykOJ7NDRfL+A6em+Q
         doH1WQsncQSFuA7orFQDXzcCHzeZEXTicHbA6FuHcs7iyyCIwhXobvyUkIhPzxzJez
         GZJ2D8bvGjGHXMOBvUnsVz2BJAnCX5z6cwu6z3VY75A0+Af6DMQHiuAufMArnM5RYY
         WRTa4zA0DKVBL3VemlJiyJ/GhnR3noRprb/OVtwAtvfXXbY+n0OX4PznRF5s5iZQtC
         eMe9cLs6R7kVA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <quic_wgong@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 113/217] ath10k: drop beacon and probe response which leak from other channel
Date:   Mon, 17 Jan 2022 21:17:56 -0500
Message-Id: <20220118021940.1942199-113-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <quic_wgong@quicinc.com>

[ Upstream commit 3bf2537ec2e33310b431b53fd84be8833736c256 ]

When scan request on channel 1, it also receive beacon from other
channels, and the beacon also indicate to mac80211 and wpa_supplicant,
and then the bss info appears in radio measurement report of radio
measurement sent from wpa_supplicant, thus lead RRM case fail.

This is to drop the beacon and probe response which is not the same
channel of scanning.

Tested-on: QCA6174 hw3.2 SDIO WLAN.RMH.4.4.1-00049

Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20211208061752.16564-1-quic_wgong@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 7c1c2658cb5f8..4733fd7fb169e 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2611,9 +2611,30 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_mac_handle_beacon(ar, skb);
 
 	if (ieee80211_is_beacon(hdr->frame_control) ||
-	    ieee80211_is_probe_resp(hdr->frame_control))
+	    ieee80211_is_probe_resp(hdr->frame_control)) {
+		struct ieee80211_mgmt *mgmt = (void *)skb->data;
+		u8 *ies;
+		int ies_ch;
+
 		status->boottime_ns = ktime_get_boottime_ns();
 
+		if (!ar->scan_channel)
+			goto drop;
+
+		ies = mgmt->u.beacon.variable;
+
+		ies_ch = cfg80211_get_ies_channel_number(mgmt->u.beacon.variable,
+							 skb_tail_pointer(skb) - ies,
+							 sband->band);
+
+		if (ies_ch > 0 && ies_ch != channel) {
+			ath10k_dbg(ar, ATH10K_DBG_MGMT,
+				   "channel mismatched ds channel %d scan channel %d\n",
+				   ies_ch, channel);
+			goto drop;
+		}
+	}
+
 	ath10k_dbg(ar, ATH10K_DBG_MGMT,
 		   "event mgmt rx skb %pK len %d ftype %02x stype %02x\n",
 		   skb, skb->len,
@@ -2627,6 +2648,10 @@ int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
 	ieee80211_rx_ni(ar->hw, skb);
 
 	return 0;
+
+drop:
+	dev_kfree_skb(skb);
+	return 0;
 }
 
 static int freq_to_idx(struct ath10k *ar, int freq)
-- 
2.34.1

