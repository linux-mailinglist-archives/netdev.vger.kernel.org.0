Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14B28426130
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 02:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243015AbhJHAZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 20:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242668AbhJHAZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 20:25:06 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD8CC06176A;
        Thu,  7 Oct 2021 17:23:11 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id g10so28703897edj.1;
        Thu, 07 Oct 2021 17:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kPyIko2PRzv//D0aLqaiF08VDVNoIeOA63B50bJM/Ws=;
        b=i0hDdGvkdVMEhTUi6K4PUhUjL/p1e/HdYgBpX6aX6qiHUoOG9w49PvcU2J44wTQY+r
         IhD+pJIhz8ZSUQZds1WFUtVQCK+arwpTqYnFoySgZMBL54Az5CkxEGoi2+L4J5Zcf4to
         XO8Hayru+dYuacxpFcRZg9Y5bVCW9tSyRTRyyp9PqaAlmH9Qf6Bndoal2ECQGsqRDNw4
         ApgCSaFdzCN25As3VNU+RlFTCKrsvC1DW63qhyilMIsvEEggwa02i8U6F4DCSnJl4Dyu
         4RsLcoQJNbRYvPhLi3/99sFvmsQ+jnPx98r4t0nt9cDmZo5SiMZhbQ71+HTnL05kteVy
         g40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kPyIko2PRzv//D0aLqaiF08VDVNoIeOA63B50bJM/Ws=;
        b=cxIJf7SHv3JiEmhjl8ZUNv0ciCRSDTNrRWSwLAUA0/869iNIsFcX1gZM7j5RdtvHNJ
         ZYL+QQZNouKDpKsHjOE+7QMu9DnhcrR6ziz1bq+i2uB4J6rYqpwrV4MLKjnH0AiQFyV0
         MEXS7Tn19KoTVtBt1881KZKVaYq8mCp4hcqwDNCW3mg6g9YaWNgviLDqQkbr+w9pcbfx
         w+mVlO4E+HUppXhhYTDM2C5zf2vXuJIbq67+nyD37TnRzqJKJFehUcDFikzt67ERsyru
         xpINZ/52cc1hM7fyrHpmYc5S4nLyETMG5niCiY/WXBp4vg+HemSXg+Y4ormM00R6bLr+
         fnEQ==
X-Gm-Message-State: AOAM5310NG4/FZV4ni2sT8zb1+/eoi2kqNZNVyN0czYakZv64xpGjGNY
        k7Ir2g2/LcxLBj14UkprbjY=
X-Google-Smtp-Source: ABdhPJynpYNG5T39kdAmuQGDrNOf9a5ge3Swc3UUIn6cJtwTo33gY1lD7d/WYKQ7kJ0w0wGo76BnnA==
X-Received: by 2002:a17:906:640f:: with SMTP id d15mr91856ejm.419.1633652590282;
        Thu, 07 Oct 2021 17:23:10 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id ke12sm308592ejc.32.2021.10.07.17.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 17:23:09 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [net-next PATCH v2 10/15] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Fri,  8 Oct 2021 02:22:20 +0200
Message-Id: <20211008002225.2426-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211008002225.2426-1-ansuelsmth@gmail.com>
References: <20211008002225.2426-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support enabling PLL on the SGMII CPU port. Some device require this
special configuration or no traffic is transmitted and the switch
doesn't work at all. A dedicated binding is added to the CPU node
port to apply the correct reg on mac config.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 05ecec4ebc01..8917bb154e8f 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1237,6 +1237,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
+		dp = dsa_to_port(ds, port);
+
 		/* Enable SGMII on the port */
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 
@@ -1255,8 +1257,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (ret)
 			return;
 
-		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
-			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+		val |= QCA8K_SGMII_EN_SD;
+
+		if (of_property_read_bool(dp->dn, "qca,sgmii-enable-pll"))
+			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			       QCA8K_SGMII_EN_TX;
 
 		if (dsa_is_cpu_port(ds, port)) {
 			/* CPU port, we're talking to the CPU MAC, be a PHY */
-- 
2.32.0

