Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7022941D521
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 10:05:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349262AbhI3IGr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 04:06:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348974AbhI3IE6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 04:04:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 81832615E0;
        Thu, 30 Sep 2021 08:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632988995;
        bh=15PY2ejusdGx6QhwsKMJIrqBAsRGLqhJhT1VDDbuxRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oSta9PKCgI/jUeKVYG5jXBfVT5WO3vph5WWIhzutpR4Of1io1wPAEDNGNHc6cftps
         zzeC8aRjGiUbJnm6d74WfkKHhk42oaBVizJZxPGH9HpcOr39lfo7ObkuLvXziBGcpy
         FEHyGAkJP3B5bCWXSRg+1f22xQOiU2MbyIOGEToLnu106nEQcVryWbw3HJjUkDAg/1
         YR5bc3Cq8inbH/O6GzJjd7E2o4W15F5F3XfiYS2Y9x3Zca6RfjATUsHeIP1UouVlUv
         dhTa93DaICd8prRoOb2HNcHH6rBUIDAlMI/NLMVjhfJY7aHlN+5uQnA0e6c6cJV/R1
         Nt+fnTJTiw2lQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Cc:     Aharon Landau <aharonl@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH rdma-next v2 10/13] RDMA/mlx5: Add steering support in optional flow counters
Date:   Thu, 30 Sep 2021 11:02:26 +0300
Message-Id: <f474ff458261b1e178762ab22c72d19a1f6b212d.1632988543.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Adding steering infrastructure for adding and removing optional counter.
This allows to add and remove the counters dynamically in order not to
hurt performance.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/fs.c      | 187 +++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  24 ++++
 include/rdma/ib_hdrs.h               |   1 +
 3 files changed, 212 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/fs.c b/drivers/infiniband/hw/mlx5/fs.c
index 5fbc0a8454b9..b780185d9dc6 100644
--- a/drivers/infiniband/hw/mlx5/fs.c
+++ b/drivers/infiniband/hw/mlx5/fs.c
@@ -10,12 +10,14 @@
 #include <rdma/uverbs_std_types.h>
 #include <rdma/mlx5_user_ioctl_cmds.h>
 #include <rdma/mlx5_user_ioctl_verbs.h>
+#include <rdma/ib_hdrs.h>
 #include <rdma/ib_umem.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/fs_helpers.h>
 #include <linux/mlx5/accel.h>
 #include <linux/mlx5/eswitch.h>
+#include <net/inet_ecn.h>
 #include "mlx5_ib.h"
 #include "counters.h"
 #include "devx.h"
@@ -847,6 +849,191 @@ static struct mlx5_ib_flow_prio *get_flow_table(struct mlx5_ib_dev *dev,
 	return prio;
 }
 
+enum {
+	RDMA_RX_ECN_OPCOUNTER_PRIO,
+	RDMA_RX_CNP_OPCOUNTER_PRIO,
+};
+
+enum {
+	RDMA_TX_CNP_OPCOUNTER_PRIO,
+};
+
+static int set_vhca_port_spec(struct mlx5_ib_dev *dev, u32 port_num,
+			      struct mlx5_flow_spec *spec)
+{
+	if (!MLX5_CAP_FLOWTABLE_RDMA_RX(dev->mdev,
+					ft_field_support.source_vhca_port) ||
+	    !MLX5_CAP_FLOWTABLE_RDMA_TX(dev->mdev,
+					ft_field_support.source_vhca_port))
+		return -EOPNOTSUPP;
+
+	MLX5_SET_TO_ONES(fte_match_param, &spec->match_criteria,
+			 misc_parameters.source_vhca_port);
+	MLX5_SET(fte_match_param, &spec->match_value,
+		 misc_parameters.source_vhca_port, port_num);
+
+	return 0;
+}
+
+static int set_ecn_ce_spec(struct mlx5_ib_dev *dev, u32 port_num,
+			   struct mlx5_flow_spec *spec, int ipv)
+{
+	if (!MLX5_CAP_FLOWTABLE_RDMA_RX(dev->mdev,
+					ft_field_support.outer_ip_version))
+		return -EOPNOTSUPP;
+
+	if (mlx5_core_mp_enabled(dev->mdev) &&
+	    set_vhca_port_spec(dev, port_num, spec))
+		return -EOPNOTSUPP;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.ip_ecn);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_ecn,
+		 INET_ECN_CE);
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 outer_headers.ip_version);
+	MLX5_SET(fte_match_param, spec->match_value, outer_headers.ip_version,
+		 ipv);
+
+	spec->match_criteria_enable =
+		get_match_criteria_enable(spec->match_criteria);
+
+	return 0;
+}
+
+static int set_cnp_spec(struct mlx5_ib_dev *dev, u32 port_num,
+			struct mlx5_flow_spec *spec)
+{
+	if (mlx5_core_mp_enabled(dev->mdev) &&
+	    set_vhca_port_spec(dev, port_num, spec))
+		return -EOPNOTSUPP;
+
+	MLX5_SET_TO_ONES(fte_match_param, spec->match_criteria,
+			 misc_parameters.bth_opcode);
+	MLX5_SET(fte_match_param, spec->match_value, misc_parameters.bth_opcode,
+		 IB_BTH_OPCODE_CNP);
+
+	spec->match_criteria_enable =
+		get_match_criteria_enable(spec->match_criteria);
+
+	return 0;
+}
+
+int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
+			 struct mlx5_ib_op_fc *opfc,
+			 enum mlx5_ib_optional_counter_type type)
+{
+	enum mlx5_flow_namespace_type fn_type;
+	int priority, i, err, spec_num;
+	struct mlx5_flow_act flow_act = {};
+	struct mlx5_flow_destination dst;
+	struct mlx5_flow_namespace *ns;
+	struct mlx5_ib_flow_prio *prio;
+	struct mlx5_flow_spec *spec;
+
+	spec = kcalloc(MAX_OPFC_RULES, sizeof(*spec), GFP_KERNEL);
+	if (!spec)
+		return -ENOMEM;
+
+	switch (type) {
+	case MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS:
+		if (set_ecn_ce_spec(dev, port_num, &spec[0],
+				    MLX5_FS_IPV4_VERSION) ||
+		    set_ecn_ce_spec(dev, port_num, &spec[1],
+				    MLX5_FS_IPV6_VERSION)) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		spec_num = 2;
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS;
+		priority = RDMA_RX_ECN_OPCOUNTER_PRIO;
+		break;
+
+	case MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS:
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					ft_field_support_2_nic_receive_rdma.bth_opcode) ||
+		    set_cnp_spec(dev, port_num, &spec[0])) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		spec_num = 1;
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS;
+		priority = RDMA_RX_CNP_OPCOUNTER_PRIO;
+		break;
+
+	case MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS:
+		if (!MLX5_CAP_FLOWTABLE(dev->mdev,
+					ft_field_support_2_nic_transmit_rdma.bth_opcode) ||
+		    set_cnp_spec(dev, port_num, &spec[0])) {
+			err = -EOPNOTSUPP;
+			goto free;
+		}
+		spec_num = 1;
+		fn_type = MLX5_FLOW_NAMESPACE_RDMA_TX_COUNTERS;
+		priority = RDMA_TX_CNP_OPCOUNTER_PRIO;
+		break;
+
+	default:
+		err = -EOPNOTSUPP;
+		goto free;
+	}
+
+	ns = mlx5_get_flow_namespace(dev->mdev, fn_type);
+	if (!ns) {
+		err = -EOPNOTSUPP;
+		goto free;
+	}
+
+	prio = &dev->flow_db->opfcs[type];
+	if (!prio->flow_table) {
+		prio = _get_prio(ns, prio, priority,
+				 dev->num_ports * MAX_OPFC_RULES, 1, 0);
+		if (IS_ERR(prio)) {
+			err = PTR_ERR(prio);
+			goto free;
+		}
+	}
+
+	dst.type = MLX5_FLOW_DESTINATION_TYPE_COUNTER;
+	dst.counter_id = mlx5_fc_id(opfc->fc);
+
+	flow_act.action =
+		MLX5_FLOW_CONTEXT_ACTION_COUNT | MLX5_FLOW_CONTEXT_ACTION_ALLOW;
+
+	for (i = 0; i < spec_num; i++) {
+		opfc->rule[i] = mlx5_add_flow_rules(prio->flow_table, &spec[i],
+						    &flow_act, &dst, 1);
+		if (IS_ERR(opfc->rule[i])) {
+			err = PTR_ERR(opfc->rule[i]);
+			goto del_rules;
+		}
+	}
+	prio->refcount += spec_num;
+	kfree(spec);
+
+	return 0;
+
+del_rules:
+	for (i -= 1; i >= 0; i--)
+		mlx5_del_flow_rules(opfc->rule[i]);
+	put_flow_table(dev, prio, false);
+free:
+	kfree(spec);
+	return err;
+}
+
+void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
+			     struct mlx5_ib_op_fc *opfc,
+			     enum mlx5_ib_optional_counter_type type)
+{
+	int i;
+
+	for (i = 0; i < MAX_OPFC_RULES && opfc->rule[i]; i++) {
+		mlx5_del_flow_rules(opfc->rule[i]);
+		put_flow_table(dev, &dev->flow_db->opfcs[type], true);
+	}
+}
+
 static void set_underlay_qp(struct mlx5_ib_dev *dev,
 			    struct mlx5_flow_spec *spec,
 			    u32 underlay_qpn)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 8215d7ab579d..d81ff5078e5e 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -263,6 +263,14 @@ struct mlx5_ib_pp {
 	struct mlx5_core_dev *mdev;
 };
 
+enum mlx5_ib_optional_counter_type {
+	MLX5_IB_OPCOUNTER_CC_RX_CE_PKTS,
+	MLX5_IB_OPCOUNTER_CC_RX_CNP_PKTS,
+	MLX5_IB_OPCOUNTER_CC_TX_CNP_PKTS,
+
+	MLX5_IB_OPCOUNTER_MAX,
+};
+
 struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	prios[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	egress_prios[MLX5_IB_NUM_FLOW_FT];
@@ -271,6 +279,7 @@ struct mlx5_ib_flow_db {
 	struct mlx5_ib_flow_prio	fdb;
 	struct mlx5_ib_flow_prio	rdma_rx[MLX5_IB_NUM_FLOW_FT];
 	struct mlx5_ib_flow_prio	rdma_tx[MLX5_IB_NUM_FLOW_FT];
+	struct mlx5_ib_flow_prio	opfcs[MLX5_IB_OPCOUNTER_MAX];
 	struct mlx5_flow_table		*lag_demux_ft;
 	/* Protect flow steering bypass flow tables
 	 * when add/del flow rules.
@@ -797,6 +806,13 @@ struct mlx5_ib_resources {
 	struct mlx5_ib_port_resources ports[2];
 };
 
+#define MAX_OPFC_RULES 2
+
+struct mlx5_ib_op_fc {
+	struct mlx5_fc *fc;
+	struct mlx5_flow_handle *rule[MAX_OPFC_RULES];
+};
+
 struct mlx5_ib_counters {
 	struct rdma_stat_desc *descs;
 	size_t *offsets;
@@ -807,6 +823,14 @@ struct mlx5_ib_counters {
 	u16 set_id;
 };
 
+int mlx5_ib_fs_add_op_fc(struct mlx5_ib_dev *dev, u32 port_num,
+			 struct mlx5_ib_op_fc *opfc,
+			 enum mlx5_ib_optional_counter_type type);
+
+void mlx5_ib_fs_remove_op_fc(struct mlx5_ib_dev *dev,
+			     struct mlx5_ib_op_fc *opfc,
+			     enum mlx5_ib_optional_counter_type type);
+
 struct mlx5_ib_multiport_info;
 
 struct mlx5_ib_multiport {
diff --git a/include/rdma/ib_hdrs.h b/include/rdma/ib_hdrs.h
index 7e542205861c..8ae07c0ecdf7 100644
--- a/include/rdma/ib_hdrs.h
+++ b/include/rdma/ib_hdrs.h
@@ -232,6 +232,7 @@ static inline u32 ib_get_sqpn(struct ib_other_headers *ohdr)
 #define IB_BTH_SE_SHIFT	23
 #define IB_BTH_TVER_MASK	0xf
 #define IB_BTH_TVER_SHIFT	16
+#define IB_BTH_OPCODE_CNP	0x81
 
 static inline u8 ib_bth_get_pad(struct ib_other_headers *ohdr)
 {
-- 
2.31.1

