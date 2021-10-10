Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BBB4280BA
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhJJLS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:18:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbhJJLSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:18:13 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41A9C061766;
        Sun, 10 Oct 2021 04:16:14 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z20so55209582edc.13;
        Sun, 10 Oct 2021 04:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ct5tSBNKAW1Vt4MkhFAB3av0RudEwIPTFp+3+07mKTg=;
        b=TB6UydIZIbHsB2nQGDsr9nylEwoW34IEppxroKuj38QM8MZxBIgmtFtUmKSORu6N93
         NASWq3+Qer+5NgIVFDQX9owdMF7D2INTftIeNHwMc7NJpl2w3/S/0L45B3RF8mpGXX66
         wXox5SdO4C+O13/Kp3xpnxer5XLxPwVBokD2hAQJEb86VRarYQn4J7UBdBN1yjIoVCfI
         d5lAri+DWUx1i+ux00UofYoAbzrJw6F9hy6YucpMlDZ8zmq7kb3jKeyzJ7jWe3oysH+7
         rMsCHZ012dHUnrbbpc4jnCXKB8Ars9Jchg/vmgGGRt0gkeKJAIJaA1KwMdwiTe2GjYK6
         cUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ct5tSBNKAW1Vt4MkhFAB3av0RudEwIPTFp+3+07mKTg=;
        b=P+4b1ni5oJHDuE9L9vPGoRdoGnTM7i38W3kgQpowojebiNbHoMCw+fRl41cROwRo8G
         VKNzGvzGRfm/IVK5FYYYU2k0KydMLFUO86o+q0Cn5cgOkgJd+KMpmI6/7lB5s26nc6sZ
         +3MKXcqyUIyhlck2juhYCtJ0HGe2psQYm3Alqn5RBh/ib73lli3C5cIMYbYFqLEiOUvy
         IS6udaR2Ybvy5g6i+wVM/tQKGjTiNWvruAByKYCtrLXU3HU1wnuEP5r6xOzRd0vaLHTN
         IyWlIGxNMHBaRtC+npKXNlXAEowvyv6g2bY0QSewxzd1U/IREoYK2GF6QNnLbxthaTD8
         HTTQ==
X-Gm-Message-State: AOAM531uw5ejNsJ5DIzhpROpWmf+UnGL9OmwyTKIaCFMJPOiZVdoLZUj
        aXK9nPntYDHkSDwFalaQwG5AW90X6FE=
X-Google-Smtp-Source: ABdhPJzAyyhr8874xDlkbyadE07ihBCfB/l7kN/D/zkf2RmPGImurGngIQ14cQjanE76zq/F+BpAzA==
X-Received: by 2002:a17:906:f243:: with SMTP id gy3mr18591350ejb.327.1633864573252;
        Sun, 10 Oct 2021 04:16:13 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id z5sm2414438edm.82.2021.10.10.04.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Oct 2021 04:16:12 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v4 07/13] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Sun, 10 Oct 2021 13:15:50 +0200
Message-Id: <20211010111556.30447-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010111556.30447-1-ansuelsmth@gmail.com>
References: <20211010111556.30447-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Support enabling PLL on the SGMII CPU port. Some device require this
special configuration or no traffic is transmitted and the switch
doesn't work at all. A dedicated binding is added to the CPU node
port to apply the correct reg on mac config.
Fail to correctly configure sgmii with qca8327 switch and warn if pll is
used on qca8337 with a revision greater than 1.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 126f20b0b94c..afdfbcbbdb52 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1245,8 +1245,20 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		if (ret)
 			return;
 
-		val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
-			QCA8K_SGMII_EN_TX | QCA8K_SGMII_EN_SD;
+		val |= QCA8K_SGMII_EN_SD;
+
+		if (of_property_read_bool(dp->dn, "qca,sgmii-enable-pll")) {
+			if (priv->switch_id == QCA8K_ID_QCA8327) {
+				dev_err(priv->dev, "SGMII PLL should NOT be enabled for qca8327. Aborting enabling");
+				return;
+			}
+
+			if (priv->switch_revision < 2)
+				dev_warn(priv->dev, "SGMII PLL should NOT be enabled for qca8337 with revision 2 or more.");
+
+			val |= QCA8K_SGMII_EN_PLL | QCA8K_SGMII_EN_RX |
+			       QCA8K_SGMII_EN_TX;
+		}
 
 		if (dsa_is_cpu_port(ds, port)) {
 			/* CPU port, we're talking to the CPU MAC, be a PHY */
-- 
2.32.0

