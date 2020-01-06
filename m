Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53341315DA
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgAFQOU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:14:20 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgAFQOQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:14:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+FX/B2OJdUaPvrHtW7p3ZC8yjntE1pHSfomAjRCful4=; b=xwvROvoGVB7oSpaW1QhSAErMnf
        BuifdzARvsekoTkueVmLk4EJIfkCFCmOh+LShsba3w+1bDIiLnpnOq+W413S8hMWUGFQ9vU7O5Zb4
        MN/Nbd1U3k5CBc2mFzftl1reGQdwSYqJn8ZU4AJs6+wstNwVIe5Jozpu9KBDClorQ07M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioV14-0001B8-6m; Mon, 06 Jan 2020 17:14:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, cphealy@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Unique g2 IRQ name
Date:   Mon,  6 Jan 2020 17:13:51 +0100
Message-Id: <20200106161352.4461-5-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200106161352.4461-1-andrew@lunn.ch>
References: <20200106161352.4461-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique g2 interrupt name, based on the
device name.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.h    | 1 +
 drivers/net/dsa/mv88e6xxx/global2.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 3558c677e1d3..47fd909fccc2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -295,6 +295,7 @@ struct mv88e6xxx_chip {
 	int irq;
 	char irq_name[32];
 	int device_irq;
+	char device_irq_name[32];
 	int watchdog_irq;
 	char watchdog_irq_name[32];
 
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 617174e94faa..01503014b1ee 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -1117,9 +1117,12 @@ int mv88e6xxx_g2_irq_setup(struct mv88e6xxx_chip *chip)
 		goto out;
 	}
 
+	snprintf(chip->device_irq_name, sizeof(chip->device_irq_name),
+		 "mv88e6xxx-%s-g2", dev_name(chip->dev));
+
 	err = request_threaded_irq(chip->device_irq, NULL,
 				   mv88e6xxx_g2_irq_thread_fn,
-				   IRQF_ONESHOT, "mv88e6xxx-g2", chip);
+				   IRQF_ONESHOT, chip->device_irq_name, chip);
 	if (err)
 		goto out;
 
-- 
2.25.0.rc1

