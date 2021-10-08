Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8AAD426FC3
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 19:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhJHRzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 13:55:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:45182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231217AbhJHRzr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 13:55:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F185B6101E;
        Fri,  8 Oct 2021 17:53:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633715632;
        bh=tc1Fh4ccDyaR6IUP9VUoFJgpD/L0mtSWbhAaYf9E8fU=;
        h=From:To:Cc:Subject:Date:From;
        b=ha+jL8aq13kQZzOTzeePlnIjKekT+RjlXrRC5T+4tSh2/hWFPQ9UcJuntBenND8lT
         eTgqvFMTaNJL8uxT72R8MHycC+av5FlWY3nI9SgCszDWpcQfp1Q9LqbNadKhc7d9rj
         ajII5WFMRq6OCCgugGHwPZ3oJRXn2C3JlCkx3MSR8cN0uPfssJBAXPgB2U1S1CMLdn
         V4zs8b+QXWnseKbG2DSXYCaVL2CwbcVHNXGiDEJDnPO870MJvt3+wr5+pHJr5WJ2hC
         5lJLsk1SiY0T+r14YeGX66LseH9MiEYvAh4hrOtOsVpwk/j+wXt7FszHiA0PYGEFUj
         DBNSBpXFUXyOA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com,
        t.sailer@alumni.ethz.ch, jreuter@yaina.de, jpr@f6fbb.org,
        sridhar.samudrala@intel.com, jiri@resnulli.us,
        jes@trained-monkey.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: use dev_addr_set()
Date:   Fri,  8 Oct 2021 10:53:39 -0700
Message-Id: <20211008175339.3753696-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use dev_addr_set() instead of writing directly to netdev->dev_addr
in various misc and old drivers.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/bonding/bond_main.c   | 2 +-
 drivers/net/hamradio/baycom_epp.c | 2 +-
 drivers/net/hamradio/bpqether.c   | 2 +-
 drivers/net/hamradio/dmascc.c     | 3 +--
 drivers/net/hamradio/hdlcdrv.c    | 2 +-
 drivers/net/hamradio/scc.c        | 2 +-
 drivers/net/hamradio/yam.c        | 2 +-
 drivers/net/net_failover.c        | 3 +--
 drivers/net/ntb_netdev.c          | 2 +-
 drivers/net/team/team.c           | 2 +-
 drivers/net/vmxnet3/vmxnet3_drv.c | 4 ++--
 drivers/net/wan/lapbether.c       | 2 +-
 net/802/hippi.c                   | 2 +-
 net/atm/br2684.c                  | 2 +-
 net/netrom/nr_dev.c               | 2 +-
 net/rose/rose_dev.c               | 2 +-
 16 files changed, 17 insertions(+), 19 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 77dc79a7f574..0c52612cb8e9 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -4414,7 +4414,7 @@ static int bond_set_mac_address(struct net_device *bond_dev, void *addr)
 	}
 
 	/* success */
-	memcpy(bond_dev->dev_addr, ss->__data, bond_dev->addr_len);
+	dev_addr_set(bond_dev, ss->__data);
 	return 0;
 
 unwind:
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 775dcf4ebde5..f6428ff780ab 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -791,7 +791,7 @@ static int baycom_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *sa = (struct sockaddr *)addr;
 
 	/* addr is an AX.25 shifted ASCII mac address */
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len); 
+	dev_addr_set(dev, sa->sa_data);
 	return 0;                                         
 }
 
diff --git a/drivers/net/hamradio/bpqether.c b/drivers/net/hamradio/bpqether.c
index d967b0748773..1ac816164a9b 100644
--- a/drivers/net/hamradio/bpqether.c
+++ b/drivers/net/hamradio/bpqether.c
@@ -302,7 +302,7 @@ static int bpq_set_mac_address(struct net_device *dev, void *addr)
 {
     struct sockaddr *sa = (struct sockaddr *)addr;
 
-    memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+    dev_addr_set(dev, sa->sa_data);
 
     return 0;
 }
diff --git a/drivers/net/hamradio/dmascc.c b/drivers/net/hamradio/dmascc.c
index f4c3efc3e074..a4ba1b79d2d0 100644
--- a/drivers/net/hamradio/dmascc.c
+++ b/drivers/net/hamradio/dmascc.c
@@ -956,8 +956,7 @@ static int scc_send_packet(struct sk_buff *skb, struct net_device *dev)
 
 static int scc_set_mac_address(struct net_device *dev, void *sa)
 {
-	memcpy(dev->dev_addr, ((struct sockaddr *) sa)->sa_data,
-	       dev->addr_len);
+	dev_addr_set(dev, ((struct sockaddr *)sa)->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/hamradio/hdlcdrv.c b/drivers/net/hamradio/hdlcdrv.c
index 5805cfc83854..ab5327acec22 100644
--- a/drivers/net/hamradio/hdlcdrv.c
+++ b/drivers/net/hamradio/hdlcdrv.c
@@ -415,7 +415,7 @@ static int hdlcdrv_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *sa = (struct sockaddr *)addr;
 
 	/* addr is an AX.25 shifted ASCII mac address */
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len); 
+	dev_addr_set(dev, sa->sa_data);
 	return 0;                                         
 }
 
diff --git a/drivers/net/hamradio/scc.c b/drivers/net/hamradio/scc.c
index e0bb131a33d7..9b745d09d327 100644
--- a/drivers/net/hamradio/scc.c
+++ b/drivers/net/hamradio/scc.c
@@ -1951,7 +1951,7 @@ static int scc_net_siocdevprivate(struct net_device *dev,
 static int scc_net_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *sa = (struct sockaddr *) addr;
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	dev_addr_set(dev, sa->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 6ddacbdb224b..e557ccf98bcf 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1063,7 +1063,7 @@ static int yam_set_mac_address(struct net_device *dev, void *addr)
 	struct sockaddr *sa = (struct sockaddr *) addr;
 
 	/* addr is an AX.25 shifted ASCII mac address */
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	dev_addr_set(dev, sa->sa_data);
 	return 0;
 }
 
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index 2a4892402ed8..86ec5aae4289 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -748,8 +748,7 @@ struct failover *net_failover_create(struct net_device *standby_dev)
 	failover_dev->hw_features |= NETIF_F_GSO_ENCAP_ALL;
 	failover_dev->features |= failover_dev->hw_features;
 
-	memcpy(failover_dev->dev_addr, standby_dev->dev_addr,
-	       failover_dev->addr_len);
+	dev_addr_set(failover_dev, standby_dev->dev_addr);
 
 	failover_dev->min_mtu = standby_dev->min_mtu;
 	failover_dev->max_mtu = standby_dev->max_mtu;
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..98ca6b18415e 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -428,7 +428,7 @@ static int ntb_netdev_probe(struct device *client_dev)
 	ndev->watchdog_timeo = msecs_to_jiffies(NTB_TX_TIMEOUT_MS);
 
 	eth_random_addr(ndev->perm_addr);
-	memcpy(ndev->dev_addr, ndev->perm_addr, ndev->addr_len);
+	dev_addr_set(ndev, ndev->perm_addr);
 
 	ndev->netdev_ops = &ntb_netdev_ops;
 	ndev->ethtool_ops = &ntb_ethtool_ops;
diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index dd7917cab2b1..8b2adc56b92a 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1790,7 +1790,7 @@ static int team_set_mac_address(struct net_device *dev, void *p)
 
 	if (dev->type == ARPHRD_ETHER && !is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	dev_addr_set(dev, addr->sa_data);
 	mutex_lock(&team->lock);
 	list_for_each_entry(port, &team->port_list, list)
 		if (team->ops.port_change_dev_addr)
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 142f70670f5c..7a205ddf0060 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -2824,7 +2824,7 @@ vmxnet3_set_mac_addr(struct net_device *netdev, void *p)
 	struct sockaddr *addr = p;
 	struct vmxnet3_adapter *adapter = netdev_priv(netdev);
 
-	memcpy(netdev->dev_addr, addr->sa_data, netdev->addr_len);
+	dev_addr_set(netdev, addr->sa_data);
 	vmxnet3_write_mac_addr(adapter, addr->sa_data);
 
 	return 0;
@@ -3638,7 +3638,7 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 #endif
 
 	vmxnet3_read_mac_addr(adapter, mac);
-	memcpy(netdev->dev_addr,  mac, netdev->addr_len);
+	dev_addr_set(netdev, mac);
 
 	netdev->netdev_ops = &vmxnet3_netdev_ops;
 	vmxnet3_set_ethtool_ops(netdev);
diff --git a/drivers/net/wan/lapbether.c b/drivers/net/wan/lapbether.c
index 89d31adc3809..282192b82404 100644
--- a/drivers/net/wan/lapbether.c
+++ b/drivers/net/wan/lapbether.c
@@ -301,7 +301,7 @@ static int lapbeth_set_mac_address(struct net_device *dev, void *addr)
 {
 	struct sockaddr *sa = addr;
 
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	dev_addr_set(dev, sa->sa_data);
 	return 0;
 }
 
diff --git a/net/802/hippi.c b/net/802/hippi.c
index f80b33a8f7e0..887e73d520e4 100644
--- a/net/802/hippi.c
+++ b/net/802/hippi.c
@@ -121,7 +121,7 @@ int hippi_mac_addr(struct net_device *dev, void *p)
 	struct sockaddr *addr = p;
 	if (netif_running(dev))
 		return -EBUSY;
-	memcpy(dev->dev_addr, addr->sa_data, dev->addr_len);
+	dev_addr_set(dev, addr->sa_data);
 	return 0;
 }
 EXPORT_SYMBOL(hippi_mac_addr);
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index dd2a8dabed84..11854fde52db 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -578,7 +578,7 @@ static int br2684_regvcc(struct atm_vcc *atmvcc, void __user * arg)
 	if (list_empty(&brdev->brvccs) && !brdev->mac_was_set) {
 		unsigned char *esi = atmvcc->dev->esi;
 		if (esi[0] | esi[1] | esi[2] | esi[3] | esi[4] | esi[5])
-			memcpy(net_dev->dev_addr, esi, net_dev->addr_len);
+			dev_addr_set(net_dev, esi);
 		else
 			net_dev->dev_addr[2] = 1;
 	}
diff --git a/net/netrom/nr_dev.c b/net/netrom/nr_dev.c
index 29e418c8c6c3..d1ca413d3317 100644
--- a/net/netrom/nr_dev.c
+++ b/net/netrom/nr_dev.c
@@ -111,7 +111,7 @@ static int __must_check nr_set_mac_address(struct net_device *dev, void *addr)
 		ax25_listen_release((ax25_address *)dev->dev_addr, NULL);
 	}
 
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	dev_addr_set(dev, sa->sa_data);
 
 	return 0;
 }
diff --git a/net/rose/rose_dev.c b/net/rose/rose_dev.c
index 051804fbee17..2a35e188b389 100644
--- a/net/rose/rose_dev.c
+++ b/net/rose/rose_dev.c
@@ -69,7 +69,7 @@ static int rose_set_mac_address(struct net_device *dev, void *addr)
 		rose_del_loopback_node((rose_address *)dev->dev_addr);
 	}
 
-	memcpy(dev->dev_addr, sa->sa_data, dev->addr_len);
+	dev_addr_set(dev, sa->sa_data);
 
 	return 0;
 }
-- 
2.31.1

