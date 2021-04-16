Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C7A236281B
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 20:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239183AbhDPSzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 14:55:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236487AbhDPSzK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 14:55:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9268F613C3;
        Fri, 16 Apr 2021 18:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618599285;
        bh=yEMI5vY4DLu3GQKKlohA0egK4JpdPurhelIisDsGNjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kIDoMY3ABNS1pWFLepqsgiUaSnznUNZuod6JAu41gfE6RdvmfKjLxFuKEuGE9+ZA0
         A+rb6otwNI3l06xDAt1/pWHQ6oA3YZV+vjDiyeQ4JEpKGlOw6C/7qIhBdv2DD9hmPU
         vWJkqw/vDtk7cke+9Hk4ghOV/ifDorm6cXLLw5Jcq0wmbWVZZF0JqBnem5s2tEJz4D
         RU9fyrzSveMw58T8ZdDXuTuUCV5TlzOhl3I0TIxw/CeQjNkmixxvqWM65KmPPdP6Ve
         Sr8ucId3Eg0raDcNmb/Q+LvBk0SZI1L237Ox4gkdoU3wmbnrFGj3YmoLGCcmnOwHA+
         V9/TAWns5JSwg==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Tariq Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
        Moshe Tal <moshet@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 12/14] net/mlx5e: Add ethtool extended link state
Date:   Fri, 16 Apr 2021 11:54:28 -0700
Message-Id: <20210416185430.62584-13-saeed@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416185430.62584-1-saeed@kernel.org>
References: <20210416185430.62584-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Tal <moshet@nvidia.com>

In case the interface was set up but cannot establish the link, ethtool
will print more information to help the user troubleshoot the state.

For example, no link due to missing cable:
$ ethtool eth1
...
Link detected: no (No cable)

Beside the general extended state, drivers can pass additional
information about the link state using the sub-state field. For example:

$ ethtool eth1
...
Link detected: no (Autoneg, No partner detected)

The extended state is available only for specific cases, in other cases
ethtool with print only "Link detected: no" as before

Signed-off-by: Moshe Tal <moshet@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 171 ++++++++++++++++++
 1 file changed, 171 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index ef4a330c4cfa..e1d3cd1f1f11 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -2125,12 +2125,183 @@ int mlx5e_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *cmd)
 	return mlx5e_ethtool_set_rxnfc(dev, cmd);
 }
 
+static int query_port_status_opcode(struct mlx5_core_dev *mdev, u32 *status_opcode)
+{
+	struct mlx5_ifc_pddr_troubleshooting_page_bits *pddr_troubleshooting_page;
+	u32 in[MLX5_ST_SZ_DW(pddr_reg)] = {};
+	u32 out[MLX5_ST_SZ_DW(pddr_reg)];
+	int err;
+
+	MLX5_SET(pddr_reg, in, local_port, 1);
+	MLX5_SET(pddr_reg, in, page_select,
+		 MLX5_PDDR_REG_PAGE_SELECT_TROUBLESHOOTING_INFO_PAGE);
+
+	pddr_troubleshooting_page = MLX5_ADDR_OF(pddr_reg, in, page_data);
+	MLX5_SET(pddr_troubleshooting_page, pddr_troubleshooting_page,
+		 group_opcode, MLX5_PDDR_REG_TRBLSH_GROUP_OPCODE_MONITOR);
+	err = mlx5_core_access_reg(mdev, in, sizeof(in), out,
+				   sizeof(out), MLX5_REG_PDDR, 0, 0);
+	if (err)
+		return err;
+
+	pddr_troubleshooting_page = MLX5_ADDR_OF(pddr_reg, out, page_data);
+	*status_opcode = MLX5_GET(pddr_troubleshooting_page, pddr_troubleshooting_page,
+				  status_opcode);
+	return 0;
+}
+
+struct mlx5e_ethtool_link_ext_state_opcode_mapping {
+	u32 status_opcode;
+	enum ethtool_link_ext_state link_ext_state;
+	u8 link_ext_substate;
+};
+
+static const struct mlx5e_ethtool_link_ext_state_opcode_mapping
+mlx5e_link_ext_state_opcode_map[] = {
+	/* States relating to the autonegotiation or issues therein */
+	{2, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED},
+	{3, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED},
+	{4, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED},
+	{36, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE},
+	{38, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE},
+	{39, ETHTOOL_LINK_EXT_STATE_AUTONEG,
+		ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD},
+
+	/* Failure during link training */
+	{5, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED},
+	{6, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT},
+	{7, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY},
+	{8, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE, 0},
+	{14, ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT},
+
+	/* Logical mismatch in physical coding sublayer or forward error correction sublayer */
+	{9, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK},
+	{10, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK},
+	{11, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS},
+	{12, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED},
+	{13, ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED},
+
+	/* Signal integrity issues */
+	{15, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY, 0},
+	{17, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS},
+	{42, ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE},
+
+	/* No cable connected */
+	{1024, ETHTOOL_LINK_EXT_STATE_NO_CABLE, 0},
+
+	/* Failure is related to cable, e.g., unsupported cable */
+	{16, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{20, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{29, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{1025, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{1029, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE},
+	{1031, ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE, 0},
+
+	/* Failure is related to EEPROM, e.g., failure during reading or parsing the data */
+	{1027, ETHTOOL_LINK_EXT_STATE_EEPROM_ISSUE, 0},
+
+	/* Failure during calibration algorithm */
+	{23, ETHTOOL_LINK_EXT_STATE_CALIBRATION_FAILURE, 0},
+
+	/* The hardware is not able to provide the power required from cable or module */
+	{1032, ETHTOOL_LINK_EXT_STATE_POWER_BUDGET_EXCEEDED, 0},
+
+	/* The module is overheated */
+	{1030, ETHTOOL_LINK_EXT_STATE_OVERHEAT, 0},
+};
+
+static void
+mlx5e_set_link_ext_state(struct mlx5e_ethtool_link_ext_state_opcode_mapping
+			 link_ext_state_mapping,
+			 struct ethtool_link_ext_state_info *link_ext_state_info)
+{
+	switch (link_ext_state_mapping.link_ext_state) {
+	case ETHTOOL_LINK_EXT_STATE_AUTONEG:
+		link_ext_state_info->autoneg =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE:
+		link_ext_state_info->link_training =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH:
+		link_ext_state_info->link_logical_mismatch =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY:
+		link_ext_state_info->bad_signal_integrity =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	case ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE:
+		link_ext_state_info->cable_issue =
+			link_ext_state_mapping.link_ext_substate;
+		break;
+	default:
+		break;
+	}
+
+	link_ext_state_info->link_ext_state = link_ext_state_mapping.link_ext_state;
+}
+
+static int
+mlx5e_get_link_ext_state(struct net_device *dev,
+			 struct ethtool_link_ext_state_info *link_ext_state_info)
+{
+	struct mlx5e_ethtool_link_ext_state_opcode_mapping link_ext_state_mapping;
+	struct mlx5e_priv *priv = netdev_priv(dev);
+	u32 status_opcode = 0;
+	int i;
+
+	/* Exit without data if the interface state is OK, since no extended data is
+	 * available in such case
+	 */
+	if (netif_carrier_ok(dev))
+		return -ENODATA;
+
+	if (query_port_status_opcode(priv->mdev, &status_opcode) ||
+	    !status_opcode)
+		return -ENODATA;
+
+	for (i = 0; i < ARRAY_SIZE(mlx5e_link_ext_state_opcode_map); i++) {
+		link_ext_state_mapping = mlx5e_link_ext_state_opcode_map[i];
+		if (link_ext_state_mapping.status_opcode == status_opcode) {
+			mlx5e_set_link_ext_state(link_ext_state_mapping,
+						 link_ext_state_info);
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
+
 const struct ethtool_ops mlx5e_ethtool_ops = {
 	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
 				     ETHTOOL_COALESCE_MAX_FRAMES |
 				     ETHTOOL_COALESCE_USE_ADAPTIVE,
 	.get_drvinfo       = mlx5e_get_drvinfo,
 	.get_link          = ethtool_op_get_link,
+	.get_link_ext_state  = mlx5e_get_link_ext_state,
 	.get_strings       = mlx5e_get_strings,
 	.get_sset_count    = mlx5e_get_sset_count,
 	.get_ethtool_stats = mlx5e_get_ethtool_stats,
-- 
2.30.2

