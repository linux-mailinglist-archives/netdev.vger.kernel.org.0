Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1BF398FDC
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbhFBQXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:23:48 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:44846 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbhFBQXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:23:40 -0400
Received: by mail-ej1-f49.google.com with SMTP id c10so4662666eja.11
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:21:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=InEy5/81GRSeKeQLmbl3JxFBwNC56Mf2ggNeB4hyCvg=;
        b=qIlT/RIakNceShPJINUCMN81CDz548JJCWRZItng/Ekm/iEnqnHY8TnX8kP5pj7DXA
         Go0xpJFP1e4QZcf0QGetwRE2zmpg+LwGnxIoL+hIqOhq7xd/McR5akTtWBFQpVTz6p4E
         FHI64pZLwYBlzR+qMGGLsnnwgbGRLuPmH3R8SP9KthsmyjmgcWIkqpewYFPchGVX4hDe
         Mu4KTYxPs+wr1QIMSf1/jz3QrLWklhsMKvu6X9bYyazDv871UqMta4U3xYc9a/Tabwt6
         QgNTCIpd2w47I8rGBaGb4nqfaHeFMKwHMLAzoazs7BXW0IxQRiqrlXIw5J3J888hgXq8
         CGcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=InEy5/81GRSeKeQLmbl3JxFBwNC56Mf2ggNeB4hyCvg=;
        b=uPv/g17o1WQMFGHIrJCU7MyE7SUUa7TRM/BN8VA0oFL88WlWekhqkjoI1jjSn7k6fr
         1rCZlZB9Mz6GXjsQdFMVPZbWTG3eXwjDW9uLa6jUW4eoL711adKkfMPuEuyoJExWvkbl
         kdWxea5pnlPZjbstGH53/CxDxYatJmwUGglGcn/Aef6QYa/+hy277ID9p30CBEPzdXSf
         DI6svrKfFpt2YZm62QaiL2K6BZDPM+DyBrDxorWLv6mAdJX9eEDjQPzH7/uD6LTM0PY4
         f6yUNsrlAlPoIhRfTxwrCtoR10o2tnh2Xek39V6ZEiMeD+/LxNJULLTZ/HH5taSHONa1
         DpgQ==
X-Gm-Message-State: AOAM531/oPPJwnziixGN91h7N052xHphcaRvy9LS4THvALJF4vJP2RLx
        +H+m0JaI5bOW4UgxHfPfFVY=
X-Google-Smtp-Source: ABdhPJyDRFMTham/AX0crT5WaUd9esixo9ZDUjkuycQ0o/p35jj/lO9XKCJEpzi7CW6bl7AFVzhseA==
X-Received: by 2002:a17:906:4d04:: with SMTP id r4mr16476496eju.76.1622650840440;
        Wed, 02 Jun 2021 09:20:40 -0700 (PDT)
Received: from localhost.localdomain ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id m12sm228078edc.40.2021.06.02.09.20.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 09:20:40 -0700 (PDT)
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
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v3 net-next 7/9] net: pcs: xpcs: use mdiobus_c45_addr in xpcs_{read,write}
Date:   Wed,  2 Jun 2021 19:20:17 +0300
Message-Id: <20210602162019.2201925-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210602162019.2201925-1-olteanv@gmail.com>
References: <20210602162019.2201925-1-olteanv@gmail.com>
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
v1->v2: none
v2->v3: none

 drivers/net/pcs/pcs-xpcs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/pcs/pcs-xpcs.c b/drivers/net/pcs/pcs-xpcs.c
index 7f51eb4bbaa4..afabb9209c52 100644
--- a/drivers/net/pcs/pcs-xpcs.c
+++ b/drivers/net/pcs/pcs-xpcs.c
@@ -240,14 +240,14 @@ static bool __xpcs_linkmode_supported(const struct xpcs_compat *compat,
 
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

