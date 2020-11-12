Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BBA2B0931
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 16:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbgKLP6m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 10:58:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728935AbgKLP6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 10:58:39 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BEAC0613D4;
        Thu, 12 Nov 2020 07:58:39 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id b9so6854621edu.10;
        Thu, 12 Nov 2020 07:58:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kaxRXeGuXfHak60d13Nyjn4fY/R1ELgbzE8j8qdmc+o=;
        b=t3rGd9fQjD+ZqUSjfbnS3MaN2Ytfy9sBqTIz1+6v45QcftikW6yhkQQvOgMAxJ5DpT
         Ket6Yeo2buJefdhEjpG5fwL04IQY9H8w72D8LYlH/LL2/lLAkYz+r/mExwsw9NK8jcLC
         /SAThsHyQrm9iww3mGu4UFul4omNnpkrUVAwjB8XZGN9BMWAFk4uyDs9mV+3vEwWV5/6
         OyfBgDhrZQ7Bje6xl5XFCrRNOgyK45EcYO7WL62f49GyiGOUAxKPgYVYQ+WG2Q9UDQhj
         q7Xuju5/F9Od6XrpeEC0IGe/ocs12OqZYkyu4IYhngVRD6hC6AwfoDi8naU8iKgV02Ej
         1vUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kaxRXeGuXfHak60d13Nyjn4fY/R1ELgbzE8j8qdmc+o=;
        b=OmmKQRdO9BzQK+r16LQaYrdUrBg830AO3XUZiRC5hbA82YH4fXnZS+P2Yw9hGTGK0v
         5wxzsErTcTP/BJJEb4n2qtT6W/eCWhD+MKRXqXRogOcb/Q6dmmccs03d9/X2T9qq6LdY
         qtNI/0obTUT9Ls0t0nO/MgJhs5rtswRL4XcQHNZOddjPPuP6c+Aq0X3774jhNK/bsBkj
         jqh1Ii2N0CUSMZ9HBgWE0vhc7WMUIw0oI16Uw8Uk7gZh0mZy4ww0VRqdxRuqSY3VYYhk
         wq0WLLrM9Ypg2aDxdAQbn2MKfdtw//MSCHxHdIKWM8pgKmsO6xqNCqzm/p8KeZw5sjv8
         4CsA==
X-Gm-Message-State: AOAM532vwLwx5Lc2Kn/uPpJMu8KH2FGv9vORMNrjmfW64yg2bHoap3vB
        JW4jEdmv0IBJXPkmKt/b0HA=
X-Google-Smtp-Source: ABdhPJykrY0a+UFv1JBQmlk/8EBXrHIaOLyf25xnejFN39ceA5liy0N6q/PKQEsVSoOA8qEm+nufHw==
X-Received: by 2002:a50:cfcd:: with SMTP id i13mr364858edk.275.1605196717842;
        Thu, 12 Nov 2020 07:58:37 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id q15sm2546540edt.95.2020.11.12.07.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 07:58:37 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH net-next 17/18] net: phy: adin: implement generic .handle_interrupt() callback
Date:   Thu, 12 Nov 2020 17:55:12 +0200
Message-Id: <20201112155513.411604-18-ciorneiioana@gmail.com>
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

Cc: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/adin.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/adin.c b/drivers/net/phy/adin.c
index 3727b38addf7..ba24434b867d 100644
--- a/drivers/net/phy/adin.c
+++ b/drivers/net/phy/adin.c
@@ -479,6 +479,24 @@ static int adin_phy_config_intr(struct phy_device *phydev)
 			      ADIN1300_INT_MASK_EN);
 }
 
+static irqreturn_t adin_phy_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, ADIN1300_INT_STATUS_REG);
+	if (irq_status < 0) {
+		phy_error(phydev);
+		return IRQ_NONE;
+	}
+
+	if (!(irq_status & ADIN1300_INT_LINK_STAT_CHNG_EN))
+		return IRQ_NONE;
+
+	phy_trigger_machine(phydev);
+
+	return IRQ_HANDLED;
+}
+
 static int adin_cl45_to_adin_reg(struct phy_device *phydev, int devad,
 				 u16 cl45_regnum)
 {
@@ -879,6 +897,7 @@ static struct phy_driver adin_driver[] = {
 		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.handle_interrupt = adin_phy_handle_interrupt,
 		.get_sset_count	= adin_get_sset_count,
 		.get_strings	= adin_get_strings,
 		.get_stats	= adin_get_stats,
@@ -902,6 +921,7 @@ static struct phy_driver adin_driver[] = {
 		.set_tunable	= adin_set_tunable,
 		.ack_interrupt	= adin_phy_ack_intr,
 		.config_intr	= adin_phy_config_intr,
+		.handle_interrupt = adin_phy_handle_interrupt,
 		.get_sset_count	= adin_get_sset_count,
 		.get_strings	= adin_get_strings,
 		.get_stats	= adin_get_stats,
-- 
2.28.0

