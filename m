Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B88812F26E
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 02:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgACBDa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 20:03:30 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:41042 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727247AbgACBD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 20:03:27 -0500
Received: by mail-pl1-f195.google.com with SMTP id bd4so18456913plb.8;
        Thu, 02 Jan 2020 17:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8raNKHHqbrLxNNM2oLUriEG3Gl922A0KHZoXKNxlPCI=;
        b=TP7f+WuyusDO5KHLNPuGWx6H3bszUBiGq90mxk2AgHj678yUim/ZXQH463JzSP4xzo
         BXz0uu5779J3W5cTqrnT06J2jUNDYHy5d8rKpKqqa0aMnDjc0udgiDTQtHgB65QHh79D
         y0dJgsKCDWbD7i6rFR/a2eon5LTYhoTfFnkX8kvGUtN/JST9NN5UB5Y9nd0f+Dst+HTs
         DR996gTQuGpc5OrtSkt69CzyCSk5YBKDRzryroH1q3hpqJdvVTCfru7RXdTFyi8CItOa
         hl7SztjzKBMCsgy3vlDReKvg/im0CORRpXghS9K1UWDeH7NvQxJUZV8lgfHQ4OLAo6G4
         o6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8raNKHHqbrLxNNM2oLUriEG3Gl922A0KHZoXKNxlPCI=;
        b=uNgR9ebRCbKSXEYi17M4MzPmUNaZkfGBiA2py5/4vML0FY2TvregE12cpL6iWnRzjm
         1RPeMQBj5wC+NDUf8zkcMUIjQhHfZFEPZnGSWqoMYEbfVU2EnY5fcszCrIVcxjq7w4Hf
         /m5pcl3OhbBThUIktrxkoa8m+qlepFVKTfLT60+ZTbD26phMdvrxBDrJxtQb9iOhDHtm
         yU4JWI/EdNp2rpQHWcKSMRGSdXkavAsijd9Fd1zQ8PgGyDIJpmCayUY7krRpvaD9CgYL
         VewFk5XGr/2BUMv1Wpqvp99Tko4zVuiVn5y9pt/5O0d6WjE0RySHgw+L74laJKnTimfB
         xalw==
X-Gm-Message-State: APjAAAVH4cF8iKR622tzUVYlMEwCfuPVxuO5iA/Cg1lLyZeMYNiVnQFY
        wXljpYriqLxzC5C5Gg4Ii1E=
X-Google-Smtp-Source: APXvYqzJg+fdvX7+CUg9oCAaw20MjnnG5esX+Zoed2hNj2yclmwVSoPYOJhd0NjvkkqYV9bexx/wDg==
X-Received: by 2002:a17:902:7602:: with SMTP id k2mr6880556pll.34.1578013406356;
        Thu, 02 Jan 2020 17:03:26 -0800 (PST)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id 5sm12780784pjt.28.2020.01.02.17.03.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 17:03:25 -0800 (PST)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v3 3/3] net: phy: fixed_phy: switch to using fwnode_gpiod_get_index
Date:   Thu,  2 Jan 2020 17:03:20 -0800
Message-Id: <20200103010320.245675-4-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
In-Reply-To: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
References: <20200103010320.245675-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gpiod_get_from_of_node() is being retired in favor of
[devm_]fwnode_gpiod_get_index(), that behaves similar to
[devm_]gpiod_get_index(), but can work with arbitrary firmware node. It
will also be able to support secondary software nodes.

Let's switch this driver over.

Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 4190f9ed5313d..73a72ff0fb16b 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -210,8 +210,8 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 * Linux device associated with it, we simply have obtain
 	 * the GPIO descriptor from the device tree like this.
 	 */
-	gpiod = gpiod_get_from_of_node(fixed_link_node, "link-gpios", 0,
-				       GPIOD_IN, "mdio");
+	gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),
+				       "link", 0, GPIOD_IN, "mdio");
 	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
 			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
-- 
2.24.1.735.g03f4e72817-goog

