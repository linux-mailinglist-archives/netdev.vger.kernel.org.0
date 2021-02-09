Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5796314BFE
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 10:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbhBIJpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 04:45:53 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:38554 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230122AbhBIJnu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 04:43:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9D909204EF;
        Tue,  9 Feb 2021 10:43:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id So_PXF4qz-O6; Tue,  9 Feb 2021 10:43:08 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2FCF52006C;
        Tue,  9 Feb 2021 10:43:08 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 9 Feb 2021 10:43:08 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 9 Feb 2021
 10:43:07 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 5DD093180130; Tue,  9 Feb 2021 10:43:08 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 1/4] xfrm: interface: enable TSO on xfrm interfaces
Date:   Tue, 9 Feb 2021 10:43:02 +0100
Message-ID: <20210209094305.3529418-2-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210209094305.3529418-1-steffen.klassert@secunet.com>
References: <20210209094305.3529418-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eyal Birger <eyal.birger@gmail.com>

Underlying xfrm output supports gso packets.
Declare support in hw_features and adapt the xmit MTU check to pass GSO
packets.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/xfrm/xfrm_interface.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 697cdcfbb5e1..495b1f5c979b 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -296,7 +296,8 @@ xfrmi_xmit2(struct sk_buff *skb, struct net_device *dev, struct flowi *fl)
 	}
 
 	mtu = dst_mtu(dst);
-	if (skb->len > mtu) {
+	if ((!skb_is_gso(skb) && skb->len > mtu) ||
+	    (skb_is_gso(skb) && !skb_gso_validate_network_len(skb, mtu))) {
 		skb_dst_update_pmtu_no_confirm(skb, mtu);
 
 		if (skb->protocol == htons(ETH_P_IPV6)) {
@@ -564,6 +565,11 @@ static void xfrmi_dev_setup(struct net_device *dev)
 	eth_broadcast_addr(dev->broadcast);
 }
 
+#define XFRMI_FEATURES (NETIF_F_SG |		\
+			NETIF_F_FRAGLIST |	\
+			NETIF_F_GSO_SOFTWARE |	\
+			NETIF_F_HW_CSUM)
+
 static int xfrmi_dev_init(struct net_device *dev)
 {
 	struct xfrm_if *xi = netdev_priv(dev);
@@ -581,6 +587,8 @@ static int xfrmi_dev_init(struct net_device *dev)
 	}
 
 	dev->features |= NETIF_F_LLTX;
+	dev->features |= XFRMI_FEATURES;
+	dev->hw_features |= XFRMI_FEATURES;
 
 	if (phydev) {
 		dev->needed_headroom = phydev->needed_headroom;
-- 
2.25.1

