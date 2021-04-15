Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FD03615B9
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 00:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237627AbhDOWx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 18:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237565AbhDOWxr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 18:53:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 205BB61158;
        Thu, 15 Apr 2021 22:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618527203;
        bh=U/7c/BzMyp342B61s/mOhMmsl9YLW6f236Yuf7AG7C0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nUsxGVry6rNmSSuo1CHfe1qLMuKASvs9cnfit9wdfQuITATDUGvM99CaVQUW/7bc6
         ZfYyVE70AXMqGOs27gWlNg7irFhxhxC23nASf7Tz65WbjZRphJV7+fJviq8gCbGTfd
         r0RNRIsWY6CICdKkoRklRQyZpQR98VFft9X/fFXffHbmkeC64eqcjc1g/ZjjkZAp1d
         n9NwJDtG4WI291kTLmvIRX94u1bXUStl5AyTQJoLWe9xaFRSKwAkGuw3HMcltU0541
         7ZHkCt/ileNad6iREsxTv1cuvf5K8X1QsnB5U+NcG96Aqt+teWOEuiNoZ4DtrcfYNF
         8WdduWy2ICUHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, michael.chan@broadcom.com,
        saeedm@nvidia.com, leon@kernel.org, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        mkubecek@suse.cz, ariela@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 5/6] sfc: ef10: implement ethtool::get_fec_stats
Date:   Thu, 15 Apr 2021 15:53:17 -0700
Message-Id: <20210415225318.2726095-6-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210415225318.2726095-1-kuba@kernel.org>
References: <20210415225318.2726095-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Report what appears to be the standard block counts:
 - 30.5.1.1.17 aFECCorrectedBlocks
 - 30.5.1.1.18 aFECUncorrectableBlocks

Don't report the per-lane symbol counts, if those really
count symbols they are not what the standard calls for
(even if symbols seem like the most useful thing to count.)

Fingers crossed that fec_corrected_errors is not in symbols.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c       | 17 +++++++++++++++++
 drivers/net/ethernet/sfc/ethtool.c    | 10 ++++++++++
 drivers/net/ethernet/sfc/net_driver.h |  3 +++
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index da6886dcac37..c873f961d5a5 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -1747,6 +1747,22 @@ static size_t efx_ef10_describe_stats(struct efx_nic *efx, u8 *names)
 				      mask, names);
 }
 
+static void efx_ef10_get_fec_stats(struct efx_nic *efx,
+				   struct ethtool_fec_stats *fec_stats)
+{
+	DECLARE_BITMAP(mask, EF10_STAT_COUNT);
+	struct efx_ef10_nic_data *nic_data = efx->nic_data;
+	u64 *stats = nic_data->stats;
+
+	efx_ef10_get_stat_mask(efx, mask);
+	if (test_bit(EF10_STAT_fec_corrected_errors, mask))
+		fec_stats->corrected_blocks.total =
+			stats[EF10_STAT_fec_corrected_errors];
+	if (test_bit(EF10_STAT_fec_uncorrected_errors, mask))
+		fec_stats->uncorrectable_blocks.total =
+			stats[EF10_STAT_fec_uncorrected_errors];
+}
+
 static size_t efx_ef10_update_stats_common(struct efx_nic *efx, u64 *full_stats,
 					   struct rtnl_link_stats64 *core_stats)
 {
@@ -4122,6 +4138,7 @@ const struct efx_nic_type efx_hunt_a0_nic_type = {
 	.get_wol = efx_ef10_get_wol,
 	.set_wol = efx_ef10_set_wol,
 	.resume_wol = efx_port_dummy_op_void,
+	.get_fec_stats = efx_ef10_get_fec_stats,
 	.test_chip = efx_ef10_test_chip,
 	.test_nvram = efx_mcdi_nvram_test_all,
 	.mcdi_request = efx_ef10_mcdi_request,
diff --git a/drivers/net/ethernet/sfc/ethtool.c b/drivers/net/ethernet/sfc/ethtool.c
index 12a91c559aa2..058d9fe41d99 100644
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -206,6 +206,15 @@ static int efx_ethtool_set_wol(struct net_device *net_dev,
 	return efx->type->set_wol(efx, wol->wolopts);
 }
 
+static void efx_ethtool_get_fec_stats(struct net_device *net_dev,
+				      struct ethtool_fec_stats *fec_stats)
+{
+	struct efx_nic *efx = netdev_priv(net_dev);
+
+	if (efx->type->get_fec_stats)
+		efx->type->get_fec_stats(efx, fec_stats);
+}
+
 static int efx_ethtool_get_ts_info(struct net_device *net_dev,
 				   struct ethtool_ts_info *ts_info)
 {
@@ -257,6 +266,7 @@ const struct ethtool_ops efx_ethtool_ops = {
 	.get_module_eeprom	= efx_ethtool_get_module_eeprom,
 	.get_link_ksettings	= efx_ethtool_get_link_ksettings,
 	.set_link_ksettings	= efx_ethtool_set_link_ksettings,
+	.get_fec_stats		= efx_ethtool_get_fec_stats,
 	.get_fecparam		= efx_ethtool_get_fecparam,
 	.set_fecparam		= efx_ethtool_set_fecparam,
 };
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 9f7dfdf708cf..9b4b25704271 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1187,6 +1187,7 @@ struct efx_udp_tunnel {
  * @get_wol: Get WoL configuration from driver state
  * @set_wol: Push WoL configuration to the NIC
  * @resume_wol: Synchronise WoL state between driver and MC (e.g. after resume)
+ * @get_fec_stats: Get standard FEC statistics.
  * @test_chip: Test registers.  May use efx_farch_test_registers(), and is
  *	expected to reset the NIC.
  * @test_nvram: Test validity of NVRAM contents
@@ -1332,6 +1333,8 @@ struct efx_nic_type {
 	void (*get_wol)(struct efx_nic *efx, struct ethtool_wolinfo *wol);
 	int (*set_wol)(struct efx_nic *efx, u32 type);
 	void (*resume_wol)(struct efx_nic *efx);
+	void (*get_fec_stats)(struct efx_nic *efx,
+			      struct ethtool_fec_stats *fec_stats);
 	unsigned int (*check_caps)(const struct efx_nic *efx,
 				   u8 flag,
 				   u32 offset);
-- 
2.30.2

