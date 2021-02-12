Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75B731A38A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 18:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231292AbhBLRZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 12:25:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231546AbhBLRZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 12:25:28 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377FEC0613D6
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:24:48 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y18so551537edw.13
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 09:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bh0BqV3JwCvPqAI5uWtLopwKQ8wNwNF0Xbt77Fqb3FA=;
        b=fgYRXdXY33swqusM2bbQp1Hpi/TQy2LfxVUoJ8186Hm/aISCaIvZ+52z6jT5tX6mkl
         tfPMaSSdGNulfd7vnObIcRLN5NtbhKFfQLyB4A9UgPpVhxPr4r5AVwWmf+1W4tRLeoDG
         uW+5io9y9OEgboG1Q/Dp8XMhpDd3pm6V5AYSXbiYzeupKyptX+fLCBjOzH4FJN72Seya
         b5Bk+0647twYiXDwlH0NJ9KdqUYq5R260Rv8kuXQ933mBurX3PIVdbuI/DF6CPS/m6Pv
         52sjiv92Jvl8qrH4hf6douaVXttLfqnaYwD7d1uZg1ofyJEVffNwnfuoSxbpXXsqV1P8
         Dw1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bh0BqV3JwCvPqAI5uWtLopwKQ8wNwNF0Xbt77Fqb3FA=;
        b=JONA4aeN5dQqvUkiEBysIy1ISXmujwkfrl+7gQjr28kfL5vhotWMda73Ec2Rui9j4K
         //Mhr6OHzzdqgbyM20ncTND46XQZhR0agH1dvMU84cF7VuM+WI1vgj8g5IvwRamU8xHF
         EyaNkKAtwaIMU9beOSDlDKg3wiMk+/oNTOEr8OMVezyAPaoOUyGO1WgZ33oiYW6DHR0w
         BZ5bJi2zX3n84m6/tpk467O/iAref7qW8b5yfRE8IwQJJynCSQEcWBNUvRJp6XTcPH2a
         Kwv6LVb0eb/JHn7BINI0oTUKARKK7gP7PQpMvI/5u8tZpXAjNAeR8lrhd07n2NnZaNkO
         fbug==
X-Gm-Message-State: AOAM53058pMN1of4uA0vbvPlyPcAvjfmX1oMHD4Bre+4gmlFBJWWqiH3
        a7g27tEI+vsI4nDu3CsBkVQ=
X-Google-Smtp-Source: ABdhPJxCnWVNR9VfJrXHiyiVZcVQzcpWndkGrHYLDYPpD2uq//mU8zNmMfrfGxIuMlD6AGwjZRc/mw==
X-Received: by 2002:a05:6402:1c0f:: with SMTP id ck15mr4308573edb.16.1613150686998;
        Fri, 12 Feb 2021 09:24:46 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id x25sm6061616edv.65.2021.02.12.09.24.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 09:24:46 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Antoine Tenart <atenart@kernel.org>,
        Quentin Schulz <quentin.schulz@bootlin.com>,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Steen Hegelund <steen.hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH net-next 2/2] net: phy: mscc: configure in-band auto-negotiation for VSC8514
Date:   Fri, 12 Feb 2021 19:23:41 +0200
Message-Id: <20210212172341.3489046-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210212172341.3489046-1-olteanv@gmail.com>
References: <20210212172341.3489046-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Add the in-band configuration knob for the VSC8514 quad PHY. Tested with
QSGMII in-band AN both on and off on NXP LS1028A-RDB and T1040-RDB.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/phy/mscc/mscc.h      |  2 ++
 drivers/net/phy/mscc/mscc_main.c | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/phy/mscc/mscc.h b/drivers/net/phy/mscc/mscc.h
index 9481bce94c2e..44d1d8f28481 100644
--- a/drivers/net/phy/mscc/mscc.h
+++ b/drivers/net/phy/mscc/mscc.h
@@ -187,6 +187,8 @@ enum rgmii_clock_delay {
 #define MSCC_PHY_EXTENDED_INT_MS_EGR	  BIT(9)
 
 /* Extended Page 3 Registers */
+#define MSCC_PHY_SERDES_PCS_CTRL	  16
+#define MSCC_PHY_SERDES_ANEG		  BIT(7)
 #define MSCC_PHY_SERDES_TX_VALID_CNT	  21
 #define MSCC_PHY_SERDES_TX_CRC_ERR_CNT	  22
 #define MSCC_PHY_SERDES_RX_VALID_CNT	  28
diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 2f2157e3deab..2951ed216620 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1986,6 +1986,18 @@ static int vsc85xx_read_status(struct phy_device *phydev)
 	return genphy_read_status(phydev);
 }
 
+static int vsc8514_config_inband_aneg(struct phy_device *phydev, bool enabled)
+{
+	int reg_val = 0;
+
+	if (enabled)
+		reg_val = MSCC_PHY_SERDES_ANEG;
+
+	return phy_modify_paged(phydev, MSCC_PHY_PAGE_EXTENDED_3,
+				MSCC_PHY_SERDES_PCS_CTRL, MSCC_PHY_SERDES_ANEG,
+				reg_val);
+}
+
 static int vsc8514_probe(struct phy_device *phydev)
 {
 	struct vsc8531_private *vsc8531;
@@ -2176,6 +2188,7 @@ static struct phy_driver vsc85xx_driver[] = {
 	.phy_id_mask	= 0xfffffff0,
 	.soft_reset	= &genphy_soft_reset,
 	.config_init    = &vsc8514_config_init,
+	.config_inband_aneg = vsc8514_config_inband_aneg,
 	.config_aneg    = &vsc85xx_config_aneg,
 	.read_status	= &vsc85xx_read_status,
 	.handle_interrupt = vsc85xx_handle_interrupt,
-- 
2.25.1

