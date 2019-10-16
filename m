Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF770DA1F1
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 01:07:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437556AbfJPXHb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 19:07:31 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46177 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391310AbfJPXH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 19:07:28 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so106963wrv.13;
        Wed, 16 Oct 2019 16:07:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2Mypw3BR815FFU4U5Q7Ds4joCjvD25A3UExNUUx7Khw=;
        b=d+qnmMVPcEb8+hIeAATNeaELj8bvwthwp6JE0yCrVhD/Dj2o3H6kypx82ogtDIx2r+
         JAvQc+Vrof9gx5t+RiIsZ/tGcjLUwFDafuEvhvj9T77YtIjsQViYgZClre1Sc1ZPhs4/
         2Fy4AcCwSZoXX8xxIuimBp1k9GZ6bQzrTmtBN1lAJ/mKFKzeno+rwzVV277oznYTwSH0
         YGfRlYueEiLWmkkbcHeribdoQ6XDeAP4JzSfqzm6vc8Vnn2KYtzm4WmsGwKOlrT3hMic
         iL8DF0XJzkdcsGSbETkaKgQgPfCzv9kaWEQ4LKjhOsTM168rkbmRE7s31gjx+TX71Vid
         z4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2Mypw3BR815FFU4U5Q7Ds4joCjvD25A3UExNUUx7Khw=;
        b=BU+QQ1bDAJS+VyjpNBQctR8q84E1b13BZZxIgK7I/hDOBejymT3/vWHvijCDqMewN8
         xrZaTb5CboSyoRqqu5upD9iXT2HrnS2w/DIBjb7FEVFaNTbu2OIvzaH9jAU7yn5p4WVD
         6DwN0bZUCjAK+Gr8FGR/jBn853zEMhHD53BAmL+sT5uih28ST5SArR0vKtqRmAMqUMYm
         PQEX7TAV/ahZW9Slr8Ta2LAdj+yMp+s5eD47qi4VwgXK7L7Z07oZvVh4u+2HZTqcgA91
         eGPbedD6jttdCangKpLHTkov+6XAcgmZuk2P2aWwLLWi8VMbAemeDOThhGw8gPmC9upS
         OBMg==
X-Gm-Message-State: APjAAAWY3t+4Eji5IdQniQXTSxyNHykrlqG62MNVHzVA54CnUoCoLYEZ
        mQyNyWbQMmmxAWS+12RsNoA=
X-Google-Smtp-Source: APXvYqw7ygO2UMf+AY9OJvdGudEUStiSQ3fz9a5y560ulc/4+4OqXyJfEW9JJDS45+cWVASSPxGZZA==
X-Received: by 2002:adf:f0cc:: with SMTP id x12mr252059wro.326.1571267246314;
        Wed, 16 Oct 2019 16:07:26 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id l9sm297071wme.45.2019.10.16.16.07.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 16:07:25 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net 2/4] net: phy: bcm7xxx: define soft_reset for 40nm EPHY
Date:   Wed, 16 Oct 2019 16:06:30 -0700
Message-Id: <1571267192-16720-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
References: <1571267192-16720-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The internal 40nm EPHYs use a "Workaround for putting the PHY in
IDDQ mode." These PHYs require a soft reset to restore functionality
after they are powered back up.

This commit defines the soft_reset function to use genphy_soft_reset
during phy_init_hw to accommodate this.

Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 8fc33867e524..af8eabe7a6d4 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -572,6 +572,7 @@ static int bcm7xxx_28nm_probe(struct phy_device *phydev)
 	.name           = _name,					\
 	/* PHY_BASIC_FEATURES */					\
 	.flags          = PHY_IS_INTERNAL,				\
+	.soft_reset	= genphy_soft_reset,				\
 	.config_init    = bcm7xxx_config_init,				\
 	.suspend        = bcm7xxx_suspend,				\
 	.resume         = bcm7xxx_config_init,				\
-- 
2.7.4

