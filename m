Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA7E2E1655
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 04:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbgLWCSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:18:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728208AbgLWCSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:18:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9212A23384;
        Wed, 23 Dec 2020 02:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689851;
        bh=ozinDI24uCMnH6Lu+b2WB5734r8VopwjntVrHDyAv2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8jKn0Q9aimqhZy83E4Br3bQH3/AGzzKEpi3LbPLT0u3CHU0eurpFhBchmRlKfQFj
         WUEIt0K7S5wwWomGjf+TwElBEciFebJLOO0qg1BIwDgOwQ0o9lvnujwkLKGv/V9MSi
         5H2+kQ9ZCq13WzN20oE2sSeKX2GXoaVtBiu+yqxgPW4DfiXGyb0kuPVPzQ3pdg0lMx
         QrWfdnBTU8qlKIOsl1tpkRZAMMjcBzerIoZOKHDysJiUXmyYZ1KHYhS2xMVpcEMCyg
         61KYDUxTSilUrqA+RTf5WLbg5sC9d3kUx9fFRnswMpAHle8cQy6dm6W8NJWM+xdQnb
         GIBMieyAmsA0g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Marek Vasut <marex@denx.de>, Angus Ainslie <angus@akkea.ca>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Siva Rebbagondla <siva8118@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 050/217] rsi: Fix TX EAPOL packet handling against iwlwifi AP
Date:   Tue, 22 Dec 2020 21:13:39 -0500
Message-Id: <20201223021626.2790791-50-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021626.2790791-1-sashal@kernel.org>
References: <20201223021626.2790791-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 65277100caa2f2c62b6f3c4648b90d6f0435f3bc ]

In case RSI9116 SDIO WiFi operates in STA mode against Intel 9260 in AP mode,
the association fails. The former is using wpa_supplicant during association,
the later is set up using hostapd:

iwl$ cat hostapd.conf
interface=wlp1s0
ssid=test
country_code=DE
hw_mode=g
channel=1
wpa=2
wpa_passphrase=test
wpa_key_mgmt=WPA-PSK
iwl$ hostapd -d hostapd.conf

rsi$ wpa_supplicant -i wlan0 -c <(wpa_passphrase test test)

The problem is that the TX EAPOL data descriptor RSI_DESC_REQUIRE_CFM_TO_HOST
flag and extended descriptor EAPOL4_CONFIRM frame type are not set in case the
AP is iwlwifi, because in that case the TX EAPOL packet is 2 bytes shorter.

The downstream vendor driver has this change in place already [1], however
there is no explanation for it, neither is there any commit history from which
such explanation could be obtained.

[1] https://github.com/SiliconLabs/RS911X-nLink-OSD/blob/master/rsi/rsi_91x_hal.c#L238

Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Angus Ainslie <angus@akkea.ca>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Martin Kepplinger <martink@posteo.de>
Cc: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20201015111616.429220-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 3f7e3cfb6f00d..ce9892152f4d4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -248,7 +248,8 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 			rsi_set_len_qno(&data_desc->len_qno,
 					(skb->len - FRAME_DESC_SZ),
 					RSI_WIFI_MGMT_Q);
-		if ((skb->len - header_size) == EAPOL4_PACKET_LEN) {
+		if (((skb->len - header_size) == EAPOL4_PACKET_LEN) ||
+		    ((skb->len - header_size) == EAPOL4_PACKET_LEN - 2)) {
 			data_desc->misc_flags |=
 				RSI_DESC_REQUIRE_CFM_TO_HOST;
 			xtend_desc->confirm_frame_type = EAPOL4_CONFIRM;
-- 
2.27.0

