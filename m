Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA79F33212A
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231445AbhCIIq2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:28 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:51468 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbhCIIpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:47 -0500
Message-Id: <20210309084242.726452321@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=9KT43iZjcYh0YrvTvN7XdcTuH8DaLv7UrGU0p5dJ7Kw=;
        b=wbIPe/m5YjN4T0CDdkyHEN3ndj7u66SXrWn9gJjd/UkhTNnGLeGIUI4nTvNwc7lpFNabXr
        vxQ6cZqrDDW2eM5MQX3ZWhiivT0yo+ZyXH7EJqOXtf6l38AMSVnN8bn0ueCfbmBAuqnBpS
        luR4xNWKJDT05NOP79QWNntAMHafrWS8GO2MbfhqlI8jaP8LpW4HD4DcsHiPaNuqsgpYZz
        dmrFsN7ejzCrAYm7LduwIBlWJWYmtzsz0hv4qcm+OYpWTxOxxnmJzw8N5tUzdzuKpQcHX9
        HECVCBidiDF5S9jqMmRQMo2QAzg9hQohkD0Cd40RxKAIdq0x5iXtiX++xbdcsg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=9KT43iZjcYh0YrvTvN7XdcTuH8DaLv7UrGU0p5dJ7Kw=;
        b=1zaTxtqRMfwcDkMrDkgUs/o2Y1uOqHP/lGxGKpimbVREa7ooJ+5Ln+F0PzjOPoORY4z1cD
        1riABWr9jAEmHXBg==
Date:   Tue, 09 Mar 2021 09:42:17 +0100
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
Subject: [patch 14/14] tasklets: Switch tasklet_disable() to the sleep wait variant
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 -- NOT FOR IMMEDIATE MERGING --

Now that all users of tasklet_disable() are invoked from sleepable context,
convert it to use tasklet_unlock_wait() which might sleep.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/interrupt.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -716,8 +716,7 @@ static inline void tasklet_disable_in_at
 static inline void tasklet_disable(struct tasklet_struct *t)
 {
 	tasklet_disable_nosync(t);
-	/* Spin wait until all atomic users are converted */
-	tasklet_unlock_spin_wait(t);
+	tasklet_unlock_wait(t);
 	smp_mb();
 }
 

