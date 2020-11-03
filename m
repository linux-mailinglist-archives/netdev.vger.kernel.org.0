Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B827C2A5001
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 20:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729561AbgKCTWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 14:22:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:58396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgKCTWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 14:22:36 -0500
Received: from dellmb.labs.office.nic.cz (nat-1.nic.cz [217.31.205.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B216421D91;
        Tue,  3 Nov 2020 19:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604431355;
        bh=PrCfCR3gt8S7eJW0z4TD7GmNdG+8LYpd9sT+cnuK2dA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EwYflywyEgYd1PWw/BL7P3crNe+EYKoD4wijUxiPS1uoG1a7V1Ja/bAYorC9mjCBW
         68JV2PYgLDWxlpFFrR6BuP0nVpM/LYdNqvb9fAxAfSoWvyQKt4MI/CxcXg+tU9cREX
         w8cD77KmPfrsHgnclBgmuRSpA4bpO7Wj1DYF2Tcs=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, Hayes Wang <hayeswang@realtek.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net-next 4/5] r8152: rename r8153_phy_status to r8153_phy_status_wait
Date:   Tue,  3 Nov 2020 20:22:25 +0100
Message-Id: <20201103192226.2455-5-kabel@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201103192226.2455-1-kabel@kernel.org>
References: <20201103192226.2455-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The idea behind r8153_phy_status function is to wait till status is of
desired value or (if desired value is zero) to wait till status if of
non-zero value. Rename this function to r8153_phy_status_wait.

Signed-off-by: Marek Behún <kabel@kernel.org>
---
 drivers/net/usb/r8152.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 905859309db4..1a427061da8e 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3198,7 +3198,7 @@ static void r8153b_green_en(struct r8152 *tp, bool enable)
 	tp->ups_info.green = enable;
 }
 
-static u16 r8153_phy_status(struct r8152 *tp, u16 desired)
+static u16 r8153_phy_status_wait(struct r8152 *tp, u16 desired)
 {
 	u16 data;
 	int i;
@@ -3249,7 +3249,7 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 		ocp_data &= ~PCUT_STATUS;
 		usb_ocp_write_word(tp, USB_MISC_0, ocp_data);
 
-		data = r8153_phy_status(tp, 0);
+		data = r8153_phy_status_wait(tp, 0);
 
 		switch (data) {
 		case PHY_STAT_PWRDN:
@@ -3262,7 +3262,7 @@ static void r8153b_ups_en(struct r8152 *tp, bool enable)
 			data |= BMCR_RESET;
 			r8152_mdio_write(tp, MII_BMCR, data);
 
-			data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
+			data = r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
 			fallthrough;
 
 		default:
@@ -5397,7 +5397,7 @@ static void r8153_init(struct r8152 *tp)
 			break;
 	}
 
-	data = r8153_phy_status(tp, 0);
+	data = r8153_phy_status_wait(tp, 0);
 
 	if (tp->version == RTL_VER_03 || tp->version == RTL_VER_04 ||
 	    tp->version == RTL_VER_05)
@@ -5409,7 +5409,7 @@ static void r8153_init(struct r8152 *tp)
 		r8152_mdio_write(tp, MII_BMCR, data);
 	}
 
-	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
+	data = r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
 
 	r8153_u2p3en(tp, false);
 
@@ -5536,7 +5536,7 @@ static void r8153b_init(struct r8152 *tp)
 			break;
 	}
 
-	data = r8153_phy_status(tp, 0);
+	data = r8153_phy_status_wait(tp, 0);
 
 	data = r8152_mdio_read(tp, MII_BMCR);
 	if (data & BMCR_PDOWN) {
@@ -5544,7 +5544,7 @@ static void r8153b_init(struct r8152 *tp)
 		r8152_mdio_write(tp, MII_BMCR, data);
 	}
 
-	data = r8153_phy_status(tp, PHY_STAT_LAN_ON);
+	data = r8153_phy_status_wait(tp, PHY_STAT_LAN_ON);
 
 	r8153_u2p3en(tp, false);
 
-- 
2.26.2

