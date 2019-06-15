Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 520C246F6E
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 12:10:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfFOKJt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 06:09:49 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34389 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726657AbfFOKJq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 06:09:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so4993127wrl.1;
        Sat, 15 Jun 2019 03:09:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H+yWWY9tEBVeyv5Kuo7PN/KU7l8anqtZ9YKcn1BGMX8=;
        b=F2OUqJoOIhLqTWwNr+ox+F1uAsR57hiVV8JfO+cpLJ+ookCiS0zuXCRXK8gGWzl/+R
         PDY1O8QaYoiP3yvbTfWAmfJeS5rJWUdFAwG3W3e4t90qk9pz3aI1v+ccxNgXd0/UznZp
         QtGGlMmhaHXW/GHro/Opuc6TPNoz26ugUrr7wmtGlQ0F0t0IcySE7Eoam7Uv0i3FKZ9a
         z3JXpiFFPUqZ3tyoU8mwJLUv+vllWShP1R9CfI6jNEUvNc6RDfrBkjAstnbnHBw6k835
         nAFOrC7gkIquBYE4lDwWQrgkuZtRGC89LOBskczxEyGhm03WUBUEnYdM7mq9LXezgZce
         xgWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+yWWY9tEBVeyv5Kuo7PN/KU7l8anqtZ9YKcn1BGMX8=;
        b=I6si6RvuBO9gm/mumHNGkaMDdFHv+PTdr9T1AygoLc/3fe36X1fo6z2lgI9rS3IjXi
         Gf6D2a23QplvJsT55/SX569DnD6omE8eKDVwPta+gJh9QJ9/rohe2qWu8lnfYjQ2XZQ7
         MGXz6K87C7UBHFDIATNCOrCNIqzgxRLxh5SlzcvB8z4JCJp935Bt9V4jEoXVzOibl34Q
         cE1OSa6+etQ4UU5NGQMbYcaRX2Cn/5UZt8TpgNdAW+a5Q1pRC4sBOdprxViyqk54X2ut
         WYMMDNURGTUJaaVZefy32BOpbXARcyU/xVBCRk5zf4Kgo2avxJLKc9+3s1xVphwbn03v
         Ti5Q==
X-Gm-Message-State: APjAAAUEnpiBj/gsg10sa4Kb4KqdCRIw/INksvWavurDF7pY75yCo0mb
        LhavAvsD7IxCd32a8z6dDEOZ90l2JIk=
X-Google-Smtp-Source: APXvYqxLGsoHfLPnFj28nDTuYbhsnM6ZxMGBs0QlhKr1dIDBWN6DREupTQWYfM4lOTVfZ3WkVTuzGg==
X-Received: by 2002:adf:df10:: with SMTP id y16mr9612659wrl.302.1560593383691;
        Sat, 15 Jun 2019 03:09:43 -0700 (PDT)
Received: from blackbox.darklights.net (p200300F133C20E00A9A405DFDBBC0790.dip0.t-ipconnect.de. [2003:f1:33c2:e00:a9a4:5df:dbbc:790])
        by smtp.googlemail.com with ESMTPSA id f2sm9270513wrq.48.2019.06.15.03.09.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 15 Jun 2019 03:09:43 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net
Cc:     linus.walleij@linaro.org, andrew@lunn.ch,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net-next v1 2/5] net: stmmac: use device_property_read_u32_array to read the reset delays
Date:   Sat, 15 Jun 2019 12:09:29 +0200
Message-Id: <20190615100932.27101-3-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
References: <20190615100932.27101-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change stmmac_mdio_reset() to use device_property_read_u32_array()
instead of of_property_read_u32_array().

This is meant as a cleanup because we can drop the struct device_node
variable. Also it will make it easier to get rid of struct
stmmac_mdio_bus_data (or at least make it private) in the future because
non-OF platforms can now pass the reset delays as device properties.

No functional changes (neither for OF platforms nor for ones that are
not using OF, because the modified code is still contained in an "if
(priv->device->of_node)").

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
index 21bbe3ba3e8e..4614f1f2bffb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c
@@ -24,9 +24,9 @@
 #include <linux/io.h>
 #include <linux/iopoll.h>
 #include <linux/mii.h>
-#include <linux/of.h>
 #include <linux/of_mdio.h>
 #include <linux/phy.h>
+#include <linux/property.h>
 #include <linux/slab.h>
 
 #include "dwxgmac2.h"
@@ -254,16 +254,15 @@ int stmmac_mdio_reset(struct mii_bus *bus)
 		struct gpio_desc *reset_gpio;
 
 		if (data->reset_gpio < 0) {
-			struct device_node *np = priv->device->of_node;
-
 			reset_gpio = devm_gpiod_get_optional(priv->device,
 							     "snps,reset",
 							     GPIOD_OUT_LOW);
 			if (IS_ERR(reset_gpio))
 				return PTR_ERR(reset_gpio);
 
-			of_property_read_u32_array(np,
-				"snps,reset-delays-us", data->delays, 3);
+			device_property_read_u32_array(priv->device,
+						       "snps,reset-delays-us",
+						       data->delays, 3);
 		} else {
 			reset_gpio = gpio_to_desc(data->reset_gpio);
 
-- 
2.22.0

