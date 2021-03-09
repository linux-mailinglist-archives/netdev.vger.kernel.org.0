Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C40F33211A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbhCIIqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:15 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbhCIIpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:41 -0500
Message-Id: <20210309084242.209110861@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=3OZDZ1PlAIXweh7titVCv+Mhn6QM6oopTZUhKH8n3fI=;
        b=OHqjpGKzuWjP+ej4hd27e5ZqZrmViqn9gk8mqAOiivIPpzrHwdyFNiFKhb6RX2HyHplghe
        CAbm1ecdOgYQd4x7YP2MQPb+tH4KPQ6o0MUrzbYxxI8aRRi2i2nPOkWNuvbOyg61rZ1yo0
        DjJC1WOJiDIRdPk97zbrpQ0bXKnJnOdUu3NaT2ZP+JtjAC/VvVGBFgel3qlOWmrnlVnbgw
        PSg2351Hv8WRE7GmEVPQST7lNGtgE6boyfuDeMjNk+1HiMXw3q3En3ND4s5vLy+pzB7LfK
        2CBwAs4jMqqsgXQKIyJYyGPuJUF1PnOPa/paFgILHa/BvyF3xtK0QIhtfteSbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=3OZDZ1PlAIXweh7titVCv+Mhn6QM6oopTZUhKH8n3fI=;
        b=o9tIrGOpSVQUSJ1YQqLXROg6bjTxJYKvkYRgEtPlvtrNy6s6CHuYZDrzd8nr4wFP+zYF0n
        C0xlpPo2jMwMG+DA==
Date:   Tue, 09 Mar 2021 09:42:12 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
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
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [patch 09/14] net: sundance: Use tasklet_disable_in_atomic().
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

tasklet_disable() is used in the timer callback. This might be distangled,
but without access to the hardware that's a bit risky.

Replace it with tasklet_disable_in_atomic() so tasklet_disable() can be
changed to a sleep wait once all remaining atomic users are converted.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Denis Kirjanov <kda@linux-powerpc.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 drivers/net/ethernet/dlink/sundance.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/dlink/sundance.c
+++ b/drivers/net/ethernet/dlink/sundance.c
@@ -963,7 +963,7 @@ static void tx_timeout(struct net_device
 	unsigned long flag;
 
 	netif_stop_queue(dev);
-	tasklet_disable(&np->tx_tasklet);
+	tasklet_disable_in_atomic(&np->tx_tasklet);
 	iowrite16(0, ioaddr + IntrEnable);
 	printk(KERN_WARNING "%s: Transmit timed out, TxStatus %2.2x "
 		   "TxFrameId %2.2x,"

