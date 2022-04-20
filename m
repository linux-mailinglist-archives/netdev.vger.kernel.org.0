Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF9A5088A0
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378676AbiDTNCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 09:02:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353465AbiDTNCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 09:02:52 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A112313E8F;
        Wed, 20 Apr 2022 06:00:05 -0700 (PDT)
Received: from localhost.localdomain (36-229-224-240.dynamic-ip.hinet.net [36.229.224.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 73B6A3FA13;
        Wed, 20 Apr 2022 12:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1650458471;
        bh=IuGCtf3zsB/O4RdOMcLBokmiioeblM6BUDmAgq58MJg=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=muLIKpoXBwJKSydkivyRZuCnkKzuV8fu+vL1nKSK5mcu0Vy1xZr0/ve2M3OrxkTTj
         zMPerWxBgytunUxAT6t05LFZI6CAQJEJGWawlW7VUSInDb/HjCHx2defOP5MqGVAhk
         +rHf7Mz1NDDk1JLnJAO2bs77Cmi4srGXJaZnRHg4yINLnB6mHlFHxgp9nSeThlYp37
         wZeaOwfA9aNDnAiu832x9ORIwdc0w/5SOL9ktByRKWC4B9s677nAfQlVj0CTz1itGp
         +8okbfi7tWECHrZqsMt/vLmJclKGhMIegl4q/l0Gk652iDInsLg/REDO7+9THcIebZ
         G+MQdgVfizhgw==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] net: mdio: Mask PHY only when its ACPI node is present
Date:   Wed, 20 Apr 2022 20:40:48 +0800
Message-Id: <20220420124053.853891-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220420124053.853891-1-kai.heng.feng@canonical.com>
References: <20220420124053.853891-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Not all PHY has an ACPI node, for those nodes auto probing is still
needed.

So only mask those PHYs with ACPI nodes.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/mdio/acpi_mdio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/acpi_mdio.c b/drivers/net/mdio/acpi_mdio.c
index d77c987fda9cd..f9369319ada19 100644
--- a/drivers/net/mdio/acpi_mdio.c
+++ b/drivers/net/mdio/acpi_mdio.c
@@ -33,8 +33,15 @@ int acpi_mdiobus_register(struct mii_bus *mdio, struct fwnode_handle *fwnode)
 	u32 addr;
 	int ret;
 
-	/* Mask out all PHYs from auto probing. */
-	mdio->phy_mask = GENMASK(31, 0);
+	/* Loop over the child nodes and mask out PHY from auto probing */
+	fwnode_for_each_child_node(fwnode, child) {
+		ret = acpi_get_local_address(ACPI_HANDLE_FWNODE(child), &addr);
+		if (ret || addr >= PHY_MAX_ADDR)
+			continue;
+
+		mdio->phy_mask |= BIT(addr);
+	}
+
 	ret = mdiobus_register(mdio);
 	if (ret)
 		return ret;
-- 
2.34.1

