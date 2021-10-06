Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4038A4249DD
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 00:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240067AbhJFWjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 18:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239854AbhJFWie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 18:38:34 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A3BC061762;
        Wed,  6 Oct 2021 15:36:40 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id p13so15925371edw.0;
        Wed, 06 Oct 2021 15:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=UaCfwxQyICFRn47sKu0NVRcgx1lpcpn3rb9dZlWLRD8=;
        b=CCo9cWeWzx6GV6U42mzvdQdVC5sHWp59WNt8hidlY930qVEGjwtwcLNgJ+lnfPW1yF
         i/HZrFFNv8m6OYeeT8EWNWkFZ6OqgiEtt19hpAAyHshCJddwPluinw7zBi1i/Llt+CbO
         0OqcV8fLAnI3zOtwWrn2eVBs0GnQb9pgQRY4EOlQtI3uaeoZzzlXWWfSHn6O9uaI8XJb
         HMGPI6b3LR+oxI0qwFYLeUaq+pmRIL4qr9CaDkEuGmgLKi8fmksewcjwjeYfrXvnMibX
         cge5QiQa2TKIxBIVK5zAcKaUiycLmrmkHoCOjkkUmYTv4T4drUCyark1SRmzrwJ0D/y5
         ns8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UaCfwxQyICFRn47sKu0NVRcgx1lpcpn3rb9dZlWLRD8=;
        b=ysFK1a+OmXIG/SWHf+D0unAyXCa6m3xfwjK97rZMdAHzCL8kbzhPMHwqs34HMcha92
         BIBKamFKUOfBE4Z99+a7UlS7RQt1H0tw5+5ZI+TGiwogB+bT5iV8dmeWIe6oDOZnmn2Q
         clfGioWy2a8HVDX5ZZeaDP+8NeXu0icYxrpbbcFGiLNaBnSNcRkfWjsikqBWnVQuR4TN
         bh4ACM1IWFzBqWrVVlilbh3K3n6TYQx0vuk43aQ89Bzy+RUPyDCdL35l73srDWiftH65
         5eTi++U/7XIlZiWssi+iA9hrSM5eD7IgS/I4SHqCqZsVe9jz1JgV0jIYFNAUTp2MrF6i
         ++2A==
X-Gm-Message-State: AOAM530yNTMOo+qbXcCRz5bMZDf/bHXsx/wh2ZO0bgFctSF7pyUY6Yq/
        ntEC6eY4HKpieJm+VLx0t7Q=
X-Google-Smtp-Source: ABdhPJxo5N1dTabx47/CHGgr3P+HACEEA3b++bX9WFK4JgDL6xME8VnHXly4wnczboCACQ0dsoxzdA==
X-Received: by 2002:a05:6402:2682:: with SMTP id w2mr1194519edd.185.1633559799179;
        Wed, 06 Oct 2021 15:36:39 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z8sm9462678ejd.94.2021.10.06.15.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 15:36:38 -0700 (PDT)
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
Subject: [net-next PATCH 10/13] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Thu,  7 Oct 2021 00:36:00 +0200
Message-Id: <20211006223603.18858-11-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211006223603.18858-1-ansuelsmth@gmail.com>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
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
 drivers/net/dsa/qca8k.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 4d4f23f7f948..01b05dfeae2b 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1214,6 +1214,7 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 			 const struct phylink_link_state *state)
 {
 	struct qca8k_priv *priv = ds->priv;
+	struct dsa_port *dp;
 	u32 reg, val;
 	int ret;
 
@@ -1282,6 +1283,8 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		break;
 	case PHY_INTERFACE_MODE_SGMII:
 	case PHY_INTERFACE_MODE_1000BASEX:
+		dp = dsa_to_port(ds, port);
+
 		/* Enable SGMII on the port */
 		qca8k_write(priv, reg, QCA8K_PORT_PAD_SGMII_EN);
 
@@ -1300,8 +1303,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
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

