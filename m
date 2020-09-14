Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0682685EE
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbgINHbc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgINHav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:30:51 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E091C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:51 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 7so10814123pgm.11
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kadJX/TBo1jHMCDxQSM4lxEW3g0wCAWlJEByQ27+TyA=;
        b=YmJprhjuL5o5pEGOKjY3bwgtE6DQCSLMtSyoE9VTOOA+VPTpnYD1Ea71NckvQkfaSe
         osE6YrRnenDr54/MoKT8HaWNRVhmTu1q0xjPdMAqdrvUXOVTB9ASb6JvgZUlXG3J8Xy9
         x2WspvB5yKMgx5pgpTQ7YDRpae1ycUdkxEg7UNaixgeS0wNzVeOAsAZ3lqFdtCFdaoIl
         ikiRsIUDBbVXxXkxAsiInrmF+z4YH4Me+N7BW0+dshCd9dawpC2I5RhHrbe54Lw0QJii
         qmV/auA49S+bBoLOoYwsR+mXQAxETrsJie3inqdZu4wTzoP1DFXtaYf8LQTe3ymH+Xmm
         TyQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kadJX/TBo1jHMCDxQSM4lxEW3g0wCAWlJEByQ27+TyA=;
        b=NZyUa4jrKvWzn1hDpiRgSAmN/feAM96iSHOWW4MPNKyOPM9KGuhGtX8P0+EvgZtp5h
         wusCPbgRz6nUAbfiHY1CuSvCQh9u8wSdqEXPnCz7VimRb//prl6JmqsUgzdLqJo0EVxk
         /TUFgMSSy1p6uVGu8pwwU1DbhVCJEwi7BiYsRC44cQRKzlqPh7fv7J/esf4GHpOfumyA
         vHpCojrUaQEYFpWfNZxcP+HUbbvfC308srU5wLyW/G5xHTYqlrrybGnd9QV6To3qV9S/
         RmEaELC4XvF9d+aAZiOfLhPKMflaCxQd73OKV/I7bdXjAhJGplqUphAImcWsL08Ehg/3
         1bCg==
X-Gm-Message-State: AOAM5309Fcv85XvH7kL9S1S1O/qNe5WhPpFRUAG4c8Hz0s2bKAscArXl
        XLzXKBcYVh6qB/U9k1Hvgf4=
X-Google-Smtp-Source: ABdhPJwzgEHSWBsEpp/ad5tGx2j1Y3gDReLI5r14dZOaY7sdULKX4O3fBP90de48mrgh3qkwm24JdQ==
X-Received: by 2002:a17:902:b20e:: with SMTP id t14mr13054212plr.24.1600068651011;
        Mon, 14 Sep 2020 00:30:51 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:30:50 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 15/20] net: natsemi: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:34 +0530
Message-Id: <20200914072939.803280-16-allen.lkml@gmail.com>
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
 drivers/net/ethernet/natsemi/ns83820.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/natsemi/ns83820.c b/drivers/net/ethernet/natsemi/ns83820.c
index 8e24c7acf79b..9157c1bffc79 100644
--- a/drivers/net/ethernet/natsemi/ns83820.c
+++ b/drivers/net/ethernet/natsemi/ns83820.c
@@ -923,10 +923,10 @@ static void rx_irq(struct net_device *ndev)
 	spin_unlock_irqrestore(&info->lock, flags);
 }
 
-static void rx_action(unsigned long _dev)
+static void rx_action(struct tasklet_struct *t)
 {
-	struct net_device *ndev = (void *)_dev;
-	struct ns83820 *dev = PRIV(ndev);
+	struct ns83820 *dev = from_tasklet(dev, t, rx_tasklet);
+	struct net_device *ndev = dev->ndev;
 	rx_irq(ndev);
 	writel(ihr, dev->base + IHR);
 
@@ -1927,7 +1927,7 @@ static int ns83820_init_one(struct pci_dev *pci_dev,
 	SET_NETDEV_DEV(ndev, &pci_dev->dev);
 
 	INIT_WORK(&dev->tq_refill, queue_refill);
-	tasklet_init(&dev->rx_tasklet, rx_action, (unsigned long)ndev);
+	tasklet_setup(&dev->rx_tasklet, rx_action);
 
 	err = pci_enable_device(pci_dev);
 	if (err) {
-- 
2.25.1

