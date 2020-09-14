Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28A492685F5
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 09:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbgINHbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 03:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbgINHbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 03:31:07 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8FDC06178A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:31:06 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so11870469pfc.7
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 00:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=G2YJJHZ1leUq1N8E18rQ9NCCVB3HJgG64yXaIhFx97s=;
        b=PDFb++eXxAF8FcPsuVrWVMbvuj72tdFsPJ1VOQIz4SjbIX6+XyEGltpf21kH42dv2O
         ebK3YXMoagFkNd0FioXcke/chWAMGp8iRR3FmYP7JblBzQsarKgI1EZEUQ/lEQ/6lt3N
         kl6VOZSi343g2ArD7F1ZSrcYJHCs+MWLOOrJNkSrefO6hM7GqFeTBWUK+Nb/tAkd5cE+
         l74Ri1SLLvJr2JwV23eiNuNLrYQydvzBJnGQFGZT9k+yqbQCsSLdvrFIjTSw+1RMVLAI
         6zVV0OBXmeKNxYaArMbBU/hZ9uypCfZvSenSWqAN7KEHxGUNTeG1gqe1nliVh2y7JW9n
         nXGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=G2YJJHZ1leUq1N8E18rQ9NCCVB3HJgG64yXaIhFx97s=;
        b=Ee0j8nm7RKPPqKtuPKCVJASDpN20p37cSIhfAVsI1I0xzPA5VEdsaIQg/tmkhGeJnM
         zmN+eeEcLyFwT9nPJuORqXwvzQzWT0GRritCbf7QZk61EeDcyNJc49vWamRNUNJeut+o
         rvy37TjeE0mRUT4l7xU5LB72YwE21k9qdkWeuM9E26c/OkqO/gLtvItFIDRF+Vhuoozz
         +8f69+1UTTOusAzuMActKRM/olMeX9eubQBJ9Y42qoOrbPtueEzZG7NABsLz8MoiD97A
         uuUxKxQEfFWlr2lBVTsaDnIn1laY2IK8+2jxipUR9Yt6Cfk6Xms2vnJ4pjltd5aJan8Q
         qKBQ==
X-Gm-Message-State: AOAM530pq8CfI6phEH1U4hfCZCjMokaAdMJ1L6mdLs9ip3Elf7eW1FBH
        pC3wJr5I2TGsCGECGh3YePxDk5Po7Hv1hQ==
X-Google-Smtp-Source: ABdhPJysSIOx43BVm2ElwcpYvlfgkvCjyaN6RhnVo5OEkKJJwDIGDygF4W500uEh9G7hU8p8kHI6lA==
X-Received: by 2002:a17:902:fe15:: with SMTP id g21mr13169836plj.22.1600068666376;
        Mon, 14 Sep 2020 00:31:06 -0700 (PDT)
Received: from localhost.localdomain ([49.207.192.250])
        by smtp.gmail.com with ESMTPSA id a16sm7609057pgh.48.2020.09.14.00.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2020 00:31:05 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [net-next v3 19/20] net: silan: convert tasklets to use new tasklet_setup() API
Date:   Mon, 14 Sep 2020 12:59:38 +0530
Message-Id: <20200914072939.803280-20-allen.lkml@gmail.com>
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
 drivers/net/ethernet/silan/sc92031.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/silan/sc92031.c b/drivers/net/ethernet/silan/sc92031.c
index f94078f8ebe5..8dc7143839ad 100644
--- a/drivers/net/ethernet/silan/sc92031.c
+++ b/drivers/net/ethernet/silan/sc92031.c
@@ -301,6 +301,7 @@ struct sc92031_priv {
 
 	/* for dev->get_stats */
 	long			rx_value;
+	struct net_device	*ndev;
 };
 
 /* I don't know which registers can be safely read; however, I can guess
@@ -829,10 +830,10 @@ static void _sc92031_link_tasklet(struct net_device *dev)
 	}
 }
 
-static void sc92031_tasklet(unsigned long data)
+static void sc92031_tasklet(struct tasklet_struct *t)
 {
-	struct net_device *dev = (struct net_device *)data;
-	struct sc92031_priv *priv = netdev_priv(dev);
+	struct  sc92031_priv *priv = from_tasklet(priv, t, tasklet);
+	struct net_device *dev = priv->ndev;
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
@@ -1443,10 +1444,11 @@ static int sc92031_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev->ethtool_ops	= &sc92031_ethtool_ops;
 
 	priv = netdev_priv(dev);
+	priv->ndev = dev;
 	spin_lock_init(&priv->lock);
 	priv->port_base = port_base;
 	priv->pdev = pdev;
-	tasklet_init(&priv->tasklet, sc92031_tasklet, (unsigned long)dev);
+	tasklet_setup(&priv->tasklet, sc92031_tasklet);
 	/* Fudge tasklet count so the call to sc92031_enable_interrupts at
 	 * sc92031_open will work correctly */
 	tasklet_disable_nosync(&priv->tasklet);
-- 
2.25.1

