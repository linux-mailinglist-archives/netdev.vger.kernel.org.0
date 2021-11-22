Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536C9459147
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 16:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239939AbhKVP1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 10:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239915AbhKVP1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 10:27:31 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F7EC061714;
        Mon, 22 Nov 2021 07:24:24 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id t5so78951458edd.0;
        Mon, 22 Nov 2021 07:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XfoP7pt9X22IbrYPLObk4gn6jQom0hyYQ6nYRPQ8Vfw=;
        b=OwxHN2tVdFxUQrQWYqcTNpMqRN0IPciwsqcJLQI27TJwkgO9LP7vSRaU03OXGD8e35
         2MDwx8FwbjjMUCOXbFhAaK8qaBydwjjRp5y76JdFjqFu3rtZAZ7E537XCgp09H/FROcq
         Oz1hsIl2pUVQLdkQz6Pz7glKnRS7IEo1L/ThNMxnT8rjdXZyKgRMl2DKo4N19UZblHDS
         wVDyVWDNBMfPTn8y39oRawMWv4OrmngjTjjDuwphg0vwLsDvsashwURwqugJkega4QoR
         QGcjOMo88AKk0EV+3XXLblVueHH2zAPHI+owrSi5XgBlcVx2YQbBFRpD5yBcLx0SiILn
         i0Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XfoP7pt9X22IbrYPLObk4gn6jQom0hyYQ6nYRPQ8Vfw=;
        b=FqOixpHPVBegYMW6+hwAlyBvOlHCsCfArNotFl5yRygJHF+ICE4phMsqnke9Fx0fqq
         lK7LGDeEVYWAFV0rrF5BoCJFaoho3AAzIWbr2rWCuuCJWnuN3IONDxn1h6ktRFmHSdpM
         kOo3XEguCoKdNYm1l4ggHAZLP48AXnzQIFVaeG6T+wjfW8UHFugevL65Z/rsbSRP/1cu
         9LhnVp7g2ve9IVVxixNh1ZQpXXg26r3FWgCQGoj192hTt6B9gu7TUHbbLf0eNG/WB6mL
         u2VCAy/SX46ACi0b1pQ67/XotqkF3EOY5LrkWGLy9bshVWAxGU2qrOOtIOH5RBrP/NkV
         d/kQ==
X-Gm-Message-State: AOAM533MUf97pgiWYphDeSRNz4VWAjXaNAS2w5ErAnKPbFVQ+9YZJmN3
        gaosubiJHC5s9Kss5a/VbNw=
X-Google-Smtp-Source: ABdhPJyuLT5j4vm/lYUkyQPRba5b9/1rnotlumZqI4/r8exAPuCmUAE1Qewesvk6U4Ymux2TvsnyfQ==
X-Received: by 2002:a17:907:16a1:: with SMTP id hc33mr40914168ejc.486.1637594658077;
        Mon, 22 Nov 2021 07:24:18 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id sb19sm3995307ejc.120.2021.11.22.07.24.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 07:24:17 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v3 4/9] net: dsa: qca8k: move regmap init in probe and set it mandatory
Date:   Mon, 22 Nov 2021 16:23:43 +0100
Message-Id: <20211122152348.6634-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122152348.6634-1-ansuelsmth@gmail.com>
References: <20211122152348.6634-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for regmap conversion, move regmap init in the probe
function and make it mandatory as any read/write/rmw operation will be
converted to regmap API.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index ae02043a5207..f63a43291636 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1086,12 +1086,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	/* Start by setting up the register mapping */
-	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
-					&qca8k_regmap_config);
-	if (IS_ERR(priv->regmap))
-		dev_warn(priv->dev, "regmap initialization failed");
-
 	ret = qca8k_setup_mdio_bus(priv);
 	if (ret)
 		return ret;
@@ -2073,6 +2067,14 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
 		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 	}
 
+	/* Start by setting up the register mapping */
+	priv->regmap = devm_regmap_init(&mdiodev->dev, NULL, priv,
+					&qca8k_regmap_config);
+	if (IS_ERR(priv->regmap)) {
+		dev_err(priv->dev, "regmap initialization failed");
+		return PTR_ERR(priv->regmap);
+	}
+
 	/* Check the detected switch id */
 	ret = qca8k_read_switch_id(priv);
 	if (ret)
-- 
2.32.0

