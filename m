Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A2B53E0C4
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 08:03:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiFFF1R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 01:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiFFF1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 01:27:11 -0400
X-Greylist: delayed 83 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 05 Jun 2022 22:04:29 PDT
Received: from condef-04.nifty.com (condef-04.nifty.com [202.248.20.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 205BD762BF;
        Sun,  5 Jun 2022 22:04:28 -0700 (PDT)
Received: from conuserg-10.nifty.com ([10.126.8.73])by condef-04.nifty.com with ESMTP id 2564uAao012761;
        Mon, 6 Jun 2022 13:56:30 +0900
Received: from grover.sesame (133-32-177-133.west.xps.vectant.ne.jp [133.32.177.133]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 2564rxU9026256;
        Mon, 6 Jun 2022 13:54:01 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 2564rxU9026256
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1654491242;
        bh=isf+a5aQ1y4P6QoSWZORn/o1CmARhw+dCDmlwB5MUhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/5LLpefrhB6ls7uUg5UnXmoqagKwB+mQiCQosf9QYbV5pNhS1Gd1Sid/GZWZxGLT
         vh+oA2onkm3RC6YMqE3CsQ8vU4ilcfWTvMf+W4U6MREze7eLHqRMoh6YXohU9IK6AF
         0MHHFHQp0/1b54orxyALK6PMWmzo7jmkHdzFyvRaoAt7lOl6MzELTGlz4ZEgNSGfyL
         Mdwk4FJ1DCJ3j+fDouhxxcTvseXTgSBGHRJI9lTKmubL8WuSYLBJyGXAmCzHn5itxu
         pFmcu1h6/DfltJzelsuyJyJPDl+AdHL6bB+h3w00TFPKE6MUtu1qBA5+bkUc6aDn3Y
         pdafOyHgLu56w==
X-Nifty-SrcIP: [133.32.177.133]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] net: mdio: unexport __init-annotated mdio_bus_init()
Date:   Mon,  6 Jun 2022 13:53:53 +0900
Message-Id: <20220606045355.4160711-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220606045355.4160711-1-masahiroy@kernel.org>
References: <20220606045355.4160711-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it has been broken for a decade.

Recently, I fixed modpost so it started to warn it again, then this
showed up in linux-next builds.

There are two ways to fix it:

  - Remove __init
  - Remove EXPORT_SYMBOL

I chose the latter for this case because the only in-tree call-site,
drivers/net/phy/phy_device.c is never compiled as modular.
(CONFIG_PHYLIB is boolean)

Fixes: 90eff9096c01 ("net: phy: Allow splitting MDIO bus/device support from PHYs")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 drivers/net/phy/mdio_bus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 58d602985877..8a2dbe849866 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1046,7 +1046,6 @@ int __init mdio_bus_init(void)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mdio_bus_init);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 void mdio_bus_exit(void)
-- 
2.32.0

