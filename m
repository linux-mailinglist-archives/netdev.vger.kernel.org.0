Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBE79245FE6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 10:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbgHQI1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 04:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728007AbgHQI0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 04:26:49 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F16C061388;
        Mon, 17 Aug 2020 01:26:49 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d22so7870247pfn.5;
        Mon, 17 Aug 2020 01:26:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3SmzZTvbfXannYWzT1vvdfD+eue2ti3PQmFQt1sGqfI=;
        b=mVxdCAmlrwsYQJZWYKoyLuTHqKET9xgnJHVg1b42wEWATRvgN28vjs+9yxPGjjBj3q
         +BiTp1jESGn24Bvj7NdntB1gnuMTn62rZA4PSbpZd50xaRScVHCvIcGK1CGMN+NYrofh
         Zekg7tIE6a7JaiyzGOp+nzfFogg3zuhdg4c42EsDm26wgB0apPiElsclleFZiMioqKfD
         VwjM710zSNPJtu0FfHP/jI89WSWw0coLa+WZmZoA8uVe7Mwp7bvOcum3capp11m8AWJb
         3/0K3H9ZhgQY1g0rj9s7ZxkyHWX3iaCNd+wsx8X4cWxiC8OJPL7q43XkcFApldAcZDcZ
         9mwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3SmzZTvbfXannYWzT1vvdfD+eue2ti3PQmFQt1sGqfI=;
        b=VvDW7k+wLHWksNUGVap1FREKiRERtUr2uyPHKsoivTtFfs7STo2aDBhe1JGWMsmsWk
         xc7jeihOojbJQg4qwftmhrCrnjJXJDG1MEz0ZrERgZXxsa6OhNklN/g19oyPu9XhR6YP
         vG8hq0IoHX9uD6JppblaSbn8Y3plLSdOgEeqGZ8P4eu20hQpasvTK7DoLrMCpF3NbaQN
         JHUl9M/LcJJGCf1m8/z6oNtA880GrelzY/Dd5uYKaS2mk2hK7YHmNMnMFJOsBnLZu3Dm
         tinC+rzm62dLNYeVXqUtDdbejGnCWc3BbSVtboqagicvUZiHiNoW8LoFW5f62B+Mhi4D
         da6Q==
X-Gm-Message-State: AOAM532+2NiRvquUEhQuUk19uhq71yyOCGlbjpDMB03zzYKKJ5XJL8FS
        Zdir0jU3KxdI5sQN0Y9YrU0=
X-Google-Smtp-Source: ABdhPJye0HaIKIHr1tF33YyLaOR04c2pC3AzFAUznRzYhHDdY6IPyjwJWo+RevYkvnDPWaqS7Tie5A==
X-Received: by 2002:aa7:9d04:: with SMTP id k4mr10414244pfp.256.1597652808813;
        Mon, 17 Aug 2020 01:26:48 -0700 (PDT)
Received: from localhost.localdomain ([49.207.202.98])
        by smtp.gmail.com with ESMTPSA id r186sm19928482pfr.162.2020.08.17.01.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 01:26:48 -0700 (PDT)
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
Subject: [PATCH 19/20] ethernet: silan: convert tasklets to use new tasklet_setup() API
Date:   Mon, 17 Aug 2020 13:54:33 +0530
Message-Id: <20200817082434.21176-21-allen.lkml@gmail.com>
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
 drivers/net/ethernet/silan/sc92031.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index f94078f8ebe5..8d56eca5be17 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -829,10 +829,11 @@ static void _sc92031_link_tasklet(struct net_device *dev)
 	}
 }
 
-static void sc92031_tasklet(unsigned long data)
+static void sc92031_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct sc92031_priv *priv = netdev_priv(dev);
+	struct  sc92031_priv *priv = from_tasklet(priv, t, tasklet);
+	struct net_device *dev = (struct net_device *)((char *)priv -
+				ALIGN(sizeof(struct net_device), NETDEV_ALIGN));
 	void __iomem *port_base = priv->port_base;
 	u32 intr_status, intr_mask;
 
@@ -1108,7 +1109,7 @@ static void sc92031_poll_controller(struct net_device *dev)
 
 	disable_irq(irq);
 	if (sc92031_interrupt(irq, dev) != IRQ_NONE)
-		sc92031_tasklet((unsigned long)dev);
+		sc92031_tasklet(&priv->tasklet);
 	enable_irq(irq);
 }
 #endif
@@ -1446,7 +1447,7 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	spin_lock_init(&priv->lock);
 	priv->port_base = port_base;
 	priv->pdev = pdev;
-	tasklet_init(&priv->tasklet, sc92031_tasklet, (unsigned long)dev);
+	tasklet_setup(&priv->tasklet, sc92031_tasklet);
 	/* Fudge tasklet count so the call to sc92031_enable_interrupts at
 	 * sc92031_open will work correctly */
 	tasklet_disable_nosync(&priv->tasklet);
-- 
2.17.1

