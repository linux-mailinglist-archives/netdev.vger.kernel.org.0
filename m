Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C41C29E881
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgJ2KJH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726866AbgJ2KJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:09:03 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB3BC0613D2;
        Thu, 29 Oct 2020 03:09:03 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id p93so2430647edd.7;
        Thu, 29 Oct 2020 03:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z3tbMXzhuBxBBcxu29NK84/5ZH6lbxeaxIV+Myg/cks=;
        b=OvhWKVIx38tNaxPv2H9kIleTbNpO78JUZafg/ZR3kiFsSDfj8eYEKcjdchRmTnRrCE
         +r1+POojZIkDYEIKcFJoG4sNcVK1xitPadkcg3TWK/fOBe1KnU5iF0WhBm6tMGcWHPV2
         z1IXdHpLnrSNmHANQaPDMk9jY0qqQXrKlPWHjuArZ13Qiyv6V2xmTLGtyfCyMRRcAZV0
         wq+1LCNpAwja+lXx56LBgKQmuSWkAIGYM+NiqBVbLGYjUk/qonqGKtPr5pTBsixRbkYi
         aIZToLxuT678B4dwxYyejATSA6SGQ18sXGWBQ7wudV/ogAVEPAMsOgvMGCd43m2bgw2S
         pmKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z3tbMXzhuBxBBcxu29NK84/5ZH6lbxeaxIV+Myg/cks=;
        b=AX51W5HCtA6qkWPSxoQOwcO/r45mUw7LWvnpSugLdM545wRuUCfDu9rPk37TXz80Ep
         zSl+M7xDY+02aue0L9GHwg3SZ59PKXEFLfsx4a5aaOb16GZYf0qQerM8NiNEys12dw4Z
         ldbqFCON5C9Y+vP1+MgsrPmFA/L0CQJyBr7GqWG8Cjz1U/ij/dgeszfp7B/pejF3rq3s
         wIkV7oqQ6xOU319JOoF8z/BpwylmPtZf3BEWpi6kx8FH848zWR+4NrZ0TFgurtH0cPLM
         89NifmWM/Ql+75l/R7V2yZcc50Nm4pUn29LPb6HfLVDYZbHeuyRTaEeSA+mi4jKs7xv4
         r3rw==
X-Gm-Message-State: AOAM531/9GvGdDSJWnnXNlrRSnY4UwgTMPk+XtOrvE6xDYvq58js27vT
        di3q3O+UjUeA3p7ftxQv/AERoxZmTs/T6GmV
X-Google-Smtp-Source: ABdhPJx3XzC9MT2i/1s6t8xQw5or2K039h3E6YUFY+YXoyXLiZJuC15JXjB4bY0e3X2LGHn4pNAANg==
X-Received: by 2002:aa7:de97:: with SMTP id j23mr3186484edv.45.1603966141852;
        Thu, 29 Oct 2020 03:09:01 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.09.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:09:01 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 17/19] net: phy: add genphy_handle_interrupt_no_ack()
Date:   Thu, 29 Oct 2020 12:07:39 +0200
Message-Id: <20201029100741.462818-18-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

It seems there are cases where the interrupts are handled by another
entity (ie an IRQ controller embedded inside the PHY) and do not need
any other interraction from phylib. For this kind of PHYs, like the
RTL8366RB, add the genphy_handle_interrupt_no_ack() function which just
triggers the link state machine.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/phy_device.c | 13 +++++++++++++
 include/linux/phy.h          |  1 +
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index f54f483d7fd6..e13a46c25437 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2463,6 +2463,19 @@ int genphy_soft_reset(struct phy_device *phydev)
 }
 EXPORT_SYMBOL(genphy_soft_reset);
 
+irqreturn_t genphy_handle_interrupt_no_ack(struct phy_device *phydev)
+{
+	/* It seems there are cases where the interrupts are handled by another
+	 * entity (ie an IRQ controller embedded inside the PHY) and do not
+	 * need any other interraction from phylib. In this case, just trigger
+	 * the state machine directly.
+	 */
+	phy_trigger_machine(phydev);
+
+	return 0;
+}
+EXPORT_SYMBOL(genphy_handle_interrupt_no_ack);
+
 /**
  * genphy_read_abilities - read PHY abilities from Clause 22 registers
  * @phydev: target phy_device struct
diff --git a/include/linux/phy.h b/include/linux/phy.h
index 566b39f6cd64..4f158d6352ae 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -1510,6 +1510,7 @@ int genphy_suspend(struct phy_device *phydev);
 int genphy_resume(struct phy_device *phydev);
 int genphy_loopback(struct phy_device *phydev, bool enable);
 int genphy_soft_reset(struct phy_device *phydev);
+irqreturn_t genphy_handle_interrupt_no_ack(struct phy_device *phydev);
 
 static inline int genphy_config_aneg(struct phy_device *phydev)
 {
-- 
2.28.0

