Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB34D52045F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 20:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240134AbiEISVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 14:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240147AbiEISVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 14:21:30 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16822AACEA
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 11:17:34 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so60399pjb.5
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 11:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=uIW6IjPadbdphrCauS971hyB85Z2J399imKbOECpuaw=;
        b=YlVM4RnWqO7a0hiohMI/UsRjCHrJX5ZsB672UtrqS5hifwUkuGE0QhZjj6fZqQ2ISU
         OkySrhfm8WxqJBzLXUDX4DExeWzU0OeGjPk14YtIfmYeebAOEkT5qslgLEIq6rx5EAln
         wiH9HJbVAv+pIAQqgZCx/fgbN/PRm/e9RBh+ZLFiTUBPV0YgHIPxheOaXMrkXAmQLO+/
         k0c6P9i1IFCsQsBAypgQxaqjSL0jc6ovEmWslZbJECPrcuj8XP+JuXs5jITTbFQPh2dU
         gcHakKQbUGQXqBeeXPu7m/h/SOo0yp7XLXq4/nJ4yLQaZwsG3VjwAsduZyOZ0qA4f/ib
         MEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=uIW6IjPadbdphrCauS971hyB85Z2J399imKbOECpuaw=;
        b=Q02eIAOhbvGeQ6qxItqI1bqPGa0FSEOaoEXgCBz2aP69FJAA5rPPDPgce2yJSj2U9J
         Gr0LInyWqMQQ125IQOYbTn7caMcHyvyWBYITohTSJqxs4U+zW2DVvFpD5SM0RpklIQNJ
         6MDF+c+IIOPVqKLqFL0saCovC4Fr2cGbumtL7Nm6HH8vkfrdBEZymqe2u3eWxjpcQzH8
         k6FFlLTe4QhtBHL/hSJA09MsS3cN3/BU2hI/PH1GgDYdSefsQQIoLILJPUcYGjFZrzyC
         QHQ/WkM5QMC1qyFe+uDtA7S/fiLmLG0Pdb96E8IjFP0h0MRgwmrOT49h6ItSGw9pX0vM
         Gjig==
X-Gm-Message-State: AOAM531UPbnftwTEZ+AfdMDAuLE0snabkYxRpSokUYDilLO4I4b6pq1a
        krEDpSuBEQR+eeNiLn0dN48=
X-Google-Smtp-Source: ABdhPJz+nx6BtxBDq9E3PVHVk4F/dFwRyBFTXwS07QNut48LQAKVFBydL/ZT5/gA09TFp6ulV1rGeg==
X-Received: by 2002:a17:90b:610:b0:1d9:4008:cfee with SMTP id gb16-20020a17090b061000b001d94008cfeemr19531698pjb.71.1652120254405;
        Mon, 09 May 2022 11:17:34 -0700 (PDT)
Received: from localhost.localdomain ([98.97.39.30])
        by smtp.gmail.com with ESMTPSA id b23-20020aa79517000000b005104c6d7941sm7178894pfp.31.2022.05.09.11.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 11:17:33 -0700 (PDT)
Subject: [PATCH 1/2] net: Allow gso_max_size to exceed 65536
From:   Alexander Duyck <alexander.duyck@gmail.com>
To:     edumazet@google.com
Cc:     alexander.duyck@gmail.com, davem@davemloft.net,
        eric.dumazet@gmail.com, kuba@kernel.org, lixiaoyan@google.com,
        netdev@vger.kernel.org, pabeni@redhat.com
Date:   Mon, 09 May 2022 11:17:31 -0700
Message-ID: <165212025151.5729.4487172084186405211.stgit@localhost.localdomain>
In-Reply-To: <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
References: <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
User-Agent: StGit/1.5
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
---
 drivers/net/ethernet/amd/xgbe/xgbe.h            |    3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c |    2 +-
 drivers/net/ethernet/sfc/ef100_nic.c            |    3 ++-
 drivers/net/ethernet/sfc/falcon/tx.c            |    3 ++-
 drivers/net/ethernet/sfc/tx_common.c            |    3 ++-
 drivers/net/ethernet/synopsys/dwc-xlgmac.h      |    3 ++-
 drivers/net/hyperv/rndis_filter.c               |    2 +-
 drivers/scsi/fcoe/fcoe.c                        |    2 +-
 include/linux/netdevice.h                       |    3 ++-
 net/bpf/test_run.c                              |    2 +-
 net/core/dev.c                                  |    5 +++--
 net/core/rtnetlink.c                            |    2 +-
 net/core/sock.c                                 |    4 ++++
 net/ipv4/tcp_bbr.c                              |    2 +-
 net/ipv4/tcp_output.c                           |    2 +-
 net/sctp/output.c                               |    3 ++-
 16 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe.h b/drivers/net/ethernet/amd/xgbe/xgbe.h
index 607a2c90513b..d9547552ceef 100644
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
index fb11081001a0..838870bc6dbd 100644
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
index a69d756e09b9..b2536d2c218a 100644
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
index f7306e93a8b8..b9369483758c 100644
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
index 9bc8281b7f5b..658ea2d34070 100644
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
index 98e3a271e017..a848e10f3ea4 100644
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
index 866af2cc27a3..6da36cb8af80 100644
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
index 44ca6110213c..79b2827e4081 100644
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
index 8cf0ac616cb9..da063cb37759 100644
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
index 8d54fef9a568..9b5a1f630bb0 100644
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
index f036ccb61da4..a1bbe000953f 100644
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
index 512ed661204e..c5b44de41088 100644
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
index 6b287eb5427b..f7c3171078b6 100644
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
index c7d30a3bbd81..075e744bfb48 100644
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
index b092228e4342..b4b2284ed4a2 100644
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
index 72fe6669c50d..a63df055ac57 100644
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


