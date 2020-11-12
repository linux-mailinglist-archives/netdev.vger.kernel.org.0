Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D45B52B0C7A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 19:22:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKLSW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 13:22:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbgKLSWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 13:22:22 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8E9AC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:22 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id w6so5338455pfu.1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 10:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ThuSp1nWjUdZnFZrlwwu4dXM5FADWV5pVgbm5tfIdyk=;
        b=WYs16sjEE4omgATI/7uob/4Y20BE4qbGZQhvqkGtLoUtMKTI8z3CTa8HwGZ6dRO0VP
         S2tSp3k4J5LLm8oj1V7QYfZbmMQk2jJbFR7SrH6ZILLgMIbcf9L6/IfF285xk8bmiZ9h
         JRDlmIWoZzVnGD1RIXsCHUTAShj81E/08yn+VDKjGjmAm1u3AGgDVOsEiFamH2HyAr6z
         LCndHneLOcCcLJAu8byHxi3SRg9m4c8H/TIBcR/XQVvTlRfGkWCeECx16ls2xK21FBUI
         bhIrNq+KBXjmkPoy8+wozThCDBlq9xQnAfcujGhmwolRs9DTInrG2Vyx9f6s6zLknXFU
         6Gew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ThuSp1nWjUdZnFZrlwwu4dXM5FADWV5pVgbm5tfIdyk=;
        b=sib9zkAPiVx9I53yvf1eA/JY9AarWLVlu/9++gAZGoqrCkMIef2W3jtqos3B8xzVC/
         fF6UraF4JW7vWefy+RSSLiMCi27SLWmyFqtZb4P6gCe6JbPTzUVQvsDFiPp6Ve3YC8Ql
         kCo0aXYQ7rMFDihZDHHyQ5RPc6+8YVl/8PAqrTWuhcai1b2R2OAUF96cuSos87HLvdYr
         +V+nmv6cOhxq3EBtaI1p9CsMHs6ysJbLrfyFFE86CpFavvPy+m8v/JgNYTUeao9WA3MA
         C6zVR9GkxggA31bdp0I65OyEzBIO+Sy1VYzwMwYjHOo4kyNYmmSgnOPjOo2dHva3Fcia
         IvKg==
X-Gm-Message-State: AOAM530n2xehD3EryDnOSiOERb2yFEY7F4WGPfPYOwscVXqn6JrWs8ja
        FB+kLpCasgjxHgDLqCMtIUxRSooNAu3urw==
X-Google-Smtp-Source: ABdhPJxwZwZEsvXZFr0r4k484CEAnPxhgYYSBiODiNM/04wDyosQkL+cQgcAF2HIgbcgSZjG8I59OA==
X-Received: by 2002:a65:4b8e:: with SMTP id t14mr591830pgq.99.1605205342139;
        Thu, 12 Nov 2020 10:22:22 -0800 (PST)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id m6sm7152292pfa.61.2020.11.12.10.22.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Nov 2020 10:22:21 -0800 (PST)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH v3 net-next 5/8] ionic: use mc sync for multicast filters
Date:   Thu, 12 Nov 2020 10:22:05 -0800
Message-Id: <20201112182208.46770-6-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201112182208.46770-1-snelson@pensando.io>
References: <20201112182208.46770-1-snelson@pensando.io>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should be using the multicast sync routines for the multicast
filters.  Also, let's just flatten the logic a bit and pull
the small unicast routine back into ionic_set_rx_mode().

Fixes: 1800eee16676 ("net: ionic: Replace in_interrupt() usage.")
Signed-off-by: Shannon Nelson <snelson@pensando.io>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../net/ethernet/pensando/ionic/ionic_lif.c   | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index e5ed8231317a..13c7ac904611 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -1149,15 +1149,6 @@ static void _ionic_lif_rx_mode(struct ionic_lif *lif, unsigned int rx_mode,
 	}
 }
 
-static void ionic_dev_uc_sync(struct net_device *netdev, bool from_ndo)
-{
-	if (from_ndo)
-		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
-	else
-		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
-
-}
-
 static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
@@ -1177,7 +1168,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	 *       we remove our overflow flag and check the netdev flags
 	 *       to see if we can disable NIC PROMISC
 	 */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	if (from_ndo)
+		__dev_uc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_uc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_ucast_filters);
 	if (netdev_uc_count(netdev) + 1 > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_PROMISC;
@@ -1189,7 +1183,10 @@ static void ionic_set_rx_mode(struct net_device *netdev, bool from_ndo)
 	}
 
 	/* same for multicast */
-	ionic_dev_uc_sync(netdev, from_ndo);
+	if (from_ndo)
+		__dev_mc_sync(netdev, ionic_ndo_addr_add, ionic_ndo_addr_del);
+	else
+		__dev_mc_sync(netdev, ionic_addr_add, ionic_addr_del);
 	nfilters = le32_to_cpu(lif->identity->eth.max_mcast_filters);
 	if (netdev_mc_count(netdev) > nfilters) {
 		rx_mode |= IONIC_RX_MODE_F_ALLMULTI;
-- 
2.17.1

