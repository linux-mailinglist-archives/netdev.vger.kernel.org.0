Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5F562B20F3
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 17:53:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726557AbgKMQxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 11:53:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgKMQxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 11:53:16 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BE1C0617A7;
        Fri, 13 Nov 2020 08:53:15 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id b9so11462737edu.10;
        Fri, 13 Nov 2020 08:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kaxRXeGuXfHak60d13Nyjn4fY/R1ELgbzE8j8qdmc+o=;
        b=UdVXk3LX0+GRq7VBXDPnmTmleY12yk6LDleSJEieYCQGg10aLewuXKmLP1yJGOuvTh
         pXjWnPphcb0PhsiW18phrbleNUx/HoLwJDJzXT9wUCRv/gxAF0C+AwooGVadqthIpE4l
         KmujtiEihqKxJoRiNPh/suTxu5EKU5/Gf7gT1q9U3Yv3l7/2ecodHeqxFIod7aY66HwK
         xsB3yFt06C85d43/ulRvqnuQIZaOC7fSTa109X8x2B+VstjyMSRsRzVu0neWuhYwJsEK
         n3SxrQe/TPIr3rjhca6ij0lgWvGKpm5F/mPf+CqXm57Pake9mLBi8y2/KYQD6v3PIGbA
         GJDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kaxRXeGuXfHak60d13Nyjn4fY/R1ELgbzE8j8qdmc+o=;
        b=B2lcka4hTtj9Tp84VVZ9Gh8MrKVX+l+MyEpy8jZIWFVGxBJvytbvS9fmw3FtmHXgor
         nvLc+WvTLf8gUuJ9pMalXK9mw+tZB6T2ieS0D1VPeAsgozbuNro9lzSsFWWxVpVEwO8K
         Ec2ODWXEB1zS9jWBcSrI5v3VossrR+MXHip/pWigNemxe9jh+hSH0AnGMyeXiFO2UqxB
         8q2S0t8UuJhMN81PDEKA1VWfR04iIAw6/KuRRT1Z7XFwXISjRyEBnSucJl6jIeHef11+
         L3SgApYPU4hXJO915eapuKIJpn6CEQHl+DSwGHPE1epoybp5mYrVkj6EHE9oQ/BkVrEn
         H+QA==
X-Gm-Message-State: AOAM532tia2MPzeTRYTWZE+9qolrAqHZn/Z5hUPyL1ipKSrvSfd7L71T
        9HkcRjGGQPyoYk15/z9pr6G8ov9Gr064gg==
X-Google-Smtp-Source: ABdhPJz2EkVU09tx1Rcw5mQUK4NuHiuczcJxTf05ZadM6uY6f/l3+yPQcF3QkvrseVmQBE0jSSKnjw==
X-Received: by 2002:a05:6402:141:: with SMTP id s1mr3247800edu.87.1605286394096;
        Fri, 13 Nov 2020 08:53:14 -0800 (PST)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rp28sm4076570ejb.77.2020.11.13.08.53.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 08:53:12 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: [PATCH RESEND net-next 17/18] net: phy: adin: implement generic .handle_interrupt() callback
Date:   Fri, 13 Nov 2020 18:52:25 +0200
Message-Id: <20201113165226.561153-18-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201113165226.561153-1-ciorneiioana@gmail.com>
References: <20201113165226.561153-1-ciorneiioana@gmail.com>
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

