Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B56315427
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbhBIQmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 11:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233008AbhBIQlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 11:41:51 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004C3C061756;
        Tue,  9 Feb 2021 08:41:10 -0800 (PST)
Received: from mwalle01.fritz.box (unknown [IPv6:2a02:810c:c200:2e91:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 352E523E75;
        Tue,  9 Feb 2021 17:41:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1612888860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY/Trf8IAXCJ0PG0ClY+O2svJbcABB/zmuNJczwrq/g=;
        b=iMOfgVYL8XjIoepNzn1HjT5xtNNZKsjjawwjgvk4sO9J8U88Kb/z0DTZwrRMEOab4ywBHH
        JL23EQBOzHAweUTvcF33wi2BS6lhhqcy5pYtqmLuVSXJ8ArohaRC+hQ8oOvuQxqBOiLq4g
        s2xqVORYz0eM5it6wWx5J7IqikYtF6E=
From:   Michael Walle <michael@walle.cc>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 6/9] net: phy: icplus: don't set APS_EN bit on IP101G
Date:   Tue,  9 Feb 2021 17:40:48 +0100
Message-Id: <20210209164051.18156-7-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210209164051.18156-1-michael@walle.cc>
References: <20210209164051.18156-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This bit is reserved as 'always-write-1'. While this is not a particular
error, because we are only setting it, guard it by checking the model to
prevent errors in the future.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/icplus.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/icplus.c b/drivers/net/phy/icplus.c
index 189a9a34ed5f..a6e1c7611f15 100644
--- a/drivers/net/phy/icplus.c
+++ b/drivers/net/phy/icplus.c
@@ -250,7 +250,7 @@ static int ip101a_g_probe(struct phy_device *phydev)
 static int ip101a_g_config_init(struct phy_device *phydev)
 {
 	struct ip101a_g_phy_priv *priv = phydev->priv;
-	int err, c;
+	int err;
 
 	/* configure the RXER/INTR_32 pin of the 32-pin IP101GR if needed: */
 	switch (priv->sel_intr32) {
@@ -280,11 +280,16 @@ static int ip101a_g_config_init(struct phy_device *phydev)
 		break;
 	}
 
-	/* Enable Auto Power Saving mode */
-	c = phy_read(phydev, IP10XX_SPEC_CTRL_STATUS);
-	c |= IP101A_G_APS_ON;
+	/* Enable Auto Power Saving mode on IP101A, on IP101G this bit is
+	 * reserved as 'write-one'.
+	 */
+	if (priv->model == IP101A) {
+		err = phy_set_bits(phydev, IP10XX_SPEC_CTRL_STATUS, IP101A_G_APS_ON);
+		if (err)
+			return err;
+	}
 
-	return phy_write(phydev, IP10XX_SPEC_CTRL_STATUS, c);
+	return 0;
 }
 
 static int ip101a_g_ack_interrupt(struct phy_device *phydev)
-- 
2.20.1

