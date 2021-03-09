Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06DC332122
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbhCIIqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:19 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51468 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230424AbhCIIpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:42 -0500
Message-Id: <20210309084242.313899703@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=l6Q3W/LryXAjvWJbzAW7nw1Byy8ZW+Ak6BqUHfGdIYA=;
        b=wkfrvYWdeSxVkZZvGJrvJ5doa1FQOYEdrs9XtXy+47hkZr79UvWY+m+G9akaJQslI0Hptg
        sYnBZXRXHiw7V+qHXT2/S2jvkbUf9V5/ePXCILMMjFH3RnIgn2E2s1uSQJfYZt1fCK1XtD
        Of9D8bk7Jn0jf6Vpiom/NscjyJnL7uIE/s/W4ZKi2PExELJU0oOnY9lQc2U0/hwoX2RYTN
        aHrp25gQZLqCU9Nj3Xq0qHr8+J9S3Ya78w107pmK4K3X42rqInFgO/e7lGS2qOKPcIcw0w
        dw82CAulutJ4Psg1LyI6T7H3JYhWeQ1K6QVyGJzeEaDxAXlGa69vFi6ASruCrg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279541;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=l6Q3W/LryXAjvWJbzAW7nw1Byy8ZW+Ak6BqUHfGdIYA=;
        b=DTmNItlbUCzhKqosxEh/VQS7S4RBz18lFKbgeCay+vE0IyWWX0E4N9MzEuBG8k5h2jqMWK
        HqURayVmIpwdfoCg==
Date:   Tue, 09 Mar 2021 09:42:13 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
        ath9k-devel@qca.qualcomm.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Denis Kirjanov <kda@linux-powerpc.org>,
        Chas Williams <3chas3@gmail.com>,
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
Subject: [patch 10/14] ath9k: Use tasklet_disable_in_atomic()
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

All callers of ath9k_beacon_ensure_primary_slot() are preemptible /
acquire a mutex except for this callchain:

  spin_lock_bh(&sc->sc_pcu_lock);
  ath_complete_reset()
  -> ath9k_calculate_summary_state()
     -> ath9k_beacon_ensure_primary_slot()

It's unclear how that can be distangled, so use tasklet_disable_in_atomic()
for now. This allows tasklet_disable() to become sleepable once the
remaining atomic users are cleaned up.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: ath9k-devel@qca.qualcomm.com
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
---
 drivers/net/wireless/ath/ath9k/beacon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -251,7 +251,7 @@ void ath9k_beacon_ensure_primary_slot(st
 	int first_slot = ATH_BCBUF;
 	int slot;
 
-	tasklet_disable(&sc->bcon_tasklet);
+	tasklet_disable_in_atomic(&sc->bcon_tasklet);
 
 	/* Find first taken slot. */
 	for (slot = 0; slot < ATH_BCBUF; slot++) {

