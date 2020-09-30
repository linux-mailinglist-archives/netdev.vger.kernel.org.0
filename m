Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA5B27F275
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 21:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730158AbgI3TRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 15:17:14 -0400
Received: from inva021.nxp.com ([92.121.34.21]:45008 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730054AbgI3TRN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 15:17:13 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 48022200426;
        Wed, 30 Sep 2020 21:17:08 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id 39B9A20060D;
        Wed, 30 Sep 2020 21:17:08 +0200 (CEST)
Received: from fsr-ub1864-126.ea.freescale.net (fsr-ub1864-126.ea.freescale.net [10.171.82.212])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id D7606202DA;
        Wed, 30 Sep 2020 21:17:07 +0200 (CEST)
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     jiri@nvidia.com, idosch@nvidia.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v2 4/4] dpaa2-eth: add support for devlink parser error drop traps
Date:   Wed, 30 Sep 2020 22:16:45 +0300
Message-Id: <20200930191645.9520-5-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200930191645.9520-1-ioana.ciornei@nxp.com>
References: <20200930191645.9520-1-ioana.ciornei@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for the new group of devlink traps - PARSER_ERROR_DROPS.
This consists of registering the array of parser error drops supported,
controlling their action through the .trap_group_action_set() callback
and reporting an erroneous skb received on the error queue
appropriately.
DPAA2 devices do not support controlling the action of independent
parser error traps, thus the .trap_action_set() callback just returns an
EOPNOTSUPP while .trap_group_action_set() actually notifies the hardware
what it should do with a frame marked as having a header error.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
 - none

 .../freescale/dpaa2/dpaa2-eth-devlink.c       | 217 ++++++++++++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 100 ++++++++
 .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  68 +++++-
 3 files changed, 384 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
index 3691981f5165..8672295c2a1a 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.c
@@ -3,6 +3,33 @@
 /* Copyright 2020 NXP
  */
 
+#define DPAA2_ETH_TRAP_DROP(_id, _group_id)					\
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,					\
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, 0)
+
+static const struct devlink_trap_group dpaa2_eth_trap_groups_arr[] = {
+	DEVLINK_TRAP_GROUP_GENERIC(PARSER_ERROR_DROPS, 0),
+};
+
+static const struct devlink_trap dpaa2_eth_traps_arr[] = {
+	DPAA2_ETH_TRAP_DROP(VXLAN_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(LLC_SNAP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(VLAN_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(PPPOE_PPP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(MPLS_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(ARP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(IP_1_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(IP_N_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(GRE_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(UDP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(TCP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(IPSEC_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(SCTP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(DCCP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(GTP_PARSING, PARSER_ERROR_DROPS),
+	DPAA2_ETH_TRAP_DROP(ESP_PARSING, PARSER_ERROR_DROPS),
+};
+
 static int dpaa2_eth_dl_info_get(struct devlink *devlink,
 				 struct devlink_info_req *req,
 				 struct netlink_ext_ack *extack)
@@ -24,8 +51,140 @@ static int dpaa2_eth_dl_info_get(struct devlink *devlink,
 	return 0;
 }
 
+static struct dpaa2_eth_trap_item *
+dpaa2_eth_dl_trap_item_lookup(struct dpaa2_eth_priv *priv, u16 trap_id)
+{
+	struct dpaa2_eth_trap_data *dpaa2_eth_trap_data = priv->trap_data;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(dpaa2_eth_traps_arr); i++) {
+		if (dpaa2_eth_traps_arr[i].id == trap_id)
+			return &dpaa2_eth_trap_data->trap_items_arr[i];
+	}
+
+	return NULL;
+}
+
+struct dpaa2_eth_trap_item *dpaa2_eth_dl_get_trap(struct dpaa2_eth_priv *priv,
+						  struct dpaa2_fapr *fapr)
+{
+	struct dpaa2_faf_error_bit {
+		int position;
+		enum devlink_trap_generic_id trap_id;
+	} faf_bits[] = {
+		{ .position = 5,  .trap_id = DEVLINK_TRAP_GENERIC_ID_VXLAN_PARSING },
+		{ .position = 20, .trap_id = DEVLINK_TRAP_GENERIC_ID_LLC_SNAP_PARSING },
+		{ .position = 24, .trap_id = DEVLINK_TRAP_GENERIC_ID_VLAN_PARSING },
+		{ .position = 26, .trap_id = DEVLINK_TRAP_GENERIC_ID_PPPOE_PPP_PARSING },
+		{ .position = 29, .trap_id = DEVLINK_TRAP_GENERIC_ID_MPLS_PARSING },
+		{ .position = 31, .trap_id = DEVLINK_TRAP_GENERIC_ID_ARP_PARSING },
+		{ .position = 52, .trap_id = DEVLINK_TRAP_GENERIC_ID_IP_1_PARSING },
+		{ .position = 61, .trap_id = DEVLINK_TRAP_GENERIC_ID_IP_N_PARSING },
+		{ .position = 67, .trap_id = DEVLINK_TRAP_GENERIC_ID_GRE_PARSING },
+		{ .position = 71, .trap_id = DEVLINK_TRAP_GENERIC_ID_UDP_PARSING },
+		{ .position = 76, .trap_id = DEVLINK_TRAP_GENERIC_ID_TCP_PARSING },
+		{ .position = 80, .trap_id = DEVLINK_TRAP_GENERIC_ID_IPSEC_PARSING },
+		{ .position = 82, .trap_id = DEVLINK_TRAP_GENERIC_ID_SCTP_PARSING },
+		{ .position = 84, .trap_id = DEVLINK_TRAP_GENERIC_ID_DCCP_PARSING },
+		{ .position = 88, .trap_id = DEVLINK_TRAP_GENERIC_ID_GTP_PARSING },
+		{ .position = 90, .trap_id = DEVLINK_TRAP_GENERIC_ID_ESP_PARSING },
+	};
+	u64 faf_word;
+	u64 mask;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(faf_bits); i++) {
+		if (faf_bits[i].position < 32) {
+			/* Low part of FAF.
+			 * position ranges from 31 to 0, mask from 0 to 31.
+			 */
+			mask = 1ull << (31 - faf_bits[i].position);
+			faf_word = __le32_to_cpu(fapr->faf_lo);
+		} else {
+			/* High part of FAF.
+			 * position ranges from 95 to 32, mask from 0 to 63.
+			 */
+			mask = 1ull << (63 - (faf_bits[i].position - 32));
+			faf_word = __le64_to_cpu(fapr->faf_hi);
+		}
+		if (faf_word & mask)
+			return dpaa2_eth_dl_trap_item_lookup(priv, faf_bits[i].trap_id);
+	}
+	return NULL;
+}
+
+static int dpaa2_eth_dl_trap_init(struct devlink *devlink,
+				  const struct devlink_trap *trap,
+				  void *trap_ctx)
+{
+	struct dpaa2_eth_devlink_priv *dl_priv = devlink_priv(devlink);
+	struct dpaa2_eth_priv *priv = dl_priv->dpaa2_priv;
+	struct dpaa2_eth_trap_item *dpaa2_eth_trap_item;
+
+	dpaa2_eth_trap_item = dpaa2_eth_dl_trap_item_lookup(priv, trap->id);
+	if (WARN_ON(!dpaa2_eth_trap_item))
+		return -ENOENT;
+
+	dpaa2_eth_trap_item->trap_ctx = trap_ctx;
+
+	return 0;
+}
+
+static int dpaa2_eth_dl_trap_action_set(struct devlink *devlink,
+					const struct devlink_trap *trap,
+					enum devlink_trap_action action,
+					struct netlink_ext_ack *extack)
+{
+	/* No support for changing the action of an independent packet trap,
+	 * only per trap group - parser error drops
+	 */
+	return -EOPNOTSUPP;
+}
+
+static int dpaa2_eth_dl_trap_group_action_set(struct devlink *devlink,
+					      const struct devlink_trap_group *group,
+					      enum devlink_trap_action action,
+					      struct netlink_ext_ack *extack)
+{
+	struct dpaa2_eth_devlink_priv *dl_priv = devlink_priv(devlink);
+	struct dpaa2_eth_priv *priv = dl_priv->dpaa2_priv;
+	struct net_device *net_dev = priv->net_dev;
+	struct device *dev = net_dev->dev.parent;
+	struct dpni_error_cfg err_cfg = {0};
+	int err;
+
+	if (group->id != DEVLINK_TRAP_GROUP_GENERIC_ID_PARSER_ERROR_DROPS)
+		return -EOPNOTSUPP;
+
+	/* Configure handling of frames marked as errors from the parser */
+	err_cfg.errors = DPAA2_FAS_RX_ERR_MASK;
+	err_cfg.set_frame_annotation = 1;
+
+	switch (action) {
+	case DEVLINK_TRAP_ACTION_DROP:
+		err_cfg.error_action = DPNI_ERROR_ACTION_DISCARD;
+		break;
+	case DEVLINK_TRAP_ACTION_TRAP:
+		err_cfg.error_action = DPNI_ERROR_ACTION_SEND_TO_ERROR_QUEUE;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	err = dpni_set_errors_behavior(priv->mc_io, 0, priv->mc_token, &err_cfg);
+	if (err) {
+		dev_err(dev, "dpni_set_errors_behavior failed\n");
+		return err;
+	}
+
+	return 0;
+}
+
 static const struct devlink_ops dpaa2_eth_devlink_ops = {
 	.info_get = dpaa2_eth_dl_info_get,
+	.trap_init = dpaa2_eth_dl_trap_init,
+	.trap_action_set = dpaa2_eth_dl_trap_action_set,
+	.trap_group_action_set = dpaa2_eth_dl_trap_group_action_set,
 };
 
 int dpaa2_eth_dl_register(struct dpaa2_eth_priv *priv)
@@ -88,3 +247,61 @@ void dpaa2_eth_dl_port_del(struct dpaa2_eth_priv *priv)
 	devlink_port_type_clear(devlink_port);
 	devlink_port_unregister(devlink_port);
 }
+
+int dpaa2_eth_dl_traps_register(struct dpaa2_eth_priv *priv)
+{
+	struct dpaa2_eth_trap_data *dpaa2_eth_trap_data;
+	struct net_device *net_dev = priv->net_dev;
+	struct device *dev = net_dev->dev.parent;
+	int err;
+
+	dpaa2_eth_trap_data = kzalloc(sizeof(*dpaa2_eth_trap_data), GFP_KERNEL);
+	if (!dpaa2_eth_trap_data)
+		return -ENOMEM;
+	priv->trap_data = dpaa2_eth_trap_data;
+
+	dpaa2_eth_trap_data->trap_items_arr = kcalloc(ARRAY_SIZE(dpaa2_eth_traps_arr),
+						      sizeof(struct dpaa2_eth_trap_item),
+						      GFP_KERNEL);
+	if (!dpaa2_eth_trap_data->trap_items_arr) {
+		err = -ENOMEM;
+		goto trap_data_free;
+	}
+
+	err = devlink_trap_groups_register(priv->devlink, dpaa2_eth_trap_groups_arr,
+					   ARRAY_SIZE(dpaa2_eth_trap_groups_arr));
+	if (err) {
+		dev_err(dev, "devlink_trap_groups_register() = %d\n", err);
+		goto trap_items_arr_free;
+	}
+
+	err = devlink_traps_register(priv->devlink, dpaa2_eth_traps_arr,
+				     ARRAY_SIZE(dpaa2_eth_traps_arr), priv);
+	if (err) {
+		dev_err(dev, "devlink_traps_register() = %d\n", err);
+		goto trap_groups_unregiser;
+	}
+
+	return 0;
+
+trap_groups_unregiser:
+	devlink_trap_groups_unregister(priv->devlink, dpaa2_eth_trap_groups_arr,
+				       ARRAY_SIZE(dpaa2_eth_trap_groups_arr));
+trap_items_arr_free:
+	kfree(dpaa2_eth_trap_data->trap_items_arr);
+trap_data_free:
+	kfree(dpaa2_eth_trap_data);
+	priv->trap_data = NULL;
+
+	return err;
+}
+
+void dpaa2_eth_dl_traps_unregister(struct dpaa2_eth_priv *priv)
+{
+	devlink_traps_unregister(priv->devlink, dpaa2_eth_traps_arr,
+				 ARRAY_SIZE(dpaa2_eth_traps_arr));
+	devlink_trap_groups_unregister(priv->devlink, dpaa2_eth_trap_groups_arr,
+				       ARRAY_SIZE(dpaa2_eth_trap_groups_arr));
+	kfree(priv->trap_data->trap_items_arr);
+	kfree(priv->trap_data);
+}
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 29c1c9263422..4f75f6bda8e0 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -509,6 +509,58 @@ static void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
 	percpu_stats->rx_dropped++;
 }
 
+/* Processing of Rx frames received on the error FQ
+ * We check and print the error bits and then free the frame
+ */
+static void dpaa2_eth_rx_err(struct dpaa2_eth_priv *priv,
+			     struct dpaa2_eth_channel *ch,
+			     const struct dpaa2_fd *fd,
+			     struct dpaa2_eth_fq *fq __always_unused)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	dma_addr_t addr = dpaa2_fd_get_addr(fd);
+	u8 fd_format = dpaa2_fd_get_format(fd);
+	struct rtnl_link_stats64 *percpu_stats;
+	struct dpaa2_eth_trap_item *trap_item;
+	struct dpaa2_fapr *fapr;
+	struct sk_buff *skb;
+	void *buf_data;
+	void *vaddr;
+
+	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
+	dma_sync_single_for_cpu(dev, addr, priv->rx_buf_size,
+				DMA_BIDIRECTIONAL);
+
+	buf_data = vaddr + dpaa2_fd_get_offset(fd);
+
+	if (fd_format == dpaa2_fd_single) {
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
+			       DMA_BIDIRECTIONAL);
+		skb = dpaa2_eth_build_linear_skb(ch, fd, vaddr);
+	} else if (fd_format == dpaa2_fd_sg) {
+		dma_unmap_page(dev, addr, priv->rx_buf_size,
+			       DMA_BIDIRECTIONAL);
+		skb = dpaa2_eth_build_frag_skb(priv, ch, buf_data);
+		free_pages((unsigned long)vaddr, 0);
+	} else {
+		/* We don't support any other format */
+		dpaa2_eth_free_rx_fd(priv, fd, vaddr);
+		goto err_frame_format;
+	}
+
+	fapr = dpaa2_get_fapr(vaddr, false);
+	trap_item = dpaa2_eth_dl_get_trap(priv, fapr);
+	if (trap_item)
+		devlink_trap_report(priv->devlink, skb, trap_item->trap_ctx,
+				    &priv->devlink_port, NULL);
+	consume_skb(skb);
+
+err_frame_format:
+	percpu_stats = this_cpu_ptr(priv->percpu_stats);
+	percpu_stats->rx_errors++;
+	ch->buf_count--;
+}
+
 /* Consume all frames pull-dequeued into the store. This is the simplest way to
  * make sure we don't accidentally issue another volatile dequeue which would
  * overwrite (leak) frames already in the store.
@@ -2723,6 +2775,7 @@ static void dpaa2_eth_set_fq_affinity(struct dpaa2_eth_priv *priv)
 		fq = &priv->fq[i];
 		switch (fq->type) {
 		case DPAA2_RX_FQ:
+		case DPAA2_RX_ERR_FQ:
 			fq->target_cpu = rx_cpu;
 			rx_cpu = cpumask_next(rx_cpu, &priv->dpio_cpumask);
 			if (rx_cpu >= nr_cpu_ids)
@@ -2766,6 +2819,10 @@ static void dpaa2_eth_setup_fqs(struct dpaa2_eth_priv *priv)
 		}
 	}
 
+	/* We have exactly one Rx error queue per DPNI */
+	priv->fq[priv->num_fqs].type = DPAA2_RX_ERR_FQ;
+	priv->fq[priv->num_fqs++].consume = dpaa2_eth_rx_err;
+
 	/* For each FQ, decide on which core to process incoming frames */
 	dpaa2_eth_set_fq_affinity(priv);
 }
@@ -3341,6 +3398,38 @@ static int dpaa2_eth_setup_tx_flow(struct dpaa2_eth_priv *priv,
 	return 0;
 }
 
+static int setup_rx_err_flow(struct dpaa2_eth_priv *priv,
+			     struct dpaa2_eth_fq *fq)
+{
+	struct device *dev = priv->net_dev->dev.parent;
+	struct dpni_queue q = { { 0 } };
+	struct dpni_queue_id qid;
+	u8 q_opt = DPNI_QUEUE_OPT_USER_CTX | DPNI_QUEUE_OPT_DEST;
+	int err;
+
+	err = dpni_get_queue(priv->mc_io, 0, priv->mc_token,
+			     DPNI_QUEUE_RX_ERR, 0, 0, &q, &qid);
+	if (err) {
+		dev_err(dev, "dpni_get_queue() failed (%d)\n", err);
+		return err;
+	}
+
+	fq->fqid = qid.fqid;
+
+	q.destination.id = fq->channel->dpcon_id;
+	q.destination.type = DPNI_DEST_DPCON;
+	q.destination.priority = 1;
+	q.user_context = (u64)fq;
+	err = dpni_set_queue(priv->mc_io, 0, priv->mc_token,
+			     DPNI_QUEUE_RX_ERR, 0, 0, q_opt, &q);
+	if (err) {
+		dev_err(dev, "dpni_set_queue() failed (%d)\n", err);
+		return err;
+	}
+
+	return 0;
+}
+
 /* Supported header fields for Rx hash distribution key */
 static const struct dpaa2_eth_dist_fields dist_fields[] = {
 	{
@@ -3723,6 +3812,7 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 	err_cfg.errors = DPAA2_FAS_RX_ERR_MASK;
 	err_cfg.set_frame_annotation = 1;
 	err_cfg.error_action = DPNI_ERROR_ACTION_DISCARD;
+	// err_cfg.error_action = DPNI_ERROR_ACTION_SEND_TO_ERROR_QUEUE;
 	err = dpni_set_errors_behavior(priv->mc_io, 0, priv->mc_token,
 				       &err_cfg);
 	if (err) {
@@ -3739,6 +3829,9 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
 		case DPAA2_TX_CONF_FQ:
 			err = dpaa2_eth_setup_tx_flow(priv, &priv->fq[i]);
 			break;
+		case DPAA2_RX_ERR_FQ:
+			err = setup_rx_err_flow(priv, &priv->fq[i]);
+			break;
 		default:
 			dev_err(dev, "Invalid FQ type %d\n", priv->fq[i].type);
 			return -EINVAL;
@@ -4227,6 +4320,10 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 	if (err)
 		goto err_dl_register;
 
+	err = dpaa2_eth_dl_traps_register(priv);
+	if (err)
+		goto err_dl_trap_register;
+
 	err = dpaa2_eth_dl_port_add(priv);
 	if (err)
 		goto err_dl_port_add;
@@ -4247,6 +4344,8 @@ static int dpaa2_eth_probe(struct fsl_mc_device *dpni_dev)
 err_netdev_reg:
 	dpaa2_eth_dl_port_del(priv);
 err_dl_port_add:
+	dpaa2_eth_dl_traps_unregister(priv);
+err_dl_trap_register:
 	dpaa2_eth_dl_unregister(priv);
 err_dl_register:
 	dpaa2_eth_disconnect_mac(priv);
@@ -4304,6 +4403,7 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 	unregister_netdev(net_dev);
 
 	dpaa2_eth_dl_port_del(priv);
+	dpaa2_eth_dl_traps_unregister(priv);
 	dpaa2_eth_dl_unregister(priv);
 
 	if (priv->do_link_poll)
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
index 9da6fac7cfef..d236b8695c39 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
@@ -182,6 +182,49 @@ struct dpaa2_fas {
  */
 #define DPAA2_TS_OFFSET			0x8
 
+/* Frame annotation parse results */
+struct dpaa2_fapr {
+	/* 64-bit word 1 */
+	__le32 faf_lo;
+	__le16 faf_ext;
+	__le16 nxt_hdr;
+	/* 64-bit word 2 */
+	__le64 faf_hi;
+	/* 64-bit word 3 */
+	u8 last_ethertype_offset;
+	u8 vlan_tci_offset_n;
+	u8 vlan_tci_offset_1;
+	u8 llc_snap_offset;
+	u8 eth_offset;
+	u8 ip1_pid_offset;
+	u8 shim_offset_2;
+	u8 shim_offset_1;
+	/* 64-bit word 4 */
+	u8 l5_offset;
+	u8 l4_offset;
+	u8 gre_offset;
+	u8 l3_offset_n;
+	u8 l3_offset_1;
+	u8 mpls_offset_n;
+	u8 mpls_offset_1;
+	u8 pppoe_offset;
+	/* 64-bit word 5 */
+	__le16 running_sum;
+	__le16 gross_running_sum;
+	u8 ipv6_frag_offset;
+	u8 nxt_hdr_offset;
+	u8 routing_hdr_offset_2;
+	u8 routing_hdr_offset_1;
+	/* 64-bit word 6 */
+	u8 reserved[5]; /* Soft-parsing context */
+	u8 ip_proto_offset_n;
+	u8 nxt_hdr_frag_offset;
+	u8 parse_error_code;
+};
+
+#define DPAA2_FAPR_OFFSET		0x10
+#define DPAA2_FAPR_SIZE			sizeof((struct dpaa2_fapr))
+
 /* Frame annotation egress action descriptor */
 #define DPAA2_FAEAD_OFFSET		0x58
 
@@ -230,6 +273,11 @@ static inline __le64 *dpaa2_get_ts(void *buf_addr, bool swa)
 	return dpaa2_get_hwa(buf_addr, swa) + DPAA2_TS_OFFSET;
 }
 
+static inline struct dpaa2_fapr *dpaa2_get_fapr(void *buf_addr, bool swa)
+{
+	return dpaa2_get_hwa(buf_addr, swa) + DPAA2_FAPR_OFFSET;
+}
+
 static inline struct dpaa2_faead *dpaa2_get_faead(void *buf_addr, bool swa)
 {
 	return dpaa2_get_hwa(buf_addr, swa) + DPAA2_FAEAD_OFFSET;
@@ -344,8 +392,10 @@ struct dpaa2_eth_ch_stats {
 #define DPAA2_ETH_MAX_RX_QUEUES		\
 	(DPAA2_ETH_MAX_RX_QUEUES_PER_TC * DPAA2_ETH_MAX_TCS)
 #define DPAA2_ETH_MAX_TX_QUEUES		16
+#define DPAA2_ETH_MAX_RX_ERR_QUEUES	1
 #define DPAA2_ETH_MAX_QUEUES		(DPAA2_ETH_MAX_RX_QUEUES + \
-					DPAA2_ETH_MAX_TX_QUEUES)
+					DPAA2_ETH_MAX_TX_QUEUES + \
+					DPAA2_ETH_MAX_RX_ERR_QUEUES)
 #define DPAA2_ETH_MAX_NETDEV_QUEUES	\
 	(DPAA2_ETH_MAX_TX_QUEUES * DPAA2_ETH_MAX_TCS)
 
@@ -354,6 +404,7 @@ struct dpaa2_eth_ch_stats {
 enum dpaa2_eth_fq_type {
 	DPAA2_RX_FQ = 0,
 	DPAA2_TX_CONF_FQ,
+	DPAA2_RX_ERR_FQ
 };
 
 struct dpaa2_eth_priv;
@@ -427,6 +478,15 @@ struct dpaa2_eth_sgt_cache {
 	u16 count;
 };
 
+struct dpaa2_eth_trap_item {
+	void *trap_ctx;
+};
+
+struct dpaa2_eth_trap_data {
+	struct dpaa2_eth_trap_item *trap_items_arr;
+	struct dpaa2_eth_priv *priv;
+};
+
 /* Driver private data */
 struct dpaa2_eth_priv {
 	struct net_device *net_dev;
@@ -505,6 +565,7 @@ struct dpaa2_eth_priv {
 	 */
 	struct mutex		onestep_tstamp_lock;
 	struct devlink *devlink;
+	struct dpaa2_eth_trap_data *trap_data;
 	struct devlink_port devlink_port;
 };
 
@@ -649,4 +710,9 @@ void dpaa2_eth_dl_unregister(struct dpaa2_eth_priv *priv);
 int dpaa2_eth_dl_port_add(struct dpaa2_eth_priv *priv);
 void dpaa2_eth_dl_port_del(struct dpaa2_eth_priv *priv);
 
+int dpaa2_eth_dl_traps_register(struct dpaa2_eth_priv *priv);
+void dpaa2_eth_dl_traps_unregister(struct dpaa2_eth_priv *priv);
+
+struct dpaa2_eth_trap_item *dpaa2_eth_dl_get_trap(struct dpaa2_eth_priv *priv,
+						  struct dpaa2_fapr *fapr);
 #endif	/* __DPAA2_H */
-- 
2.28.0

