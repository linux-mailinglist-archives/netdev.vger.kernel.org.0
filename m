Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60B3D3EF8C7
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 05:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237528AbhHRDi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 23:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236340AbhHRDiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 23:38:50 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75CB3C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:38:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id e75-20020a25374e000000b00597165a06d2so1466949yba.6
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 20:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=BEMUdr8X5Q4aL9TA7J3U2xLBZtVMZHuyJZqksg9L6+U=;
        b=r2ib7ss7DFluFVBCuF5BLjvbhbDWTq5l01Sq9U6fA1uYR58uS2GdlH2s1USJ0itLLy
         LhtOVKy1r0bSe17mRG2AaJAzPB791fm9h6RjVsAsk1js9r3FoNJdGDd8e57gQ6sEmJmt
         zuurs+QgmXUfg6mOh2VgEW7AyFTdsM5flBkvCDoFdMH1Jf0PGzzIBLmzMPAfUr85X8LY
         yVPRCD7kU/owvuh4W/8l47WHSqkQVmTmty+YifgSE73AKuAteEgwL3alhVhX53pHYneA
         N1NldWWx9K7B4h8k/n9aAW5TUXONi1KtK40+aZaYgIZeq3JjY7IZFyTVucChKUCpaCUI
         eSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BEMUdr8X5Q4aL9TA7J3U2xLBZtVMZHuyJZqksg9L6+U=;
        b=YOCRSbu4/NC8JA5u/DLfZfA9LSG1xyuzLB/5kDA/xLLF//UM/znM4O7cCR6kocdMO7
         WY3fjfXdhXYViKhI+cSMkkYeEhK6SvsnSqNS4ePnrNXYmZ7nDUt8Jmk/JoZPQzo4JLr/
         lBiizLf5JHIy4n++jmqEWMBLkgOnojVnYblD5MO7JjLb2JgR6/B5Dt1hwTxbDwvRe66y
         eSPqAXAcNO2V1U7ILDgnuvjJK43HnRBMJSui7wvVQMoGkT1/UQva4Y1OrvZuxtR62+3D
         Szor7V+67aTtXRygxPzd/t9f2N9weftFdxVOGtVAx3hulrEgbHAICF2gG+AhowUNvYmJ
         WFEA==
X-Gm-Message-State: AOAM533bFqzysiv9EB3qW3vxfz2pqxDzEbHahkSqkvDZRH+Qq0bGdUGw
        v8urxLj3suCZL1Ghlwk69S40ne8WihKUtYg=
X-Google-Smtp-Source: ABdhPJy5LvWk3456EERDnC1tvN03sDdUbOu+LZxfyycl1yfSMIZ6x9KrYprNC1/bZPlkGy9r+vXkKJR0ze2Tbbg=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7750:a56d:5272:72cb])
 (user=saravanak job=sendgmr) by 2002:a25:8445:: with SMTP id
 r5mr9205574ybm.20.1629257895746; Tue, 17 Aug 2021 20:38:15 -0700 (PDT)
Date:   Tue, 17 Aug 2021 20:38:03 -0700
In-Reply-To: <20210818033804.3281057-1-saravanak@google.com>
Message-Id: <20210818033804.3281057-4-saravanak@google.com>
Mime-Version: 1.0
References: <20210818033804.3281057-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net v3 3/3] net: mdio-mux: Handle -EPROBE_DEFER correctly
From:   Saravana Kannan <saravanak@google.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Mason <jon.mason@broadcom.com>,
        David Daney <david.daney@cavium.com>
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

Fixes: 0ca2997d1452 ("netdev/of/phy: Add MDIO bus multiplexer support.")
Link: https://lore.kernel.org/lkml/CAGETcx95kHrv8wA-O+-JtfH7H9biJEGJtijuPVN0V5dUKUAB3A@mail.gmail.com/#t
Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
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
2.33.0.rc1.237.g0d66db33f3-goog

