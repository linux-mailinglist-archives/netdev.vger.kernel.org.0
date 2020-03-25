Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BB11928FB
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCYMxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:33 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48772 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727457AbgCYMxc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:32 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp54O014665;
        Wed, 25 Mar 2020 05:53:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=MXJLbo8GNf6znnx/cHDplRM4sf2atBf+KqTvUuXBNQs=;
 b=fZoyWl9OlF8sbEfPjU8Mk02RUrNUZdGxorXJNQI5s1lmqhE9k9jwAyaSC42veTXBzGhZ
 zK/wQlTsTDB5r046VJ/JDvOINUyBbxNneptiekrzsShy2c1kSESbd/736GHODkCQNlj9
 ooZwCi9UIfr83vpv1LysWaYTIqGWQQyz/9zXemzAdi5swk6ZeC714G/WzfxJsyGMN6Xr
 sA6Fd0X9WuhnMrh7UdVq1y/zqNmL4N0cWVwOuAHeT0sFtVPZqbb0CnhP6UtiXQTEoTgQ
 rmAZSPvEep+Ap1RGKKKPApxVt25KACnVGfjjhoQWlJsG2Q6YSaEeXfntdDqw8zL3ph/W AA== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr5r1-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:29 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:27 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:53:27 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id F1D5F3F7040;
        Wed, 25 Mar 2020 05:53:25 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 16/17] net: atlantic: MACSec offload statistics implementation
Date:   Wed, 25 Mar 2020 15:52:45 +0300
Message-ID: <20200325125246.987-17-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200325125246.987-1-irusskikh@marvell.com>
References: <20200325125246.987-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-25_05:2020-03-24,2020-03-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmitry Bogdanov <dbogdanov@marvell.com>

This patch adds support for MACSec statistics on Atlantic network cards.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_ethtool.c   | 160 ++++-
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 545 ++++++++++++++++++
 .../ethernet/aquantia/atlantic/aq_macsec.h    |  73 +++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   |   5 +-
 .../net/ethernet/aquantia/atlantic/aq_nic.h   |   2 +-
 5 files changed, 766 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index 6781256a318a..7241cf92b43a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -11,6 +11,7 @@
 #include "aq_vec.h"
 #include "aq_ptp.h"
 #include "aq_filters.h"
+#include "aq_macsec.h"
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -96,6 +97,62 @@ static const char aq_ethtool_queue_stat_names[][ETH_GSTRING_LEN] = {
 	"Queue[%d] InErrors",
 };
 
+#if IS_ENABLED(CONFIG_MACSEC)
+static const char aq_macsec_stat_names[][ETH_GSTRING_LEN] = {
+	"MACSec InCtlPackets",
+	"MACSec InTaggedMissPackets",
+	"MACSec InUntaggedMissPackets",
+	"MACSec InNotagPackets",
+	"MACSec InUntaggedPackets",
+	"MACSec InBadTagPackets",
+	"MACSec InNoSciPackets",
+	"MACSec InUnknownSciPackets",
+	"MACSec InCtrlPortPassPackets",
+	"MACSec InUnctrlPortPassPackets",
+	"MACSec InCtrlPortFailPackets",
+	"MACSec InUnctrlPortFailPackets",
+	"MACSec InTooLongPackets",
+	"MACSec InIgpocCtlPackets",
+	"MACSec InEccErrorPackets",
+	"MACSec InUnctrlHitDropRedir",
+	"MACSec OutCtlPackets",
+	"MACSec OutUnknownSaPackets",
+	"MACSec OutUntaggedPackets",
+	"MACSec OutTooLong",
+	"MACSec OutEccErrorPackets",
+	"MACSec OutUnctrlHitDropRedir",
+};
+
+static const char *aq_macsec_txsc_stat_names[] = {
+	"MACSecTXSC%d ProtectedPkts",
+	"MACSecTXSC%d EncryptedPkts",
+	"MACSecTXSC%d ProtectedOctets",
+	"MACSecTXSC%d EncryptedOctets",
+};
+
+static const char *aq_macsec_txsa_stat_names[] = {
+	"MACSecTXSC%dSA%d HitDropRedirect",
+	"MACSecTXSC%dSA%d Protected2Pkts",
+	"MACSecTXSC%dSA%d ProtectedPkts",
+	"MACSecTXSC%dSA%d EncryptedPkts",
+};
+
+static const char *aq_macsec_rxsa_stat_names[] = {
+	"MACSecRXSC%dSA%d UntaggedHitPkts",
+	"MACSecRXSC%dSA%d CtrlHitDrpRedir",
+	"MACSecRXSC%dSA%d NotUsingSa",
+	"MACSecRXSC%dSA%d UnusedSa",
+	"MACSecRXSC%dSA%d NotValidPkts",
+	"MACSecRXSC%dSA%d InvalidPkts",
+	"MACSecRXSC%dSA%d OkPkts",
+	"MACSecRXSC%dSA%d LatePkts",
+	"MACSecRXSC%dSA%d DelayedPkts",
+	"MACSecRXSC%dSA%d UncheckedPkts",
+	"MACSecRXSC%dSA%d ValidatedOctets",
+	"MACSecRXSC%dSA%d DecryptedOctets",
+};
+#endif
+
 static const char aq_ethtool_priv_flag_names[][ETH_GSTRING_LEN] = {
 	"DMASystemLoopback",
 	"PKTSystemLoopback",
@@ -104,18 +161,38 @@ static const char aq_ethtool_priv_flag_names[][ETH_GSTRING_LEN] = {
 	"PHYExternalLoopback",
 };
 
+static u32 aq_ethtool_n_stats(struct net_device *ndev)
+{
+	struct aq_nic_s *nic = netdev_priv(ndev);
+	struct aq_nic_cfg_s *cfg = aq_nic_get_cfg(nic);
+	u32 n_stats = ARRAY_SIZE(aq_ethtool_stat_names) +
+		      ARRAY_SIZE(aq_ethtool_queue_stat_names) * cfg->vecs;
+
+#if IS_ENABLED(CONFIG_MACSEC)
+	if (nic->macsec_cfg) {
+		n_stats += ARRAY_SIZE(aq_macsec_stat_names) +
+			   ARRAY_SIZE(aq_macsec_txsc_stat_names) *
+				   aq_macsec_tx_sc_cnt(nic) +
+			   ARRAY_SIZE(aq_macsec_txsa_stat_names) *
+				   aq_macsec_tx_sa_cnt(nic) +
+			   ARRAY_SIZE(aq_macsec_rxsa_stat_names) *
+				   aq_macsec_rx_sa_cnt(nic);
+	}
+#endif
+
+	return n_stats;
+}
+
 static void aq_ethtool_stats(struct net_device *ndev,
 			     struct ethtool_stats *stats, u64 *data)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg;
 
-	cfg = aq_nic_get_cfg(aq_nic);
-
-	memset(data, 0, (ARRAY_SIZE(aq_ethtool_stat_names) +
-			 ARRAY_SIZE(aq_ethtool_queue_stat_names) *
-			 cfg->vecs) * sizeof(u64));
-	aq_nic_get_stats(aq_nic, data);
+	memset(data, 0, aq_ethtool_n_stats(ndev) * sizeof(u64));
+	data = aq_nic_get_stats(aq_nic, data);
+#if IS_ENABLED(CONFIG_MACSEC)
+	data = aq_macsec_get_stats(aq_nic, data);
+#endif
 }
 
 static void aq_ethtool_get_drvinfo(struct net_device *ndev,
@@ -123,11 +200,9 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 {
 	struct pci_dev *pdev = to_pci_dev(ndev->dev.parent);
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg;
 	u32 firmware_version;
 	u32 regs_count;
 
-	cfg = aq_nic_get_cfg(aq_nic);
 	firmware_version = aq_nic_get_fw_version(aq_nic);
 	regs_count = aq_nic_get_regs_count(aq_nic);
 
@@ -139,8 +214,7 @@ static void aq_ethtool_get_drvinfo(struct net_device *ndev,
 
 	strlcpy(drvinfo->bus_info, pdev ? pci_name(pdev) : "",
 		sizeof(drvinfo->bus_info));
-	drvinfo->n_stats = ARRAY_SIZE(aq_ethtool_stat_names) +
-		cfg->vecs * ARRAY_SIZE(aq_ethtool_queue_stat_names);
+	drvinfo->n_stats = aq_ethtool_n_stats(ndev);
 	drvinfo->testinfo_len = 0;
 	drvinfo->regdump_len = regs_count;
 	drvinfo->eedump_len = 0;
@@ -153,6 +227,9 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 	struct aq_nic_cfg_s *cfg;
 	u8 *p = data;
 	int i, si;
+#if IS_ENABLED(CONFIG_MACSEC)
+	int sa;
+#endif
 
 	cfg = aq_nic_get_cfg(aq_nic);
 
@@ -170,6 +247,60 @@ static void aq_ethtool_get_strings(struct net_device *ndev,
 				p += ETH_GSTRING_LEN;
 			}
 		}
+#if IS_ENABLED(CONFIG_MACSEC)
+		if (!aq_nic->macsec_cfg)
+			break;
+
+		memcpy(p, aq_macsec_stat_names, sizeof(aq_macsec_stat_names));
+		p = p + sizeof(aq_macsec_stat_names);
+		for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+			struct aq_macsec_txsc *aq_txsc;
+
+			if (!(test_bit(i, &aq_nic->macsec_cfg->txsc_idx_busy)))
+				continue;
+
+			for (si = 0;
+				si < ARRAY_SIZE(aq_macsec_txsc_stat_names);
+				si++) {
+				snprintf(p, ETH_GSTRING_LEN,
+					 aq_macsec_txsc_stat_names[si], i);
+				p += ETH_GSTRING_LEN;
+			}
+			aq_txsc = &aq_nic->macsec_cfg->aq_txsc[i];
+			for (sa = 0; sa < MACSEC_NUM_AN; sa++) {
+				if (!(test_bit(sa, &aq_txsc->tx_sa_idx_busy)))
+					continue;
+				for (si = 0;
+				     si < ARRAY_SIZE(aq_macsec_txsa_stat_names);
+				     si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+						 aq_macsec_txsa_stat_names[si],
+						 i, sa);
+					p += ETH_GSTRING_LEN;
+				}
+			}
+		}
+		for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+			struct aq_macsec_rxsc *aq_rxsc;
+
+			if (!(test_bit(i, &aq_nic->macsec_cfg->rxsc_idx_busy)))
+				continue;
+
+			aq_rxsc = &aq_nic->macsec_cfg->aq_rxsc[i];
+			for (sa = 0; sa < MACSEC_NUM_AN; sa++) {
+				if (!(test_bit(sa, &aq_rxsc->rx_sa_idx_busy)))
+					continue;
+				for (si = 0;
+				     si < ARRAY_SIZE(aq_macsec_rxsa_stat_names);
+				     si++) {
+					snprintf(p, ETH_GSTRING_LEN,
+						 aq_macsec_rxsa_stat_names[si],
+						 i, sa);
+					p += ETH_GSTRING_LEN;
+				}
+			}
+		}
+#endif
 		break;
 	case ETH_SS_PRIV_FLAGS:
 		memcpy(p, aq_ethtool_priv_flag_names,
@@ -209,16 +340,11 @@ static int aq_ethtool_set_phys_id(struct net_device *ndev,
 
 static int aq_ethtool_get_sset_count(struct net_device *ndev, int stringset)
 {
-	struct aq_nic_s *aq_nic = netdev_priv(ndev);
-	struct aq_nic_cfg_s *cfg;
 	int ret = 0;
 
-	cfg = aq_nic_get_cfg(aq_nic);
-
 	switch (stringset) {
 	case ETH_SS_STATS:
-		ret = ARRAY_SIZE(aq_ethtool_stat_names) +
-			cfg->vecs * ARRAY_SIZE(aq_ethtool_queue_stat_names);
+		ret = aq_ethtool_n_stats(ndev);
 		break;
 	case ETH_SS_PRIV_FLAGS:
 		ret = ARRAY_SIZE(aq_ethtool_priv_flag_names);
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index 53e533f8a53d..4bd283ba0d56 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -127,6 +127,166 @@ static void aq_rotate_keys(u32 (*key)[8], const int key_len)
 	}
 }
 
+#define STATS_2x32_TO_64(stat_field)                                           \
+	(((u64)stat_field[1] << 32) | stat_field[0])
+
+static int aq_get_macsec_common_stats(struct aq_hw_s *hw,
+				      struct aq_macsec_common_stats *stats)
+{
+	struct aq_mss_ingress_common_counters ingress_counters;
+	struct aq_mss_egress_common_counters egress_counters;
+	int ret;
+
+	/* MACSEC counters */
+	ret = aq_mss_get_ingress_common_counters(hw, &ingress_counters);
+	if (unlikely(ret))
+		return ret;
+
+	stats->in.ctl_pkts = STATS_2x32_TO_64(ingress_counters.ctl_pkts);
+	stats->in.tagged_miss_pkts =
+		STATS_2x32_TO_64(ingress_counters.tagged_miss_pkts);
+	stats->in.untagged_miss_pkts =
+		STATS_2x32_TO_64(ingress_counters.untagged_miss_pkts);
+	stats->in.notag_pkts = STATS_2x32_TO_64(ingress_counters.notag_pkts);
+	stats->in.untagged_pkts =
+		STATS_2x32_TO_64(ingress_counters.untagged_pkts);
+	stats->in.bad_tag_pkts =
+		STATS_2x32_TO_64(ingress_counters.bad_tag_pkts);
+	stats->in.no_sci_pkts = STATS_2x32_TO_64(ingress_counters.no_sci_pkts);
+	stats->in.unknown_sci_pkts =
+		STATS_2x32_TO_64(ingress_counters.unknown_sci_pkts);
+	stats->in.ctrl_prt_pass_pkts =
+		STATS_2x32_TO_64(ingress_counters.ctrl_prt_pass_pkts);
+	stats->in.unctrl_prt_pass_pkts =
+		STATS_2x32_TO_64(ingress_counters.unctrl_prt_pass_pkts);
+	stats->in.ctrl_prt_fail_pkts =
+		STATS_2x32_TO_64(ingress_counters.ctrl_prt_fail_pkts);
+	stats->in.unctrl_prt_fail_pkts =
+		STATS_2x32_TO_64(ingress_counters.unctrl_prt_fail_pkts);
+	stats->in.too_long_pkts =
+		STATS_2x32_TO_64(ingress_counters.too_long_pkts);
+	stats->in.igpoc_ctl_pkts =
+		STATS_2x32_TO_64(ingress_counters.igpoc_ctl_pkts);
+	stats->in.ecc_error_pkts =
+		STATS_2x32_TO_64(ingress_counters.ecc_error_pkts);
+	stats->in.unctrl_hit_drop_redir =
+		STATS_2x32_TO_64(ingress_counters.unctrl_hit_drop_redir);
+
+	ret = aq_mss_get_egress_common_counters(hw, &egress_counters);
+	if (unlikely(ret))
+		return ret;
+	stats->out.ctl_pkts = STATS_2x32_TO_64(egress_counters.ctl_pkt);
+	stats->out.unknown_sa_pkts =
+		STATS_2x32_TO_64(egress_counters.unknown_sa_pkts);
+	stats->out.untagged_pkts =
+		STATS_2x32_TO_64(egress_counters.untagged_pkts);
+	stats->out.too_long = STATS_2x32_TO_64(egress_counters.too_long);
+	stats->out.ecc_error_pkts =
+		STATS_2x32_TO_64(egress_counters.ecc_error_pkts);
+	stats->out.unctrl_hit_drop_redir =
+		STATS_2x32_TO_64(egress_counters.unctrl_hit_drop_redir);
+
+	return 0;
+}
+
+static int aq_get_rxsa_stats(struct aq_hw_s *hw, const int sa_idx,
+			     struct aq_macsec_rx_sa_stats *stats)
+{
+	struct aq_mss_ingress_sa_counters i_sa_counters;
+	int ret;
+
+	ret = aq_mss_get_ingress_sa_counters(hw, &i_sa_counters, sa_idx);
+	if (unlikely(ret))
+		return ret;
+
+	stats->untagged_hit_pkts =
+		STATS_2x32_TO_64(i_sa_counters.untagged_hit_pkts);
+	stats->ctrl_hit_drop_redir_pkts =
+		STATS_2x32_TO_64(i_sa_counters.ctrl_hit_drop_redir_pkts);
+	stats->not_using_sa = STATS_2x32_TO_64(i_sa_counters.not_using_sa);
+	stats->unused_sa = STATS_2x32_TO_64(i_sa_counters.unused_sa);
+	stats->not_valid_pkts = STATS_2x32_TO_64(i_sa_counters.not_valid_pkts);
+	stats->invalid_pkts = STATS_2x32_TO_64(i_sa_counters.invalid_pkts);
+	stats->ok_pkts = STATS_2x32_TO_64(i_sa_counters.ok_pkts);
+	stats->late_pkts = STATS_2x32_TO_64(i_sa_counters.late_pkts);
+	stats->delayed_pkts = STATS_2x32_TO_64(i_sa_counters.delayed_pkts);
+	stats->unchecked_pkts = STATS_2x32_TO_64(i_sa_counters.unchecked_pkts);
+	stats->validated_octets =
+		STATS_2x32_TO_64(i_sa_counters.validated_octets);
+	stats->decrypted_octets =
+		STATS_2x32_TO_64(i_sa_counters.decrypted_octets);
+
+	return 0;
+}
+
+static int aq_get_txsa_stats(struct aq_hw_s *hw, const int sa_idx,
+			     struct aq_macsec_tx_sa_stats *stats)
+{
+	struct aq_mss_egress_sa_counters e_sa_counters;
+	int ret;
+
+	ret = aq_mss_get_egress_sa_counters(hw, &e_sa_counters, sa_idx);
+	if (unlikely(ret))
+		return ret;
+
+	stats->sa_hit_drop_redirect =
+		STATS_2x32_TO_64(e_sa_counters.sa_hit_drop_redirect);
+	stats->sa_protected2_pkts =
+		STATS_2x32_TO_64(e_sa_counters.sa_protected2_pkts);
+	stats->sa_protected_pkts =
+		STATS_2x32_TO_64(e_sa_counters.sa_protected_pkts);
+	stats->sa_encrypted_pkts =
+		STATS_2x32_TO_64(e_sa_counters.sa_encrypted_pkts);
+
+	return 0;
+}
+
+static int aq_get_txsa_next_pn(struct aq_hw_s *hw, const int sa_idx, u32 *pn)
+{
+	struct aq_mss_egress_sa_record sa_rec;
+	int ret;
+
+	ret = aq_mss_get_egress_sa_record(hw, &sa_rec, sa_idx);
+	if (likely(!ret))
+		*pn = sa_rec.next_pn;
+
+	return ret;
+}
+
+static int aq_get_rxsa_next_pn(struct aq_hw_s *hw, const int sa_idx, u32 *pn)
+{
+	struct aq_mss_ingress_sa_record sa_rec;
+	int ret;
+
+	ret = aq_mss_get_ingress_sa_record(hw, &sa_rec, sa_idx);
+	if (likely(!ret))
+		*pn = (!sa_rec.sat_nextpn) ? sa_rec.next_pn : 0;
+
+	return ret;
+}
+
+static int aq_get_txsc_stats(struct aq_hw_s *hw, const int sc_idx,
+			     struct aq_macsec_tx_sc_stats *stats)
+{
+	struct aq_mss_egress_sc_counters e_sc_counters;
+	int ret;
+
+	ret = aq_mss_get_egress_sc_counters(hw, &e_sc_counters, sc_idx);
+	if (unlikely(ret))
+		return ret;
+
+	stats->sc_protected_pkts =
+		STATS_2x32_TO_64(e_sc_counters.sc_protected_pkts);
+	stats->sc_encrypted_pkts =
+		STATS_2x32_TO_64(e_sc_counters.sc_encrypted_pkts);
+	stats->sc_protected_octets =
+		STATS_2x32_TO_64(e_sc_counters.sc_protected_octets);
+	stats->sc_encrypted_octets =
+		STATS_2x32_TO_64(e_sc_counters.sc_encrypted_octets);
+
+	return 0;
+}
+
 static int aq_mdo_dev_open(struct macsec_context *ctx)
 {
 	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
@@ -873,6 +1033,191 @@ static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 	return ret;
 }
 
+static int aq_mdo_get_dev_stats(struct macsec_context *ctx)
+{
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_common_stats *stats = &nic->macsec_cfg->stats;
+	struct aq_hw_s *hw = nic->aq_hw;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_get_macsec_common_stats(hw, stats);
+
+	ctx->stats.dev_stats->OutPktsUntagged = stats->out.untagged_pkts;
+	ctx->stats.dev_stats->InPktsUntagged = stats->in.untagged_pkts;
+	ctx->stats.dev_stats->OutPktsTooLong = stats->out.too_long;
+	ctx->stats.dev_stats->InPktsNoTag = stats->in.notag_pkts;
+	ctx->stats.dev_stats->InPktsBadTag = stats->in.bad_tag_pkts;
+	ctx->stats.dev_stats->InPktsUnknownSCI = stats->in.unknown_sci_pkts;
+	ctx->stats.dev_stats->InPktsNoSCI = stats->in.no_sci_pkts;
+	ctx->stats.dev_stats->InPktsOverrun = 0;
+
+	return 0;
+}
+
+static int aq_mdo_get_tx_sc_stats(struct macsec_context *ctx)
+{
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_tx_sc_stats *stats;
+	struct aq_hw_s *hw = nic->aq_hw;
+	struct aq_macsec_txsc *aq_txsc;
+	int txsc_idx;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, ctx->secy);
+	if (txsc_idx < 0)
+		return -ENOENT;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_txsc = &nic->macsec_cfg->aq_txsc[txsc_idx];
+	stats = &aq_txsc->stats;
+	aq_get_txsc_stats(hw, aq_txsc->hw_sc_idx, stats);
+
+	ctx->stats.tx_sc_stats->OutPktsProtected = stats->sc_protected_pkts;
+	ctx->stats.tx_sc_stats->OutPktsEncrypted = stats->sc_encrypted_pkts;
+	ctx->stats.tx_sc_stats->OutOctetsProtected = stats->sc_protected_octets;
+	ctx->stats.tx_sc_stats->OutOctetsEncrypted = stats->sc_encrypted_octets;
+
+	return 0;
+}
+
+static int aq_mdo_get_tx_sa_stats(struct macsec_context *ctx)
+{
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	struct aq_macsec_tx_sa_stats *stats;
+	struct aq_hw_s *hw = nic->aq_hw;
+	const struct macsec_secy *secy;
+	struct aq_macsec_txsc *aq_txsc;
+	struct macsec_tx_sa *tx_sa;
+	unsigned int sa_idx;
+	int txsc_idx;
+	u32 next_pn;
+	int ret;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(cfg, ctx->secy);
+	if (txsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_txsc = &cfg->aq_txsc[txsc_idx];
+	sa_idx = aq_txsc->hw_sc_idx | ctx->sa.assoc_num;
+	stats = &aq_txsc->tx_sa_stats[ctx->sa.assoc_num];
+	ret = aq_get_txsa_stats(hw, sa_idx, stats);
+	if (ret)
+		return ret;
+
+	ctx->stats.tx_sa_stats->OutPktsProtected = stats->sa_protected_pkts;
+	ctx->stats.tx_sa_stats->OutPktsEncrypted = stats->sa_encrypted_pkts;
+
+	secy = aq_txsc->sw_secy;
+	tx_sa = rcu_dereference_bh(secy->tx_sc.sa[ctx->sa.assoc_num]);
+	ret = aq_get_txsa_next_pn(hw, sa_idx, &next_pn);
+	if (ret == 0) {
+		spin_lock_bh(&tx_sa->lock);
+		tx_sa->next_pn = next_pn;
+		spin_unlock_bh(&tx_sa->lock);
+	}
+
+	return ret;
+}
+
+static int aq_mdo_get_rx_sc_stats(struct macsec_context *ctx)
+{
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	struct aq_macsec_rx_sa_stats *stats;
+	struct aq_hw_s *hw = nic->aq_hw;
+	struct aq_macsec_rxsc *aq_rxsc;
+	unsigned int sa_idx;
+	int rxsc_idx;
+	int ret = 0;
+	int i;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, ctx->rx_sc);
+	if (rxsc_idx < 0)
+		return -ENOENT;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_rxsc = &cfg->aq_rxsc[rxsc_idx];
+	for (i = 0; i < MACSEC_NUM_AN; i++) {
+		if (!test_bit(i, &aq_rxsc->rx_sa_idx_busy))
+			continue;
+
+		stats = &aq_rxsc->rx_sa_stats[i];
+		sa_idx = aq_rxsc->hw_sc_idx | i;
+		ret = aq_get_rxsa_stats(hw, sa_idx, stats);
+		if (ret)
+			break;
+
+		ctx->stats.rx_sc_stats->InOctetsValidated +=
+			stats->validated_octets;
+		ctx->stats.rx_sc_stats->InOctetsDecrypted +=
+			stats->decrypted_octets;
+		ctx->stats.rx_sc_stats->InPktsUnchecked +=
+			stats->unchecked_pkts;
+		ctx->stats.rx_sc_stats->InPktsDelayed += stats->delayed_pkts;
+		ctx->stats.rx_sc_stats->InPktsOK += stats->ok_pkts;
+		ctx->stats.rx_sc_stats->InPktsInvalid += stats->invalid_pkts;
+		ctx->stats.rx_sc_stats->InPktsLate += stats->late_pkts;
+		ctx->stats.rx_sc_stats->InPktsNotValid += stats->not_valid_pkts;
+		ctx->stats.rx_sc_stats->InPktsNotUsingSA += stats->not_using_sa;
+		ctx->stats.rx_sc_stats->InPktsUnusedSA += stats->unused_sa;
+	}
+
+	return ret;
+}
+
+static int aq_mdo_get_rx_sa_stats(struct macsec_context *ctx)
+{
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	struct aq_macsec_rx_sa_stats *stats;
+	struct aq_hw_s *hw = nic->aq_hw;
+	struct aq_macsec_rxsc *aq_rxsc;
+	struct macsec_rx_sa *rx_sa;
+	unsigned int sa_idx;
+	int rxsc_idx;
+	u32 next_pn;
+	int ret;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, ctx->rx_sc);
+	if (rxsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_rxsc = &cfg->aq_rxsc[rxsc_idx];
+	stats = &aq_rxsc->rx_sa_stats[ctx->sa.assoc_num];
+	sa_idx = aq_rxsc->hw_sc_idx | ctx->sa.assoc_num;
+	ret = aq_get_rxsa_stats(hw, sa_idx, stats);
+	if (ret)
+		return ret;
+
+	ctx->stats.rx_sa_stats->InPktsOK = stats->ok_pkts;
+	ctx->stats.rx_sa_stats->InPktsInvalid = stats->invalid_pkts;
+	ctx->stats.rx_sa_stats->InPktsNotValid = stats->not_valid_pkts;
+	ctx->stats.rx_sa_stats->InPktsNotUsingSA = stats->not_using_sa;
+	ctx->stats.rx_sa_stats->InPktsUnusedSA = stats->unused_sa;
+
+	rx_sa = rcu_dereference_bh(aq_rxsc->sw_rxsc->sa[ctx->sa.assoc_num]);
+	ret = aq_get_rxsa_next_pn(hw, sa_idx, &next_pn);
+	if (ret == 0) {
+		spin_lock_bh(&rx_sa->lock);
+		rx_sa->next_pn = next_pn;
+		spin_unlock_bh(&rx_sa->lock);
+	}
+
+	return ret;
+}
+
 static int apply_txsc_cfg(struct aq_nic_s *nic, const int txsc_idx)
 {
 	struct aq_macsec_txsc *aq_txsc = &nic->macsec_cfg->aq_txsc[txsc_idx];
@@ -1116,6 +1461,11 @@ const struct macsec_ops aq_macsec_ops = {
 	.mdo_add_txsa = aq_mdo_add_txsa,
 	.mdo_upd_txsa = aq_mdo_upd_txsa,
 	.mdo_del_txsa = aq_mdo_del_txsa,
+	.mdo_get_dev_stats = aq_mdo_get_dev_stats,
+	.mdo_get_tx_sc_stats = aq_mdo_get_tx_sc_stats,
+	.mdo_get_tx_sa_stats = aq_mdo_get_tx_sa_stats,
+	.mdo_get_rx_sc_stats = aq_mdo_get_rx_sc_stats,
+	.mdo_get_rx_sa_stats = aq_mdo_get_rx_sa_stats,
 };
 
 int aq_macsec_init(struct aq_nic_s *nic)
@@ -1225,3 +1575,198 @@ void aq_macsec_work(struct aq_nic_s *nic)
 	aq_check_txsa_expiration(nic);
 	rtnl_unlock();
 }
+
+int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic)
+{
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	int i, cnt = 0;
+
+	if (!cfg)
+		return 0;
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (!test_bit(i, &cfg->rxsc_idx_busy))
+			continue;
+		cnt += hweight_long(cfg->aq_rxsc[i].rx_sa_idx_busy);
+	}
+
+	return cnt;
+}
+
+int aq_macsec_tx_sc_cnt(struct aq_nic_s *nic)
+{
+	if (!nic->macsec_cfg)
+		return 0;
+
+	return hweight_long(nic->macsec_cfg->txsc_idx_busy);
+}
+
+int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic)
+{
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	int i, cnt = 0;
+
+	if (!cfg)
+		return 0;
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (!test_bit(i, &cfg->txsc_idx_busy))
+			continue;
+		cnt += hweight_long(cfg->aq_txsc[i].tx_sa_idx_busy);
+	}
+
+	return cnt;
+}
+
+static int aq_macsec_update_stats(struct aq_nic_s *nic)
+{
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	struct aq_hw_s *hw = nic->aq_hw;
+	struct aq_macsec_txsc *aq_txsc;
+	struct aq_macsec_rxsc *aq_rxsc;
+	int i, sa_idx, assoc_num;
+	int ret = 0;
+
+	aq_get_macsec_common_stats(hw, &cfg->stats);
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (!(cfg->txsc_idx_busy & BIT(i)))
+			continue;
+		aq_txsc = &cfg->aq_txsc[i];
+
+		ret = aq_get_txsc_stats(hw, aq_txsc->hw_sc_idx,
+					&aq_txsc->stats);
+		if (ret)
+			return ret;
+
+		for (assoc_num = 0; assoc_num < MACSEC_NUM_AN; assoc_num++) {
+			if (!test_bit(assoc_num, &aq_txsc->tx_sa_idx_busy))
+				continue;
+			sa_idx = aq_txsc->hw_sc_idx | assoc_num;
+			ret = aq_get_txsa_stats(hw, sa_idx,
+					      &aq_txsc->tx_sa_stats[assoc_num]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (!(test_bit(i, &cfg->rxsc_idx_busy)))
+			continue;
+		aq_rxsc = &cfg->aq_rxsc[i];
+
+		for (assoc_num = 0; assoc_num < MACSEC_NUM_AN; assoc_num++) {
+			if (!test_bit(assoc_num, &aq_rxsc->rx_sa_idx_busy))
+				continue;
+			sa_idx = aq_rxsc->hw_sc_idx | assoc_num;
+
+			ret = aq_get_rxsa_stats(hw, sa_idx,
+					      &aq_rxsc->rx_sa_stats[assoc_num]);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
+u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data)
+{
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	struct aq_macsec_common_stats *common_stats;
+	struct aq_macsec_tx_sc_stats *txsc_stats;
+	struct aq_macsec_tx_sa_stats *txsa_stats;
+	struct aq_macsec_rx_sa_stats *rxsa_stats;
+	struct aq_macsec_txsc *aq_txsc;
+	struct aq_macsec_rxsc *aq_rxsc;
+	unsigned int assoc_num;
+	unsigned int sc_num;
+	unsigned int i = 0U;
+
+	if (!cfg)
+		return data;
+
+	aq_macsec_update_stats(nic);
+
+	common_stats = &cfg->stats;
+	data[i] = common_stats->in.ctl_pkts;
+	data[++i] = common_stats->in.tagged_miss_pkts;
+	data[++i] = common_stats->in.untagged_miss_pkts;
+	data[++i] = common_stats->in.notag_pkts;
+	data[++i] = common_stats->in.untagged_pkts;
+	data[++i] = common_stats->in.bad_tag_pkts;
+	data[++i] = common_stats->in.no_sci_pkts;
+	data[++i] = common_stats->in.unknown_sci_pkts;
+	data[++i] = common_stats->in.ctrl_prt_pass_pkts;
+	data[++i] = common_stats->in.unctrl_prt_pass_pkts;
+	data[++i] = common_stats->in.ctrl_prt_fail_pkts;
+	data[++i] = common_stats->in.unctrl_prt_fail_pkts;
+	data[++i] = common_stats->in.too_long_pkts;
+	data[++i] = common_stats->in.igpoc_ctl_pkts;
+	data[++i] = common_stats->in.ecc_error_pkts;
+	data[++i] = common_stats->in.unctrl_hit_drop_redir;
+	data[++i] = common_stats->out.ctl_pkts;
+	data[++i] = common_stats->out.unknown_sa_pkts;
+	data[++i] = common_stats->out.untagged_pkts;
+	data[++i] = common_stats->out.too_long;
+	data[++i] = common_stats->out.ecc_error_pkts;
+	data[++i] = common_stats->out.unctrl_hit_drop_redir;
+
+	for (sc_num = 0; sc_num < AQ_MACSEC_MAX_SC; sc_num++) {
+		if (!(test_bit(sc_num, &cfg->txsc_idx_busy)))
+			continue;
+
+		aq_txsc = &cfg->aq_txsc[sc_num];
+		txsc_stats = &aq_txsc->stats;
+
+		data[++i] = txsc_stats->sc_protected_pkts;
+		data[++i] = txsc_stats->sc_encrypted_pkts;
+		data[++i] = txsc_stats->sc_protected_octets;
+		data[++i] = txsc_stats->sc_encrypted_octets;
+
+		for (assoc_num = 0; assoc_num < MACSEC_NUM_AN; assoc_num++) {
+			if (!test_bit(assoc_num, &aq_txsc->tx_sa_idx_busy))
+				continue;
+
+			txsa_stats = &aq_txsc->tx_sa_stats[assoc_num];
+
+			data[++i] = txsa_stats->sa_hit_drop_redirect;
+			data[++i] = txsa_stats->sa_protected2_pkts;
+			data[++i] = txsa_stats->sa_protected_pkts;
+			data[++i] = txsa_stats->sa_encrypted_pkts;
+		}
+	}
+
+	for (sc_num = 0; sc_num < AQ_MACSEC_MAX_SC; sc_num++) {
+		if (!(test_bit(sc_num, &cfg->rxsc_idx_busy)))
+			continue;
+
+		aq_rxsc = &cfg->aq_rxsc[sc_num];
+
+		for (assoc_num = 0; assoc_num < MACSEC_NUM_AN; assoc_num++) {
+			if (!test_bit(assoc_num, &aq_rxsc->rx_sa_idx_busy))
+				continue;
+
+			rxsa_stats = &aq_rxsc->rx_sa_stats[assoc_num];
+
+			data[++i] = rxsa_stats->untagged_hit_pkts;
+			data[++i] = rxsa_stats->ctrl_hit_drop_redir_pkts;
+			data[++i] = rxsa_stats->not_using_sa;
+			data[++i] = rxsa_stats->unused_sa;
+			data[++i] = rxsa_stats->not_valid_pkts;
+			data[++i] = rxsa_stats->invalid_pkts;
+			data[++i] = rxsa_stats->ok_pkts;
+			data[++i] = rxsa_stats->late_pkts;
+			data[++i] = rxsa_stats->delayed_pkts;
+			data[++i] = rxsa_stats->unchecked_pkts;
+			data[++i] = rxsa_stats->validated_octets;
+			data[++i] = rxsa_stats->decrypted_octets;
+		}
+	}
+
+	i++;
+
+	data += i;
+
+	return data;
+}
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
index b8485c1cb667..f5fba8b8cdea 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -23,11 +23,77 @@ enum aq_macsec_sc_sa {
 	aq_macsec_sa_sc_1sa_32sc,
 };
 
+struct aq_macsec_common_stats {
+	/* Ingress Common Counters */
+	struct {
+		u64 ctl_pkts;
+		u64 tagged_miss_pkts;
+		u64 untagged_miss_pkts;
+		u64 notag_pkts;
+		u64 untagged_pkts;
+		u64 bad_tag_pkts;
+		u64 no_sci_pkts;
+		u64 unknown_sci_pkts;
+		u64 ctrl_prt_pass_pkts;
+		u64 unctrl_prt_pass_pkts;
+		u64 ctrl_prt_fail_pkts;
+		u64 unctrl_prt_fail_pkts;
+		u64 too_long_pkts;
+		u64 igpoc_ctl_pkts;
+		u64 ecc_error_pkts;
+		u64 unctrl_hit_drop_redir;
+	} in;
+
+	/* Egress Common Counters */
+	struct {
+		u64 ctl_pkts;
+		u64 unknown_sa_pkts;
+		u64 untagged_pkts;
+		u64 too_long;
+		u64 ecc_error_pkts;
+		u64 unctrl_hit_drop_redir;
+	} out;
+};
+
+/* Ingress SA Counters */
+struct aq_macsec_rx_sa_stats {
+	u64 untagged_hit_pkts;
+	u64 ctrl_hit_drop_redir_pkts;
+	u64 not_using_sa;
+	u64 unused_sa;
+	u64 not_valid_pkts;
+	u64 invalid_pkts;
+	u64 ok_pkts;
+	u64 late_pkts;
+	u64 delayed_pkts;
+	u64 unchecked_pkts;
+	u64 validated_octets;
+	u64 decrypted_octets;
+};
+
+/* Egress SA Counters */
+struct aq_macsec_tx_sa_stats {
+	u64 sa_hit_drop_redirect;
+	u64 sa_protected2_pkts;
+	u64 sa_protected_pkts;
+	u64 sa_encrypted_pkts;
+};
+
+/* Egress SC Counters */
+struct aq_macsec_tx_sc_stats {
+	u64 sc_protected_pkts;
+	u64 sc_encrypted_pkts;
+	u64 sc_protected_octets;
+	u64 sc_encrypted_octets;
+};
+
 struct aq_macsec_txsc {
 	u32 hw_sc_idx;
 	unsigned long tx_sa_idx_busy;
 	const struct macsec_secy *sw_secy;
 	u8 tx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
+	struct aq_macsec_tx_sc_stats stats;
+	struct aq_macsec_tx_sa_stats tx_sa_stats[MACSEC_NUM_AN];
 };
 
 struct aq_macsec_rxsc {
@@ -36,6 +102,7 @@ struct aq_macsec_rxsc {
 	const struct macsec_secy *sw_secy;
 	const struct macsec_rx_sc *sw_rxsc;
 	u8 rx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
+	struct aq_macsec_rx_sa_stats rx_sa_stats[MACSEC_NUM_AN];
 };
 
 struct aq_macsec_cfg {
@@ -46,6 +113,8 @@ struct aq_macsec_cfg {
 	/* Ingress channel configuration */
 	unsigned long rxsc_idx_busy;
 	struct aq_macsec_rxsc aq_rxsc[AQ_MACSEC_MAX_SC];
+	/* Statistics / counters */
+	struct aq_macsec_common_stats stats;
 };
 
 extern const struct macsec_ops aq_macsec_ops;
@@ -54,6 +123,10 @@ int aq_macsec_init(struct aq_nic_s *nic);
 void aq_macsec_free(struct aq_nic_s *nic);
 int aq_macsec_enable(struct aq_nic_s *nic);
 void aq_macsec_work(struct aq_nic_s *nic);
+u64 *aq_macsec_get_stats(struct aq_nic_s *nic, u64 *data);
+int aq_macsec_rx_sa_cnt(struct aq_nic_s *nic);
+int aq_macsec_tx_sc_cnt(struct aq_nic_s *nic);
+int aq_macsec_tx_sa_cnt(struct aq_nic_s *nic);
 
 #endif
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 5d4c16d637c7..a369705a786a 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -781,7 +781,7 @@ int aq_nic_get_regs_count(struct aq_nic_s *self)
 	return self->aq_nic_cfg.aq_hw_caps->mac_regs_count;
 }
 
-void aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
+u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 {
 	struct aq_vec_s *aq_vec = NULL;
 	struct aq_stats_s *stats;
@@ -831,7 +831,10 @@ void aq_nic_get_stats(struct aq_nic_s *self, u64 *data)
 		aq_vec_get_sw_stats(aq_vec, data, &count);
 	}
 
+	data += count;
+
 err_exit:;
+	return data;
 }
 
 static void aq_nic_update_ndev_stats(struct aq_nic_s *self)
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
index 011db4094c93..0663b8d0220d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.h
@@ -158,7 +158,7 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, struct sk_buff *skb,
 int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb);
 int aq_nic_get_regs(struct aq_nic_s *self, struct ethtool_regs *regs, void *p);
 int aq_nic_get_regs_count(struct aq_nic_s *self);
-void aq_nic_get_stats(struct aq_nic_s *self, u64 *data);
+u64 *aq_nic_get_stats(struct aq_nic_s *self, u64 *data);
 int aq_nic_stop(struct aq_nic_s *self);
 void aq_nic_deinit(struct aq_nic_s *self, bool link_down);
 void aq_nic_set_power(struct aq_nic_s *self);
-- 
2.17.1

