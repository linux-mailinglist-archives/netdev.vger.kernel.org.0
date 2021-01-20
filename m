Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F662FD9F2
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 20:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392474AbhATTok (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 14:44:40 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:33439 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388379AbhATTn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 14:43:56 -0500
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 654E522727;
        Wed, 20 Jan 2021 20:43:13 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1611171794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=wECjIsfiv6b1vpeE3rC46GdUz/M0EaI99XImGOrJhB8=;
        b=p0vxJUwjuuGDnpiAaCkylxe/ifGBH5IUDfHHuDB4WXRGLKmH26+SGO9sPHK6b3aIzyY1qV
        gbko9UzORdaieMFvuwy220g9dvnaPe8WHH8PLuORhinlgm59nCpWHNdzWnDoKk979q4qzW
        3huCfM1jgKWOmToRTsq4HkpM0FHaeh0=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH] net: macb: ignore tx_clk if MII is used
Date:   Wed, 20 Jan 2021 20:43:03 +0100
Message-Id: <20210120194303.28268-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the MII interface is used, the PHY is the clock master, thus don't
set the clock rate. On Zynq-7000, this will prevent the following
warning:
  macb e000b000.ethernet eth0: unable to generate target frequency: 25000000 Hz

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/ethernet/cadence/macb_main.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 814a5b10141d..472bf8f220bc 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -470,6 +470,10 @@ static void macb_set_tx_clk(struct macb *bp, int speed)
 	if (!bp->tx_clk || (bp->caps & MACB_CAPS_CLK_HW_CHG))
 		return;
 
+	/* In case of MII the PHY is the clock master */
+	if (bp->phy_interface == PHY_INTERFACE_MODE_MII)
+		return;
+
 	switch (speed) {
 	case SPEED_10:
 		rate = 2500000;
-- 
2.20.1

