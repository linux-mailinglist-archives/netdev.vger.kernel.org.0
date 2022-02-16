Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 131CE4B83B0
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231919AbiBPJJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:09:08 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbiBPJJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EE1289B3;
        Wed, 16 Feb 2022 01:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0471B81D4D;
        Wed, 16 Feb 2022 09:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2F4C340ED;
        Wed, 16 Feb 2022 09:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645002531;
        bh=+gImVgn+psIKjeLVL98uEnM5hThrgobcx/W+sXGKkb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=drW/XExEl75IfRPeJK1st1gzdg1hobjuGOuCaX4mXla6gHEDWiA0QHQYWSF2iJ80w
         4aoldhFKjCKNA5hAMmMi3oF2zpvJbHbmEH18+Q6Xc01Gnrkr1f+KCsgGZdHHcEOWnO
         OkZg7DGOTnrqrnQgOBF0N8hBW+fNQHn+fSOYYGFnKQMy2+nCux6GOyLDPgEmfwUwto
         Cr7c1yUOVoZPvHzShYsTcSWIC14wR5BlthwyBIWo15U/Ir5nmB5muJqqT/s9sGFV0W
         akayIAetH7sX12ECYF085MCeuxX51Wr+Bbr0HdForANUAFB6nigekoQH+zHFwXHOBP
         HFMvMAd/sOO6g==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKGIr-008HM9-IG; Wed, 16 Feb 2022 09:08:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Subject: [PATCH 2/2] net: mvpp2: Convert to managed interrupts to fix CPU HP issues
Date:   Wed, 16 Feb 2022 09:08:45 +0000
Message-Id: <20220216090845.1278114-3-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220216090845.1278114-1-maz@kernel.org>
References: <20220216090845.1278114-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@linuxfoundation.org, mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org, tglx@linutronix.de, john.garry@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The MVPP2 driver uses a set of per-CPU interrupts and relies on
each particular interrupt to fire *only* on the CPU it has been
assigned to.

Although the affinity setting is restricted to prevent userspace
to move interrupts around, this all falls apart when using CPU
hotplug, as this breaks the affinity. Depending on how lucky you
are, the interrupt will then scream on the wrong CPU, eventually
leading to an ugly crash.

Ideally, the interrupt assigned to a given CPU would simply be left
where it is, only masked when the CPU goes down, and brought back
up when the CPU is alive again. As it turns out, this is the model
used for most multi-queue devices, and we'd be better off using it
for the MVPP2 driver.

Drop the home-baked affinity settings in favour of the ready-made
irq_set_affinity_masks() helper, making things slightly simpler.

With this change, the driver able to sustain CPUs being taken away.
What is still missing is a way to tell the device that it should
stop sending traffic to a given CPU.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h    |  1 -
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 67 ++++++++++---------
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
index ad73a488fc5f..86f8feaf5350 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2.h
@@ -1143,7 +1143,6 @@ struct mvpp2_queue_vector {
 	int nrxqs;
 	u32 pending_cause_rx;
 	struct mvpp2_port *port;
-	struct cpumask *mask;
 };
 
 /* Internal represention of a Flow Steering rule */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 7cdbf8b8bbf6..cdc519583e86 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4674,49 +4674,54 @@ static void mvpp21_get_mac_address(struct mvpp2_port *port, unsigned char *addr)
 
 static int mvpp2_irqs_init(struct mvpp2_port *port)
 {
-	int err, i;
+	struct irq_affinity affd = {
+		/* No pre/post-vectors, single set */
+	};
+	int err, i, nvec, *irqs;
 
-	for (i = 0; i < port->nqvecs; i++) {
+	for (i = nvec = 0; i < port->nqvecs; i++) {
 		struct mvpp2_queue_vector *qv = port->qvecs + i;
 
-		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE) {
-			qv->mask = kzalloc(cpumask_size(), GFP_KERNEL);
-			if (!qv->mask) {
-				err = -ENOMEM;
-				goto err;
-			}
+		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE)
+			nvec++;
+	}
 
-			irq_set_status_flags(qv->irq, IRQ_NO_BALANCING);
-		}
+	irqs = kmalloc(sizeof(*irqs) * nvec, GFP_KERNEL);
+	if (!irqs)
+		return -ENOMEM;
 
-		err = request_irq(qv->irq, mvpp2_isr, 0, port->dev->name, qv);
-		if (err)
-			goto err;
+	for (i = 0; i < port->nqvecs; i++) {
+		struct mvpp2_queue_vector *qv = port->qvecs + i;
 
-		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE) {
-			unsigned int cpu;
+		if (qv->type == MVPP2_QUEUE_VECTOR_PRIVATE)
+			irqs[i] = qv->irq;
+	}
 
-			for_each_present_cpu(cpu) {
-				if (mvpp2_cpu_to_thread(port->priv, cpu) ==
-				    qv->sw_thread_id)
-					cpumask_set_cpu(cpu, qv->mask);
-			}
+	err = irq_set_affinity_masks(&affd, irqs, nvec);
+	if (err)
+		goto err;
 
-			irq_set_affinity_hint(qv->irq, qv->mask);
+	for (i = 0; i < port->nqvecs; i++) {
+		struct mvpp2_queue_vector *qv = port->qvecs + i;
+
+		err = request_irq(qv->irq, mvpp2_isr, 0, port->dev->name, qv);
+		if (err) {
+			nvec = i;
+			break;
 		}
 	}
 
-	return 0;
-err:
-	for (i = 0; i < port->nqvecs; i++) {
-		struct mvpp2_queue_vector *qv = port->qvecs + i;
+	if (err) {
+		for (i = 0; i < nvec; i++) {
+			struct mvpp2_queue_vector *qv = port->qvecs + i;
 
-		irq_set_affinity_hint(qv->irq, NULL);
-		kfree(qv->mask);
-		qv->mask = NULL;
-		free_irq(qv->irq, qv);
+			free_irq(qv->irq, qv);
+		}
 	}
 
+err:
+	kfree(irqs);
+
 	return err;
 }
 
@@ -4727,10 +4732,6 @@ static void mvpp2_irqs_deinit(struct mvpp2_port *port)
 	for (i = 0; i < port->nqvecs; i++) {
 		struct mvpp2_queue_vector *qv = port->qvecs + i;
 
-		irq_set_affinity_hint(qv->irq, NULL);
-		kfree(qv->mask);
-		qv->mask = NULL;
-		irq_clear_status_flags(qv->irq, IRQ_NO_BALANCING);
 		free_irq(qv->irq, qv);
 	}
 }
-- 
2.30.2

