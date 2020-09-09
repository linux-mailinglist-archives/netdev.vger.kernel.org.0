Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386E4262AD6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgIIIqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729507AbgIIIqG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:06 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41ADEC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:06 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id gf14so999817pjb.5
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aKqaUZboWy0wN9WJcktjpPy7JqOWlde4Agb9SDYLCws=;
        b=vNPVEMgCLkVbYGt+a4R86QQaSpM41cAaUrs9c6nlqWVbDAOIoiQFNi2Aqg8RgzUJnX
         oeVrWf/JYw1hQUuFPdPLrs4eqKGBGns1ZP2jVMQ8RWa3ZG/xpskq45bYORRp59e9K7tm
         JWrRkeS1mgczeEhlRTb4ixB4sKCVYRaH0M0cJcoca8OIsy8X+LnbsuKS0FEPBsxDY7LH
         SirGSP7+c3Mm9jYqYVtMKywcJI/bg5X3EGye/vdTRHrcpe7AEHWvb/kaY8/7suvpXau0
         68CC3EOWzUtQjuTHc/ogooIRuGyf7PCvXfnY9BCWfmHxidrKkwI/HBaepBHrZqKfarDd
         KeTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKqaUZboWy0wN9WJcktjpPy7JqOWlde4Agb9SDYLCws=;
        b=SDakWn48dTwkHdYpA1A4QrL337Ajh64FytBAlmVqmLfO2oCdcMJYpxhvytxveZ+ueg
         F0Gjh/oIRrXCOUsL7vtthPJw8hcS0fr8/xsDZ3xw87x4n5ddjO3RcW6Rnl2IGYwBrWzk
         ywgo4TIkDTDRqvxCXZSHIPKpecFYS+H91ZKuSXTAO4OOCpc/vq4KFGBSyb9+gXsqiD5m
         Jdyhcar8s+g8EGdobrZurITAwL1tSW6kj0NcGz8sq1LUpVUV8NguIRE+gD9b3TEOQfdy
         wjvdlNEEB1K1Zegyn5p3irLpdQlbntkRXuzvxRKgGSZQxeQR6SfU7jkLWuk1AELJcPC+
         fh4g==
X-Gm-Message-State: AOAM532CtoEqLRJNbp4fEbDF7jhIy2l3xzj8oROfN5AYh6MJGfuJFXtH
        JsnfRuvpvVdgirH4nf++qfQ=
X-Google-Smtp-Source: ABdhPJxNdFEkHu33wpmPoVZPpmBYnnsmI6IvOcjl2koSqc5wxufX4IqObaxMYYaGNk0dh8lwbtZrmQ==
X-Received: by 2002:a17:90a:7bcf:: with SMTP id d15mr2641732pjl.230.1599641165879;
        Wed, 09 Sep 2020 01:46:05 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:05 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 12/20] ethernet: marvell: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:02 +0530
Message-Id: <20200909084510.648706-13-allen.lkml@gmail.com>
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

