Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29CFB2002E3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 09:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbgFSHn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 03:43:57 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:34780 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730955AbgFSHnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 03:43:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2C4B92057E;
        Fri, 19 Jun 2020 09:43:51 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id r877RYVS0Bas; Fri, 19 Jun 2020 09:43:47 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E6C512056D;
        Fri, 19 Jun 2020 09:43:46 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 19 Jun 2020 09:43:46 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 19 Jun
 2020 09:43:46 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E2CFD31800BD;
 Fri, 19 Jun 2020 09:43:45 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/5] xfrm: Fix double ESP trailer insertion in IPsec crypto offload.
Date:   Fri, 19 Jun 2020 09:43:38 +0200
Message-ID: <20200619074342.14095-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200619074342.14095-1-steffen.klassert@secunet.com>
References: <20200619074342.14095-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

During IPsec performance testing, we see bad ICMP checksum. The error packet
has duplicated ESP trailer due to double validate_xmit_xfrm calls. The first call
is from ip_output, but the packet cannot be sent because
netif_xmit_frozen_or_stopped is true and the packet gets dev_requeue_skb. The second
call is from NET_TX softirq. However after the first call, the packet already
has the ESP trailer.

Fix by marking the skb with XFRM_XMIT bit after the packet is handled by
validate_xmit_xfrm to avoid duplicate ESP trailer insertion.

Fixes: f6e27114a60a ("net: Add a xfrm validate function to validate_xmit_skb")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Boris Pismenny <borisp@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/net/xfrm.h     | 1 +
 net/xfrm/xfrm_device.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 094fe682f5d7..c7d213c9f9d8 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1008,6 +1008,7 @@ struct xfrm_offload {
 #define	XFRM_GRO		32
 #define	XFRM_ESP_NO_TRAILER	64
 #define	XFRM_DEV_RESUME		128
+#define	XFRM_XMIT		256
 
 	__u32			status;
 #define CRYPTO_SUCCESS				1
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index f50d1f97cf8e..626096bd0d29 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -108,7 +108,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	struct xfrm_offload *xo = xfrm_offload(skb);
 	struct sec_path *sp;
 
-	if (!xo)
+	if (!xo || (xo->flags & XFRM_XMIT))
 		return skb;
 
 	if (!(features & NETIF_F_HW_ESP))
@@ -129,6 +129,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
+	xo->flags |= XFRM_XMIT;
+
 	if (skb_is_gso(skb)) {
 		struct net_device *dev = skb->dev;
 
-- 
2.17.1

