Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4751E454EEE
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 22:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240392AbhKQVI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 16:08:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240718AbhKQVIT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 16:08:19 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B302C061570;
        Wed, 17 Nov 2021 13:05:20 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y12so16882715eda.12;
        Wed, 17 Nov 2021 13:05:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=BUclrFJvY/lUooQxWpEiWnhLCpexSSSJJKHmSzu8+8M=;
        b=G4FOrIxLDcG5g/+ifJR9ROmuXQJONFOHzIBWfTY35HN0yTuk7MvZ4qG3pdj4DNV0u0
         yJfA2lf6ZHszRpRbso9KBQJTXLvZP+/0OQMs96FS+m3VxmJYkfot38uj1ivQ/ArVm2RH
         1n2RQtOukGROnwFuFXjwjCwI6HRVp6EC0cNgBiVxClFUtZjkn4nXcASllwjMYSxTYQy9
         b7bchuTVYZl3VTtXi6CVCiLwClz+8oBKK8dsbCfBh1NshTbF2ORlzSpiXG54GFUGGdXm
         ADqEV9tizDnvQnexwfC1ey/65YWuFrujz3sJAUYpjau38P2CS6VaCY031jxaY6+kAIBp
         pExw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BUclrFJvY/lUooQxWpEiWnhLCpexSSSJJKHmSzu8+8M=;
        b=Ai9q98Vaq0ZWj75Zdpd6eHVdlnR1m/Jd+NXeTvslNSPn2q+SigGyPSbZXvaFa3E2Oc
         fp3bE993jAkmr1vQWAnffbCqz6PXkdHK5qCs36ApmX+851tryStCQbY2+ZYbfJ2Wrwd/
         IJX7N1kzprV8IoWskQfEYAxgMgeAG+5i2oervLVCAQp+c/RIOwJs+ZWgSsjB9guoBFCm
         iZHQZp7qmQVsd7U/cXOQ/K0KJ0nOOgVhmgdUrkHE76E49v8ctmeu/5Y3huD8ygnmgGHh
         4pdFuC9K1QfvoFWvwQCOO7QC5NW/Qu+KBkDHYxB1tP3Aq/vCmyZfkF/g2AaiuixA5QP3
         LQLQ==
X-Gm-Message-State: AOAM5302Fi3JtwTr/WqFm8BqOFv+DP7Z9xCOpfDYxGq3Uiw5zwscqfTd
        8lytsGiXv5MGIWV1uRGdj6E=
X-Google-Smtp-Source: ABdhPJxgwUPA8roxtM+Qu96hbrOA/Ov9ydrK4flHLMGbbfFsibcwZtiWGZ+O4Q8Uk23sLKL1lCVmiQ==
X-Received: by 2002:a05:6402:50c7:: with SMTP id h7mr2617464edb.277.1637183118833;
        Wed, 17 Nov 2021 13:05:18 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id di4sm467070ejc.11.2021.11.17.13.05.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 13:05:18 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [net-next PATCH 03/19] net: dsa: qca8k: skip sgmii delay on double cpu conf
Date:   Wed, 17 Nov 2021 22:04:35 +0100
Message-Id: <20211117210451.26415-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211117210451.26415-1-ansuelsmth@gmail.com>
References: <20211117210451.26415-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With a dual cpu configuration rgmii+sgmii, skip configuring sgmii delay
as it does cause no traffic. Configure only rgmii delay in this
specific configuration.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 12 ++++++++++--
 drivers/net/dsa/qca8k.h |  1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index bfffc1fb7016..ace465c878f8 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1041,8 +1041,13 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
 			if (mode == PHY_INTERFACE_MODE_RGMII ||
 			    mode == PHY_INTERFACE_MODE_RGMII_ID ||
 			    mode == PHY_INTERFACE_MODE_RGMII_TXID ||
-			    mode == PHY_INTERFACE_MODE_RGMII_RXID)
+			    mode == PHY_INTERFACE_MODE_RGMII_RXID) {
+				if (priv->ports_config.rgmii_tx_delay[cpu_port_index] ||
+				    priv->ports_config.rgmii_rx_delay[cpu_port_index])
+					priv->ports_config.skip_sgmii_delay = true;
+
 				break;
+			}
 
 			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
 				priv->ports_config.sgmii_tx_clk_falling_edge = true;
@@ -1457,8 +1462,11 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 
 		/* From original code is reported port instability as SGMII also
 		 * require delay set. Apply advised values here or take them from DT.
+		 * In dual CPU configuration, apply only delay to rgmii as applying
+		 * it also to the SGMII line cause no traffic to the entire switch.
 		 */
-		if (state->interface == PHY_INTERFACE_MODE_SGMII)
+		if (state->interface == PHY_INTERFACE_MODE_SGMII &&
+		    !priv->ports_config.skip_sgmii_delay)
 			qca8k_mac_config_setup_internal_delay(priv, cpu_port_index, reg);
 
 		break;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 128b8cf85e08..57c4c0d93558 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -275,6 +275,7 @@ struct qca8k_ports_config {
 	bool sgmii_rx_clk_falling_edge;
 	bool sgmii_tx_clk_falling_edge;
 	bool sgmii_enable_pll;
+	bool skip_sgmii_delay;
 	u8 rgmii_rx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 	u8 rgmii_tx_delay[QCA8K_NUM_CPU_PORTS]; /* 0: CPU port0, 1: CPU port6 */
 };
-- 
2.32.0

