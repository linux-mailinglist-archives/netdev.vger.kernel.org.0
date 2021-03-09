Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D27DA332127
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbhCIIq0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:26 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51468 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhCIIpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:45 -0500
Message-Id: <20210309084242.516519290@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=yxUKUiZYjhibc7jZnuln+kQQPBZLvoc8TbB9cqh+HxU=;
        b=Q13IywTH7EUDUibhBHMamY2qhFxsv/BDqx36OJXLf+7Q44Guho/PkLo0IhD0AdtPtW3qgp
        w2kiHcvR7sBVw/aZ3JReCRcyFZlRWt+SuCKHybxLuc74cDc7lHqC324UCJCpOcGS/6Ls3s
        EhLTpsZEXaaEpOv4GY29Z4ou0fNI46qQM53sAOcYIjcXC41/DofN4shGkNo11xWFYmku8q
        +BZPhCPyND4RWjOPYGSjy32KLewEu+5lxFmZiGGM1sxsVMolDqMJf1t6+tL1UQBvIrjFxT
        qbmqFBDlC15LlYGmVcptExHe0laWMEkGcVg5P6122ht1p6DN8f+ltdobyMZ1WQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=yxUKUiZYjhibc7jZnuln+kQQPBZLvoc8TbB9cqh+HxU=;
        b=IP5NQTNugT2CYFrvO7b8n1tyL7nIbQVE2j1mpwhsV2gWriSLkZq1moytqMLibvtQWJzD46
        ea56QlNhvi/NPHAg==
Date:   Tue, 09 Mar 2021 09:42:15 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Rob Herring <robh@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [patch 12/14] PCI: hv: Use tasklet_disable_in_atomic()
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The hv_compose_msi_msg() callback in irq_chip::irq_compose_msi_msg is
invoked via irq_chip_compose_msi_msg(), which itself is always invoked from
atomic contexts from the guts of the interrupt core code.

There is no way to change this w/o rewriting the whole driver, so use
tasklet_disable_in_atomic() which allows to make tasklet_disable()
sleepable once the remaining atomic users are addressed.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Wei Liu <wei.liu@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Rob Herring <robh@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-hyperv@vger.kernel.org
Cc: linux-pci@vger.kernel.org
---
 drivers/pci/controller/pci-hyperv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/pci-hyperv.c
+++ b/drivers/pci/controller/pci-hyperv.c
@@ -1458,7 +1458,7 @@ static void hv_compose_msi_msg(struct ir
 	 * Prevents hv_pci_onchannelcallback() from running concurrently
 	 * in the tasklet.
 	 */
-	tasklet_disable(&channel->callback_event);
+	tasklet_disable_in_atomic(&channel->callback_event);
 
 	/*
 	 * Since this function is called with IRQ locks held, can't

