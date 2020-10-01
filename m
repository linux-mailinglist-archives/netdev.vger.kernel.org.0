Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC4932803CB
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 18:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732380AbgJAQW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 12:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732208AbgJAQW6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 12:22:58 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24248C0613E2
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 09:22:58 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id n14so4998862pff.6
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 09:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fMcKVD61nofaq5qqD+Y1T6wU0xAKqtvzSc1DonbyAPM=;
        b=C/05m0ZiXooWfrcQnbMoS25Ez6zbkCrSs6jBBtuJ9XiZR6oznAPsXuLBVN9xuOs5JY
         G3NqQnXE6yMwbJDefuk1XDQKEHi5XIzWBtL+O9kytE+2/BiRhF0okBvPj49ncO4AJHI6
         y1kwv3Bga5e5abn5757qAQvJSGWPyuIM8sm2tWXvqlAfMBA/0Y8Hg4AcPtlmIceacS5T
         T2WYMqhFInz3tkKZracbWsk1KODrYBTnNh6jF3s6lPDyNjLwCoWeMspjnEJ2avCMY7w/
         4x+q9dN38nhchZNf41c1DSNbFhod4VkCvaIFR2fx6+Bc/WJveFGAN8ZxunOf4E9y2MgK
         lEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fMcKVD61nofaq5qqD+Y1T6wU0xAKqtvzSc1DonbyAPM=;
        b=RBnDIEodU/SddSVuUpgYz5OmCeUPVnrAN1JqGcXDdi5VeZOuSj5xc9mPhEKuOUbXcR
         uJjotFURRuRnbURBUqCoFpLFluWJDTGkvyYHz99dc0+bRAN21V0Uh4JlY6jQwCmEV/rY
         toJJZlkXmrDxBw/uK4ohB/uQFyLJBEG8woC64vCrLWuM/x+R+mE7dGbdvmoPEwjDpirL
         GGF4epw41GpcrU5MX17ZLi+pei3/Zfu1DqzPhH3AnJIfSnwSNhKGQQkujA0JheNzSDcX
         Dm5X0vyVawvquGWi0h0DNsoRYJ6wg93sEXNjJJDSyDZ8G8YT0R0F8nBHtE86sGEyDdCd
         dKTg==
X-Gm-Message-State: AOAM530nefmX7lzKfBZJQDKL6aNuPl1Nrv5wicEblOpl94i1LLj5I4QC
        Z9OEl8dEBRWAvcVTHKsCcTmBkgOKtantIw==
X-Google-Smtp-Source: ABdhPJwBSdi9Cl86iw7WGN1tEgs8/yeuSeloiLCIEFkyezoEF8zCI8FWCahp2wN2dIXVcR0C/T0wLg==
X-Received: by 2002:aa7:9204:0:b029:14b:f92e:f57 with SMTP id 4-20020aa792040000b029014bf92e0f57mr8141405pfo.16.1601569376216;
        Thu, 01 Oct 2020 09:22:56 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id k2sm6380066pfi.169.2020.10.01.09.22.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Oct 2020 09:22:55 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/8] ionic: contiguous memory for notifyq
Date:   Thu,  1 Oct 2020 09:22:39 -0700
Message-Id: <20201001162246.18508-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201001162246.18508-1-snelson@pensando.io>
References: <20201001162246.18508-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The event notification queue is set up a little differently in the
NIC and so the notifyq q and cq descriptor structures need to be
contiguous, which got missed in an earlier patch that separated
out the q and cq descriptor allocations.  That patch was aimed at
making the big tx and rx descriptor queue allocations easier to
manage - the notifyq is much smaller and doesn't need to be split.
This patch simply adds an if/else and slightly different code for
the notifyq descriptor allocation.

Fixes: ea5a8b09dc3a ("ionic: reduce contiguous memory allocation requirement")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 69 +++++++++++++------
 1 file changed, 47 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 1b4d5eb9bbc9..969979b31e93 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -518,30 +518,55 @@ static int ionic_qcq_alloc(struct ionic_lif *lif, unsigned int type,
 		goto err_out_free_cq_info;
 	}
 
-	new->q_size = PAGE_SIZE + (num_descs * desc_size);
-	new->q_base = dma_alloc_coherent(dev, new->q_size, &new->q_base_pa,
-					 GFP_KERNEL);
-	if (!new->q_base) {
-		netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
-		err = -ENOMEM;
-		goto err_out_free_cq_info;
-	}
-	q_base = PTR_ALIGN(new->q_base, PAGE_SIZE);
-	q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
-	ionic_q_map(&new->q, q_base, q_base_pa);
+	if (flags & IONIC_QCQ_F_NOTIFYQ) {
+		int q_size, cq_size;
+
+		/* q & cq need to be contiguous in case of notifyq */
+		q_size = ALIGN(num_descs * desc_size, PAGE_SIZE);
+		cq_size = ALIGN(num_descs * cq_desc_size, PAGE_SIZE);
+
+		new->q_size = PAGE_SIZE + q_size + cq_size;
+		new->q_base = dma_alloc_coherent(dev, new->q_size,
+						 &new->q_base_pa, GFP_KERNEL);
+		if (!new->q_base) {
+			netdev_err(lif->netdev, "Cannot allocate qcq DMA memory\n");
+			err = -ENOMEM;
+			goto err_out_free_cq_info;
+		}
+		q_base = PTR_ALIGN(new->q_base, PAGE_SIZE);
+		q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
+		ionic_q_map(&new->q, q_base, q_base_pa);
+
+		cq_base = PTR_ALIGN(q_base + q_size, PAGE_SIZE);
+		cq_base_pa = ALIGN(new->q_base_pa + q_size, PAGE_SIZE);
+		ionic_cq_map(&new->cq, cq_base, cq_base_pa);
+		ionic_cq_bind(&new->cq, &new->q);
+	} else {
+		new->q_size = PAGE_SIZE + (num_descs * desc_size);
+		new->q_base = dma_alloc_coherent(dev, new->q_size, &new->q_base_pa,
+						 GFP_KERNEL);
+		if (!new->q_base) {
+			netdev_err(lif->netdev, "Cannot allocate queue DMA memory\n");
+			err = -ENOMEM;
+			goto err_out_free_cq_info;
+		}
+		q_base = PTR_ALIGN(new->q_base, PAGE_SIZE);
+		q_base_pa = ALIGN(new->q_base_pa, PAGE_SIZE);
+		ionic_q_map(&new->q, q_base, q_base_pa);
 
-	new->cq_size = PAGE_SIZE + (num_descs * cq_desc_size);
-	new->cq_base = dma_alloc_coherent(dev, new->cq_size, &new->cq_base_pa,
-					  GFP_KERNEL);
-	if (!new->cq_base) {
-		netdev_err(lif->netdev, "Cannot allocate cq DMA memory\n");
-		err = -ENOMEM;
-		goto err_out_free_q;
+		new->cq_size = PAGE_SIZE + (num_descs * cq_desc_size);
+		new->cq_base = dma_alloc_coherent(dev, new->cq_size, &new->cq_base_pa,
+						  GFP_KERNEL);
+		if (!new->cq_base) {
+			netdev_err(lif->netdev, "Cannot allocate cq DMA memory\n");
+			err = -ENOMEM;
+			goto err_out_free_q;
+		}
+		cq_base = PTR_ALIGN(new->cq_base, PAGE_SIZE);
+		cq_base_pa = ALIGN(new->cq_base_pa, PAGE_SIZE);
+		ionic_cq_map(&new->cq, cq_base, cq_base_pa);
+		ionic_cq_bind(&new->cq, &new->q);
 	}
-	cq_base = PTR_ALIGN(new->cq_base, PAGE_SIZE);
-	cq_base_pa = ALIGN(new->cq_base_pa, PAGE_SIZE);
-	ionic_cq_map(&new->cq, cq_base, cq_base_pa);
-	ionic_cq_bind(&new->cq, &new->q);
 
 	if (flags & IONIC_QCQ_F_SG) {
 		new->sg_size = PAGE_SIZE + (num_descs * sg_desc_size);
-- 
2.17.1

