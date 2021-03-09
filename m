Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77F3E332129
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhCIIq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230476AbhCIIpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:46 -0500
Message-Id: <20210309084242.616379058@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=tlyvAn/iLsnm16cCofFKPPKUvuYjwP7bNofYqMtepoU=;
        b=Qlzwohm0ky1Wc0yoAaFc1u7qAxUQot4tEXPvu5fFgMXwl8en8cJNZqPLoDOXlh+yWNCdyA
        7CvuQrdNx8rNz1AfWKfp7iu7JJI1fARHIfbiCBh2Y7QoujPJ7jd7/iZILi+8hg/MuJBtQ6
        sf5gHlbIZy7sEnj16W1LaivwXrHTx2iphw7GtshoGLN+aI4O3nEKodZtfrYcJGpNa4w3Jk
        tsk7W6FG48rHe17gdBaF1k4TwBMZme3Yvx+GPES6K6c5/jDZ2DuFBthglaOQNKxfvdnaNT
        iyeBbpnMxyky1tIueNyKNnDmJtLJdAjMJ+LU9+DUS+5LSqiWsRhRbbyjQenOTg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279544;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=tlyvAn/iLsnm16cCofFKPPKUvuYjwP7bNofYqMtepoU=;
        b=4uviCJ31waHDVyHXuUlHnZ6PNw0FIonj8rD9WJzrc5m+wDPM7Ai550CdyaMdzhAP03Jqt1
        Ixw9TwLF4CvNbACg==
Date:   Tue, 09 Mar 2021 09:42:16 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [patch 13/14] firewire: ohci: Use tasklet_disable_in_atomic() where required
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

tasklet_disable() is invoked in several places. Some of them are in atomic
context which prevents a conversion of tasklet_disable() to a sleepable
function.

The atomic callchains are:

 ar_context_tasklet()
   ohci_cancel_packet()
     tasklet_disable()

 ...
   ohci_flush_iso_completions()
     tasklet_disable()

The invocation of tasklet_disable() from at_context_flush() is always in
preemptible context.

Use tasklet_disable_in_atomic() for the two invocations in
ohci_cancel_packet() and ohci_flush_iso_completions().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net
---
 drivers/firewire/ohci.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -2545,7 +2545,7 @@ static int ohci_cancel_packet(struct fw_
 	struct driver_data *driver_data = packet->driver_data;
 	int ret = -ENOENT;
 
-	tasklet_disable(&ctx->tasklet);
+	tasklet_disable_in_atomic(&ctx->tasklet);
 
 	if (packet->ack != 0)
 		goto out;
@@ -3465,7 +3465,7 @@ static int ohci_flush_iso_completions(st
 	struct iso_context *ctx = container_of(base, struct iso_context, base);
 	int ret = 0;
 
-	tasklet_disable(&ctx->context.tasklet);
+	tasklet_disable_in_atomic(&ctx->context.tasklet);
 
 	if (!test_and_set_bit_lock(0, &ctx->flushing_completions)) {
 		context_tasklet((unsigned long)&ctx->context);

