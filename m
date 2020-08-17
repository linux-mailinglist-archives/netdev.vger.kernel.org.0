Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2527245FF0
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728170AbgHQI1T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:27:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728250AbgHQI0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:25 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9861AC061388;
        Mon, 17 Aug 2020 01:26:25 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id t6so7348674pjr.0;
        Mon, 17 Aug 2020 01:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Df7yxK//cmVxvAkf6cXduXiAsh32H2X5cVsb6K8GHGM=;
        b=XNx3Kz/kSLSRc7VTJus4z7RYdORZ86+CFl9HXiWO+FTTDyVpTDjj3setW6Q8pT38mh
         NmOs1/ct0cRXsbBeRTwvx4W1afRcRX6p+G7YG0U9cG5hRYgnLqPpAHCICNeXp8/3MONy
         Xb3t+Azgude6qcZ6sxW9JZsKZzsk9pUn+LymdgQuENerjmXXr6xtfYbelZuiw41dEIdz
         P0wXQ2PtBLxCES+dmV6SBamPReFvL3SyU1HWQp3U4mxHPklRPF+So6pXcy8/wvv8Fb3R
         /UdfL3Ca2orJ4GrTPiExKanCPWj2W3yP+gt/KsqbHMJLz7Lpae2Pp5SYue11557317bf
         LDcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Df7yxK//cmVxvAkf6cXduXiAsh32H2X5cVsb6K8GHGM=;
        b=faxjoWPYRJnQEW9g98fuS9hx49aen021prBJqSg+9Eq/93V1rFw0xg0bRDsrbHPoDE
         dt2u2T9TYOmkYd7J7Bdg4GeKEiiHXr4UI/jmtZqPzKLucFAEXYUrwPj+LAREWqHgBSaq
         kvi11bji5LD5HyzGc06BgriiTl8l62lRGykiDmgdP8y2AL4nObVTUk4TJzKoSMroXPYU
         PLfNwyqo3LeQhtm0XllrLlxCyGQkvTO68x/Co1lhb9GxmdeGYLyVPcPmss67+Iwv69L2
         lmfLgvffNhLOADkg14adjiJaTrF98VyFp2hjZ0BklXPhY+lD2BdEKiOfpFSg0omM/bas
         GlGQ==
X-Gm-Message-State: AOAM532Fa1R2v7yLmI/uSomPL2OeHpS2LYcXNFnovMASPy3yBIlnALHL
        te9GO2oPmUimVnqQKKQt26g=
X-Google-Smtp-Source: ABdhPJy25qZkwLdPxae9MaYOKgL9LadrOvMoVqZOA4GCkZihBoxS6mmIhsQz13i9lJFXT11QTvGjjQ==
X-Received: by 2002:a17:902:264:: with SMTP id 91mr10638591plc.88.1597652785215;
        Mon, 17 Aug 2020 01:26:25 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:24 -0700 (PDT)
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
Subject: [PATCH 15/20] ethernet: natsemi: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:29 +0530
Message-Id: <20200817082434.21176-17-allen.lkml@gmail.com>
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
2.17.1

