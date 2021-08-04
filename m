Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA08B3E0A19
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233816AbhHDVoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbhHDVn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 17:43:59 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B03E5C06179A
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 14:43:46 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id 18-20020a05620a0792b02903b8e915ccceso2874923qka.18
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 14:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Rynpga3J+xjZzUqZXpOXfkfOoHAVyRGf/PRkioLCwmY=;
        b=B8/MlBGQclT50fb7n0ieBcTHQoZD+gRQ/u345in6OYabDUyr30L+tBW1j2xiCfNLr7
         a1C8CtX5vMQRm7x1CDvBkHnR7zdve2JnoVx+Z7xbdcxfV8yk3pWdXvh+j8UYSWjpIiG6
         rQTgFQZx6M0HcZUL+vGBw04INfBrgmBHJ2l9jkRxNUionVIyWBvYuy2oGjIubI+Tp0Yo
         XGhjEY7KB+c3EYjb5InTMJ/2ppIb+GcWeznUvm2v3ZPxxskJbztyZsN3GfzDLyk9Mh31
         WWLv+LGc6qcqeKBXZiBeJ7l+m+i/DGhYActbYEasEVcdsi3dwW04HAEC2deDco3mysZ3
         YMOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Rynpga3J+xjZzUqZXpOXfkfOoHAVyRGf/PRkioLCwmY=;
        b=YPW9fMM85CUFtBrkE86xPvMwMJ1XcqwG0X42DTiAxzsAcCVUL8irGcLpmYgG/kMcAz
         aTKPs5Bt56TbfuOiMJYcjX5fm/cxH1Jp2FXdK1rgLR4whdAARXgO0vN7p29SNK1FGJ7o
         W0G1Dw7mRdAeC9UurDiVZApLYFUYnFlpFBukQIB5AIXKaPK+Zicd4stPmY4EAlwwbmKp
         hH1yTjmTNvo28/ctYcKSWMfeegjaWd+/E6b7SdRbxa/0zL2EF65WDrFLuDqpTSTSmP4O
         x6r44fdpulhHSrRFO1Jhe4oytoj/MRRvl3i2HBt3K5cTBCkMNtR9wBTuTXPtIKyYqV5l
         Nh7w==
X-Gm-Message-State: AOAM533hTJQsJoyEQWRtyR01cpbEdAZmEnTM3k473z+wEiQ5TJiC8MgC
        48FdBWQjW6PoRgHZCZM2zELiK4LQFB7wT0E=
X-Google-Smtp-Source: ABdhPJzlOYEDH8yob9gAEtyiJ+2bW8yWLnsn+Oa2Ym13tfciy/2gVuwXNkqzQileftC8X7uEAeOaOlgtP57eeUw=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ffe5:1245:526e:3189])
 (user=saravanak job=sendgmr) by 2002:ad4:40cb:: with SMTP id
 x11mr1616861qvp.60.1628113425608; Wed, 04 Aug 2021 14:43:45 -0700 (PDT)
Date:   Wed,  4 Aug 2021 14:43:32 -0700
In-Reply-To: <20210804214333.927985-1-saravanak@google.com>
Message-Id: <20210804214333.927985-4-saravanak@google.com>
Mime-Version: 1.0
References: <20210804214333.927985-1-saravanak@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v1 3/3] net: mdio-mux: Handle -EPROBE_DEFER correctly
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Saravana Kannan <saravanak@google.com>,
        Marc Zyngier <maz@kernel.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>, kernel-team@android.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When registering mdiobus children, if we get an -EPROBE_DEFER, we shouldn't
ignore it and continue registering the rest of the mdiobus children. This
would permanently prevent the deferring child mdiobus from working instead
of reattempting it in the future. So, if a child mdiobus needs to be
reattempted in the future, defer the entire mdio-mux initialization.

This fixes the issue where PHYs sitting under the mdio-mux aren't
initialized correctly if the PHY's interrupt controller is not yet ready
when the mdio-mux is being probed. Additional context in the link below.

Link: https://lore.kernel.org/lkml/CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com/#t
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/net/mdio/mdio-mux.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 13035e2685c4..ebd001f0eece 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -175,11 +175,15 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus->write = mdio_mux_write;
 		r = of_mdiobus_register(cb->mii_bus, child_bus_node);
 		if (r) {
+			mdiobus_free(cb->mii_bus);
+			if (r == -EPROBE_DEFER) {
+				ret_val = r;
+				goto err_loop;
+			}
+			devm_kfree(dev, cb);
 			dev_err(dev,
 				"Error: Failed to register MDIO bus for child %pOF\n",
 				child_bus_node);
-			mdiobus_free(cb->mii_bus);
-			devm_kfree(dev, cb);
 		} else {
 			cb->next = pb->children;
 			pb->children = cb;
-- 
2.32.0.554.ge1b32706d8-goog

