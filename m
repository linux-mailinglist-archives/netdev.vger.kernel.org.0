Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F3D368A92
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbhDWBsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240094AbhDWBsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:48:31 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048D8C061574;
        Thu, 22 Apr 2021 18:47:56 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id bx20so54579636edb.12;
        Thu, 22 Apr 2021 18:47:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=pvbtV9z9Nr84yi5HQm0Sl3OJ0RmRKTgXaB8Aibs1Fi8=;
        b=EfRbrmuBOsfwwNIQNwN5GJp3OecEYddJmdaOR6JSbMsoY6lBC76RhjCTvceB0TPBd2
         77S72/SYUO+z6E9y6A8iuGSV4h7Q27S0GqdEuhMp1KazW0IJpqyjiScuPSGO0SFRrSAz
         WnoTOh+LU0E5vUxZO59H1jFFN2CtOiIMRaiUMUZMLw0pucHTvFQc6y64awrM8uR9VXyC
         bR/dNgD0OPiU9usH0Yfk5ggv9J0E8twIM/Z/oV4dhKml8R43Z4UilpG2gQprQV0Ls0id
         /uVPlVqt+Oar8hY7GB+milL4VAr8MWSp8tjbxfSvaDpZh79aQvZi/cGsiKKdglcSskyl
         f1tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pvbtV9z9Nr84yi5HQm0Sl3OJ0RmRKTgXaB8Aibs1Fi8=;
        b=EUXRBRtv9uTqKjBc+Br08W77oJmjBSAmCDOZf6s8+Zfy2Q9y9r6BtC6sY5yQY6eaQN
         zTdy7Hof6aYBB0KnI2HqltLOICZct0VSi9im1M/oC6cZmEn2HwL/cuhv/yzcAMS78hkO
         A36Nb0Cg69wSlKZIEVkd9z8jN9cB648OdszlQWmQWANxtPe0LofRPyismBQOE1WZfgVj
         CHPXT8afef6xMd/5gj3E2ZDyxljaZUkbW4GvOD5dyI0MKTYS2Yqzrd5Xx+mlNjC0wH58
         J3MJkbs45hlv30QiU4AXqoc9UGJJ6SQqiHWNVJWhHTElV1RULuLrQa9hb5qAu937QcAH
         ZEnQ==
X-Gm-Message-State: AOAM5334cXKuHFxvYZWmf48OsJrlkXWuvBdwND10f9WIdN9oexwLAbK9
        UmXdUqxNgGOGua+zX6EM2Jw=
X-Google-Smtp-Source: ABdhPJxyUWMKaSFu4paSngAiB+5r6Rkz9pq5QLh3DwWoyDCpPTxn6OBbJPJGdeBTBeVqYp6gwZLQKw==
X-Received: by 2002:aa7:c78a:: with SMTP id n10mr1527723eds.239.1619142474723;
        Thu, 22 Apr 2021 18:47:54 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id t4sm3408635edd.6.2021.04.22.18.47.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 18:47:54 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 02/14] drivers: net: dsa: qca8k: tweak internal delay to oem spec
Date:   Fri, 23 Apr 2021 03:47:28 +0200
Message-Id: <20210423014741.11858-3-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210423014741.11858-1-ansuelsmth@gmail.com>
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The original code had the internal dalay set to 1 for tx and 2 for rx.
Apply the oem internal dalay to fix some switch communication error.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 6 ++++--
 drivers/net/dsa/qca8k.h | 9 ++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index a6d35b825c0e..b8bfc7acf6f4 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -849,8 +849,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
 		 */
 		qca8k_write(priv, reg,
 			    QCA8K_PORT_PAD_RGMII_EN |
-			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
-			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY(1) |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY(2) |
+			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
+			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		qca8k_write(priv, QCA8K_REG_PORT5_PAD_CTRL,
 			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);
 		break;
diff --git a/drivers/net/dsa/qca8k.h b/drivers/net/dsa/qca8k.h
index 7ca4b93e0bb5..e0b679133880 100644
--- a/drivers/net/dsa/qca8k.h
+++ b/drivers/net/dsa/qca8k.h
@@ -32,12 +32,11 @@
 #define QCA8K_REG_PORT5_PAD_CTRL			0x008
 #define QCA8K_REG_PORT6_PAD_CTRL			0x00c
 #define   QCA8K_PORT_PAD_RGMII_EN			BIT(26)
-#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		\
-						((0x8 + (x & 0x3)) << 22)
-#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		\
-						((0x10 + (x & 0x3)) << 20)
-#define   QCA8K_MAX_DELAY				3
+#define   QCA8K_PORT_PAD_RGMII_TX_DELAY(x)		((x) << 22)
+#define   QCA8K_PORT_PAD_RGMII_RX_DELAY(x)		((x) << 20)
+#define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
+#define   QCA8K_MAX_DELAY				3
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_SERDES_AEN_DIS			BIT(7)
-- 
2.30.2

