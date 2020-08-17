Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2798B245FCA
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:25:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728195AbgHQIZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728101AbgHQIZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:25:12 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F13C061388;
        Mon, 17 Aug 2020 01:25:12 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id t11so7142780plr.5;
        Mon, 17 Aug 2020 01:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=//0cU4D4ygspSBbtP32AytW3V0GobkPQnAIy8h5tGFQ=;
        b=k6TcpdBke/4ra4r69REycQPL5SXj2DVcOiJbAczGGHueHEcC8s5DLSbYPyZ3sBEAgM
         y6n6KwEZ10tmEj0hJyZj+ZUYnx2AAO4FbQErR1urJcgd6CwQtt6SUK4oX2t4DMNH7AsB
         CbLz39wd3i6EDj07z5/nx5rmHJuQwPjPQk57LqcXNWR3qPmQS0mrSt7tkH4nUSiaCar6
         uQ3FOaahy6No3eSkYQb2q3/4/YKj5hjwFbI9jF8Y5y2lw0Yt0rBl2yXZu9X7QBz0+5P/
         EQ8vunq+SiqEyr6McmwaZ4SuG+5AViw8t5/1ME+LzUe74E8+sPcNl06lzsn77sRGjBd5
         t40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=//0cU4D4ygspSBbtP32AytW3V0GobkPQnAIy8h5tGFQ=;
        b=CpNELGuDfUNz7ckuNA9UcLTkIFeMWgED1MNml+MChaR+1KhmgxloeU93aXOEkm22hi
         gBtxljRCu/FQtKhw+hB0YYdvNOqQvH5duGM+K0tJ+1D3nF+KkohIun7flhwtTuGAx6Ti
         tzUbeEnjFf7q2PQS34m1wety6VFeQ6p9VwE6gU5sA2zHqjlf9rPNB03HNRV/s+XAVoXf
         rluVN2qJFIz2Cn4bZDgFFr/7yYyehNQmy2wXmlIeHqCLf8yk+3A5MObspiKL5TYocpYT
         WeMYatLBw348f8IklCXrlfOV4EIGJU+vzdylK6yGvSzKHuNL3bDM/kjBNYdDIDeZjQ0S
         Ahog==
X-Gm-Message-State: AOAM533YNfX7wN3cIknoAKJR0rzYMJb1aoSgcHVwYP7OA+KrJYFuoU0N
        5ALGfJWf2104pu85mCtTwaE=
X-Google-Smtp-Source: ABdhPJy/kN3PQGQOz7LcO/GIU86/ehe4vLYAl+7eOVcgh49ZDG6UFRQWvhti77fCOLiIhfqDvSIvsw==
X-Received: by 2002:a17:902:5997:: with SMTP id p23mr10460861pli.277.1597652712379;
        Mon, 17 Aug 2020 01:25:12 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:25:11 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     jes@trained-monkey.org, davem@davemloft.net, kuba@kernel.org,
        kda@linux-powerpc.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com, borisp@mellanox.com
Cc:     keescook@chromium.org, linux-acenic@sunsite.dk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, linux-rdma@vger.kernel.org,
        oss-drivers@netronome.com, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH 03/20] broadcom: cnic: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:17 +0530
Message-Id: <20200817082434.21176-5-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200817082434.21176-1-allen.lkml@gmail.com>
References: <20200817082434.21176-1-allen.lkml@gmail.com>
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
index c5cca63b8571..e1e8c012d501 100644
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
2.17.1

