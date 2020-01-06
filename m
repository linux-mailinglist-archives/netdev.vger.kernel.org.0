Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02541315DE
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:14:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgAFQOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:14:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49098 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgAFQOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:14:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0wLXNoZPDimZxyQYwgvxusjzaSLSRoXgIQyGxXz/4d4=; b=pw8OuoC9hw72+lpEQ5eEC/NZQz
        2IVP/F8pe6Mce49zv5eIoyXysLiWmPcA7cMaaNbxcEFLJ7VIlfawdrwUOyohJcTwUNHVqBy7ILzMW
        H+0Dc5RoHAeU/IkLoxk5ztU9/mvHkLzLBrZmXZy2mRNtLWT2lQ45p44g6ZSJ0Qz5Pj3E=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioV13-0001At-TR; Mon, 06 Jan 2020 17:14:05 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, cphealy@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 1/5] net: dsa: mv88e6xxx: Unique IRQ name
Date:   Mon,  6 Jan 2020 17:13:48 +0100
Message-Id: <20200106161352.4461-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200106161352.4461-1-andrew@lunn.ch>
References: <20200106161352.4461-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique switch interrupt name, based on the
device name.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 5 ++++-
 drivers/net/dsa/mv88e6xxx/chip.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5eeeb6566196..e21e460c11f7 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -340,11 +340,14 @@ static int mv88e6xxx_g1_irq_setup(struct mv88e6xxx_chip *chip)
 	 */
 	irq_set_lockdep_class(chip->irq, &lock_key, &request_key);
 
+	snprintf(chip->irq_name, sizeof(chip->irq_name),
+		 "mv88e6xxx-%s", dev_name(chip->dev));
+
 	mv88e6xxx_reg_unlock(chip);
 	err = request_threaded_irq(chip->irq, NULL,
 				   mv88e6xxx_g1_irq_thread_fn,
 				   IRQF_ONESHOT | IRQF_SHARED,
-				   dev_name(chip->dev), chip);
+				   chip->irq_name, chip);
 	mv88e6xxx_reg_lock(chip);
 	if (err)
 		mv88e6xxx_g1_irq_free_common(chip);
diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 8a8e38bfb161..03aec58513ab 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -292,6 +292,7 @@ struct mv88e6xxx_chip {
 	struct mv88e6xxx_irq g1_irq;
 	struct mv88e6xxx_irq g2_irq;
 	int irq;
+	char irq_name[32];
 	int device_irq;
 	int watchdog_irq;
 
-- 
2.25.0.rc1

