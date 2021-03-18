Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51A48340A74
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhCRQpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:45:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44745 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhCRQpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:45:19 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lMvlq-0007pz-5X; Thu, 18 Mar 2021 16:45:14 +0000
From:   Colin King <colin.king@canonical.com>
To:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] brcmsmac: fix shift on 4 bit masked value
Date:   Thu, 18 Mar 2021 16:45:13 +0000
Message-Id: <20210318164513.19600-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The calculation of offtune_val seems incorrect, the u16 value in
pi->tx_rx_cal_radio_saveregs[2] is being masked with 0xf0 and then
shifted 8 places right so that always ends up as a zero result. I
believe the intended shift was 4 bits to the right. Fix this.

[Note: not tested, I don't have the H/W]

Addresses-Coverity: ("Operands don't affect result")
Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
index 8580a2754789..2c04bae6e21c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/phy/phy_n.c
@@ -26329,7 +26329,7 @@ static void wlc_phy_rxcal_radio_setup_nphy(struct brcms_phy *pi, u8 rx_core)
 
 					offtune_val =
 						(pi->tx_rx_cal_radio_saveregs
-						 [2] & 0xF0) >> 8;
+						 [2] & 0xF0) >> 4;
 					offtune_val =
 						(offtune_val <= 0x7) ? 0xF : 0;
 
-- 
2.30.2

