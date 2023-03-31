Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16E706D1470
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjCaA4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:56:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjCaAzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:55:46 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37A510402
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=YL6xhcBVXuty3K6N6oEf9aHPNv9O56x7qsv4scpFW3s=; b=s6fOmYUnX9SlbAcrc9aYDf3QI9
        QzUtRqnFtOriJtfnhcPDqcbtay68iSksvtWZCU5qsNLsEuO9dFe/pdF9lRdTXcZLnNrL+nAvlO6Hi
        IEK4OD4FqpgV1m0oIhf+xfZeMx7p1wG5/cZyNoFh/GlUjf2qCG2XG8fMsYNnaexe0QTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pi33L-008xL7-Ru; Fri, 31 Mar 2023 02:55:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     netdev <netdev@vger.kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [RFC/RFTv3 16/24] net: dsa: b53: Swap to using phydev->eee_active
Date:   Fri, 31 Mar 2023 02:55:10 +0200
Message-Id: <20230331005518.2134652-17-andrew@lunn.ch>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230331005518.2134652-1-andrew@lunn.ch>
References: <20230331005518.2134652-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than calling phy_init_eee() retrieve the same information from
within the phydev structure.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/b53/b53_common.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 3464ce5e7470..5984733e4d0d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -2218,10 +2218,7 @@ EXPORT_SYMBOL(b53_eee_enable_set);
  */
 int b53_eee_init(struct dsa_switch *ds, int port, struct phy_device *phy)
 {
-	int ret;
-
-	ret = phy_init_eee(phy, false);
-	if (ret)
+	if (!phy->eee_active)
 		return 0;
 
 	b53_eee_enable_set(ds, port, true);
-- 
2.40.0

