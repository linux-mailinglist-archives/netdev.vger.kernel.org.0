Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44E51620B0B
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 09:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233650AbiKHIX4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 03:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232641AbiKHIXv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 03:23:51 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9182F27B12
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 00:23:50 -0800 (PST)
Received: from localhost.localdomain (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 64F3984EC7;
        Tue,  8 Nov 2022 09:23:48 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1667895828;
        bh=Gs6DnUydFRMZ2YE+Wn8GF/e+WivSI2G7EmFJMVghOvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWAmEF66T99msKZCC0y4PaoPYYhpYEVzUCLkBhIkfuniSNZkkU0Z0RoCwpztQj7OQ
         Uo93GCCtvz1+K9ZryDR2E82ts0JpdmAGALK25Du4GS9pceXJFd9dUhojg2cMyN8Zlc
         QB1UZOnujrj47c4szx2WDwOAtHS7999DdcCnBh/85pbKpMn67BRXHWsGG9XG5EMdKH
         OsNI5JrgzBvIIbm74bS7CcAmt8O1oRXCMjh5QxXDbyJG3v3LVnXfZlFbqi+VDDT71n
         M6EHGPoMJUGcCBvUE+KjWN/pc9GzA+PaIK5i7ygey/4edmlXNOO0rHnTcazB9Jfmke
         EaryWVTucVWCw==
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH 2/9] net: dsa: mv88e6xxx: account for PHY base address offset in dual chip mode
Date:   Tue,  8 Nov 2022 09:23:23 +0100
Message-Id: <20221108082330.2086671-3-lukma@denx.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221108082330.2086671-1-lukma@denx.de>
References: <20221108082330.2086671-1-lukma@denx.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

In dual chip mode (6250 family), not only global and port registers are
shifted by sw_addr, but also the PHY addresses. Account for this in the
IRQ mapping.

Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
---
 drivers/net/dsa/mv88e6xxx/chip.h    | 1 +
 drivers/net/dsa/mv88e6xxx/global2.c | 2 +-
 drivers/net/dsa/mv88e6xxx/smi.c     | 4 ++++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index e693154cf803..b03f279a673d 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -328,6 +328,7 @@ struct mv88e6xxx_chip {
 	const struct mv88e6xxx_bus_ops *smi_ops;
 	struct mii_bus *bus;
 	int sw_addr;
+	unsigned int phy_base_addr;
 
 	/* Handles automatic disabling and re-enabling of the PHY
 	 * polling unit.
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index fa65ecd9cb85..fd6ba1fc6bef 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1172,7 +1172,7 @@ int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
 			err = irq;
 			goto out;
 		}
-		bus->irq[chip->info->phy_base_addr + phy] = irq;
+		bus->irq[chip->phy_base_addr + phy] = irq;
 	}
 	return 0;
 out:
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index a990271b7482..520e47b375b2 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -186,5 +186,9 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
 	if (chip->smi_ops->init)
 		return chip->smi_ops->init(chip);
 
+	chip->phy_base_addr = chip->info->phy_base_addr;
+	if (chip->info->dual_chip)
+		chip->phy_base_addr += sw_addr;
+
 	return 0;
 }
-- 
2.37.2

