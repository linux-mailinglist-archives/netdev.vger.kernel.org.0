Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47FCD455DF9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233099AbhKROa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:30:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:46400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233068AbhKROa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:30:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2286F61881;
        Thu, 18 Nov 2021 14:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637245648;
        bh=ggM/t0CsUScJiqimTWYRkutSY19TQge2u1WHul5n12g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U8VCo0T9kTKtgbi1Lx923GSgMI289/v/P9jJvxlxHOFSOUW02l0QzCq6tM21Wb7R0
         jPE58t+wjw+g7o5T6v7zq1TYTqct2iGCkuy0prm3BpPx0q/tZ1MhdtxmpCLSIAfJd7
         5KjImPLdqL42K1SywBqXkw4uaAPxK0ZozGgeaHS/FTOB6ySdZ4gTxQlabh8i8sk0sB
         Pd2gsq7WPSkrAQ4gpzHpcrHO0aJlGPzRScD2DSEgWf0DoPsDpzFW4Bu4psJbRtIU/q
         ebDaMx3oVCTHt4sVexfneSVGd8RLTcU1y9FLbdSXuNxMPrxzJKXD6wU4fCK/Z+I7DJ
         OAKhX94LcCAFA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>, ajay.kathat@microchip.com,
        claudiu.beznea@microchip.com
Subject: [PATCH net-next 3/4] wilc1000: copy address before calling wilc_set_mac_address
Date:   Thu, 18 Nov 2021 06:27:19 -0800
Message-Id: <20211118142720.3176980-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118142720.3176980-1-kuba@kernel.org>
References: <20211118142720.3176980-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wilc_set_mac_address() calls IO routines which don't guarantee
the pointer won't be written to. Make a copy.

Acked-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ajay.kathat@microchip.com
CC: claudiu.beznea@microchip.com
---
 drivers/net/wireless/microchip/wilc1000/netdev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 690572e01a2a..4712cd7dff9f 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -574,6 +574,7 @@ static int wilc_mac_open(struct net_device *ndev)
 	struct wilc *wl = vif->wilc;
 	int ret = 0;
 	struct mgmt_frame_regs mgmt_regs = {};
+	u8 addr[ETH_ALEN] __aligned(2);
 
 	if (!wl || !wl->dev) {
 		netdev_err(ndev, "device not ready\n");
@@ -596,10 +597,9 @@ static int wilc_mac_open(struct net_device *ndev)
 				vif->idx);
 
 	if (is_valid_ether_addr(ndev->dev_addr)) {
-		wilc_set_mac_address(vif, ndev->dev_addr);
+		ether_addr_copy(addr, ndev->dev_addr);
+		wilc_set_mac_address(vif, addr);
 	} else {
-		u8 addr[ETH_ALEN];
-
 		wilc_get_mac_address(vif, addr);
 		eth_hw_addr_set(ndev, addr);
 	}
-- 
2.31.1

