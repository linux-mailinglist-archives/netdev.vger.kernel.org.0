Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08A4C1F22A1
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728502AbgFHXJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:09:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728472AbgFHXJk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A180208FE;
        Mon,  8 Jun 2020 23:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657780;
        bh=b8sF3nzdbNYI7vM2opADzKQK1kEfaHKTQBe+5In3VHI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFTDTcU7Ygj5En4fIVpl2rsFlvk/UtkG6RAoa6Ql6oznxpzDHfCr9+sCeBzW9gZD6
         JZ2cysQxKEM9AwGYkN728Zvg96MX/wJ6CUSaOTUDZv4fkfrcn5iQHuLBOUyA9sGz4z
         tDyrS3bA7B5iBp+LtTCiDZ9Ots5SB8hpJqQvwGgc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tamizh Chelvam <tamizhr@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 162/274] ath11k: fix kernel panic by freeing the msdu received with invalid length
Date:   Mon,  8 Jun 2020 19:04:15 -0400
Message-Id: <20200608230607.3361041-162-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tamizh Chelvam <tamizhr@codeaurora.org>

[ Upstream commit d7d43782d541edb8596d2f4fc7f41b0734948ec5 ]

In certain scenario host receives the packets with invalid length
which causes below kernel panic. Free up those msdus to avoid
this kernel panic.

 2270.028121:   <6> task: ffffffc0008306d0 ti: ffffffc0008306d0 task.ti: ffffffc0008306d0
 2270.035247:   <2> PC is at skb_panic+0x40/0x44
 2270.042784:   <2> LR is at skb_panic+0x40/0x44
 2270.521775:   <2> [<ffffffc0004a06e0>] skb_panic+0x40/0x44
 2270.524039:   <2> [<ffffffc0004a1278>] skb_put+0x54/0x5c
 2270.529264:   <2> [<ffffffbffcc373a8>] ath11k_dp_process_rx_err+0x320/0x5b0 [ath11k]
 2270.533860:   <2> [<ffffffbffcc30b68>] ath11k_dp_service_srng+0x80/0x268 [ath11k]
 2270.541063:   <2> [<ffffffbffcc1d554>] ath11k_hal_rx_reo_ent_buf_paddr_get+0x200/0xb64 [ath11k]
 2270.547917:   <2> [<ffffffc0004b1f74>] net_rx_action+0xf8/0x274
 2270.556247:   <2> [<ffffffc000099df4>] __do_softirq+0x128/0x228
 2270.561625:   <2> [<ffffffc00009a130>] irq_exit+0x84/0xcc
 2270.567008:   <2> [<ffffffc0000cfb28>] __handle_domain_irq+0x8c/0xb0
 2270.571695:   <2> [<ffffffc000082484>] gic_handle_irq+0x6c/0xbc

Signed-off-by: Tamizh Chelvam <tamizhr@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1588611568-20791-1-git-send-email-tamizhr@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 34b1e8e6a7fb..007bb73d6c61 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2265,6 +2265,7 @@ static int ath11k_dp_rx_process_msdu(struct ath11k *ar,
 	struct ieee80211_hdr *hdr;
 	struct sk_buff *last_buf;
 	u8 l3_pad_bytes;
+	u8 *hdr_status;
 	u16 msdu_len;
 	int ret;
 
@@ -2293,8 +2294,13 @@ static int ath11k_dp_rx_process_msdu(struct ath11k *ar,
 		skb_pull(msdu, HAL_RX_DESC_SIZE);
 	} else if (!rxcb->is_continuation) {
 		if ((msdu_len + HAL_RX_DESC_SIZE) > DP_RX_BUFFER_SIZE) {
+			hdr_status = ath11k_dp_rx_h_80211_hdr(rx_desc);
 			ret = -EINVAL;
 			ath11k_warn(ar->ab, "invalid msdu len %u\n", msdu_len);
+			ath11k_dbg_dump(ar->ab, ATH11K_DBG_DATA, NULL, "", hdr_status,
+					sizeof(struct ieee80211_hdr));
+			ath11k_dbg_dump(ar->ab, ATH11K_DBG_DATA, NULL, "", rx_desc,
+					sizeof(struct hal_rx_desc));
 			goto free_out;
 		}
 		skb_put(msdu, HAL_RX_DESC_SIZE + l3_pad_bytes + msdu_len);
@@ -3389,6 +3395,7 @@ ath11k_dp_process_rx_err_buf(struct ath11k *ar, u32 *ring_desc, int buf_id, bool
 	struct sk_buff *msdu;
 	struct ath11k_skb_rxcb *rxcb;
 	struct hal_rx_desc *rx_desc;
+	u8 *hdr_status;
 	u16 msdu_len;
 
 	spin_lock_bh(&rx_ring->idr_lock);
@@ -3426,6 +3433,17 @@ ath11k_dp_process_rx_err_buf(struct ath11k *ar, u32 *ring_desc, int buf_id, bool
 
 	rx_desc = (struct hal_rx_desc *)msdu->data;
 	msdu_len = ath11k_dp_rx_h_msdu_start_msdu_len(rx_desc);
+	if ((msdu_len + HAL_RX_DESC_SIZE) > DP_RX_BUFFER_SIZE) {
+		hdr_status = ath11k_dp_rx_h_80211_hdr(rx_desc);
+		ath11k_warn(ar->ab, "invalid msdu leng %u", msdu_len);
+		ath11k_dbg_dump(ar->ab, ATH11K_DBG_DATA, NULL, "", hdr_status,
+				sizeof(struct ieee80211_hdr));
+		ath11k_dbg_dump(ar->ab, ATH11K_DBG_DATA, NULL, "", rx_desc,
+				sizeof(struct hal_rx_desc));
+		dev_kfree_skb_any(msdu);
+		goto exit;
+	}
+
 	skb_put(msdu, HAL_RX_DESC_SIZE + msdu_len);
 
 	if (ath11k_dp_rx_frag_h_mpdu(ar, msdu, ring_desc)) {
-- 
2.25.1

