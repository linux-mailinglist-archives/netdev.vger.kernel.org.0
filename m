Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 217A0376DD7
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 02:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhEHAcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 20:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhEHAbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 May 2021 20:31:07 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFECC061354;
        Fri,  7 May 2021 17:29:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id s8so10863032wrw.10;
        Fri, 07 May 2021 17:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D5uILt9Mcik69GuSPXQVODEGZtxJwB3jkU/VveoNRJY=;
        b=aPiMybhdazAWHfH8VCeUfkKwZUm8E5m/BizfTo3J55KXdWXy4WiW6pvdWTnM0MrAxN
         CrIiTXZaWb+iuBurRdE1gXBWuWc42f+OMg8Tl9pR18vC3IH1eMh/0U81MOaXsZ2GncHW
         9/xCu3Ph1Q+TyLQmTGcV8mrs9UwAHu3qT/8DDuA9bLBu+9qAlMtdvb96INgwR/EJuwDL
         ROybuA5PYWkHIH+uFgc2sOM7xGJ6ESqJB4G54lWcNiX9gK4IUEpv5onzzw/6GSg1BFwr
         NuGTGGTDDB9Zy3BMj8jytlYEbZn6ItCKqoYqiSUw8/gJP9MO2me+evYwovHQl+ZBAg+a
         PgpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D5uILt9Mcik69GuSPXQVODEGZtxJwB3jkU/VveoNRJY=;
        b=PDeVXaA6Q0B9nhJW4TlQz2fjkxilju/vX/7U40ysM+TJvpBbM7NUXwT/kDWcD3ftGC
         4zTrsORtuybwmnkF5nPCFiAC2Kv0CMUwTeJuYfGqAAfahopbvFCRXoA6vgoRj1/k5XKc
         dvocVw3SmdKHVGU50dQA+XA8AyhYaZVCXzF4/nZIeMSOgmvsqcVf5iswqo1nh0/MOlE7
         n7eIKqXVSTSzgYwazxkxNPza6bSuqmydEevh4C8ZEMNFfXXQx5BlK6CnvORzgqaixliA
         WF9zbJkLMCPm6T4B7wrjdxwaaxdeFTKGi0NXAbpgpP/UUMm6Y5aMUs89Xo1KDBo2drlZ
         /TJQ==
X-Gm-Message-State: AOAM532SDaXU2Eq67mpz+n6hBAZCz8UiODwIbBnFqvkqKIO8zYC7oLh1
        xwwzM4YdymyTFeP7hV4aKzY=
X-Google-Smtp-Source: ABdhPJw/Pq+vvq3FZsqSdCfYPDj9ZmoQYsIpqvP0/xvnRbLpbJQx7oc9TOZRtKwz4t42P2Ac2sTsxQ==
X-Received: by 2002:a5d:6342:: with SMTP id b2mr15854176wrw.203.1620433784443;
        Fri, 07 May 2021 17:29:44 -0700 (PDT)
Received: from Ansuel-xps.localdomain (93-35-189-2.ip56.fastwebnet.it. [93.35.189.2])
        by smtp.googlemail.com with ESMTPSA id f4sm10967597wrz.33.2021.05.07.17.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 17:29:44 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH net-next v4 23/28] net: dsa: register of_mdiobus if a mdio node is declared
Date:   Sat,  8 May 2021 02:29:13 +0200
Message-Id: <20210508002920.19945-23-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508002920.19945-1-ansuelsmth@gmail.com>
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some switch have phy port that use the internal switch mdio bus and can
have different phy regs than the one declared in the ports node. Add
support for this specific case by registering the mdiobus with the mdio
node and permit the port to declare a phy-handle defined inside the
switch node.

This is an example from the qca8337 switch where the 5 phy port should
use the internal mdiobus and would benefits from this.

switch10: switch@10 {
        compatible = "qca,qca8337";
        #address-cells = <1>;
        #size-cells = <0>;
        reg = <0x10>;

        ports {
                #address-cells = <1>;
                #size-cells = <0>;

                port@0 {
                        reg = <0>;
                        label = "cpu";
                        ethernet = <&gmac1>;
                        phy-mode = "rgmii-id";

                        fixed-link {
                                speed = <1000>;
                                full-duplex;
                        };
                };

                port@1 {
                        reg = <1>;
                        label = "lan1";

                        phy-handle = <&phy_port0>;
                        phy-mode = "internal";
                };

                port@2 {
                        reg = <2>;
                        label = "lan2";

                        phy-handle = <&phy_port1>;
                        phy-mode = "internal";
                };

                port@3 {
                        reg = <3>;
                        label = "lan3";

                        phy-handle = <&phy_port2>;
                        phy-mode = "internal";
                };

                port@4 {
                        reg = <4>;
                        label = "lan4";

                        phy-handle = <&phy_port3>;
                        phy-mode = "internal";
                };

                port@5 {
                        reg = <5>;
                        label = "wan";

                        phy-handle = <&phy_port4>;
                        phy-mode = "internal";
                };

                port@6 {
                        reg = <6>;
                        label = "cpu";
                        ethernet = <&gmac2>;
                        phy-mode = "sgmii";

                        fixed-link {
                                        speed = <1000>;
                                        full-duplex;
                        };
                };
        };

        mdio {
                #address-cells = <1>;
                #size-cells = <0>;

                phy_port0: phy@0 {
                        reg = <0>;
                };

                phy_port1: phy@1 {
                        reg = <1>;
                };

                phy_port2: phy@2 {
                        reg = <2>;
                };

                phy_port3: phy@3 {
                        reg = <3>;
                };

                phy_port4: phy@4 {
                        reg = <4>;
                };
        };
};

Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
---
 net/dsa/dsa2.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/dsa/dsa2.c b/net/dsa/dsa2.c
index 3c3e56a1f34d..79adabe3e2a7 100644
--- a/net/dsa/dsa2.c
+++ b/net/dsa/dsa2.c
@@ -14,6 +14,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/of.h>
 #include <linux/of_net.h>
+#include <linux/of_mdio.h>
 #include <net/devlink.h>
 
 #include "dsa_priv.h"
@@ -721,6 +722,8 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 	devlink_params_publish(ds->devlink);
 
 	if (!ds->slave_mii_bus && ds->ops->phy_read) {
+		struct device_node *mdio;
+
 		ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
 		if (!ds->slave_mii_bus) {
 			err = -ENOMEM;
@@ -729,7 +732,15 @@ static int dsa_switch_setup(struct dsa_switch *ds)
 
 		dsa_slave_mii_bus_init(ds);
 
-		err = mdiobus_register(ds->slave_mii_bus);
+		mdio = of_get_child_by_name(ds->dev->of_node, "mdio");
+
+		if (mdio) {
+			err = of_mdiobus_register(ds->slave_mii_bus, mdio);
+			of_node_put(mdio);
+		} else {
+			err = mdiobus_register(ds->slave_mii_bus);
+		}
+
 		if (err < 0)
 			goto teardown;
 	}
-- 
2.30.2

