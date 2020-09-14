Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712452685DF
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:30:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgINHaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgINHaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0887DC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:05 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id v14so3566931pjd.4
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+OEW+j/IVzOV01ZFOPO++wg5uIdjVbIViYfFl+LVV2c=;
        b=rOpjcmQOIVKA7O+X2OpyPFrEPpA+1J8KY8672nWs2deUQHSGwxW2DOdU1lusLVpBee
         ivxOFxKSvELqPK53aoZDjZH+SJIXJqGW4sj0+l5qhZ0G5Fne6V30n8h65JnVGf+WsPSp
         Me4+khuC5nf2DjFo7RFSE/xJ1nNvVI6MwqmPkXBoMxUVXz9nnhBPBgzAGfxYkXQEiuda
         MlsNKFNtdV7AQ/ajKu6W+twsg34ZZC1QIMtrDx1JswV4UmMpzksb3zno0owO7kV2M4P7
         VmkDelpeSOM3MvZwtWWUDd/kboVVLieJ9/Nk2aJEV13rGURv48yFHHVaKDvKTNYSfH02
         JUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+OEW+j/IVzOV01ZFOPO++wg5uIdjVbIViYfFl+LVV2c=;
        b=MrfnELdOjPPNpu17wN4T5tnCyaUqTxqyBPF0niGGO0lV+P5LlAvs9JG8OtSaIFnizP
         Y8KMhgoyVIyZkqg/HnY0eur846APKB01adAM5oy88m6D+Lgav/w2MN8wtwMuNyA0daP4
         a/BSZlZHCooNjuOyt3o6LGdGV99eZQShJUT+XerP8v+8H3aDOUkE3TWGSlGE05Vv8JYh
         IR1ieRfk9pAmxt5eTHPMmPD5Bdt0ivw0P/vuU5uySgNOSStnX8rYT6pncKsuM3GfAk17
         t7A4psUgVLaphx2z9CKiRbUY3HNdYB9JvngpZ6BzWBebuj3uBiLkUZNqlUjYQuW2NJGA
         5MZg==
X-Gm-Message-State: AOAM532cmUkec53BMnC0nS8Lu5awLe1q6Lozbuovl88u9j8/9Y8zntcq
        LPfcIYOWbRzrTTPRihDlRI0=
X-Google-Smtp-Source: ABdhPJxiffiCa8iWcS9G7bxcOUr46DnsIefbheqJvMrcslsPp1ZWsYO2ie4wBs19tqGFp8HinrYhQA==
X-Received: by 2002:a17:90a:5a48:: with SMTP id m8mr12919237pji.181.1600068604641;
        Mon, 14 Sep 2020 00:30:04 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:04 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 03/20] cnic: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:22 +0530
Message-Id: <20200914072939.803280-4-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200914072939.803280-1-allen.lkml@gmail.com>
References: <20200914072939.803280-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen Pais <apais@linux.microsoft.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <apais@linux.microsoft.com>
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

