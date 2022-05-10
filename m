Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC95219E9
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 15:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236572AbiEJNw3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 09:52:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245144AbiEJNr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 09:47:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 560CB2C13CB;
        Tue, 10 May 2022 06:35:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D7172618A0;
        Tue, 10 May 2022 13:35:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84E9C385A6;
        Tue, 10 May 2022 13:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189726;
        bh=/avtzuZvfnMi1NnIu7uKKrjB03sJRY+GFZrwoZkIdA4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+3Bcslfp2vl5Ycev8DQ5k/6ogIVZdy33DMSHSGOHwsXOamhkfhWvy3TdRLKbbC6E
         1d0WPvWqYVeYK3qvTo5TCnQs7wci2gSKKWOvmfyaCeYBKrSU+X06ea2VwVuL/60XFH
         O2mV2dbLrqCYHpdMkrImzuAdaCmvIaehSvjnJgpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH 5.17 001/140] pci_irq_vector() cant be used in atomic context any longer. This conflicts with the usage of this function in nic_mbx_intr_handler(). =?UTF-8?q?age=20of=20this=20function=20in=20nic=5Fmbx=5Fintr=5Fhandler().?=
Date:   Tue, 10 May 2022 15:06:31 +0200
Message-Id: <20220510130741.644300046@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 6b292a04c694573a302686323fe15b1c7e673e5b upstream.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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


