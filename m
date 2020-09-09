Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE94262AC0
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbgIIIpk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728936AbgIIIpe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:45:34 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F8AC061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:45:33 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j34so1570332pgi.7
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rw8MiQTQyeul6XkGacM3BCi7JDAaTFdx0LbZCloJ4X0=;
        b=kJfIkIxjuB7xUwUYLXD57sRQ9l1l2aNGapSU6HgZGdBnm6QZqKj9GVKPhuscfBjNug
         jKk7H2cpWJa72Ydj4SJU8JyGWA+m+yNO4OOOydKqsJb1R2rXz2AUvcQaq9KzUkGwOEEn
         prIrX4tXFLij0HWZv1i/2J7YpkEK0PmSgE5vwoxo1WQFd9z2wdI3MyNoctQ1D1vH37pt
         W/BaRrffQ0W+RWm9/zHoR9sqS7utXGS1MrM8WjQ7Uj6rpdzg2sqLjPxpEugyZaKs3IGc
         CbDGp89hSvz4GTWHEZp9W/RODIpsLKhF7bpm5xu32btnWNXgS6WTCk+1ezbI8lEVfiMm
         GBPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rw8MiQTQyeul6XkGacM3BCi7JDAaTFdx0LbZCloJ4X0=;
        b=Stvz1j6HDtYz3+MnY5QhHULfPx6NIcq/RKPgI8Tb2NK7ukl956pBuplxl/tULxCAWW
         +/VXyQLttQS/1J3TyMXWqNb/jFuBTKGfMw8evijPw2dVQP7fKfcpsTlAUTfffD/c7a6E
         H6JYfm0HGCVkXcg5dZB6g3VTpv0TyNlOekOhDxF0y9uxygJ7ivH8GH6B8eZYDd8+cInw
         1Uz94rf+De6mtT/kuwt/o5zBhXKpPARF/JXTva6xrwypZOwDmfFBjTU7SKFRjVhgvz8N
         7jEDmDw8u0I/dhZrELyDxW6MAav66FTlq5OQpNNSJn+9q8CFjYFSyl4sUV25vf+HSxQv
         XEeg==
X-Gm-Message-State: AOAM532gcncPNs5bYh6QZx/MPx4I7uJ8AEnKNvtTr9NxOEE7a55Cpbe9
        sFBJCjmQkbK36Ha/HX/Yho0=
X-Google-Smtp-Source: ABdhPJw3ymAn+UwM2jsAickgp16PgvKqqLqMzdZinx5AP3Qau9q0xW7rsfsbGqbJ1x8zEWjrm8McHw==
X-Received: by 2002:a63:490f:: with SMTP id w15mr2185787pga.323.1599641132857;
        Wed, 09 Sep 2020 01:45:32 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:45:32 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 03/20] broadcom: cnic: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:14:53 +0530
Message-Id: <20200909084510.648706-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200909084510.648706-1-allen.lkml@gmail.com>
References: <20200909084510.648706-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/ethernet/broadcom/cnic.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/cnic.c b/drivers/net/ethernet/broadcom/cnic.c
index 84536292b031..f7f10cfb3476 100644
--- a/drivers/net/ethernet/broadcom/cnic.c
+++ b/drivers/net/ethernet/broadcom/cnic.c
@@ -3009,10 +3009,10 @@ static int cnic_service_bnx2(void *data, void *status_blk)
 	return cnic_service_bnx2_queues(dev);
 }
 
-static void cnic_service_bnx2_msix(unsigned long data)
+static void cnic_service_bnx2_msix(struct tasklet_struct *t)
 {
-	struct cnic_dev *dev = (struct cnic_dev *) data;
-	struct cnic_local *cp = dev->cnic_priv;
+	struct cnic_local *cp = from_tasklet(cp, t, cnic_irq_task);
+	struct cnic_dev *dev = cp->dev;
 
 	cp->last_status_idx = cnic_service_bnx2_queues(dev);
 
@@ -3134,10 +3134,10 @@ static u32 cnic_service_bnx2x_kcq(struct cnic_dev *dev, struct kcq_info *info)
 	return last_status;
 }
 
-static void cnic_service_bnx2x_bh(unsigned long data)
+static void cnic_service_bnx2x_bh(struct tasklet_struct *t)
 {
-	struct cnic_dev *dev = (struct cnic_dev *) data;
-	struct cnic_local *cp = dev->cnic_priv;
+	struct cnic_local *cp = from_tasklet(cp, t, cnic_irq_task);
+	struct cnic_dev *dev = cp->dev;
 	struct bnx2x *bp = netdev_priv(dev->netdev);
 	u32 status_idx, new_status_idx;
 
@@ -4458,8 +4458,7 @@ static int cnic_init_bnx2_irq(struct cnic_dev *dev)
 		CNIC_WR(dev, base + BNX2_HC_CMD_TICKS_OFF, (64 << 16) | 220);
 
 		cp->last_status_idx = cp->status_blk.bnx2->status_idx;
-		tasklet_init(&cp->cnic_irq_task, cnic_service_bnx2_msix,
-			     (unsigned long) dev);
+		tasklet_setup(&cp->cnic_irq_task, cnic_service_bnx2_msix);
 		err = cnic_request_irq(dev);
 		if (err)
 			return err;
@@ -4868,8 +4867,7 @@ static int cnic_init_bnx2x_irq(struct cnic_dev *dev)
 	struct cnic_eth_dev *ethdev = cp->ethdev;
 	int err = 0;
 
-	tasklet_init(&cp->cnic_irq_task, cnic_service_bnx2x_bh,
-		     (unsigned long) dev);
+	tasklet_setup(&cp->cnic_irq_task, cnic_service_bnx2x_bh);
 	if (ethdev->drv_state & CNIC_DRV_STATE_USING_MSIX)
 		err = cnic_request_irq(dev);
 
-- 
2.25.1

