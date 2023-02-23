Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF3856A0325
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 08:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjBWHFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 02:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233296AbjBWHFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 02:05:35 -0500
Received: from mail.zeus03.de (www.zeus03.de [194.117.254.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9987A92
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 23:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=k1; bh=OIOomp7cpAJjsuC0dN7moT40lIm
        w7FjKpciZCFaEvBE=; b=MxxxE1GA5YlhSuMFni3q8w57S5/1NfReO2W82rAEdhK
        gIywXuwwBh1hNR6Wx2PnrEtijLodgJqlWpbwSw1lV1Bys3V6m6wfHTdfNGY/m3TE
        HSpZbD0ZMf2B3AqMUXmxS2TmpxTmtllSEzcNBcNcid71wU25xIUQSTt+FSt0Q7LI
        =
Received: (qmail 829236 invoked from network); 23 Feb 2023 08:05:28 +0100
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 23 Feb 2023 08:05:28 +0100
X-UD-Smtp-Session: l3s3148p1@Bx5Eo1j1XuJehh92
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     linux-renesas-soc@vger.kernel.org
Cc:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [REGRESSION PATCH RFC] net: phy: don't resume PHY via MDIO when iface is not up
Date:   Thu, 23 Feb 2023 08:05:19 +0100
Message-Id: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TLDR; Commit 96fb2077a517 ("net: phy: consider that suspend2ram may cut
off PHY power") caused regressions for us when resuming an interface
which is not up. It turns out the problem is another one, the above
commit only makes it visible. The attached patch is probably not the
right fix, but at least is proving my assumptions AFAICS.

Setup: I used Renesas boards for my tests, namely Salvator-XS and Ebisu.
They both use RAVB driver (drivers/net/ethernet/renesas/ravb_main.c) and
a Micrel KSZ9031 PHY (drivers/net/phy/micrel.c). I think the problems
are generic, though.

Long text: After the above commit, we could see various resume failures
on our boards, like timeouts when resetting the MDIO bus, or warning
about skew values in non-RGMII mode, although RGMII was used. All of
these happened, because phy_init_hw() was now called in
mdio_bus_phy_resume() which wasn't the case before. But the interface
was not up yet, e.g. phydev->interface was still the default and not
RGMII, so the initialization didn't work properly. phy_attach_direct()
pays attention to this:

1504         /* Do initial configuration here, now that
1505          * we have certain key parameters
1506          * (dev_flags and interface)
1507          */
1508         err = phy_init_hw(phydev);

But phy_init_hw() doesn't if the interface is not up, AFAICS.

This may be a problem in itself, but I then wondered why
mdio_bus_phy_resume() gets called anyhow because the RAVB driver sets
'phydev->mac_managed_pm = true' so once the interface is up
mdio_bus_phy_resume() never gets called. But again, the interface was
not up yet, so mac_managed_pm was not set yet.

So, in my quest to avoid mdio_bus_phy_resume() being called, I tried
this patch declaring the PHY being in suspend state when being probed.
The KSZ9031 has a soft_reset() callback, so phy_init_hw() will reset the
suspended flag when the PHY is attached. It works for me(tm),
suspend/resume now works independently of the interface being up or not.

I don't think this is the proper solution, though. It will e.g. fail if
some PHY is not using the soft_reset() callback. And I am missing the
experience in this subsystem to decide if we can clear the resume flag
in phy_init_hw() unconditionally. My gut feeling is that we can't.

So, this patch mostly demonstrates the issues we have and the things I
found out. I'd be happy if someone could point me to a proper solution,
or more information that I am missing here. Thank you in advance and
happy hacking!

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
---
 drivers/net/phy/phy_device.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 8cff61dbc4b5..5cbb471700a8 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -3108,6 +3108,7 @@ static int phy_probe(struct device *dev)
 
 	/* Set the state to READY by default */
 	phydev->state = PHY_READY;
+	phydev->suspended = 1;
 
 out:
 	/* Assert the reset signal */
-- 
2.30.2

