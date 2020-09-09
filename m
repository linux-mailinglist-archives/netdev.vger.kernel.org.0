Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C100262ACA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 10:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbgIIIqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 04:46:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729941AbgIIIqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 04:46:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CED6C061573
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 01:46:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id jw11so1013913pjb.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 01:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PjXMlFVOJ4e0i4gIewgISVhKN2YrI3k+15FHe57lM0s=;
        b=uiOtvkqprfGlYAuzteiXSEMW0rCFQqdHQWeWNND/k3CG+fpqwOcFjUvW3H9visnOV1
         xRgtIeHVQ1tWTzMoAS6zjzBms9PQWPep0AVwyQh1pAED+CS9xacBvtU2scP+mW4zzq7r
         QeCORXCHWPlioH4PR0E8go0l9xNZDiSn2BWOuEDLDaRZ1yRoAIZBpSRLXlndPU+xUHaU
         q3Rs1GNZXkYZdVcy2urBQgFbmVjE0CoOcNQlZ9OhT5t49o94Zka9J76BtusOXXtrry5L
         GLmA+3ddy2n0hwOhjAZjriULUvoc2mTZppPJhgAbm8NVkLcwAebDn8YdJFKvWu59V01N
         pGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PjXMlFVOJ4e0i4gIewgISVhKN2YrI3k+15FHe57lM0s=;
        b=XGld2Z9x+HgHYDU+QeJANGN3cj1pKnadshn7lGa1tZ1IYPLEWczGN4yaVnzaNy/f1W
         i6Lna2RkbLEy08U1gUU2iw4tPOrLznGztlQQ91G25g/jHRINkMavFfMUQ9m42EbiPcL6
         liMFEjEO4ZKIT3xQG8w1vQBNB8GMxNNuG7+CYBewp0b2LUlY9dXWXDBRHEvwyd/zM1kI
         ME9dcQZloP2tC91w6LCs5HcD2kl8lGA/6fRaGVB82iKr49OOMtsw2OEE+1cIO7ZxTpmd
         Oazn9TSoXWnAj4ADT3XrQNkZoeisZu+EJsO9o9lCfZGfT7SHdTjgQMh2QNiUnhc/ympt
         IGzg==
X-Gm-Message-State: AOAM5324iJ6kgWDcfcjMoFEL7eP/ek8lt5gFZOXD73/HJ/UEYaNSYNaK
        184mxYOUSfRZiLQ1TYyyYMQ=
X-Google-Smtp-Source: ABdhPJzKRfAbvPMRbde24C0EzwniJj+FTI1PaOdo+ZUyOxYnQ24uPZ+JkX3SJki9EUR1BYaIpCo4zA==
X-Received: by 2002:a17:90a:4005:: with SMTP id u5mr2565200pjc.7.1599641176813;
        Wed, 09 Sep 2020 01:46:16 -0700 (PDT)
Received: from localhost.localdomain ([49.207.214.52])
        by smtp.gmail.com with ESMTPSA id u21sm1468355pjn.27.2020.09.09.01.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 01:46:16 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [PATCH v2 15/20] ethernet: natsemi: convert tasklets to use new tasklet_setup() API
Date:   Wed,  9 Sep 2020 14:15:05 +0530
Message-Id: <20200909084510.648706-16-allen.lkml@gmail.com>
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

