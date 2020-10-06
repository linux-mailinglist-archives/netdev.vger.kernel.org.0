Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 362442845D4
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 08:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgJFGMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 02:12:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbgJFGMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 02:12:21 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC3E4C0613A7
        for <netdev@vger.kernel.org>; Mon,  5 Oct 2020 23:12:21 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id gm14so1051642pjb.2
        for <netdev@vger.kernel.org>; Mon, 05 Oct 2020 23:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XtYAHLGQp5a8nA/p44315exvsBdm564sL0Emr+HilCY=;
        b=T84M37x39ubfP6XQULROfrO7I587+unBtdaLQuZ4wfRTl/iw9CPkBukQ2WhE2R0Yit
         1rFN9HToavoLs+K6nMVaxA53CCPV5a8uKy3BgciuILiPMLrcYexnqHbkcbZ1vcsZQ63x
         FWAAgpN7zv5nRGfSKtBo6jvoQTV1LPbNyV+YQgLskmQWHxkcysyo/gDC9Cn4EeBRZiZ4
         YCxVV7T7bRLZXdGgjlIUNtJVrNJKByPIvdu878fck/y2z79GQBpbyhutK7i71adv0INt
         3H8G4GAHPCoBmj4ajrReYzYwuz5CaH6K5H0o7BvY4Zm0i9d8mkP2iNiKQf97DtqH29n/
         kVbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XtYAHLGQp5a8nA/p44315exvsBdm564sL0Emr+HilCY=;
        b=FgTJop/BNVEAiwVDtsyxXBcpxgJblPoPAlyLKNxcsQ7oHvzIlkDcuuLjqb+Th+5vwe
         GT6VoDTuFqjf76Ulah7lSg1gaUygkah0hq/jldlC1RSi1JSGGfKKOq8sj6NCuNLGS9uL
         RyyQIZkIiVUWq0CcdGClY7q7pE1vH9JTflmBetZk/2F/V47orispzkaF777lMUN8IAt/
         JrabH4hZbYEd2AxaUNp9o4vuB+mAen1jeMJfa9ZtZE1+RDpOZjXp4qls/FleiQwLN9Ci
         18IXXoT56DxCmQ7FnPQT9c9EBDFWQrotAMsgpKs1X9U0tUh7dQg755nIh3GgQcpkC1I7
         2tsg==
X-Gm-Message-State: AOAM5301dGS/8YWJygUWjzGUWemhMFMnMROHxdLf0dVa9Qb4Obto7Qme
        BLMDrEidp8p6RHfh7acbRvM=
X-Google-Smtp-Source: ABdhPJyh9h1IwRDOw0GKoy9hdwfIFOszSIbIpaLXdl+zOyCJ1e5Pudeh1nIqtHUllbByaluF0n4bbw==
X-Received: by 2002:a17:90a:8585:: with SMTP id m5mr2805798pjn.69.1601964741310;
        Mon, 05 Oct 2020 23:12:21 -0700 (PDT)
Received: from localhost.localdomain ([49.207.203.202])
        by smtp.gmail.com with ESMTPSA id c12sm2046410pfj.164.2020.10.05.23.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 23:12:20 -0700 (PDT)
From:   Allen Pais <allen.lkml@gmail.com>
To:     davem@davemloft.net
Cc:     m.grzeschik@pengutronix.de, kuba@kernel.org, paulus@samba.org,
        oliver@neukum.org, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, petkan@nucleusys.com,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: [next-next v3 02/10] net: caif: convert tasklets to use new tasklet_setup() API
Date:   Tue,  6 Oct 2020 11:41:51 +0530
Message-Id: <20201006061159.292340-3-allen.lkml@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201006061159.292340-1-allen.lkml@gmail.com>
References: <20201006061159.292340-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 drivers/net/caif/caif_virtio.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/caif/caif_virtio.c b/drivers/net/caif/caif_virtio.c
index 47a6d62b7..106f089eb 100644
--- a/drivers/net/caif/caif_virtio.c
+++ b/drivers/net/caif/caif_virtio.c
@@ -598,9 +598,9 @@ static netdev_tx_t cfv_netdev_tx(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static void cfv_tx_release_tasklet(unsigned long drv)
+static void cfv_tx_release_tasklet(struct tasklet_struct *t)
 {
-	struct cfv_info *cfv = (struct cfv_info *)drv;
+	struct cfv_info *cfv = from_tasklet(cfv, t, tx_release_tasklet);
 	cfv_release_used_buf(cfv->vq_tx);
 }
 
@@ -716,9 +716,7 @@ static int cfv_probe(struct virtio_device *vdev)
 	cfv->ctx.head = USHRT_MAX;
 	netif_napi_add(netdev, &cfv->napi, cfv_rx_poll, CFV_DEFAULT_QUOTA);
 
-	tasklet_init(&cfv->tx_release_tasklet,
-		     cfv_tx_release_tasklet,
-		     (unsigned long)cfv);
+	tasklet_setup(&cfv->tx_release_tasklet, cfv_tx_release_tasklet);
 
 	/* Carrier is off until netdevice is opened */
 	netif_carrier_off(netdev);
-- 
2.25.1

