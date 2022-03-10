Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90584D40E7
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:48:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239679AbiCJFsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiCJFsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:41 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099DD27FED
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:33 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o23so3815963pgk.13
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2qkUWOSjFuJ3SYVMEm+07IQm8DqN/HrdudaxPS5fN9M=;
        b=m3bPEg5eKAeooeOjFmNBwjk7keCAEpxfefNsBnogmisIHwsPJlMBAW/dzyazILi406
         yBZGsv3NjhMgeTyUidmAy2msISDet67M0216xnrzWjiYmGokS53FlrUQP7AvW3/FOGvl
         GGG85vjVawddBY91/qyRK1pkSUZtIUGIxetbNeNMWifz8Kkk/OMCXnpAarhdnKP8zzWX
         8p+dz9Bx7We8VCEDFuUBx/qwYMqBgi2sQAon6L1TDVNG4dCOPrY+Xfsnp4YFdLPeczSj
         1uuN2PlbtCh+oaMlcANoJzFwPG9fwGnF4fTMbXIudhc59W59V9u9/O1ccPm269om/qFl
         HitQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2qkUWOSjFuJ3SYVMEm+07IQm8DqN/HrdudaxPS5fN9M=;
        b=uXfqreWYllRpaGJm1e7UZUpV8aE/cHrPWMmNHy1ba5toiOcRGSh5v5ADazUAccCqrb
         /2Bthg8f+1VJDSRe0I5WScsNiMQ6BeYPx+liWp6dTIflrv0e7Hu4X6WvrQ57N/yuAYFZ
         PldUhdzzKZBiiTNzx5ZV+klRujYxtJOPL3NE407YB6vMFVdNLaAVWHK6ays5my7H9Ysl
         xdOb8uILVFs3hsIyiReIipIETntEIY2qtOOp2ogafckgKt6MaJqlGL83+MRVYKUFP4ii
         VdxT4wkGEfPlSNIwbE67T2x0bWfAkQONNmb3X7r6myNrpDjBJEpSxZNfC7Ggb9c97ZNB
         Yt0A==
X-Gm-Message-State: AOAM533tKLo1KcPJNZY41Dux1uHYJDNJmXRc7Jzk1N6+ICawv4MxiLbS
        ebok1mvXq2toIZI2wcZMC+KbvNEK3tM=
X-Google-Smtp-Source: ABdhPJzAuULemzrVoep+YYZ0f/WgaXl9/e7jy2lgp4iC+Kktq8P/u7ZU9KVyhj2t1RSd/eZqPJZrHg==
X-Received: by 2002:aa7:8889:0:b0:4f7:7283:e378 with SMTP id z9-20020aa78889000000b004f77283e378mr2041198pfe.36.1646891253383;
        Wed, 09 Mar 2022 21:47:33 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:33 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: [PATCH v4 net-next 13/14] mlx4: support BIG TCP packets
Date:   Wed,  9 Mar 2022 21:47:02 -0800
Message-Id: <20220310054703.849899-14-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
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
2.35.1.616.g0bdcbb4464-goog

