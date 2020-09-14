Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC982685EB
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgINHbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726063AbgINHak (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:40 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E77C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:39 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id o16so5024813pjr.2
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bTZLpe1Z4Prl4QDL59Sva1UVH5F2B9wvbDVNz1voc8s=;
        b=hP3gQfbrNLudxBTEM2L/fPQ8c/gIXMjrbcM8aZlxK6vy6KWCwQaVlKHdcmF1Nnrwpa
         bFrPr4F7etpEQoeeTBED1i/S3lzGJ6M8DeBjjIMoyt3cKnDmAgjkC1iCO5DsEM12i/Ps
         oeIQmFgvNQ0lcPXNFvjm2+c2GghHFPUfmnqeG7iuzNDUIFjmRnBb3Yc2hSsUzgRxvKEM
         ff9r5iRux8zcSbRT+Z+pBVaQmOUsUxJQK43YMxeI8fuK6pqu2EjIbKHr3Yz59Ssinq9W
         /o2CLC1FlUNIbLSxgqSr5KhM4YyA5FECKIP3WimbC8GXRZI65aa/pWMzGn1OaRqeOITh
         olCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bTZLpe1Z4Prl4QDL59Sva1UVH5F2B9wvbDVNz1voc8s=;
        b=H0ghtDLByhbCow1m+KV60ddnQhhT5NW7Vz4Pw7c+MJK4Wm5QXmqMXGTM0JmdwKV4ip
         rkQ6PVOuQieMFBlrqiXTyM75D6kkD6ghQIKrxMg8FYmuS/a48euqN1q3vh6W5WvqAqIG
         KqNdx+/t6OurzpPoUkNtNdNi92HzosCrm5B3QHiS6oWUA0sEZmtA3S9PIf+CecdlctIZ
         uTnbBVTV1cg8Mp62F5jctCAbaZQqNhAl62CzQQ8fXLjFPLXrTmOhIvaDjLs+yPPhXNEC
         WPP36zxjwBX1LNTtkqZHwv/A2qezi0hGXC3//YnYNBc0cwU7W4zvhiHRSaT27mSFbDmA
         sKyA==
X-Gm-Message-State: AOAM533U/EEFO4+jOOVBsIbnDituS0e3hHucOet56gZn2XjyDpYK9YnJ
        MAsJxHiF4y9IEdMNq35PfKY=
X-Google-Smtp-Source: ABdhPJzEgi9WzX/HpoE1cQFgxLdDcLr4o7c/r0AUs+uvCOhX6rvTeO6j4B0B3gl7YW2CJDhNEUHdjg==
X-Received: by 2002:a17:90a:ea0c:: with SMTP id w12mr12723348pjy.65.1600068639336;
        Mon, 14 Sep 2020 00:30:39 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:38 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 12/20] net: skge: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:31 +0530
Message-Id: <20200914072939.803280-13-allen.lkml@gmail.com>
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
 drivers/net/ethernet/marvell/skge.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
index 6a930351cb23..8a9c0f490bfb 100644
--- a/drivers/net/ethernet/marvell/skge.c
+++ b/drivers/net/ethernet/marvell/skge.c
@@ -3338,9 +3338,9 @@ static void skge_error_irq(struct skge_hw *hw)
  * because accessing phy registers requires spin wait which might
  * cause excess interrupt latency.
  */
-static void skge_extirq(unsigned long arg)
+static void skge_extirq(struct tasklet_struct *t)
 {
-	struct skge_hw *hw = (struct skge_hw *) arg;
+	struct skge_hw *hw = from_tasklet(hw, t, phy_task);
 	int port;
 
 	for (port = 0; port < hw->ports; port++) {
@@ -3927,7 +3927,7 @@ static int skge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw->pdev = pdev;
 	spin_lock_init(&hw->hw_lock);
 	spin_lock_init(&hw->phy_lock);
-	tasklet_init(&hw->phy_task, skge_extirq, (unsigned long) hw);
+	tasklet_setup(&hw->phy_task, skge_extirq);
 
 	hw->regs = ioremap(pci_resource_start(pdev, 0), 0x4000);
 	if (!hw->regs) {
-- 
2.25.1

