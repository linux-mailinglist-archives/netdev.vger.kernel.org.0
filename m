Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F71B514C2C
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 16:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376993AbiD2OHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 10:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377050AbiD2OGy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 10:06:54 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC56941A8
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 06:55:20 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1651240465; h=from:from:reply-to:subject:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type; bh=KX94rVVeut3wHX2/VemxEKyeP6SfnePyS21Z4cm2+mI=;
        b=FJJoweXu6GR2IIsls1eLnZCuudOIYEErttCgVFbXQqYvMMMMxdkBRjW5Nu6XfqXTYsb5xd
        nUd8p6vMHI0sVcnAZe7U0DucAyxhp/CEIXABRSg4v1GQysRVewmNY/t2VMBSiCOC41eKJ0
        tm5gSZJ00AoeFJzEbVtoDW6SaAsApXQFrq/lzbCmDospogG6dtiLhcxWNG34JWna2Wb2kX
        +IDaNu9zLUEOoWl9fUJSSVjs1EDpeeHM2ABKPYwZw8Uz0kipsJFh614m/eq7eo2axG3/d+
        lX9n2yf1TwUJsQ/Db1aefrSakkLM4OcH9QIie/CMfhIPN4/iZFQtMiEbJRLp+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1651240465; h=from:from:reply-to:subject:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type; bh=KX94rVVeut3wHX2/VemxEKyeP6SfnePyS21Z4cm2+mI=;
        b=8qCnqiKn1uLTlVVXwBPRIw/9mN2rOUuMQCgT/8tW92IMAXwQi/Ulv5zRG6pOCr2qr0bAmE
        lg2j+8jGhwSJ/HDQ==
To:     Ondrej Mosnacek <omosnace@redhat.com>
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH] net: thunderx: Do not invoke pci_irq_vector() from
 interrupt context
Subject: 
Date:   Fri, 29 Apr 2022 15:54:24 +0200
Message-ID: <87r15gngfj.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

pci_irq_vector() can't be used in atomic context any longer. This conflicts
with the usage of this function in nic_mbx_intr_handler().

Cache the Linux interrupt numbers in struct nicpf and use that cache in the
interrupt handler to select the mailbox.

Fixes: 495c66aca3da ("genirq/msi: Convert to new functions")
Reported-by: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Sunil Goutham <sgoutham@marvell.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2041772
---
 drivers/net/ethernet/cavium/thunder/nic_main.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -59,7 +59,7 @@ struct nicpf {
 
 	/* MSI-X */
 	u8			num_vec;
-	bool			irq_allocated[NIC_PF_MSIX_VECTORS];
+	unsigned int		irq_allocated[NIC_PF_MSIX_VECTORS];
 	char			irq_name[NIC_PF_MSIX_VECTORS][20];
 };
 
@@ -1150,7 +1150,7 @@ static irqreturn_t nic_mbx_intr_handler(
 	u64 intr;
 	u8  vf;
 
-	if (irq == pci_irq_vector(nic->pdev, NIC_PF_INTR_ID_MBOX0))
+	if (irq == nic->irq_allocated[NIC_PF_INTR_ID_MBOX0])
 		mbx = 0;
 	else
 		mbx = 1;
@@ -1176,14 +1176,14 @@ static void nic_free_all_interrupts(stru
 
 	for (irq = 0; irq < nic->num_vec; irq++) {
 		if (nic->irq_allocated[irq])
-			free_irq(pci_irq_vector(nic->pdev, irq), nic);
-		nic->irq_allocated[irq] = false;
+			free_irq(nic->irq_allocated[irq], nic);
+		nic->irq_allocated[irq] = 0;
 	}
 }
 
 static int nic_register_interrupts(struct nicpf *nic)
 {
-	int i, ret;
+	int i, ret, irq;
 	nic->num_vec = pci_msix_vec_count(nic->pdev);
 
 	/* Enable MSI-X */
@@ -1201,13 +1201,13 @@ static int nic_register_interrupts(struc
 		sprintf(nic->irq_name[i],
 			"NICPF Mbox%d", (i - NIC_PF_INTR_ID_MBOX0));
 
-		ret = request_irq(pci_irq_vector(nic->pdev, i),
-				  nic_mbx_intr_handler, 0,
+		irq = pci_irq_vector(nic->pdev, i);
+		ret = request_irq(irq, nic_mbx_intr_handler, 0,
 				  nic->irq_name[i], nic);
 		if (ret)
 			goto fail;
 
-		nic->irq_allocated[i] = true;
+		nic->irq_allocated[i] = irq;
 	}
 
 	/* Enable mailbox interrupt */
