Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A3039374C
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 22:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhE0Urb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 16:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236052AbhE0UrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 May 2021 16:47:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0658C061574
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:47 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lg14so2095607ejb.9
        for <netdev@vger.kernel.org>; Thu, 27 May 2021 13:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KV4L5yPhusQwpn3Ky/Es1VhkJTPcXPa1gVI8rTgpDUo=;
        b=kPIa6phvPga725lveo2klEzb2aTPZvqSpOsgveBoV9Xo3y+MN8c8CoLCjpizrCTEvl
         YR01OWr4byDPtrF0Ht8N9wcJplkuC+OAgcPaQDueaN9M/HVBQ3dNCa/CtiDYfaAC0KSN
         fjSy4l9brDiLydNK79B1V8QqIfHe2oj9JwD6R+Gaypwo6zCe5sqRT/z6Sc7C5V6iSNYC
         pVmeSb8Zm1FxcjI7fxmC1af5621awz5M5yQ55Ba4P5aM+sDKr7f0BZ9xoXOu24czztEn
         tkS3HKX/DAEGjzgL8T10jJZb7T2VLxWuPuwDFVcSqbpDqYiWMowAW6uw621q1gzdhBEP
         Sx+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KV4L5yPhusQwpn3Ky/Es1VhkJTPcXPa1gVI8rTgpDUo=;
        b=Qz3PYIIPf59gM95KzN7ZRXJt739EOo6QAnS6fuXxAApmKv9jeDu3uygBLJi+y33z55
         J3st6kBXOEJF6t5nIV4pgNLEQP4eyowUniFGXhUBwhXZ9ZA58TSTv2Am+LsPO8QREqEG
         T+Fns8nqClmtitIWTjtuX+xibeMp4eSzC6ypXpFCp3a80RXJapGBaWi704EqQyUuD4I5
         /boWTjteXD+JdmpkBzpBQeaCBxcd83Qow6SI3z83YL3Qku9MXgpvxElFwiMwDloiFcKS
         v0QDlgaEwP+8FtG123ceFollyGKf2lIGGH2tXeD+3eiJdMCCWqTj0/7ie1yeSYwWzmoq
         1jWQ==
X-Gm-Message-State: AOAM530WagRQDl/iEVWO5xmsuog8P3NPG/PNORZL8xzCdsbopXFIXRIn
        t8qBqxPzGPClYWtG0HEiOTluQQFE/HM=
X-Google-Smtp-Source: ABdhPJyighIHBKIxUGuLn5Doa2pKyhAV/MO6ZrQ1hViVCcyxTeJaz3dZ049ovYGzaVEyn7Nt6FKYdw==
X-Received: by 2002:a17:907:2d0c:: with SMTP id gs12mr5856037ejc.173.1622148346390;
        Thu, 27 May 2021 13:45:46 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id g11sm1654145edt.85.2021.05.27.13.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 13:45:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [RFC PATCH net-next 7/8] net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
Date:   Thu, 27 May 2021 23:45:27 +0300
Message-Id: <20210527204528.3490126-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210527204528.3490126-1-olteanv@gmail.com>
References: <20210527204528.3490126-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Use the dedicated helper for abstracting away how the clause 45 address
is packed in reg_addr.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/pcs/pcs-xpcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 288abe8ddaf3..e0a7e546f32b 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -220,14 +220,14 @@ static struct xpcs_id {
 
 static int xpcs_read(struct mdio_xpcs_args *xpcs, int dev, u32 reg)
 {
-	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
+	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 
 	return mdiobus_read(xpcs->bus, xpcs->addr, reg_addr);
 }
 
 static int xpcs_write(struct mdio_xpcs_args *xpcs, int dev, u32 reg, u16 val)
 {
-	u32 reg_addr = MII_ADDR_C45 | dev << 16 | reg;
+	u32 reg_addr = mdiobus_c45_addr(dev, reg);
 
 	return mdiobus_write(xpcs->bus, xpcs->addr, reg_addr, val);
 }
-- 
2.25.1

