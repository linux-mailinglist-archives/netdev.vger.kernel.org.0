Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55B021E5076
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 23:26:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387596AbgE0V0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 17:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387412AbgE0V0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 17:26:13 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A57C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:13 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id e11so11485627pfn.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 14:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HdChYpAFg6TyWIfjSjmt+eP+fiPnuv6p6ph8IaoYRaE=;
        b=ECfBpEqQwU7Ea0EXVX7hA34ppoL2ATv7zKJ0tmIvLzipxocKsJz7OF6n36XRpVSNgk
         Bi7PQ45D7VBGnQcN7fhFC596OHF7xLv6Yzd/u9vSFYUL6NScNEaN2l0mLJXdT5t4k9SY
         E10K++zuHVzokjrqdEklhisASBhvYaBzNogu0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HdChYpAFg6TyWIfjSjmt+eP+fiPnuv6p6ph8IaoYRaE=;
        b=IEUFJiYtw46iy6p0ynjBpRl9MJBzfNBjWwSVthD+v6tdwlgEep7b+RkLwZVKmsdV0i
         sk3p6Hej262/nGxNxFCGv1bR20J6dSObXn/2cbFwLhUICm/GTSOUkRKtHsYUB8wMQTfT
         cTB8UZJVHlc12aZvoTNTZKspX/cRcu2JQf5jQsGlScaaJoZ6QvaCcg4kIs6Y3v6dTNZb
         odnt89VUN8MaewajXjALTaXPAIThm6UBy18ovUt0ghd1EYNnjXn87MPTeY52X0DCCSbL
         ECDTocKLoHYj7U5rGrF3dvRvCoPsonZl33QrWxNqWLsZpY27hqk8AQJWUxHyJc2pUQYS
         DhgA==
X-Gm-Message-State: AOAM531tNrkXGHpKcEs0+VBPjl8x7EnEyJNJmGnwlpY6/pAl6FMySUSV
        SFnFHBzOVQEPXzHBvs9Qj4KZpKhA3N2ZmiP2ql7em0phdI+WWoyYRz2GWDpHfHo+zFTPuiyVYSZ
        wd2B3Q7fGS6uCGyHmHrFQpWGe8kwmhtr7jUVllLYAyQxRxQHrDTmacPAka42mbNcGwnFFlk5S
X-Google-Smtp-Source: ABdhPJwLWMTXmKXxYt0EzL4fSGtxSQF9sORdu2AieqfyTTG5souowqdegkszf47Dsc4BwBjjXAlfqw==
X-Received: by 2002:a62:1681:: with SMTP id 123mr5593778pfw.306.1590614771949;
        Wed, 27 May 2020 14:26:11 -0700 (PDT)
Received: from localhost.localdomain ([2600:8802:202:f600::ddf])
        by smtp.gmail.com with ESMTPSA id c4sm2770344pfb.130.2020.05.27.14.26.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 14:26:11 -0700 (PDT)
From:   Edwin Peer <edwin.peer@broadcom.com>
To:     netdev@vger.kernel.org
Cc:     Edwin Peer <edwin.peer@broadcom.com>, edumazet@google.com,
        linville@tuxdriver.com, shemminger@vyatta.com,
        mirq-linux@rere.qmqm.pl, jesse.brandeburg@intel.com,
        jchapman@katalix.com, david@weave.works, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, sridhar.samudrala@intel.com,
        jiri@mellanox.com, geoff@infradead.org, mokuno@sm.sony.co.jp,
        msink@permonline.ru, mporter@kernel.crashing.org,
        inaky.perez-gonzalez@intel.com, jwi@linux.ibm.com,
        kgraul@linux.ibm.com, ubraun@linux.ibm.com,
        grant.likely@secretlab.ca, hadi@cyberus.ca, dsahern@kernel.org,
        shrijeet@gmail.com, jon.mason@intel.com, dave.jiang@intel.com,
        saeedm@mellanox.com, hadarh@mellanox.com, ogerlitz@mellanox.com,
        allenbh@gmail.com, michael.chan@broadcom.com
Subject: [RFC PATCH net-next 10/11] net: vlan: disallow non-Ethernet devices
Date:   Wed, 27 May 2020 14:25:11 -0700
Message-Id: <20200527212512.17901-11-edwin.peer@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200527212512.17901-1-edwin.peer@broadcom.com>
References: <20200527212512.17901-1-edwin.peer@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Layering VLANs on top of non-Ethernet devices is not defined. This
prevents nonsensical combinations like VLANs on top of raw IP in
IP tunnels, for example.

Checking the device type means that some devices no longer need to
explicitly set NETIF_F_VLAN_CHALLENGED. Remove this flags from those
devices where this is trivially the case.

The failover device does not explicitly check device types when adding
slaves (team and bonding drivers do), so include the device type check
when VLANs are in use too.

TEQL scheduling devices have historically allowed VLANs and this change
would break that. Inherit the slave device's type instead of ARPHRD_VOID
and enforce that all slaves have the same type.

IFB devices do not have a normal xmit function and so VLAN devices
cannot forward frames (packets must be redirected). IFB devices are
also IFF_NOARP, so we can set the device type accordingly to disable
support for VLANs. Similarly the SB1000 is RX only.

VLANs don't make sense for VRF devices because they are raw IP. Relying
on NETIF_F_VLAN_CHALLENGED is unnecessary if the device type is set
appropriately.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c   | 3 +--
 drivers/net/ethernet/xilinx/ll_temac_main.c | 1 -
 drivers/net/ifb.c                           | 4 ++++
 drivers/net/loopback.c                      | 1 -
 drivers/net/net_failover.c                  | 3 +--
 drivers/net/sb1000.c                        | 1 +
 drivers/net/vrf.c                           | 4 +---
 include/linux/if_vlan.h                     | 8 ++++++++
 net/8021q/vlan.c                            | 2 +-
 net/sched/sch_teql.c                        | 3 +++
 10 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 81b8227214f1..a4404957b39b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -2086,8 +2086,7 @@ void ipoib_setup_common(struct net_device *dev)
 	dev->addr_len		 = INFINIBAND_ALEN;
 	dev->type		 = ARPHRD_INFINIBAND;
 	dev->tx_queue_len	 = ipoib_sendq_size * 2;
-	dev->features		 = (NETIF_F_VLAN_CHALLENGED	|
-				    NETIF_F_HIGHDMA);
+	dev->features		 = NETIF_F_HIGHDMA;
 	netif_keep_dst(dev);
 
 	memcpy(dev->broadcast, ipv4_bcast_addr, INFINIBAND_ALEN);
diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 929244064abd..731326d1e99f 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1375,7 +1375,6 @@ static int temac_probe(struct platform_device *pdev)
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_TX; /* Transmit VLAN hw accel */
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_RX; /* Receive VLAN hw acceleration */
 	ndev->features |= NETIF_F_HW_VLAN_CTAG_FILTER; /* Receive VLAN filtering */
-	ndev->features |= NETIF_F_VLAN_CHALLENGED; /* cannot handle VLAN pkts */
 	ndev->features |= NETIF_F_GSO; /* Enable software GSO. */
 	ndev->features |= NETIF_F_MULTI_QUEUE; /* Has multiple TX/RX queues */
 	ndev->features |= NETIF_F_LRO; /* large receive offload */
diff --git a/drivers/net/ifb.c b/drivers/net/ifb.c
index 7fe306e76281..3ac6b4282113 100644
--- a/drivers/net/ifb.c
+++ b/drivers/net/ifb.c
@@ -213,6 +213,10 @@ static void ifb_setup(struct net_device *dev)
 
 	/* Fill in device structure with ethernet-generic values. */
 	ether_setup(dev);
+
+	/* Override ARPHRD_ETHER to disallow upper VLAN devices (no xmit). */
+	dev->type = ARPHRD_NONE;
+
 	dev->tx_queue_len = TX_Q_LIMIT;
 
 	dev->features |= IFB_FEATURES;
diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
index a1c77cc00416..59c7aa726245 100644
--- a/drivers/net/loopback.c
+++ b/drivers/net/loopback.c
@@ -183,7 +183,6 @@ static void gen_lo_setup(struct net_device *dev,
 		| NETIF_F_HIGHDMA
 		| NETIF_F_LLTX
 		| NETIF_F_NETNS_LOCAL
-		| NETIF_F_VLAN_CHALLENGED
 		| NETIF_F_LOOPBACK;
 	dev->ethtool_ops	= eth_ops;
 	dev->header_ops		= hdr_ops;
diff --git a/drivers/net/net_failover.c b/drivers/net/net_failover.c
index a085d292b4cf..78ef32642c85 100644
--- a/drivers/net/net_failover.c
+++ b/drivers/net/net_failover.c
@@ -496,8 +496,7 @@ static int net_failover_slave_pre_register(struct net_device *slave_dev,
 				  !dev_is_pci(slave_dev->dev.parent)))
 		return -EINVAL;
 
-	if (failover_dev->features & NETIF_F_VLAN_CHALLENGED &&
-	    vlan_uses_dev(failover_dev)) {
+	if (vlan_challenged(failover_dev) && vlan_uses_dev(failover_dev)) {
 		netdev_err(failover_dev, "Device %s is VLAN challenged and failover device has VLAN set up\n",
 			   failover_dev->name);
 		return -EINVAL;
diff --git a/drivers/net/sb1000.c b/drivers/net/sb1000.c
index e88af978f63c..0cb3fb563160 100644
--- a/drivers/net/sb1000.c
+++ b/drivers/net/sb1000.c
@@ -192,6 +192,7 @@ sb1000_probe_one(struct pnp_dev *pdev, const struct pnp_device_id *id)
 	 * The SB1000 is an rx-only cable modem device.  The uplink is a modem
 	 * and we do not want to arp on it.
 	 */
+	dev->type = ARPHRD_NONE;
 	dev->flags = IFF_POINTOPOINT|IFF_NOARP;
 
 	SET_NETDEV_DEV(dev, &pdev->dev);
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index 43928a1c2f2a..f490f3cfa358 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -860,6 +860,7 @@ static int vrf_dev_init(struct net_device *dev)
 	if (vrf_rt6_create(dev) != 0)
 		goto out_rth;
 
+	dev->type = ARPHRD_RAWIP;
 	dev->flags = IFF_MASTER | IFF_NOARP;
 
 	/* MTU is irrelevant for VRF device; set to 64k similar to lo */
@@ -1271,9 +1272,6 @@ static void vrf_setup(struct net_device *dev)
 	/* don't allow vrf devices to change network namespaces. */
 	dev->features |= NETIF_F_NETNS_LOCAL;
 
-	/* does not make sense for a VLAN to be added to a vrf device */
-	dev->features   |= NETIF_F_VLAN_CHALLENGED;
-
 	/* enable offload features */
 	dev->features   |= NETIF_F_GSO_SOFTWARE;
 	dev->features   |= NETIF_F_RXCSUM | NETIF_F_HW_CSUM | NETIF_F_SCTP_CRC;
diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index e4a5532fb179..7c2781ec7013 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -12,6 +12,7 @@
 #include <linux/rtnetlink.h>
 #include <linux/bug.h>
 #include <uapi/linux/if_vlan.h>
+#include <uapi/linux/if_arp.h>
 
 #define VLAN_HLEN	4		/* The additional bytes required by VLAN
 					 * (in addition to the Ethernet header)
@@ -789,4 +790,11 @@ static inline void vlan_constrain_mtu(struct net_device *dev)
  */
 int vlan_constrained_change_mtu(struct net_device *dev, int new_mtu);
 
+/* in addition to NETIF_F_VLAN_CHALLENGED, non-Ethernet devices can't VLAN */
+static inline bool vlan_challenged(struct net_device *dev)
+{
+	return dev->type != ARPHRD_ETHER ||
+	       dev->features & NETIF_F_VLAN_CHALLENGED;
+}
+
 #endif /* !(_LINUX_IF_VLAN_H_) */
diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index d4bcfd8f95bf..eb162b020ec9 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -127,7 +127,7 @@ int vlan_check_real_dev(struct net_device *real_dev,
 {
 	const char *name = real_dev->name;
 
-	if (real_dev->features & NETIF_F_VLAN_CHALLENGED) {
+	if (vlan_challenged(real_dev)) {
 		pr_info("VLANs not supported on %s\n", name);
 		NL_SET_ERR_MSG_MOD(extack, "VLANs not supported on device");
 		return -EOPNOTSUPP;
diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 689ef6f3ded8..7ef08bd16b24 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -181,6 +181,8 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 	skb_queue_head_init(&q->q);
 
 	if (m->slaves) {
+		if (m->dev->type != dev->type)
+			return -EINVAL;
 		if (m->dev->flags & IFF_UP) {
 			if ((m->dev->flags & IFF_POINTOPOINT &&
 			     !(dev->flags & IFF_POINTOPOINT)) ||
@@ -205,6 +207,7 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 	} else {
 		q->next = sch;
 		m->slaves = sch;
+		m->dev->type = dev->type;
 		m->dev->mtu = dev->mtu;
 		m->dev->flags = (m->dev->flags&~FMASK)|(dev->flags&FMASK);
 	}
-- 
2.26.2

