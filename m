Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C00359C9C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 13:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233823AbhDILFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 07:05:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39364 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233829AbhDILFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 07:05:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617966299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SiT7vLcG+vMLW9KGOEDSZM5J0A+4fEfACAwEYatyA8I=;
        b=FWVy7j6avsqlSkArz6BBYxKTvfSVEVGfSybxSKqOQaFDXf3vhEYMf+jv9jNZxzf2PJx2XR
        ofk3iHYh2FLLXicKLykxeuln59lmRWcQHyXpGyyEmT7Gstr1k+VAE/9uCNykgnY2Y0j37k
        VU7gTes2Q3JkweZJxncaPKheWqPB0B8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-200-DgMyzGA6PMu2C67wWeiIMg-1; Fri, 09 Apr 2021 07:04:55 -0400
X-MC-Unique: DgMyzGA6PMu2C67wWeiIMg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C5441107ACE4;
        Fri,  9 Apr 2021 11:04:54 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-115-50.ams2.redhat.com [10.36.115.50])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 49CBB10074F1;
        Fri,  9 Apr 2021 11:04:53 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>
Subject: [PATCH net-next 3/4] veth: refine napi usage
Date:   Fri,  9 Apr 2021 13:04:39 +0200
Message-Id: <b241da0e8aa31773472591e219ada3632a84dfbb.1617965243.git.pabeni@redhat.com>
In-Reply-To: <cover.1617965243.git.pabeni@redhat.com>
References: <cover.1617965243.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patch, when enabling GRO, locally generated
TCP traffic experiences some measurable overhead, as it traverses
the GRO engine without any chance of aggregation.

This change refine the NAPI receive path admission test, to avoid
unnecessary GRO overhead in most scenarios, when GRO is enabled
on a veth peer.

Only skbs that are eligible for aggregation enter the GRO layer,
the others will go through the traditional receive path.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 drivers/net/veth.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index ca44e82d1edeb..85f90f33d437e 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -282,6 +282,25 @@ static int veth_forward_skb(struct net_device *dev, struct sk_buff *skb,
 		netif_rx(skb);
 }
 
+/* return true if the specified skb has chances of GRO aggregation
+ * Don't strive for accuracy, but try to avoid GRO overhead in the most
+ * common scenarios.
+ * When XDP is enabled, all traffic is considered eligible, as the xmit
+ * device has TSO off.
+ * When TSO is enabled on the xmit device, we are likely interested only
+ * in UDP aggregation, explicitly check for that if the skb is suspected
+ * - the sock_wfree destructor is used by UDP, ICMP and XDP sockets -
+ * to belong to locally generated UDP traffic.
+ */
+static bool veth_skb_is_eligible_for_gro(const struct net_device *dev,
+					 const struct net_device *rcv,
+					 const struct sk_buff *skb)
+{
+	return !(dev->features & NETIF_F_ALL_TSO) ||
+		(skb->destructor == sock_wfree &&
+		 rcv->features & (NETIF_F_GRO_FRAGLIST | NETIF_F_GRO_UDP_FWD));
+}
+
 static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct veth_priv *rcv_priv, *priv = netdev_priv(dev);
@@ -305,8 +324,10 @@ static netdev_tx_t veth_xmit(struct sk_buff *skb, struct net_device *dev)
 
 		/* The napi pointer is available when an XDP program is
 		 * attached or when GRO is enabled
+		 * Don't bother with napi/GRO if the skb can't be aggregated
 		 */
-		use_napi = rcu_access_pointer(rq->napi);
+		use_napi = rcu_access_pointer(rq->napi) &&
+			   veth_skb_is_eligible_for_gro(dev, rcv, skb);
 		skb_record_rx_queue(skb, rxq);
 	}
 
-- 
2.26.2

