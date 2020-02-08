Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD11156543
	for <lists+netdev@lfdr.de>; Sat,  8 Feb 2020 16:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgBHPyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Feb 2020 10:54:47 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:39050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727340AbgBHPyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Feb 2020 10:54:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fFfSxoQPhL/uEo/oe0USyGFtICrLfNxYGxf39o4OMJs=; b=5Vv6IArus/hqpqjcvweoR/UNI9
        +CmTiZjXymfLuRx2lEiQUzsfMyz0bin70YiydkMUPPsNGbl+7osRC5WOFGqT9jzz4ENLb2V5HQars
        oIn/Qe/OY1JgFfH+QDjYbT5XejT/wYU2hatO+OEOKZAusiZB8bti98FYJMOVLDYf5CPY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1j0SRP-0008Vq-3O; Sat, 08 Feb 2020 16:54:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        Lucas Stach <l.stach@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: dsa: mv88e6xxx: Prevent truncation of longer interrupt names
Date:   Sat,  8 Feb 2020 16:54:32 +0100
Message-Id: <20200208155432.32680-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When adding support for unique interrupt names, after testing on a few
devices, it was assumed 32 characters would be sufficient. This
assumption turned out to be incorrect, ZII RDU2 for example uses a
device base name of mv88e6xxx-30be0000.ethernet-1:0, leaving no space
for post fixes such as -g1-atu-prob and -watchdog. The names then
become identical, defeating the point of the patch.

Increase the length of the string to 64 charactoes.

Reported-by: Chris Healy <Chris.Healy@zii.aero>
Fixes: 3095383a8ab4 ("net: dsa: mv88e6xxx: Unique IRQ name")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
index f332cb4b2fbf..79cad5e751c6 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.h
+++ b/drivers/net/dsa/mv88e6xxx/chip.h
@@ -236,7 +236,7 @@ struct mv88e6xxx_port {
 	bool mirror_ingress;
 	bool mirror_egress;
 	unsigned int serdes_irq;
-	char serdes_irq_name[32];
+	char serdes_irq_name[64];
 };
 
 struct mv88e6xxx_chip {
@@ -293,16 +293,16 @@ struct mv88e6xxx_chip {
 	struct mv88e6xxx_irq g1_irq;
 	struct mv88e6xxx_irq g2_irq;
 	int irq;
-	char irq_name[32];
+	char irq_name[64];
 	int device_irq;
-	char device_irq_name[32];
+	char device_irq_name[64];
 	int watchdog_irq;
-	char watchdog_irq_name[32];
+	char watchdog_irq_name[64];
 
 	int atu_prob_irq;
-	char atu_prob_irq_name[32];
+	char atu_prob_irq_name[64];
 	int vtu_prob_irq;
-	char vtu_prob_irq_name[32];
+	char vtu_prob_irq_name[64];
 	struct kthread_worker *kworker;
 	struct kthread_delayed_work irq_poll_work;
 
-- 
2.25.0

