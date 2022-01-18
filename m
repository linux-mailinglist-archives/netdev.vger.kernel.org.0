Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8CF491BB3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 04:12:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352171AbiARDIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 22:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352086AbiARC5z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:57:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9360DC06136F;
        Mon, 17 Jan 2022 18:46:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32C8C612D1;
        Tue, 18 Jan 2022 02:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CF0EC36AE3;
        Tue, 18 Jan 2022 02:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473979;
        bh=Wbkwr54W1ZE6NvANhIYMVi477GP/ssZByIQOh6Dkhg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BQ0lh3QpTSPcWCxY8QTWTcD4W/hGU+bPK97f+PsyEA+0Q0Dc4ANqjg+pywCvhkWRi
         q20kvtEZS+cNNUh776yTnCVgcuQjWQ+D7bfMvlZfiUhss+kBwFc6jpqr7H6hBkRf4Y
         dvtcHgFjj8739vbf3726oAyad1I1t/V3nLPyOW6QvUURWg6GrkU2fbAhvbMLlzvZlq
         JGhcmc4vVLDGoELy/bqZCDNrzlDV0Wk/5BfMJ/95mMEneSt8Rk5h3zTJbr+pFUcDxK
         dV9WjaRzZKe1FfzVy4kQLLeh6W2NPKS88oKebq4MSHFt+g+kMh0VVZtPQjIZyyTium
         DOqkabznddDtQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, johannes.berg@intel.com,
        miriam.rachel.korenblit@intel.com, emmanuel.grumbach@intel.com,
        avraham.stern@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 51/73] iwlwifi: mvm: Fix calculation of frame length
Date:   Mon, 17 Jan 2022 21:44:10 -0500
Message-Id: <20220118024432.1952028-51-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024432.1952028-1-sashal@kernel.org>
References: <20220118024432.1952028-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit 40a0b38d7a7f91a6027287e0df54f5f547e8d27e ]

The RADA might include in the Rx frame the MIC and CRC bytes.
These bytes should be removed for non monitor interfaces and
should not be passed to mac80211.

Fix the Rx processing to remove the extra bytes on non monitor
cases.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211219121514.098be12c801e.I1d81733d8a75b84c3b20eb6e0d14ab3405ca6a86@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index a6e2a30eb3109..52c6edc621ced 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -177,12 +177,39 @@ static int iwl_mvm_create_skb(struct iwl_mvm *mvm, struct sk_buff *skb,
 	struct iwl_rx_mpdu_desc *desc = (void *)pkt->data;
 	unsigned int headlen, fraglen, pad_len = 0;
 	unsigned int hdrlen = ieee80211_hdrlen(hdr->frame_control);
+	u8 mic_crc_len = u8_get_bits(desc->mac_flags1,
+				     IWL_RX_MPDU_MFLG1_MIC_CRC_LEN_MASK) << 1;
 
 	if (desc->mac_flags2 & IWL_RX_MPDU_MFLG2_PAD) {
 		len -= 2;
 		pad_len = 2;
 	}
 
+	/*
+	 * For non monitor interface strip the bytes the RADA might not have
+	 * removed. As monitor interface cannot exist with other interfaces
+	 * this removal is safe.
+	 */
+	if (mic_crc_len && !ieee80211_hw_check(mvm->hw, RX_INCLUDES_FCS)) {
+		u32 pkt_flags = le32_to_cpu(pkt->len_n_flags);
+
+		/*
+		 * If RADA was not enabled then decryption was not performed so
+		 * the MIC cannot be removed.
+		 */
+		if (!(pkt_flags & FH_RSCSR_RADA_EN)) {
+			if (WARN_ON(crypt_len > mic_crc_len))
+				return -EINVAL;
+
+			mic_crc_len -= crypt_len;
+		}
+
+		if (WARN_ON(mic_crc_len > len))
+			return -EINVAL;
+
+		len -= mic_crc_len;
+	}
+
 	/* If frame is small enough to fit in skb->head, pull it completely.
 	 * If not, only pull ieee80211_hdr (including crypto if present, and
 	 * an additional 8 bytes for SNAP/ethertype, see below) so that
-- 
2.34.1

