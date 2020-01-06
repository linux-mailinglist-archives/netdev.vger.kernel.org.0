Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20A61315DF
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgAFQO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:14:57 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgAFQO4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:14:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=otUrMLUKr9fhW/G2zxf5XgECHUxbwOFj1b3VYT69M/0=; b=jmmSgLB4JIlNcICIyY282Ht5nj
        wYbjguBLkpeonHxFPoMnZ3RR+SQa2xAzVSd686NctqjNwOtgkDXvzX02dWkZJoQZYENcB0dTs1ulR
        hGtL+uA8J/kzg7uJCYVZtt/eEw5t1UZLshpIzzystwhkI/qCV6qjZr4JglrotdBE2rlI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioV14-0001B3-4L; Mon, 06 Jan 2020 17:14:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, cphealy@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Unique watchdog IRQ name
Date:   Mon,  6 Jan 2020 17:13:50 +0100
Message-Id: <20200106161352.4461-4-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200106161352.4461-1-andrew@lunn.ch>
References: <20200106161352.4461-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique watchdog interrupt name, based on the
device name.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.h    | 1 +
 drivers/net/dsa/mv88e6xxx/global2.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index b7613ef600d2..3558c677e1d3 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -296,6 +296,7 @@ struct mv88e6xxx_chip {
 	char irq_name[32];
 	int device_irq;
 	int watchdog_irq;
+	char watchdog_irq_name[32];
 
 	int atu_prob_irq;
 	int vtu_prob_irq;
diff --git a/drivers/net/dsa/mv88e6xxx/global2.c b/drivers/net/dsa/mv88e6xxx/global2.c
index 87bfe7c8c9cd..617174e94faa 100644
--- a/drivers/net/dsa/mv88e6xxx/global2.c
+++ b/drivers/net/dsa/mv88e6xxx/global2.c
@@ -948,10 +948,13 @@ static int mv88e6xxx_g2_watchdog_setup(struct mv88e6xxx_chip *chip)
 	if (chip->watchdog_irq < 0)
 		return chip->watchdog_irq;
 
+	snprintf(chip->watchdog_irq_name, sizeof(chip->watchdog_irq_name),
+		 "mv88e6xxx-%s-watchdog", dev_name(chip->dev));
+
 	err = request_threaded_irq(chip->watchdog_irq, NULL,
 				   mv88e6xxx_g2_watchdog_thread_fn,
 				   IRQF_ONESHOT | IRQF_TRIGGER_FALLING,
-				   "mv88e6xxx-watchdog", chip);
+				   chip->watchdog_irq_name, chip);
 	if (err)
 		return err;
 
-- 
2.25.0.rc1

