Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440D54EA2DA
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 00:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiC1WON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 18:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiC1WN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 18:13:59 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D59F14A927;
        Mon, 28 Mar 2022 15:04:00 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 05FF92223A;
        Tue, 29 Mar 2022 00:03:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1648505038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vp4rKL6VyEnIJD26VD7lbiGVoFzegzSinsmaY3pZqhA=;
        b=k7mL78gO3w6EI+zWoydALo8/RJZOCQoA1ekmvW4MD+7OaocvhfpIfwtxUronph9lqMq9Oe
        09TLHEF8gFp3o6QxzhDrfnv1F/2bfVrJIjLDC5/22nGMXh4kRcyqxY524zjlsXukv0rqAy
        1CTg2TFmshcNcHfPPSYsfRS89cAHMVA=
From:   Michael Walle <michael@walle.cc>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Walle <michael@walle.cc>
Subject: [PATCH v2 net] net: lan966x: fix kernel oops on ioctl when I/F is down
Date:   Tue, 29 Mar 2022 00:03:50 +0200
Message-Id: <20220328220350.3118969-1-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ioctls handled by phy_mii_ioctl() will cause a kernel oops when the
interface is down. Fix it by making sure there is a PHY attached.

Fixes: 735fec995b21 ("net: lan966x: Implement SIOCSHWTSTAMP and SIOCGHWTSTAMP")
Signed-off-by: Michael Walle <michael@walle.cc>
---
changes since v1:
 - reword commit message
 - test for the presence of phydev instead of the interface state
 - move the test just before phy_mii_ioctl()

 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index ec42e526f6fb..1759b0e2b56f 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -408,6 +408,9 @@ static int lan966x_port_ioctl(struct net_device *dev, struct ifreq *ifr,
 		}
 	}
 
+	if (!dev->phydev)
+		return -ENODEV;
+
 	return phy_mii_ioctl(dev->phydev, ifr, cmd);
 }
 
-- 
2.30.2

