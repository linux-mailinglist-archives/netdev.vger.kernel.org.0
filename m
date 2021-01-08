Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 948E22EEA52
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 01:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729635AbhAHAV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 19:21:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729589AbhAHAVt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 19:21:49 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A815C0612FF
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 16:20:38 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id qw4so12119390ejb.12
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 16:20:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ntfzK9SbDysANK2lZRsU82gYRppMfK/4oXK3IjadEAs=;
        b=Pf60WzYfPkrLcS4og0J/4qgJlkNHC335hfEZ5waZtuizGp24J82U6mO9tO6BJOIsvV
         8Ygw2y4NFSC4GtkzbqUEkAOWbBRfZYkk+quLRMg9WArehSvGpI9yDXhtUQe6uWpbUlt/
         +SokCLm3diegEfoVySUE7maRlzK2vpcYUOYJ/RucDzcMvoYxwAAtYS7fLjIZC0nTs92q
         /8xCLue4un+jZRPi8gqHX4KxQ1jMapx3WizHtvjhXUF4EWTixP/rwX5PRX2KAYSHyC0G
         JE6amqDU5m3cygbK2dh+aeNwZVy5oPkBoXTXwUfzQ762iS5eXtEdAtbZYPRqkobjUMJD
         Yn4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ntfzK9SbDysANK2lZRsU82gYRppMfK/4oXK3IjadEAs=;
        b=MVBwJvWCkm5PR8NbI3dBeYu6193qMEkQ+zBMUjiO6qnOHXijcVWWcIDg45TuMOr3e6
         VizzFNU+56rac/xtmWX+VRyjWZqMXwpAW9FCX7Ic1hO118YWztB74UCHUYvIRt803M5N
         KpVzJRnf4YhQiuld/vbXkb47gA8rvnTSTeKmi1TA+cCJF20vKXStMwc6zCEdiO3qHmwP
         aXBn/tMlRh0MYE5MMcN6gN8+UP8TTA7dryX7NpiarFV6fHu/bqyK3g5oV/rIotWnepEo
         9E/jvBUTV2PLwWJEBPc0u8f7y+bij8fScPf40q80fvg+8X/GF7rw2cMi5KCP7N+YkYXe
         yVXA==
X-Gm-Message-State: AOAM5330VrDinyrY+IsTgdeJv9V28p7+DxFYHrwDrafYbxMMQUV61thb
        slZzsHPkXdxMPXu6Q/OSuzs=
X-Google-Smtp-Source: ABdhPJxqQ9xlCtm8Ij1MoHw9H1NBgpn9nrAp+1pq61h5UNqfdeSQ3GFWAT9kypbYo9nVA7nK/bmZ/A==
X-Received: by 2002:a17:906:31cb:: with SMTP id f11mr965177ejf.468.1610065236687;
        Thu, 07 Jan 2021 16:20:36 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id rk12sm2981691ejb.75.2021.01.07.16.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 16:20:36 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Arnd Bergmann <arnd@arndb.de>, Taehee Yoo <ap420073@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, Florian Westphal <fw@strlen.de>
Subject: [PATCH v4 net-next 09/18] net: allow ndo_get_stats64 to return an int error code
Date:   Fri,  8 Jan 2021 02:19:56 +0200
Message-Id: <20210108002005.3429956-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210108002005.3429956-1-olteanv@gmail.com>
References: <20210108002005.3429956-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Some drivers need to do special tricks to comply with the new policy of
ndo_get_stats64 being sleepable. For example, the bonding driver, which
derives its stats from its lower interfaces, must recurse with
dev_get_stats into its lowers with no locks held. But for that to work,
it needs to dynamically allocate some memory for a refcounted copy of
its array of slave interfaces (because recursing unlocked means that the
original one is subject to disappearing). And since memory allocation
can fail under pressure, we should not let it go unnoticed, but instead
propagate the error code.

This patch converts all implementations of .ndo_get_stats64 to return
int, and propagates that to the dev_get_stats calling site. Error
checking will be done in further patches.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v4:
Patch is new (Eric's suggestion).

 drivers/infiniband/hw/hfi1/vnic_main.c               |  6 ++++--
 drivers/infiniband/ulp/ipoib/ipoib_main.c            |  9 ++++++---
 drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c    |  9 ++++++---
 drivers/net/bonding/bond_main.c                      | 11 +++++++----
 drivers/net/dummy.c                                  |  6 ++++--
 drivers/net/ethernet/alacritech/slicoss.c            |  6 ++++--
 drivers/net/ethernet/amazon/ena/ena_netdev.c         |  8 +++++---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c             |  6 ++++--
 drivers/net/ethernet/apm/xgene-v2/main.c             |  6 ++++--
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c     |  7 ++++---
 drivers/net/ethernet/atheros/alx/main.c              |  6 ++++--
 drivers/net/ethernet/broadcom/b44.c                  |  6 ++++--
 drivers/net/ethernet/broadcom/bcmsysport.c           |  6 ++++--
 drivers/net/ethernet/broadcom/bnx2.c                 |  5 +++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.c            |  6 ++++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c        |  4 +++-
 drivers/net/ethernet/broadcom/tg3.c                  |  8 +++++---
 drivers/net/ethernet/brocade/bna/bnad.c              |  4 +++-
 drivers/net/ethernet/calxeda/xgmac.c                 |  4 +++-
 drivers/net/ethernet/cavium/liquidio/lio_main.c      |  6 ++++--
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c   |  6 ++++--
 drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c    |  8 +++++---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c     |  5 +++--
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c      |  8 +++++---
 drivers/net/ethernet/cisco/enic/enic_main.c          |  8 +++++---
 drivers/net/ethernet/cortina/gemini.c                |  6 ++++--
 drivers/net/ethernet/ec_bhf.c                        |  4 +++-
 drivers/net/ethernet/emulex/benet/be_main.c          |  6 ++++--
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c       |  6 ++++--
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c     |  6 ++++--
 drivers/net/ethernet/google/gve/gve_main.c           |  4 +++-
 drivers/net/ethernet/hisilicon/hns/hns_enet.c        |  6 ++++--
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c      |  8 +++++---
 drivers/net/ethernet/huawei/hinic/hinic_main.c       |  6 ++++--
 drivers/net/ethernet/ibm/ehea/ehea_main.c            |  6 ++++--
 drivers/net/ethernet/intel/e1000e/e1000.h            |  4 ++--
 drivers/net/ethernet/intel/e1000e/netdev.c           |  6 ++++--
 drivers/net/ethernet/intel/fm10k/fm10k_netdev.c      |  6 ++++--
 drivers/net/ethernet/intel/i40e/i40e_main.c          | 10 ++++++----
 drivers/net/ethernet/intel/ice/ice_main.c            |  6 ++++--
 drivers/net/ethernet/intel/igb/igb_main.c            | 10 ++++++----
 drivers/net/ethernet/intel/igc/igc_main.c            |  6 ++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c        |  6 ++++--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c    |  6 ++++--
 drivers/net/ethernet/marvell/mvneta.c                |  4 +++-
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c      |  4 +++-
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.c |  6 ++++--
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h |  4 ++--
 .../net/ethernet/marvell/prestera/prestera_main.c    |  6 ++++--
 drivers/net/ethernet/marvell/sky2.c                  |  6 ++++--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c          |  6 ++++--
 drivers/net/ethernet/mediatek/mtk_star_emac.c        |  6 ++++--
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c       |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en.h         |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    |  4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c     |  4 +++-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c    |  4 +++-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h    |  2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c       |  4 +++-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c       |  4 +++-
 drivers/net/ethernet/microchip/lan743x_main.c        |  6 ++++--
 drivers/net/ethernet/mscc/ocelot_net.c               |  6 ++++--
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c     | 12 +++++++-----
 drivers/net/ethernet/neterion/vxge/vxge-main.c       |  4 +++-
 drivers/net/ethernet/netronome/nfp/nfp_net_common.c  |  6 ++++--
 drivers/net/ethernet/netronome/nfp/nfp_net_repr.c    |  6 ++++--
 drivers/net/ethernet/nvidia/forcedeth.c              |  4 +++-
 drivers/net/ethernet/pensando/ionic/ionic_lif.c      |  6 ++++--
 drivers/net/ethernet/pensando/ionic/ionic_lif.h      |  4 ++--
 drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c | 10 ++++++----
 drivers/net/ethernet/qlogic/qede/qede_main.c         |  6 ++++--
 drivers/net/ethernet/qualcomm/emac/emac.c            |  6 ++++--
 drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c      |  8 +++++---
 drivers/net/ethernet/realtek/8139too.c               |  8 +++++---
 drivers/net/ethernet/realtek/r8169_main.c            |  4 +++-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c      |  6 ++++--
 drivers/net/ethernet/sfc/efx_common.c                |  4 +++-
 drivers/net/ethernet/sfc/efx_common.h                |  2 +-
 drivers/net/ethernet/sfc/falcon/efx.c                |  6 ++++--
 drivers/net/ethernet/socionext/sni_ave.c             |  6 ++++--
 drivers/net/ethernet/sun/niu.c                       |  6 ++++--
 drivers/net/ethernet/synopsys/dwc-xlgmac-net.c       |  6 ++++--
 drivers/net/ethernet/ti/am65-cpsw-nuss.c             |  6 ++++--
 drivers/net/ethernet/ti/netcp_core.c                 |  4 +++-
 drivers/net/ethernet/via/via-rhine.c                 |  8 +++++---
 drivers/net/fjes/fjes_main.c                         |  6 ++++--
 drivers/net/hyperv/netvsc_drv.c                      |  6 ++++--
 drivers/net/ifb.c                                    |  5 +++--
 drivers/net/ipvlan/ipvlan_main.c                     |  6 ++++--
 drivers/net/loopback.c                               |  6 ++++--
 drivers/net/macsec.c                                 |  8 +++++---
 drivers/net/macvlan.c                                |  6 ++++--
 drivers/net/mhi_net.c                                |  6 ++++--
 drivers/net/net_failover.c                           |  6 ++++--
 drivers/net/netdevsim/netdev.c                       |  4 +++-
 drivers/net/nlmon.c                                  |  4 +++-
 drivers/net/ppp/ppp_generic.c                        |  4 +++-
 drivers/net/slip/slip.c                              |  4 +++-
 drivers/net/team/team.c                              |  4 +++-
 drivers/net/thunderbolt.c                            |  6 ++++--
 drivers/net/tun.c                                    |  4 +++-
 drivers/net/veth.c                                   |  6 ++++--
 drivers/net/virtio_net.c                             |  6 ++++--
 drivers/net/vmxnet3/vmxnet3_ethtool.c                |  4 +++-
 drivers/net/vmxnet3/vmxnet3_int.h                    |  4 ++--
 drivers/net/vrf.c                                    |  6 ++++--
 drivers/net/vsockmon.c                               |  4 +++-
 drivers/net/xen-netfront.c                           |  6 ++++--
 drivers/s390/net/qeth_core.h                         |  2 +-
 drivers/s390/net/qeth_core_main.c                    |  4 +++-
 drivers/scsi/fcoe/fcoe_transport.c                   |  6 +++---
 drivers/staging/fsl-dpaa2/ethsw/ethsw.c              |  8 +++-----
 drivers/staging/netlogic/xlr_net.c                   |  4 +++-
 include/linux/netdevice.h                            | 10 +++++-----
 net/8021q/vlan_dev.c                                 |  6 ++++--
 net/core/dev.c                                       | 11 ++++++++---
 net/l2tp/l2tp_eth.c                                  |  6 ++++--
 net/mac80211/iface.c                                 |  4 +++-
 net/sched/sch_teql.c                                 |  6 ++++--
 119 files changed, 453 insertions(+), 237 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/vnic_main.c b/drivers/infiniband/hw/hfi1/vnic_main.c
index a90824de0f57..bf0b5c9d8e3b 100644
--- a/drivers/infiniband/hw/hfi1/vnic_main.c
+++ b/drivers/infiniband/hw/hfi1/vnic_main.c
@@ -220,13 +220,15 @@ static void hfi1_vnic_update_rx_counters(struct hfi1_vnic_vport_info *vinfo,
 }
 
 /* This function is overloaded for opa_vnic specific implementation */
-static void hfi1_vnic_get_stats64(struct net_device *netdev,
-				  struct rtnl_link_stats64 *stats)
+static int hfi1_vnic_get_stats64(struct net_device *netdev,
+				 struct rtnl_link_stats64 *stats)
 {
 	struct opa_vnic_stats *vstats = (struct opa_vnic_stats *)stats;
 	struct hfi1_vnic_vport_info *vinfo = opa_vnic_dev_priv(netdev);
 
 	hfi1_vnic_update_stats(vinfo, vstats);
+
+	return 0;
 }
 
 static u64 create_bypass_pbc(u32 vl, u32 dw_len)
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index a6f413491321..ce8f333deaa4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -268,15 +268,18 @@ static int ipoib_change_mtu(struct net_device *dev, int new_mtu)
 	return ret;
 }
 
-static void ipoib_get_stats(struct net_device *dev,
-			    struct rtnl_link_stats64 *stats)
+static int ipoib_get_stats(struct net_device *dev,
+			   struct rtnl_link_stats64 *stats)
 {
 	struct ipoib_dev_priv *priv = ipoib_priv(dev);
+	int err = 0;
 
 	if (priv->rn_ops->ndo_get_stats64)
-		priv->rn_ops->ndo_get_stats64(dev, stats);
+		err = priv->rn_ops->ndo_get_stats64(dev, stats);
 	else
 		netdev_stats_to_stats64(stats, &dev->stats);
+
+	return err;
 }
 
 /* Called with an RCU read lock taken */
diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
index aeff68f582d3..4b0ca1707b9d 100644
--- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
+++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_netdev.c
@@ -62,17 +62,20 @@
 			ALIGN((OPA_VNIC_HDR_LEN + OPA_VNIC_SKB_MDATA_LEN), 8)
 
 /* This function is overloaded for opa_vnic specific implementation */
-static void opa_vnic_get_stats64(struct net_device *netdev,
-				 struct rtnl_link_stats64 *stats)
+static int opa_vnic_get_stats64(struct net_device *netdev,
+				struct rtnl_link_stats64 *stats)
 {
 	struct opa_vnic_adapter *adapter = opa_vnic_priv(netdev);
 	struct opa_vnic_stats vstats;
+	int err;
 
 	memset(&vstats, 0, sizeof(vstats));
 	spin_lock(&adapter->stats_lock);
-	adapter->rn_ops->ndo_get_stats64(netdev, &vstats.netstats);
+	err = adapter->rn_ops->ndo_get_stats64(netdev, &vstats.netstats);
 	spin_unlock(&adapter->stats_lock);
 	memcpy(stats, &vstats.netstats, sizeof(*stats));
+
+	return err;
 }
 
 /* opa_netdev_start_xmit - transmit function */
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 714aa0e5d041..5a3178b3dba3 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -252,8 +252,8 @@ static struct flow_dissector flow_keys_bonding __read_mostly;
 
 static int bond_init(struct net_device *bond_dev);
 static void bond_uninit(struct net_device *bond_dev);
-static void bond_get_stats(struct net_device *bond_dev,
-			   struct rtnl_link_stats64 *stats);
+static int bond_get_stats(struct net_device *bond_dev,
+			  struct rtnl_link_stats64 *stats);
 static void bond_slave_arr_handler(struct work_struct *work);
 static bool bond_time_in_interval(struct bonding *bond, unsigned long last_act,
 				  int mod);
@@ -2070,6 +2070,7 @@ static int __bond_release_one(struct net_device *bond_dev,
 	struct sockaddr_storage ss;
 	int old_flags = bond_dev->flags;
 	netdev_features_t old_features = bond_dev->features;
+	int err;
 
 	/* slave is not a slave or master is not master of this slave */
 	if (!(slave_dev->flags & IFF_SLAVE) ||
@@ -3734,8 +3735,8 @@ static int bond_get_lowest_level_rcu(struct net_device *dev)
 }
 #endif
 
-static void bond_get_stats(struct net_device *bond_dev,
-			   struct rtnl_link_stats64 *stats)
+static int bond_get_stats(struct net_device *bond_dev,
+			  struct rtnl_link_stats64 *stats)
 {
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct rtnl_link_stats64 temp;
@@ -3764,6 +3765,8 @@ static void bond_get_stats(struct net_device *bond_dev,
 	memcpy(&bond->bond_stats, stats, sizeof(*stats));
 	spin_unlock(&bond->stats_lock);
 	rcu_read_unlock();
+
+	return 0;
 }
 
 static int bond_do_ioctl(struct net_device *bond_dev, struct ifreq *ifr, int cmd)
diff --git a/drivers/net/dummy.c b/drivers/net/dummy.c
index f82ad7419508..97b6b5f7e43f 100644
--- a/drivers/net/dummy.c
+++ b/drivers/net/dummy.c
@@ -50,10 +50,12 @@ static void set_multicast_list(struct net_device *dev)
 {
 }
 
-static void dummy_get_stats64(struct net_device *dev,
-			      struct rtnl_link_stats64 *stats)
+static int dummy_get_stats64(struct net_device *dev,
+			     struct rtnl_link_stats64 *stats)
 {
 	dev_lstats_read(dev, &stats->tx_packets, &stats->tx_bytes);
+
+	return 0;
 }
 
 static netdev_tx_t dummy_xmit(struct sk_buff *skb, struct net_device *dev)
diff --git a/drivers/net/ethernet/alacritech/slicoss.c b/drivers/net/ethernet/alacritech/slicoss.c
index 696517eae77f..c68a025e17da 100644
--- a/drivers/net/ethernet/alacritech/slicoss.c
+++ b/drivers/net/ethernet/alacritech/slicoss.c
@@ -1457,8 +1457,8 @@ static netdev_tx_t slic_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static void slic_get_stats(struct net_device *dev,
-			   struct rtnl_link_stats64 *lst)
+static int slic_get_stats(struct net_device *dev,
+			  struct rtnl_link_stats64 *lst)
 {
 	struct slic_device *sdev = netdev_priv(dev);
 	struct slic_stats *stats = &sdev->stats;
@@ -1475,6 +1475,8 @@ static void slic_get_stats(struct net_device *dev,
 	SLIC_GET_STATS_COUNTER(lst->rx_crc_errors, stats, rx_crc);
 	SLIC_GET_STATS_COUNTER(lst->rx_fifo_errors, stats, rx_oflow802);
 	SLIC_GET_STATS_COUNTER(lst->tx_carrier_errors, stats, tx_carrier);
+
+	return 0;
 }
 
 static int slic_get_sset_count(struct net_device *dev, int sset)
diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 06596fa1f9fe..a6c52f07025a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3229,8 +3229,8 @@ int ena_update_hw_stats(struct ena_adapter *adapter)
 	return 0;
 }
 
-static void ena_get_stats64(struct net_device *netdev,
-			    struct rtnl_link_stats64 *stats)
+static int ena_get_stats64(struct net_device *netdev,
+			   struct rtnl_link_stats64 *stats)
 {
 	struct ena_adapter *adapter = netdev_priv(netdev);
 	struct ena_ring *rx_ring, *tx_ring;
@@ -3240,7 +3240,7 @@ static void ena_get_stats64(struct net_device *netdev,
 	int i;
 
 	if (!test_bit(ENA_FLAG_DEV_UP, &adapter->flags))
-		return;
+		return 0;
 
 	for (i = 0; i < adapter->num_io_queues; i++) {
 		u64 bytes, packets;
@@ -3289,6 +3289,8 @@ static void ena_get_stats64(struct net_device *netdev,
 
 	stats->rx_errors = 0;
 	stats->tx_errors = 0;
+
+	return 0;
 }
 
 static const struct net_device_ops ena_netdev_ops = {
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 2709a2db5657..a6d636b0002f 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -2074,8 +2074,8 @@ static void xgbe_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	schedule_work(&pdata->restart_work);
 }
 
-static void xgbe_get_stats64(struct net_device *netdev,
-			     struct rtnl_link_stats64 *s)
+static int xgbe_get_stats64(struct net_device *netdev,
+			    struct rtnl_link_stats64 *s)
 {
 	struct xgbe_prv_data *pdata = netdev_priv(netdev);
 	struct xgbe_mmc_stats *pstats = &pdata->mmc_stats;
@@ -2101,6 +2101,8 @@ static void xgbe_get_stats64(struct net_device *netdev,
 	s->tx_dropped = netdev->stats.tx_dropped;
 
 	DBGPR("<--%s\n", __func__);
+
+	return 0;
 }
 
 static int xgbe_vlan_rx_add_vid(struct net_device *netdev, __be16 proto,
diff --git a/drivers/net/ethernet/apm/xgene-v2/main.c b/drivers/net/ethernet/apm/xgene-v2/main.c
index 860c18fb7aae..6b72b488c987 100644
--- a/drivers/net/ethernet/apm/xgene-v2/main.c
+++ b/drivers/net/ethernet/apm/xgene-v2/main.c
@@ -606,8 +606,8 @@ static void xge_timeout(struct net_device *ndev, unsigned int txqueue)
 	rtnl_unlock();
 }
 
-static void xge_get_stats64(struct net_device *ndev,
-			    struct rtnl_link_stats64 *storage)
+static int xge_get_stats64(struct net_device *ndev,
+			   struct rtnl_link_stats64 *storage)
 {
 	struct xge_pdata *pdata = netdev_priv(ndev);
 	struct xge_stats *stats = &pdata->stats;
@@ -618,6 +618,8 @@ static void xge_get_stats64(struct net_device *ndev,
 	storage->rx_packets += stats->rx_packets;
 	storage->rx_bytes += stats->rx_bytes;
 	storage->rx_errors += stats->rx_errors;
+
+	return 0;
 }
 
 static const struct net_device_ops xgene_ndev_ops = {
diff --git a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
index 5f1fc6582d74..8567b85a8bb8 100644
--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -1465,9 +1465,8 @@ static int xgene_enet_create_desc_rings(struct net_device *ndev)
 	return ret;
 }
 
-static void xgene_enet_get_stats64(
-			struct net_device *ndev,
-			struct rtnl_link_stats64 *stats)
+static int xgene_enet_get_stats64(struct net_device *ndev,
+				  struct rtnl_link_stats64 *stats)
 {
 	struct xgene_enet_pdata *pdata = netdev_priv(ndev);
 	struct xgene_enet_desc_ring *ring;
@@ -1500,6 +1499,8 @@ static void xgene_enet_get_stats64(
 			stats->rx_fifo_errors += ring->rx_fifo_errors;
 		}
 	}
+
+	return 0;
 }
 
 static int xgene_enet_set_mac_address(struct net_device *ndev, void *addr)
diff --git a/drivers/net/ethernet/atheros/alx/main.c b/drivers/net/ethernet/atheros/alx/main.c
index 9b7f1af5f574..b15ac4a2e94a 100644
--- a/drivers/net/ethernet/atheros/alx/main.c
+++ b/drivers/net/ethernet/atheros/alx/main.c
@@ -1624,8 +1624,8 @@ static void alx_poll_controller(struct net_device *netdev)
 }
 #endif
 
-static void alx_get_stats64(struct net_device *dev,
-			    struct rtnl_link_stats64 *net_stats)
+static int alx_get_stats64(struct net_device *dev,
+			   struct rtnl_link_stats64 *net_stats)
 {
 	struct alx_priv *alx = netdev_priv(dev);
 	struct alx_hw_stats *hw_stats = &alx->hw.stats;
@@ -1669,6 +1669,8 @@ static void alx_get_stats64(struct net_device *dev,
 	net_stats->rx_packets = hw_stats->rx_ok + net_stats->rx_errors;
 
 	spin_unlock(&alx->stats_lock);
+
+	return 0;
 }
 
 static const struct net_device_ops alx_netdev_ops = {
diff --git a/drivers/net/ethernet/broadcom/b44.c b/drivers/net/ethernet/broadcom/b44.c
index b455b60a5434..03e53b6bb7c9 100644
--- a/drivers/net/ethernet/broadcom/b44.c
+++ b/drivers/net/ethernet/broadcom/b44.c
@@ -1670,8 +1670,8 @@ static int b44_close(struct net_device *dev)
 	return 0;
 }
 
-static void b44_get_stats64(struct net_device *dev,
-			    struct rtnl_link_stats64 *nstat)
+static int b44_get_stats64(struct net_device *dev,
+			   struct rtnl_link_stats64 *nstat)
 {
 	struct b44 *bp = netdev_priv(dev);
 	struct b44_hw_stats *hwstat = &bp->hw_stats;
@@ -1714,6 +1714,8 @@ static void b44_get_stats64(struct net_device *dev,
 #endif
 	} while (u64_stats_fetch_retry_irq(&hwstat->syncp, start));
 
+	return 0;
+
 }
 
 static int __b44_load_mcast(struct b44 *bp, struct net_device *dev)
diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index b1ae9eb8f247..1ef0bfba72c6 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1858,8 +1858,8 @@ static int bcm_sysport_change_mac(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void bcm_sysport_get_stats64(struct net_device *dev,
-				    struct rtnl_link_stats64 *stats)
+static int bcm_sysport_get_stats64(struct net_device *dev,
+				   struct rtnl_link_stats64 *stats)
 {
 	struct bcm_sysport_priv *priv = netdev_priv(dev);
 	struct bcm_sysport_stats64 *stats64 = &priv->stats64;
@@ -1875,6 +1875,8 @@ static void bcm_sysport_get_stats64(struct net_device *dev,
 		stats->rx_packets = stats64->rx_packets;
 		stats->rx_bytes = stats64->rx_bytes;
 	} while (u64_stats_fetch_retry_irq(&priv->syncp, start));
+
+	return 0;
 }
 
 static void bcm_sysport_netif_start(struct net_device *dev)
diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 3e8a179f39db..7aa9cb8b3578 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -6812,13 +6812,13 @@ bnx2_save_stats(struct bnx2 *bp)
 	(unsigned long) (bp->stats_blk->ctr +			\
 			 bp->temp_stats_blk->ctr)
 
-static void
+static int
 bnx2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *net_stats)
 {
 	struct bnx2 *bp = netdev_priv(dev);
 
 	if (!bp->stats_blk)
-		return;
+		return 0;
 
 	net_stats->rx_packets =
 		GET_64BIT_NET_STATS(stat_IfHCInUcastPkts) +
@@ -6882,6 +6882,7 @@ bnx2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *net_stats)
 		GET_32BIT_NET_STATS(stat_IfInMBUFDiscards) +
 		GET_32BIT_NET_STATS(stat_FwRxDrop);
 
+	return 0;
 }
 
 /* All ethtool functions called with rtnl_lock */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index bbd2a07dc329..2f0037da2c96 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -10096,7 +10096,7 @@ static void bnxt_add_prev_stats(struct bnxt *bp,
 	stats->tx_dropped += prev_stats->tx_dropped;
 }
 
-static void
+static int
 bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -10109,7 +10109,7 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	if (!test_bit(BNXT_STATE_OPEN, &bp->state)) {
 		clear_bit(BNXT_STATE_READ_STATS, &bp->state);
 		*stats = bp->net_stats_prev;
-		return;
+		return 0;
 	}
 
 	bnxt_get_ring_stats(bp, stats);
@@ -10138,6 +10138,8 @@ bnxt_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_errors = BNXT_GET_TX_PORT_STATS64(tx, tx_err);
 	}
 	clear_bit(BNXT_STATE_READ_STATS, &bp->state);
+
+	return 0;
 }
 
 static bool bnxt_mc_list_updated(struct bnxt *bp, u32 *rx_mask)
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
index 4b5c8fd76a51..5d60073af2e6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_vfr.c
@@ -129,7 +129,7 @@ static netdev_tx_t bnxt_vf_rep_xmit(struct sk_buff *skb,
 	return rc;
 }
 
-static void
+static int
 bnxt_vf_rep_get_stats64(struct net_device *dev,
 			struct rtnl_link_stats64 *stats)
 {
@@ -139,6 +139,8 @@ bnxt_vf_rep_get_stats64(struct net_device *dev,
 	stats->rx_bytes = vf_rep->rx_stats.bytes;
 	stats->tx_packets = vf_rep->tx_stats.packets;
 	stats->tx_bytes = vf_rep->tx_stats.bytes;
+
+	return 0;
 }
 
 static int bnxt_vf_rep_setup_tc_block_cb(enum tc_setup_type type,
diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index 5143cdd0eeca..d632a4a502cd 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -14201,8 +14201,8 @@ static const struct ethtool_ops tg3_ethtool_ops = {
 	.set_link_ksettings	= tg3_set_link_ksettings,
 };
 
-static void tg3_get_stats64(struct net_device *dev,
-			    struct rtnl_link_stats64 *stats)
+static int tg3_get_stats64(struct net_device *dev,
+			   struct rtnl_link_stats64 *stats)
 {
 	struct tg3 *tp = netdev_priv(dev);
 
@@ -14210,11 +14210,13 @@ static void tg3_get_stats64(struct net_device *dev,
 	if (!tp->hw_stats || !tg3_flag(tp, INIT_COMPLETE)) {
 		*stats = tp->net_stats_prev;
 		spin_unlock_bh(&tp->lock);
-		return;
+		return 0;
 	}
 
 	tg3_get_nstats(tp, stats);
 	spin_unlock_bh(&tp->lock);
+
+	return 0;
 }
 
 static void tg3_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/ethernet/brocade/bna/bnad.c b/drivers/net/ethernet/brocade/bna/bnad.c
index 7e4e831d720f..a56dcdb93430 100644
--- a/drivers/net/ethernet/brocade/bna/bnad.c
+++ b/drivers/net/ethernet/brocade/bna/bnad.c
@@ -3096,7 +3096,7 @@ bnad_start_xmit(struct sk_buff *skb, struct net_device *netdev)
  * Used spin_lock to synchronize reading of stats structures, which
  * is written by BNA under the same lock.
  */
-static void
+static int
 bnad_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 {
 	struct bnad *bnad = netdev_priv(netdev);
@@ -3108,6 +3108,8 @@ bnad_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	bnad_netdev_hwstats_fill(bnad, stats);
 
 	spin_unlock_irqrestore(&bnad->bna_lock, flags);
+
+	return 0;
 }
 
 static void
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index bbb453c6a5f7..5e41dc5125f9 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1438,7 +1438,7 @@ static void xgmac_poll_controller(struct net_device *dev)
 }
 #endif
 
-static void
+static int
 xgmac_get_stats64(struct net_device *dev,
 		  struct rtnl_link_stats64 *storage)
 {
@@ -1468,6 +1468,8 @@ xgmac_get_stats64(struct net_device *dev,
 
 	writel(0, base + XGMAC_MMC_CTRL);
 	spin_unlock_bh(&priv->stats_lock);
+
+	return 0;
 }
 
 static int xgmac_set_mac_address(struct net_device *dev, void *p)
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 7d00d3a8ded4..0b8bd1f90678 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -2021,7 +2021,7 @@ static int liquidio_set_mac(struct net_device *netdev, void *p)
 	return 0;
 }
 
-static void
+static int
 liquidio_get_stats64(struct net_device *netdev,
 		     struct rtnl_link_stats64 *lstats)
 {
@@ -2035,7 +2035,7 @@ liquidio_get_stats64(struct net_device *netdev,
 	oct = lio->oct_dev;
 
 	if (ifstate_check(lio, LIO_IFSTATE_RESETTING))
-		return;
+		return 0;
 
 	for (i = 0; i < oct->num_iqs; i++) {
 		iq_no = lio->linfo.txpciq[i].s.q_no;
@@ -2091,6 +2091,8 @@ liquidio_get_stats64(struct net_device *netdev,
 	lstats->tx_errors = lstats->tx_aborted_errors +
 		lstats->tx_carrier_errors +
 		lstats->tx_fifo_errors;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
index 103440f97bc8..e880d914eb2e 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_main.c
@@ -1161,7 +1161,7 @@ static int liquidio_set_mac(struct net_device *netdev, void *p)
 	return 0;
 }
 
-static void
+static int
 liquidio_get_stats64(struct net_device *netdev,
 		     struct rtnl_link_stats64 *lstats)
 {
@@ -1175,7 +1175,7 @@ liquidio_get_stats64(struct net_device *netdev,
 	oct = lio->oct_dev;
 
 	if (ifstate_check(lio, LIO_IFSTATE_RESETTING))
-		return;
+		return 0;
 
 	for (i = 0; i < oct->num_iqs; i++) {
 		iq_no = lio->linfo.txpciq[i].s.q_no;
@@ -1226,6 +1226,8 @@ liquidio_get_stats64(struct net_device *netdev,
 
 	lstats->tx_errors = lstats->tx_aborted_errors +
 		lstats->tx_carrier_errors;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
index 600de587d7a9..763248863c79 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_vf_rep.c
@@ -34,8 +34,8 @@ static netdev_tx_t lio_vf_rep_pkt_xmit(struct sk_buff *skb,
 static void lio_vf_rep_tx_timeout(struct net_device *netdev, unsigned int txqueue);
 static int lio_vf_rep_phys_port_name(struct net_device *dev,
 				     char *buf, size_t len);
-static void lio_vf_rep_get_stats64(struct net_device *dev,
-				   struct rtnl_link_stats64 *stats64);
+static int lio_vf_rep_get_stats64(struct net_device *dev,
+				  struct rtnl_link_stats64 *stats64);
 static int lio_vf_rep_change_mtu(struct net_device *ndev, int new_mtu);
 static int lio_vf_get_port_parent_id(struct net_device *dev,
 				     struct netdev_phys_item_id *ppid);
@@ -179,7 +179,7 @@ lio_vf_rep_tx_timeout(struct net_device *ndev, unsigned int txqueue)
 	netif_wake_queue(ndev);
 }
 
-static void
+static int
 lio_vf_rep_get_stats64(struct net_device *dev,
 		       struct rtnl_link_stats64 *stats64)
 {
@@ -193,6 +193,8 @@ lio_vf_rep_get_stats64(struct net_device *dev,
 	stats64->rx_packets = vf_rep->stats.tx_packets;
 	stats64->rx_bytes   = vf_rep->stats.tx_bytes;
 	stats64->rx_dropped = vf_rep->stats.tx_dropped;
+
+	return 0;
 }
 
 static int
diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index f3b7b443f964..567e657a86f2 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1720,8 +1720,8 @@ void nicvf_update_stats(struct nicvf *nic)
 		nicvf_update_sq_stats(nic, qidx);
 }
 
-static void nicvf_get_stats64(struct net_device *netdev,
-			      struct rtnl_link_stats64 *stats)
+static int nicvf_get_stats64(struct net_device *netdev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct nicvf *nic = netdev_priv(netdev);
 	struct nicvf_hw_stats *hw_stats = &nic->hw_stats;
@@ -1737,6 +1737,7 @@ static void nicvf_get_stats64(struct net_device *netdev,
 	stats->tx_packets = hw_stats->tx_frames;
 	stats->tx_dropped = hw_stats->tx_drops;
 
+	return 0;
 }
 
 static void nicvf_tx_timeout(struct net_device *dev, unsigned int txqueue)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 7fd264a6d085..552b08955617 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -2999,8 +2999,8 @@ int cxgb4_remove_server_filter(const struct net_device *dev, unsigned int stid,
 }
 EXPORT_SYMBOL(cxgb4_remove_server_filter);
 
-static void cxgb_get_stats(struct net_device *dev,
-			   struct rtnl_link_stats64 *ns)
+static int cxgb_get_stats(struct net_device *dev,
+			  struct rtnl_link_stats64 *ns)
 {
 	struct port_stats stats;
 	struct port_info *p = netdev_priv(dev);
@@ -3013,7 +3013,7 @@ static void cxgb_get_stats(struct net_device *dev,
 	spin_lock(&adapter->stats_lock);
 	if (!netif_device_present(dev)) {
 		spin_unlock(&adapter->stats_lock);
-		return;
+		return 0;
 	}
 	t4_get_port_stats_offset(adapter, p->tx_chan, &stats,
 				 &p->stats_base);
@@ -3047,6 +3047,8 @@ static void cxgb_get_stats(struct net_device *dev,
 	ns->tx_errors = stats.tx_error_frames;
 	ns->rx_errors = stats.rx_symbol_err + stats.rx_fcs_err +
 		ns->rx_length_errors + stats.rx_len_err + ns->rx_fifo_errors;
+
+	return 0;
 }
 
 static int cxgb_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index fb269d587b74..62191a691eb2 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -871,8 +871,8 @@ static netdev_tx_t enic_hard_start_xmit(struct sk_buff *skb,
 }
 
 /* dev_base_lock rwlock held, nominally process context */
-static void enic_get_stats(struct net_device *netdev,
-			   struct rtnl_link_stats64 *net_stats)
+static int enic_get_stats(struct net_device *netdev,
+			  struct rtnl_link_stats64 *net_stats)
 {
 	struct enic *enic = netdev_priv(netdev);
 	struct vnic_stats *stats;
@@ -884,7 +884,7 @@ static void enic_get_stats(struct net_device *netdev,
 	 * recorded stats.
 	 */
 	if (err == -ENOMEM)
-		return;
+		return 0;
 
 	net_stats->tx_packets = stats->tx.tx_frames_ok;
 	net_stats->tx_bytes = stats->tx.tx_bytes_ok;
@@ -898,6 +898,8 @@ static void enic_get_stats(struct net_device *netdev,
 	net_stats->rx_over_errors = enic->rq_truncated_pkts;
 	net_stats->rx_crc_errors = enic->rq_bad_fcs;
 	net_stats->rx_dropped = stats->rx.rx_no_bufs + stats->rx.rx_drop;
+
+	return 0;
 }
 
 static int enic_mc_sync(struct net_device *netdev, const u8 *mc_addr)
diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index 8df6f081f244..84b86dcc0420 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -1907,8 +1907,8 @@ static void gmac_clear_hw_stats(struct net_device *netdev)
 	readl(port->gmac_base + GMAC_IN_MAC2);
 }
 
-static void gmac_get_stats64(struct net_device *netdev,
-			     struct rtnl_link_stats64 *stats)
+static int gmac_get_stats64(struct net_device *netdev,
+			    struct rtnl_link_stats64 *stats)
 {
 	struct gemini_ethernet_port *port = netdev_priv(netdev);
 	unsigned int start;
@@ -1954,6 +1954,8 @@ static void gmac_get_stats64(struct net_device *netdev,
 	} while (u64_stats_fetch_retry(&port->tx_stats_syncp, start));
 
 	stats->rx_dropped += stats->rx_missed_errors;
+
+	return 0;
 }
 
 static int gmac_change_mtu(struct net_device *netdev, int new_mtu)
diff --git a/drivers/net/ethernet/ec_bhf.c b/drivers/net/ethernet/ec_bhf.c
index 46b0dbab8aad..0bff80b16c67 100644
--- a/drivers/net/ethernet/ec_bhf.c
+++ b/drivers/net/ethernet/ec_bhf.c
@@ -448,7 +448,7 @@ static int ec_bhf_stop(struct net_device *net_dev)
 	return 0;
 }
 
-static void
+static int
 ec_bhf_get_stats(struct net_device *net_dev,
 		 struct rtnl_link_stats64 *stats)
 {
@@ -463,6 +463,8 @@ ec_bhf_get_stats(struct net_device *net_dev,
 
 	stats->tx_bytes = priv->stat_tx_bytes;
 	stats->rx_bytes = priv->stat_rx_bytes;
+
+	return 0;
 }
 
 static const struct net_device_ops ec_bhf_netdev_ops = {
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index d402d83d9edd..e7a4bfcc419d 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -650,8 +650,8 @@ void be_parse_stats(struct be_adapter *adapter)
 	}
 }
 
-static void be_get_stats64(struct net_device *netdev,
-			   struct rtnl_link_stats64 *stats)
+static int be_get_stats64(struct net_device *netdev,
+			  struct rtnl_link_stats64 *stats)
 {
 	struct be_adapter *adapter = netdev_priv(netdev);
 	struct be_drv_stats *drvs = &adapter->drv_stats;
@@ -715,6 +715,8 @@ static void be_get_stats64(struct net_device *netdev,
 	stats->rx_fifo_errors = drvs->rxpp_fifo_overflow_drop +
 				drvs->rx_input_fifo_overflow_drop +
 				drvs->rx_drops_no_pbuf;
+
+	return 0;
 }
 
 void be_link_status_update(struct be_adapter *adapter, u8 link_status)
diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 4360ce4d3fb6..2028792aab26 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -350,8 +350,8 @@ static void dpaa_tx_timeout(struct net_device *net_dev, unsigned int txqueue)
 /* Calculates the statistics for the given device by adding the statistics
  * collected by each CPU.
  */
-static void dpaa_get_stats64(struct net_device *net_dev,
-			     struct rtnl_link_stats64 *s)
+static int dpaa_get_stats64(struct net_device *net_dev,
+			    struct rtnl_link_stats64 *s)
 {
 	int numstats = sizeof(struct rtnl_link_stats64) / sizeof(u64);
 	struct dpaa_priv *priv = netdev_priv(net_dev);
@@ -369,6 +369,8 @@ static void dpaa_get_stats64(struct net_device *net_dev,
 		for (j = 0; j < numstats; j++)
 			netstats[j] += cpustats[j];
 	}
+
+	return 0;
 }
 
 static int dpaa_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index fb0bcd18ec0c..688c27f209b7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -1896,8 +1896,8 @@ static int dpaa2_eth_set_addr(struct net_device *net_dev, void *addr)
 /** Fill in counters maintained by the GPP driver. These may be different from
  * the hardware counters obtained by ethtool.
  */
-static void dpaa2_eth_get_stats(struct net_device *net_dev,
-				struct rtnl_link_stats64 *stats)
+static int dpaa2_eth_get_stats(struct net_device *net_dev,
+			       struct rtnl_link_stats64 *stats)
 {
 	struct dpaa2_eth_priv *priv = netdev_priv(net_dev);
 	struct rtnl_link_stats64 *percpu_stats;
@@ -1912,6 +1912,8 @@ static void dpaa2_eth_get_stats(struct net_device *net_dev,
 		for (j = 0; j < num; j++)
 			netstats[j] += cpustats[j];
 	}
+
+	return 0;
 }
 
 /* Copy mac unicast addresses from @net_dev to @priv.
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 7302498c6df3..4a08bf37805b 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -26,7 +26,7 @@
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
-static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
+static int gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 {
 	struct gve_priv *priv = netdev_priv(dev);
 	unsigned int start;
@@ -54,6 +54,8 @@ static void gve_get_stats(struct net_device *dev, struct rtnl_link_stats64 *s)
 						       start));
 		}
 	}
+
+	return 0;
 }
 
 static int gve_alloc_counter_array(struct gve_priv *priv)
diff --git a/drivers/net/ethernet/hisilicon/hns/hns_enet.c b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
index 858cb293152a..67f704459fd8 100644
--- a/drivers/net/ethernet/hisilicon/hns/hns_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns/hns_enet.c
@@ -1876,8 +1876,8 @@ static void hns_nic_set_rx_mode(struct net_device *ndev)
 		netdev_err(ndev, "sync uc address fail\n");
 }
 
-static void hns_nic_get_stats64(struct net_device *ndev,
-				struct rtnl_link_stats64 *stats)
+static int hns_nic_get_stats64(struct net_device *ndev,
+			       struct rtnl_link_stats64 *stats)
 {
 	int idx = 0;
 	u64 tx_bytes = 0;
@@ -1919,6 +1919,8 @@ static void hns_nic_get_stats64(struct net_device *ndev,
 	stats->tx_window_errors = ndev->stats.tx_window_errors;
 	stats->rx_compressed = ndev->stats.rx_compressed;
 	stats->tx_compressed = ndev->stats.tx_compressed;
+
+	return 0;
 }
 
 static u16
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 405e49033417..43d9d207b50f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1710,8 +1710,8 @@ static netdev_features_t hns3_features_check(struct sk_buff *skb,
 	return features;
 }
 
-static void hns3_nic_get_stats64(struct net_device *netdev,
-				 struct rtnl_link_stats64 *stats)
+static int hns3_nic_get_stats64(struct net_device *netdev,
+				struct rtnl_link_stats64 *stats)
 {
 	struct hns3_nic_priv *priv = netdev_priv(netdev);
 	int queue_num = priv->ae_handle->kinfo.num_tqps;
@@ -1732,7 +1732,7 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 	u64 rx_drop = 0;
 
 	if (test_bit(HNS3_NIC_STATE_DOWN, &priv->state))
-		return;
+		return 0;
 
 	handle->ae_algo->ops->update_stats(handle, &netdev->stats);
 
@@ -1795,6 +1795,8 @@ static void hns3_nic_get_stats64(struct net_device *netdev,
 	stats->tx_window_errors = netdev->stats.tx_window_errors;
 	stats->rx_compressed = netdev->stats.rx_compressed;
 	stats->tx_compressed = netdev->stats.tx_compressed;
+
+	return 0;
 }
 
 static int hns3_setup_tc(struct net_device *netdev, void *type_data)
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 9a9b09401d01..ec30bf395a6e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -854,8 +854,8 @@ static void hinic_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 	}
 }
 
-static void hinic_get_stats64(struct net_device *netdev,
-			      struct rtnl_link_stats64 *stats)
+static int hinic_get_stats64(struct net_device *netdev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct hinic_dev *nic_dev = netdev_priv(netdev);
 	struct hinic_rxq_stats *nic_rx_stats;
@@ -878,6 +878,8 @@ static void hinic_get_stats64(struct net_device *netdev,
 	stats->tx_bytes   = nic_tx_stats->bytes;
 	stats->tx_packets = nic_tx_stats->pkts;
 	stats->tx_errors  = nic_tx_stats->tx_dropped;
+
+	return 0;
 }
 
 static int hinic_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/ibm/ehea/ehea_main.c b/drivers/net/ethernet/ibm/ehea/ehea_main.c
index c2e740475786..9297043fdf10 100644
--- a/drivers/net/ethernet/ibm/ehea/ehea_main.c
+++ b/drivers/net/ethernet/ibm/ehea/ehea_main.c
@@ -314,8 +314,8 @@ static void ehea_update_bcmc_registrations(void)
 	spin_unlock_irqrestore(&ehea_bcmc_regs.lock, flags);
 }
 
-static void ehea_get_stats64(struct net_device *dev,
-			     struct rtnl_link_stats64 *stats)
+static int ehea_get_stats64(struct net_device *dev,
+			    struct rtnl_link_stats64 *stats)
 {
 	struct ehea_port *port = netdev_priv(dev);
 	u64 rx_packets = 0, tx_packets = 0, rx_bytes = 0, tx_bytes = 0;
@@ -338,6 +338,8 @@ static void ehea_get_stats64(struct net_device *dev,
 
 	stats->multicast = port->stats.multicast;
 	stats->rx_errors = port->stats.rx_errors;
+
+	return 0;
 }
 
 static void ehea_update_stats(struct work_struct *work)
diff --git a/drivers/net/ethernet/intel/e1000e/e1000.h b/drivers/net/ethernet/intel/e1000e/e1000.h
index 5b2143f4b1f8..f30fcbaf2731 100644
--- a/drivers/net/ethernet/intel/e1000e/e1000.h
+++ b/drivers/net/ethernet/intel/e1000e/e1000.h
@@ -476,8 +476,8 @@ int e1000e_setup_rx_resources(struct e1000_ring *ring);
 int e1000e_setup_tx_resources(struct e1000_ring *ring);
 void e1000e_free_rx_resources(struct e1000_ring *ring);
 void e1000e_free_tx_resources(struct e1000_ring *ring);
-void e1000e_get_stats64(struct net_device *netdev,
-			struct rtnl_link_stats64 *stats);
+int e1000e_get_stats64(struct net_device *netdev,
+		       struct rtnl_link_stats64 *stats);
 void e1000e_set_interrupt_capability(struct e1000_adapter *adapter);
 void e1000e_reset_interrupt_capability(struct e1000_adapter *adapter);
 void e1000e_get_hw_control(struct e1000_adapter *adapter);
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e9b82c209c2d..0707d6281233 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -5992,8 +5992,8 @@ static void e1000_reset_task(struct work_struct *work)
  *
  * Returns the address of the device statistics structure.
  **/
-void e1000e_get_stats64(struct net_device *netdev,
-			struct rtnl_link_stats64 *stats)
+int e1000e_get_stats64(struct net_device *netdev,
+		       struct rtnl_link_stats64 *stats)
 {
 	struct e1000_adapter *adapter = netdev_priv(netdev);
 
@@ -6029,6 +6029,8 @@ void e1000e_get_stats64(struct net_device *netdev,
 	/* Tx Dropped needs to be maintained elsewhere */
 
 	spin_unlock(&adapter->stats64_lock);
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
index 5c19ff452558..3a2c88a20e88 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_netdev.c
@@ -1212,8 +1212,8 @@ void fm10k_reset_rx_state(struct fm10k_intfc *interface)
  * Obtain 64bit statistics in a way that is safe for both 32bit and 64bit
  * architectures.
  */
-static void fm10k_get_stats64(struct net_device *netdev,
-			      struct rtnl_link_stats64 *stats)
+static int fm10k_get_stats64(struct net_device *netdev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct fm10k_intfc *interface = netdev_priv(netdev);
 	struct fm10k_ring *ring;
@@ -1258,6 +1258,8 @@ static void fm10k_get_stats64(struct net_device *netdev,
 
 	/* following stats updated by fm10k_service_task() */
 	stats->rx_missed_errors	= netdev->stats.rx_missed_errors;
+
+	return 0;
 }
 
 int fm10k_setup_tc(struct net_device *dev, u8 tc)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index 1db482d310c2..2d84dbab312c 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -407,8 +407,8 @@ static void i40e_get_netdev_stats_struct_tx(struct i40e_ring *ring,
  * Returns the address of the device statistics structure.
  * The statistics are actually updated from the service task.
  **/
-static void i40e_get_netdev_stats_struct(struct net_device *netdev,
-				  struct rtnl_link_stats64 *stats)
+static int i40e_get_netdev_stats_struct(struct net_device *netdev,
+					struct rtnl_link_stats64 *stats)
 {
 	struct i40e_netdev_priv *np = netdev_priv(netdev);
 	struct i40e_vsi *vsi = np->vsi;
@@ -417,10 +417,10 @@ static void i40e_get_netdev_stats_struct(struct net_device *netdev,
 	int i;
 
 	if (test_bit(__I40E_VSI_DOWN, vsi->state))
-		return;
+		return 0;
 
 	if (!vsi->tx_rings)
-		return;
+		return 0;
 
 	rcu_read_lock();
 	for (i = 0; i < vsi->num_queue_pairs; i++) {
@@ -462,6 +462,8 @@ static void i40e_get_netdev_stats_struct(struct net_device *netdev,
 	stats->rx_dropped	= vsi_stats->rx_dropped;
 	stats->rx_crc_errors	= vsi_stats->rx_crc_errors;
 	stats->rx_length_errors	= vsi_stats->rx_length_errors;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index c52b9bb0e3ab..bd5acfa9bcf7 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5539,7 +5539,7 @@ void ice_update_pf_stats(struct ice_pf *pf)
  * @stats: main device statistics structure
  */
 static
-void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
+int ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct rtnl_link_stats64 *vsi_stats;
@@ -5548,7 +5548,7 @@ void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	vsi_stats = &vsi->net_stats;
 
 	if (!vsi->num_txq || !vsi->num_rxq)
-		return;
+		return 0;
 
 	/* netdev packet/byte stats come from ring counter. These are obtained
 	 * by summing up ring counters (done by ice_update_vsi_ring_stats).
@@ -5573,6 +5573,8 @@ void ice_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	stats->rx_dropped = vsi_stats->rx_dropped;
 	stats->rx_crc_errors = vsi_stats->rx_crc_errors;
 	stats->rx_length_errors = vsi_stats->rx_length_errors;
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 03f78fdb0dcd..20dd1bb8512f 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -124,8 +124,8 @@ static void igb_update_phy_info(struct timer_list *);
 static void igb_watchdog(struct timer_list *);
 static void igb_watchdog_task(struct work_struct *);
 static netdev_tx_t igb_xmit_frame(struct sk_buff *skb, struct net_device *);
-static void igb_get_stats64(struct net_device *dev,
-			    struct rtnl_link_stats64 *stats);
+static int igb_get_stats64(struct net_device *dev,
+			   struct rtnl_link_stats64 *stats);
 static int igb_change_mtu(struct net_device *, int);
 static int igb_set_mac(struct net_device *, void *);
 static void igb_set_uta(struct igb_adapter *adapter, bool set);
@@ -6479,8 +6479,8 @@ static void igb_reset_task(struct work_struct *work)
  *  @netdev: network interface device structure
  *  @stats: rtnl_link_stats64 pointer
  **/
-static void igb_get_stats64(struct net_device *netdev,
-			    struct rtnl_link_stats64 *stats)
+static int igb_get_stats64(struct net_device *netdev,
+			   struct rtnl_link_stats64 *stats)
 {
 	struct igb_adapter *adapter = netdev_priv(netdev);
 
@@ -6488,6 +6488,8 @@ static void igb_get_stats64(struct net_device *netdev,
 	igb_update_stats(adapter);
 	memcpy(stats, &adapter->stats64, sizeof(*stats));
 	spin_unlock(&adapter->stats64_lock);
+
+	return 0;
 }
 
 /**
diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index afd6a62da29d..495a614d34ae 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -3899,8 +3899,8 @@ static int igc_change_mtu(struct net_device *netdev, int new_mtu)
  * Returns the address of the device statistics structure.
  * The statistics are updated here and also from the timer callback.
  */
-static void igc_get_stats64(struct net_device *netdev,
-			    struct rtnl_link_stats64 *stats)
+static int igc_get_stats64(struct net_device *netdev,
+			   struct rtnl_link_stats64 *stats)
 {
 	struct igc_adapter *adapter = netdev_priv(netdev);
 
@@ -3909,6 +3909,8 @@ static void igc_get_stats64(struct net_device *netdev,
 		igc_update_stats(adapter);
 	memcpy(stats, &adapter->stats64, sizeof(*stats));
 	spin_unlock(&adapter->stats64_lock);
+
+	return 0;
 }
 
 static netdev_features_t igc_fix_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 393d1c2cd853..b9e7f2664af3 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8926,8 +8926,8 @@ static void ixgbe_get_ring_stats64(struct rtnl_link_stats64 *stats,
 	}
 }
 
-static void ixgbe_get_stats64(struct net_device *netdev,
-			      struct rtnl_link_stats64 *stats)
+static int ixgbe_get_stats64(struct net_device *netdev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 	int i;
@@ -8967,6 +8967,8 @@ static void ixgbe_get_stats64(struct net_device *netdev,
 	stats->rx_length_errors	= netdev->stats.rx_length_errors;
 	stats->rx_crc_errors	= netdev->stats.rx_crc_errors;
 	stats->rx_missed_errors	= netdev->stats.rx_missed_errors;
+
+	return 0;
 }
 
 #ifdef CONFIG_IXGBE_DCB
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 4061cd7db5dd..efe8b35e80b3 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4357,8 +4357,8 @@ static void ixgbevf_get_tx_ring_stats(struct rtnl_link_stats64 *stats,
 	}
 }
 
-static void ixgbevf_get_stats(struct net_device *netdev,
-			      struct rtnl_link_stats64 *stats)
+static int ixgbevf_get_stats(struct net_device *netdev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct ixgbevf_adapter *adapter = netdev_priv(netdev);
 	unsigned int start;
@@ -4392,6 +4392,8 @@ static void ixgbevf_get_stats(struct net_device *netdev,
 		ixgbevf_get_tx_ring_stats(stats, ring);
 	}
 	rcu_read_unlock();
+
+	return 0;
 }
 
 #define IXGBEVF_MAX_MAC_HDR_LEN		127
diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 3369ec717a51..5569d15eae3a 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -760,7 +760,7 @@ static void mvneta_mib_counters_clear(struct mvneta_port *pp)
 }
 
 /* Get System Network Statistics */
-static void
+static int
 mvneta_get_stats64(struct net_device *dev,
 		   struct rtnl_link_stats64 *stats)
 {
@@ -797,6 +797,8 @@ mvneta_get_stats64(struct net_device *dev,
 	}
 
 	stats->tx_dropped	= dev->stats.tx_dropped;
+
+	return 0;
 }
 
 /* Rx descriptors helper methods */
diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 4b1808acef58..67f2220a6081 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -4701,7 +4701,7 @@ static int mvpp2_check_pagepool_dma(struct mvpp2_port *port)
 	return err;
 }
 
-static void
+static int
 mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
@@ -4733,6 +4733,8 @@ mvpp2_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_errors	= dev->stats.rx_errors;
 	stats->rx_dropped	= dev->stats.rx_dropped;
 	stats->tx_dropped	= dev->stats.tx_dropped;
+
+	return 0;
 }
 
 static int mvpp2_set_ts_config(struct mvpp2_port *port, struct ifreq *ifr)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index bdfa2e293531..2f8b8c705cd6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -110,8 +110,8 @@ void otx2_get_dev_stats(struct otx2_nic *pfvf)
 			       dev_stats->tx_ucast_frames;
 }
 
-void otx2_get_stats64(struct net_device *netdev,
-		      struct rtnl_link_stats64 *stats)
+int otx2_get_stats64(struct net_device *netdev,
+		     struct rtnl_link_stats64 *stats)
 {
 	struct otx2_nic *pfvf = netdev_priv(netdev);
 	struct otx2_dev_stats *dev_stats;
@@ -127,6 +127,8 @@ void otx2_get_stats64(struct net_device *netdev,
 	stats->tx_bytes = dev_stats->tx_bytes;
 	stats->tx_packets = dev_stats->tx_frames;
 	stats->tx_dropped = dev_stats->tx_drops;
+
+	return 0;
 }
 EXPORT_SYMBOL(otx2_get_stats64);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 143ae04c8ad5..6987ef8b00eb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -665,8 +665,8 @@ void mbox_handler_nix_bp_enable(struct otx2_nic *pfvf,
 
 /* Device stats APIs */
 void otx2_get_dev_stats(struct otx2_nic *pfvf);
-void otx2_get_stats64(struct net_device *netdev,
-		      struct rtnl_link_stats64 *stats);
+int otx2_get_stats64(struct net_device *netdev,
+		     struct rtnl_link_stats64 *stats);
 void otx2_update_lmac_stats(struct otx2_nic *pfvf);
 int otx2_update_rq_stats(struct otx2_nic *pfvf, int qidx);
 int otx2_update_sq_stats(struct otx2_nic *pfvf, int qidx);
diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 25dd903a3e92..4e8ecd9623b7 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -152,8 +152,8 @@ static int prestera_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static void prestera_port_get_stats64(struct net_device *dev,
-				      struct rtnl_link_stats64 *stats)
+static int prestera_port_get_stats64(struct net_device *dev,
+				     struct rtnl_link_stats64 *stats)
 {
 	struct prestera_port *port = netdev_priv(dev);
 	struct prestera_port_stats *port_stats = &port->cached_hw_stats.stats;
@@ -180,6 +180,8 @@ static void prestera_port_get_stats64(struct net_device *dev,
 	stats->collisions = port_stats->excessive_collision;
 
 	stats->rx_crc_errors = port_stats->bad_crc;
+
+	return 0;
 }
 
 static void prestera_port_get_hw_stats(struct prestera_port *port)
diff --git a/drivers/net/ethernet/marvell/sky2.c b/drivers/net/ethernet/marvell/sky2.c
index ebe1406c6e64..1aa9b234c55a 100644
--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -3883,8 +3883,8 @@ static void sky2_set_multicast(struct net_device *dev)
 	gma_write16(hw, port, GM_RX_CTRL, reg);
 }
 
-static void sky2_get_stats(struct net_device *dev,
-			   struct rtnl_link_stats64 *stats)
+static int sky2_get_stats(struct net_device *dev,
+			  struct rtnl_link_stats64 *stats)
 {
 	struct sky2_port *sky2 = netdev_priv(dev);
 	struct sky2_hw *hw = sky2->hw;
@@ -3924,6 +3924,8 @@ static void sky2_get_stats(struct net_device *dev,
 	stats->rx_dropped = dev->stats.rx_dropped;
 	stats->rx_fifo_errors = dev->stats.rx_fifo_errors;
 	stats->tx_fifo_errors = dev->stats.tx_fifo_errors;
+
+	return 0;
 }
 
 /* Can have one global because blinking is controlled by
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index 6d2d60675ffd..301a510f41f7 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -722,8 +722,8 @@ static void mtk_stats_update(struct mtk_eth *eth)
 	}
 }
 
-static void mtk_get_stats64(struct net_device *dev,
-			    struct rtnl_link_stats64 *storage)
+static int mtk_get_stats64(struct net_device *dev,
+			   struct rtnl_link_stats64 *storage)
 {
 	struct mtk_mac *mac = netdev_priv(dev);
 	struct mtk_hw_stats *hw_stats = mac->hw_stats;
@@ -754,6 +754,8 @@ static void mtk_get_stats64(struct net_device *dev,
 	storage->tx_errors = dev->stats.tx_errors;
 	storage->rx_dropped = dev->stats.rx_dropped;
 	storage->tx_dropped = dev->stats.tx_dropped;
+
+	return 0;
 }
 
 static inline int mtk_max_frag_size(int mtu)
diff --git a/drivers/net/ethernet/mediatek/mtk_star_emac.c b/drivers/net/ethernet/mediatek/mtk_star_emac.c
index a8641a407c06..f98faf299a8a 100644
--- a/drivers/net/ethernet/mediatek/mtk_star_emac.c
+++ b/drivers/net/ethernet/mediatek/mtk_star_emac.c
@@ -1104,14 +1104,16 @@ static void mtk_star_tx_complete_all(struct mtk_star_priv *priv)
 	spin_unlock(&priv->lock);
 }
 
-static void mtk_star_netdev_get_stats64(struct net_device *ndev,
-					struct rtnl_link_stats64 *stats)
+static int mtk_star_netdev_get_stats64(struct net_device *ndev,
+				       struct rtnl_link_stats64 *stats)
 {
 	struct mtk_star_priv *priv = netdev_priv(ndev);
 
 	mtk_star_update_stats(priv);
 
 	memcpy(stats, &priv->stats, sizeof(*stats));
+
+	return 0;
 }
 
 static void mtk_star_set_rx_mode(struct net_device *ndev)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 32aad4d32b88..e4594c87d7b1 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1385,7 +1385,7 @@ static void mlx4_en_tx_timeout(struct net_device *dev, unsigned int txqueue)
 }
 
 
-static void
+static int
 mlx4_en_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mlx4_en_priv *priv = netdev_priv(dev);
@@ -1394,6 +1394,8 @@ mlx4_en_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	mlx4_en_fold_software_stats(dev);
 	netdev_stats_to_stats64(stats, &dev->stats);
 	spin_unlock_bh(&priv->stats_lock);
+
+	return 0;
 }
 
 static void mlx4_en_set_default_moderation(struct mlx4_en_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 055baf3b6cb1..bb553c79915c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -895,7 +895,7 @@ bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev);
 bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 				struct mlx5e_params *params);
 
-void mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
+int mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s);
 
 void mlx5e_init_l2_addr(struct mlx5e_priv *priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7a79d330c075..367f1f75ed10 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3677,7 +3677,7 @@ void mlx5e_fold_sw_stats64(struct mlx5e_priv *priv, struct rtnl_link_stats64 *s)
 	}
 }
 
-void
+int
 mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -3715,6 +3715,8 @@ mlx5e_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_errors = stats->rx_length_errors + stats->rx_crc_errors +
 			   stats->rx_frame_errors;
 	stats->tx_errors = stats->tx_aborted_errors + stats->tx_carrier_errors;
+
+	return 0;
 }
 
 static void mlx5e_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 989c70c1eda3..3c931b4c3fac 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -554,7 +554,7 @@ static int mlx5e_rep_get_offload_stats(int attr_id, const struct net_device *dev
 	return -EINVAL;
 }
 
-static void
+static int
 mlx5e_rep_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mlx5e_priv *priv = netdev_priv(dev);
@@ -562,6 +562,8 @@ mlx5e_rep_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	/* update HW stats in background for next time */
 	mlx5e_queue_update_stats(priv);
 	memcpy(stats, &priv->stats.vf_vport, sizeof(*stats));
+
+	return 0;
 }
 
 static int mlx5e_rep_change_mtu(struct net_device *netdev, int new_mtu)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
index 97b5fcb1f406..10922ff26fef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c
@@ -142,7 +142,7 @@ static void mlx5i_grp_sw_update_stats(struct mlx5e_priv *priv)
 	memcpy(&priv->stats.sw, &s, sizeof(s));
 }
 
-void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
+int mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct mlx5e_priv     *priv   = mlx5i_epriv(dev);
 	struct mlx5e_sw_stats *sstats = &priv->stats.sw;
@@ -154,6 +154,8 @@ void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->tx_packets = sstats->tx_packets;
 	stats->tx_bytes   = sstats->tx_bytes;
 	stats->tx_dropped = sstats->tx_queue_dropped;
+
+	return 0;
 }
 
 int mlx5i_init_underlay_qp(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
index b79dc1e28c41..01dfeb6d29ab 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h
@@ -118,7 +118,7 @@ struct mlx5i_tx_wqe {
 
 void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		   struct mlx5_av *av, u32 dqpn, u32 dqkey, bool xmit_more);
-void mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
+int mlx5i_get_stats(struct net_device *dev, struct rtnl_link_stats64 *stats);
 
 #endif /* CONFIG_MLX5_CORE_IPOIB */
 #endif /* __MLX5E_IPOB_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 1650d9852b5b..4f2fdfd395c3 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -834,13 +834,15 @@ static void update_stats_cache(struct work_struct *work)
 /* Return the stats from a cache that is updated periodically,
  * as this function might get called in an atomic context.
  */
-static void
+static int
 mlxsw_sp_port_get_stats64(struct net_device *dev,
 			  struct rtnl_link_stats64 *stats)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 
 	memcpy(stats, &mlxsw_sp_port->periodic_hw_stats.stats, sizeof(*stats));
+
+	return 0;
 }
 
 static int __mlxsw_sp_port_vlan_set(struct mlxsw_sp_port *mlxsw_sp_port,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 40e2e79d4517..c115755d82e9 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -346,7 +346,7 @@ static int mlxsw_sx_port_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static void
+static int
 mlxsw_sx_port_get_stats64(struct net_device *dev,
 			  struct rtnl_link_stats64 *stats)
 {
@@ -375,6 +375,8 @@ mlxsw_sx_port_get_stats64(struct net_device *dev,
 		tx_dropped	+= p->tx_dropped;
 	}
 	stats->tx_dropped	= tx_dropped;
+
+	return 0;
 }
 
 static struct devlink_port *
diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 3804310c853a..2cc7593f6a51 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -2605,8 +2605,8 @@ static int lan743x_netdev_change_mtu(struct net_device *netdev, int new_mtu)
 	return ret;
 }
 
-static void lan743x_netdev_get_stats64(struct net_device *netdev,
-				       struct rtnl_link_stats64 *stats)
+static int lan743x_netdev_get_stats64(struct net_device *netdev,
+				      struct rtnl_link_stats64 *stats)
 {
 	struct lan743x_adapter *adapter = netdev_priv(netdev);
 
@@ -2650,6 +2650,8 @@ static void lan743x_netdev_get_stats64(struct net_device *netdev,
 					     STAT_TX_MULTIPLE_COLLISIONS) +
 			    lan743x_csr_read(adapter,
 					     STAT_TX_LATE_COLLISIONS);
+
+	return 0;
 }
 
 static int lan743x_netdev_set_mac_address(struct net_device *netdev,
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 2bd2840d88bd..e4b44c57cddc 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -556,8 +556,8 @@ static int ocelot_port_set_mac_address(struct net_device *dev, void *p)
 	return 0;
 }
 
-static void ocelot_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *stats)
+static int ocelot_get_stats64(struct net_device *dev,
+			      struct rtnl_link_stats64 *stats)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot *ocelot = priv->port.ocelot;
@@ -593,6 +593,8 @@ static void ocelot_get_stats64(struct net_device *dev,
 	stats->tx_dropped = ocelot_read(ocelot, SYS_COUNT_TX_DROPS) +
 			    ocelot_read(ocelot, SYS_COUNT_TX_AGING);
 	stats->collisions = ocelot_read(ocelot, SYS_COUNT_TX_COLLISION);
+
+	return 0;
 }
 
 static int ocelot_port_fdb_add(struct ndmsg *ndm, struct nlattr *tb[],
diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 1634ca6d4a8f..67c9c10f68f1 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -362,8 +362,8 @@ static inline void put_be32(__be32 val, __be32 __iomem * p)
 	__raw_writel((__force __u32) val, (__force void __iomem *)p);
 }
 
-static void myri10ge_get_stats(struct net_device *dev,
-			       struct rtnl_link_stats64 *stats);
+static int myri10ge_get_stats(struct net_device *dev,
+			      struct rtnl_link_stats64 *stats);
 
 static void set_fw_name(struct myri10ge_priv *mgp, char *name, bool allocated)
 {
@@ -1790,7 +1790,7 @@ myri10ge_get_ethtool_stats(struct net_device *netdev,
 
 	/* force stats update */
 	memset(&link_stats, 0, sizeof(link_stats));
-	(void)myri10ge_get_stats(netdev, &link_stats);
+	myri10ge_get_stats(netdev, &link_stats);
 	for (i = 0; i < MYRI10GE_NET_STATS_LEN; i++)
 		data[i] = ((u64 *)&link_stats)[i];
 
@@ -2914,8 +2914,8 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static void myri10ge_get_stats(struct net_device *dev,
-			       struct rtnl_link_stats64 *stats)
+static int myri10ge_get_stats(struct net_device *dev,
+			      struct rtnl_link_stats64 *stats)
 {
 	const struct myri10ge_priv *mgp = netdev_priv(dev);
 	const struct myri10ge_slice_netstats *slice_stats;
@@ -2930,6 +2930,8 @@ static void myri10ge_get_stats(struct net_device *dev,
 		stats->rx_dropped += slice_stats->rx_dropped;
 		stats->tx_dropped += slice_stats->tx_dropped;
 	}
+
+	return 0;
 }
 
 static void myri10ge_set_multicast_list(struct net_device *dev)
diff --git a/drivers/net/ethernet/neterion/vxge/vxge-main.c b/drivers/net/ethernet/neterion/vxge/vxge-main.c
index 87892bd992b1..ce1a98cd3783 100644
--- a/drivers/net/ethernet/neterion/vxge/vxge-main.c
+++ b/drivers/net/ethernet/neterion/vxge/vxge-main.c
@@ -3100,7 +3100,7 @@ static int vxge_change_mtu(struct net_device *dev, int new_mtu)
  * @net_stats: pointer to struct rtnl_link_stats64
  *
  */
-static void
+static int
 vxge_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *net_stats)
 {
 	struct vxgedev *vdev = netdev_priv(dev);
@@ -3139,6 +3139,8 @@ vxge_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *net_stats)
 		net_stats->tx_bytes += bytes;
 		net_stats->tx_errors += txstats->tx_errors;
 	}
+
+	return 0;
 }
 
 static enum vxge_hw_status vxge_timestamp_config(struct __vxge_hw_device *devh)
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
index f21fb573ea3e..2a02a9ae27bb 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_common.c
@@ -3360,8 +3360,8 @@ nfp_net_vlan_rx_kill_vid(struct net_device *netdev, __be16 proto, u16 vid)
 	return nfp_net_mbox_reconfig_and_unlock(nn, cmd);
 }
 
-static void nfp_net_stat64(struct net_device *netdev,
-			   struct rtnl_link_stats64 *stats)
+static int nfp_net_stat64(struct net_device *netdev,
+			  struct rtnl_link_stats64 *stats)
 {
 	struct nfp_net *nn = netdev_priv(netdev);
 	int r;
@@ -3400,6 +3400,8 @@ static void nfp_net_stat64(struct net_device *netdev,
 
 	stats->tx_dropped += nn_readq(nn, NFP_NET_CFG_STATS_TX_DISCARDS);
 	stats->tx_errors += nn_readq(nn, NFP_NET_CFG_STATS_TX_ERRORS);
+
+	return 0;
 }
 
 static int nfp_net_set_features(struct net_device *netdev,
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
index b3cabc274121..fc2569c50d46 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_repr.c
@@ -86,13 +86,13 @@ nfp_repr_vnic_get_stats64(struct nfp_port *port,
 	stats->rx_dropped = readq(port->vnic + NFP_NET_CFG_STATS_TX_DISCARDS);
 }
 
-static void
+static int
 nfp_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 {
 	struct nfp_repr *repr = netdev_priv(netdev);
 
 	if (WARN_ON(!repr->port))
-		return;
+		return 0;
 
 	switch (repr->port->type) {
 	case NFP_PORT_PHYS_PORT:
@@ -106,6 +106,8 @@ nfp_repr_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 	default:
 		break;
 	}
+
+	return 0;
 }
 
 static bool
diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
index 8724d6a9ed02..c2057cc6df9c 100644
--- a/drivers/net/ethernet/nvidia/forcedeth.c
+++ b/drivers/net/ethernet/nvidia/forcedeth.c
@@ -1764,7 +1764,7 @@ static void nv_get_stats(int cpu, struct fe_priv *np,
  * Called with read_lock(&dev_base_lock) held for read -
  * only synchronized against unregister_netdevice.
  */
-static void
+static int
 nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
 	__acquires(&netdev_priv(dev)->hwstats_lock)
 	__releases(&netdev_priv(dev)->hwstats_lock)
@@ -1812,6 +1812,8 @@ nv_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *storage)
 
 		spin_unlock_bh(&np->hwstats_lock);
 	}
+
+	return 0;
 }
 
 /*
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.c b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
index 11140915c2da..0c952604dedf 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.c
@@ -904,8 +904,8 @@ static int ionic_adminq_napi(struct napi_struct *napi, int budget)
 	return work_done;
 }
 
-void ionic_get_stats64(struct net_device *netdev,
-		       struct rtnl_link_stats64 *ns)
+int ionic_get_stats64(struct net_device *netdev,
+		      struct rtnl_link_stats64 *ns)
 {
 	struct ionic_lif *lif = netdev_priv(netdev);
 	struct ionic_lif_stats *ls;
@@ -955,6 +955,8 @@ void ionic_get_stats64(struct net_device *netdev,
 			ns->rx_missed_errors;
 
 	ns->tx_errors = ns->tx_aborted_errors;
+
+	return 0;
 }
 
 static int ionic_lif_addr_add(struct ionic_lif *lif, const u8 *addr)
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 9bed42719ae5..0e8c56696924 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -252,8 +252,8 @@ static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
 
 void ionic_link_status_check_request(struct ionic_lif *lif, bool can_sleep);
-void ionic_get_stats64(struct net_device *netdev,
-		       struct rtnl_link_stats64 *ns);
+int ionic_get_stats64(struct net_device *netdev,
+		      struct rtnl_link_stats64 *ns);
 void ionic_lif_deferred_enqueue(struct ionic_deferred *def,
 				struct ionic_deferred_work *work);
 int ionic_lif_alloc(struct ionic *ionic);
diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
index f21847739ef1..4ce1d74ac1d8 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_main.c
@@ -71,8 +71,8 @@ static irqreturn_t netxen_msix_intr(int irq, void *data);
 
 static void netxen_free_ip_list(struct netxen_adapter *, bool);
 static void netxen_restore_indev_addr(struct net_device *dev, unsigned long);
-static void netxen_nic_get_stats(struct net_device *dev,
-				 struct rtnl_link_stats64 *stats);
+static int netxen_nic_get_stats(struct net_device *dev,
+				struct rtnl_link_stats64 *stats);
 static int netxen_nic_set_mac(struct net_device *netdev, void *p);
 
 /*  PCI Device ID Table  */
@@ -2269,8 +2269,8 @@ static void netxen_tx_timeout_task(struct work_struct *work)
 	clear_bit(__NX_RESETTING, &adapter->state);
 }
 
-static void netxen_nic_get_stats(struct net_device *netdev,
-				 struct rtnl_link_stats64 *stats)
+static int netxen_nic_get_stats(struct net_device *netdev,
+				struct rtnl_link_stats64 *stats)
 {
 	struct netxen_adapter *adapter = netdev_priv(netdev);
 
@@ -2280,6 +2280,8 @@ static void netxen_nic_get_stats(struct net_device *netdev,
 	stats->tx_bytes = adapter->stats.txbytes;
 	stats->rx_dropped = adapter->stats.rxdropped;
 	stats->tx_dropped = adapter->stats.txdropped;
+
+	return 0;
 }
 
 static irqreturn_t netxen_intr(int irq, void *data)
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index 9cf960a6d007..05ec55efd5ac 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -412,8 +412,8 @@ void qede_fill_by_demand_stats(struct qede_dev *edev)
 	}
 }
 
-static void qede_get_stats64(struct net_device *dev,
-			     struct rtnl_link_stats64 *stats)
+static int qede_get_stats64(struct net_device *dev,
+			    struct rtnl_link_stats64 *stats)
 {
 	struct qede_dev *edev = netdev_priv(dev);
 	struct qede_stats_common *p_common;
@@ -440,6 +440,8 @@ static void qede_get_stats64(struct net_device *dev,
 		stats->collisions = edev->stats.bb.tx_total_collisions;
 	stats->rx_crc_errors = p_common->rx_crc_errors;
 	stats->rx_frame_errors = p_common->rx_align_errors;
+
+	return 0;
 }
 
 #ifdef CONFIG_QED_SRIOV
diff --git a/drivers/net/ethernet/qualcomm/emac/emac.c b/drivers/net/ethernet/qualcomm/emac/emac.c
index 8543bf3c3484..a48d3f3e7882 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac.c
@@ -332,8 +332,8 @@ void emac_update_hw_stats(struct emac_adapter *adpt)
 }
 
 /* Provide network statistics info for the interface */
-static void emac_get_stats64(struct net_device *netdev,
-			     struct rtnl_link_stats64 *net_stats)
+static int emac_get_stats64(struct net_device *netdev,
+			    struct rtnl_link_stats64 *net_stats)
 {
 	struct emac_adapter *adpt = netdev_priv(netdev);
 	struct emac_stats *stats = &adpt->stats;
@@ -368,6 +368,8 @@ static void emac_get_stats64(struct net_device *netdev,
 	net_stats->tx_window_errors = stats->tx_late_col;
 
 	spin_unlock(&stats->lock);
+
+	return 0;
 }
 
 static const struct net_device_ops emac_netdev_ops = {
diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
index 41fbd2ceeede..aca3e50de06c 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
@@ -122,8 +122,8 @@ static void rmnet_vnd_uninit(struct net_device *dev)
 	free_percpu(priv->pcpu_stats);
 }
 
-static void rmnet_get_stats64(struct net_device *dev,
-			      struct rtnl_link_stats64 *s)
+static int rmnet_get_stats64(struct net_device *dev,
+			     struct rtnl_link_stats64 *s)
 {
 	struct rmnet_priv *priv = netdev_priv(dev);
 	struct rmnet_vnd_stats total_stats;
@@ -151,6 +151,8 @@ static void rmnet_get_stats64(struct net_device *dev,
 	s->tx_packets = total_stats.tx_pkts;
 	s->tx_bytes = total_stats.tx_bytes;
 	s->tx_dropped = total_stats.tx_drops;
+
+	return 0;
 }
 
 static const struct net_device_ops rmnet_vnd_ops = {
@@ -354,4 +356,4 @@ int rmnet_vnd_update_dev_mtu(struct rmnet_port *port,
 	}
 
 	return 0;
-}
\ No newline at end of file
+}
diff --git a/drivers/net/ethernet/realtek/8139too.c b/drivers/net/ethernet/realtek/8139too.c
index 1e5a453dea14..a654f7f6fb8d 100644
--- a/drivers/net/ethernet/realtek/8139too.c
+++ b/drivers/net/ethernet/realtek/8139too.c
@@ -654,8 +654,8 @@ static int rtl8139_poll(struct napi_struct *napi, int budget);
 static irqreturn_t rtl8139_interrupt (int irq, void *dev_instance);
 static int rtl8139_close (struct net_device *dev);
 static int netdev_ioctl (struct net_device *dev, struct ifreq *rq, int cmd);
-static void rtl8139_get_stats64(struct net_device *dev,
-				struct rtnl_link_stats64 *stats);
+static int rtl8139_get_stats64(struct net_device *dev,
+			       struct rtnl_link_stats64 *stats);
 static void rtl8139_set_rx_mode (struct net_device *dev);
 static void __set_rx_mode (struct net_device *dev);
 static void rtl8139_hw_start (struct net_device *dev);
@@ -2513,7 +2513,7 @@ static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 }
 
 
-static void
+static int
 rtl8139_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct rtl8139_private *tp = netdev_priv(dev);
@@ -2541,6 +2541,8 @@ rtl8139_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_packets = tp->tx_stats.packets;
 		stats->tx_bytes = tp->tx_stats.bytes;
 	} while (u64_stats_fetch_retry_irq(&tp->tx_stats.syncp, start));
+
+	return 0;
 }
 
 /* Set or clear the multicast filter for this adaptor.
diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index a569abe7f5ef..d9d93800aea7 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4733,7 +4733,7 @@ static int rtl_open(struct net_device *dev)
 	goto out;
 }
 
-static void
+static int
 rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
@@ -4766,6 +4766,8 @@ rtl8169_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		le16_to_cpu(tp->tc_offset.rx_missed);
 
 	pm_runtime_put_noidle(&pdev->dev);
+
+	return 0;
 }
 
 static void rtl8169_net_suspend(struct rtl8169_private *tp)
diff --git a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
index 971f1e54b652..a69d4df60ee3 100644
--- a/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
+++ b/drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c
@@ -1708,8 +1708,8 @@ static inline u64 sxgbe_get_stat64(void __iomem *ioaddr, int reg_lo, int reg_hi)
  *  executed to see device statistics. Statistics are number of
  *  bytes sent or received, errors occurred etc.
  */
-static void sxgbe_get_stats64(struct net_device *dev,
-			      struct rtnl_link_stats64 *stats)
+static int sxgbe_get_stats64(struct net_device *dev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct sxgbe_priv_data *priv = netdev_priv(dev);
 	void __iomem *ioaddr = priv->ioaddr;
@@ -1760,6 +1760,8 @@ static void sxgbe_get_stats64(struct net_device *dev,
 						 SXGBE_MMC_TXUFLWHI_GBCNT_REG);
 	writel(0, ioaddr + SXGBE_MMC_CTL_REG);
 	spin_unlock(&priv->stats_lock);
+
+	return 0;
 }
 
 /*  sxgbe_set_features - entry point to set offload features of the device.
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a9..e76f5f961f61 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -597,13 +597,15 @@ void efx_stop_all(struct efx_nic *efx)
 }
 
 /* Context: process, dev_base_lock or RTNL held, non-blocking. */
-void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
+int efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats)
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	spin_lock_bh(&efx->stats_lock);
 	efx_nic_update_stats_atomic(efx, NULL, stats);
 	spin_unlock_bh(&efx->stats_lock);
+
+	return 0;
 }
 
 /* Push loopback/power/transmit disable settings to the PHY, and reconfigure
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c..96282cbebe3e 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -31,7 +31,7 @@ void efx_link_set_wanted_fc(struct efx_nic *efx, u8);
 void efx_start_all(struct efx_nic *efx);
 void efx_stop_all(struct efx_nic *efx);
 
-void efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats);
+int efx_net_stats(struct net_device *net_dev, struct rtnl_link_stats64 *stats);
 
 int efx_create_reset_workqueue(void);
 void efx_queue_reset_work(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/falcon/efx.c b/drivers/net/ethernet/sfc/falcon/efx.c
index f8979991970e..78846737441c 100644
--- a/drivers/net/ethernet/sfc/falcon/efx.c
+++ b/drivers/net/ethernet/sfc/falcon/efx.c
@@ -2097,14 +2097,16 @@ int ef4_net_stop(struct net_device *net_dev)
 }
 
 /* Context: process, dev_base_lock or RTNL held, non-blocking. */
-static void ef4_net_stats(struct net_device *net_dev,
-			  struct rtnl_link_stats64 *stats)
+static int ef4_net_stats(struct net_device *net_dev,
+			 struct rtnl_link_stats64 *stats)
 {
 	struct ef4_nic *efx = netdev_priv(net_dev);
 
 	spin_lock_bh(&efx->stats_lock);
 	efx->type->update_stats(efx, NULL, stats);
 	spin_unlock_bh(&efx->stats_lock);
+
+	return 0;
 }
 
 /* Context: netif_tx_lock held, BHs disabled. */
diff --git a/drivers/net/ethernet/socionext/sni_ave.c b/drivers/net/ethernet/socionext/sni_ave.c
index 501b9c7aba56..a62793cf2be5 100644
--- a/drivers/net/ethernet/socionext/sni_ave.c
+++ b/drivers/net/ethernet/socionext/sni_ave.c
@@ -1499,8 +1499,8 @@ static void ave_set_rx_mode(struct net_device *ndev)
 	}
 }
 
-static void ave_get_stats64(struct net_device *ndev,
-			    struct rtnl_link_stats64 *stats)
+static int ave_get_stats64(struct net_device *ndev,
+			   struct rtnl_link_stats64 *stats)
 {
 	struct ave_private *priv = netdev_priv(ndev);
 	unsigned int start;
@@ -1523,6 +1523,8 @@ static void ave_get_stats64(struct net_device *ndev,
 	stats->tx_dropped     = priv->stats_tx.dropped;
 	stats->rx_fifo_errors = priv->stats_rx.fifo_errors;
 	stats->collisions     = priv->stats_tx.collisions;
+
+	return 0;
 }
 
 static int ave_set_mac_address(struct net_device *ndev, void *p)
diff --git a/drivers/net/ethernet/sun/niu.c b/drivers/net/ethernet/sun/niu.c
index 68695d4afacd..aa5da0951020 100644
--- a/drivers/net/ethernet/sun/niu.c
+++ b/drivers/net/ethernet/sun/niu.c
@@ -6274,8 +6274,8 @@ static void niu_get_tx_stats(struct niu *np,
 	stats->tx_errors = errors;
 }
 
-static void niu_get_stats(struct net_device *dev,
-			  struct rtnl_link_stats64 *stats)
+static int niu_get_stats(struct net_device *dev,
+			 struct rtnl_link_stats64 *stats)
 {
 	struct niu *np = netdev_priv(dev);
 
@@ -6283,6 +6283,8 @@ static void niu_get_stats(struct net_device *dev,
 		niu_get_rx_stats(np, stats);
 		niu_get_tx_stats(np, stats);
 	}
+
+	return 0;
 }
 
 static void niu_load_hash_xmac(struct niu *np, u16 *hash)
diff --git a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
index 26aa7f32151f..1381a4d6bcc9 100644
--- a/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
+++ b/drivers/net/ethernet/synopsys/dwc-xlgmac-net.c
@@ -764,8 +764,8 @@ static netdev_tx_t xlgmac_xmit(struct sk_buff *skb, struct net_device *netdev)
 	return NETDEV_TX_OK;
 }
 
-static void xlgmac_get_stats64(struct net_device *netdev,
-			       struct rtnl_link_stats64 *s)
+static int xlgmac_get_stats64(struct net_device *netdev,
+			      struct rtnl_link_stats64 *s)
 {
 	struct xlgmac_pdata *pdata = netdev_priv(netdev);
 	struct xlgmac_stats *pstats = &pdata->stats;
@@ -787,6 +787,8 @@ static void xlgmac_get_stats64(struct net_device *netdev,
 	s->tx_bytes = pstats->txoctetcount_gb;
 	s->tx_errors = pstats->txframecount_gb - pstats->txframecount_g;
 	s->tx_dropped = netdev->stats.tx_dropped;
+
+	return 0;
 }
 
 static int xlgmac_set_mac_address(struct net_device *netdev, void *addr)
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 766e8866bbef..e2766299f720 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1407,8 +1407,8 @@ static int am65_cpsw_nuss_ndo_slave_ioctl(struct net_device *ndev,
 	return phy_mii_ioctl(port->slave.phy, req, cmd);
 }
 
-static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
-					 struct rtnl_link_stats64 *stats)
+static int am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
+					struct rtnl_link_stats64 *stats)
 {
 	struct am65_cpsw_ndev_priv *ndev_priv = netdev_priv(dev);
 	unsigned int start;
@@ -1439,6 +1439,8 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->rx_errors	= dev->stats.rx_errors;
 	stats->rx_dropped	= dev->stats.rx_dropped;
 	stats->tx_dropped	= dev->stats.tx_dropped;
+
+	return 0;
 }
 
 static const struct net_device_ops am65_cpsw_nuss_netdev_ops = {
diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
index d7a144b4a09f..2b6a6d027410 100644
--- a/drivers/net/ethernet/ti/netcp_core.c
+++ b/drivers/net/ethernet/ti/netcp_core.c
@@ -1908,7 +1908,7 @@ static int netcp_setup_tc(struct net_device *dev, enum tc_setup_type type,
 	return 0;
 }
 
-static void
+static int
 netcp_get_stats(struct net_device *ndev, struct rtnl_link_stats64 *stats)
 {
 	struct netcp_intf *netcp = netdev_priv(ndev);
@@ -1937,6 +1937,8 @@ netcp_get_stats(struct net_device *ndev, struct rtnl_link_stats64 *stats)
 	stats->rx_errors = p->rx_errors;
 	stats->rx_dropped = p->rx_dropped;
 	stats->tx_dropped = p->tx_dropped;
+
+	return 0;
 }
 
 static const struct net_device_ops netcp_netdev_ops = {
diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 73ca597ebd1b..c4acb823cdad 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -507,8 +507,8 @@ static irqreturn_t rhine_interrupt(int irq, void *dev_instance);
 static void rhine_tx(struct net_device *dev);
 static int rhine_rx(struct net_device *dev, int limit);
 static void rhine_set_rx_mode(struct net_device *dev);
-static void rhine_get_stats64(struct net_device *dev,
-			      struct rtnl_link_stats64 *stats);
+static int rhine_get_stats64(struct net_device *dev,
+			     struct rtnl_link_stats64 *stats);
 static int netdev_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
 static const struct ethtool_ops netdev_ethtool_ops;
 static int  rhine_close(struct net_device *dev);
@@ -2207,7 +2207,7 @@ static void rhine_slow_event_task(struct work_struct *work)
 	mutex_unlock(&rp->task_lock);
 }
 
-static void
+static int
 rhine_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct rhine_private *rp = netdev_priv(dev);
@@ -2230,6 +2230,8 @@ rhine_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_packets = rp->tx_stats.packets;
 		stats->tx_bytes = rp->tx_stats.bytes;
 	} while (u64_stats_fetch_retry_irq(&rp->tx_stats.syncp, start));
+
+	return 0;
 }
 
 static void rhine_set_rx_mode(struct net_device *dev)
diff --git a/drivers/net/fjes/fjes_main.c b/drivers/net/fjes/fjes_main.c
index 466622664424..df333411f40a 100644
--- a/drivers/net/fjes/fjes_main.c
+++ b/drivers/net/fjes/fjes_main.c
@@ -44,7 +44,7 @@ static void fjes_raise_intr_rxdata_task(struct work_struct *);
 static void fjes_tx_stall_task(struct work_struct *);
 static void fjes_force_close_task(struct work_struct *);
 static irqreturn_t fjes_intr(int, void*);
-static void fjes_get_stats64(struct net_device *, struct rtnl_link_stats64 *);
+static int fjes_get_stats64(struct net_device *, struct rtnl_link_stats64 *);
 static int fjes_change_mtu(struct net_device *, int);
 static int fjes_vlan_rx_add_vid(struct net_device *, __be16 proto, u16);
 static int fjes_vlan_rx_kill_vid(struct net_device *, __be16 proto, u16);
@@ -802,12 +802,14 @@ static void fjes_tx_retry(struct net_device *netdev, unsigned int txqueue)
 	netif_tx_wake_queue(queue);
 }
 
-static void
+static int
 fjes_get_stats64(struct net_device *netdev, struct rtnl_link_stats64 *stats)
 {
 	struct fjes_adapter *adapter = netdev_priv(netdev);
 
 	memcpy(stats, &adapter->stats64, sizeof(struct rtnl_link_stats64));
+
+	return 0;
 }
 
 static int fjes_change_mtu(struct net_device *netdev, int new_mtu)
diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
index f32f28311d57..0af96b314671 100644
--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -1357,8 +1357,8 @@ static void netvsc_get_pcpu_stats(struct net_device *net,
 	}
 }
 
-static void netvsc_get_stats64(struct net_device *net,
-			       struct rtnl_link_stats64 *t)
+static int netvsc_get_stats64(struct net_device *net,
+			      struct rtnl_link_stats64 *t)
 {
 	struct net_device_context *ndev_ctx = netdev_priv(net);
 	struct netvsc_device *nvdev;
@@ -1410,6 +1410,8 @@ static void netvsc_get_stats64(struct net_device *net,
 	}
 out:
 	rcu_read_unlock();
+
+	return 0;
 }
 
 static int netvsc_set_mac_addr(struct net_device *ndev, void *p)
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index fa63d4dee0ba..de402f5045ef 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -123,8 +123,7 @@ static void ifb_ri_tasklet(unsigned long _txp)
 
 }
 
-static void ifb_stats64(struct net_device *dev,
-			struct rtnl_link_stats64 *stats)
+static int ifb_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct ifb_dev_private *dp = netdev_priv(dev);
 	struct ifb_q_private *txp = dp->tx_private;
@@ -151,6 +150,8 @@ static void ifb_stats64(struct net_device *dev,
 	}
 	stats->rx_dropped = dev->stats.rx_dropped;
 	stats->tx_dropped = dev->stats.tx_dropped;
+
+	return 0;
 }
 
 static int ifb_dev_init(struct net_device *dev)
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index a707502a0c0f..7c4d88579f46 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -286,8 +286,8 @@ static void ipvlan_set_multicast_mac_filter(struct net_device *dev)
 	dev_mc_sync(ipvlan->phy_dev, dev);
 }
 
-static void ipvlan_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *s)
+static int ipvlan_get_stats64(struct net_device *dev,
+			      struct rtnl_link_stats64 *s)
 {
 	struct ipvl_dev *ipvlan = netdev_priv(dev);
 
@@ -324,6 +324,8 @@ static void ipvlan_get_stats64(struct net_device *dev,
 		s->rx_dropped = rx_errs;
 		s->tx_dropped = tx_drps;
 	}
+
+	return 0;
 }
 
 static int ipvlan_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..3d76829161a6 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -115,8 +115,8 @@ void dev_lstats_read(struct net_device *dev, u64 *packets, u64 *bytes)
 }
 EXPORT_SYMBOL(dev_lstats_read);
 
-static void loopback_get_stats64(struct net_device *dev,
-				 struct rtnl_link_stats64 *stats)
+static int loopback_get_stats64(struct net_device *dev,
+				struct rtnl_link_stats64 *stats)
 {
 	u64 packets, bytes;
 
@@ -126,6 +126,8 @@ static void loopback_get_stats64(struct net_device *dev,
 	stats->tx_packets = packets;
 	stats->rx_bytes   = bytes;
 	stats->tx_bytes   = bytes;
+
+	return 0;
 }
 
 static u32 always_on(struct net_device *dev)
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 92425e1fd70c..ef05c5cf3abc 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3645,16 +3645,18 @@ static int macsec_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static void macsec_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *s)
+static int macsec_get_stats64(struct net_device *dev,
+			      struct rtnl_link_stats64 *s)
 {
 	if (!dev->tstats)
-		return;
+		return 0;
 
 	dev_fetch_sw_netstats(s, dev->tstats);
 
 	s->rx_dropped = dev->stats.rx_dropped;
 	s->tx_dropped = dev->stats.tx_dropped;
+
+	return 0;
 }
 
 static int macsec_get_iflink(const struct net_device *dev)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9a9a5cf36a4b..bdcf38564320 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -927,8 +927,8 @@ static void macvlan_uninit(struct net_device *dev)
 		macvlan_port_destroy(port->dev);
 }
 
-static void macvlan_dev_get_stats64(struct net_device *dev,
-				    struct rtnl_link_stats64 *stats)
+static int macvlan_dev_get_stats64(struct net_device *dev,
+				   struct rtnl_link_stats64 *stats)
 {
 	struct macvlan_dev *vlan = netdev_priv(dev);
 
@@ -965,6 +965,8 @@ static void macvlan_dev_get_stats64(struct net_device *dev,
 		stats->rx_dropped	= rx_errors;
 		stats->tx_dropped	= tx_dropped;
 	}
+
+	return 0;
 }
 
 static int macvlan_vlan_rx_add_vid(struct net_device *dev,
diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 5f3a4cc92a88..57454b505cce 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -89,8 +89,8 @@ static int mhi_ndo_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return NETDEV_TX_OK;
 }
 
-static void mhi_ndo_get_stats64(struct net_device *ndev,
-				struct rtnl_link_stats64 *stats)
+static int mhi_ndo_get_stats64(struct net_device *ndev,
+			       struct rtnl_link_stats64 *stats)
 {
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
 	unsigned int start;
@@ -110,6 +110,8 @@ static void mhi_ndo_get_stats64(struct net_device *ndev,
 		stats->tx_errors = u64_stats_read(&mhi_netdev->stats.tx_errors);
 		stats->tx_dropped = u64_stats_read(&mhi_netdev->stats.tx_dropped);
 	} while (u64_stats_fetch_retry_irq(&mhi_netdev->stats.tx_syncp, start));
+
+	return 0;
 }
 
 static const struct net_device_ops mhi_netdev_ops = {
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 4f83165412bd..e032ad1c5e22 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -179,8 +179,8 @@ static void net_failover_fold_stats(struct rtnl_link_stats64 *_res,
 	}
 }
 
-static void net_failover_get_stats(struct net_device *dev,
-				   struct rtnl_link_stats64 *stats)
+static int net_failover_get_stats(struct net_device *dev,
+				  struct rtnl_link_stats64 *stats)
 {
 	struct net_failover_info *nfo_info = netdev_priv(dev);
 	struct rtnl_link_stats64 temp;
@@ -209,6 +209,8 @@ static void net_failover_get_stats(struct net_device *dev,
 
 	memcpy(&nfo_info->failover_stats, stats, sizeof(*stats));
 	spin_unlock(&nfo_info->stats_lock);
+
+	return 0;
 }
 
 static int net_failover_change_mtu(struct net_device *dev, int new_mtu)
diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
index 7178468302c8..6c7875a823d9 100644
--- a/drivers/net/netdevsim/netdev.c
+++ b/drivers/net/netdevsim/netdev.c
@@ -60,7 +60,7 @@ static int nsim_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
-static void
+static int
 nsim_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct netdevsim *ns = netdev_priv(dev);
@@ -71,6 +71,8 @@ nsim_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_bytes = ns->tx_bytes;
 		stats->tx_packets = ns->tx_packets;
 	} while (u64_stats_fetch_retry(&ns->syncp, start));
+
+	return 0;
 }
 
 static int
diff --git a/drivers/net/nlmon.c b/drivers/net/nlmon.c
index 5e19a6839dea..ac405cab8b2d 100644
--- a/drivers/net/nlmon.c
+++ b/drivers/net/nlmon.c
@@ -48,7 +48,7 @@ static int nlmon_close(struct net_device *dev)
 	return netlink_remove_tap(&nlmon->nt);
 }
 
-static void
+static int
 nlmon_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	u64 packets, bytes;
@@ -60,6 +60,8 @@ nlmon_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 	stats->rx_bytes = bytes;
 	stats->tx_bytes = 0;
+
+	return 0;
 }
 
 static u32 always_on(struct net_device *dev)
diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index 09c27f7773f9..fe6c6b62b0f6 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1488,7 +1488,7 @@ ppp_net_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	return err;
 }
 
-static void
+static int
 ppp_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats64)
 {
 	struct ppp *ppp = netdev_priv(dev);
@@ -1508,6 +1508,8 @@ ppp_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats64)
 	stats64->rx_dropped       = dev->stats.rx_dropped;
 	stats64->tx_dropped       = dev->stats.tx_dropped;
 	stats64->rx_length_errors = dev->stats.rx_length_errors;
+
+	return 0;
 }
 
 static int ppp_dev_init(struct net_device *dev)
diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index f81fb0b13a94..1f3fda7f410f 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -570,7 +570,7 @@ static int sl_change_mtu(struct net_device *dev, int new_mtu)
 
 /* Netdevice get statistics request */
 
-static void
+static int
 sl_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct net_device_stats *devstats = &dev->stats;
@@ -601,6 +601,8 @@ sl_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->collisions     += comp->sls_o_misses;
 	}
 #endif
+
+	return 0;
 }
 
 /* Netdevice register callback */
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index c19dac21c468..dc9b179a7fd6 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1835,7 +1835,7 @@ static int team_change_mtu(struct net_device *dev, int new_mtu)
 	return err;
 }
 
-static void
+static int
 team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct team *team = netdev_priv(dev);
@@ -1872,6 +1872,8 @@ team_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 	stats->rx_dropped	= rx_dropped;
 	stats->tx_dropped	= tx_dropped;
 	stats->rx_nohandler	= rx_nohandler;
+
+	return 0;
 }
 
 static int team_vlan_rx_add_vid(struct net_device *dev, __be16 proto, u16 vid)
diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index ed3743dc62b9..6ddf1e70308c 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1144,8 +1144,8 @@ static netdev_tx_t tbnet_start_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 }
 
-static void tbnet_get_stats64(struct net_device *dev,
-			      struct rtnl_link_stats64 *stats)
+static int tbnet_get_stats64(struct net_device *dev,
+			     struct rtnl_link_stats64 *stats)
 {
 	struct tbnet *net = netdev_priv(dev);
 
@@ -1161,6 +1161,8 @@ static void tbnet_get_stats64(struct net_device *dev,
 	stats->rx_over_errors = net->stats.rx_over_errors;
 	stats->rx_crc_errors = net->stats.rx_crc_errors;
 	stats->rx_missed_errors = net->stats.rx_missed_errors;
+
+	return 0;
 }
 
 static const struct net_device_ops tbnet_netdev_ops = {
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 978ac0981d16..027929eaad26 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1089,7 +1089,7 @@ static void tun_set_headroom(struct net_device *dev, int new_hr)
 	tun->align = new_hr;
 }
 
-static void
+static int
 tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct tun_struct *tun = netdev_priv(dev);
@@ -1098,6 +1098,8 @@ tun_net_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 
 	stats->rx_frame_errors +=
 		(unsigned long)atomic_long_read(&tun->rx_frame_errors);
+
+	return 0;
 }
 
 static int tun_xdp_set(struct net_device *dev, struct bpf_prog *prog,
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 02bfcdf50a7a..49a1db371bbf 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -361,8 +361,8 @@ static void veth_stats_rx(struct veth_stats *result, struct net_device *dev)
 	}
 }
 
-static void veth_get_stats64(struct net_device *dev,
-			     struct rtnl_link_stats64 *tot)
+static int veth_get_stats64(struct net_device *dev,
+			    struct rtnl_link_stats64 *tot)
 {
 	struct veth_priv *priv = netdev_priv(dev);
 	struct net_device *peer;
@@ -393,6 +393,8 @@ static void veth_get_stats64(struct net_device *dev,
 		tot->tx_packets += rx.xdp_packets;
 	}
 	rcu_read_unlock();
+
+	return 0;
 }
 
 /* fake multicast ability */
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 508408fbe78f..c7cc59f265ad 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1741,8 +1741,8 @@ static int virtnet_set_mac_address(struct net_device *dev, void *p)
 	return ret;
 }
 
-static void virtnet_stats(struct net_device *dev,
-			  struct rtnl_link_stats64 *tot)
+static int virtnet_stats(struct net_device *dev,
+			 struct rtnl_link_stats64 *tot)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 	unsigned int start;
@@ -1777,6 +1777,8 @@ static void virtnet_stats(struct net_device *dev,
 	tot->tx_fifo_errors = dev->stats.tx_fifo_errors;
 	tot->rx_length_errors = dev->stats.rx_length_errors;
 	tot->rx_frame_errors = dev->stats.rx_frame_errors;
+
+	return 0;
 }
 
 static void virtnet_ack_link_announce(struct virtnet_info *vi)
diff --git a/drivers/net/vmxnet3/vmxnet3_ethtool.c b/drivers/net/vmxnet3/vmxnet3_ethtool.c
index 7ec8652f2c26..446f57f802f7 100644
--- a/drivers/net/vmxnet3/vmxnet3_ethtool.c
+++ b/drivers/net/vmxnet3/vmxnet3_ethtool.c
@@ -113,7 +113,7 @@ vmxnet3_global_stats[] = {
 };
 
 
-void
+int
 vmxnet3_get_stats64(struct net_device *netdev,
 		   struct rtnl_link_stats64 *stats)
 {
@@ -160,6 +160,8 @@ vmxnet3_get_stats64(struct net_device *netdev,
 		stats->rx_dropped += drvRxStats->drop_total;
 		stats->multicast +=  devRxStats->mcastPktsRxOK;
 	}
+
+	return 0;
 }
 
 static int
diff --git a/drivers/net/vmxnet3/vmxnet3_int.h b/drivers/net/vmxnet3/vmxnet3_int.h
index d958b92c9429..14739197fe26 100644
--- a/drivers/net/vmxnet3/vmxnet3_int.h
+++ b/drivers/net/vmxnet3/vmxnet3_int.h
@@ -484,8 +484,8 @@ vmxnet3_create_queues(struct vmxnet3_adapter *adapter,
 
 void vmxnet3_set_ethtool_ops(struct net_device *netdev);
 
-void vmxnet3_get_stats64(struct net_device *dev,
-			 struct rtnl_link_stats64 *stats);
+int vmxnet3_get_stats64(struct net_device *dev,
+			struct rtnl_link_stats64 *stats);
 
 extern char vmxnet3_driver_name[];
 #endif
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 6d9130859c55..3300c006f696 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -145,8 +145,8 @@ static void vrf_tx_error(struct net_device *vrf_dev, struct sk_buff *skb)
 	kfree_skb(skb);
 }
 
-static void vrf_get_stats64(struct net_device *dev,
-			    struct rtnl_link_stats64 *stats)
+static int vrf_get_stats64(struct net_device *dev,
+			   struct rtnl_link_stats64 *stats)
 {
 	int i;
 
@@ -170,6 +170,8 @@ static void vrf_get_stats64(struct net_device *dev,
 		stats->rx_bytes += rbytes;
 		stats->rx_packets += rpkts;
 	}
+
+	return 0;
 }
 
 static struct vrf_map *netns_vrf_map(struct net *net)
diff --git a/drivers/net/vsockmon.c b/drivers/net/vsockmon.c
index b1bb1b04b664..4716dc0af471 100644
--- a/drivers/net/vsockmon.c
+++ b/drivers/net/vsockmon.c
@@ -55,13 +55,15 @@ static netdev_tx_t vsockmon_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-static void
+static int
 vsockmon_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	dev_lstats_read(dev, &stats->rx_packets, &stats->rx_bytes);
 
 	stats->tx_packets = 0;
 	stats->tx_bytes = 0;
+
+	return 0;
 }
 
 static int vsockmon_is_valid_mtu(int new_mtu)
diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index b01848ef4649..84f08e42e362 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1247,8 +1247,8 @@ static int xennet_change_mtu(struct net_device *dev, int mtu)
 	return 0;
 }
 
-static void xennet_get_stats64(struct net_device *dev,
-			       struct rtnl_link_stats64 *tot)
+static int xennet_get_stats64(struct net_device *dev,
+			      struct rtnl_link_stats64 *tot)
 {
 	struct netfront_info *np = netdev_priv(dev);
 	int cpu;
@@ -1279,6 +1279,8 @@ static void xennet_get_stats64(struct net_device *dev,
 
 	tot->rx_errors  = dev->stats.rx_errors;
 	tot->tx_dropped = dev->stats.tx_dropped;
+
+	return 0;
 }
 
 static void xennet_release_tx_bufs(struct netfront_queue *queue)
diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 6f5ddc3eab8c..ef96dcebb92a 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -1135,7 +1135,7 @@ netdev_features_t qeth_fix_features(struct net_device *, netdev_features_t);
 netdev_features_t qeth_features_check(struct sk_buff *skb,
 				      struct net_device *dev,
 				      netdev_features_t features);
-void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
+int qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats);
 int qeth_set_real_num_tx_queues(struct qeth_card *card, unsigned int count);
 u16 qeth_iqd_select_queue(struct net_device *dev, struct sk_buff *skb,
 			  u8 cast_type, struct net_device *sb_dev);
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index f4b60294a969..b0efc2a7c498 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -7129,7 +7129,7 @@ netdev_features_t qeth_features_check(struct sk_buff *skb,
 }
 EXPORT_SYMBOL_GPL(qeth_features_check);
 
-void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
+int qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	struct qeth_card *card = dev->ml_priv;
 	struct qeth_qdio_out_q *queue;
@@ -7158,6 +7158,8 @@ void qeth_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 		stats->tx_errors += queue->stats.tx_errors;
 		stats->tx_dropped += queue->stats.tx_dropped;
 	}
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(qeth_get_stats64);
 
diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index f8ba6495e745..213ee9efb044 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -170,7 +170,7 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 		     struct fc_els_lesb *fc_lesb,
 		     struct net_device *netdev)
 {
-	struct rtnl_link_stats64 stats;
+	struct rtnl_link_stats64 dev_stats;
 	unsigned int cpu;
 	u32 lfc, vlfc, mdac;
 	struct fc_stats *stats;
@@ -190,8 +190,8 @@ void __fcoe_get_lesb(struct fc_lport *lport,
 	lesb->lesb_link_fail = htonl(lfc);
 	lesb->lesb_vlink_fail = htonl(vlfc);
 	lesb->lesb_miss_fka = htonl(mdac);
-	dev_get_stats(netdev, &stats);
-	lesb->lesb_fcs_error = htonl(stats.rx_crc_errors);
+	dev_get_stats(netdev, &dev_stats);
+	lesb->lesb_fcs_error = htonl(dev_stats.rx_crc_errors);
 }
 EXPORT_SYMBOL_GPL(__fcoe_get_lesb);
 
diff --git a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
index d524e92051a3..7badd3b0939e 100644
--- a/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
+++ b/drivers/staging/fsl-dpaa2/ethsw/ethsw.c
@@ -358,8 +358,8 @@ static int dpaa2_switch_port_fdb_del(struct ndmsg *ndm, struct nlattr *tb[],
 						    addr);
 }
 
-static void dpaa2_switch_port_get_stats(struct net_device *netdev,
-					struct rtnl_link_stats64 *stats)
+static int dpaa2_switch_port_get_stats(struct net_device *netdev,
+				       struct rtnl_link_stats64 *stats)
 {
 	struct ethsw_port_priv *port_priv = netdev_priv(netdev);
 	u64 tmp;
@@ -418,10 +418,8 @@ static void dpaa2_switch_port_get_stats(struct net_device *netdev,
 	if (err)
 		goto error;
 
-	return;
-
 error:
-	netdev_err(netdev, "dpsw_if_get_counter err %d\n", err);
+	return err;
 }
 
 static bool dpaa2_switch_port_has_offload_stats(const struct net_device *netdev,
diff --git a/drivers/staging/netlogic/xlr_net.c b/drivers/staging/netlogic/xlr_net.c
index 69ea61faf8fa..cfe39e2c493b 100644
--- a/drivers/staging/netlogic/xlr_net.c
+++ b/drivers/staging/netlogic/xlr_net.c
@@ -317,7 +317,7 @@ static void xlr_set_rx_mode(struct net_device *ndev)
 	xlr_nae_wreg(priv->base_addr, R_MAC_FILTER_CONFIG, regval);
 }
 
-static void xlr_stats(struct net_device *ndev, struct rtnl_link_stats64 *stats)
+static int xlr_stats(struct net_device *ndev, struct rtnl_link_stats64 *stats)
 {
 	struct xlr_net_priv *priv = netdev_priv(ndev);
 
@@ -360,6 +360,8 @@ static void xlr_stats(struct net_device *ndev, struct rtnl_link_stats64 *stats)
 						 TX_DROP_FRAME_COUNTER);
 	stats->tx_fifo_errors = xlr_nae_rdreg(priv->base_addr,
 					      TX_DROP_FRAME_COUNTER);
+
+	return 0;
 }
 
 static const struct net_device_ops xlr_netdev_ops = {
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7075a6e94486..c1b641e4bd23 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1039,8 +1039,8 @@ struct netdev_net_notifier {
  *	Callback used when the transmitter has not made any progress
  *	for dev->watchdog ticks.
  *
- * void (*ndo_get_stats64)(struct net_device *dev,
- *                         struct rtnl_link_stats64 *storage);
+ * int (*ndo_get_stats64)(struct net_device *dev,
+ *			  struct rtnl_link_stats64 *storage);
  * struct net_device_stats* (*ndo_get_stats)(struct net_device *dev);
  *	Called when a user wants to get the network device usage
  *	statistics. Drivers must do one of the following:
@@ -1317,7 +1317,7 @@ struct net_device_ops {
 	void			(*ndo_tx_timeout) (struct net_device *dev,
 						   unsigned int txqueue);
 
-	void			(*ndo_get_stats64)(struct net_device *dev,
+	int			(*ndo_get_stats64)(struct net_device *dev,
 						   struct rtnl_link_stats64 *storage);
 	bool			(*ndo_has_offload_stats)(const struct net_device *dev, int attr_id);
 	int			(*ndo_get_offload_stats)(int attr_id,
@@ -4562,12 +4562,12 @@ void netdev_notify_peers(struct net_device *dev);
 void netdev_features_change(struct net_device *dev);
 /* Load a device via the kmod */
 void dev_load(struct net *net, const char *name);
-void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage);
+int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage);
 void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 			     const struct net_device_stats *netdev_stats);
 void dev_fetch_sw_netstats(struct rtnl_link_stats64 *s,
 			   const struct pcpu_sw_netstats __percpu *netstats);
-void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s);
+int dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s);
 
 extern int		netdev_max_backlog;
 extern int		netdev_tstamp_prequeue;
diff --git a/net/8021q/vlan_dev.c b/net/8021q/vlan_dev.c
index ec8408d1638f..4d31184cbfe4 100644
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -683,8 +683,8 @@ static int vlan_ethtool_get_ts_info(struct net_device *dev,
 	return 0;
 }
 
-static void vlan_dev_get_stats64(struct net_device *dev,
-				 struct rtnl_link_stats64 *stats)
+static int vlan_dev_get_stats64(struct net_device *dev,
+				struct rtnl_link_stats64 *stats)
 {
 	struct vlan_pcpu_stats *p;
 	u32 rx_errors = 0, tx_dropped = 0;
@@ -715,6 +715,8 @@ static void vlan_dev_get_stats64(struct net_device *dev,
 	}
 	stats->rx_errors  = rx_errors;
 	stats->tx_dropped = tx_dropped;
+
+	return 0;
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/net/core/dev.c b/net/core/dev.c
index 93618300ac90..96ef462932a7 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10403,13 +10403,14 @@ EXPORT_SYMBOL(netdev_stats_to_stats64);
  *	dev->netdev_ops->get_stats64 or dev->netdev_ops->get_stats;
  *	otherwise the internal statistics structure is used.
  */
-void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
+int dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
 {
 	const struct net_device_ops *ops = dev->netdev_ops;
+	int err = 0;
 
 	if (ops->ndo_get_stats64) {
 		memset(storage, 0, sizeof(*storage));
-		ops->ndo_get_stats64(dev, storage);
+		err = ops->ndo_get_stats64(dev, storage);
 	} else if (ops->ndo_get_stats) {
 		netdev_stats_to_stats64(storage, ops->ndo_get_stats(dev));
 	} else {
@@ -10418,6 +10419,8 @@ void dev_get_stats(struct net_device *dev, struct rtnl_link_stats64 *storage)
 	storage->rx_dropped += (unsigned long)atomic_long_read(&dev->rx_dropped);
 	storage->tx_dropped += (unsigned long)atomic_long_read(&dev->tx_dropped);
 	storage->rx_nohandler += (unsigned long)atomic_long_read(&dev->rx_nohandler);
+
+	return err;
 }
 EXPORT_SYMBOL(dev_get_stats);
 
@@ -10463,10 +10466,12 @@ EXPORT_SYMBOL_GPL(dev_fetch_sw_netstats);
  *	Populate @s from dev->stats and dev->tstats. Can be used as
  *	ndo_get_stats64() callback.
  */
-void dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s)
+int dev_get_tstats64(struct net_device *dev, struct rtnl_link_stats64 *s)
 {
 	netdev_stats_to_stats64(s, &dev->stats);
 	dev_fetch_sw_netstats(s, dev->tstats);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dev_get_tstats64);
 
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index 6cd97c75445c..9a554d47a816 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -87,8 +87,8 @@ static netdev_tx_t l2tp_eth_dev_xmit(struct sk_buff *skb, struct net_device *dev
 	return NETDEV_TX_OK;
 }
 
-static void l2tp_eth_get_stats64(struct net_device *dev,
-				 struct rtnl_link_stats64 *stats)
+static int l2tp_eth_get_stats64(struct net_device *dev,
+				struct rtnl_link_stats64 *stats)
 {
 	struct l2tp_eth *priv = netdev_priv(dev);
 
@@ -98,6 +98,8 @@ static void l2tp_eth_get_stats64(struct net_device *dev,
 	stats->rx_bytes   = (unsigned long)atomic_long_read(&priv->rx_bytes);
 	stats->rx_packets = (unsigned long)atomic_long_read(&priv->rx_packets);
 	stats->rx_errors  = (unsigned long)atomic_long_read(&priv->rx_errors);
+
+	return 0;
 }
 
 static const struct net_device_ops l2tp_eth_netdev_ops = {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 3b9ec4ef81c3..a2cb9dc8ada0 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -698,10 +698,12 @@ static u16 ieee80211_netdev_select_queue(struct net_device *dev,
 	return ieee80211_select_queue(IEEE80211_DEV_TO_SUB_IF(dev), skb);
 }
 
-static void
+static int
 ieee80211_get_stats64(struct net_device *dev, struct rtnl_link_stats64 *stats)
 {
 	dev_fetch_sw_netstats(stats, dev->tstats);
+
+	return 0;
 }
 
 static const struct net_device_ops ieee80211_dataif_ops = {
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 2f1f0a378408..eeca5c6acb80 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -398,8 +398,8 @@ static int teql_master_close(struct net_device *dev)
 	return 0;
 }
 
-static void teql_master_stats64(struct net_device *dev,
-				struct rtnl_link_stats64 *stats)
+static int teql_master_stats64(struct net_device *dev,
+			       struct rtnl_link_stats64 *stats)
 {
 	struct teql_master *m = netdev_priv(dev);
 
@@ -407,6 +407,8 @@ static void teql_master_stats64(struct net_device *dev,
 	stats->tx_bytes		= m->tx_bytes;
 	stats->tx_errors	= m->tx_errors;
 	stats->tx_dropped	= m->tx_dropped;
+
+	return 0;
 }
 
 static int teql_master_mtu(struct net_device *dev, int new_mtu)
-- 
2.25.1

