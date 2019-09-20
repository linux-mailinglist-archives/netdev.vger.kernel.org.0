Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547BCB8A38
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 06:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729668AbfITEtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Sep 2019 00:49:15 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51684 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729387AbfITEtP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Sep 2019 00:49:15 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1E6F220299;
        Fri, 20 Sep 2019 06:49:14 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5ITKK20hnngu; Fri, 20 Sep 2019 06:49:13 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 34A1D205B5;
        Fri, 20 Sep 2019 06:49:13 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Sep 2019
 06:49:13 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id C248C3182610;
 Fri, 20 Sep 2019 06:49:12 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Steffen Klassert <steffen.klassert@secunet.com>,
        Willem de Bruijn <willemb@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Subash Abhinov Kasiviswanathan" <subashab@codeaurora.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [PATCH RFC 2/5] net: Add fraglist GRO/GSO feature flags
Date:   Fri, 20 Sep 2019 06:49:02 +0200
Message-ID: <20190920044905.31759-3-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190920044905.31759-1-steffen.klassert@secunet.com>
References: <20190920044905.31759-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds new Fraglist GRO/GSO feature flags. They will be used
to configure fraglist GRO/GSO what will be implemented with some
followup paches.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/netdev_features.h | 6 +++++-
 include/linux/netdevice.h       | 1 +
 include/linux/skbuff.h          | 2 ++
 net/core/ethtool.c              | 1 +
 4 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/netdev_features.h b/include/linux/netdev_features.h
index 4b19c544c59a..b239507da2a0 100644
--- a/include/linux/netdev_features.h
+++ b/include/linux/netdev_features.h
@@ -53,8 +53,9 @@ enum {
 	NETIF_F_GSO_ESP_BIT,		/* ... ESP with TSO */
 	NETIF_F_GSO_UDP_BIT,		/* ... UFO, deprecated except tuntap */
 	NETIF_F_GSO_UDP_L4_BIT,		/* ... UDP payload GSO (not UFO) */
+	NETIF_F_GSO_FRAGLIST_BIT,		/* ... Fraglist GSO */
 	/**/NETIF_F_GSO_LAST =		/* last bit, see GSO_MASK */
-		NETIF_F_GSO_UDP_L4_BIT,
+		NETIF_F_GSO_FRAGLIST_BIT,
 
 	NETIF_F_FCOE_CRC_BIT,		/* FCoE CRC32 */
 	NETIF_F_SCTP_CRC_BIT,		/* SCTP checksum offload */
@@ -80,6 +81,7 @@ enum {
 
 	NETIF_F_GRO_HW_BIT,		/* Hardware Generic receive offload */
 	NETIF_F_HW_TLS_RECORD_BIT,	/* Offload TLS record */
+	NETIF_F_GRO_FRAGLIST_BIT,	/* Fraglist GRO */
 
 	/*
 	 * Add your fresh new feature above and remember to update
@@ -150,6 +152,8 @@ enum {
 #define NETIF_F_GSO_UDP_L4	__NETIF_F(GSO_UDP_L4)
 #define NETIF_F_HW_TLS_TX	__NETIF_F(HW_TLS_TX)
 #define NETIF_F_HW_TLS_RX	__NETIF_F(HW_TLS_RX)
+#define NETIF_F_GRO_FRAGLIST	__NETIF_F(GRO_FRAGLIST)
+#define NETIF_F_GSO_FRAGLIST	__NETIF_F(GSO_FRAGLIST)
 
 /* Finds the next feature with the highest number of the range of start till 0.
  */
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index d7d5626002e9..4917cf513bd1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -4524,6 +4524,7 @@ static inline bool net_gso_ok(netdev_features_t features, int gso_type)
 	BUILD_BUG_ON(SKB_GSO_ESP != (NETIF_F_GSO_ESP >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_UDP != (NETIF_F_GSO_UDP >> NETIF_F_GSO_SHIFT));
 	BUILD_BUG_ON(SKB_GSO_UDP_L4 != (NETIF_F_GSO_UDP_L4 >> NETIF_F_GSO_SHIFT));
+	BUILD_BUG_ON(SKB_GSO_FRAGLIST != (NETIF_F_GSO_FRAGLIST >> NETIF_F_GSO_SHIFT));
 
 	return (features & feature) == feature;
 }
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 028e684fa974..c72540813ea7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -595,6 +595,8 @@ enum {
 	SKB_GSO_UDP = 1 << 16,
 
 	SKB_GSO_UDP_L4 = 1 << 17,
+
+	SKB_GSO_FRAGLIST = 1 << 18,
 };
 
 #if BITS_PER_LONG > 32
diff --git a/net/core/ethtool.c b/net/core/ethtool.c
index 6288e69e94fc..2eaf94debbf6 100644
--- a/net/core/ethtool.c
+++ b/net/core/ethtool.c
@@ -111,6 +111,7 @@ static const char netdev_features_strings[NETDEV_FEATURE_COUNT][ETH_GSTRING_LEN]
 	[NETIF_F_HW_TLS_RECORD_BIT] =	"tls-hw-record",
 	[NETIF_F_HW_TLS_TX_BIT] =	 "tls-hw-tx-offload",
 	[NETIF_F_HW_TLS_RX_BIT] =	 "tls-hw-rx-offload",
+	[NETIF_F_GRO_FRAGLIST_BIT] =	 "rx-gro-list",
 };
 
 static const char
-- 
2.17.1

