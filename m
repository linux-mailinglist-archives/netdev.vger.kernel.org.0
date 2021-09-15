Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8224040CB76
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 19:10:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhIORLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 13:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230439AbhIORLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 13:11:15 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A02EC061575
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id f8-20020a2585480000b02905937897e3daso4584404ybn.2
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 10:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0UkhiVR6DjX0Qd/nDHxWlOx6CU+wUejBFeHGRDPmxic=;
        b=rwiUknLhsfckyVtc9MYWfpdl3zUMcj5whM/wqIUzOr7o2qJxIqRU8JtfI8kmsp9RPC
         cDeUTCK6JiV3Lckp6PP2yElQNCgj9MAHv6Y060ht0erC5m5TM6cFAFlEGsIQTxpunqkJ
         TTmdqVt2BxbTrwpXoz2MK7WckyV25BgIsa/cOe8MbdW0TwswELSHN4loB6VRm1E3MoFH
         mv3X8AEDVvRNbr72GDMRLCGqivh2AfHr1AW2HFbuX7q88dvrmYlkdY6cCkbIIj/yfAj0
         hRcDxevpYLN7SZ2ZsnVkE/qqQxQHCA/kXgRMDSoALiQci0e/P+iYgF8tV9TLT/684NE1
         irrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0UkhiVR6DjX0Qd/nDHxWlOx6CU+wUejBFeHGRDPmxic=;
        b=D59JzrD9/Q3D14nUO+Io05PQtu7RxCPJfQNfDbJamEkh8iyyaTCxPrCYCVEdWPJa5O
         TFori5QDv9eSdGEYY4/WFUlnmumZKGRAmyi+mk+Br5Q5KyhfhgWjghQaybh/r0siP9WT
         kTu73ioWfR9jdNktqRgTKFbyk5RJP0JzvwmVcqk1RARCOp5d8p9lOmAzCYIwCtO2NA/d
         EhoEzFYKSXIz60c491YlW5iPjoZLTif7Qe+jlLcUrUf9qd+6VG338xgcpaNwvaWGghUY
         rPT41PEMDcLdUoRzup94f5QVPOTs8JWxq9lXH7NdrxjSzRiUcggQFMcYuytlWnOCuEkZ
         lp5g==
X-Gm-Message-State: AOAM5313NVpbhI3tX0rmEw5LHHQjgItuGG13ph53jwAPFrrJvhLrBho1
        KkaioE7lEnwOBhMaWU0xxR2AjSo3ADrOpEg=
X-Google-Smtp-Source: ABdhPJyvpC6BA5zyb82hUXBtYjxlMLYkjX2NtqbM8ENYqEoZl85lNNkglEar4E0dEbS7Amv0OoYKpo2c4nNcc14=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a25:d387:: with SMTP id
 e129mr1258115ybf.239.1631725795385; Wed, 15 Sep 2021 10:09:55 -0700 (PDT)
Date:   Wed, 15 Sep 2021 10:09:39 -0700
In-Reply-To: <20210915170940.617415-1-saravanak@google.com>
Message-Id: <20210915170940.617415-4-saravanak@google.com>
Mime-Version: 1.0
References: <20210915170940.617415-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v3 3/3] net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
 for mdiobus parents
From:   Saravana Kannan <saravanak@google.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Saravana Kannan <saravanak@google.com>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Oltean <olteanv@gmail.com>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are many instances of PHYs that depend on a switch to supply a
resource (Eg: interrupts). Switches also expects the PHYs to be probed
by their specific drivers as soon as they are added. If that doesn't
happen, then the switch would force the use of generic PHY drivers for
the PHY even if the PHY might have specific driver available.

fw_devlink=on by design can cause delayed probes of PHY. To avoid, this
we need to set the FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD for the switch's
fwnode before the PHYs are added. The most generic way to do this is to
set this flag for the parent of MDIO busses which is typically the
switch.

For more context:
https://lore.kernel.org/lkml/YTll0i6Rz3WAAYzs@lunn.ch/#t

Fixes: ea718c699055 ("Revert "Revert "driver core: Set fw_devlink=on by default""")
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Saravana Kannan <saravanak@google.com>
---
 drivers/net/phy/mdio_bus.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 53f034fc2ef7..ee8313a4ac71 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -525,6 +525,10 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
 	    NULL == bus->read || NULL == bus->write)
 		return -EINVAL;
 
+	if (bus->parent && bus->parent->of_node)
+		bus->parent->of_node->fwnode.flags |=
+					FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD;
+
 	BUG_ON(bus->state != MDIOBUS_ALLOCATED &&
 	       bus->state != MDIOBUS_UNREGISTERED);
 
-- 
2.33.0.309.g3052b89438-goog

