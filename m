Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735112C0F0B
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 16:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389693AbgKWPjD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 10:39:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389685AbgKWPjC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 10:39:02 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE348C0613CF;
        Mon, 23 Nov 2020 07:39:00 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id k1so4617307eds.13;
        Mon, 23 Nov 2020 07:39:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cqDNeq3r/DZ3Fa6vyHKMYrzd94gpNO8C1c5X2bRnhJY=;
        b=QhDIP0U2vCHqonbpJ2sMdYVCddNT/RjlHFiSLCiW9/tJC+hwXnRnkAHhTfxvwqhYTT
         YozXdT//y7ra0VjjdywHFD7LpLsklOIPgUM1kAurCWB9ysp9Deyk95OoGqwfXVlM2tHv
         jOLWh7HWkluMjWuQU/LBWlXzMyWRMxQyGlTKevjlbrfkrF8kwGvacNaCpu1G4Pq+nhzK
         PtQ23WNU1TBnh51qcKC11cxPZureadf8Zx2eaonu7f+EvARzFgNoCTizOyrA84/ZPAS1
         gpWVaVoXhd/auPNKt19H3LTVnFK9XF+TrRz3hO7614KreHhhGrsukisQGnZFVk/sFMiq
         eN9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cqDNeq3r/DZ3Fa6vyHKMYrzd94gpNO8C1c5X2bRnhJY=;
        b=HJgKNcLBM6OaPeO15cyYYi79kycZXb77arFw5UfiG3vIjD6P2Qm+RzNX2ghpkhG5VW
         C0xLi31C7pNSuW1g/1ZzjZH4N+FkM1Rlt89qSStOfLXFrLeA5E2SBi7ANGM1vxgF91SA
         t0edKB412VQ+cEOjbr0bRbYeJbdHcWe/KIK9JUCHvPlfUNGUiDIfoYON/AI3FNlV+/hH
         vXVGee84VIFGuMD5SIEHGV01K+Edq+A5dDIif9jDAfc97Yzy3pW2QWANL109rb0GUxWY
         UxzK6PPw0lc2V6fCvbxSwdqa05IHscrNwE/9Ba7zpVQVMFF/E/dHr9DYfsAxOEul1Jq/
         l2+Q==
X-Gm-Message-State: AOAM532PifCPRMa6ZMsxQ4ioLOuEjuzUfQ7YEszDtq32W4Edml9oGynr
        h6FqWAlHl+VVzxjTCkyEBmQ=
X-Google-Smtp-Source: ABdhPJzHGXDkG++aTYU4CeeveWrHoP2UUo1eJ5SGSQiyUcx+H06KETz8U0JU2zEGPAy0yk3fvOJQjw==
X-Received: by 2002:aa7:d615:: with SMTP id c21mr48136666edr.23.1606145939544;
        Mon, 23 Nov 2020 07:38:59 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c6sm4800126edy.62.2020.11.23.07.38.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 07:38:58 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 13/15] net: phy: qsemi: implement generic .handle_interrupt() callback
Date:   Mon, 23 Nov 2020 17:38:15 +0200
Message-Id: <20201123153817.1616814-14-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201123153817.1616814-1-ciorneiioana@gmail.com>
References: <20201123153817.1616814-1-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/qsemi.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/phy/qsemi.c b/drivers/net/phy/qsemi.c
index 1b15a991ee06..97f29ed2f0ca 100644
--- a/drivers/net/phy/qsemi.c
+++ b/drivers/net/phy/qsemi.c
@@ -106,6 +106,27 @@ static int qs6612_config_intr(struct phy_device *phydev)
 
 }
 
+static irqreturn_t qs6612_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_QS6612_ISR);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & MII_QS6612_IMR_INIT))
+		return IRQ_NONE;
+
+	/* the interrupt source register is not self-clearing */
+	qs6612_ack_interrupt(phydev);
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static struct phy_driver qs6612_driver[] = { {
 	.phy_id		= 0x00181440,
 	.name		= "QS6612",
@@ -114,6 +135,7 @@ static struct phy_driver qs6612_driver[] = { {
 	.config_init	= qs6612_config_init,
 	.ack_interrupt	= qs6612_ack_interrupt,
 	.config_intr	= qs6612_config_intr,
+	.handle_interrupt = qs6612_handle_interrupt,
 } };
 
 module_phy_driver(qs6612_driver);
-- 
2.28.0

