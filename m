Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87BD529E87F
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgJ2KJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgJ2KI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:59 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EE3C0613CF;
        Thu, 29 Oct 2020 03:08:57 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id v19so2412764edx.9;
        Thu, 29 Oct 2020 03:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iSqdzsR05m30MrTKYfN0RdpfKEkLx7WjEE7llyjtWDc=;
        b=hpfvENbl5rzDeLS7kdA8/eWwoUvtcjvC12sLtkJHAEsxBKZGyUM9KNEuTvK0opZ95r
         HwHFCy+ZLlYkY1+ub8N7i5hr2Z43yfLoT1yNbugZIlTWgBexD7qjehPmWWt/RstU/qsw
         yd/fft/WS3p3zPMLtNlUWBjAgE7MEDQVcUK1A9mkiPWSDxeluPJOs4qDCMGgYYmnfVdN
         Ov4V9rB//vwtVDpIKbkLDd197sLyl2v89HU/rvVySrpP8HegKnctuC6gysSFv7u+ITDH
         B24HTzlBPbiPwy3JQLMxMWpkMP6C2U+a6rkxtBB+iDnsEt+cfEcTMq5D7jiVIk8Ut+Lu
         Q11g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iSqdzsR05m30MrTKYfN0RdpfKEkLx7WjEE7llyjtWDc=;
        b=iJpNCORxVS1gXxvN1yfw32KwlVWGJE44f3HL3TJxZf7m0SKZXZkVu/QwCYKB4t+LHB
         Fs3vCioNVe0qhWa1t7d3a6wYGLs59tmZp2F7u3CesP8vLlQt/ndsG98Zg5Orq8VEWUYw
         nnz6WwoXSJ0nuQrtsKFJPXxlnSdR/WZAQ6zhFpNygfbNVwfOtDEjZ6PwX+Nmovx+5haF
         pmAkxqe32+JRdMyZKoi2TjT2pL7qoGHG6hBtPKuGuSdOjm2CJBNsC5Drh4fxmdbw3JAj
         cJx8awp14jROdOFAvbfjZF2W1IyUK+DGMXjSmWXJUxh7FSmbBXP8U9SeGhlhQN72AkIu
         VJYQ==
X-Gm-Message-State: AOAM531EUoddCJnW7wQJzWtbCHRw/fslGb4QGTKSg03chB6OQKL49Rd6
        ydmzGMwdgQdMjpItjjjn7iE=
X-Google-Smtp-Source: ABdhPJzqlCnMkO6bSHbM11jgWkdh8i36hMUnmFiepHJok7UOpA7tvNkmoC7OC5jYlTmv+Sn/55Tqgg==
X-Received: by 2002:aa7:d394:: with SMTP id x20mr3173915edq.14.1603966136692;
        Thu, 29 Oct 2020 03:08:56 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:56 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 13/19] net: phy: cicada: implement the generic .handle_interrupt() callback
Date:   Thu, 29 Oct 2020 12:07:35 +0200
Message-Id: <20201029100741.462818-14-ciorneiioana@gmail.com>
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

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/cicada.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/cicada.c b/drivers/net/phy/cicada.c
index 9d1612a4d7e6..03b957483023 100644
--- a/drivers/net/phy/cicada.c
+++ b/drivers/net/phy/cicada.c
@@ -96,6 +96,24 @@ static int cis820x_config_intr(struct phy_device *phydev)
 	return err;
 }
 
+static irqreturn_t cis820x_handle_interrupt(struct phy_device *phydev)
+{
+	int irq_status;
+
+	irq_status = phy_read(phydev, MII_CIS8201_ISTAT);
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
 /* Cicada 8201, a.k.a Vitesse VSC8201 */
 static struct phy_driver cis820x_driver[] = {
 {
@@ -106,6 +124,7 @@ static struct phy_driver cis820x_driver[] = {
 	.config_init	= &cis820x_config_init,
 	.ack_interrupt	= &cis820x_ack_interrupt,
 	.config_intr	= &cis820x_config_intr,
+	.handle_interrupt = &cis820x_handle_interrupt,
 }, {
 	.phy_id		= 0x000fc440,
 	.name		= "Cicada Cis8204",
@@ -114,6 +133,7 @@ static struct phy_driver cis820x_driver[] = {
 	.config_init	= &cis820x_config_init,
 	.ack_interrupt	= &cis820x_ack_interrupt,
 	.config_intr	= &cis820x_config_intr,
+	.handle_interrupt = &cis820x_handle_interrupt,
 } };
 
 module_phy_driver(cis820x_driver);
-- 
2.28.0

