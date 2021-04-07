Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83D33562BE
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 06:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348566AbhDGEzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 00:55:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348533AbhDGEyr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 00:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BAF2613CF;
        Wed,  7 Apr 2021 04:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617771278;
        bh=X19N6v4C/ebV+USecBDWI4H4V7yrOLNdJm21H9xJyps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZ62VNbenvwzlPTVEQD3azgMQEs0HjzGpRCWW3VV1uOjEWtLFgzk2ICl4OlGHXNnL
         8nG7pG2bj6ijQRpDGWx0ZFPVZCOGhQBeeLKZ1buqbzIiS65gtPAn+wxg1EVSaaCh+f
         IOIFzmgDGetPxTq10SIIdAfB7hcNbNBLSI9HAY83qG1tQXLBGnFr23BxEvaZRHXHLE
         JkfsUyXVEBB1zhYatWKbE30DO0LxD1sk5wm0fHgSuzwx0BXNUuSSRj+4Ix22bB4hnr
         Y0rTj89+p/aeTw4wuoecRIkzZcwfNXUVd+vJ3BZbhVlZdwPldjy5ME372S29262QCT
         he6H7jtmT1Lrw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Chris Mi <cmi@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 07/13] net/mlx5e: TC, Parse sample action
Date:   Tue,  6 Apr 2021 21:54:15 -0700
Message-Id: <20210407045421.148987-8-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407045421.148987-1-saeed@kernel.org>
References: <20210407045421.148987-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chris Mi <cmi@nvidia.com>

Parse TC sample action and save sample parameters in flow attribute
data structure.

Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Oz Shlomo <ozsh@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en/tc_priv.h  |  1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 28 +++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/esw/sample.h  | 13 +++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 ++
 4 files changed, 44 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
index c223591ffc22..d1599b7b944b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_priv.h
@@ -27,6 +27,7 @@ enum {
 	MLX5E_TC_FLOW_FLAG_L3_TO_L2_DECAP        = MLX5E_TC_FLOW_BASE + 8,
 	MLX5E_TC_FLOW_FLAG_TUN_RX                = MLX5E_TC_FLOW_BASE + 9,
 	MLX5E_TC_FLOW_FLAG_FAILED                = MLX5E_TC_FLOW_BASE + 10,
+	MLX5E_TC_FLOW_FLAG_SAMPLE                = MLX5E_TC_FLOW_BASE + 11,
 };
 
 struct mlx5e_tc_flow_parse_attr {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index c938215c8fbc..85782d12ffb2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -47,6 +47,7 @@
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/tc_act/tc_mpls.h>
+#include <net/psample.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
 #include <net/bareudp.h>
@@ -1481,6 +1482,7 @@ static void mlx5e_tc_del_fdb_flow(struct mlx5e_priv *priv,
 	if (flow_flag_test(flow, L3_TO_L2_DECAP))
 		mlx5e_detach_decap(priv, flow);
 
+	kfree(flow->attr->esw_attr->sample);
 	kfree(flow->attr);
 }
 
@@ -3627,6 +3629,7 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 	bool ft_flow = mlx5e_is_ft_flow(flow);
 	const struct flow_action_entry *act;
 	struct mlx5_esw_flow_attr *esw_attr;
+	struct mlx5_sample_attr sample = {};
 	bool encap = false, decap = false;
 	u32 action = attr->action;
 	int err, i, if_count = 0;
@@ -3881,6 +3884,10 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			attr->dest_chain = act->chain_index;
 			break;
 		case FLOW_ACTION_CT:
+			if (flow_flag_test(flow, SAMPLE)) {
+				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
+				return -EOPNOTSUPP;
+			}
 			err = mlx5_tc_ct_parse_action(get_ct_priv(priv), attr, act, extack);
 			if (err)
 				return err;
@@ -3888,6 +3895,17 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 			flow_flag_set(flow, CT);
 			esw_attr->split_count = esw_attr->out_count;
 			break;
+		case FLOW_ACTION_SAMPLE:
+			if (flow_flag_test(flow, CT)) {
+				NL_SET_ERR_MSG_MOD(extack, "Sample action with connection tracking is not supported");
+				return -EOPNOTSUPP;
+			}
+			sample.rate = act->sample.rate;
+			sample.group_num = act->sample.psample_group->group_num;
+			if (act->sample.truncate)
+				sample.trunc_size = act->sample.trunc_size;
+			flow_flag_set(flow, SAMPLE);
+			break;
 		default:
 			NL_SET_ERR_MSG_MOD(extack, "The offload action is not supported");
 			return -EOPNOTSUPP;
@@ -3966,6 +3984,16 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *priv,
 		return -EOPNOTSUPP;
 	}
 
+	/* Allocate sample attribute only when there is a sample action and
+	 * no errors after parsing.
+	 */
+	if (flow_flag_test(flow, SAMPLE)) {
+		esw_attr->sample = kzalloc(sizeof(*esw_attr->sample), GFP_KERNEL);
+		if (!esw_attr->sample)
+			return -ENOMEM;
+		*esw_attr->sample = sample;
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
new file mode 100644
index 000000000000..35a5e6dddcd0
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/sample.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB */
+/* Copyright (c) 2021 Mellanox Technologies. */
+
+#ifndef __MLX5_EN_TC_SAMPLE_H__
+#define __MLX5_EN_TC_SAMPLE_H__
+
+struct mlx5_sample_attr {
+	u32 group_num;
+	u32 rate;
+	u32 trunc_size;
+};
+
+#endif /* __MLX5_EN_TC_SAMPLE_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index a97396330160..9b26bd67e2b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -46,6 +46,7 @@
 #include "lib/fs_chains.h"
 #include "sf/sf.h"
 #include "en/tc_ct.h"
+#include "esw/sample.h"
 
 enum mlx5_mapped_obj_type {
 	MLX5_MAPPED_OBJ_CHAIN,
@@ -440,6 +441,7 @@ struct mlx5_esw_flow_attr {
 	} dests[MLX5_MAX_FLOW_FWD_VPORTS];
 	struct mlx5_rx_tun_attr *rx_tun_attr;
 	struct mlx5_pkt_reformat *decap_pkt_reformat;
+	struct mlx5_sample_attr *sample;
 };
 
 int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
-- 
2.30.2

