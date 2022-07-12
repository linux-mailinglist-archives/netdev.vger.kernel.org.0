Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF8BF571AF8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 15:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbiGLNQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 09:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232343AbiGLNQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 09:16:09 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D333C7AB1B;
        Tue, 12 Jul 2022 06:16:03 -0700 (PDT)
Received: from mwalle01.kontron.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 4C10A22248;
        Tue, 12 Jul 2022 15:16:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1657631761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YKhzt3cpITEJyGyy9hsxcRxMJ7yw3/fJk2ysgW6U4JY=;
        b=ii+xTKVa3ZeGjM4nMcroApaA2P6iByzeL5OlSdUmoC5nO2Ip5U7BOZhUgJa71EER8ToyVo
        w6w0AguvD1gDza0OVUIttcLFhc5R5pPAaWqfYiB4SEfDkzk99FrXWZHiLTUKfRWgpTvzJ9
        Hh0akFYIBT8WuxSPnYdgLMogMhTmAEU=
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
Subject: [PATCH net-next 1/4] net: phy: mxl-gpy: fix version reporting
Date:   Tue, 12 Jul 2022 15:15:51 +0200
Message-Id: <20220712131554.2737792-2-michael@walle.cc>
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

The commit 09ce6b20103b ("net: phy: mxl-gpy: add temperature sensor")
will overwrite the return value and the reported version will be wrong.
Fix it.

Fixes: 09ce6b20103b ("net: phy: mxl-gpy: add temperature sensor")
Signed-off-by: Michael Walle <michael@walle.cc>
---
 drivers/net/phy/mxl-gpy.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/mxl-gpy.c b/drivers/net/phy/mxl-gpy.c
index 5b99acf44337..9728ef93fc0b 100644
--- a/drivers/net/phy/mxl-gpy.c
+++ b/drivers/net/phy/mxl-gpy.c
@@ -198,6 +198,7 @@ static int gpy_config_init(struct phy_device *phydev)
 
 static int gpy_probe(struct phy_device *phydev)
 {
+	int fw_version;
 	int ret;
 
 	if (!phydev->is_c45) {
@@ -207,16 +208,16 @@ static int gpy_probe(struct phy_device *phydev)
 	}
 
 	/* Show GPY PHY FW version in dmesg */
-	ret = phy_read(phydev, PHY_FWV);
-	if (ret < 0)
-		return ret;
+	fw_version = phy_read(phydev, PHY_FWV);
+	if (fw_version < 0)
+		return fw_version;
 
 	ret = gpy_hwmon_register(phydev);
 	if (ret)
 		return ret;
 
-	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", ret,
-		    (ret & PHY_FWV_REL_MASK) ? "release" : "test");
+	phydev_info(phydev, "Firmware Version: 0x%04X (%s)\n", fw_version,
+		    (fw_version & PHY_FWV_REL_MASK) ? "release" : "test");
 
 	return 0;
 }
-- 
2.30.2

