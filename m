Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 791BC206252
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393031AbgFWU7L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 16:59:11 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59467 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392307AbgFWUlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 16:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592944876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=LLF8LHEH8NJOMUcF1aLfYC033N+Bd+Ad/2TjfiGHZVA=;
        b=bWcU6HlQW80BIDR7ITD8yj9BIF42G6tz2xmAz/vUiN6mWTMLl/590hm8dD1i3i1KQ1Iwv6
        Kw1phBnaep98herNRNRxxAKUbYXh+VbJ2pw+3lmYs9wT7fhsh7vehn5gSo+kzV2wg0QoSB
        klHI3QUAARLRtaVFp5FCONVcGspETKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-339-4smYYUt9Mj6P7AM3k07XCg-1; Tue, 23 Jun 2020 16:41:12 -0400
X-MC-Unique: 4smYYUt9Mj6P7AM3k07XCg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D839D1005512;
        Tue, 23 Jun 2020 20:41:09 +0000 (UTC)
Received: from hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com (hp-dl360pgen8-07.khw2.lab.eng.bos.redhat.com [10.16.210.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FBE460CD3;
        Tue, 23 Jun 2020 20:41:05 +0000 (UTC)
From:   Jarod Wilson <jarod@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Jarod Wilson <jarod@redhat.com>,
        Boris Pismenny <borisp@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org
Subject: [PATCH net-next] bonding/xfrm: use real_dev instead of slave_dev
Date:   Tue, 23 Jun 2020 16:40:01 -0400
Message-Id: <20200623204001.55030-1-jarod@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rather than requiring every hw crypto capable NIC driver to do a check for
slave_dev being set, set real_dev in the xfrm layer and xso init time, and
then override it in the bonding driver as needed. Then NIC drivers can
always use real_dev, and at the same time, we eliminate the use of a
variable name that probably shouldn't have been used in the first place,
particularly given recent current events.

CC: Boris Pismenny <borisp@mellanox.com>
CC: Saeed Mahameed <saeedm@mellanox.com>
CC: Leon Romanovsky <leon@kernel.org>
CC: Jay Vosburgh <j.vosburgh@gmail.com>
CC: Veaceslav Falico <vfalico@gmail.com>
CC: Andy Gospodarek <andy@greyhouse.net>
CC: "David S. Miller" <davem@davemloft.net>
CC: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
CC: Jakub Kicinski <kuba@kernel.org>
CC: Steffen Klassert <steffen.klassert@secunet.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>
CC: netdev@vger.kernel.org
Suggested-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Jarod Wilson <jarod@redhat.com>
---
 drivers/net/bonding/bond_main.c               |  6 +--
 .../net/ethernet/intel/ixgbe/ixgbe_ipsec.c    | 47 +++++--------------
 .../mellanox/mlx5/core/en_accel/ipsec.c       | 10 +---
 include/net/xfrm.h                            |  2 +-
 net/xfrm/xfrm_device.c                        |  5 +-
 5 files changed, 21 insertions(+), 49 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 90939ccf2a94..4ef99efc37f6 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -386,7 +386,7 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	struct bonding *bond = netdev_priv(bond_dev);
 	struct slave *slave = rtnl_dereference(bond->curr_active_slave);
 
-	xs->xso.slave_dev = slave->dev;
+	xs->xso.real_dev = slave->dev;
 	bond->xs = xs;
 
 	if (!(slave->dev->xfrmdev_ops
@@ -411,7 +411,7 @@ static void bond_ipsec_del_sa(struct xfrm_state *xs)
 	if (!slave)
 		return;
 
-	xs->xso.slave_dev = slave->dev;
+	xs->xso.real_dev = slave->dev;
 
 	if (!(slave->dev->xfrmdev_ops
 	      && slave->dev->xfrmdev_ops->xdo_dev_state_delete)) {
@@ -440,7 +440,7 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 		return false;
 	}
 
-	xs->xso.slave_dev = slave_dev;
+	xs->xso.real_dev = slave_dev;
 	return slave_dev->xfrmdev_ops->xdo_dev_offload_ok(skb, xs);
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 26b0a58a064d..6516980965a2 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -427,14 +427,11 @@ static struct xfrm_state *ixgbe_ipsec_find_rx_state(struct ixgbe_ipsec *ipsec,
 static int ixgbe_ipsec_parse_proto_keys(struct xfrm_state *xs,
 					u32 *mykey, u32 *mysalt)
 {
-	struct net_device *dev = xs->xso.dev;
+	struct net_device *dev = xs->xso.real_dev;
 	unsigned char *key_data;
 	char *alg_name = NULL;
 	int key_len;
 
-	if (xs->xso.slave_dev)
-		dev = xs->xso.slave_dev;
-
 	if (!xs->aead) {
 		netdev_err(dev, "Unsupported IPsec algorithm\n");
 		return -EINVAL;
@@ -480,9 +477,9 @@ static int ixgbe_ipsec_parse_proto_keys(struct xfrm_state *xs,
  **/
 static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 {
-	struct net_device *dev = xs->xso.dev;
-	struct ixgbe_adapter *adapter;
-	struct ixgbe_hw *hw;
+	struct net_device *dev = xs->xso.real_dev;
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
+	struct ixgbe_hw *hw = &adapter->hw;
 	u32 mfval, manc, reg;
 	int num_filters = 4;
 	bool manc_ipv4;
@@ -500,12 +497,6 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 #define BMCIP_V6                 0x3
 #define BMCIP_MASK               0x3
 
-	if (xs->xso.slave_dev)
-		dev = xs->xso.slave_dev;
-
-	adapter = netdev_priv(dev);
-	hw = &adapter->hw;
-
 	manc = IXGBE_READ_REG(hw, IXGBE_MANC);
 	manc_ipv4 = !!(manc & MANC_EN_IPV4_FILTER);
 	mfval = IXGBE_READ_REG(hw, IXGBE_MFVAL);
@@ -569,22 +560,15 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
  **/
 static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
 {
-	struct net_device *dev = xs->xso.dev;
-	struct ixgbe_adapter *adapter;
-	struct ixgbe_ipsec *ipsec;
-	struct ixgbe_hw *hw;
+	struct net_device *dev = xs->xso.real_dev;
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
+	struct ixgbe_ipsec *ipsec = adapter->ipsec;
+	struct ixgbe_hw *hw = &adapter->hw;
 	int checked, match, first;
 	u16 sa_idx;
 	int ret;
 	int i;
 
-	if (xs->xso.slave_dev)
-		dev = xs->xso.slave_dev;
-
-	adapter = netdev_priv(dev);
-	ipsec = adapter->ipsec;
-	hw = &adapter->hw;
-
 	if (xs->id.proto != IPPROTO_ESP && xs->id.proto != IPPROTO_AH) {
 		netdev_err(dev, "Unsupported protocol 0x%04x for ipsec offload\n",
 			   xs->id.proto);
@@ -761,20 +745,13 @@ static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
  **/
 static void ixgbe_ipsec_del_sa(struct xfrm_state *xs)
 {
-	struct net_device *dev = xs->xso.dev;
-	struct ixgbe_adapter *adapter;
-	struct ixgbe_ipsec *ipsec;
-	struct ixgbe_hw *hw;
+	struct net_device *dev = xs->xso.real_dev;
+	struct ixgbe_adapter *adapter = netdev_priv(dev);
+	struct ixgbe_ipsec *ipsec = adapter->ipsec;
+	struct ixgbe_hw *hw = &adapter->hw;
 	u32 zerobuf[4] = {0, 0, 0, 0};
 	u16 sa_idx;
 
-	if (xs->xso.slave_dev)
-		dev = xs->xso.slave_dev;
-
-	adapter = netdev_priv(dev);
-	ipsec = adapter->ipsec;
-	hw = &adapter->hw;
-
 	if (xs->xso.flags & XFRM_OFFLOAD_INBOUND) {
 		struct rx_sa *rsa;
 		u8 ipi;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 72ad6664bd73..bc55c82b55ba 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -207,12 +207,9 @@ mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 {
-	struct net_device *netdev = x->xso.dev;
+	struct net_device *netdev = x->xso.real_dev;
 	struct mlx5e_priv *priv;
 
-	if (x->xso.slave_dev)
-		netdev = x->xso.slave_dev;
-
 	priv = netdev_priv(netdev);
 
 	if (x->props.aalgo != SADB_AALG_NONE) {
@@ -288,15 +285,12 @@ static inline int mlx5e_xfrm_validate_state(struct xfrm_state *x)
 static int mlx5e_xfrm_add_state(struct xfrm_state *x)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
-	struct net_device *netdev = x->xso.dev;
+	struct net_device *netdev = x->xso.real_dev;
 	struct mlx5_accel_esp_xfrm_attrs attrs;
 	struct mlx5e_priv *priv;
 	unsigned int sa_handle;
 	int err;
 
-	if (x->xso.slave_dev)
-		netdev = x->xso.slave_dev;
-
 	priv = netdev_priv(netdev);
 
 	err = mlx5e_xfrm_validate_state(x);
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index e20b2b27ec48..e648c9e6c919 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -127,7 +127,7 @@ struct xfrm_state_walk {
 
 struct xfrm_state_offload {
 	struct net_device	*dev;
-	struct net_device	*slave_dev;
+	struct net_device	*real_dev;
 	unsigned long		offload_handle;
 	unsigned int		num_exthdrs;
 	u8			flags;
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index b8918fc5248b..7b64bb64c822 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -120,8 +120,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 	if (xo->flags & XFRM_GRO || x->xso.flags & XFRM_OFFLOAD_INBOUND)
 		return skb;
 
-	/* This skb was already validated on the master dev */
-	if ((x->xso.dev != dev) && (x->xso.slave_dev == dev))
+	/* This skb was already validated on the upper/virtual dev */
+	if ((x->xso.dev != dev) && (x->xso.real_dev == dev))
 		return skb;
 
 	local_irq_save(flags);
@@ -259,6 +259,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	}
 
 	xso->dev = dev;
+	xso->real_dev = dev;
 	xso->num_exthdrs = 1;
 	xso->flags = xuo->flags;
 
-- 
2.20.1

