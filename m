Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E624F197DC5
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 16:01:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbgC3OBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 10:01:40 -0400
Received: from mx1.tq-group.com ([62.157.118.193]:24401 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727390AbgC3OBj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 10:01:39 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Mar 2020 10:01:37 EDT
IronPort-SDR: l6c8d4ufmHTFlol9w4egC0tFWAAggT8Ue4+UFH01FKJta4iAKUZm6LIeBJnE01aierZW+Fuia1
 HBktNyVeNULwudAqq9EktOfEiEeR9Ib8BwsUzvrLdERymVtAw/adzZZILiR9r5TIrf6/s3x0yh
 rGRxc6cp2Da0XMdOFP1kQigOH2NLCEv2sgYpoR2XKN4CmZLwDgPPayQSOyHY1Xu0nDU/KINIlo
 NwnJ0GBEnJTSIlIRYybDMKdK2YZqOEbO2XzCU9wORWE8lXOB5gBs8k+0n8ymwy1i04+Z5vbDti
 A6Q=
X-IronPort-AV: E=Sophos;i="5.72,324,1580770800"; 
   d="scan'208";a="11606918"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 30 Mar 2020 15:54:28 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Mon, 30 Mar 2020 15:54:28 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Mon, 30 Mar 2020 15:54:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1585576468; x=1617112468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=po89PzaA6MKZBpJ/RTQTIsqag9iwZ1Wmc6kMxkfYtkk=;
  b=Dcko6Av78DGjCMu57BZG+4QC2ukRKqTff/Vn/tp0KtBTDPBIhG+8GDNE
   0SWFqRg0RMhKf1Z6EIw/z/pzZBR8HfpdxxoFc8dTnLYFo/q0/LHc+TjJq
   kM+NCMYxTMOQE5cdfjRiz2v9VzjgyzRIhyyfzuoQ48OlWcYBtE6vs3gIg
   a+nxgAl+E/Ecz6/C/hOV3oCBWC3/lh/ZtmJDx7Sp/03Yd38pr+l/+cmF8
   +H6abv1YF76yKXtD3SjV6moeUCY0JFw+xJTgvFZOYRJB/zkmTlsaFPMRB
   Ryl7en6XiDa+8HW7uYd1W5bCyh+J/GziV78Ol3wOZsIb9xJL0awrKGsn8
   Q==;
IronPort-SDR: EeKZZ6vDx2l67ZyrQH8h+LQ2Q63oXjRZ56gxaDTE5ijPrUOkTM7NMFRToneC/heXFFK/zggDOG
 Iw8eH890PZ2sOSTdZ5nfHlG0G8gEklp+zXgnFFfuS6FOEul7zsebucN/N2Z6zfs1qTFRL3jlpB
 kCjwo4cgakkQ5XcrzhoLLSAiSWD7cRywGTC3uX87/VVAu9R1p51F2DP4ltsUAox+TN+O7MjdaA
 BXNjhbDZeGrcBl1AX2b760M6DTZQvPBkdKL8ss4SsQLrayWtKOWvxa+na8+qVL23PU34boG4xD
 Wa4=
X-IronPort-AV: E=Sophos;i="5.72,324,1580770800"; 
   d="scan'208";a="11606917"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 30 Mar 2020 15:54:28 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.117.49.26])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id EF068280070;
        Mon, 30 Mar 2020 15:54:32 +0200 (CEST)
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Subject: [PATCH net-next 2/4] net: dsa: mv88e6xxx: account for PHY base address offset in dual chip mode
Date:   Mon, 30 Mar 2020 15:53:43 +0200
Message-Id: <20200330135345.4361-2-matthias.schiffer@ew.tq-group.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
References: <20200330135345.4361-1-matthias.schiffer@ew.tq-group.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
index e5430cf2ad71..88c148a62366 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -257,6 +257,7 @@ struct mv88e6xxx_chip {
 	const struct mv88e6xxx_bus_ops *smi_ops;
 	struct mii_bus *bus;
 	int sw_addr;
+	unsigned int phy_base_addr;
 
 	/* Handles automatic disabling and re-enabling of the PHY
 	 * polling unit.
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 8fd483020c5b..3c3dfaf16882 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1156,7 +1156,7 @@ int mv88e6xxx_g2_irq_mdio_setup(struct mv88e6xxx_chip *chip,
 			err = irq;
 			goto out;
 		}
-		bus->irq[chip->info->phy_base_addr + phy] = irq;
+		bus->irq[chip->phy_base_addr + phy] = irq;
 	}
 	return 0;
 out:
diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 282fe08db050..a62d7b8702d5 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -175,5 +175,9 @@ int mv88e6xxx_smi_init(struct mv88e6xxx_chip *chip,
 	chip->bus = bus;
 	chip->sw_addr = sw_addr;
 
+	chip->phy_base_addr = chip->info->phy_base_addr;
+	if (chip->info->dual_chip)
+		chip->phy_base_addr += sw_addr;
+
 	return 0;
 }
-- 
2.17.1

