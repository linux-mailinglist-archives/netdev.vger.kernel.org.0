Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6817829E8A1
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgJ2KKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbgJ2KIq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:46 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B40C0613CF;
        Thu, 29 Oct 2020 03:08:46 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w1so1295960edv.11;
        Thu, 29 Oct 2020 03:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Vg6cxA4AV0TwhpYzKE3rrOiS3WmEuG9OucTOqCd4JEU=;
        b=GeIdPWHWyeASPHLv0SIp050YogjP6ZjV7PxGCszfKYJKx4+iqelgQpR7ZNQfs+JLZ6
         eQf5ivyLCJPcs76sHy3oiC1jK43PI3SPwDGiCcYKQBAWfnqRrvFOItb4XnRNPDuWHzlZ
         +tOjJ4M8CQlHNUQQezWv7iulwhpTg8nBHx/Ki1Nhbu4f6sgH9ZPa9wFkK61KPW4g3KL7
         havqxiHoURWGg02KgDqj0VsXPCd5pWu9ftZWXBsEYcjhCximgFHI9teZQt7aeToyoROJ
         lxgmDzWwp1pFV3LXdICVf6KUlYaFvCbChP0/N5kemR099Nbb4IPZx/1Ni7iDvA3vcFFK
         /64w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vg6cxA4AV0TwhpYzKE3rrOiS3WmEuG9OucTOqCd4JEU=;
        b=P652m4ow21ZCh4FBLXGaEHq9dLZYeOfTFfeamWD6m5DymRs4cQ5uz1QAeR5D4ZdG9o
         cKOSx5NsCyJ6ByRBcm3F3IT5HoeQFKGUEOK5brR45js3+1hEKbUL2pdMLtO+C/7Mx2cS
         vC9o1ZBA6j5SXJp1XI3DEUoX1QJls30ITpTIU++PMZRQsOotzreTyY3UXzRxQ87qAjVQ
         bMrAL2n22RrxNfpshu8UMdHpo4XRUnCr+RXT9hzpfFq4R852VYO46mwjcIc7IyRBwr8z
         un3C/Mpi/uu5wn27yWtfx4XSNkbyY2+23qqoAhXNzeJDSGKYgGY3+wuGeSPttwmww2Pp
         2GDg==
X-Gm-Message-State: AOAM532+gun5Ignnit9PpJZPS/EooMeJjXn26FSE+Uz9ueYvQ7/OQoAw
        RiMSa4oJEvg7f1G/KvSfirE=
X-Google-Smtp-Source: ABdhPJxdvUN9NSwMamYkUDcOG1oqw4mCuCja0cL0ccMkBjJHW4fnNZ7rvrIdKgfYc00LPM+HgHBHSA==
X-Received: by 2002:a50:e881:: with SMTP id f1mr3172080edn.58.1603966125056;
        Thu, 29 Oct 2020 03:08:45 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:44 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Michael Walle <michael@walle.cc>
Subject: [PATCH net-next 04/19] net: phy: at803x: implement generic .handle_interrupt() callback
Date:   Thu, 29 Oct 2020 12:07:26 +0200
Message-Id: <20201029100741.462818-5-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
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

Cc: Oleksij Rempel <o.rempel@pengutronix.de>
Cc: Michael Walle <michael@walle.cc>
Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/at803x.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/phy/at803x.c b/drivers/net/phy/at803x.c
index ed601a7e46a0..106c6f53755f 100644
--- a/drivers/net/phy/at803x.c
+++ b/drivers/net/phy/at803x.c
@@ -628,6 +628,24 @@ static int at803x_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t at803x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, AT803X_INTR_STATUS);
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
 static void at803x_link_change_notify(struct phy_device *phydev)
 {
 	/*
@@ -1064,6 +1082,7 @@ static struct phy_driver at803x_driver[] = {
 	.read_status		= at803x_read_status,
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1084,6 +1103,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 }, {
 	/* Qualcomm Atheros AR8031/AR8033 */
 	PHY_ID_MATCH_EXACT(ATH8031_PHY_ID),
@@ -1102,6 +1122,7 @@ static struct phy_driver at803x_driver[] = {
 	.aneg_done		= at803x_aneg_done,
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.get_tunable		= at803x_get_tunable,
 	.set_tunable		= at803x_set_tunable,
 	.cable_test_start	= at803x_cable_test_start,
@@ -1122,6 +1143,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= at803x_ack_interrupt,
 	.config_intr		= at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
 }, {
@@ -1134,6 +1156,7 @@ static struct phy_driver at803x_driver[] = {
 	/* PHY_BASIC_FEATURES */
 	.ack_interrupt		= &at803x_ack_interrupt,
 	.config_intr		= &at803x_config_intr,
+	.handle_interrupt	= at803x_handle_interrupt,
 	.cable_test_start	= at803x_cable_test_start,
 	.cable_test_get_status	= at803x_cable_test_get_status,
 	.read_status		= at803x_read_status,
-- 
2.28.0

