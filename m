Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 041BDAF741
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726911AbfIKHw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:52:28 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:38595 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbfIKHw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:52:26 -0400
Received: by mail-pf1-f196.google.com with SMTP id h195so13156976pfe.5;
        Wed, 11 Sep 2019 00:52:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h88MG2l81eiTdjzgkHJX15BXFcOh2ckomfV8YTYTFjU=;
        b=kMBQ3dMrsESr7TwZqim8jjaa2hJp3u+maVECjThf5KhPmfb7HZ0562mIg/dkSgsVxB
         3zrz+6cT+bL8lNKexFDcv2CaCY0wdX3vkNNsRx0n4ZA5wy1kbIQA4fGgOB9LoYC2qePn
         7WAX7Bypv/lPCEDSe1GjQUDCz8hgB6NeWoK7+SUS6c9rC/QgmVqb6uVbTZ9ot0DNS8xB
         3K71OrksDrXb/BQLz72jnm8oD17ZgqzsD7lnxAl1rEBPMG4EwWyidqWv2IpquIsoDpUK
         gdc6qbMTi7Ea3Qx3M2opHAnaOBUYjZcnVwdj93ugzTXBHL3J9TBb3GyCzr9YdyNFI/2A
         TOTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h88MG2l81eiTdjzgkHJX15BXFcOh2ckomfV8YTYTFjU=;
        b=imN6+G68ryW8N/vCInbN/6PJQEpzSnZ7axeu46/Wzb4/cELt6P+iMX5WkfAO9nhl1C
         Qwn7ykTGLrOJ6BMiG8wF8XDuJ90hh6F5a9dfm7w0a6nPJsd1Wurk05tMxW8SYVahClnB
         mTl1JJ87jAvubd4O6P2CXKc/1nAhlfRzphcysJE1bygH5alcas5qTGnCONRyEuLtaWAy
         twM2hAvpA5Q/tfXWXJFnYXFpfsTQkQnUislEKRd35YgoxlCBnhbXc4FqPvpmE2TD0wT/
         X0vUYzdsblEKkBEw7ub44lEO3Mp3B7UkFqCiQ1R/RvLJ/SIc71jfjEOoNTicKzbyh4jo
         6ZVg==
X-Gm-Message-State: APjAAAV38PXueuqMZoGSCTff40aRfe5etwaP0w626qeU07ckNLB9xD0d
        YUj7RJs6HAg0p1jAXJUuvA0=
X-Google-Smtp-Source: APXvYqwONOjWAlEXKobnYjYWQs5FrHnxNtmzqbN8TPKlC8jUIXa+3WVHFQ4DniPtIjcy4gPeDdwkIg==
X-Received: by 2002:a17:90a:b63:: with SMTP id 90mr3979456pjq.96.1568188345092;
        Wed, 11 Sep 2019 00:52:25 -0700 (PDT)
Received: from dtor-ws.mtv.corp.google.com ([2620:15c:202:201:3adc:b08c:7acc:b325])
        by smtp.gmail.com with ESMTPSA id u2sm8582445pgp.66.2019.09.11.00.52.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 00:52:23 -0700 (PDT)
From:   Dmitry Torokhov <dmitry.torokhov@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Subject: [PATCH 04/11] net: phylink: switch to using fwnode_gpiod_get_index()
Date:   Wed, 11 Sep 2019 00:52:08 -0700
Message-Id: <20190911075215.78047-5-dmitry.torokhov@gmail.com>
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
In-Reply-To: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
References: <20190911075215.78047-1-dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of fwnode_get_named_gpiod() that I plan to hide away, let's use
the new fwnode_gpiod_get_index() that mimics gpiod_get_index(), bit
works with arbitrary firmware node.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---

 drivers/net/phy/phylink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a45c5de96ab1..14b608991445 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -168,8 +168,8 @@ static int phylink_parse_fixedlink(struct phylink *pl,
 			pl->link_config.pause |= MLO_PAUSE_ASYM;
 
 		if (ret == 0) {
-			desc = fwnode_get_named_gpiod(fixed_node, "link-gpios",
-						      0, GPIOD_IN, "?");
+			desc = fwnode_gpiod_get_index(fixed_node, "link", 0,
+						      GPIOD_IN, "?");
 
 			if (!IS_ERR(desc))
 				pl->link_gpio = desc;
-- 
2.23.0.162.g0b9fbb3734-goog

