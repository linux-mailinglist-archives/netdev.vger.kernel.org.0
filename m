Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D289A3EF16D
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 20:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233350AbhHQSJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 14:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233316AbhHQSJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 14:09:24 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AA96C061796
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:08:51 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id s9-20020ad450090000b029034fef0edad8so117996qvo.21
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 11:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SKq9HcdkybONWxbOYSXUnyicnjbklpyY3c0EANEvRv8=;
        b=Gs0/YqmYWclEEeTZV6R0wilhvUjUPDlIS/alZU0PkD0KPC860I53TUlJwRT2VfmdWs
         gVkyGiF+eaKIW0lluIAEjagyDa9dW75LUek/rBFKL+/bX97fU95KzJw78Pdo3ADvPl5R
         I72BjDAAjJWB5JyTxIssoUpda34lczkElPf9clOSKRPQBVKNQR2ijSl54LVmR4zL30JA
         M7KwKTdVDu5TdAj6gH3ONOh5k/QJL0kHDPvUZ+VGAmbwopsc3usYdmlk69IvKWWUHe4h
         hIELSWAWKSR2a+Mjo80PpmQYXeZa7dmFFA3Lv6po5JDvdPAa80UaRgq2ic9p4u3mHnCP
         5qcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SKq9HcdkybONWxbOYSXUnyicnjbklpyY3c0EANEvRv8=;
        b=QzkbeU3Dt75HSzpAP5icFUrxkgRsHfcq2Mk4+sNgMvgrPzhwFem1P+NapjP7RbQViL
         xxrunXbwFOQHsfAI4TEucrR5j+KklaNqiJs4dxcHvICsqZdYAe4sSq4LwjZ6mfjjZ9z+
         0BoZbjaaSPYouepaBENkYxhoq2RopdorNZ25iAaP3TwLFaJk9K5z1PWB/hnuPA7NjoBX
         YL5hoZei+BmhGMT5LtmJ6gy3yrwt9YyUlarAKPbWa50yghyYwnhkoSunINnxoFwx/C2I
         geWOWNAMc+gk37haj2jno3ruQ4dLKWZS17iFmJWk5+ap7uk9+nhg8KAF+rrW/S4H6KFB
         ++SQ==
X-Gm-Message-State: AOAM530W6+X55e1RskUlTaiZVh1EhTbjN3Y7lcQIUo3xC/jtWHxceN56
        z4wYD9AMCSFWHH/AiulvIER9n+RHMZDJYZs=
X-Google-Smtp-Source: ABdhPJzyMy1hBP0Fyod55lGFXARTq3Sr2eOkmHUhHKt/kEGuoSOplyPyBEAtyvjpSZqanFM3QC2V3dk1l0Mik9s=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:7750:a56d:5272:72cb])
 (user=saravanak job=sendgmr) by 2002:a0c:aac2:: with SMTP id
 g2mr4539726qvb.44.1629223730289; Tue, 17 Aug 2021 11:08:50 -0700 (PDT)
Date:   Tue, 17 Aug 2021 11:08:40 -0700
In-Reply-To: <20210817180841.3210484-1-saravanak@google.com>
Message-Id: <20210817180841.3210484-3-saravanak@google.com>
Mime-Version: 1.0
References: <20210817180841.3210484-1-saravanak@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH net v2 2/3] net: mdio-mux: Don't ignore memory allocation errors
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

If we are seeing memory allocation errors, don't try to continue
registering child mdiobus devices. It's unlikely they'll succeed.

Signed-off-by: Saravana Kannan <saravanak@google.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Marc Zyngier <maz@kernel.org>
Tested-by: Marc Zyngier <maz@kernel.org>
Acked-by: Kevin Hilman <khilman@baylibre.com>
Tested-by: Kevin Hilman <khilman@baylibre.com>
---
 drivers/net/mdio/mdio-mux.c | 28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/mdio/mdio-mux.c b/drivers/net/mdio/mdio-mux.c
index 5b37284f54d6..13035e2685c4 100644
--- a/drivers/net/mdio/mdio-mux.c
+++ b/drivers/net/mdio/mdio-mux.c
@@ -82,6 +82,17 @@ static int mdio_mux_write(struct mii_bus *bus, int phy_id,
 
 static int parent_count;
 
+static void mdio_mux_uninit_children(struct mdio_mux_parent_bus *pb)
+{
+	struct mdio_mux_child_bus *cb = pb->children;
+
+	while (cb) {
+		mdiobus_unregister(cb->mii_bus);
+		mdiobus_free(cb->mii_bus);
+		cb = cb->next;
+	}
+}
+
 int mdio_mux_init(struct device *dev,
 		  struct device_node *mux_node,
 		  int (*switch_fn)(int cur, int desired, void *data),
@@ -144,7 +155,7 @@ int mdio_mux_init(struct device *dev,
 		cb = devm_kzalloc(dev, sizeof(*cb), GFP_KERNEL);
 		if (!cb) {
 			ret_val = -ENOMEM;
-			continue;
+			goto err_loop;
 		}
 		cb->bus_number = v;
 		cb->parent = pb;
@@ -152,8 +163,7 @@ int mdio_mux_init(struct device *dev,
 		cb->mii_bus = mdiobus_alloc();
 		if (!cb->mii_bus) {
 			ret_val = -ENOMEM;
-			devm_kfree(dev, cb);
-			continue;
+			goto err_loop;
 		}
 		cb->mii_bus->priv = cb;
 
@@ -181,6 +191,10 @@ int mdio_mux_init(struct device *dev,
 	}
 
 	dev_err(dev, "Error: No acceptable child buses found\n");
+
+err_loop:
+	mdio_mux_uninit_children(pb);
+	of_node_put(child_bus_node);
 err_pb_kz:
 	put_device(&parent_bus->dev);
 err_parent_bus:
@@ -192,14 +206,8 @@ EXPORT_SYMBOL_GPL(mdio_mux_init);
 void mdio_mux_uninit(void *mux_handle)
 {
 	struct mdio_mux_parent_bus *pb = mux_handle;
-	struct mdio_mux_child_bus *cb = pb->children;
-
-	while (cb) {
-		mdiobus_unregister(cb->mii_bus);
-		mdiobus_free(cb->mii_bus);
-		cb = cb->next;
-	}
 
+	mdio_mux_uninit_children(pb);
 	put_device(&pb->mii_bus->dev);
 }
 EXPORT_SYMBOL_GPL(mdio_mux_uninit);
-- 
2.33.0.rc1.237.g0d66db33f3-goog

