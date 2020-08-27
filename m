Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0719255174
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 01:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgH0XAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 19:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727845AbgH0XAm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 19:00:42 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E7CFC06121B
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:42 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id v15so4416970pgh.6
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 16:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9Dcu0ODgktyQopGmsvvfnLYcxiTT+wl+JncOEgcVoIU=;
        b=SXL+C/U6crxPhUZAlbDnRj0g6wKCXIhDRhE1+uokFye28nsFZo91PFSerFyT9jTLOm
         GkdlvRAYTMLYLCkS85oqfouJvVUU6moiE0OhHy5IRTiz0cd9no4xRN+5X33xOrp6Bxmx
         YHzvalxVR5G/ALAbp8U+7o/09mHNQfGbGUUM+94PF3FST5GTMbufAa+TqqhDsCguIrh0
         63qbhIFqr0hzSQYMCdjM+eMCTrkk4TF9bhsYk13nzxuHy9b5PPWjsIVGMLQMDookCTdk
         mlPGp/w0ft4UjbsmHDDzui8KbDCXr3WU80GztdimqA0sNEVYCR1q0L17Ev+BrTLEkpuU
         LhYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9Dcu0ODgktyQopGmsvvfnLYcxiTT+wl+JncOEgcVoIU=;
        b=uWx5Q7GXk3dyQBsV59fZn1oo8KC4auoSfg8CevSLavLMMw72Kx+9cr6JCxb8za87gC
         7LplVlNPHZJCTujGn7d0x9XEeUNbd9XlekmP5luHollUxJCH2wYZxyvSTJV5nwo3/rx4
         XSGv41zaKU5wyk9DT76+ymaqux02Co+vQuiHpmZQcHNbf3v8Y/xP2si4vxJkUUf9RABT
         Lx8FJwy0KTAC0ApOMnZNYqcVJ1aZdrAe4UZDB4GgtRt/aW/a1zWojuFX55KJIpBZ4WOw
         21pnTefXo/t4QK+YGPjAhNauU7lQIXpRWO8LeghxMVg0qGZ2mSgOq80oIu/BVtOD3yJu
         ghmA==
X-Gm-Message-State: AOAM530fiCj6ZM/C/YZALKRhyiOnYnsBxzyORLNvUnGZXNlVJ2ZLQZOD
        gFYI+pIUncRtz2bsmrXJjmJRA72fNN5KEg==
X-Google-Smtp-Source: ABdhPJxfF8qbuehHsup5s+wgrOi4it/Vgm8qsXKoMFq2n6qkP45ybgfL68twuVHbCNliYvysS44T9A==
X-Received: by 2002:a63:1d4c:: with SMTP id d12mr16155266pgm.365.1598569240940;
        Thu, 27 Aug 2020 16:00:40 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id n22sm3137534pjq.25.2020.08.27.16.00.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Aug 2020 16:00:40 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 03/12] ionic: use kcalloc for new arrays
Date:   Thu, 27 Aug 2020 16:00:21 -0700
Message-Id: <20200827230030.43343-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200827230030.43343-1-snelson@pensando.io>
References: <20200827230030.43343-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use kcalloc for allocating arrays of structures.

Following along after
commit e71642009cbdA ("ionic_lif: Use devm_kcalloc() in ionic_qcq_alloc()")
there are a couple more array allocations that can be converted
to using devm_kcalloc().

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e95e3fa8840a..d73beddc30cc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -522,7 +522,6 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 static int ionic_qcqs_alloc(struct ionic_lif *lif)
 {
 	struct device *dev = lif->ionic->dev;
-	unsigned int q_list_size;
 	unsigned int flags;
 	int err;
 	int i;
@@ -552,9 +551,9 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 		ionic_link_qcq_interrupts(lif->adminqcq, lif->notifyqcq);
 	}
 
-	q_list_size = sizeof(*lif->txqcqs) * lif->nxqs;
 	err = -ENOMEM;
-	lif->txqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	lif->txqcqs = devm_kcalloc(dev, lif->ionic->ntxqs_per_lif,
+				   sizeof(*lif->txqcqs), GFP_KERNEL);
 	if (!lif->txqcqs)
 		goto err_out_free_notifyqcq;
 	for (i = 0; i < lif->nxqs; i++) {
@@ -565,7 +564,8 @@ static int ionic_qcqs_alloc(struct ionic_lif *lif)
 			goto err_out_free_tx_stats;
 	}
 
-	lif->rxqcqs = devm_kzalloc(dev, q_list_size, GFP_KERNEL);
+	lif->rxqcqs = devm_kcalloc(dev, lif->ionic->nrxqs_per_lif,
+				   sizeof(*lif->rxqcqs), GFP_KERNEL);
 	if (!lif->rxqcqs)
 		goto err_out_free_tx_stats;
 	for (i = 0; i < lif->nxqs; i++) {
-- 
2.17.1

