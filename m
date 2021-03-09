Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2D8332111
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhCIIqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhCIIpf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:35 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177ADC06174A;
        Tue,  9 Mar 2021 00:45:35 -0800 (PST)
Message-Id: <20210309084241.685352806@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=fajdk1se+hvPqPoM0Mv211jYRgBOSmzsn3kwBqkLUCE=;
        b=4C+zwdYSCewZBAvg9JCo756ZwB/xNPomxFH/6ypc4syQiX/vfwjWWZRCTb3DhFc5iC0zzK
        0m601MJ+7emu2midF95gI8LaS2eqggA1YylfBCY9ggv/oWmh4FQhyJioPgO5nmmUWcoJ3w
        nYYJwe9vwfQwNNCmRQl7bQhtQf635TbKeG1S4FHSym4Ki7pGKZ8MC5jZ6bZeR+4dhMe80x
        t39j6CKdwPFNxDteOL1pS9CSOlB9xBibc8HVkkBhJKBUa4kf4y/QAUKGUxMlN1RbJ3E1tf
        tp/49XzusDQMWSxSkzqgTeFr0/59Tvmfovoycg7shA3I+ADHsvLITw7U7ndRQw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279533;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=fajdk1se+hvPqPoM0Mv211jYRgBOSmzsn3kwBqkLUCE=;
        b=u2ufN0ryTPI6iaS2zSQyW6B292/G/cKQn67hUvgNj6rQWijamDsMf6cfWjVoR7pxDc1GeJ
        06KPRYx02lf9/1Dg==
Date:   Tue, 09 Mar 2021 09:42:07 +0100
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
Subject: [patch 04/14] tasklets: Use spin wait in tasklet_disable() temporarily
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To ease the transition use spin waiting in tasklet_disable() until all
usage sites from atomic context have been cleaned up.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -728,7 +728,8 @@ static inline void tasklet_disable_in_at
 static inline void tasklet_disable(struct tasklet_struct *t)
 {
 	tasklet_disable_nosync(t);
-	tasklet_unlock_wait(t);
+	/* Spin wait until all atomic users are converted */
+	tasklet_unlock_spin_wait(t);
 	smp_mb();
 }
 

