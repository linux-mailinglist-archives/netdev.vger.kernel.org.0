Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3769C1D6635
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 07:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726740AbgEQFrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 01:47:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgEQFrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 01:47:23 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70E47C061A0C;
        Sat, 16 May 2020 22:47:23 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m7so2755916plt.5;
        Sat, 16 May 2020 22:47:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=drmII/PwGs2+j+RC/yUKrWEgxCX9gLQZgVT9e2wht+c=;
        b=WzUYx0wYfkC13YkdNT/husM8BOe7dmAbzZac3CVLTwuF/tG87AgQBU2iZsVagBcAFK
         NrGpTa4TXzk3oqL3VHxHFn3yuwq+SHOmlaY5JM5ZoeUW+I6O6YNvd6d8kOFQVp1WT1YY
         zWfUcNpZIPCP/DlNDgqTa7/pMbr2rPH02TQqkQf26OWuU/ZVfIdFKoctbRVsDy76Ok3k
         Ht7O+zm50YbFrylSy5v5J5GS5g/Pncn+rFgilkxUw4yBAOoRprBMQtSf5MOUrc8C3tMR
         kFvRLdr7cPhYjA2y3/qlQupLk26IwvqcENTK0XnoxZPhdDma0awdiYKjRj7XARUoyCyC
         3Cyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=drmII/PwGs2+j+RC/yUKrWEgxCX9gLQZgVT9e2wht+c=;
        b=lGvOQnoK4q9/sJAQmg6YjdU8Gllftuo8PFQ2w5g6c/UK2shnyqV+eD3H9DFvr98v2c
         PENOVJGyl5sBoQEKJlzDfhXcleRtlpI+LrDHtdqlOAJFbpYwD1Z0SykhvFXO8hTBHT9j
         LCRuT7IIVVDALtGKLuPzx6WL8e2Xa4tdFjMNGn39zTVuznWw9UJ7eo+IlWiO4sLIvJ57
         tdSTdw4eXzBlwYDna7eu0WDuxhDveN9LBj2apeD0yrQla0iGEld7z9IEDLGJd+Rq/BV8
         byAILqIRb5ganr5/6auuuV/gqsHoSlGcXDOl55M5m7grEvkynfk+Old7qSNG9fagsq9i
         M+ag==
X-Gm-Message-State: AOAM531DhD1KbZvZNdp2Qcl1bnTjczcJaHpU8m1QbvycHM5PHfB8ETJ8
        jBq9meXZIYNbrTqw2GEMNyM=
X-Google-Smtp-Source: ABdhPJye4WrT8yxOZNSKYH+VbCBliyGbSYG3H3GtqNgBv6eSe+mFst0mHVKXrqp9MpENO6SjSLpu+A==
X-Received: by 2002:a17:90a:e30e:: with SMTP id x14mr10799845pjy.141.1589694442867;
        Sat, 16 May 2020 22:47:22 -0700 (PDT)
Received: from localhost ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id v5sm875450pjy.4.2020.05.16.22.47.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 May 2020 22:47:22 -0700 (PDT)
From:   Xiangyang Zhang <xyz.sun.ok@gmail.com>
To:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com
Cc:     gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Xiangyang Zhang <xyz.sun.ok@gmail.com>
Subject: [PATCH] staging: qlge: unmap dma when lock failed
Date:   Sun, 17 May 2020 13:46:38 +0800
Message-Id: <20200517054638.10764-1-xyz.sun.ok@gmail.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DMA not unmapped when lock failed, this patch fixed it.

Signed-off-by: Xiangyang Zhang <xyz.sun.ok@gmail.com>
---
 drivers/staging/qlge/qlge_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index a9163fb659d9..402edaeffe12 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -227,7 +227,7 @@ int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
 
 	status = ql_sem_spinlock(qdev, SEM_ICB_MASK);
 	if (status)
-		return status;
+		goto lock_failed;
 
 	status = ql_wait_cfg(qdev, bit);
 	if (status) {
@@ -249,6 +249,7 @@ int ql_write_cfg(struct ql_adapter *qdev, void *ptr, int size, u32 bit,
 	status = ql_wait_cfg(qdev, bit);
 exit:
 	ql_sem_unlock(qdev, SEM_ICB_MASK);	/* does flush too */
+lock_failed:
 	dma_unmap_single(&qdev->pdev->dev, map, size, direction);
 	return status;
 }
-- 
2.19.1

