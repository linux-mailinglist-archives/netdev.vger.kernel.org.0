Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F47175115
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 00:55:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgCAXzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Mar 2020 18:55:16 -0500
Received: from mout-p-103.mailbox.org ([80.241.56.161]:15010 "EHLO
        mout-p-103.mailbox.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726525AbgCAXzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Mar 2020 18:55:16 -0500
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.2 with cipher ECDHE-RSA-CHACHA20-POLY1305 (256/256 bits))
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 48W0Wj709SzKmcK;
        Mon,  2 Mar 2020 00:55:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
Received: from smtp2.mailbox.org ([80.241.60.241])
        by gerste.heinlein-support.de (gerste.heinlein-support.de [91.198.250.173]) (amavisd-new, port 10030)
        with ESMTP id nTT74APEphUf; Mon,  2 Mar 2020 00:55:10 +0100 (CET)
From:   Hauke Mehrtens <hauke@hauke-m.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] phylink: Improve error message when validate failed
Date:   Mon,  2 Mar 2020 00:55:02 +0100
Message-Id: <20200301235502.17872-1-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This should improve the error message when the PHY validate in the MAC
driver failed. I ran into this problem multiple times that I put wrong
interface values into the device tree and was searching why it is
failing with -22 (-EINVAL). This should make it easier to spot the
problem.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/phy/phylink.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index b4367fab7899..5347275215be 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -797,8 +797,14 @@ static int phylink_bringup_phy(struct phylink *pl, struct phy_device *phy,
 		config.interface = interface;
 
 	ret = phylink_validate(pl, supported, &config);
-	if (ret)
+	if (ret) {
+		phylink_warn(pl, "validation of %s with support %*pb and advertisement %*pb failed: %d\n",
+			     phy_modes(config.interface),
+			     __ETHTOOL_LINK_MODE_MASK_NBITS, phy->supported,
+			     __ETHTOOL_LINK_MODE_MASK_NBITS, config.advertising,
+			     ret);
 		return ret;
+	}
 
 	phy->phylink = pl;
 	phy->phy_link_change = phylink_phy_change;
-- 
2.20.1

