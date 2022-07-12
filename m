Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7588F571AEE
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbiGLNQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbiGLNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:16:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543C5820F5;
        Tue, 12 Jul 2022 06:16:04 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7B03E2224E;
        Tue, 12 Jul 2022 15:16:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657631762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5ttA7hy2efh7uguHjjZhwytdsronnsa+uPbqeqsgPMs=;
        b=Tf0NSwVJFA9kgNler/v6L6I6kKX6RiOhRx5fjARTAbhtUzVgqkpz6meDwoqWgBl/u8kWar
        hhjaMABl7wRs2i4eqfI2PYRLkHSK5in/tlGkoFVOZE9Gg7ZPNgYfezukBlZUPLCycFjHOS
        qGRnp5PCvn/n3p2rDBJpTWhIYi/WfmM=
From:   Michael Walle <michael@walle.cc>
To:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 4/4] net: phy: mxl-gpy: print firmware in human readable form
Date:   Tue, 12 Jul 2022 15:15:54 +0200
Message-Id: <20220712131554.2737792-5-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712131554.2737792-1-michael@walle.cc>
References: <20220712131554.2737792-1-michael@walle.cc>
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

Now having a major and a minor number, also print the firmware in
human readable form "major.minor". Still keep the 4-digit hexadecimal
representation because that form is used in the firmware changelog
documents. Also, drop the "release" string assuming that most common
case, but make it clearer that the user is running a test version.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index ac62b01c61ed..24bae27eedef 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -230,8 +230,9 @@ static int gpy_probe(struct phy_device *phydev)
 		return ret;
 
 	/* Show GPY PHY FW version in dmesg */
-	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
-		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");
+	phydev_info(phydev, "Firmware Version: %d.%d (0x%04X%s)\n",
+		    priv->fw_major, priv->fw_minor, fw_version,
+		    fw_version & PHY_FWV_REL_MASK ? "" : " test version");
 
 	return 0;
 }
-- 
2.30.2

