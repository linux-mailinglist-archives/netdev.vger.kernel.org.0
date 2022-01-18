Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C8491450
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244797AbiARCVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:21:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37838 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244686AbiARCVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:21:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C73D961163;
        Tue, 18 Jan 2022 02:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E5CAC36AF2;
        Tue, 18 Jan 2022 02:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472469;
        bh=VbjM88vfkzibxjmt+y58uIpvisAVC02ljgpwkY+7PCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IyIqOvMJqL7RaoEbzRxRgUDtWsbYLmZquDAk1r1YUi3abPpS4Rk5WRFB17kDXL8Hi
         xCDivf4R3oaw613eqz3sXdXVM4IQG96lHeHeI5jVDHSqInVLlEj27ym/okj7o05KkB
         X7Gnwmz8SvkmdG9tl5jxUynZ3VFmKrTF6iffT2iPJvI3uru8eqADfrIyNfKUDmzlA8
         kZxYppO0vKJM3jgwkm+FUejK8MkvEdMagrWA5Pi+dFabkrufg8QdKp5JyJfuWxsLN8
         GgFIh/7kSHPidd3ZR93i8AiaMkYVkgW8qrNI2q5sjJt35MctfT7pJ5jl3BnYjJPXrx
         Y+R0mBthx2h6g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wen Gong <wgong@codeaurora.org>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 024/217] ath11k: enable IEEE80211_VHT_EXT_NSS_BW_CAPABLE if NSS ratio enabled
Date:   Mon, 17 Jan 2022 21:16:27 -0500
Message-Id: <20220118021940.1942199-24-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Gong <wgong@codeaurora.org>

[ Upstream commit 78406044bdd0cc8987bc082b76867c63ab1c6af8 ]

When NSS ratio enabled reported by firmware, SUPPORTS_VHT_EXT_NSS_BW
is set in ath11k, meanwhile IEEE80211_VHT_EXT_NSS_BW_CAPABLE also
need to be set, otherwise it is invalid because spec in IEEE Std
802.11™‐2020 as below.

Table 9-273-Supported VHT-MCS and NSS Set subfields, it has subfield
VHT Extended NSS BW Capable, its definition is:
Indicates whether the STA is capable of interpreting the Extended NSS
BW Support subfield of the VHT Capabilities Information field.

dmesg have a message without this patch:

ieee80211 phy0: copying sband (band 1) due to VHT EXT NSS BW flag

It means mac80211 will set IEEE80211_VHT_EXT_NSS_BW_CAPABLE if ath11k not
set it in ieee80211_register_hw(). So it is better to set it in ath11k.

Tested-on: WCN6855 hw2.0 PCI WLAN.HSP.1.1-01720.1-QCAHSPSWPL_V1_V2_SILICONZ_LITE-1

Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20211013073704.15888-1-wgong@codeaurora.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mac.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 1cc55602787bb..0a196fb3df9fd 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -4561,6 +4561,10 @@ ath11k_create_vht_cap(struct ath11k *ar, u32 rate_cap_tx_chainmask,
 	vht_cap.vht_supported = 1;
 	vht_cap.cap = ar->pdev->cap.vht_cap;
 
+	if (ar->pdev->cap.nss_ratio_enabled)
+		vht_cap.vht_mcs.tx_highest |=
+			cpu_to_le16(IEEE80211_VHT_EXT_NSS_BW_CAPABLE);
+
 	ath11k_set_vht_txbf_cap(ar, &vht_cap.cap);
 
 	rxmcs_map = 0;
-- 
2.34.1

