Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33DCC64D
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 01:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731604AbfJDXOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 19:14:05 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:41324 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbfJDXOE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 19:14:04 -0400
Received: by mail-pf1-f196.google.com with SMTP id q7so4773406pfh.8;
        Fri, 04 Oct 2019 16:14:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lISiiaIRIYcWBibBe1iOZ/5qzUoajo4AJ6kmzzJGjtM=;
        b=NfB/9dhy9h2aOSJ8PnppKjzSkOOgwvS2D6bnO1+bR7jvlX3Mp/ZbBb3Sep0gy682So
         TYgpwjm9l3JjiOuxWwt/MMfqtDEgEtPo2wO8IUs7ltlTOU8lsy8t9m3ObbKUm1BuY2Rh
         QbKDwzKPQ7Vco+kt5zwVD3JTts2khhj0zJk1dQhJpcJWqD8zmiBFzLjXKF/rXV1oOPfA
         3MWNAl2U5m/jJA7dhPCb4q+wpg/rbhOrs4qTHwn7DnbIktKaZlfFGsVCZXq5W3WKK1Q7
         Z7jqzBt391pGfmxDEpl1LHeP26ckLtfFNRzrczoethPCzBWf9OM+fbgkvZ+HNXOEPRFa
         wPMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lISiiaIRIYcWBibBe1iOZ/5qzUoajo4AJ6kmzzJGjtM=;
        b=P7/CiOBmf7w1KomdyxlyDPZJP2SSsvsipPhq7CYHhDtLKaCYzZx+/x7BbTlxFKCMsS
         SsgLxL0JVAi9X+ig6B5gZyj+Kt7ev3g96jJKKf9s/3Tkxzn6R0+kBG8NzuwZbeYaA/+G
         cPlqyRpD7CBZ4elHMH4Z5ubA00jMGHrHCAuyM9o3bVFJyiJ/hQr3HmyvOTOpy1YGuCx1
         dvUWY/3l3jWGF0Wj+fkUDL3iEj0TMAT3NrAFd41nSor+UDthQtaBrYsNW/9pgo1AGqxZ
         +SiMOynhdq1V3OXzNTb3gjYJb+5cMPtvE/VY/UpLtc8pH8mjfbJ49EJgbDY3KtFI1mNv
         G5zQ==
X-Gm-Message-State: APjAAAWGCVicGFR698MKGwY8Srq3YcVd9MPmZRH+3Wr2+nHWa6ck5om+
        qYeZTFip+JmvOPq4omzXIns=
X-Google-Smtp-Source: APXvYqwxv6Gmfx1v5s4xL2Ayn/oB8k7vRfxLHY+NJRMEHLsw1FiFBsrHZdupVqlfzLRQJSlDN+RIMQ==
X-Received: by 2002:a63:fc55:: with SMTP id r21mr17412509pgk.432.1570230842435;
        Fri, 04 Oct 2019 16:14:02 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id y6sm9514353pfp.82.2019.10.04.16.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 16:14:01 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH 3/3] net: phy: fixed_phy: switch to using fwnode_gpiod_get_index
Date:   Fri,  4 Oct 2019 16:13:56 -0700
Message-Id: <20191004231356.135996-4-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.581.g78d2f28ef7-goog
In-Reply-To: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
References: <20191004231356.135996-1-dmitry.torokhov@gmail.com>
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

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

---

 drivers/net/phy/fixed_phy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 4190f9ed5313..73a72ff0fb16 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -210,8 +210,8 @@ static struct gpio_desc *fixed_phy_get_gpiod(struct device_node *np)
 	 * Linux device associated with it, we simply have obtain
 	 * the GPIO descriptor from the device tree like this.
 	 */
-	gpiod = gpiod_get_from_of_node(fixed_link_node, "link-gpios", 0,
-				       GPIOD_IN, "mdio");
+	gpiod = fwnode_gpiod_get_index(of_fwnode_handle(fixed_link_node),
+				       "link-gpios", 0, GPIOD_IN, "mdio");
 	if (IS_ERR(gpiod) && PTR_ERR(gpiod) != -EPROBE_DEFER) {
 		if (PTR_ERR(gpiod) != -ENOENT)
 			pr_err("error getting GPIO for fixed link %pOF, proceed without\n",
-- 
2.23.0.581.g78d2f28ef7-goog

