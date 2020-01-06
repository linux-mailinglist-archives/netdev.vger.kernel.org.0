Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15F01315D5
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 17:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbgAFQOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 11:14:09 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49058 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726448AbgAFQOJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 11:14:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Kzr339+rcjkhSMZt4wHyqq52nwkSHTOwFhgYVyuwDQk=; b=PO7e90v5qJQzSYG9i8hLqUhjLI
        DhTa/c1k2G+C6MYC+0PvJm0g4WHrEToR7mI3FzmjyMgud6DJWtjc/98adJ2vNoNQL/aK3Sxg1zO8/
        cR7u6S5bcVMLVpR4HoBiFG7rCrs86xhe99akR6rzUxVrjCL6hz89m7bj/ijDaylXoGIY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1ioV14-0001BD-9a; Mon, 06 Jan 2020 17:14:06 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>, cphealy@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net-next 5/5] net: dsa: mv88e6xxx: Unique ATU and VTU IRQ names
Date:   Mon,  6 Jan 2020 17:13:52 +0100
Message-Id: <20200106161352.4461-6-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0.rc1
In-Reply-To: <20200106161352.4461-1-andrew@lunn.ch>
References: <20200106161352.4461-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dynamically generate a unique interrupt name for the VTU and ATU,
based on the device name.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.h        | 2 ++
 drivers/net/dsa/mv88e6xxx/global1_atu.c | 5 ++++-
 drivers/net/dsa/mv88e6xxx/global1_vtu.c | 5 ++++-
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index 47fd909fccc2..f332cb4b2fbf 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -300,7 +300,9 @@ struct mv88e6xxx_chip {
 	char watchdog_irq_name[32];
 
 	int atu_prob_irq;
+	char atu_prob_irq_name[32];
 	int vtu_prob_irq;
+	char vtu_prob_irq_name[32];
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work irq_poll_work;
 
diff --git a/drivers/net/dsa/mv88e6xxx/global1_atu.c b/drivers/net/dsa/mv88e6xxx/global1_atu.c
index bdcd25560dd2..bac9a8a68e50 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_atu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_atu.c
@@ -425,9 +425,12 @@ int mv88e6xxx_g1_atu_prob_irq_setup(struct mv88e6xxx_chip *chip)
 	if (chip->atu_prob_irq < 0)
 		return chip->atu_prob_irq;
 
+	snprintf(chip->atu_prob_irq_name, sizeof(chip->atu_prob_irq_name),
+		 "mv88e6xxx-%s-g1-atu-prob", dev_name(chip->dev));
+
 	err = request_threaded_irq(chip->atu_prob_irq, NULL,
 				   mv88e6xxx_g1_atu_prob_irq_thread_fn,
-				   IRQF_ONESHOT, "mv88e6xxx-g1-atu-prob",
+				   IRQF_ONESHOT, chip->atu_prob_irq_name,
 				   chip);
 	if (err)
 		irq_dispose_mapping(chip->atu_prob_irq);
diff --git a/drivers/net/dsa/mv88e6xxx/global1_vtu.c b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
index 33056a609e96..48390b7b18ad 100644
--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -631,9 +631,12 @@ int mv88e6xxx_g1_vtu_prob_irq_setup(struct mv88e6xxx_chip *chip)
 	if (chip->vtu_prob_irq < 0)
 		return chip->vtu_prob_irq;
 
+	snprintf(chip->vtu_prob_irq_name, sizeof(chip->vtu_prob_irq_name),
+		 "mv88e6xxx-%s-g1-vtu-prob", dev_name(chip->dev));
+
 	err = request_threaded_irq(chip->vtu_prob_irq, NULL,
 				   mv88e6xxx_g1_vtu_prob_irq_thread_fn,
-				   IRQF_ONESHOT, "mv88e6xxx-g1-vtu-prob",
+				   IRQF_ONESHOT, chip->vtu_prob_irq_name,
 				   chip);
 	if (err)
 		irq_dispose_mapping(chip->vtu_prob_irq);
-- 
2.25.0.rc1

