Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383B36D1A9E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 10:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbjCaInG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 04:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbjCaImp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 04:42:45 -0400
Received: from smtp1.axis.com (smtp1.axis.com [195.60.68.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48CD1BF7A;
        Fri, 31 Mar 2023 01:42:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1680252131;
  x=1711788131;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k8KVUCNpW25DV6tjwWLq0OtC95O37Z97vcBAzgAGp6I=;
  b=pLWqwYmFgUmNx1/Or9peyE0Ibfc22ncAtZeZUwKrURa8pIkiagR7dCUL
   4ECilel0mfyZUV+Za2roOJ3oyrtkRhjNo8XWcQdkLFE9/8+T7CPkh4sjf
   bAg4tzaQH2DAceIge//QGyt3udFD+ZXa2S2K0yHCmaIkXo7SOawXEuEKF
   T77rl50ESYWnxwDfW6LeqIUJQ42yzR/TSlBCMzRvTy+XWAGKVPMtO0jBA
   fLKzNyNHNwwZ0KiPBm4nIghFZWnjN488xo+w1GzEBXgy3Hg+lpK6RnSD6
   cHQeccD2cmCXc7YzcoNE86zToUqklVck1zCHU1Ts5z9/SEHlHrixgkCv4
   w==;
From:   Gustav Ekelund <gustav.ekelund@axis.com>
To:     <marek.behun@nic.cz>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     <kernel@axis.com>, Gustav Ekelund <gustaek@axis.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net v2] net: dsa: mv88e6xxx: Reset mv88e6393x force WD event bit
Date:   Fri, 31 Mar 2023 10:40:13 +0200
Message-ID: <20230331084014.1144597-1-gustav.ekelund@axis.com>
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

The force watchdog event bit is not cleared during SW reset in the
mv88e6393x switch. This is a different behavior compared to mv886390 which
clears the force WD event bit as advertised. This causes a force WD event
to be handled over and over again as the SW reset following the event never
clears the force WD event bit.

Explicitly clear the watchdog event register to 0 in irq_action when
handling an event to prevent the switch from sending continuous interrupts.
Marvell aren't aware of any other stuck bits apart from the force WD
bit.

Signed-off-by: Gustav Ekelund <gustaek@axis.com>
---

Notes:
    v2 Clarify commit message and added a comment

 drivers/net/dsa/mv88e6xxx/chip.c    |  2 +-
 drivers/net/dsa/mv88e6xxx/global2.c | 20 ++++++++++++++++++++
 drivers/net/dsa/mv88e6xxx/global2.h |  1 +
 3 files changed, 22 insertions(+), 1 deletion(-)

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
index ed3b2f88e783..a7af3cebae97 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -943,6 +943,26 @@ const struct mv88e6xxx_irq_ops mv88e6390_watchdog_ops = {
 	.irq_free = mv88e6390_watchdog_free,
 };
 
+static int mv88e6393x_watchdog_action(struct mv88e6xxx_chip *chip, int irq)
+{
+	mv88e6390_watchdog_action(chip, irq);
+
+	/* Fix for clearing the force WD event bit.
+	 * Unreleased erratum on mv88e6393x.
+	 */
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

