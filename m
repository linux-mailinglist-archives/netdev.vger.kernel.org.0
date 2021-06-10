Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63D9C3A32CF
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 20:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhFJSQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 14:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJSQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 14:16:37 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4147CC061574
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:26 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id my49so600255ejc.7
        for <netdev@vger.kernel.org>; Thu, 10 Jun 2021 11:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cb3Vo2vLk4ryIodn1SYTiwH3Et1KhclqG020AZoiFgU=;
        b=Iwd7zwEvW8w+wrswP7X44bigS/+5qlO5wciw80S5Hd5Zcu3s8zjbWqs9Gd6INzb01C
         UKI40wGuGMZQZG2sw+OTjfC992OWmKj6wQaNsA60kiz4OxI6KhtUzsvMEKdo0H5D3Kjt
         vGeLy1Ee8taKtaKjK4uz6w7Mqc1O/H182DoR8lztYXQoM8ONUUaQSbrLpQsulXNIyxWz
         Dv53a9rswaTnzj7RNec8kXtkCiFbkQyi8Og4U4rwr5WWkKumJIjPoGYiSwvTKUV7EwfE
         d1ZyhgYZl4msf1oqbcaWrLv7dfbY5fE24dfez4q11vu8i6iwTkwmdnUyP172YIMkWp8Z
         dZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cb3Vo2vLk4ryIodn1SYTiwH3Et1KhclqG020AZoiFgU=;
        b=Ola+dal3bsbhy8sufyI0upnGLcB22eEHZa8E0m+8ikEIBJ5+FZwF5lKvTI1TTjq+rX
         pAy+FNri0IKca1wpCX00Prg6wTIKfz12VZ61HHS8zItsqNB3tYPUDH3lUd7F/rbu9ZYo
         +9jMp8sHT4wk0xCFlvneB7nkjWGmWuaAkdnQvt60iTw0k1msRIl5OnytX5z9NwF1UdDZ
         VB+qoIhJwLYJSMrt94QPrJjFW+5rPNTmhD3W27M/8O1aJ4roGedD35XKrQpNRoXiSA0i
         /a+Ikp/gLji/tqqk08LZyt1wBN6NeJfx0LqyDxv6KTQxh5CcodqSCV2eSPCmFwJHuTbt
         i1/g==
X-Gm-Message-State: AOAM531GIrHL+cThoQYqHnzBrZ2HeMtmnQM7bVkVLL1JBnUQjAI0NAKo
        5JcnbXy3pCC0shzWiVF8ZW5eLH2t1eo=
X-Google-Smtp-Source: ABdhPJy/oECYbUHUPJVNtFB2jUtCUu/UpRbS7MJuhkCUKWhPrFKhSyUD+nuXOr5/y/7k4QV0mrQsWg==
X-Received: by 2002:a17:907:2648:: with SMTP id ar8mr784946ejc.521.1623348864771;
        Thu, 10 Jun 2021 11:14:24 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id dh18sm1705660edb.92.2021.06.10.11.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 11:14:23 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v2 net-next 02/13] net: stmmac: reverse Christmas tree notation in stmmac_xpcs_setup
Date:   Thu, 10 Jun 2021 21:13:59 +0300
Message-Id: <20210610181410.1886658-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210610181410.1886658-1-olteanv@gmail.com>
References: <20210610181410.1886658-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Reorder the variable declarations in descending line length order,
according to the networking coding style.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
v1->v2: none

 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 3b3033b20b1d..a5d150c5f3d8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -399,11 +399,11 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 
 int stmmac_xpcs_setup(struct mii_bus *bus)
 {
-	int mode, addr;
 	struct net_device *ndev = bus->priv;
-	struct dw_xpcs *xpcs;
-	struct stmmac_priv *priv;
 	struct mdio_device *mdiodev;
+	struct stmmac_priv *priv;
+	struct dw_xpcs *xpcs;
+	int mode, addr;
 
 	priv = netdev_priv(ndev);
 	mode = priv->plat->phy_interface;
-- 
2.25.1

