Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 813514553A9
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:15:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242875AbhKRESO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:18:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:36138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242862AbhKRESG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:18:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9BCF161B64;
        Thu, 18 Nov 2021 04:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637208906;
        bh=farPGQDiLjnWPYOI1YEy+djKfpnXbMRXSuuubpxsVBI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qqwyrLK6Z0rw8Wo138zWLmpUjG2zfuEbiauUbJTqh4KZDDCIvsLq1Wq84Ay/eSxlw
         V12tncJRyvdBWzeZgMVZKemZbmyic2+hkIq3mKRcQXoSrNi0pw9hAIcAxs15pddzAk
         No/6WxJdFSOuGnMXq//eH0o4Tt+ODbJOdU6a9oCoJ8mEvvhATqE6Qv2p7sXhuR5zF2
         guS5qHvqjwyDTNLZY35ppyUYLVS76Kw98Rzyk71N/WTWf4lgtnxu0UKqqjW60p08Mq
         41T1YHIDdxVGXxU7h5bjnYXpmIkGHd7U0l+aW7Uar+/afB0aar5z9Ht1TIC6lr7tOc
         r8ZNVLsgZVC/Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        ajay.kathat@microchip.com, claudiu.beznea@microchip.com,
        kvalo@codeaurora.org
Subject: [PATCH net-next 3/9] wilc1000: copy address before calling wilc_set_mac_address
Date:   Wed, 17 Nov 2021 20:14:55 -0800
Message-Id: <20211118041501.3102861-4-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211118041501.3102861-1-kuba@kernel.org>
References: <20211118041501.3102861-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wilc_set_mac_address() calls IO routines which don't guarantee
the pointer won't be written to. Make a copy.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: ajay.kathat@microchip.com
CC: claudiu.beznea@microchip.com
CC: kvalo@codeaurora.org
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

