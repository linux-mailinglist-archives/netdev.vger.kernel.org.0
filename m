Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3228124879
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 14:35:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLRNfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 08:35:11 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:34878 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfLRNfL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 08:35:11 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E9325204FD;
        Wed, 18 Dec 2019 14:35:09 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pRfgrYyMlVOV; Wed, 18 Dec 2019 14:35:09 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 7D15120080;
        Wed, 18 Dec 2019 14:35:09 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 18 Dec 2019
 14:35:09 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 3B91031809EB;
 Wed, 18 Dec 2019 14:35:09 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH net-next 2/4] net: Add a netdev software feature set that defaults to off.
Date:   Wed, 18 Dec 2019 14:34:56 +0100
Message-ID: <20191218133458.14533-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191218133458.14533-1-steffen.klassert@secunet.com>
References: <20191218133458.14533-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The previous patch added the NETIF_F_GRO_FRAGLIST feature.
This is a software feature that should default to off.
Current software features default to on, so add a new
feature set that defaults to off.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/netdev_features.h | 3 +++
 net/core/dev.c                  | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index b239507da2a0..34d050bb1ae6 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -230,6 +230,9 @@ static inline int find_next_netdev_feature(u64 feature, unsigned long start)
 /* changeable features with no special hardware requirements */
 #define NETIF_F_SOFT_FEATURES	(NETIF_F_GSO | NETIF_F_GRO)
 
+/* Changeable features with no special hardware requirements that defaults to off. */
+#define NETIF_F_SOFT_FEATURES_OFF	NETIF_F_GRO_FRAGLIST
+
 #define NETIF_F_VLAN_FEATURES	(NETIF_F_HW_VLAN_CTAG_FILTER | \
 				 NETIF_F_HW_VLAN_CTAG_RX | \
 				 NETIF_F_HW_VLAN_CTAG_TX | \
diff --git a/net/core/dev.c b/net/core/dev.c
index 2c277b8aba38..092bdbcfb9f8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9269,7 +9269,7 @@ int register_netdevice(struct net_device *dev)
 	/* Transfer changeable features to wanted_features and enable
 	 * software offloads (GSO and GRO).
 	 */
-	dev->hw_features |= NETIF_F_SOFT_FEATURES;
+	dev->hw_features |= (NETIF_F_SOFT_FEATURES | NETIF_F_SOFT_FEATURES_OFF);
 	dev->features |= NETIF_F_SOFT_FEATURES;
 
 	if (dev->netdev_ops->ndo_udp_tunnel_add) {
-- 
2.17.1

