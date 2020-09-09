Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC87262AD7
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgIIIrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729993AbgIIIqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:32 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17CDC061755
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x123so1547276pfc.7
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e1DqThIxcgkkSH7JhlwB5IFFaSNM9DTU0sdoZsrDzFY=;
        b=QlwuFOhpr9+cHSSUWqEc3vXQrzfD+XVC9IPugIoNDYWTUKbWcFoQM8mVt9rikAQhhc
         JhHqKi+b/zxIXzL+p0DzCDwMiDZvSZ3AKRjvT0GAGRslfOukE3l6dL95USudBK0R4sV0
         IiMgP6JMlGTRLel6udnNl2YQBcljEtZ8AWzkncjJULxmolwvgh7wsQ1gKuSxUyrOV6Km
         8apGM8+3e4ZfRWChVbvXYSQB45ypvu/QZGjLSALURGt2sP7DSbXjtn3F8pkSnXieSLvh
         MCFPvKV7PeBimNpWGB1IsXlpcX8Cpn5y9Es+3ZziqqjeFtqEdMhtzKxj8BmNKjFLOETX
         xKBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e1DqThIxcgkkSH7JhlwB5IFFaSNM9DTU0sdoZsrDzFY=;
        b=dK1x2DJczzTgc+Oosc8IO7YYiBJ6L+KSdQ5CNTewy42XWwHZq6szaN1Bhjm/Oedb4t
         gEMJ9fkRitXNBtKECu5pRyCMHgtH7pCD/myJvA8cpilnU1FiWLhGOtfXpKE1LnOhYtVK
         XS+e+Kt97wGsqRUiCtGS23tUotzGSX+CMSF6LYaVjm89yyExbsTAjWxoLjLdO/dQDBN+
         o0wCdHgZu8nbWVfgiG3SE5/K2c+BoPUiPQ5pg9K7dxHkoRKT6fbkOBXjZKg6Q6sKa1/9
         E2pza4+J9TYIsPsyPN+eRWtTT0gTsGoIoWRT1sw0QsN21tHMNbS2Z4Qpc7bWip4aoo54
         ePDg==
X-Gm-Message-State: AOAM531qjDQqNXG3sOaYfGVvhABfLDrMBXgqEj2b00SK79pqvvXMtiel
        y2CSgk5wJZTyqqOVhc8CE58=
X-Google-Smtp-Source: ABdhPJzU1/SUgCP03ZbsqbFapejzUyuQKlfhEVEoveC+iSFbwywvqVrcqPpCX5oBrTGiSQ4wLGFdgA==
X-Received: by 2002:a63:3742:: with SMTP id g2mr2141937pgn.71.1599641191455;
        Wed, 09 Sep 2020 01:46:31 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:31 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 19/20] ethernet: silan: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:09 +0530
Message-Id: <20200909084510.648706-20-allen.lkml@gmail.com>
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
2.25.1

