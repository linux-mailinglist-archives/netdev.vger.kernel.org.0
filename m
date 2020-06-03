Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D0B1ED275
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 16:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726507AbgFCOuY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 10:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726414AbgFCOuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 10:50:19 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82937C08C5C0;
        Wed,  3 Jun 2020 07:50:19 -0700 (PDT)
Received: from [5.158.153.53] (helo=debian-buster-darwi.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <a.darwish@linutronix.de>)
        id 1jgUiP-0001w5-0A; Wed, 03 Jun 2020 16:50:01 +0200
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH v2 2/6] net: phy: fixed_phy: Remove unused seqcount
Date:   Wed,  3 Jun 2020 16:49:45 +0200
Message-Id: <20200603144949.1122421-3-a.darwish@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200603144949.1122421-1-a.darwish@linutronix.de>
References: <20200603144949.1122421-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit bf7afb29d545 ("phy: improve safety of fixed-phy MII register
reading") protected the fixed PHY status with a sequence counter.

Two years later, commit d2b977939b18 ("net: phy: fixed-phy: remove
fixed_phy_update_state()") removed the sequence counter's write side
critical section -- neutralizing its read side retry loop.

Remove the unused seqcount.

Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/phy/fixed_phy.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/phy/fixed_phy.c b/drivers/net/phy/fixed_phy.c
index 4a3d34f40cb9..c4641b1704d6 100644
--- a/drivers/net/phy/fixed_phy.c
+++ b/drivers/net/phy/fixed_phy.c
@@ -19,7 +19,6 @@
 #include <linux/slab.h>
 #include <linux/of.h>
 #include <linux/gpio/consumer.h>
-#include <linux/seqlock.h>
 #include <linux/idr.h>
 #include <linux/netdevice.h>
 #include <linux/linkmode.h>
@@ -34,7 +33,6 @@ struct fixed_mdio_bus {
 struct fixed_phy {
 	int addr;
 	struct phy_device *phydev;
-	seqcount_t seqcount;
 	struct fixed_phy_status status;
 	bool no_carrier;
 	int (*link_update)(struct net_device *, struct fixed_phy_status *);
@@ -80,19 +78,17 @@ static int fixed_mdio_read(struct mii_bus *bus, int phy_addr, int reg_num)
 	list_for_each_entry(fp, &fmb->phys, node) {
 		if (fp->addr == phy_addr) {
 			struct fixed_phy_status state;
-			int s;
 
-			do {
-				s = read_seqcount_begin(&fp->seqcount);
-				fp->status.link = !fp->no_carrier;
-				/* Issue callback if user registered it. */
-				if (fp->link_update)
-					fp->link_update(fp->phydev->attached_dev,
-							&fp->status);
-				/* Check the GPIO for change in status */
-				fixed_phy_update(fp);
-				state = fp->status;
-			} while (read_seqcount_retry(&fp->seqcount, s));
+			fp->status.link = !fp->no_carrier;
+
+			/* Issue callback if user registered it. */
+			if (fp->link_update)
+				fp->link_update(fp->phydev->attached_dev,
+						&fp->status);
+
+			/* Check the GPIO for change in status */
+			fixed_phy_update(fp);
+			state = fp->status;
 
 			return swphy_read_reg(reg_num, &state);
 		}
@@ -150,8 +146,6 @@ static int fixed_phy_add_gpiod(unsigned int irq, int phy_addr,
 	if (!fp)
 		return -ENOMEM;
 
-	seqcount_init(&fp->seqcount);
-
 	if (irq != PHY_POLL)
 		fmb->mii_bus->irq[phy_addr] = irq;
 
-- 
2.20.1

