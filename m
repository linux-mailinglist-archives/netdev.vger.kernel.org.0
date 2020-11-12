Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5092B0928
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:58:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728866AbgKLP61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgKLP6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:21 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8025C0613D1;
        Thu, 12 Nov 2020 07:58:20 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id v4so6876621edi.0;
        Thu, 12 Nov 2020 07:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Jk5b9nB+oqKMHLVq5uhhdOuhJ71EuKFqGbaLsLlT2HU=;
        b=UH50FOe8hifDLYF9FTbh5I6yaXE+AwV8tq/JpdQSxgi1L+M8NtCNC5wNLlXYdgo2h1
         jb8UG1PvLWoIxw8y8z2rHA7AWEkvHsKVvGu3l7c3g3nprJ8ap69QDG9CZ+Wm70uDNGQ8
         KiW0V44PcLYu0Br/K4j/evuPAZvyFF5/KMm2K0ZXvTfubp4xOdP+VhE+F4jlZZmjbK8D
         bYipeoqFteCTDzum6mTN/if0AAiSSjE0qNjG7kt+nj7cT/23MlKtHWPP3u3s/5wd9UI7
         oLL9bxpTBpWlva9u7V13n/NkW0QVa+GlW+BhysKfqPUH5YSkjwj5+ejnJ9r33CRsGp8D
         eisg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Jk5b9nB+oqKMHLVq5uhhdOuhJ71EuKFqGbaLsLlT2HU=;
        b=FBvkNE/erTeFZSrxBgbq+7EilSNxozq/+VZoTn7CyPt7JbdNn0v+oyiA4tJiA/PJcC
         y+n0ZTuO7rkT54KvH//dYUTSHgMdCWyGD/WIo+ZWU2pWMI7vjK2k+64clfGYdAiRZ68J
         H5O82Nn4gG0Eb6PQiDJOvCafeBAGl/ukV0jNYFbZRfynUvwIKvbBMgeDymvoDBd4EMYn
         /2qOg8AX4SMrrpXoglXkQk7bLiHB8GhJkBNrMDHmZ/fMflR+T+PAlbwFgHzrFba4WlcY
         3O9q7dgAfoqDcmcb5ryadwPIPugMeP8W4cecewTDC6F2f4x4Msf3XpNJCuVu4w+EAb0X
         6zZg==
X-Gm-Message-State: AOAM532hG1tdAFvUqPQ9RShIgMwQN3Slbi1NmxthAnus/zTjIvXW8sIR
        ufkcw+wT9NfQadIQ1R6Zydo=
X-Google-Smtp-Source: ABdhPJzs/8iagcffBUJjN8XXYt08i7NJeBt9zI0ZwW6IQitKkqFB8Q+XqF1YSISFTCyt7uX4YYW2hw==
X-Received: by 2002:a50:9e86:: with SMTP id a6mr419851edf.238.1605196699524;
        Thu, 12 Nov 2020 07:58:19 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:19 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Nisar Sayed <Nisar.Sayed@microchip.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>
Subject: [PATCH net-next 03/18] net: phy: microchip: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:54:58 +0200
Message-Id: <20201112155513.411604-4-ciorneiioana@gmail.com>
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

Cc: Nisar Sayed <Nisar.Sayed@microchip.com>
Cc: Yuiko Oshino <yuiko.oshino@microchip.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
For the lan87xx_handle_interrupt() implementation, I do not know which
exact bits denote a link change status (since I do not have access to a
datasheet), so only in this driver's case, the phy state machine is
triggered if any bit is asserted in the Interrupt status register.

 drivers/net/phy/microchip.c    | 19 +++++++++++++++++++
 drivers/net/phy/microchip_t1.c | 19 +++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/phy/microchip.c b/drivers/net/phy/microchip.c
index a644e8e5071c..b472a2149f08 100644
--- a/drivers/net/phy/microchip.c
+++ b/drivers/net/phy/microchip.c
@@ -56,6 +56,24 @@ static int lan88xx_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static irqreturn_t lan88xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN88XX_INT_STS);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & LAN88XX_INT_STS_LINK_CHANGE_))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int lan88xx_suspend(struct phy_device *phydev)
 {
 	struct lan88xx_priv *priv = phydev->priv;
@@ -342,6 +360,7 @@ static struct phy_driver microchip_phy_driver[] = {
 
 	.ack_interrupt	= lan88xx_phy_ack_interrupt,
 	.config_intr	= lan88xx_phy_config_intr,
+	.handle_interrupt = lan88xx_handle_interrupt,
 
 	.suspend	= lan88xx_suspend,
 	.resume		= genphy_resume,
diff --git a/drivers/net/phy/microchip_t1.c b/drivers/net/phy/microchip_t1.c
index 1c9900162619..04cda8865deb 100644
--- a/drivers/net/phy/microchip_t1.c
+++ b/drivers/net/phy/microchip_t1.c
@@ -203,6 +203,24 @@ static int lan87xx_phy_ack_interrupt(struct phy_device *phydev)
 	return rc < 0 ? rc : 0;
 }
 
+static irqreturn_t lan87xx_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, LAN87XX_INTERRUPT_SOURCE);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (irq_status == 0)
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int lan87xx_config_init(struct phy_device *phydev)
 {
 	int rc = lan87xx_phy_init(phydev);
@@ -222,6 +240,7 @@ static struct phy_driver microchip_t1_phy_driver[] = {
 
 		.ack_interrupt  = lan87xx_phy_ack_interrupt,
 		.config_intr    = lan87xx_phy_config_intr,
+		.handle_interrupt = lan87xx_handle_interrupt,
 
 		.suspend        = genphy_suspend,
 		.resume         = genphy_resume,
-- 
2.28.0

