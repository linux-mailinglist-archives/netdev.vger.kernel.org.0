Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D73DF4B83B2
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:09:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiBPJJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:09:09 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:55006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiBPJJG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:09:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849AE2252A;
        Wed, 16 Feb 2022 01:08:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3C8AB81E3B;
        Wed, 16 Feb 2022 09:08:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59384C004E1;
        Wed, 16 Feb 2022 09:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645002531;
        bh=f92FiNCHdkK0S2WazdArToFy2oc6o82XVRvE88ZJZsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ds+64LnMjSsL685UOY9k7NhGeXxIZcKOEzrvi2AHoVutAmXxmTeg3kyGBQm7x7OXX
         uUw+Z60+1d9BHm5VA52q3ruUYiEzeKeXxz19baozd0fTnp5cX4roATtwOd5yVgdFop
         iBY2JNHcjhLByXUcUTgHqSvIKA1slFTvAbZcxaA0latnKf+5rJDVAqOE6k6Rn6JW22
         4sSuoqnGlaJxcAiBYO7qqVj5KzVzqZY6KFMIqXqKGtquwcn7z31uxwXH4pUWquMKyJ
         qGaYot4/pUiGSGPCj6W6LSkWCKUGvewHZGH2IUma77GBBBdmLADErORd8VGMHIyUy8
         LGBwWB7ZUs2hw==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nKGIr-008HM9-Af; Wed, 16 Feb 2022 09:08:49 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Garry <john.garry@huawei.com>, kernel-team@android.com
Subject: [PATCH 1/2] genirq: Extract irq_set_affinity_masks() from devm_platform_get_irqs_affinity()
Date:   Wed, 16 Feb 2022 09:08:44 +0000
Message-Id: <20220216090845.1278114-2-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220216090845.1278114-1-maz@kernel.org>
References: <20220216090845.1278114-1-maz@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, gregkh@linuxfoundation.org, mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org, tglx@linutronix.de, john.garry@huawei.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In order to better support drivers that deal with interrupts in a more
"hands-on" way, extract the core of devm_platform_get_irqs_affinity()
and expose it as irq_set_affinity_masks().

This helper allows a driver to provide a set of wired interrupts that
are to be configured as managed interrupts. As with the original helper,
this is exported as EXPORT_SYMBOL_GPL.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 drivers/base/platform.c   | 20 +++-----------------
 include/linux/interrupt.h |  8 ++++++++
 kernel/irq/affinity.c     | 27 +++++++++++++++++++++++++++
 3 files changed, 38 insertions(+), 17 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 6cb04ac48bf0..b363cf6ce5be 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -335,7 +335,6 @@ int devm_platform_get_irqs_affinity(struct platform_device *dev,
 				    int **irqs)
 {
 	struct irq_affinity_devres *ptr;
-	struct irq_affinity_desc *desc;
 	size_t size;
 	int i, ret, nvec;
 
@@ -376,31 +375,18 @@ int devm_platform_get_irqs_affinity(struct platform_device *dev,
 		ptr->irq[i] = irq;
 	}
 
-	desc = irq_create_affinity_masks(nvec, affd);
-	if (!desc) {
-		ret = -ENOMEM;
+	ret = irq_set_affinity_masks(affd, ptr->irq, nvec);
+	if (ret) {
+		dev_err(&dev->dev, "failed to update affinity descriptors (%d)\n", ret);
 		goto err_free_devres;
 	}
 
-	for (i = 0; i < nvec; i++) {
-		ret = irq_update_affinity_desc(ptr->irq[i], &desc[i]);
-		if (ret) {
-			dev_err(&dev->dev, "failed to update irq%d affinity descriptor (%d)\n",
-				ptr->irq[i], ret);
-			goto err_free_desc;
-		}
-	}
-
 	devres_add(&dev->dev, ptr);
 
-	kfree(desc);
-
 	*irqs = ptr->irq;
 
 	return nvec;
 
-err_free_desc:
-	kfree(desc);
 err_free_devres:
 	devres_free(ptr);
 	return ret;
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 9367f1cb2e3c..6bfce96206f8 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -381,6 +381,8 @@ irq_create_affinity_masks(unsigned int nvec, struct irq_affinity *affd);
 unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
 				       const struct irq_affinity *affd);
 
+int irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int nvec);
+
 #else /* CONFIG_SMP */
 
 static inline int irq_set_affinity(unsigned int irq, const struct cpumask *m)
@@ -443,6 +445,12 @@ irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
 	return maxvec;
 }
 
+static inline int
+irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int nvec)
+{
+	return -EINVAL;
+}
+
 #endif /* CONFIG_SMP */
 
 /*
diff --git a/kernel/irq/affinity.c b/kernel/irq/affinity.c
index f7ff8919dc9b..c0f868cd5b87 100644
--- a/kernel/irq/affinity.c
+++ b/kernel/irq/affinity.c
@@ -512,3 +512,30 @@ unsigned int irq_calc_affinity_vectors(unsigned int minvec, unsigned int maxvec,
 
 	return resv + min(set_vecs, maxvec - resv);
 }
+
+/*
+ * irq_set_affinity_masks - Set the affinity masks of a number of interrupts
+ *                          for multiqueue spreading
+ * @affd:	Description of the affinity requirements
+ * @irqs:	An array of interrupt numbers
+ * @nvec:	The total number of interrupts
+ */
+int irq_set_affinity_masks(struct irq_affinity *affd, int *irqs, int nvec)
+{
+	struct irq_affinity_desc *desc;
+	int i, err = 0;
+
+	desc = irq_create_affinity_masks(nvec, affd);
+	if (!desc)
+		return -ENOMEM;
+
+	for (i = 0; i < nvec; i++) {
+		err = irq_update_affinity_desc(irqs[i], desc + i);
+		if (err)
+			break;
+	}
+
+	kfree(desc);
+	return err;
+}
+EXPORT_SYMBOL_GPL(irq_set_affinity_masks);
-- 
2.30.2

