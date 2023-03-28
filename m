Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8BF6CBE2E
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232075AbjC1Lzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjC1Lzj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:55:39 -0400
Received: from smtp2.axis.com (smtp2.axis.com [195.60.68.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAF86A7F;
        Tue, 28 Mar 2023 04:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1680004538;
  x=1711540538;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hLW9oKkzUELEmx4quJRja6L+Ddl748nJ5KqDLi0c2Wo=;
  b=Y03uZykADA6MiLK+1UMQdfuGdviBKqldqzzxzLk5sJP/6tdhN7/oFkTC
   FuOKRfrTvnLDNyiqsluwUPqscg+dfxupa0xqA2IF/POqOVUcmGohGOQ5l
   ZnJOmGGX+OOcRE+tGYR/F1/av+L4v+Yura5z4BoSr6rkVt13VkY4VbvCx
   XsdxtjG9bD74OxEsiTz6mv+qIslTzlOkNoLHcr0xrVmEenA4p0dVStV0N
   ah5i/jiHRwWFb6ldBAchZuNIspf+xp2DAtvIwaV5a9WIUB4RjGCUMQhP5
   GBrvoQTiiGkQnOkvozpAuXJkNCuh5hhdSxmA3cEoUoyNy3QwqDbkcr7Fr
   g==;
From:   Gustav Ekelund <gustav.ekelund@axis.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>
CC:     <kernel@axis.com>, Gustav Ekelund <gustaek@axis.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: dsa: mv88e6xxx: Reset mv88e6393x watchdog register
Date:   Tue, 28 Mar 2023 13:55:11 +0200
Message-ID: <20230328115511.400145-1-gustav.ekelund@axis.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gustav Ekelund <gustaek@axis.com>

The watchdog event bits are not cleared during SW reset in the mv88e6393x
switch. This causes one event to be handled over and over again.

Explicitly clear the watchdog event register to 0 after the SW reset.

Signed-off-by: Gustav Ekelund <gustaek@axis.com>
---
 drivers/net/dsa/mv88e6xxx/chip.c    |  2 +-
 drivers/net/dsa/mv88e6xxx/global2.c | 17 +++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global2.h |  1 +
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 30383c4f8fd0..ee22d4785e9e 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -5596,7 +5596,7 @@ static const struct mv88e6xxx_ops mv88e6393x_ops = {
 	 * .port_set_upstream_port method.
 	 */
 	.set_egress_port = mv88e6393x_set_egress_port,
-	.watchdog_ops = &mv88e6390_watchdog_ops,
+	.watchdog_ops = &mv88e6393x_watchdog_ops,
 	.mgmt_rsvd2cpu = mv88e6393x_port_mgmt_rsvd2cpu,
 	.pot_clear = mv88e6xxx_g2_pot_clear,
 	.reset = mv88e6352_g1_reset,
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index ed3b2f88e783..bef8297d4f78 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -943,6 +943,23 @@ const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {
 	.irq_free = mv88e6390_watchdog_free,
 };
 
+static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
+{
+	mv88e6390_watchdog_action(chip, irq);
+
+	mv88e6xxx_g2_write(chip, MV88E6390_G2_WDOG_CTL,
+			   MV88E6390_G2_WDOG_CTL_UPDATE |
+			   MV88E6390_G2_WDOG_CTL_PTR_EVENT);
+
+	return IRQ_HANDLED;
+}
+
+const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops = {
+	.irq_action = mv88e6393x_watchdog_action,
+	.irq_setup = mv88e6390_watchdog_setup,
+	.irq_free = mv88e6390_watchdog_free,
+};
+
 static irqreturn_t mv88e6xxx_g2_watchdog_thread_fn(int irq, void *dev_id)
 {
 	struct mv88e6xxx_chip *chip = dev_id;
diff --git a/drivers/net/dsa/mv88e6xxx/global2.h b/drivers/net/dsa/mv88e6xxx/global2.h
index e973114d6890..7e091965582b 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.h
+++ b/drivers/net/dsa/mv88e6xxx/global2.h
@@ -369,6 +369,7 @@ int mv88e6xxx_g2_device_mapping_write(struct mv88e6xxx_chip *chip, int target,
 extern const struct mv88e6xxx_irq_ops mv88e6097_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6250_watchdog_ops;
 extern const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops;
+extern const struct mv88e6xxx_irq_ops mv88e6393x_watchdog_ops;
 
 extern const struct mv88e6xxx_avb_ops mv88e6165_avb_ops;
 extern const struct mv88e6xxx_avb_ops mv88e6352_avb_ops;
-- 
2.30.2

