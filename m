Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE36B29E877
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 11:10:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726707AbgJ2KIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 06:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726674AbgJ2KIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 06:08:49 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0FC1C0613CF;
        Thu, 29 Oct 2020 03:08:48 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id dg9so2390163edb.12;
        Thu, 29 Oct 2020 03:08:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T5XcUZu+SnqPOg6uGWPm+6vMcKuKj8o1aFhhSPVAROk=;
        b=DHL0thqjyVIHujJtl3J/xBEVbNKG8JUydovt15m2O359vOAVXR0DEVUmJDjDu8W5uC
         2t331HmKA0sbees7AhyWmfvDRnLC2cCYR5WJmYG6XjYiw+JP9UnV7wLKlsXcO+EgFfjY
         QWYaYgd2Xyss9MejyfNPD2BpyQDqSdct6ku3hMTouKpeP4G2Ru+X7Pe5zTzKW+0pa/Db
         Eo1P2Fv10XakmQhZKgIXjQiTok4QBVMU66ohOFNqkiPZGNMAfQg2M1hrE6nZrzG4PLQG
         BRUbGRVBDvjOMRfZODwdEv26qrf8E0TMf1deImfMnqqvKPFWATSSTohmNjw4Oxr3zTjh
         P5Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T5XcUZu+SnqPOg6uGWPm+6vMcKuKj8o1aFhhSPVAROk=;
        b=U+TKnRvWo+4Gt0kelmkZq3aJ4c405fxL9zrLfE3RbpnGNACuXamTfoD2ZMLKAWqQ12
         EmgUyTv2x4WDBOO6AaKMsE/mEh7Qv9u3a1HRN+W0U3FFliMtbq+9IbZzWPhaEiHa816e
         5Cf5VW1EbUYqKlZ8Ht0Q3flQ1V66qLZ914Udx4yUiyHTCa9+76o2Gpni1enQ+n1HVGBX
         VNRvSTbPpGu4Ir/zDIsSZilNNGFCZsViMh81663KIZasfH5nkFl98o5C/v22lzsO5f8+
         iXYGRBm36F4wF0fVoxDAK9dfGdsphhY5+Tb1sMb6H0KDGaB8A5vZxUOjrr6FaEddjNuv
         I/0A==
X-Gm-Message-State: AOAM531dWEc5n3Y1rhFkLe2CNYFUCPlmWNFlbJppcemVb0bdJ0NZesRD
        EJaoUp789RWUO7UPac/HCE68sivkVbz9rhjt
X-Google-Smtp-Source: ABdhPJwhrco2Ylo0x2zVWpxXNv4Un2peFD+Q2d1sYzlzrWKNB+uM3xIQGncuX2W1UGasjBAmri50jQ==
X-Received: by 2002:aa7:d54f:: with SMTP id u15mr3155378edr.239.1603966127731;
        Thu, 29 Oct 2020 03:08:47 -0700 (PDT)
Received: from yoga-910.localhost ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id m1sm1198650ejj.117.2020.10.29.03.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 03:08:47 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 06/19] net: phy: mscc: use phy_trigger_machine() to notify link change
Date:   Thu, 29 Oct 2020 12:07:28 +0200
Message-Id: <20201029100741.462818-7-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201029100741.462818-1-ciorneiioana@gmail.com>
References: <20201029100741.462818-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

According to the comment describing the phy_mac_interrupt() function, it
it intended to be used by MAC drivers which have noticed a link change
thus its use in the mscc PHY driver is improper and, most probably, was
added just because phy_trigger_machine() was not exported.
Now that we have acces to trigger the link state machine, use directly
the phy_trigger_machine() function to notify a link change detected by
the PHY driver.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/phy/mscc/mscc_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/mscc/mscc_main.c b/drivers/net/phy/mscc/mscc_main.c
index 6bc7406a1ce7..b705121c9d26 100644
--- a/drivers/net/phy/mscc/mscc_main.c
+++ b/drivers/net/phy/mscc/mscc_main.c
@@ -1498,7 +1498,7 @@ static irqreturn_t vsc8584_handle_interrupt(struct phy_device *phydev)
 		vsc8584_handle_macsec_interrupt(phydev);
 
 	if (irq_status & MII_VSC85XX_INT_MASK_LINK_CHG)
-		phy_mac_interrupt(phydev);
+		phy_trigger_machine(phydev);
 
 	return IRQ_HANDLED;
 }
-- 
2.28.0

