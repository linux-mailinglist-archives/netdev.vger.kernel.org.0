Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7EF45879B
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 02:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhKVBHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Nov 2021 20:07:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232259AbhKVBHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Nov 2021 20:07:09 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8618C061714;
        Sun, 21 Nov 2021 17:04:03 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id r11so69415436edd.9;
        Sun, 21 Nov 2021 17:04:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z7GXdDyp0cHFR+WFU90zjT8tLM+Bk4o/PJjBns/5RwI=;
        b=gLsAilmq1mdDCkORp2EogyPfeQhmlghCe3jVMksQ4fXqch1UNrK/an6sJS4xctxwvM
         fXDeiVYI2cPxTBMgQ8kWfVW33UTrweLIRCnBlmpf+F1TOnMsCRdiT9JYAoHCHTXEoPJW
         xV91nO8nYA4Ugff58hx5LnFC6+zAZTOjzfh2xeC0HL7Xpc2dShfCwlik6kVgCfBcZ9JO
         bWVtPJ9HzNUjFIXmHB7mgcU06rDPqmAsirYLxA4EXFhTrzafav6LjHhJ3lVc1EwFGG0f
         W0HShbJuXrHy7XfrRs9mbCU1KC6o6TcInOiKumM2h1LWYFq/AXjcRxoP6as1UCBxL1R6
         pq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z7GXdDyp0cHFR+WFU90zjT8tLM+Bk4o/PJjBns/5RwI=;
        b=nl43VVGCb/FF9oX8FNsDZvPcfzIZRr85Ag3vCyMCSChJx7mLEz+YMfZ0oykWnTzO7K
         2mkEBw148Urzd8rcdwkm2kkptcl0//1aty+CpczOSs+aRq+tK46wZ8rVyh9mWMuQXn7F
         SCj8gLErShUk9WK5OH+84xJjEYgnX/nKuSWv8Du8SeESo70VpEYX8bp4VuGDrXtxXX1G
         RUthqdAqODezVhFdiF6lSws6qMPUsw2r2N5Z8oOS/WkwNEOpDVdeeLaTfQVooO0b2rmy
         BFhwVfwkaGoC3hsIXrQutzn4tOBOZDii7JTb4Rn5tA4/DisZypXPu5EUVT/hbfY3orXf
         O4sw==
X-Gm-Message-State: AOAM533h+9aH4vW7vnKci0pYXIUVdnpUQkov75glV7PU9cVtF24Gbi5f
        Kro3IkEEBdyUJ/k0BmSdL90=
X-Google-Smtp-Source: ABdhPJyqWm1DSmzjKuUinMbpXJEl1FnlYIUurl4SO1xdJIjTUWH+zaJUElTCKQiQutLzpf6/JSTwGg==
X-Received: by 2002:a05:6402:5158:: with SMTP id n24mr57029430edd.230.1637543041809;
        Sun, 21 Nov 2021 17:04:01 -0800 (PST)
Received: from localhost.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id c8sm3208684edu.60.2021.11.21.17.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 17:04:01 -0800 (PST)
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
Subject: [net-next PATCH v2 3/9] net: dsa: qca8k: remove extra mutex_init in qca8k_setup
Date:   Mon, 22 Nov 2021 02:03:07 +0100
Message-Id: <20211122010313.24944-4-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122010313.24944-1-ansuelsmth@gmail.com>
References: <20211122010313.24944-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mutex is already init in sw_probe. Remove the extra init in qca8k_setup.

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 drivers/net/dsa/qca8k.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
index 6783a3c2620f..321d11dfcc2c 100644
--- a/drivers/net/dsa/qca8k.c
+++ b/drivers/net/dsa/qca8k.c
@@ -1086,8 +1086,6 @@ qca8k_setup(struct dsa_switch *ds)
 	if (ret)
 		return ret;
 
-	mutex_init(&priv->reg_mutex);
-
 	/* Start by setting up the register mapping */
 	priv->regmap = devm_regmap_init(ds->dev, NULL, priv,
 					&qca8k_regmap_config);
-- 
2.32.0

