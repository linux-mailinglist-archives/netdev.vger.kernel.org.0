Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B65427E62
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 03:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbhJJB7H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 21:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbhJJB6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 21:58:16 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74913C061764;
        Sat,  9 Oct 2021 18:56:18 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id t16so30046433eds.9;
        Sat, 09 Oct 2021 18:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V2yujiD8OZbIWoNtB8E5DbI83vp4Xmu0HE/5ATJK4Yg=;
        b=fICozNcIJuD63BKeQ7wI80kjtg20ndSwhhKrZcmSLn70QeLM79GWDOpydclLUbf23j
         d4/BGCUvFyKDm8qNMmOBzt6aw5OgMkxOkcS9d2IvV3kFiijB0OXDydfTIKz1ng9hC3Kv
         2aNfv4Fmix1i4PfgQrKeibQ61MaB1iq1N0I+rhGv5sVjkdZOohEX1fes+9KRpLef/sIM
         OTro52Gab2/KrrQVIpb5AfePKHMQgQZ5/5BlKQoh9TtcLOM5YLoTfSdIeJJ8StzD0stz
         CLoMKvsvXmSdqkWw3pYzU1RVLIQ4046kiIkL72nICz3/li1KfzeWDkpyb+NRPBn2Br+n
         gSKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V2yujiD8OZbIWoNtB8E5DbI83vp4Xmu0HE/5ATJK4Yg=;
        b=kQDWGdXlqzPVkmFxLLncC8XAfQfXGlNqrjy1ixBPKnr0UJLtudHW9bXY+GP9l1JaLn
         LivRg1EvCib64DycldgIcrDBueFj27To5CR8Cw1bsvW8/AvbGKiGRLgW/AOQ86cAoXJ6
         HeJngmFya0PPuX4e66BY8PGsqEf128+Rg1B1xrssQRs1ww38yn4p4N1JSGQ9lmOwd4Qr
         XKiUKo8zsjzPpXUgeXnwTGsj7SMcp4qK96PbNYQVmIoGgMnpTLp4T0mnzWe7t5Ka9c76
         Ux7TWLePE9Gm70zhDPS0Z0k5eqDiNUt35s8Fusvt1o0s9prQ+phnuV8gVr9yejH2Eo8g
         2I5Q==
X-Gm-Message-State: AOAM530CoRhIFmHl4V/b1pq7BpXOQyswkcTY74LjR4nSErwHedgEl3xJ
        45MV2vvW9d82GphAScKE5/E=
X-Google-Smtp-Source: ABdhPJwA1D+7uxS7FtIuaJRIEMY1mvb3PoUI1iU9q7G1h7DCd21I6i5LnhdgbnJLpm+uEy8++BCbGw==
X-Received: by 2002:a17:906:5d5:: with SMTP id t21mr15928007ejt.160.1633830976957;
        Sat, 09 Oct 2021 18:56:16 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id x11sm1877253edj.62.2021.10.09.18.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Oct 2021 18:56:16 -0700 (PDT)
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
Subject: [net-next PATCH v3 07/13] net: dsa: qca8k: add explicit SGMII PLL enable
Date:   Sun, 10 Oct 2021 03:55:57 +0200
Message-Id: <20211010015603.24483-8-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211010015603.24483-1-ansuelsmth@gmail.com>
References: <20211010015603.24483-1-ansuelsmth@gmail.com>
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
index 043980a5db7f..b73b92ebd72e 100644
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

