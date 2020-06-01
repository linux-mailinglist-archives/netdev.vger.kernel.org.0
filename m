Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670D41EB10B
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 23:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728818AbgFAVj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 17:39:56 -0400
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:46759 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728182AbgFAVj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 17:39:56 -0400
Received: from Internal Mail-Server by MTLPINE2 (envelope-from huyn@mellanox.com)
        with ESMTPS (AES256-SHA encrypted); 2 Jun 2020 00:39:54 +0300
Received: from sw-mtx-011.mtx.labs.mlnx. (sw-mtx-011.mtx.labs.mlnx [10.9.150.38])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 051LdpfA026614;
        Tue, 2 Jun 2020 00:39:52 +0300
From:   Huy Nguyen <huyn@mellanox.com>
To:     davem@davemloft.net
Cc:     steffen.klassert@secunet.com, saeedm@mellanox.com,
        borisp@mellanox.com, raeds@mellanox.com, netdev@vger.kernel.org,
        huyn@nvidia.com, Huy Nguyen <huyn@mellanox.com>
Subject: [PATCH] xfrm: Fix double ESP trailer insertion in IPsec crypto offload.
Date:   Mon,  1 Jun 2020 16:39:37 -0500
Message-Id: <1591047577-18113-1-git-send-email-huyn@mellanox.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <6d0d27dceb774236d79d16e44a3b9406ac8a767b.camel@mellanox.com>
References: <6d0d27dceb774236d79d16e44a3b9406ac8a767b.camel@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 include/net/xfrm.h     | 1 +
 net/xfrm/xfrm_device.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 094fe68..c7d213c 100644
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
index f50d1f9..626096b 100644
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
1.8.3.1

