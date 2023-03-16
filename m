Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F20B96BD134
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 14:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbjCPNqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 09:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCPNpu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 09:45:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D44C6439;
        Thu, 16 Mar 2023 06:45:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DEBC62039;
        Thu, 16 Mar 2023 13:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25406C4339B;
        Thu, 16 Mar 2023 13:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678974335;
        bh=2VJlSF5OJYls3zf5ftXi7SF1RFCTSEUlNaTp+sFR19o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UQVHYNQq/V6Mf80huaqxo2NCXsN0xliYBKRezJIP7AnxAfVIwNCvwbfl0TqAtBjMD
         HiIcGhgoJ1l7OJS9a/4xx4MjyGaS/hZQrk540O15OLbUwtCWekxJ/SUp/SmiiGGDy3
         uUF05Ax7YT2DPD+/O/de3Xl0gRguKzZmYvWdImVZpastjcNn7ZZaH/yBNIMDwHs/yf
         iH+kIxm4VTvw7OzojGBDqb4WHOUsw2/SnTRPc/kefoUj03kRSIqJ713XqLD3ahMRgb
         4JPHisfhG+F+H2wDR8MVdTckDsQ8mobYY0rNEJYswfUBn8jlSGDynfV9qRhf2F5CTf
         p+jaQkdj1/Rzg==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Patrisious Haddad <phaddad@nvidia.com>, linux-rdma@vger.kernel.org,
        Michael Guralnik <michaelgur@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH rdma-next 2/2] RDMA/mlx5: Expand switchdev Q-counters to expose representor statistics
Date:   Thu, 16 Mar 2023 15:45:21 +0200
Message-Id: <e95876903a368642d2730db1c5154677cdf65d35.1678974109.git.leon@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1678974109.git.leon@kernel.org>
References: <cover.1678974109.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrisious Haddad <phaddad@nvidia.com>

Previously for switchdev only per device counters were supported.

Currently we allocate counters for switchdev per port, which also
includes the ports that belong to VF representors in order to expose
them to users through the rdma tool, allowing the host to track the VFs
statistics through their representors counters.

Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/counters.c | 161 ++++++++++++++++++++++----
 1 file changed, 136 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 3e1272695d99..c52b6b3e983f 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -5,6 +5,7 @@
 
 #include "mlx5_ib.h"
 #include <linux/mlx5/eswitch.h>
+#include <linux/mlx5/vport.h>
 #include "counters.h"
 #include "ib_rep.h"
 #include "qp.h"
@@ -18,6 +19,10 @@ struct mlx5_ib_counter {
 #define INIT_Q_COUNTER(_name)		\
 	{ .name = #_name, .offset = MLX5_BYTE_OFF(query_q_counter_out, _name)}
 
+#define INIT_VPORT_Q_COUNTER(_name)		\
+	{ .name = "vport_" #_name, .offset =	\
+		MLX5_BYTE_OFF(query_q_counter_out, _name)}
+
 static const struct mlx5_ib_counter basic_q_cnts[] = {
 	INIT_Q_COUNTER(rx_write_requests),
 	INIT_Q_COUNTER(rx_read_requests),
@@ -37,6 +42,25 @@ static const struct mlx5_ib_counter retrans_q_cnts[] = {
 	INIT_Q_COUNTER(local_ack_timeout_err),
 };
 
+static const struct mlx5_ib_counter vport_basic_q_cnts[] = {
+	INIT_VPORT_Q_COUNTER(rx_write_requests),
+	INIT_VPORT_Q_COUNTER(rx_read_requests),
+	INIT_VPORT_Q_COUNTER(rx_atomic_requests),
+	INIT_VPORT_Q_COUNTER(out_of_buffer),
+};
+
+static const struct mlx5_ib_counter vport_out_of_seq_q_cnts[] = {
+	INIT_VPORT_Q_COUNTER(out_of_sequence),
+};
+
+static const struct mlx5_ib_counter vport_retrans_q_cnts[] = {
+	INIT_VPORT_Q_COUNTER(duplicate_request),
+	INIT_VPORT_Q_COUNTER(rnr_nak_retry_err),
+	INIT_VPORT_Q_COUNTER(packet_seq_err),
+	INIT_VPORT_Q_COUNTER(implied_nak_seq_err),
+	INIT_VPORT_Q_COUNTER(local_ack_timeout_err),
+};
+
 #define INIT_CONG_COUNTER(_name)		\
 	{ .name = #_name, .offset =	\
 		MLX5_BYTE_OFF(query_cong_statistics_out, _name ## _high)}
@@ -67,6 +91,25 @@ static const struct mlx5_ib_counter roce_accl_cnts[] = {
 	INIT_Q_COUNTER(roce_slow_restart_trans),
 };
 
+static const struct mlx5_ib_counter vport_extended_err_cnts[] = {
+	INIT_VPORT_Q_COUNTER(resp_local_length_error),
+	INIT_VPORT_Q_COUNTER(resp_cqe_error),
+	INIT_VPORT_Q_COUNTER(req_cqe_error),
+	INIT_VPORT_Q_COUNTER(req_remote_invalid_request),
+	INIT_VPORT_Q_COUNTER(req_remote_access_errors),
+	INIT_VPORT_Q_COUNTER(resp_remote_access_errors),
+	INIT_VPORT_Q_COUNTER(resp_cqe_flush_error),
+	INIT_VPORT_Q_COUNTER(req_cqe_flush_error),
+};
+
+static const struct mlx5_ib_counter vport_roce_accl_cnts[] = {
+	INIT_VPORT_Q_COUNTER(roce_adp_retrans),
+	INIT_VPORT_Q_COUNTER(roce_adp_retrans_to),
+	INIT_VPORT_Q_COUNTER(roce_slow_restart),
+	INIT_VPORT_Q_COUNTER(roce_slow_restart_cnps),
+	INIT_VPORT_Q_COUNTER(roce_slow_restart_trans),
+};
+
 #define INIT_EXT_PPCNT_COUNTER(_name)		\
 	{ .name = #_name, .offset =	\
 	MLX5_BYTE_OFF(ppcnt_reg, \
@@ -153,12 +196,20 @@ static int mlx5_ib_create_counters(struct ib_counters *counters,
 	return 0;
 }
 
+static bool vport_qcounters_supported(struct mlx5_ib_dev *dev)
+{
+	return MLX5_CAP_GEN(dev->mdev, q_counter_other_vport) &&
+	       MLX5_CAP_GEN(dev->mdev, q_counter_aggregation);
+}
 
 static const struct mlx5_ib_counters *get_counters(struct mlx5_ib_dev *dev,
 						   u32 port_num)
 {
-	return is_mdev_switchdev_mode(dev->mdev) ? &dev->port[0].cnts :
-						   &dev->port[port_num].cnts;
+	if ((is_mdev_switchdev_mode(dev->mdev) &&
+	     !vport_qcounters_supported(dev)) || !port_num)
+		return &dev->port[0].cnts;
+
+	return &dev->port[port_num - 1].cnts;
 }
 
 /**
@@ -172,7 +223,7 @@ static const struct mlx5_ib_counters *get_counters(struct mlx5_ib_dev *dev,
  */
 u16 mlx5_ib_get_counters_id(struct mlx5_ib_dev *dev, u32 port_num)
 {
-	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num);
+	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num + 1);
 
 	return cnts->set_id;
 }
@@ -270,12 +321,44 @@ static int mlx5_ib_query_ext_ppcnt_counters(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
+static int mlx5_ib_query_q_counters_vport(struct mlx5_ib_dev *dev,
+					  u32 port_num,
+					  const struct mlx5_ib_counters *cnts,
+					  struct rdma_hw_stats *stats)
+
+{
+	u32 out[MLX5_ST_SZ_DW(query_q_counter_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_q_counter_in)] = {};
+	__be32 val;
+	int ret, i;
+
+	if (!dev->port[port_num].rep ||
+	    dev->port[port_num].rep->vport == MLX5_VPORT_UPLINK)
+		return 0;
+
+	MLX5_SET(query_q_counter_in, in, opcode, MLX5_CMD_OP_QUERY_Q_COUNTER);
+	MLX5_SET(query_q_counter_in, in, other_vport, 1);
+	MLX5_SET(query_q_counter_in, in, vport_number,
+		 dev->port[port_num].rep->vport);
+	MLX5_SET(query_q_counter_in, in, aggregate, 1);
+	ret = mlx5_cmd_exec_inout(dev->mdev, query_q_counter, in, out);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < cnts->num_q_counters; i++) {
+		val = *(__be32 *)((void *)out + cnts->offsets[i]);
+		stats->value[i] = (u64)be32_to_cpu(val);
+	}
+
+	return 0;
+}
+
 static int do_get_hw_stats(struct ib_device *ibdev,
 			   struct rdma_hw_stats *stats,
 			   u32 port_num, int index)
 {
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
-	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num - 1);
+	const struct mlx5_ib_counters *cnts = get_counters(dev, port_num);
 	struct mlx5_core_dev *mdev;
 	int ret, num_counters;
 
@@ -286,11 +369,19 @@ static int do_get_hw_stats(struct ib_device *ibdev,
 		       cnts->num_cong_counters +
 		       cnts->num_ext_ppcnt_counters;
 
-	/* q_counters are per IB device, query the master mdev */
-	ret = mlx5_ib_query_q_counters(dev->mdev, cnts, stats, cnts->set_id);
+	if (is_mdev_switchdev_mode(dev->mdev) && dev->is_rep && port_num != 0)
+		ret = mlx5_ib_query_q_counters_vport(dev, port_num - 1, cnts,
+						     stats);
+	else
+		ret = mlx5_ib_query_q_counters(dev->mdev, cnts, stats,
+					       cnts->set_id);
 	if (ret)
 		return ret;
 
+	/* We dont expose device counters over Vports */
+	if (is_mdev_switchdev_mode(dev->mdev))
+		goto done;
+
 	if (MLX5_CAP_PCAM_FEATURE(dev->mdev, rx_icrc_encapsulated_counter)) {
 		ret =  mlx5_ib_query_ext_ppcnt_counters(dev, cnts, stats);
 		if (ret)
@@ -335,7 +426,8 @@ static int do_get_op_stat(struct ib_device *ibdev,
 	u32 type;
 	int ret;
 
-	cnts = get_counters(dev, port_num - 1);
+	cnts = get_counters(dev, port_num);
+
 	opfcs = cnts->opfcs;
 	type = *(u32 *)cnts->descs[index].priv;
 	if (type >= MLX5_IB_OPCOUNTER_MAX)
@@ -362,7 +454,7 @@ static int do_get_op_stats(struct ib_device *ibdev,
 	const struct mlx5_ib_counters *cnts;
 	int index, ret, num_hw_counters;
 
-	cnts = get_counters(dev, port_num - 1);
+	cnts = get_counters(dev, port_num);
 	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
 			  cnts->num_ext_ppcnt_counters;
 	for (index = num_hw_counters;
@@ -383,7 +475,7 @@ static int mlx5_ib_get_hw_stats(struct ib_device *ibdev,
 	struct mlx5_ib_dev *dev = to_mdev(ibdev);
 	const struct mlx5_ib_counters *cnts;
 
-	cnts = get_counters(dev, port_num - 1);
+	cnts = get_counters(dev, port_num);
 	num_hw_counters = cnts->num_q_counters + cnts->num_cong_counters +
 		cnts->num_ext_ppcnt_counters;
 	num_counters = num_hw_counters + cnts->num_op_counters;
@@ -410,8 +502,7 @@ static struct rdma_hw_stats *
 mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 {
 	struct mlx5_ib_dev *dev = to_mdev(counter->device);
-	const struct mlx5_ib_counters *cnts =
-		get_counters(dev, counter->port - 1);
+	const struct mlx5_ib_counters *cnts = get_counters(dev, counter->port);
 
 	return do_alloc_stats(cnts);
 }
@@ -419,8 +510,7 @@ mlx5_ib_counter_alloc_stats(struct rdma_counter *counter)
 static int mlx5_ib_counter_update_stats(struct rdma_counter *counter)
 {
 	struct mlx5_ib_dev *dev = to_mdev(counter->device);
-	const struct mlx5_ib_counters *cnts =
-		get_counters(dev, counter->port - 1);
+	const struct mlx5_ib_counters *cnts = get_counters(dev, counter->port);
 
 	return mlx5_ib_query_q_counters(dev->mdev, cnts,
 					counter->stats, counter->id);
@@ -481,42 +571,51 @@ static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp)
 static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 				  struct rdma_stat_desc *descs, size_t *offsets)
 {
-	int i;
-	int j = 0;
+	bool is_vport = is_mdev_switchdev_mode(dev->mdev);
+	const struct mlx5_ib_counter *names;
+	int j = 0, i;
 
+	names = is_vport ? vport_basic_q_cnts : basic_q_cnts;
 	for (i = 0; i < ARRAY_SIZE(basic_q_cnts); i++, j++) {
-		descs[j].name = basic_q_cnts[i].name;
+		descs[j].name = names[i].name;
 		offsets[j] = basic_q_cnts[i].offset;
 	}
 
+	names = is_vport ? vport_out_of_seq_q_cnts : out_of_seq_q_cnts;
 	if (MLX5_CAP_GEN(dev->mdev, out_of_seq_cnt)) {
 		for (i = 0; i < ARRAY_SIZE(out_of_seq_q_cnts); i++, j++) {
-			descs[j].name = out_of_seq_q_cnts[i].name;
+			descs[j].name = names[i].name;
 			offsets[j] = out_of_seq_q_cnts[i].offset;
 		}
 	}
 
+	names = is_vport ? vport_retrans_q_cnts : retrans_q_cnts;
 	if (MLX5_CAP_GEN(dev->mdev, retransmission_q_counters)) {
 		for (i = 0; i < ARRAY_SIZE(retrans_q_cnts); i++, j++) {
-			descs[j].name = retrans_q_cnts[i].name;
+			descs[j].name = names[i].name;
 			offsets[j] = retrans_q_cnts[i].offset;
 		}
 	}
 
+	names = is_vport ? vport_extended_err_cnts : extended_err_cnts;
 	if (MLX5_CAP_GEN(dev->mdev, enhanced_error_q_counters)) {
 		for (i = 0; i < ARRAY_SIZE(extended_err_cnts); i++, j++) {
-			descs[j].name = extended_err_cnts[i].name;
+			descs[j].name = names[i].name;
 			offsets[j] = extended_err_cnts[i].offset;
 		}
 	}
 
+	names = is_vport ? vport_roce_accl_cnts : roce_accl_cnts;
 	if (MLX5_CAP_GEN(dev->mdev, roce_accl)) {
 		for (i = 0; i < ARRAY_SIZE(roce_accl_cnts); i++, j++) {
-			descs[j].name = roce_accl_cnts[i].name;
+			descs[j].name = names[i].name;
 			offsets[j] = roce_accl_cnts[i].offset;
 		}
 	}
 
+	if (is_vport)
+		return;
+
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
 		for (i = 0; i < ARRAY_SIZE(cong_cnts); i++, j++) {
 			descs[j].name = cong_cnts[i].name;
@@ -560,7 +659,7 @@ static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
 static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 				    struct mlx5_ib_counters *cnts)
 {
-	u32 num_counters, num_op_counters;
+	u32 num_counters, num_op_counters = 0;
 
 	num_counters = ARRAY_SIZE(basic_q_cnts);
 
@@ -578,6 +677,9 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 
 	cnts->num_q_counters = num_counters;
 
+	if (is_mdev_switchdev_mode(dev->mdev))
+		goto skip_non_qcounters;
+
 	if (MLX5_CAP_GEN(dev->mdev, cc_query_allowed)) {
 		cnts->num_cong_counters = ARRAY_SIZE(cong_cnts);
 		num_counters += ARRAY_SIZE(cong_cnts);
@@ -597,6 +699,7 @@ static int __mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev,
 			       ft_field_support_2_nic_transmit_rdma.bth_opcode))
 		num_op_counters += ARRAY_SIZE(rdmatx_cnp_op_cnts);
 
+skip_non_qcounters:
 	cnts->num_op_counters = num_op_counters;
 	num_counters += num_op_counters;
 	cnts->descs = kcalloc(num_counters,
@@ -623,7 +726,8 @@ static void mlx5_ib_dealloc_counters(struct mlx5_ib_dev *dev)
 	int num_cnt_ports;
 	int i, j;
 
-	num_cnt_ports = is_mdev_switchdev_mode(dev->mdev) ? 1 : dev->num_ports;
+	num_cnt_ports = (!is_mdev_switchdev_mode(dev->mdev) ||
+			 vport_qcounters_supported(dev)) ? dev->num_ports : 1;
 
 	MLX5_SET(dealloc_q_counter_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_Q_COUNTER);
@@ -662,7 +766,8 @@ static int mlx5_ib_alloc_counters(struct mlx5_ib_dev *dev)
 
 	MLX5_SET(alloc_q_counter_in, in, opcode, MLX5_CMD_OP_ALLOC_Q_COUNTER);
 	is_shared = MLX5_CAP_GEN(dev->mdev, log_max_uctx) != 0;
-	num_cnt_ports = is_mdev_switchdev_mode(dev->mdev) ? 1 : dev->num_ports;
+	num_cnt_ports = (!is_mdev_switchdev_mode(dev->mdev) ||
+			 vport_qcounters_supported(dev)) ? dev->num_ports : 1;
 
 	for (i = 0; i < num_cnt_ports; i++) {
 		err = __mlx5_ib_alloc_counters(dev, &dev->port[i].cnts);
@@ -889,6 +994,10 @@ static const struct ib_device_ops hw_stats_ops = {
 			  mlx5_ib_modify_stat : NULL,
 };
 
+static const struct ib_device_ops hw_switchdev_vport_op = {
+	.alloc_hw_port_stats = mlx5_ib_alloc_hw_port_stats,
+};
+
 static const struct ib_device_ops hw_switchdev_stats_ops = {
 	.alloc_hw_device_stats = mlx5_ib_alloc_hw_device_stats,
 	.get_hw_stats = mlx5_ib_get_hw_stats,
@@ -914,9 +1023,11 @@ int mlx5_ib_counters_init(struct mlx5_ib_dev *dev)
 	if (!MLX5_CAP_GEN(dev->mdev, max_qp_cnt))
 		return 0;
 
-	if (is_mdev_switchdev_mode(dev->mdev))
+	if (is_mdev_switchdev_mode(dev->mdev)) {
 		ib_set_device_ops(&dev->ib_dev, &hw_switchdev_stats_ops);
-	else
+		if (vport_qcounters_supported(dev))
+			ib_set_device_ops(&dev->ib_dev, &hw_switchdev_vport_op);
+	} else
 		ib_set_device_ops(&dev->ib_dev, &hw_stats_ops);
 	return mlx5_ib_alloc_counters(dev);
 }
-- 
2.39.2

