Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95FB64A7D93
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234221AbiBCBw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348899AbiBCBwT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:19 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9A0C06174E
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:19 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id e28so915682pfj.5
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Whx1xUX7BipnQyYzQ0qIm3Bt6BwvkXA771DSm71Btnc=;
        b=EPG5TwhVPZEFDquT32VSQdBWzl1Js7JsD/a/ge3gBDLjllB4Rk1puiQ6OzO+CvGw6u
         q2yUMR6Qr7mmZxtuQvoPXdUWPAQCBTlShNi6S7Z3u4LyIMDW1e/VwMa/EGMaiqG8GnPD
         Blwb/g8AE/h13+bJMKfgJNAq/9i9sBVHKhXCxAQ6q6ZCAwnI8SVhJIKKkyWSKPlK4uDh
         OAs82K9fc0ZAnwNoFucHCfrljFwfIZ64zrOVQdAUuSakqfplbh87xzilbCe3x4awKWgl
         zJbeXrKBVir6l7tQ1i0BhweuOqe1TooA1uvW1VaF3Mg5Sy8HVYaVSGhy1PplAzuF2jB0
         yBzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Whx1xUX7BipnQyYzQ0qIm3Bt6BwvkXA771DSm71Btnc=;
        b=a7T805Z2gM+Z2u1YAQZ+6Rp/pUAjXrCm3sFCRKqqljyAkWwVm/D1qAzK55NcRddCEg
         z09IJ5IMVWmDh86pv5vUbaQthra+Y8X1h7SqWoPyVhaDiLLweYiOE4pzFp4/j1+XAF3a
         OzL/6k/zZfNofR5kHiFj1uvzYadwP/uL859UKuOeikGFxndiHlDDDUBzxZzpDGZBQ4ON
         Xkya0hssNr1hCw/0ziJyB08ofvV9QYmyojvN/NK14Qry9NCrMtf8rSRGdFd4ZmKD6WWo
         pWB9zUBwK8HGoKmylgWhN3KJz+6H2BB7N+vHR+z0AGAzWoEH1zwnrCfov7WjEiuxvGYa
         KxSA==
X-Gm-Message-State: AOAM5325aKi1zXjgAP9Cyt4Ui60amaNLHtbbwG8aVckIne/wXtrQkUCN
        Ieukln1DlIguGkKslmn2Gk8=
X-Google-Smtp-Source: ABdhPJz1cM/XAxMrfBZBRWK/w2LAb21hmEF+Ro+kfqMAgW0TAnZLOQobUkyqrHTxbAyKVa+0SuzIDQ==
X-Received: by 2002:a63:9346:: with SMTP id w6mr26859362pgm.65.1643853139296;
        Wed, 02 Feb 2022 17:52:19 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:19 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH net-next 14/15] mlx4: support BIG TCP packets
Date:   Wed,  2 Feb 2022 17:51:39 -0800
Message-Id: <20220203015140.3022854-15-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

mlx4 supports LSOv2 just fine.

IPv6 stack inserts a temporary Hop-by-Hop header
with JUMBO TLV for big packets.

We need to ignore the HBH header when populating TX descriptor.

Tested:

Before: (not enabling bigger TSO/GRO packets)

ip link set dev eth0 gso_ipv6_max_size 65536 gro_ipv6_max_size 65536

netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
Local /Remote
Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
Send   Recv   Size    Size   Time    Rate     local  remote local   remote
bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr

262144 540000 70000   70000  10.00   6591.45  0.86   1.34   62.490  97.446
262144 540000

After: (enabling bigger TSO/GRO packets)

ip link set dev eth0 gso_ipv6_max_size 185000 gro_ipv6_max_size 185000

netperf -H lpaa18 -t TCP_RR -T2,2 -l 10 -Cc -- -r 70000,70000
MIGRATED TCP REQUEST/RESPONSE TEST from ::0 (::) port 0 AF_INET6 to lpaa18.prod.google.com () port 0 AF_INET6 : first burst 0 : cpu bind
Local /Remote
Socket Size   Request Resp.  Elapsed Trans.   CPU    CPU    S.dem   S.dem
Send   Recv   Size    Size   Time    Rate     local  remote local   remote
bytes  bytes  bytes   bytes  secs.   per sec  % S    % S    us/Tr   us/Tr

262144 540000 70000   70000  10.00   8383.95  0.95   1.01   54.432  57.584
262144 540000

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    |  3 ++
 drivers/net/ethernet/mellanox/mlx4/en_tx.c    | 47 +++++++++++++++----
 2 files changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index c61dc7ae0c056a4dbcf24297549f6b1b5cc25d92..76cb93f5e5240c54f6f4c57e39739376206b4f34 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -3417,6 +3417,9 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = priv->max_mtu;
 
+	/* supports LSOv2 packets, 512KB limit has been tested. */
+	netif_set_tso_ipv6_max_size(dev, 512 * 1024);
+
 	mdev->pndev[port] = dev;
 	mdev->upper[port] = NULL;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 817f4154b86d599cd593876ec83529051d95fe2f..c89b3e8094e7d8cfb11aaa6cc4ad63bf3ad5934e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -44,6 +44,7 @@
 #include <linux/ipv6.h>
 #include <linux/moduleparam.h>
 #include <linux/indirect_call_wrapper.h>
+#include <net/ipv6.h>
 
 #include "mlx4_en.h"
 
@@ -635,19 +636,28 @@ static int get_real_size(const struct sk_buff *skb,
 			 struct net_device *dev,
 			 int *lso_header_size,
 			 bool *inline_ok,
-			 void **pfrag)
+			 void **pfrag,
+			 int *hopbyhop)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
 	int real_size;
 
 	if (shinfo->gso_size) {
 		*inline_ok = false;
-		if (skb->encapsulation)
+		*hopbyhop = 0;
+		if (skb->encapsulation) {
 			*lso_header_size = (skb_inner_transport_header(skb) - skb->data) + inner_tcp_hdrlen(skb);
-		else
+		} else {
+			/* Detects large IPV6 TCP packets and prepares for removal of
+			 * HBH header that has been pushed by ip6_xmit(),
+			 * mainly so that tcpdump can dissect them.
+			 */
+			if (ipv6_has_hopopt_jumbo(skb))
+				*hopbyhop = sizeof(struct hop_jumbo_hdr);
 			*lso_header_size = skb_transport_offset(skb) + tcp_hdrlen(skb);
+		}
 		real_size = CTRL_SIZE + shinfo->nr_frags * DS_SIZE +
-			ALIGN(*lso_header_size + 4, DS_SIZE);
+			ALIGN(*lso_header_size - *hopbyhop + 4, DS_SIZE);
 		if (unlikely(*lso_header_size != skb_headlen(skb))) {
 			/* We add a segment for the skb linear buffer only if
 			 * it contains data */
@@ -874,6 +884,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	int desc_size;
 	int real_size;
 	u32 index, bf_index;
+	struct ipv6hdr *h6;
 	__be32 op_own;
 	int lso_header_size;
 	void *fragptr = NULL;
@@ -882,6 +893,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 	bool stop_queue;
 	bool inline_ok;
 	u8 data_offset;
+	int hopbyhop;
 	bool bf_ok;
 
 	tx_ind = skb_get_queue_mapping(skb);
@@ -891,7 +903,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		goto tx_drop;
 
 	real_size = get_real_size(skb, shinfo, dev, &lso_header_size,
-				  &inline_ok, &fragptr);
+				  &inline_ok, &fragptr, &hopbyhop);
 	if (unlikely(!real_size))
 		goto tx_drop_count;
 
@@ -944,7 +956,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 		data = &tx_desc->data;
 		data_offset = offsetof(struct mlx4_en_tx_desc, data);
 	} else {
-		int lso_align = ALIGN(lso_header_size + 4, DS_SIZE);
+		int lso_align = ALIGN(lso_header_size - hopbyhop + 4, DS_SIZE);
 
 		data = (void *)&tx_desc->lso + lso_align;
 		data_offset = offsetof(struct mlx4_en_tx_desc, lso) + lso_align;
@@ -1009,14 +1021,31 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 			((ring->prod & ring->size) ?
 				cpu_to_be32(MLX4_EN_BIT_DESC_OWN) : 0);
 
+		lso_header_size -= hopbyhop;
 		/* Fill in the LSO prefix */
 		tx_desc->lso.mss_hdr_size = cpu_to_be32(
 			shinfo->gso_size << 16 | lso_header_size);
 
-		/* Copy headers;
-		 * note that we already verified that it is linear */
-		memcpy(tx_desc->lso.header, skb->data, lso_header_size);
 
+		if (unlikely(hopbyhop)) {
+			/* remove the HBH header.
+			 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+			 */
+			memcpy(tx_desc->lso.header, skb->data, ETH_HLEN + sizeof(*h6));
+			h6 = (struct ipv6hdr *)((char *)tx_desc->lso.header + ETH_HLEN);
+			h6->nexthdr = IPPROTO_TCP;
+			/* Copy the TCP header after the IPv6 one */
+			memcpy(h6 + 1,
+			       skb->data + ETH_HLEN + sizeof(*h6) +
+					sizeof(struct hop_jumbo_hdr),
+			       tcp_hdrlen(skb));
+			/* Leave ipv6 payload_len set to 0, as LSO v2 specs request. */
+		} else {
+			/* Copy headers;
+			 * note that we already verified that it is linear
+			 */
+			memcpy(tx_desc->lso.header, skb->data, lso_header_size);
+		}
 		ring->tso_packets++;
 
 		i = shinfo->gso_segs;
-- 
2.35.0.rc2.247.g8bbb082509-goog

