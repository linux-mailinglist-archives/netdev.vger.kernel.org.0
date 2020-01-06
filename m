Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C76831315DC
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgAFQOd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:14:33 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49078 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgAFQOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:14:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=5FhtFxyxa3sgbU/XV3vxTVVERCJfGRLk31fvq+zo9Rs=; b=4SVJPc7oigutu9IYdDx/zucqGx
        cCVcMEsuQ3R2vBKZPe9Iy9jH6ungTvCztNM49qApaEusgYmq74NQZQKHS1nPld4QePHqb0MpJ743Z
        wrA2hFWhAoH4e3MQOwji6qlIxZFBb1pxeSbZu3Zea8O8pvCVk4BUT0jRHh+nsJY2vz08=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioV14-0001Ay-14; Mon, 06 Jan 2020 17:14:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, cphealy@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 2/5] net: dsa: mv88e6xxx: Unique SERDES interrupt names
Date:   Mon,  6 Jan 2020 17:13:49 +0100
Message-Id: <20200106161352.4461-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200106161352.4461-1-andrew@lunn.ch>
References: <20200106161352.4461-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique SERDES interrupt name, based on the
device name and the port the SERDES is for. For example:

 95:          3  mv88e6xxx-g2   9 Edge      mv88e6xxx-0.2:00-serdes-9
 96:          0  mv88e6xxx-g2  10 Edge      mv88e6xxx-0.2:00-serdes-10

The 0.2:00 indicates the switch and -9 indicates port 9.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 6 +++++-
 drivers/net/dsa/mv88e6xxx/chip.h | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index e21e460c11f7..99816ca9e5e4 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2306,10 +2306,14 @@ static int mv88e6xxx_serdes_irq_request(struct mv88e6xxx_chip *chip, int port,
 	if (!irq)
 		return 0;
 
+	snprintf(dev_id->serdes_irq_name, sizeof(dev_id->serdes_irq_name),
+		 "mv88e6xxx-%s-serdes-%d", dev_name(chip->dev), port);
+
 	/* Requesting the IRQ will trigger IRQ callbacks, so release the lock */
 	mv88e6xxx_reg_unlock(chip);
 	err = request_threaded_irq(irq, NULL, mv88e6xxx_serdes_irq_thread_fn,
-				   IRQF_ONESHOT, "mv88e6xxx-serdes", dev_id);
+				   IRQF_ONESHOT, dev_id->serdes_irq_name,
+				   dev_id);
 	mv88e6xxx_reg_lock(chip);
 	if (err)
 		return err;
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 03aec58513ab..b7613ef600d2 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -236,6 +236,7 @@ struct mv88e6xxx_port {
 	bool mirror_ingress;
 	bool mirror_egress;
 	unsigned int serdes_irq;
+	char serdes_irq_name[32];
 };
 
 struct mv88e6xxx_chip {
-- 
2.25.0.rc1

