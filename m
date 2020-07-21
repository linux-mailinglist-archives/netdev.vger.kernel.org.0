Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09F3C2289F6
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgGUUeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgGUUeQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:16 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1E5DC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:16 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id q17so1465pfu.8
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WQdUkEmMcEnpjVPZH0PDhLEmtlqqiKx49awEHX5jm18=;
        b=CieJNtIw9CQuA2INnJw3f811HWYaPF7yY+EiEb8KjrSRSWLDCw+ji5ZGFpuf0vg1bc
         2cprPZ7ImV4wlmHATh06LzUuqdFO2tS2akNQfjZhCCYStYQsSCU9OxIOxVsd6DOUk8fC
         xG+wl8NXsG++581giQcJMUp/jsrvWv6s/HqSxZo4pTYWK7mIYnjAXT2Rtr9//5jE47Tw
         XYKHJiR4cY+lTLjHYMM/NijM7ZifKsPxkGmMytYt33ClbUAr6IAJmt8apEqJMAK+ptVI
         EQljA3J/R931tuAFzaeRnDBkR9GxmBi/MEHe/tBlocADBZVftHb25YyT9o3VzkcrDxg3
         d+FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WQdUkEmMcEnpjVPZH0PDhLEmtlqqiKx49awEHX5jm18=;
        b=o0Y+yMiI3uKRonoexhcY83pe7D/19rP0zIY7rHRkfvaAUMUtLWm34mcmJuXdVPlBzc
         xA7sey+tYsKcQ3s8Spgw47xGUdlhL/PULNf9Calc9O0p+fGbCqu31qZBSovfjNHCEJKC
         J8h1XrnJzNMWDHD+hcroosuoKh8Eyasp8dcXPsi1sFDSMQIs/nXy94HaD010BqdRNDa2
         HkhZQuGBEF9lsfY8DcS6Bg+KCmkEWdqLGliOwEjUjM9uOjqQrWydbjiU73iyE/OefdSf
         oI1UbXZXQoJgi6KpT2hV/jKeYv/RfWQf0jZzkTw8Mkp7hIoS2MRUCL3uRCRGLwgQAHn3
         obEA==
X-Gm-Message-State: AOAM5316RWrlT+W9Y5eAfyKGQlH49SSBee24ufYoNsnZNuU+xOQUZcZh
        QpbMM1BE8bRQiH1Lehw2uF2yaHBCL/0=
X-Google-Smtp-Source: ABdhPJwgm3AM23ejDYpkYgkTCQbTArglq9qhbKL92oPYqp7r/rNEoKBb6+7D2lY5FarQTE/pK1BZyQ==
X-Received: by 2002:a62:e712:: with SMTP id s18mr25731409pfh.224.1595363656030;
        Tue, 21 Jul 2020 13:34:16 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:15 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 1/6] ionic: get MTU from lif identity
Date:   Tue, 21 Jul 2020 13:34:04 -0700
Message-Id: <20200721203409.3432-2-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change from using hardcoded MTU limits and instead use the
firmware defined limits. The value from the LIF attributes is
the frame size, so we take off the header size to convert to
MTU size.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_dev.h |  2 --
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 17 ++++++++++++++---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h |  1 +
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_dev.h b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
index 525434f10025..d5cba502abca 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_dev.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_dev.h
@@ -10,8 +10,6 @@
 #include "ionic_if.h"
 #include "ionic_regs.h"
 
-#define IONIC_MIN_MTU			ETH_MIN_MTU
-#define IONIC_MAX_MTU			9194
 #define IONIC_MAX_TX_DESC		8192
 #define IONIC_MAX_RX_DESC		16384
 #define IONIC_MIN_TXRX_DESC		16
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index f49486b6d04d..cfcef41b7b23 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -5,6 +5,7 @@
 #include <linux/dynamic_debug.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/if_vlan.h>
 #include <linux/rtnetlink.h>
 #include <linux/interrupt.h>
 #include <linux/pci.h>
@@ -2022,11 +2023,16 @@ int ionic_reset_queues(struct ionic_lif *lif, ionic_reset_cb cb, void *arg)
 static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index)
 {
 	struct device *dev = ionic->dev;
+	union ionic_lif_identity *lid;
 	struct net_device *netdev;
 	struct ionic_lif *lif;
 	int tbl_sz;
 	int err;
 
+	lid = kzalloc(sizeof(*lid), GFP_KERNEL);
+	if (!lid)
+		return ERR_PTR(-ENOMEM);
+
 	netdev = alloc_etherdev_mqs(sizeof(*lif),
 				    ionic->ntxqs_per_lif, ionic->ntxqs_per_lif);
 	if (!netdev) {
@@ -2045,8 +2051,12 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 	netdev->watchdog_timeo = 2 * HZ;
 	netif_carrier_off(netdev);
 
-	netdev->min_mtu = IONIC_MIN_MTU;
-	netdev->max_mtu = IONIC_MAX_MTU;
+	lif->identity = lid;
+	lif->lif_type = IONIC_LIF_TYPE_CLASSIC;
+	ionic_lif_identify(ionic, lif->lif_type, lif->identity);
+	lif->netdev->min_mtu = le32_to_cpu(lif->identity->eth.min_frame_size);
+	lif->netdev->max_mtu =
+		le32_to_cpu(lif->identity->eth.max_frame_size) - ETH_HLEN - VLAN_HLEN;
 
 	lif->neqs = ionic->neqs_per_lif;
 	lif->nxqs = ionic->ntxqs_per_lif;
@@ -2113,6 +2123,7 @@ static struct ionic_lif *ionic_lif_alloc(struct ionic *ionic, unsigned int index
 err_out_free_netdev:
 	free_netdev(lif->netdev);
 	lif = NULL;
+	kfree(lid);
 
 	return ERR_PTR(err);
 }
@@ -2132,7 +2143,6 @@ int ionic_lifs_alloc(struct ionic *ionic)
 		return -ENOMEM;
 	}
 
-	lif->lif_type = IONIC_LIF_TYPE_CLASSIC;
 	ionic_lif_queue_identify(lif);
 
 	return 0;
@@ -2243,6 +2253,7 @@ static void ionic_lif_free(struct ionic_lif *lif)
 		ionic_lif_reset(lif);
 
 	/* free lif info */
+	kfree(lif->identity);
 	dma_free_coherent(dev, lif->info_sz, lif->info, lif->info_pa);
 	lif->info = NULL;
 	lif->info_pa = 0;
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index ed126dd74e01..949f96dc9cd8 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -184,6 +184,7 @@ struct ionic_lif {
 	u16 lif_type;
 	unsigned int nucast;
 
+	union ionic_lif_identity *identity;
 	struct ionic_lif_info *info;
 	dma_addr_t info_pa;
 	u32 info_sz;
-- 
2.17.1

