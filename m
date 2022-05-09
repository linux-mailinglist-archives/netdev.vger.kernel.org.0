Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 847B452078A
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbiEIW0Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiEIWZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:25:54 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CB515E601
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:21:58 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id q18so2222407pln.12
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rpvGFlL/dxr5w29W1znf6sKhsEG+FzRH5mCbtwORcuo=;
        b=CB0iDDi9kkqcj02zGnuk75Gyt3s08vIPUBYhtOUuJeF60GFJ5VanPCWaJXhvwQgmng
         kk5akRTpPzggjFQwsCpH+DLxLNDdfn3Q0vC4UUvn4x4olMCdMoUSMr0V7AID+1ci/A65
         zsTiVM8fi1N+xZYNjJ7vBrALF1YADBWZUCZVtsm0DO7MOysuk7zJlOcqb239OjCVFMye
         RJg6CSJRBigL6xETkZ52YpY+1/T/lxrVjcB+GCiSxq/sqjmI8C5/wMJDlOQb0KNWqu3w
         oHQ122Ft567wSfe7rzQ/um9JVgNB7TPiktkP6wRA3MoioU2OQEd9FNHfmkERggZQiELa
         II/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rpvGFlL/dxr5w29W1znf6sKhsEG+FzRH5mCbtwORcuo=;
        b=5AnNXWOZIvaX7hphu0XnVE8ma+BM5ZOOYT2+FlRya5JzqS8Xt8uPK90bKQ0aXfqQB0
         gCIU+WjvVFDOfxLvSj1aEaGiJwv8TlvF9aZtSD9HiFQD09YkMci1biVyH+KirYWDP+0u
         oKfxm0XzSTOXHuWFqQZQ498wKzqNVEA75g9yloy56Ge0Mrq3A3baJtd7cJgBKfTblzb6
         IHJxkJFr+yHQR/Vl0zxbo+OpO9Ui0xrJs7KafUg8Yc3ddvBya4sMd2AQ/ME6vhekcHUx
         CPJIiWK9bbTwHDHXu+srrUyIQZN4V0D8dG58Jst/BDdRO0DGj7o2B1f9Gpr3BICcYBQ1
         eqpw==
X-Gm-Message-State: AOAM532sgNaKtEU4H05oTkM7rxvAZOkT3m7+I8zmNi7YMPvicMPq2LHW
        /XEqnfmB+jv+3rMQUwe9tDk=
X-Google-Smtp-Source: ABdhPJwc67QoVo3forQ1GowLJFlk1osWmC+NAOsQw/4eBxw9k9G7c7ExnlIXx2PA9cOD66MhIQfypw==
X-Received: by 2002:a17:90b:14ce:b0:1dc:eff5:52b6 with SMTP id jz14-20020a17090b14ce00b001dceff552b6mr13865830pjb.148.1652134918139;
        Mon, 09 May 2022 15:21:58 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:21:57 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 02/13] net: allow gso_max_size to exceed 65536
Date:   Mon,  9 May 2022 15:21:38 -0700
Message-Id: <20220509222149.1763877-3-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
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

From: Alexander Duyck <alexanderduyck@fb.com>

The code for gso_max_size was added originally to allow for debugging and
workaround of buggy devices that couldn't support TSO with blocks 64K in
size. The original reason for limiting it to 64K was because that was the
existing limits of IPv4 and non-jumbogram IPv6 length fields.

With the addition of Big TCP we can remove this limit and allow the value
to potentially go up to UINT_MAX and instead be limited by the tso_max_size
value.

So in order to support this we need to go through and clean up the
remaining users of the gso_max_size value so that the values will cap at
64K for non-TCPv6 flows. In addition we can clean up the GSO_MAX_SIZE value
so that 64K becomes GSO_LEGACY_MAX_SIZE and UINT_MAX will now be the upper
limit for GSO_MAX_SIZE.

Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe.h            | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 +-
 drivers/net/ethernet/sfc/ef100_nic.c            | 3 ++-
 drivers/net/ethernet/sfc/falcon/tx.c            | 3 ++-
 drivers/net/ethernet/sfc/tx_common.c            | 3 ++-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h      | 3 ++-
 drivers/net/hyperv/rndis_filter.c               | 2 +-
 drivers/scsi/fcoe/fcoe.c                        | 2 +-
 include/linux/netdevice.h                       | 3 ++-
 net/bpf/test_run.c                              | 2 +-
 net/core/dev.c                                  | 5 +++--
 net/core/rtnetlink.c                            | 2 +-
 net/core/sock.c                                 | 4 ++++
 net/ipv4/tcp_bbr.c                              | 2 +-
 net/ipv4/tcp_output.c                           | 2 +-
 net/sctp/output.c                               | 3 ++-
 16 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 607a2c90513b529ca0383410a3f513d98a75a72f..d9547552ceefe1d291155ab7619a5f2fa6296340 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe.h
+++ b/drivers/net/ethernet/amd/xgbe/xgbe.h
@@ -151,7 +151,8 @@
 #define XGBE_TX_MAX_BUF_SIZE	(0x3fff & ~(64 - 1))
 
 /* Descriptors required for maximum contiguous TSO/GSO packet */
-#define XGBE_TX_MAX_SPLIT	((GSO_MAX_SIZE / XGBE_TX_MAX_BUF_SIZE) + 1)
+#define XGBE_TX_MAX_SPLIT	\
+	((GSO_LEGACY_MAX_SIZE / XGBE_TX_MAX_BUF_SIZE) + 1)
 
 /* Maximum possible descriptors needed for an SKB:
  * - Maximum number of SKB frags
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index fb11081001a088fcddde68b88bae1da65a3f2c06..838870bc6dbd6e3a3d8c9443ff4675a0e411006b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -2038,7 +2038,7 @@ mlx5e_hw_gro_skb_has_enough_space(struct sk_buff *skb, u16 data_bcnt)
 {
 	int nr_frags = skb_shinfo(skb)->nr_frags;
 
-	return PAGE_SIZE * nr_frags + data_bcnt <= GSO_MAX_SIZE;
+	return PAGE_SIZE * nr_frags + data_bcnt <= GRO_MAX_SIZE;
 }
 
 static void
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index a69d756e09b9316660aea5a48d07d86af9cd9112..b2536d2c218a6db8acf1e8a5802860639c5e71a6 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1008,7 +1008,8 @@ static int ef100_process_design_param(struct efx_nic *efx,
 		}
 		return 0;
 	case ESE_EF100_DP_GZ_TSO_MAX_PAYLOAD_LEN:
-		nic_data->tso_max_payload_len = min_t(u64, reader->value, GSO_MAX_SIZE);
+		nic_data->tso_max_payload_len = min_t(u64, reader->value,
+						      GSO_LEGACY_MAX_SIZE);
 		netif_set_tso_max_size(efx->net_dev,
 				       nic_data->tso_max_payload_len);
 		return 0;
diff --git a/drivers/net/ethernet/sfc/falcon/tx.c b/drivers/net/ethernet/sfc/falcon/tx.c
index f7306e93a8b8db9b220c5c3b95dc95c7eaaf2580..b9369483758cd6ebcd263852542175610b4d2789 100644
--- a/drivers/net/ethernet/sfc/falcon/tx.c
+++ b/drivers/net/ethernet/sfc/falcon/tx.c
@@ -98,7 +98,8 @@ unsigned int ef4_tx_max_skb_descs(struct ef4_nic *efx)
 	/* Possibly more for PCIe page boundaries within input fragments */
 	if (PAGE_SIZE > EF4_PAGE_SIZE)
 		max_descs += max_t(unsigned int, MAX_SKB_FRAGS,
-				   DIV_ROUND_UP(GSO_MAX_SIZE, EF4_PAGE_SIZE));
+				   DIV_ROUND_UP(GSO_LEGACY_MAX_SIZE,
+						EF4_PAGE_SIZE));
 
 	return max_descs;
 }
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 9bc8281b7f5bdd3d95924c6f8294d39202424a27..658ea2d340704d186bb9f94ad24497cbd2d15752 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -416,7 +416,8 @@ unsigned int efx_tx_max_skb_descs(struct efx_nic *efx)
 	/* Possibly more for PCIe page boundaries within input fragments */
 	if (PAGE_SIZE > EFX_PAGE_SIZE)
 		max_descs += max_t(unsigned int, MAX_SKB_FRAGS,
-				   DIV_ROUND_UP(GSO_MAX_SIZE, EFX_PAGE_SIZE));
+				   DIV_ROUND_UP(GSO_LEGACY_MAX_SIZE,
+						EFX_PAGE_SIZE));
 
 	return max_descs;
 }
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac.h b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
index 98e3a271e017ae17f23866beab8021d2f2ab26c0..a848e10f3ea457da1b17571df6a35b077a96c794 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac.h
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac.h
@@ -38,7 +38,8 @@
 #define XLGMAC_RX_DESC_MAX_DIRTY	(XLGMAC_RX_DESC_CNT >> 3)
 
 /* Descriptors required for maximum contiguous TSO/GSO packet */
-#define XLGMAC_TX_MAX_SPLIT	((GSO_MAX_SIZE / XLGMAC_TX_MAX_BUF_SIZE) + 1)
+#define XLGMAC_TX_MAX_SPLIT	\
+	((GSO_LEGACY_MAX_SIZE / XLGMAC_TX_MAX_BUF_SIZE) + 1)
 
 /* Maximum possible descriptors needed for a SKB */
 #define XLGMAC_TX_MAX_DESC_NR	(MAX_SKB_FRAGS + XLGMAC_TX_MAX_SPLIT + 2)
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 866af2cc27a3e0df11812d6ade17dde1d247ff4a..6da36cb8af8055eba338490b6bc7493181e8644c 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1349,7 +1349,7 @@ static int rndis_netdev_set_hwcaps(struct rndis_device *rndis_device,
 	struct net_device_context *net_device_ctx = netdev_priv(net);
 	struct ndis_offload hwcaps;
 	struct ndis_offload_params offloads;
-	unsigned int gso_max_size = GSO_MAX_SIZE;
+	unsigned int gso_max_size = GSO_LEGACY_MAX_SIZE;
 	int ret;
 
 	/* Find HW offload capabilities */
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 44ca6110213caaf7222c8b69c6c3fc2a08687495..79b2827e4081b4015fc51ace4e1467214c45fd48 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -667,7 +667,7 @@ static void fcoe_netdev_features_change(struct fc_lport *lport,
 
 	if (netdev->features & NETIF_F_FSO) {
 		lport->seq_offload = 1;
-		lport->lso_max = netdev->gso_max_size;
+		lport->lso_max = min(netdev->gso_max_size, GSO_LEGACY_MAX_SIZE);
 		FCOE_NETDEV_DBG(netdev, "Supports LSO for max len 0x%x\n",
 				lport->lso_max);
 	} else {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 74c97a34921d48c593c08e2bed72e099f42520a3..9a34cc45b20a4465a9e1532c39f410b26604144f 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2262,7 +2262,8 @@ struct net_device {
 	const struct rtnl_link_ops *rtnl_link_ops;
 
 	/* for setting kernel sock attribute on TCP connection setup */
-#define GSO_MAX_SIZE		65536
+#define GSO_LEGACY_MAX_SIZE	65536u
+#define GSO_MAX_SIZE		UINT_MAX
 	unsigned int		gso_max_size;
 #define TSO_LEGACY_MAX_SIZE	65536
 #define TSO_MAX_SIZE		UINT_MAX
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 8d54fef9a568a189d14253bcf01e3d586e746084..9b5a1f630bb0dbfe577c0f2a63094cb5872ade1d 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1001,7 +1001,7 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 		cb->pkt_len = skb->len;
 	} else {
 		if (__skb->wire_len < skb->len ||
-		    __skb->wire_len > GSO_MAX_SIZE)
+		    __skb->wire_len > GSO_LEGACY_MAX_SIZE)
 			return -EINVAL;
 		cb->pkt_len = __skb->wire_len;
 	}
diff --git a/net/core/dev.c b/net/core/dev.c
index f036ccb61da4da3ffc52c4f2402427054b831e8a..a1bbe000953f9365b4419f2ddbef96ddada42d3a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2998,7 +2998,8 @@ EXPORT_SYMBOL(netif_set_real_num_queues);
  * @size:	max skb->len of a TSO frame
  *
  * Set the limit on the size of TSO super-frames the device can handle.
- * Unless explicitly set the stack will assume the value of %GSO_MAX_SIZE.
+ * Unless explicitly set the stack will assume the value of
+ * %GSO_LEGACY_MAX_SIZE.
  */
 void netif_set_tso_max_size(struct net_device *dev, unsigned int size)
 {
@@ -10602,7 +10603,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
 
 	dev_net_set(dev, &init_net);
 
-	dev->gso_max_size = GSO_MAX_SIZE;
+	dev->gso_max_size = GSO_LEGACY_MAX_SIZE;
 	dev->gso_max_segs = GSO_MAX_SEGS;
 	dev->gro_max_size = GRO_MAX_SIZE;
 	dev->tso_max_size = TSO_LEGACY_MAX_SIZE;
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 21b117b710bf2154f11b6511de7d578d0eafb65e..823db8999a2c1d5959042393783492dbecf1352c 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -2809,7 +2809,7 @@ static int do_setlink(const struct sk_buff *skb,
 	if (tb[IFLA_GSO_MAX_SIZE]) {
 		u32 max_size = nla_get_u32(tb[IFLA_GSO_MAX_SIZE]);
 
-		if (max_size > GSO_MAX_SIZE || max_size > dev->tso_max_size) {
+		if (max_size > dev->tso_max_size) {
 			err = -EINVAL;
 			goto errout;
 		}
diff --git a/net/core/sock.c b/net/core/sock.c
index 6b287eb5427b32865d25fc22122fefeff3a4ccf5..f7c3171078b6fccd25757e8fe54dd56a2a674238 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2312,6 +2312,10 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 			sk->sk_route_caps |= NETIF_F_SG | NETIF_F_HW_CSUM;
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_size() */
 			sk->sk_gso_max_size = READ_ONCE(dst->dev->gso_max_size);
+			if (sk->sk_gso_max_size > GSO_LEGACY_MAX_SIZE &&
+			    (!IS_ENABLED(CONFIG_IPV6) || sk->sk_family != AF_INET6 ||
+			     !sk_is_tcp(sk) || ipv6_addr_v4mapped(&sk->sk_v6_rcv_saddr)))
+				sk->sk_gso_max_size = GSO_LEGACY_MAX_SIZE;
 			sk->sk_gso_max_size -= (MAX_TCP_HEADER + 1);
 			/* pairs with the WRITE_ONCE() in netif_set_gso_max_segs() */
 			max_segs = max_t(u32, READ_ONCE(dst->dev->gso_max_segs), 1);
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index c7d30a3bbd81d27e16e800ec446569b93a4123ba..075e744bfb4829c087f4a85448e2f778dba439b4 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -310,7 +310,7 @@ static u32 bbr_tso_segs_goal(struct sock *sk)
 	 */
 	bytes = min_t(unsigned long,
 		      sk->sk_pacing_rate >> READ_ONCE(sk->sk_pacing_shift),
-		      GSO_MAX_SIZE - 1 - MAX_TCP_HEADER);
+		      GSO_LEGACY_MAX_SIZE - 1 - MAX_TCP_HEADER);
 	segs = max_t(u32, bytes / tp->mss_cache, bbr_min_tso_segs(sk));
 
 	return min(segs, 0x7FU);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index b092228e434261f45f79cc6c1fad613e0bb045c0..b4b2284ed4a2c9e2569bd945e3b4e023c5502f25 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1553,7 +1553,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 	 * SO_SNDBUF values.
 	 * Also allow first and last skb in retransmit queue to be split.
 	 */
-	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_MAX_SIZE);
+	limit = sk->sk_sndbuf + 2 * SKB_TRUESIZE(GSO_LEGACY_MAX_SIZE);
 	if (unlikely((sk->sk_wmem_queued >> 1) > limit &&
 		     tcp_queue != TCP_FRAG_IN_WRITE_QUEUE &&
 		     skb != tcp_rtx_queue_head(sk) &&
diff --git a/net/sctp/output.c b/net/sctp/output.c
index 72fe6669c50de2c76842cf50d039b65a61943bd8..a63df055ac57d551e89edfb3a4982768a318cf67 100644
--- a/net/sctp/output.c
+++ b/net/sctp/output.c
@@ -134,7 +134,8 @@ void sctp_packet_config(struct sctp_packet *packet, __u32 vtag,
 		dst_hold(tp->dst);
 		sk_setup_caps(sk, tp->dst);
 	}
-	packet->max_size = sk_can_gso(sk) ? READ_ONCE(tp->dst->dev->gso_max_size)
+	packet->max_size = sk_can_gso(sk) ? min(READ_ONCE(tp->dst->dev->gso_max_size),
+						GSO_LEGACY_MAX_SIZE)
 					  : asoc->pathmtu;
 	rcu_read_unlock();
 }
-- 
2.36.0.512.ge40c2bad7a-goog

