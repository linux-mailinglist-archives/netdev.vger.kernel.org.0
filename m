Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49F80179F06
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 06:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgCEFQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 00:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgCEFQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 00:16:39 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D8B2321744;
        Thu,  5 Mar 2020 05:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583385397;
        bh=H6xW/cxPjY8pSjieXGrtoYaPX/WYGvlxKcBrlPtqjBw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hdK11egxqTGDbI3NQHRarI4HtCPwBilmAWJUGGSTQ1vMp8Tzub0k0XEh38AerfXsL
         GccZUck2cdgDA8rO9JCbjqcn4pjmOZutHTt8Z5RSwMmTJhRtuuTpWyx438idZ1jD7B
         BElDFeUXFScvV9c1GyaHirXUnYWxGFm/+czXHya0=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     andrew@lunn.ch, ecree@solarflare.com, mkubecek@suse.cz,
        thomas.lendacky@amd.com, benve@cisco.com, _govind@gmx.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, snelson@pensando.io, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        jacob.e.keller@intel.com, alexander.h.duyck@linux.intel.com,
        michael.chan@broadcom.com, saeedm@mellanox.com, leon@kernel.org,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 08/12] ice: let core reject the unsupported coalescing parameters
Date:   Wed,  4 Mar 2020 21:15:38 -0800
Message-Id: <20200305051542.991898-9-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305051542.991898-1-kuba@kernel.org>
References: <20200305051542.991898-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Set ethtool_ops->supported_coalesce_params to let
the core reject unsupported coalescing parameters.

This driver correctly rejects all unsupported parameters.
As a side effect of these changes the info message about
the bad parameter will no longer be printed. We also
always reject the tx_coalesce_usecs_high param, even
if the target queue pair does not have a TX queue.
Error code changes from EINVAL to EOPNOTSUPP.

v2: allow adaptive TX
v3: adjust commit message for new error code and member name

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_ethtool.c | 59 +-------------------
 1 file changed, 3 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index ab37dddb225b..a016ab1f7f09 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -3452,12 +3452,6 @@ ice_set_rc_coalesce(enum ice_container_type c_type, struct ethtool_coalesce *ec,
 
 		break;
 	case ICE_TX_CONTAINER:
-		if (ec->tx_coalesce_usecs_high) {
-			netdev_info(vsi->netdev, "setting %s-usecs-high is not supported\n",
-				    c_type_str);
-			return -EINVAL;
-		}
-
 		use_adaptive_coalesce = ec->use_adaptive_tx_coalesce;
 		coalesce_usecs = ec->tx_coalesce_usecs;
 
@@ -3533,53 +3527,6 @@ ice_set_q_coalesce(struct ice_vsi *vsi, struct ethtool_coalesce *ec, int q_num)
 	return 0;
 }
 
-/**
- * ice_is_coalesce_param_invalid - check for unsupported coalesce parameters
- * @netdev: pointer to the netdev associated with this query
- * @ec: ethtool structure to fill with driver's coalesce settings
- *
- * Print netdev info if driver doesn't support one of the parameters
- * and return error. When any parameters will be implemented, remove only
- * this parameter from param array.
- */
-static int
-ice_is_coalesce_param_invalid(struct net_device *netdev,
-			      struct ethtool_coalesce *ec)
-{
-	struct ice_ethtool_not_used {
-		u32 value;
-		const char *name;
-	} param[] = {
-		{ec->stats_block_coalesce_usecs, "stats-block-usecs"},
-		{ec->rate_sample_interval, "sample-interval"},
-		{ec->pkt_rate_low, "pkt-rate-low"},
-		{ec->pkt_rate_high, "pkt-rate-high"},
-		{ec->rx_max_coalesced_frames, "rx-frames"},
-		{ec->rx_coalesce_usecs_irq, "rx-usecs-irq"},
-		{ec->rx_max_coalesced_frames_irq, "rx-frames-irq"},
-		{ec->tx_max_coalesced_frames, "tx-frames"},
-		{ec->tx_coalesce_usecs_irq, "tx-usecs-irq"},
-		{ec->tx_max_coalesced_frames_irq, "tx-frames-irq"},
-		{ec->rx_coalesce_usecs_low, "rx-usecs-low"},
-		{ec->rx_max_coalesced_frames_low, "rx-frames-low"},
-		{ec->tx_coalesce_usecs_low, "tx-usecs-low"},
-		{ec->tx_max_coalesced_frames_low, "tx-frames-low"},
-		{ec->rx_max_coalesced_frames_high, "rx-frames-high"},
-		{ec->tx_max_coalesced_frames_high, "tx-frames-high"}
-	};
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(param); i++) {
-		if (param[i].value) {
-			netdev_info(netdev, "Setting %s not supported\n",
-				    param[i].name);
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
 /**
  * ice_print_if_odd_usecs - print message if user tries to set odd [tx|rx]-usecs
  * @netdev: netdev used for print
@@ -3620,9 +3567,6 @@ __ice_set_coalesce(struct net_device *netdev, struct ethtool_coalesce *ec,
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
 
-	if (ice_is_coalesce_param_invalid(netdev, ec))
-		return -EINVAL;
-
 	if (q_num < 0) {
 		struct ice_q_vector *q_vector = vsi->q_vectors[0];
 		int v_idx;
@@ -3817,6 +3761,9 @@ ice_get_module_eeprom(struct net_device *netdev,
 }
 
 static const struct ethtool_ops ice_ethtool_ops = {
+	.supported_coalesce_params = ETHTOOL_COALESCE_USECS |
+				     ETHTOOL_COALESCE_USE_ADAPTIVE |
+				     ETHTOOL_COALESCE_RX_USECS_HIGH,
 	.get_link_ksettings	= ice_get_link_ksettings,
 	.set_link_ksettings	= ice_set_link_ksettings,
 	.get_drvinfo		= ice_get_drvinfo,
-- 
2.24.1

