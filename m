Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 475A42B094F
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 17:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729084AbgKLP77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:59:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728874AbgKLP63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:29 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7987C0613D1;
        Thu, 12 Nov 2020 07:58:28 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cq7so6862081edb.4;
        Thu, 12 Nov 2020 07:58:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ulq0yD0my4Otp65SkQZNLolrSXf+hFMzY6ErDKfcVE=;
        b=tXYwL7r4So6bp1gZYXepAd5QTtB1eSBW87eG93DxuwN5Th2+/CdaXxfkLkc9B3KFvE
         Lv5SphrQiO7hOix6IRAedK0UqUQVExLke0Sm9Qg9zfitOvmqMlbNYWSsQObn8BqC1HwB
         uwpfOM4dIbDURFxWa/zqWkC1UN6BYlbm2+6uUn6yD0oiCWYliS7lPvXkwI7r7fT49osE
         l01tqqEEc2OvycQ6Jcmj5ctMimBrRMLe9bmC7C9prBdMmcgKX/cbwly0mC+gqETsoj2+
         lp1BeKocgDOPGxqwq1MJIzAj+t/AeIppTH108ht+/zL/NVn81zslkWBvoOMAxp8wqevy
         WRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ulq0yD0my4Otp65SkQZNLolrSXf+hFMzY6ErDKfcVE=;
        b=Av9JzkeRlm5pelMBXToDWV3gzMg+EHrfkMnzoMp7q/CA2ZKk5XzztxRUWjLwejFP+5
         zlL0DXf5npDZYRrX1lwBg4s5uq2DQx/gD/6YfeyTIJpVNfSGH9i1GanUWSAbLCvJmjnA
         3KPwzEjjUj/1Jy+xccyumxNrjPdiHLKy1u4qOvkfukthouV6xvlPVV4TNFEbEqblXvbd
         oe+QocvbUVZMYZWFDsqm70vDA6XN9/2EpPmsTAaq5g65DHXUzGSIPuxdfmD4zL6Vtu8J
         YDfiM+b4Emk3Hjdwe8skbpmybtDvPwq+5DeCQ4whld2tfqm4581xTdcO5Y+ZjiI3MWWB
         SGVA==
X-Gm-Message-State: AOAM533Ie4RIhSGKGOGXyd3684dxCGpuC8pSi+SYgS0JYvjA53baR4+l
        +rh/lqcxPy8uw3Jwys/obUw=
X-Google-Smtp-Source: ABdhPJyAVfXrgcet3yb/Wh2PY3f0ENCMODWxX6la6zD/3pEjV9EOkXJiq732hgewxmir/JLAa0uewg==
X-Received: by 2002:a50:e04d:: with SMTP id g13mr460895edl.72.1605196707482;
        Thu, 12 Nov 2020 07:58:27 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:26 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>, Marek Vasut <marex@denx.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [PATCH net-next 09/18] net: phy: nxp-tja11xx: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:04 +0200
Message-Id: <20201112155513.411604-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201112155513.411604-1-ciorneiioana@gmail.com>
References: <20201112155513.411604-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

In an attempt to actually support shared IRQs in phylib, we now move the
responsibility of triggering the phylib state machine or just returning
IRQ_NONE, based on the IRQ status register, to the PHY driver. Having
3 different IRQ handling callbacks (.handle_interrupt(),
.did_interrupt() and .ack_interrupt() ) is confusing so let the PHY
driver implement directly an IRQ handler like any other device driver.
Make this driver follow the new convention.

Cc: Marek Vasut <marex@denx.de>
Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/nxp-tja11xx.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
index a72fa0d2e7c7..1c4c5c267fe6 100644
--- a/drivers/net/phy/nxp-tja11xx.c
+++ b/drivers/net/phy/nxp-tja11xx.c
@@ -44,6 +44,9 @@
 #define MII_CFG2_SLEEP_REQUEST_TO_16MS	0x3
 
 #define MII_INTSRC			21
+#define MII_INTSRC_LINK_FAIL		BIT(10)
+#define MII_INTSRC_LINK_UP		BIT(9)
+#define MII_INTSRC_MASK			(MII_INTSRC_LINK_FAIL | MII_INTSRC_LINK_UP)
 #define MII_INTSRC_TEMP_ERR		BIT(1)
 #define MII_INTSRC_UV_ERR		BIT(3)
 
@@ -604,6 +607,24 @@ static int tja11xx_config_intr(struct phy_device *phydev)
 	return phy_write(phydev, MII_INTEN, value);
 }
 
+static irqreturn_t tja11xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_INTSRC);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_INTSRC_MASK))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int tja11xx_cable_test_start(struct phy_device *phydev)
 {
 	int ret;
@@ -749,6 +770,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_stats	= tja11xx_get_stats,
 		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
+		.handle_interrupt = tja11xx_handle_interrupt,
 		.cable_test_start = tja11xx_cable_test_start,
 		.cable_test_get_status = tja11xx_cable_test_get_status,
 	}, {
@@ -772,6 +794,7 @@ static struct phy_driver tja11xx_driver[] = {
 		.get_stats	= tja11xx_get_stats,
 		.ack_interrupt	= tja11xx_ack_interrupt,
 		.config_intr	= tja11xx_config_intr,
+		.handle_interrupt = tja11xx_handle_interrupt,
 		.cable_test_start = tja11xx_cable_test_start,
 		.cable_test_get_status = tja11xx_cable_test_get_status,
 	}
-- 
2.28.0

