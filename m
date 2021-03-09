Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E79332123
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:46:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCIIqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbhCIIpk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:45:40 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAAE2C06174A;
        Tue,  9 Mar 2021 00:45:39 -0800 (PST)
Message-Id: <20210309084242.106288922@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1615279538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=7IK8kzfGlSFgpO4rGsKRyh2dHPEpzNkBNUXH4hGWuJY=;
        b=GEbfG6GnTAzr16UziMmBg85BIXoJ/zfqIUVGbwQ+Prx1e3U4hgb6mUrpnbvpxxKDb2LIJh
        g+5WETTjbCIWLTzZS0A1yBImgi9CLgRpNm5mUI+ZiTp871z9SHcBmKiNNfzeKefQXwNhFy
        gkO1jOGS+6oECdVlWMaZC3Sg5oqaLz3tZBBIMUstWXqTp5K9zEqUfx0rTpQmK3OR4T4WxT
        H3PNXORIX65EB1odjmK8M/1p6A3rjydg4ztuZXiiw0CRj34U5TMZEaewjIO5Rb7agNTWvK
        rFY4M1/5Ng1GEout/Ov9hGXE+7qgPxstwe+EbT35/Da+er2NUDmRnb2LdN5smw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1615279538;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=7IK8kzfGlSFgpO4rGsKRyh2dHPEpzNkBNUXH4hGWuJY=;
        b=DI1ASnFSEA0uOjbH8sDeh9qxzuEgh2lFfMcFtdSXZ2KcYr6mQmlk+CTp5gCwez6V8h4cHr
        NI0MBr0cvy5d0wBg==
Date:   Tue, 09 Mar 2021 09:42:11 +0100
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
Subject: [patch 08/14] net: jme: Replace link-change tasklet with work
References: <20210309084203.995862150@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

The link change tasklet disables the tasklets for tx/rx processing while
upating hw parameters and then enables the tasklets again.

This update can also be pushed into a workqueue where it can be performed
in preemptible context. This allows tasklet_disable() to become sleeping.

Replace the linkch_task tasklet with a work.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/net/ethernet/jme.c |   10 +++++-----
 drivers/net/ethernet/jme.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/jme.c
+++ b/drivers/net/ethernet/jme.c
@@ -1265,9 +1265,9 @@ jme_stop_shutdown_timer(struct jme_adapt
 	jwrite32f(jme, JME_APMC, apmc);
 }
 
-static void jme_link_change_tasklet(struct tasklet_struct *t)
+static void jme_link_change_work(struct work_struct *work)
 {
-	struct jme_adapter *jme = from_tasklet(jme, t, linkch_task);
+	struct jme_adapter *jme = container_of(work, struct jme_adapter, linkch_task);
 	struct net_device *netdev = jme->dev;
 	int rc;
 
@@ -1510,7 +1510,7 @@ jme_intr_msi(struct jme_adapter *jme, u3
 		 * all other events are ignored
 		 */
 		jwrite32(jme, JME_IEVE, intrstat);
-		tasklet_schedule(&jme->linkch_task);
+		schedule_work(&jme->linkch_task);
 		goto out_reenable;
 	}
 
@@ -1832,7 +1832,6 @@ jme_open(struct net_device *netdev)
 	jme_clear_pm_disable_wol(jme);
 	JME_NAPI_ENABLE(jme);
 
-	tasklet_setup(&jme->linkch_task, jme_link_change_tasklet);
 	tasklet_setup(&jme->txclean_task, jme_tx_clean_tasklet);
 	tasklet_setup(&jme->rxclean_task, jme_rx_clean_tasklet);
 	tasklet_setup(&jme->rxempty_task, jme_rx_empty_tasklet);
@@ -1920,7 +1919,7 @@ jme_close(struct net_device *netdev)
 
 	JME_NAPI_DISABLE(jme);
 
-	tasklet_kill(&jme->linkch_task);
+	cancel_work_sync(&jme->linkch_task);
 	tasklet_kill(&jme->txclean_task);
 	tasklet_kill(&jme->rxclean_task);
 	tasklet_kill(&jme->rxempty_task);
@@ -3035,6 +3034,7 @@ jme_init_one(struct pci_dev *pdev,
 	atomic_set(&jme->rx_empty, 1);
 
 	tasklet_setup(&jme->pcc_task, jme_pcc_tasklet);
+	INIT_WORK(&jme->linkch_task, jme_link_change_work);
 	jme->dpi.cur = PCC_P1;
 
 	jme->reg_ghc = 0;
--- a/drivers/net/ethernet/jme.h
+++ b/drivers/net/ethernet/jme.h
@@ -411,7 +411,7 @@ struct jme_adapter {
 	struct tasklet_struct	rxempty_task;
 	struct tasklet_struct	rxclean_task;
 	struct tasklet_struct	txclean_task;
-	struct tasklet_struct	linkch_task;
+	struct work_struct	linkch_task;
 	struct tasklet_struct	pcc_task;
 	unsigned long		flags;
 	u32			reg_txcs;

