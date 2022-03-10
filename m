Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F7E4D3E5C
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 01:46:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239060AbiCJArK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 19:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238649AbiCJArJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 19:47:09 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404B1124C32
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 16:46:09 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id r12so3440611pla.1
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 16:46:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qHTjBv6l0QJSk8nG+dTFbgr2CmfXFHPr+SyLVxByx8U=;
        b=BkzqHJlLgzzf4p7PV8nktIlOWQuvWWCXUO4Ul3GPdbuAnaI35mrQ7jtoO0UKHHCZp9
         bzBmV6Z+HPgJFA6ASgmwOBZU1u+Cw7/4D6YMk0GMu86MLf6iOyNZaI3ggCdvYjOzNgWh
         c6gbJO88hc8hjINQDRTh1fz3oYlCxm/A0L2+NPolocxn3Tgvvww4Te8S0+ZZbaAUD2rM
         jIKrYSJuDaUeSMjl2DDtlMEL1Iv2WxQZzfHK/euNUdsKXwoA2frRkfila1i53lO9gTgK
         HwAQH2cTiLG9TX+KEBpV8nW7qUz6Ciy0RR5Ar/f5xoZpSRqsimatK9ch6o8iAiFwn+xk
         /54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qHTjBv6l0QJSk8nG+dTFbgr2CmfXFHPr+SyLVxByx8U=;
        b=RCTJW+2BXx3G2PrGDT9EASFChLyPTpq3DtbaY3gRbhh+KUHoEBGMYj355RuW9Xgy8o
         S52eWjM/pCBifgsNB/OhdksPo2lMjYtJlv24SroSJRZBtonJSTeRSdKHWHN34GFgjUCQ
         ID+0IoXk67ojEFJbeVCENerHzW7IlaXMPd79uj6Qb2f7fTDEt5w++YbV3t63quWQFFCz
         ANZTdx/LN0DTzgNHzVL0xoIO6e6nG8GOLKP1ou1KOFFnMGX3+EF/AEOsGj6t5Pm094aX
         foTKRgiX97Gk+RucKrQeUJyWdZtHjeowjTB1BM8LyJ1FSsaoKTVGqSx2Zdkq5dT9DGAM
         p6og==
X-Gm-Message-State: AOAM533OYBbhdoJiKI+bVSqzlXtgFo6SK7KmmP9IzKmCuN1ZCdMaOeJG
        ZVRiwE1xWlWrLFBwmTFiKiE=
X-Google-Smtp-Source: ABdhPJwPsMINqebln+7of6Vh0lQiI3oxPy5pKOM9a5Ci1hqzGcoPC6o4PQ0suu9v0VBVhloHXPh3Sg==
X-Received: by 2002:a17:903:11cc:b0:151:71e4:dadc with SMTP id q12-20020a17090311cc00b0015171e4dadcmr2352265plh.78.1646873168650;
        Wed, 09 Mar 2022 16:46:08 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id r1-20020a17090a560100b001bf72b5af97sm3922539pjf.13.2022.03.09.16.46.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 16:46:08 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        jeffreyji <jeffreyji@google.com>,
        Brian Vazquez <brianvv@google.com>
Subject: [PATCH v2 net-next] net: add per-cpu storage and net->core_stats
Date:   Wed,  9 Mar 2022 16:46:03 -0800
Message-Id: <20220310004603.543196-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
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

Before adding yet another possibly contended atomic_long_t,
it is time to add per-cpu storage for existing ones:
 dev->tx_dropped, dev->rx_dropped, and dev->rx_nohandler

Because many devices do not have to increment such counters,
allocate the per-cpu storage on demand, so that dev_get_stats()
does not have to spend considerable time folding zero counters.

Note that some drivers have abused these counters which
were supposed to be only used by core networking stack.

v2: add a missing include (reported by kernel test robot <lkp@intel.com>)
    Change in netdev_core_stats_alloc() (Jakub)

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: jeffreyji <jeffreyji@google.com>
Reviewed-by: Brian Vazquez <brianvv@google.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/bonding/bond_main.c               |  2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  4 +-
 .../net/ethernet/hisilicon/hns/hns_ethtool.c  |  4 +-
 .../ethernet/qualcomm/rmnet/rmnet_handlers.c  |  2 +-
 drivers/net/ipvlan/ipvlan_core.c              |  2 +-
 drivers/net/macvlan.c                         |  2 +-
 drivers/net/net_failover.c                    |  2 +-
 drivers/net/tun.c                             | 16 +++---
 drivers/net/vxlan/vxlan_core.c                |  2 +-
 include/linux/netdevice.h                     | 46 +++++++++++++----
 include/net/bonding.h                         |  2 +-
 net/core/dev.c                                | 50 +++++++++++++++----
 net/core/gro_cells.c                          |  2 +-
 net/hsr/hsr_device.c                          |  2 +-
 net/xfrm/xfrm_device.c                        |  2 +-
 15 files changed, 100 insertions(+), 40 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 55e0ba2a163d0d9c17fdaf47a49d7a2190959651..15eddca7b4b6623ccb2b17d1d8f9a092ebd90ff5 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5120,7 +5120,7 @@ static netdev_tx_t bond_xmit_broadcast(struct sk_buff *skb,
 	if (xmit_suc)
 		return NETDEV_TX_OK;
 
-	atomic_long_inc(&bond_dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(bond_dev);
 	return NET_XMIT_DROP;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 63b8fc4f9d42748985563431f8fef47644018dc0..3af230e5fa3241ae396060fe8a8fae2b0c77a6f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -370,7 +370,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	i = skb_get_queue_mapping(skb);
 	if (unlikely(i >= bp->tx_nr_rings)) {
 		dev_kfree_skb_any(skb);
-		atomic_long_inc(&dev->tx_dropped);
+		dev_core_stats_tx_dropped_inc(dev);
 		return NETDEV_TX_OK;
 	}
 
@@ -646,7 +646,7 @@ static netdev_tx_t bnxt_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (txr->kick_pending)
 		bnxt_txr_db_kick(bp, txr, txr->tx_prod);
 	txr->tx_buf_ring[txr->tx_prod].skb = NULL;
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	return NETDEV_TX_OK;
 }
 
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
index d7a27c244d48060a7e5efe22376e9f465942a94a..54faf0f2d1d867066b9fc121fc5a3d5e0d296afa 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_ethtool.c
@@ -887,8 +887,8 @@ static void hns_get_ethtool_stats(struct net_device *netdev,
 	p[21] = net_stats->rx_compressed;
 	p[22] = net_stats->tx_compressed;
 
-	p[23] = netdev->rx_dropped.counter;
-	p[24] = netdev->tx_dropped.counter;
+	p[23] = 0; /* was netdev->rx_dropped.counter */
+	p[24] = 0; /* was netdev->tx_dropped.counter */
 
 	p[25] = priv->tx_timeout_count;
 
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
index bfbd7847f9468d5698e115ec39ea92053978b45f..a313242a762e2e732c5bd5856ea8902f855e56b4 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
@@ -207,7 +207,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff **pskb)
 	dev = skb->dev;
 	port = rmnet_get_port_rcu(dev);
 	if (unlikely(!port)) {
-		atomic_long_inc(&skb->dev->rx_nohandler);
+		dev_core_stats_rx_nohandler_inc(skb->dev);
 		kfree_skb(skb);
 		goto done;
 	}
diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan_core.c
index c613900c3811f9e0482092f79bad3bf9cfab25b3..6ffb27419e64b36666d395da924304a943343640 100644
--- a/drivers/net/ipvlan/ipvlan_core.c
+++ b/drivers/net/ipvlan/ipvlan_core.c
@@ -555,7 +555,7 @@ static void ipvlan_multicast_enqueue(struct ipvl_port *port,
 		schedule_work(&port->wq);
 	} else {
 		spin_unlock(&port->backlog.lock);
-		atomic_long_inc(&skb->dev->rx_dropped);
+		dev_core_stats_rx_dropped_inc(skb->dev);
 		kfree_skb(skb);
 	}
 }
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 33753a2fde292f8f415eefe957d09be5db1c4d55..4b77819e9328175e664779855cffab4c5352dfe5 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -371,7 +371,7 @@ static void macvlan_broadcast_enqueue(struct macvlan_port *port,
 free_nskb:
 	kfree_skb(nskb);
 err:
-	atomic_long_inc(&skb->dev->rx_dropped);
+	dev_core_stats_rx_dropped_inc(skb->dev);
 }
 
 static void macvlan_flush_sources(struct macvlan_port *port,
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 86ec5aae42891aa287a3eea3e91db4462990a350..21a0435c02de6c44e5175d0f204c255c0e22ddd5 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -89,7 +89,7 @@ static int net_failover_close(struct net_device *dev)
 static netdev_tx_t net_failover_drop_xmit(struct sk_buff *skb,
 					  struct net_device *dev)
 {
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	dev_kfree_skb_any(skb);
 	return NETDEV_TX_OK;
 }
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 2b9a22669a12681185c631e772c59994ba47b574..276a0e42ca8eaa85a96b366ab56f5abda3ff7a27 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1135,7 +1135,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 
 drop:
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	skb_tx_error(skb);
 	kfree_skb_reason(skb, drop_reason);
 	rcu_read_unlock();
@@ -1291,7 +1291,7 @@ static int tun_xdp_xmit(struct net_device *dev, int n,
 		void *frame = tun_xdp_to_ptr(xdp);
 
 		if (__ptr_ring_produce(&tfile->tx_ring, frame)) {
-			atomic_long_inc(&dev->tx_dropped);
+			dev_core_stats_tx_dropped_inc(dev);
 			break;
 		}
 		nxmit++;
@@ -1626,7 +1626,7 @@ static int tun_xdp_act(struct tun_struct *tun, struct bpf_prog *xdp_prog,
 		trace_xdp_exception(tun->dev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-		atomic_long_inc(&tun->dev->rx_dropped);
+		dev_core_stats_rx_dropped_inc(tun->dev);
 		break;
 	}
 
@@ -1797,7 +1797,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 		 */
 		skb = tun_build_skb(tun, tfile, from, &gso, len, &skb_xdp);
 		if (IS_ERR(skb)) {
-			atomic_long_inc(&tun->dev->rx_dropped);
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			return PTR_ERR(skb);
 		}
 		if (!skb)
@@ -1826,7 +1826,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 
 		if (IS_ERR(skb)) {
 			if (PTR_ERR(skb) != -EAGAIN)
-				atomic_long_inc(&tun->dev->rx_dropped);
+				dev_core_stats_rx_dropped_inc(tun->dev);
 			if (frags)
 				mutex_unlock(&tfile->napi_mutex);
 			return PTR_ERR(skb);
@@ -1841,7 +1841,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 			err = -EFAULT;
 			drop_reason = SKB_DROP_REASON_SKB_UCOPY_FAULT;
 drop:
-			atomic_long_inc(&tun->dev->rx_dropped);
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			kfree_skb_reason(skb, drop_reason);
 			if (frags) {
 				tfile->napi.skb = NULL;
@@ -1876,7 +1876,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 				pi.proto = htons(ETH_P_IPV6);
 				break;
 			default:
-				atomic_long_inc(&tun->dev->rx_dropped);
+				dev_core_stats_rx_dropped_inc(tun->dev);
 				kfree_skb(skb);
 				return -EINVAL;
 			}
@@ -1956,7 +1956,7 @@ static ssize_t tun_get_user(struct tun_struct *tun, struct tun_file *tfile,
 					  skb_headlen(skb));
 
 		if (unlikely(headlen > skb_headlen(skb))) {
-			atomic_long_inc(&tun->dev->rx_dropped);
+			dev_core_stats_rx_dropped_inc(tun->dev);
 			napi_free_frags(&tfile->napi);
 			rcu_read_unlock();
 			mutex_unlock(&tfile->napi_mutex);
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index e440cdd4f710e5f6a8e583b1a5acea61ad44314a..d1fec21d39626d06dff0357f774c88d5bb76ea8c 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1760,7 +1760,7 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 
 	if (unlikely(!(vxlan->dev->flags & IFF_UP))) {
 		rcu_read_unlock();
-		atomic_long_inc(&vxlan->dev->rx_dropped);
+		dev_core_stats_rx_dropped_inc(vxlan->dev);
 		vxlan_vnifilter_count(vxlan, vni, vninode,
 				      VXLAN_VNI_STATS_RX_DROPS, 0);
 		goto drop;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 29a850a8d4604bb2ac43b582595f301aaa96a0bc..748395430b06b41bbad06edd726649b76e08f676 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -28,6 +28,7 @@
 #include <linux/prefetch.h>
 #include <asm/cache.h>
 #include <asm/byteorder.h>
+#include <asm/local.h>
 
 #include <linux/percpu.h>
 #include <linux/rculist.h>
@@ -194,6 +195,14 @@ struct net_device_stats {
 	unsigned long	tx_compressed;
 };
 
+/* per-cpu stats, allocated on demand.
+ * Try to fit them in a single cache line, for dev_get_stats() sake.
+ */
+struct net_device_core_stats {
+	local_t		rx_dropped;
+	local_t		tx_dropped;
+	local_t		rx_nohandler;
+} __aligned(4 * sizeof(local_t));
 
 #include <linux/cache.h>
 #include <linux/skbuff.h>
@@ -1735,12 +1744,8 @@ enum netdev_ml_priv_type {
  *	@stats:		Statistics struct, which was left as a legacy, use
  *			rtnl_link_stats64 instead
  *
- *	@rx_dropped:	Dropped packets by core network,
+ *	@core_stats:	core networking counters,
  *			do not use this in drivers
- *	@tx_dropped:	Dropped packets by core network,
- *			do not use this in drivers
- *	@rx_nohandler:	nohandler dropped packets by core network on
- *			inactive devices, do not use this in drivers
  *	@carrier_up_count:	Number of times the carrier has been up
  *	@carrier_down_count:	Number of times the carrier has been down
  *
@@ -2023,9 +2028,7 @@ struct net_device {
 
 	struct net_device_stats	stats; /* not used by modern drivers */
 
-	atomic_long_t		rx_dropped;
-	atomic_long_t		tx_dropped;
-	atomic_long_t		rx_nohandler;
+	struct net_device_core_stats __percpu *core_stats;
 
 	/* Stats to monitor link on/off, flapping */
 	atomic_t		carrier_up_count;
@@ -3839,13 +3842,38 @@ static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
 	return false;
 }
 
+struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev);
+
+static inline struct net_device_core_stats *dev_core_stats(struct net_device *dev)
+{
+	/* This READ_ONCE() pairs with the write in netdev_core_stats_alloc() */
+	struct net_device_core_stats __percpu *p = READ_ONCE(dev->core_stats);
+
+	if (likely(p))
+		return this_cpu_ptr(p);
+
+	return netdev_core_stats_alloc(dev);
+}
+
+#define DEV_CORE_STATS_INC(FIELD)						\
+static inline void dev_core_stats_##FIELD##_inc(struct net_device *dev)		\
+{										\
+	struct net_device_core_stats *p = dev_core_stats(dev);			\
+										\
+	if (p)									\
+		local_inc(&p->FIELD);						\
+}
+DEV_CORE_STATS_INC(rx_dropped)
+DEV_CORE_STATS_INC(tx_dropped)
+DEV_CORE_STATS_INC(rx_nohandler)
+
 static __always_inline int ____dev_forward_skb(struct net_device *dev,
 					       struct sk_buff *skb,
 					       const bool check_mtu)
 {
 	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
 	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
-		atomic_long_inc(&dev->rx_dropped);
+		dev_core_stats_rx_dropped_inc(dev);
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
diff --git a/include/net/bonding.h b/include/net/bonding.h
index d0dfe727e0b1cb45b60c6e38af545c083734db12..b14f4c0b4e9ed1c6a94cd03258d935727c971b77 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -770,7 +770,7 @@ extern const struct sysfs_ops slave_sysfs_ops;
 
 static inline netdev_tx_t bond_tx_drop(struct net_device *dev, struct sk_buff *skb)
 {
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	dev_kfree_skb_any(skb);
 	return NET_XMIT_DROP;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index ba69ddf85af6b4543caa91f314caf54794a3a02a..ccd7eea84e09b25edb1e5a06521a20f394aa5516 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3635,7 +3635,7 @@ static struct sk_buff *validate_xmit_skb(struct sk_buff *skb, struct net_device
 out_kfree_skb:
 	kfree_skb(skb);
 out_null:
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	return NULL;
 }
 
@@ -4186,7 +4186,7 @@ static int __dev_queue_xmit(struct sk_buff *skb, struct net_device *sb_dev)
 	rc = -ENETDOWN;
 	rcu_read_unlock_bh();
 
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	kfree_skb_list(skb);
 	return rc;
 out:
@@ -4238,7 +4238,7 @@ int __dev_direct_xmit(struct sk_buff *skb, u16 queue_id)
 	local_bh_enable();
 	return ret;
 drop:
-	atomic_long_inc(&dev->tx_dropped);
+	dev_core_stats_tx_dropped_inc(dev);
 	kfree_skb_list(skb);
 	return NET_XMIT_DROP;
 }
@@ -4604,7 +4604,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 	sd->dropped++;
 	rps_unlock_irq_restore(sd, &flags);
 
-	atomic_long_inc(&skb->dev->rx_dropped);
+	dev_core_stats_rx_dropped_inc(skb->dev);
 	kfree_skb_reason(skb, reason);
 	return NET_RX_DROP;
 }
@@ -5359,10 +5359,10 @@ static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 	} else {
 drop:
 		if (!deliver_exact) {
-			atomic_long_inc(&skb->dev->rx_dropped);
+			dev_core_stats_rx_dropped_inc(skb->dev);
 			kfree_skb_reason(skb, SKB_DROP_REASON_PTYPE_ABSENT);
 		} else {
-			atomic_long_inc(&skb->dev->rx_nohandler);
+			dev_core_stats_rx_nohandler_inc(skb->dev);
 			kfree_skb(skb);
 		}
 		/* Jamal, now you will not able to escape explaining
@@ -10282,6 +10282,24 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 }
 EXPORT_SYMBOL(netdev_stats_to_stats64);
 
+struct net_device_core_stats *netdev_core_stats_alloc(struct net_device *dev)
+{
+	struct net_device_core_stats __percpu *p;
+
+	p = alloc_percpu_gfp(struct net_device_core_stats,
+			     GFP_ATOMIC | __GFP_NOWARN);
+
+	if (p && cmpxchg(&dev->core_stats, NULL, p))
+		free_percpu(p);
+
+	p = dev->core_stats;
+	if (!p)
+		return NULL;
+
+	return this_cpu_ptr(p);
+}
+EXPORT_SYMBOL(netdev_core_stats_alloc);
+
 /**
  *	dev_get_stats	- get network device statistics
  *	@dev: device to get statistics from
@@ -10296,6 +10314,7 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 					struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	const struct net_device_core_stats __percpu *p;
 
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
@@ -10305,9 +10324,20 @@ struct rtnl_link_stats64 *dev_get_stats(struct net_device *dev,
 	} else {
 		netdev_stats_to_stats64(storage, &dev->stats);
 	}
-	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
-	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
-	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
+
+	/* This READ_ONCE() pairs with the write in netdev_core_stats_alloc() */
+	p = READ_ONCE(dev->core_stats);
+	if (p) {
+		const struct net_device_core_stats *core_stats;
+		int i;
+
+		for_each_possible_cpu(i) {
+			core_stats = per_cpu(p, i);
+			storage->rx_dropped += local_read(&core_stats->rx_dropped);
+			storage->tx_dropped += local_read(&core_stats->tx_dropped);
+			storage->rx_nohandler += local_read(&core_stats->rx_nohandler);
+		}
+	}
 	return storage;
 }
 EXPORT_SYMBOL(dev_get_stats);
@@ -10569,6 +10599,8 @@ void free_netdev(struct net_device *dev)
 	free_percpu(dev->pcpu_refcnt);
 	dev->pcpu_refcnt = NULL;
 #endif
+	free_percpu(dev->core_stats);
+	dev->core_stats = NULL;
 	free_percpu(dev->xdp_bulkq);
 	dev->xdp_bulkq = NULL;
 
diff --git a/net/core/gro_cells.c b/net/core/gro_cells.c
index 8462f926ab457322a12510a4d294ecca617948f0..541c7a72a28a4b00e7e196eca01df42842ea103f 100644
--- a/net/core/gro_cells.c
+++ b/net/core/gro_cells.c
@@ -28,7 +28,7 @@ int gro_cells_receive(struct gro_cells *gcells, struct sk_buff *skb)
 
 	if (skb_queue_len(&cell->napi_skbs) > netdev_max_backlog) {
 drop:
-		atomic_long_inc(&dev->rx_dropped);
+		dev_core_stats_rx_dropped_inc(dev);
 		kfree_skb(skb);
 		res = NET_RX_DROP;
 		goto unlock;
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index 7f250216433d32dd6fda52d2932e45cedf3fc24d..6ffef47e9be55c408c8c2b32472466205c690507 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -221,7 +221,7 @@ static netdev_tx_t hsr_dev_xmit(struct sk_buff *skb, struct net_device *dev)
 		skb_reset_mac_len(skb);
 		hsr_forward_skb(skb, master);
 	} else {
-		atomic_long_inc(&dev->tx_dropped);
+		dev_core_stats_tx_dropped_inc(dev);
 		dev_kfree_skb_any(skb);
 	}
 	return NETDEV_TX_OK;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 39bce5d764de5d28682368e4cbfa18f7c7f16e63..3e3448ada1bb1396e39a119cdbdf3edb9a11ae6f 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -143,7 +143,7 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		segs = skb_gso_segment(skb, esp_features);
 		if (IS_ERR(segs)) {
 			kfree_skb(skb);
-			atomic_long_inc(&dev->tx_dropped);
+			dev_core_stats_tx_dropped_inc(dev);
 			return NULL;
 		} else {
 			consume_skb(skb);
-- 
2.35.1.616.g0bdcbb4464-goog

