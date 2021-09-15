Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6127040C175
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 10:12:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237322AbhIOINt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 04:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237065AbhIOINV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 04:13:21 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754E8C0613E0
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 01:12:00 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id y185-20020a3764c20000b02903d2c78226ceso2590485qkb.6
        for <netdev@vger.kernel.org>; Wed, 15 Sep 2021 01:12:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=RwmF1eG4qjehbM/6vPHudaKlp5QMZAj0EjDeZYR+hmQ=;
        b=lisrCW1FhYgFf8tDVaJoILHzDIzWOAS5LqcKP0JGtTYPEKmraA3n3o4QQJNAhwl4/4
         TKKR9DPQyLJ+kZ+nQVA5aF0oHoCDT1mORXCa+VYPIIXBaK53fZDs3wSXIpuCpM4HtEHd
         b/iAKZelL/EgjCvxZmEGTurk1lK6922v21LbUJ7JxgYlexfobGlx8iZtIOyAVx9pyLqc
         QoK/xekl9Y57N7unuQldMOQfk+G87n32xwKcmHW32zh2RgOIGp313Kq5TsYpXT1+rwvt
         2+9hEwDzGoaW2+9sGVLIWufrkLfBncwA57Rvmmv5Nfz9ops1bM9sDFOdfaWw3keCzCk/
         ZRgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=RwmF1eG4qjehbM/6vPHudaKlp5QMZAj0EjDeZYR+hmQ=;
        b=1aOAY0yo/lXWs7f+Oz287tLmfxz8J2qVMW0oYFf37ocESNSlItDwqk6LPdppzqXbV/
         D53ZH7dZCKZXP7CiwoOLO26/EItffzBnjh15wkKri9AlkRg4FPRAvMPadc/2paipS0pU
         ACdzarJlvPBIqOp9e83pUfEQx4/Bij4Fkh/A4HG3lzVyA7OdI8P8kra1Wk7o1/iLjS6T
         77ZzX2k2+TS1S6tNP3UQWF0NIasZNpPBuHRmVkLfKszYpik9kqUOJddBqKTM+XABXBuY
         ML6tE7OSdGJvT9Ax6s71DGRTKuNORn0GuDeMyyiRLXfV2PYBxePn/VuOcWUX36v99gHl
         mYog==
X-Gm-Message-State: AOAM5329XTnXF49LVJwTo1hIvlgtU2jN7plGTWi6s3Cxb3qlSaBTluuS
        CoD6Bk6ycuTQNnJAJ6mNXQmeTndWszPxUy4=
X-Google-Smtp-Source: ABdhPJzcVHO3Ms5A0jhHL8HrSgC/BPW06xlc2sD9lu2NhNaF2NYgAvjFpvJKh45oFc+yH+l3aOMriFQ5YfmnYCc=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:16d1:ab0e:fc4a:b9b1])
 (user=saravanak job=sendgmr) by 2002:a0c:d6cd:: with SMTP id
 l13mr9444170qvi.24.1631693519655; Wed, 15 Sep 2021 01:11:59 -0700 (PDT)
Date:   Wed, 15 Sep 2021 01:11:38 -0700
In-Reply-To: <20210915081139.480263-1-saravanak@google.com>
Message-Id: <20210915081139.480263-7-saravanak@google.com>
Mime-Version: 1.0
References: <20210915081139.480263-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH v2 6/6] net: mdiobus: Set FWNODE_FLAG_NEEDS_CHILD_BOUND_ON_ADD
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
Cc:     John Stultz <john.stultz@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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

