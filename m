Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 206282AE6E
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 08:16:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726141AbfE0GQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 02:16:21 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33730 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfE0GQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 02:16:18 -0400
Received: by mail-lj1-f195.google.com with SMTP id w1so13623746ljw.0
        for <netdev@vger.kernel.org>; Sun, 26 May 2019 23:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0kiGslaZ4r/gl+DqOjDyVqXyomIFfgoJCTIOyWqhOtA=;
        b=dCfXRsIzCUqg+JU3AQzzVLz/3cjQEBpCBaxwOozXD5OR65zOY1dKXvbrYoWfJRNrPk
         RQHXKEFP2OSqmZSULnRIgC0iq3OB7N2X/GXcREe+c0qDUVLLx1WmzUsYu5mjKw8EhfJg
         z2fjhM4BAge8xZSHTy5H9ThT0MjKvSyIH7D+B06vydNZSAZUgVxsW3xK0UG4TAv4yTqI
         BfAHoxY4bKjnUEFOmW38L8KABwZV4PmO/7iiYuB3ZFSbjTva+4ZQ0JHGHDGDr1yD/dMS
         7Nk2U8LvlgW4b2HjgTEdGD/uA/Mzxk2FPBcy8uPcigTJdaxUyEtJsWfZesgxnemCBkmZ
         pCww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0kiGslaZ4r/gl+DqOjDyVqXyomIFfgoJCTIOyWqhOtA=;
        b=lj2Q+zzKDgiK6fiTNlq3nUBM4gjJUr4J9BT2NBfpdh9GvxxHZEW7q3mLtsqqn+qbIJ
         m8jmpNmfYA42cI1ltn5yIkSvzwKMuy+k5LbnL1xIyRaxuL3t9Hv+1MS0HvTfGlgWqJnE
         ce7hab7Cy4NVXXuSmMWwsyEzX5dYfjkfeDzl6ZTtuLKIQOBwhdgr6KFSL/6jBQ8JXRmw
         oLVbJNlVezLTUvkaG/J8+BskbrMjo3l8yzcSqEueY4jLD8NNPMgyAgp2j1orcYohp+Qr
         bqj2rhdeP28vaxAjZj9BuMvFM7G13zaezwIG9ou8OBz8DD/Qo8uUkZ4tqh/nVLbQbZyA
         502Q==
X-Gm-Message-State: APjAAAVAW/netCSuW7wYJ1uTsKpJQwcDUH5EV1Rp3wlokHopTHJnoWjC
        psClIx5CmWc4YhwnpvRH+Y4sILdWFofOJw==
X-Google-Smtp-Source: APXvYqzpaRS1xxB9mq6aL6sDGENsrkYFTBQKrv6T+YWGDN0yY0syUzds3vkYBfwcDgXpic7KSfu/aA==
X-Received: by 2002:a2e:864e:: with SMTP id i14mr28255992ljj.141.1558937775790;
        Sun, 26 May 2019 23:16:15 -0700 (PDT)
Received: from maxim-H61M-D2-B3.d-systems.local ([185.75.190.112])
        by smtp.gmail.com with ESMTPSA id a25sm2045454lfc.28.2019.05.26.23.16.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 23:16:15 -0700 (PDT)
From:   Max Uvarov <muvarov@gmail.com>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, Max Uvarov <muvarov@gmail.com>
Subject: [PATCH v2 1/4] net: phy: dp83867: fix speed 10 in sgmii mode
Date:   Mon, 27 May 2019 09:16:04 +0300
Message-Id: <20190527061607.30030-2-muvarov@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190527061607.30030-1-muvarov@gmail.com>
References: <20190527061607.30030-1-muvarov@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For support 10Mps sped in SGMII mode DP83867_10M_SGMII_RATE_ADAPT bit
of DP83867_10M_SGMII_CFG register has to be cleared by software.
That does not affect speeds 100 and 1000 so can be done on init.

Signed-off-by: Max Uvarov <muvarov@gmail.com>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/phy/dp83867.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index fd35131a0c39..75861b8f3b4d 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -30,6 +30,7 @@
 #define DP83867_STRAP_STS1	0x006E
 #define DP83867_RGMIIDCTL	0x0086
 #define DP83867_IO_MUX_CFG	0x0170
+#define DP83867_10M_SGMII_CFG  0x016F
 
 #define DP83867_SW_RESET	BIT(15)
 #define DP83867_SW_RESTART	BIT(14)
@@ -74,6 +75,9 @@
 /* CFG4 bits */
 #define DP83867_CFG4_PORT_MIRROR_EN              BIT(0)
 
+/* 10M_SGMII_CFG bits */
+#define DP83867_10M_SGMII_RATE_ADAPT		 BIT(7)
+
 enum {
 	DP83867_PORT_MIRROING_KEEP,
 	DP83867_PORT_MIRROING_EN,
@@ -277,6 +281,22 @@ static int dp83867_config_init(struct phy_device *phydev)
 				       DP83867_IO_MUX_CFG_IO_IMPEDANCE_CTRL);
 	}
 
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		/* For support SPEED_10 in SGMII mode
+		 * DP83867_10M_SGMII_RATE_ADAPT bit
+		 * has to be cleared by software. That
+		 * does not affect SPEED_100 and
+		 * SPEED_1000.
+		 */
+		val = phy_read_mmd(phydev, DP83867_DEVADDR,
+				   DP83867_10M_SGMII_CFG);
+		val &= ~DP83867_10M_SGMII_RATE_ADAPT;
+		ret = phy_write_mmd(phydev, DP83867_DEVADDR,
+				    DP83867_10M_SGMII_CFG, val);
+		if (ret)
+			return ret;
+	}
+
 	/* Enable Interrupt output INT_OE in CFG3 register */
 	if (phy_interrupt_is_valid(phydev)) {
 		val = phy_read(phydev, DP83867_CFG3);
-- 
2.17.1

