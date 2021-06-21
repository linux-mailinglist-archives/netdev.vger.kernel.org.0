Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 024B43AF204
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231655AbhFURdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:33:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbhFURda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Jun 2021 13:33:30 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDDE3C061756
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:31:14 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id u13so12189005lfk.2
        for <netdev@vger.kernel.org>; Mon, 21 Jun 2021 10:31:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=semihalf-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7WvcmjpDE06toGMKX+zkAYwYDdzPn5oW9s8HRQs3izM=;
        b=d8vh39N35Xd+//mob2LNSri4E6mTL19ceEvR0Ja7CJ06X/5iVoP6ktLh8u9X7pRrKU
         Gy5dcTZKZAVY9sGOaM/iOvK1RiVEQ4q/9+TfAiXMaAerLrIvNN7XiiZgBUBvPEFx45Lv
         xSIYmOsul0/nFNqao9KX/LhZWMZFFp2ifXn2Et6zb79eLdGPckwVN+EA/vYtAAlo18mz
         EGMguggW0LWTW2Vc0do1PU5XgwbuPzMD88cTfL1qKe2UwMW95Q8M3SwT6/wl2mZNL7cg
         X0CXHM543yM787B8qMFKjA9JOPAtukqFAzb4xidyMHiUSqN81M3Ak5tI+r/uPjAYNKhY
         Qnug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7WvcmjpDE06toGMKX+zkAYwYDdzPn5oW9s8HRQs3izM=;
        b=RgaBNOgoW8/ThyBSj4KNjdm2GAjcjLpHw9WumtQhD+H2ii+9l/Im1oRiyJkNfbJWxp
         qN+f/hSZZ/DA0xuZzWQbVf6jNDBts6JlVSR2XBxtkwH6Pp5B9OrDPFecT196pcUaOrQM
         2ixPN77wX3Fsf5dzTXCIN4liGwWDNOrMbFqU+ZV6F7ljFAdN8x4qxUS9qzm2MKAfHijt
         TW5W4+QgF4LkXU9qSFXc06kJC6MrmW4//VwrOqXCyJhDlvPFazkf/DASao0/IR2Lv/6w
         vo311ePIq18/Ze0I3oskP2S7dLApc5rrE+wufRNQ9lwejnqypjC4arz+rZPywdjydnpm
         q1YA==
X-Gm-Message-State: AOAM532UEFps/q1eDWEtreOPO4BKWXDGmpqtq4YdK7GKkEfyVZ4hjKtT
        8nDxFd0yo9r4ugiIiFlRF0fIKw==
X-Google-Smtp-Source: ABdhPJydDuW3AiIFeVeMNwbF8EeqbIscjb6gfI6NA8Q4YopZOgj273y4uUemXN1TY84FSoprQbpAnQ==
X-Received: by 2002:ac2:4c83:: with SMTP id d3mr14981121lfl.543.1624296673089;
        Mon, 21 Jun 2021 10:31:13 -0700 (PDT)
Received: from gilgamesh.lab.semihalf.net ([83.142.187.85])
        by smtp.gmail.com with ESMTPSA id u11sm1926380lfs.257.2021.06.21.10.31.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 10:31:12 -0700 (PDT)
From:   Marcin Wojtas <mw@semihalf.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux@armlinux.org.uk,
        jaz@semihalf.com, gjb@semihalf.com, upstream@semihalf.com,
        Samer.El-Haj-Mahmoud@arm.com, jon@solid-run.com, tn@semihalf.com,
        rjw@rjwysocki.net, lenb@kernel.org, Marcin Wojtas <mw@semihalf.com>
Subject: [net-next: PATCH v3 2/6] net: mdiobus: Introduce fwnode_mdbiobus_register()
Date:   Mon, 21 Jun 2021 19:30:24 +0200
Message-Id: <20210621173028.3541424-3-mw@semihalf.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210621173028.3541424-1-mw@semihalf.com>
References: <20210621173028.3541424-1-mw@semihalf.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch introduces a new helper function that
wraps acpi_/of_ mdiobus_register() and allows its
usage via common fwnode_ interface.

Fall back to raw mdiobus_register() in case CONFIG_FWNODE_MDIO
is not enabled, in order to satisfy compatibility
in all future user drivers.

Signed-off-by: Marcin Wojtas <mw@semihalf.com>
---
 include/linux/fwnode_mdio.h    | 12 +++++++++++
 drivers/net/mdio/fwnode_mdio.c | 22 ++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/fwnode_mdio.h b/include/linux/fwnode_mdio.h
index faf603c48c86..13d4ae8fee0a 100644
--- a/include/linux/fwnode_mdio.h
+++ b/include/linux/fwnode_mdio.h
@@ -16,6 +16,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 				struct fwnode_handle *child, u32 addr);
 
+int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode);
 #else /* CONFIG_FWNODE_MDIO */
 int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
 				       struct phy_device *phy,
@@ -30,6 +31,17 @@ static inline int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 {
 	return -EINVAL;
 }
+
+static inline int fwnode_mdiobus_register(struct mii_bus *bus,
+					  struct fwnode_handle *fwnode)
+{
+	/*
+	 * Fall back to mdiobus_register() function to register a bus.
+	 * This way, we don't have to keep compat bits around in drivers.
+	 */
+
+	return mdiobus_register(mdio);
+}
 #endif
 
 #endif /* __LINUX_FWNODE_MDIO_H */
diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
index 1becb1a731f6..ae0bf71a9932 100644
--- a/drivers/net/mdio/fwnode_mdio.c
+++ b/drivers/net/mdio/fwnode_mdio.c
@@ -7,8 +7,10 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/acpi_mdio.h>
 #include <linux/fwnode_mdio.h>
 #include <linux/of.h>
+#include <linux/of_mdio.h>
 #include <linux/phy.h>
 
 MODULE_AUTHOR("Calvin Johnson <calvin.johnson@oss.nxp.com>");
@@ -142,3 +144,23 @@ int fwnode_mdiobus_register_phy(struct mii_bus *bus,
 	return 0;
 }
 EXPORT_SYMBOL(fwnode_mdiobus_register_phy);
+
+/**
+ * fwnode_mdiobus_register - bring up all the PHYs on a given MDIO bus and
+ *	attach them to it.
+ * @bus: Target MDIO bus.
+ * @fwnode: Pointer to fwnode of the MDIO controller.
+ *
+ * Return values are determined accordingly to acpi_/of_ mdiobus_register()
+ * operation.
+ */
+int fwnode_mdiobus_register(struct mii_bus *bus, struct fwnode_handle *fwnode)
+{
+	if (is_acpi_node(fwnode))
+		return acpi_mdiobus_register(bus, fwnode);
+	else if (is_of_node(fwnode))
+		return of_mdiobus_register(bus, to_of_node(fwnode));
+	else
+		return -EINVAL;
+}
+EXPORT_SYMBOL(fwnode_mdiobus_register);
-- 
2.29.0

