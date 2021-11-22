Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA21D45879D
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234672AbhKVBHO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbhKVBHK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:10 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41339C061574;
        Sun, 21 Nov 2021 17:04:04 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id x15so69481395edv.1;
        Sun, 21 Nov 2021 17:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NnHzUKTobSKsizwqtshKW8pqgUjD7pErehYdXBuzeRo=;
        b=e6xZ3Axcc9SxgjRNiTHBeyMnCnpaK0JMPCMshAqyFQncPHiNfs4e7AwneNlrIc6Eq6
         ohfk87cv0qcU+uXVgSE9frzUiPaQLiKWFGag/z0gWVfOJUZ95wZLJJWK+bUa80RrLUmV
         JmxEjcqa/PLhgJuIdE/KCNMJWNQUFic6iNIIXWzI3jf9NZDrC1yl3PcNR2xnO8zg5YXf
         PKFY0SA5q1f6yZ9ERFbUXWY3VmWT/ME4bumuKtjS6Xabewp7xHRo4B7YITs9TqfzSE1e
         DdeufGI4z0x4tgf4nI48mvryDcKXxWpKK6txmj4XO2NiqYqComrv09yMin19v66leHa9
         dHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NnHzUKTobSKsizwqtshKW8pqgUjD7pErehYdXBuzeRo=;
        b=vLhAVHxdsDZOgxHPlDhNxmxa0kR4gANQBo+ty+mALcj9YNeBoPgEvLOhCgK2fR82Gj
         aJ5LO2Peuy93/0Lj0KoNm9hI438EH/mc2ArxH33hi3wA/xLAo201p/FW5oZxA6BueL/r
         GmPAtTgemKhrdxuox1zWxJHfH8YGLNblubBKaVb0Sf3I+3eB9lnbKFP2MBkJuaT6voR1
         5Zw57/QQds7yB6DXywMBb2zN2kMnKHlVQjIn7D4WAVDcRp+2WOR2NEBfqZYK9HkPvV2D
         CXZaJNzSj1NE7kN/Jc80Q9zX+SipATFcM0HVuuTed/ez9spG2QphtD5UbQZh3sc5ZojZ
         jtlw==
X-Gm-Message-State: AOAM530eGr7oyA7YAw6Yl71IGGcTDQeh5yq1GYIHBEpxvlpO8iocr4ea
        c1AFu5Q9kymFvaccUQggBrA=
X-Google-Smtp-Source: ABdhPJyLKI+Xy+mk9ALLB1oNwd7737fvrsUjAYR4vLebK4MBwgBbP9OFaXmoAPvW2lh8q59Y7mDzjg==
X-Received: by 2002:a05:6402:5156:: with SMTP id n22mr59264136edd.222.1637543042743;
        Sun, 21 Nov 2021 17:04:02 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:02 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>
Subject: [net-next PATCH v2 4/9] net: dsa: qca8k: move regmap init in probe and set it mandatory
Date:   Mon, 22 Nov 2021 02:03:08 +0100
Message-Id: <20211122010313.24944-5-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for regmap conversion, move regmap init in the probe
function and make it mandatory as any read/write/rmw operation will be
converted to regmap API.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 321d11dfcc2c..52fca800e6f7 100644
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
@@ -2077,6 +2071,14 @@ qca8k_sw_probe(struct mdio_device *mdiodev)
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

