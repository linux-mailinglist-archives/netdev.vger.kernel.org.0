Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FCA268BEB
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 15:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731260AbfGONrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731195AbfGONrs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:47:48 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587F02086C;
        Mon, 15 Jul 2019 13:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198463;
        bh=FMLCJaIguW6YWjuMGHKMm+W18reEkOZbzo2vwzvBfvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YkQLakubt12torj4bf9JMdpM2abUjB3i8XpRIFoA3p1FDnwz1L4Am6IQaJjw+pcoB
         TucRU67tECd0uN/Z5227aPTGkylA1KDO9KKsgosOc3fV+5xBQbeS3kk+BPMEQxKDeO
         mRoviveRDupgdsLzrM4T3n2ZTdiD1ty8pNzx06Po=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rakesh Pillai <pillair@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 016/249] ath10k: Fix encoding for protected management frames
Date:   Mon, 15 Jul 2019 09:43:01 -0400
Message-Id: <20190715134655.4076-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit 42f1bc43e6a97b9ddbe976eba9bd05306c990c75 ]

Currently the protected management frames are
not appended with the MIC_LEN which results in
the protected management frames being encoded
incorrectly.

Add the extra space at the end of the protected
management frames to fix this encoding error for
the protected management frames.

Tested HW: WCN3990
Tested FW: WLAN.HL.3.1-00784-QCAHLSWMTPLZ-1

Fixes: 1807da49733e ("ath10k: wmi: add management tx by reference support over wmi")
Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 582fb11f648a..02709fc99034 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -2840,8 +2840,10 @@ ath10k_wmi_tlv_op_gen_mgmt_tx_send(struct ath10k *ar, struct sk_buff *msdu,
 	if ((ieee80211_is_action(hdr->frame_control) ||
 	     ieee80211_is_deauth(hdr->frame_control) ||
 	     ieee80211_is_disassoc(hdr->frame_control)) &&
-	     ieee80211_has_protected(hdr->frame_control))
+	     ieee80211_has_protected(hdr->frame_control)) {
+		skb_put(msdu, IEEE80211_CCMP_MIC_LEN);
 		buf_len += IEEE80211_CCMP_MIC_LEN;
+	}
 
 	buf_len = min_t(u32, buf_len, WMI_TLV_MGMT_TX_FRAME_MAX_LEN);
 	buf_len = round_up(buf_len, 4);
-- 
2.20.1

