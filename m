Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE050677D68
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 15:01:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjAWOBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 09:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232037AbjAWOBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 09:01:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A51724124;
        Mon, 23 Jan 2023 06:01:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 312DA60F31;
        Mon, 23 Jan 2023 14:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C96D3C433D2;
        Mon, 23 Jan 2023 14:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674482461;
        bh=masDtr0y+l20792ObNM2iso0DDnYb2duLa9PEIo7Zzo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oc/RFWwcP8jMDUp+DK5lLDt6OQEsnnT+5PmdRqiU/r7t3HYxDek1waMJWx8mRNgjN
         xtUx2X/5+YNh2c5jqMVgIecHZQSaicNuh1sK59Ew5Ra0HHL57mr606erq1QkD3EqEd
         z8fB04psqzsrAXslYrUKH9R5QarjI5wiZkXNzpqACpFkjL9DRXPR2ZSM/Cbg1At5KV
         KRTBS3BFBhDvQvoPKUYiWoT4h3OImHoUaXBSwIn0uffmjUKbznbq0Zruu48m7ujyZH
         5E2EtqqmnTQ8xNbja9rWzCDDGYSsMphiRbdQMgJ5UzDdkH4m+jBknL9bP3/NA/CulX
         vsj/42LmyObrA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Eric Dumazet <edumazet@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        intel-wired-lan@lists.osuosl.org,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Veaceslav Falico <vfalico@gmail.com>
Subject: [PATCH net-next 03/10] xfrm: extend add state callback to set failure reason
Date:   Mon, 23 Jan 2023 16:00:16 +0200
Message-Id: <77e4e6777e0c8c8dceb8053546b9407138df21be.1674481435.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1674481435.git.leon@kernel.org>
References: <cover.1674481435.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Almost all validation logic is in the drivers, but they are
missing reliable way to convey failure reason to userspace
applications.

Let's use extack to return this information to users.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
---
 Documentation/networking/xfrm_device.rst                  | 2 +-
 drivers/net/bonding/bond_main.c                           | 8 +++++---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c           | 5 +++--
 .../ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c  | 6 ++++--
 drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c            | 6 ++++--
 drivers/net/ethernet/intel/ixgbevf/ipsec.c                | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c  | 3 ++-
 drivers/net/ethernet/netronome/nfp/crypto/ipsec.c         | 3 ++-
 drivers/net/netdevsim/ipsec.c                             | 3 ++-
 include/linux/netdevice.h                                 | 2 +-
 net/xfrm/xfrm_device.c                                    | 6 ++----
 net/xfrm/xfrm_state.c                                     | 2 +-
 12 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/Documentation/networking/xfrm_device.rst b/Documentation/networking/xfrm_device.rst
index b9c53e626982..83abdfef4ec3 100644
--- a/Documentation/networking/xfrm_device.rst
+++ b/Documentation/networking/xfrm_device.rst
@@ -64,7 +64,7 @@ Callbacks to implement
   /* from include/linux/netdevice.h */
   struct xfrmdev_ops {
         /* Crypto and Packet offload callbacks */
-	int	(*xdo_dev_state_add) (struct xfrm_state *x);
+	int	(*xdo_dev_state_add) (struct xfrm_state *x, struct netlink_ext_ack *extack);
 	void	(*xdo_dev_state_delete) (struct xfrm_state *x);
 	void	(*xdo_dev_state_free) (struct xfrm_state *x);
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 0363ce597661..686b2a6fd674 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -419,8 +419,10 @@ static int bond_vlan_rx_kill_vid(struct net_device *bond_dev,
 /**
  * bond_ipsec_add_sa - program device with a security association
  * @xs: pointer to transformer state struct
+ * @extack: extack point to fill failure reason
  **/
-static int bond_ipsec_add_sa(struct xfrm_state *xs)
+static int bond_ipsec_add_sa(struct xfrm_state *xs,
+			     struct netlink_ext_ack *extack)
 {
 	struct net_device *bond_dev = xs->xso.dev;
 	struct bond_ipsec *ipsec;
@@ -454,7 +456,7 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs)
 	}
 	xs->xso.real_dev = slave->dev;
 
-	err = slave->dev->xfrmdev_ops->xdo_dev_state_add(xs);
+	err = slave->dev->xfrmdev_ops->xdo_dev_state_add(xs, extack);
 	if (!err) {
 		ipsec->xs = xs;
 		INIT_LIST_HEAD(&ipsec->list);
@@ -494,7 +496,7 @@ static void bond_ipsec_add_sa_all(struct bonding *bond)
 	spin_lock_bh(&bond->ipsec_lock);
 	list_for_each_entry(ipsec, &bond->ipsec_list, list) {
 		ipsec->xs->xso.real_dev = slave->dev;
-		if (slave->dev->xfrmdev_ops->xdo_dev_state_add(ipsec->xs)) {
+		if (slave->dev->xfrmdev_ops->xdo_dev_state_add(ipsec->xs, NULL)) {
 			slave_warn(bond_dev, slave->dev, "%s: failed to add SA\n", __func__);
 			ipsec->xs->xso.real_dev = NULL;
 		}
diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
index 9cbce1faab26..6c0a41f3ae44 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c
@@ -6490,7 +6490,8 @@ static const struct tlsdev_ops cxgb4_ktls_ops = {
 
 #if IS_ENABLED(CONFIG_CHELSIO_IPSEC_INLINE)
 
-static int cxgb4_xfrm_add_state(struct xfrm_state *x)
+static int cxgb4_xfrm_add_state(struct xfrm_state *x,
+				struct netlink_ext_ack *extack)
 {
 	struct adapter *adap = netdev2adap(x->xso.dev);
 	int ret;
@@ -6504,7 +6505,7 @@ static int cxgb4_xfrm_add_state(struct xfrm_state *x)
 	if (ret)
 		goto out_unlock;
 
-	ret = adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_state_add(x);
+	ret = adap->uld[CXGB4_ULD_IPSEC].xfrmdev_ops->xdo_dev_state_add(x, extack);
 
 out_unlock:
 	mutex_unlock(&uld_mutex);
diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
index ca21794281d6..ac2ea6206af1 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ipsec/chcr_ipsec.c
@@ -80,7 +80,8 @@ static void *ch_ipsec_uld_add(const struct cxgb4_lld_info *infop);
 static void ch_ipsec_advance_esn_state(struct xfrm_state *x);
 static void ch_ipsec_xfrm_free_state(struct xfrm_state *x);
 static void ch_ipsec_xfrm_del_state(struct xfrm_state *x);
-static int ch_ipsec_xfrm_add_state(struct xfrm_state *x);
+static int ch_ipsec_xfrm_add_state(struct xfrm_state *x,
+				   struct netlink_ext_ack *extack);
 
 static const struct xfrmdev_ops ch_ipsec_xfrmdev_ops = {
 	.xdo_dev_state_add      = ch_ipsec_xfrm_add_state,
@@ -226,7 +227,8 @@ static int ch_ipsec_setkey(struct xfrm_state *x,
  * returns 0 on success, negative error if failed to send message to FPGA
  * positive error if FPGA returned a bad response
  */
-static int ch_ipsec_xfrm_add_state(struct xfrm_state *x)
+static int ch_ipsec_xfrm_add_state(struct xfrm_state *x,
+				   struct netlink_ext_ack *extack)
 {
 	struct ipsec_sa_entry *sa_entry;
 	int res = 0;
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
index 53a969e34883..07c37dc619e8 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_ipsec.c
@@ -557,8 +557,10 @@ static int ixgbe_ipsec_check_mgmt_ip(struct xfrm_state *xs)
 /**
  * ixgbe_ipsec_add_sa - program device with a security association
  * @xs: pointer to transformer state struct
+ * @extack: extack point to fill failure reason
  **/
-static int ixgbe_ipsec_add_sa(struct xfrm_state *xs)
+static int ixgbe_ipsec_add_sa(struct xfrm_state *xs,
+			      struct netlink_ext_ack *extack)
 {
 	struct net_device *dev = xs->xso.real_dev;
 	struct ixgbe_adapter *adapter = netdev_priv(dev);
@@ -950,7 +952,7 @@ int ixgbe_ipsec_vf_add_sa(struct ixgbe_adapter *adapter, u32 *msgbuf, u32 vf)
 	memcpy(xs->aead->alg_name, aes_gcm_name, sizeof(aes_gcm_name));
 
 	/* set up the HW offload */
-	err = ixgbe_ipsec_add_sa(xs);
+	err = ixgbe_ipsec_add_sa(xs, NULL);
 	if (err)
 		goto err_aead;
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ipsec.c b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
index c1cf540d162a..752b9df4fb51 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ipsec.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ipsec.c
@@ -257,8 +257,10 @@ static int ixgbevf_ipsec_parse_proto_keys(struct xfrm_state *xs,
 /**
  * ixgbevf_ipsec_add_sa - program device with a security association
  * @xs: pointer to transformer state struct
+ * @extack: extack point to fill failure reason
  **/
-static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs)
+static int ixgbevf_ipsec_add_sa(struct xfrm_state *xs,
+				struct netlink_ext_ack *extack)
 {
 	struct net_device *dev = xs->xso.real_dev;
 	struct ixgbevf_adapter *adapter;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 3236c3b43149..a889df77dd2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -298,7 +298,8 @@ static void _update_xfrm_state(struct work_struct *work)
 	mlx5_accel_esp_modify_xfrm(sa_entry, &modify_work->attrs);
 }
 
-static int mlx5e_xfrm_add_state(struct xfrm_state *x)
+static int mlx5e_xfrm_add_state(struct xfrm_state *x,
+				struct netlink_ext_ack *extack)
 {
 	struct mlx5e_ipsec_sa_entry *sa_entry = NULL;
 	struct net_device *netdev = x->xso.real_dev;
diff --git a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
index 4632268695cb..41b98f2b7402 100644
--- a/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
+++ b/drivers/net/ethernet/netronome/nfp/crypto/ipsec.c
@@ -260,7 +260,8 @@ static void set_sha2_512hmac(struct nfp_ipsec_cfg_add_sa *cfg, int *trunc_len)
 	}
 }
 
-static int nfp_net_xfrm_add_state(struct xfrm_state *x)
+static int nfp_net_xfrm_add_state(struct xfrm_state *x,
+				  struct netlink_ext_ack *extack)
 {
 	struct net_device *netdev = x->xso.dev;
 	struct nfp_ipsec_cfg_mssg msg = {};
diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.c
index b93baf5c8bee..84a02d69abad 100644
--- a/drivers/net/netdevsim/ipsec.c
+++ b/drivers/net/netdevsim/ipsec.c
@@ -125,7 +125,8 @@ static int nsim_ipsec_parse_proto_keys(struct xfrm_state *xs,
 	return 0;
 }
 
-static int nsim_ipsec_add_sa(struct xfrm_state *xs)
+static int nsim_ipsec_add_sa(struct xfrm_state *xs,
+			     struct netlink_ext_ack *extack)
 {
 	struct nsim_ipsec *ipsec;
 	struct net_device *dev;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7c43b9fb9aae..63b77cbc947e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1035,7 +1035,7 @@ struct netdev_bpf {
 
 #ifdef CONFIG_XFRM_OFFLOAD
 struct xfrmdev_ops {
-	int	(*xdo_dev_state_add) (struct xfrm_state *x);
+	int	(*xdo_dev_state_add) (struct xfrm_state *x, struct netlink_ext_ack *extack);
 	void	(*xdo_dev_state_delete) (struct xfrm_state *x);
 	void	(*xdo_dev_state_free) (struct xfrm_state *x);
 	bool	(*xdo_dev_offload_ok) (struct sk_buff *skb,
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 2cec637a4a9c..562b9d951598 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -309,7 +309,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	else
 		xso->type = XFRM_DEV_OFFLOAD_CRYPTO;
 
-	err = dev->xfrmdev_ops->xdo_dev_state_add(x);
+	err = dev->xfrmdev_ops->xdo_dev_state_add(x, extack);
 	if (err) {
 		xso->dev = NULL;
 		xso->dir = 0;
@@ -325,10 +325,8 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 		 * authors to do not return -EOPNOTSUPP in packet offload mode.
 		 */
 		WARN_ON(err == -EOPNOTSUPP && is_packet_offload);
-		if (err != -EOPNOTSUPP || is_packet_offload) {
-			NL_SET_ERR_MSG(extack, "Device failed to offload this state");
+		if (err != -EOPNOTSUPP || is_packet_offload)
 			return err;
-		}
 	}
 
 	return 0;
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 89c731f4f0c7..59fffa02d1cc 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1274,7 +1274,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			xso->real_dev = xdo->real_dev;
 			netdev_tracker_alloc(xso->dev, &xso->dev_tracker,
 					     GFP_ATOMIC);
-			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x);
+			error = xso->dev->xfrmdev_ops->xdo_dev_state_add(x, NULL);
 			if (error) {
 				xso->dir = 0;
 				netdev_put(xso->dev, &xso->dev_tracker);
-- 
2.39.1

