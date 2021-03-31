Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B11734FB6A
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbhCaITc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:19:32 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:48064 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234385AbhCaIS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 04:18:56 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C699A20569;
        Wed, 31 Mar 2021 10:18:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1WgzlzigKh9o; Wed, 31 Mar 2021 10:18:55 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 666AB20571;
        Wed, 31 Mar 2021 10:18:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 31 Mar 2021 10:18:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 31 Mar
 2021 10:18:53 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9D74D3180634; Wed, 31 Mar 2021 10:18:52 +0200 (CEST)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 07/11] esp: delete NETIF_F_SCTP_CRC bit from features for esp offload
Date:   Wed, 31 Mar 2021 10:18:43 +0200
Message-ID: <20210331081847.3547641-8-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331081847.3547641-1-steffen.klassert@secunet.com>
References: <20210331081847.3547641-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

Now in esp4/6_gso_segment(), before calling inner proto .gso_segment,
NETIF_F_CSUM_MASK bits are deleted, as HW won't be able to do the
csum for inner proto due to the packet encrypted already.

So the UDP/TCP packet has to do the checksum on its own .gso_segment.
But SCTP is using CRC checksum, and for that NETIF_F_SCTP_CRC should
be deleted to make SCTP do the csum in own .gso_segment as well.

In Xiumei's testing with SCTP over IPsec/veth, the packets are kept
dropping due to the wrong CRC checksum.

Reported-by: Xiumei Mu <xmu@redhat.com>
Fixes: 7862b4058b9f ("esp: Add gso handlers for esp4 and esp6")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c | 6 ++++--
 net/ipv6/esp6_offload.c | 6 ++++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 601f5fbfc63f..ed3de486ea34 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -217,10 +217,12 @@ static struct sk_buff *esp4_gso_segment(struct sk_buff *skb,
 
 	if ((!(skb->dev->gso_partial_features & NETIF_F_HW_ESP) &&
 	     !(features & NETIF_F_HW_ESP)) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 	else if (!(features & NETIF_F_HW_ESP_TX_CSUM) &&
 		 !(skb->dev->gso_partial_features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516fb30e1..f35203ab39f5 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -254,9 +254,11 @@ static struct sk_buff *esp6_gso_segment(struct sk_buff *skb,
 	skb->encap_hdr_csum = 1;
 
 	if (!(features & NETIF_F_HW_ESP) || x->xso.dev != skb->dev)
-		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK);
+		esp_features = features & ~(NETIF_F_SG | NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 	else if (!(features & NETIF_F_HW_ESP_TX_CSUM))
-		esp_features = features & ~NETIF_F_CSUM_MASK;
+		esp_features = features & ~(NETIF_F_CSUM_MASK |
+					    NETIF_F_SCTP_CRC);
 
 	xo->flags |= XFRM_GSO_SEGMENT;
 
-- 
2.25.1

