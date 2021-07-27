Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7043D7C74
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 19:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231828AbhG0RoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 13:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbhG0Rnx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 13:43:53 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37446C061760
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:53 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id i10so13522791pla.3
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 10:43:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rKuYgIu2M2nAj0qfjxyQ666JNynI0dNfLdDnkg4WsaI=;
        b=WsJmpna1ceWjEz9tXIvjujFr2t06UZx2M3KZ+DUWd3fC6liOEKv7CL5hjA94RME5Bp
         JQRCQvUQ1Km60CMFEn+xf5ublOysTtYAepeG7rcYjJBiBXy8N04Z7/qs3tjZkw2KFo+X
         +1FI8GXxBP9UddP3eWx+ok9LA2MJa/4xeXPdI+Gszyr8rrGozEd/ZKVc6Vzlhb5ICKnC
         a+62OF0oWXQ3Ly0yv8Nbq+lyd4veSA01RweRoMd5IBGVDvk4pPMuQ0rCFyyUhjOYahaO
         fmlJfGzb23CYPd5D1LP3M40XdfdWeX/+aRIn2Lc55x0nraGGyfXV2pTxdSeNUM8cY05h
         vjhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rKuYgIu2M2nAj0qfjxyQ666JNynI0dNfLdDnkg4WsaI=;
        b=cEgW4i8fF/Njtd17yh13flz/ps8060R5T3H+Z4ornen2WPr5BJadZoP4AlwDM5KwLX
         uqdyqcIqpNshkuAwVJbCnzVKxzvsOF1MK7c8vOHCD+KsEGRFamRMPumIpCnOGR3nZDDi
         ZNZ881S1hpMzg8qf/ekFNv1631TeU/6Q262z6v1E3DMdgiOQbgnwzNBGFnr4xU4GdeiC
         OFLR24WWugkXsroSptY9L3iCeA/SRQnovnxmO31FOC5Y9IrP/NeLUBTj6fg7yrVWaVUc
         GsZc4Qp1LxfpRyXTR8Zw1Mxb/KaFoV/ziYmbf6xCAjLsHcTYSElbWJ591TaYf/8kMpwC
         3jcQ==
X-Gm-Message-State: AOAM533nNxmjGh8rSadSUIt0/Xa/OmWbAYAHqj45hnw6ca+/ezj4kkxs
        sX3le0iVkQ2i8cjuSRv9VA8CKA==
X-Google-Smtp-Source: ABdhPJw9/Z15tvzMvGgC7ZJQeZ6wvLcfZ/JBYkKX+ppFqkuRkMvFXDjdNKX1rYUlYz1VdHg/4v/FMA==
X-Received: by 2002:a17:90a:9483:: with SMTP id s3mr4749882pjo.22.1627407832786;
        Tue, 27 Jul 2021 10:43:52 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id t9sm4671944pgc.81.2021.07.27.10.43.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 10:43:52 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 09/10] ionic: enable rxhash only with multiple queues
Date:   Tue, 27 Jul 2021 10:43:33 -0700
Message-Id: <20210727174334.67931-10-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210727174334.67931-1-snelson@pensando.io>
References: <20210727174334.67931-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If there's only one queue, there is no need to enable
the rxhashing.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 3a72403cf4df..78b3b8ca23dc 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1607,7 +1607,6 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 	features = NETIF_F_HW_VLAN_CTAG_TX |
 		   NETIF_F_HW_VLAN_CTAG_RX |
 		   NETIF_F_HW_VLAN_CTAG_FILTER |
-		   NETIF_F_RXHASH |
 		   NETIF_F_SG |
 		   NETIF_F_HW_CSUM |
 		   NETIF_F_RXCSUM |
@@ -1615,6 +1614,9 @@ static int ionic_init_nic_features(struct ionic_lif *lif)
 		   NETIF_F_TSO6 |
 		   NETIF_F_TSO_ECN;
 
+	if (lif->nxqs > 1)
+		features |= NETIF_F_RXHASH;
+
 	err = ionic_set_nic_features(lif, features);
 	if (err)
 		return err;
-- 
2.17.1

