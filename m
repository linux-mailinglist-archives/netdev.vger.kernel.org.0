Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6077A332126
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbhCIIqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:23 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51322 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbhCIIpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:43 -0500
Message-Id: <20210309084242.415583839@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=QGpDfJMmIlACx05EM2bvuZB38xRW2f8VO628eoWh8rs=;
        b=ZPPTU832YYY3DB5bNt/1hbd+LTin0b21UuB+bOwFJWUlHhEek9cGKByRTNzYAr7Snrynx8
        Q3cQeFv1TdHNsWclb9ML6GsTk0XnBu66XRnJx0xKJAa2FsfJgB9aemHbcfMOHByQXJ+5mz
        pfgIw57fa0RqtWjPq4sbjsTIS9LG23r5sUeQxkSOP9i622HZ7aIyW9FwO+bQXhcOF2Tl2F
        uM4ewrlYRxcuEJOen8YYySETwpa5AhmuSH/p9pCuxzUGwqryk9YIHkJpFnKwan99X6M6dY
        tqy+gR5bYO7qMlT8IhX/xBDxEOtIt8+7gkkhMktGDDcLjXmcG0oopYKufm+wSQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279542;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=QGpDfJMmIlACx05EM2bvuZB38xRW2f8VO628eoWh8rs=;
        b=QPBa77aA1llDmSjFe4gs4pYWyd/5xnN8oPYCQFBpl1rPtJDQokKJpFiaqMjegedA/WihG9
        gtjUJGH5B1Kd6iCQ==
Date:   Tue, 09 Mar 2021 09:42:14 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        Chas Williams <3chas3@gmail.com>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, ath9k-devel@qca.qualcomm.com,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
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
Subject: [patch 11/14] atm: eni: Use tasklet_disable_in_atomic() in the send()
 callback
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The atmdev_ops::send callback which calls tasklet_disable() is invoked with
bottom halfs disabled from net_device_ops::ndo_start_xmit(). All other
invocations of tasklet_disable() in this driver happen in preemptible
context.

Change the send() call to use tasklet_disable_in_atomic() which allows
tasklet_disable() to be made sleepable once the remaining atomic context
usage sites are cleaned up.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Chas Williams <3chas3@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net
Cc: netdev@vger.kernel.org
---
 drivers/atm/eni.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -2054,7 +2054,7 @@ static int eni_send(struct atm_vcc *vcc,
 	}
 	submitted++;
 	ATM_SKB(skb)->vcc = vcc;
-	tasklet_disable(&ENI_DEV(vcc->dev)->task);
+	tasklet_disable_in_atomic(&ENI_DEV(vcc->dev)->task);
 	res = do_tx(skb);
 	tasklet_enable(&ENI_DEV(vcc->dev)->task);
 	if (res == enq_ok) return 0;

