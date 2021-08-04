Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7D03E0A17
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 23:43:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233670AbhHDVn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 17:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232829AbhHDVn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 17:43:57 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04357C0613D5
        for <netdev@vger.kernel.org>; Wed,  4 Aug 2021 14:43:44 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id b4-20020a3799040000b02903b899a4309cso2886033qke.14
        for <netdev@vger.kernel.org>; Wed, 04 Aug 2021 14:43:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Yfvc1y59oR5+LtzVBBauZFH1r/tvrwxUqR7lrvF7mpY=;
        b=kTmOFrP7L/yw8DPyAq+Z9PdmavFp56OCF/BKatjh3C5PTq4hbHOwJh7VYSOlTzbvZf
         lgzgeD7Ao1klgXljKIqzg4sby9v4uAyNdWwihF0so/j4O51xLfiiwAn7dbpEiQIsUJps
         br2k7Fzr1t8Yc4z60bh5FtEiwgaC+4v6C3knP+d8rlmMUXNdIpHQIYTSfrCQut2NBnkc
         l+HgGMMqRjeuG9+MvsKONbR+4CXKUkiIKeOh/e3Luv4Inn+eZHio8mBFI5oRBgbBRVAF
         riSUm2NwDCGnE4Bw48DmmM+qkSYF3ikncB5BTYe4vXD+EoWPaTFLP4eqZrapz6vPqOdA
         Pi+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Yfvc1y59oR5+LtzVBBauZFH1r/tvrwxUqR7lrvF7mpY=;
        b=MYg3qwuh6Dhq3NJ57cYz97dkfozN6+JHYcwy0oym7wwox3wBD3l+xYXe0Q2KxGysPd
         +0E+EKuejd1V5t0N9DklcUkTJb17yqPQeuuZgdYiPMMhHSv95IaBu+F29YAIPDq8CQQl
         DwMlUNsKdHR9862PQYZNFgnWGibAEvhxw4JGZoLpgtqvYRsoGMC9FiLK9Zuka6Oihkak
         z4SHoQcpTRQRcrTjE1+U3fIkAG4Be0LPkgmzEj+ZKiRsUezQv4zu/oee68WV65bAEafO
         l/CejppupBGb+Obo8ET4q7W5lQwXIhbvQ1CW89+zV7AWRfDASFoneWKTxbTHTorK9AYH
         MnBw==
X-Gm-Message-State: AOAM53125pRFYG3u6qDBF4ha8a6oI94O/KUYq71usG/kpVdFPeBrAFeK
        /gNkkoGn8JSwbnL7WeoAtpczbv3XVXVzaFs=
X-Google-Smtp-Source: ABdhPJxP4qxypc1Lm8WQZTN0xdIV9kZ1Q3kp6P0dl9diA/2iCpr9UsfvSrl8gf3HIuwSOzKOn85j6PDmXnySW5A=
X-Received: from saravanak.san.corp.google.com ([2620:15c:2d:3:ffe5:1245:526e:3189])
 (user=saravanak job=sendgmr) by 2002:ad4:55d0:: with SMTP id
 bt16mr1690482qvb.49.1628113423244; Wed, 04 Aug 2021 14:43:43 -0700 (PDT)
Date:   Wed,  4 Aug 2021 14:43:31 -0700
In-Reply-To: <20210804214333.927985-1-saravanak@google.com>
Message-Id: <20210804214333.927985-3-saravanak@google.com>
Mime-Version: 1.0
References: <20210804214333.927985-1-saravanak@google.com>
X-Mailer: git-send-email 2.32.0.554.ge1b32706d8-goog
Subject: [PATCH v1 2/3] net: mdio-mux: Don't ignore memory allocation errors
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
2.32.0.554.ge1b32706d8-goog

