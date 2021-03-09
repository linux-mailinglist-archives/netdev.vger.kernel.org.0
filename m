Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCF73320FF
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbhCIIpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:45:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51208 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbhCIIpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:31 -0500
Message-Id: <20210309084241.249343366@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=iaFdsa84zN1qKIHuuoUkYKtunZ9pM939i3ed8fPSgwU=;
        b=XEwGzZxDVBQvC/wL/umlG31QWnGTA4V4F7MELMLkdc2BEOXbsPQiX54Yo5seMvS2UQuP8F
        SDFc4SgeP/nMsMdcJ0f4NRHQ/9hB1pSHJnZ22vjWsEjzSWlC0/gL8Rr2ym/gbjPZ8oV9SN
        aP8oIsFhSXCykPH7L55q6Tr4q0VKdBC/l4MgsgP6GfYww4fH8mwy8vwNOa8v4Z57jRRvst
        TgLiY5648U20sA/G2nYT4g8iS5boWxmSTIOngWmyVdTnVXGPLdxvRihnqDf5xBn4Oz4y9O
        oD1rA260a2xBR6b4fxtY/pCBz3lrsJ2AShrkfAeMGQbbnGQDGvnDcV4PeHjgKA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=iaFdsa84zN1qKIHuuoUkYKtunZ9pM939i3ed8fPSgwU=;
        b=QL0dsDLrkyTWJDcn0Idnv3OmGjEQ7hA+fk8LpQLouQYHWEgKPIPI+KlQQIlr/ePLYzBWCL
        zExxvmYMEMPT7kAA==
Date:   Tue, 09 Mar 2021 09:42:04 +0100
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>,
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
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        linux1394-devel@lists.sourceforge.net
Subject: [patch 01/14] tasklets: Replace barrier() with cpu_relax() in
 tasklet_unlock_wait()
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A barrier() in a tight loop which waits for something to happen on a remote
CPU is a pointless exercise. Replace it with cpu_relax() which allows HT
siblings to make progress.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 include/linux/interrupt.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -672,7 +672,8 @@ static inline void tasklet_unlock(struct
 
 static inline void tasklet_unlock_wait(struct tasklet_struct *t)
 {
-	while (test_bit(TASKLET_STATE_RUN, &(t)->state)) { barrier(); }
+	while (test_bit(TASKLET_STATE_RUN, &t->state))
+		cpu_relax();
 }
 #else
 #define tasklet_trylock(t) 1

