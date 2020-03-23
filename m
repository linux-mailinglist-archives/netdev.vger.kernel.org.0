Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BE318F575
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 14:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbgCWNPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 09:15:19 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:39982 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728465AbgCWNPT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 09:15:19 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02ND6MJ5019116;
        Mon, 23 Mar 2020 06:15:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=fBXOcb4OrsA6tcH/siHX1yhmLqvbP+2FSLNUr3gwQvc=;
 b=CFcL8kbp8UQPTabxi1WP8hXydQGbQ2neh46QjsHA4lZi5SuRnQcwhlIDYz47Og10wu4P
 1bM0r5z+M9TB7CbIekT2lcii3aHjPzzNwFDpSOupgHrBdK62KdiS0dW21kYZjmoJ3YKV
 MOWvpeUbUEJxX8YSLFd3DJi8M3Wj7gQo0Mw4KaZ4omKJCJ+8hGIk84XXWiUZ75NtAfpR
 FuBrmh2bRS8IlAJDii+Crd+qM2qU6c+kMD6fGjdbPP5DICnQMzyxj5Iekfu9fUGQgns3
 x7iXAqdJ1Yp37hzQqXjjmeS6ACnyBJzAdyyHnj4ZWZG3odZiNYYwcMuAqA1GLh9Dyrt4 6g== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ywvkqmn55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 23 Mar 2020 06:15:15 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 23 Mar
 2020 06:15:13 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 23 Mar 2020 06:15:13 -0700
Received: from localhost.localdomain (unknown [10.9.16.91])
        by maili.marvell.com (Postfix) with ESMTP id 7808D3F7041;
        Mon, 23 Mar 2020 06:15:11 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Igor Russkikh" <irusskikh@marvell.com>
Subject: [PATCH net-next 14/17] net: atlantic: MACSec ingress offload implementation
Date:   Mon, 23 Mar 2020 16:13:45 +0300
Message-ID: <20200323131348.340-15-irusskikh@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200323131348.340-1-irusskikh@marvell.com>
References: <20200323131348.340-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-23_04:2020-03-21,2020-03-23 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Starovoytov <mstarovoitov@marvell.com>

This patch adds support for MACSec ingress HW offloading on Atlantic
network cards.

Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 463 +++++++++++++++++-
 .../ethernet/aquantia/atlantic/aq_macsec.h    |   5 +
 2 files changed, 462 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index cf5862958e92..92244184659e 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -25,6 +25,10 @@ static int aq_clear_txsc(struct aq_nic_s *nic, const int txsc_idx,
 			 enum aq_clear_type clear_type);
 static int aq_clear_txsa(struct aq_nic_s *nic, struct aq_macsec_txsc *aq_txsc,
 			 const int sa_num, enum aq_clear_type clear_type);
+static int aq_clear_rxsc(struct aq_nic_s *nic, const int rxsc_idx,
+			 enum aq_clear_type clear_type);
+static int aq_clear_rxsa(struct aq_nic_s *nic, struct aq_macsec_rxsc *aq_rxsc,
+			 const int sa_num, enum aq_clear_type clear_type);
 static int aq_clear_secy(struct aq_nic_s *nic, const struct macsec_secy *secy,
 			 enum aq_clear_type clear_type);
 static int aq_apply_macsec_cfg(struct aq_nic_s *nic);
@@ -57,6 +61,22 @@ static int aq_get_txsc_idx_from_secy(struct aq_macsec_cfg *macsec_cfg,
 	return -1;
 }
 
+static int aq_get_rxsc_idx_from_rxsc(struct aq_macsec_cfg *macsec_cfg,
+				     const struct macsec_rx_sc *rxsc)
+{
+	int i;
+
+	if (unlikely(!rxsc))
+		return -1;
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (macsec_cfg->aq_rxsc[i].sw_rxsc == rxsc)
+			return i;
+	}
+
+	return -1;
+}
+
 static int aq_get_txsc_idx_from_sc_idx(const enum aq_macsec_sc_sa sc_sa,
 				       const int sc_idx)
 {
@@ -527,34 +547,393 @@ static int aq_mdo_del_txsa(struct macsec_context *ctx)
 	return ret;
 }
 
+static int aq_rxsc_validate_frames(const enum macsec_validation_type validate)
+{
+	switch (validate) {
+	case MACSEC_VALIDATE_DISABLED:
+		return 2;
+	case MACSEC_VALIDATE_CHECK:
+		return 1;
+	case MACSEC_VALIDATE_STRICT:
+		return 0;
+	default:
+		break;
+	}
+
+	/* should never be here */
+	WARN_ON(true);
+	return 0;
+}
+
+static int aq_set_rxsc(struct aq_nic_s *nic, const u32 rxsc_idx)
+{
+	const struct aq_macsec_rxsc *aq_rxsc =
+		&nic->macsec_cfg->aq_rxsc[rxsc_idx];
+	struct aq_mss_ingress_preclass_record pre_class_record;
+	const struct macsec_rx_sc *rx_sc = aq_rxsc->sw_rxsc;
+	const struct macsec_secy *secy = aq_rxsc->sw_secy;
+	const u32 hw_sc_idx = aq_rxsc->hw_sc_idx;
+	struct aq_mss_ingress_sc_record sc_record;
+	struct aq_hw_s *hw = nic->aq_hw;
+	__be64 nsci;
+	int ret = 0;
+
+	netdev_dbg(nic->ndev,
+		   "set rx_sc: rxsc_idx=%d, sci %#llx, hw_sc_idx=%d\n",
+		   rxsc_idx, rx_sc->sci, hw_sc_idx);
+
+	memset(&pre_class_record, 0, sizeof(pre_class_record));
+	nsci = cpu_to_be64((__force u64)rx_sc->sci);
+	memcpy(pre_class_record.sci, &nsci, sizeof(nsci));
+	pre_class_record.sci_mask = 0xff;
+	/* match all MACSEC ethertype packets */
+	pre_class_record.eth_type = ETH_P_MACSEC;
+	pre_class_record.eth_type_mask = 0x3;
+
+	aq_ether_addr_to_mac(pre_class_record.mac_sa, (char *)&rx_sc->sci);
+	pre_class_record.sa_mask = 0x3f;
+
+	pre_class_record.an_mask = nic->macsec_cfg->sc_sa;
+	pre_class_record.sc_idx = hw_sc_idx;
+	/* strip SecTAG & forward for decryption */
+	pre_class_record.action = 0x0;
+	pre_class_record.valid = 1;
+
+	ret = aq_mss_set_ingress_preclass_record(hw, &pre_class_record,
+						 2 * rxsc_idx + 1);
+	if (ret) {
+		netdev_err(nic->ndev,
+			"aq_mss_set_ingress_preclass_record failed with %d\n",
+			ret);
+		return ret;
+	}
+
+	/* If SCI is absent, then match by SA alone */
+	pre_class_record.sci_mask = 0;
+	pre_class_record.sci_from_table = 1;
+
+	ret = aq_mss_set_ingress_preclass_record(hw, &pre_class_record,
+						 2 * rxsc_idx);
+	if (ret) {
+		netdev_err(nic->ndev,
+			"aq_mss_set_ingress_preclass_record failed with %d\n",
+			ret);
+		return ret;
+	}
+
+	memset(&sc_record, 0, sizeof(sc_record));
+	sc_record.validate_frames =
+		aq_rxsc_validate_frames(secy->validate_frames);
+	if (secy->replay_protect) {
+		sc_record.replay_protect = 1;
+		sc_record.anti_replay_window = secy->replay_window;
+	}
+	sc_record.valid = 1;
+	sc_record.fresh = 1;
+
+	ret = aq_mss_set_ingress_sc_record(hw, &sc_record, hw_sc_idx);
+	if (ret) {
+		netdev_err(nic->ndev,
+			   "aq_mss_set_ingress_sc_record failed with %d\n",
+			   ret);
+		return ret;
+	}
+
+	return ret;
+}
+
 static int aq_mdo_add_rxsc(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	const u32 rxsc_idx_max = aq_sc_idx_max(cfg->sc_sa);
+	u32 rxsc_idx;
+	int ret = 0;
+
+	if (hweight32(cfg->rxsc_idx_busy) >= rxsc_idx_max)
+		return -ENOSPC;
+
+	rxsc_idx = ffz(cfg->rxsc_idx_busy);
+	if (rxsc_idx >= rxsc_idx_max)
+		return -ENOSPC;
+
+	if (ctx->prepare)
+		return 0;
+
+	cfg->aq_rxsc[rxsc_idx].hw_sc_idx = aq_to_hw_sc_idx(rxsc_idx,
+							   cfg->sc_sa);
+	cfg->aq_rxsc[rxsc_idx].sw_secy = ctx->secy;
+	cfg->aq_rxsc[rxsc_idx].sw_rxsc = ctx->rx_sc;
+	netdev_dbg(nic->ndev, "add rxsc: rxsc_idx=%u, hw_sc_idx=%u, rxsc=%p\n",
+		   rxsc_idx, cfg->aq_rxsc[rxsc_idx].hw_sc_idx,
+		   cfg->aq_rxsc[rxsc_idx].sw_rxsc);
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(ctx->secy->netdev))
+		ret = aq_set_rxsc(nic, rxsc_idx);
+
+	if (ret < 0)
+		return ret;
+
+	set_bit(rxsc_idx, &cfg->rxsc_idx_busy);
+
+	return 0;
 }
 
 static int aq_mdo_upd_rxsc(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	int rxsc_idx;
+	int ret = 0;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, ctx->rx_sc);
+	if (rxsc_idx < 0)
+		return -ENOENT;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(ctx->secy->netdev))
+		ret = aq_set_rxsc(nic, rxsc_idx);
+
+	return ret;
+}
+
+static int aq_clear_rxsc(struct aq_nic_s *nic, const int rxsc_idx,
+			 enum aq_clear_type clear_type)
+{
+	struct aq_macsec_rxsc *rx_sc = &nic->macsec_cfg->aq_rxsc[rxsc_idx];
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+	int sa_num;
+
+	for_each_set_bit (sa_num, &rx_sc->rx_sa_idx_busy, AQ_MACSEC_MAX_SA) {
+		ret = aq_clear_rxsa(nic, rx_sc, sa_num, clear_type);
+		if (ret)
+			return ret;
+	}
+
+	if (clear_type & AQ_CLEAR_HW) {
+		struct aq_mss_ingress_preclass_record pre_class_record;
+		struct aq_mss_ingress_sc_record sc_record;
+
+		memset(&pre_class_record, 0, sizeof(pre_class_record));
+		memset(&sc_record, 0, sizeof(sc_record));
+
+		ret = aq_mss_set_ingress_preclass_record(hw, &pre_class_record,
+							 2 * rxsc_idx);
+		if (ret) {
+			netdev_err(nic->ndev,
+				"aq_mss_set_ingress_preclass_record failed with %d\n",
+				ret);
+			return ret;
+		}
+
+		ret = aq_mss_set_ingress_preclass_record(hw, &pre_class_record,
+							 2 * rxsc_idx + 1);
+		if (ret) {
+			netdev_err(nic->ndev,
+				"aq_mss_set_ingress_preclass_record failed with %d\n",
+				ret);
+			return ret;
+		}
+
+		sc_record.fresh = 1;
+		ret = aq_mss_set_ingress_sc_record(hw, &sc_record,
+						   rx_sc->hw_sc_idx);
+		if (ret)
+			return ret;
+	}
+
+	if (clear_type & AQ_CLEAR_SW) {
+		clear_bit(rxsc_idx, &nic->macsec_cfg->rxsc_idx_busy);
+		rx_sc->sw_secy = NULL;
+		rx_sc->sw_rxsc = NULL;
+	}
+
+	return ret;
 }
 
 static int aq_mdo_del_rxsc(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	enum aq_clear_type clear_type = AQ_CLEAR_SW;
+	int rxsc_idx;
+	int ret = 0;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, ctx->rx_sc);
+	if (rxsc_idx < 0)
+		return -ENOENT;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (netif_carrier_ok(nic->ndev))
+		clear_type = AQ_CLEAR_ALL;
+
+	ret = aq_clear_rxsc(nic, rxsc_idx, clear_type);
+
+	return ret;
+}
+
+static int aq_update_rxsa(struct aq_nic_s *nic, const unsigned int sc_idx,
+			  const struct macsec_secy *secy,
+			  const struct macsec_rx_sa *rx_sa,
+			  const unsigned char *key, const unsigned char an)
+{
+	struct aq_mss_ingress_sakey_record sa_key_record;
+	struct aq_mss_ingress_sa_record sa_record;
+	struct aq_hw_s *hw = nic->aq_hw;
+	const int sa_idx = sc_idx | an;
+	int ret = 0;
+
+	netdev_dbg(nic->ndev, "set rx_sa %d: active=%d, next_pn=%d\n", an,
+		   rx_sa->active, rx_sa->next_pn);
+
+	memset(&sa_record, 0, sizeof(sa_record));
+	sa_record.valid = rx_sa->active;
+	sa_record.fresh = 1;
+	sa_record.next_pn = rx_sa->next_pn;
+
+	ret = aq_mss_set_ingress_sa_record(hw, &sa_record, sa_idx);
+	if (ret) {
+		netdev_err(nic->ndev,
+			   "aq_mss_set_ingress_sa_record failed with %d\n",
+			   ret);
+		return ret;
+	}
+
+	if (!key)
+		return ret;
+
+	memset(&sa_key_record, 0, sizeof(sa_key_record));
+	memcpy(&sa_key_record.key, key, secy->key_len);
+
+	switch (secy->key_len) {
+	case AQ_MACSEC_KEY_LEN_128_BIT:
+		sa_key_record.key_len = 0;
+		break;
+	case AQ_MACSEC_KEY_LEN_192_BIT:
+		sa_key_record.key_len = 1;
+		break;
+	case AQ_MACSEC_KEY_LEN_256_BIT:
+		sa_key_record.key_len = 2;
+		break;
+	default:
+		return -1;
+	}
+
+	aq_rotate_keys(&sa_key_record.key, secy->key_len);
+
+	ret = aq_mss_set_ingress_sakey_record(hw, &sa_key_record, sa_idx);
+	if (ret)
+		netdev_err(nic->ndev,
+			   "aq_mss_set_ingress_sakey_record failed with %d\n",
+			   ret);
+
+	return ret;
 }
 
 static int aq_mdo_add_rxsa(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	const struct macsec_rx_sc *rx_sc = ctx->sa.rx_sa->sc;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	const struct macsec_secy *secy = ctx->secy;
+	struct aq_macsec_rxsc *aq_rxsc;
+	int rxsc_idx;
+	int ret = 0;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, rx_sc);
+	if (rxsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_rxsc = &nic->macsec_cfg->aq_rxsc[rxsc_idx];
+	set_bit(ctx->sa.assoc_num, &aq_rxsc->rx_sa_idx_busy);
+
+	memcpy(aq_rxsc->rx_sa_key[ctx->sa.assoc_num], ctx->sa.key,
+	       secy->key_len);
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
+		ret = aq_update_rxsa(nic, aq_rxsc->hw_sc_idx, secy,
+				     ctx->sa.rx_sa, ctx->sa.key,
+				     ctx->sa.assoc_num);
+
+	return ret;
 }
 
 static int aq_mdo_upd_rxsa(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	const struct macsec_rx_sc *rx_sc = ctx->sa.rx_sa->sc;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	const struct macsec_secy *secy = ctx->secy;
+	int rxsc_idx;
+	int ret = 0;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, rx_sc);
+	if (rxsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
+		ret = aq_update_rxsa(nic, cfg->aq_rxsc[rxsc_idx].hw_sc_idx,
+				     secy, ctx->sa.rx_sa, NULL,
+				     ctx->sa.assoc_num);
+
+	return ret;
+}
+
+static int aq_clear_rxsa(struct aq_nic_s *nic, struct aq_macsec_rxsc *aq_rxsc,
+			 const int sa_num, enum aq_clear_type clear_type)
+{
+	int sa_idx = aq_rxsc->hw_sc_idx | sa_num;
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+
+	if (clear_type & AQ_CLEAR_SW)
+		clear_bit(sa_num, &aq_rxsc->rx_sa_idx_busy);
+
+	if ((clear_type & AQ_CLEAR_HW) && netif_carrier_ok(nic->ndev)) {
+		struct aq_mss_ingress_sakey_record sa_key_record;
+		struct aq_mss_ingress_sa_record sa_record;
+
+		memset(&sa_key_record, 0, sizeof(sa_key_record));
+		memset(&sa_record, 0, sizeof(sa_record));
+		sa_record.fresh = 1;
+		ret = aq_mss_set_ingress_sa_record(hw, &sa_record, sa_idx);
+		if (ret)
+			return ret;
+
+		return aq_mss_set_ingress_sakey_record(hw, &sa_key_record,
+						       sa_idx);
+	}
+
+	return ret;
 }
 
 static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	const struct macsec_rx_sc *rx_sc = ctx->sa.rx_sa->sc;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	int rxsc_idx;
+	int ret = 0;
+
+	rxsc_idx = aq_get_rxsc_idx_from_rxsc(cfg, rx_sc);
+	if (rxsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	ret = aq_clear_rxsa(nic, &cfg->aq_rxsc[rxsc_idx], ctx->sa.assoc_num,
+			    AQ_CLEAR_ALL);
+
+	return ret;
 }
 
 static int apply_txsc_cfg(struct aq_nic_s *nic, const int txsc_idx)
@@ -585,10 +964,40 @@ static int apply_txsc_cfg(struct aq_nic_s *nic, const int txsc_idx)
 	return ret;
 }
 
+static int apply_rxsc_cfg(struct aq_nic_s *nic, const int rxsc_idx)
+{
+	struct aq_macsec_rxsc *aq_rxsc = &nic->macsec_cfg->aq_rxsc[rxsc_idx];
+	const struct macsec_secy *secy = aq_rxsc->sw_secy;
+	struct macsec_rx_sa *rx_sa;
+	int ret = 0;
+	int i;
+
+	if (!netif_running(secy->netdev))
+		return ret;
+
+	ret = aq_set_rxsc(nic, rxsc_idx);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < MACSEC_NUM_AN; i++) {
+		rx_sa = rcu_dereference_bh(aq_rxsc->sw_rxsc->sa[i]);
+		if (rx_sa) {
+			ret = aq_update_rxsa(nic, aq_rxsc->hw_sc_idx, secy,
+					     rx_sa, aq_rxsc->rx_sa_key[i], i);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
 static int aq_clear_secy(struct aq_nic_s *nic, const struct macsec_secy *secy,
 			 enum aq_clear_type clear_type)
 {
+	struct macsec_rx_sc *rx_sc;
 	int txsc_idx;
+	int rxsc_idx;
 	int ret = 0;
 
 	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
@@ -598,19 +1007,43 @@ static int aq_clear_secy(struct aq_nic_s *nic, const struct macsec_secy *secy,
 			return ret;
 	}
 
+	for (rx_sc = rcu_dereference_bh(secy->rx_sc); rx_sc;
+	     rx_sc = rcu_dereference_bh(rx_sc->next)) {
+		rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, rx_sc);
+		if (rxsc_idx < 0)
+			continue;
+
+		ret = aq_clear_rxsc(nic, rxsc_idx, clear_type);
+		if (ret)
+			return ret;
+	}
+
 	return ret;
 }
 
 static int aq_apply_secy_cfg(struct aq_nic_s *nic,
 			     const struct macsec_secy *secy)
 {
+	struct macsec_rx_sc *rx_sc;
 	int txsc_idx;
+	int rxsc_idx;
 	int ret = 0;
 
 	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
 	if (txsc_idx >= 0)
 		apply_txsc_cfg(nic, txsc_idx);
 
+	for (rx_sc = rcu_dereference_bh(secy->rx_sc); rx_sc && rx_sc->active;
+	     rx_sc = rcu_dereference_bh(rx_sc->next)) {
+		rxsc_idx = aq_get_rxsc_idx_from_rxsc(nic->macsec_cfg, rx_sc);
+		if (unlikely(rxsc_idx < 0))
+			continue;
+
+		ret = apply_rxsc_cfg(nic, rxsc_idx);
+		if (ret)
+			return ret;
+	}
+
 	return ret;
 }
 
@@ -627,6 +1060,14 @@ static int aq_apply_macsec_cfg(struct aq_nic_s *nic)
 		}
 	}
 
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (nic->macsec_cfg->rxsc_idx_busy & BIT(i)) {
+			ret = apply_rxsc_cfg(nic, i);
+			if (ret)
+				return ret;
+		}
+	}
+
 	return ret;
 }
 
@@ -802,6 +1243,7 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 
 	/* Init Ethertype bypass filters */
 	for (index = 0; index < ARRAY_SIZE(ctl_ether_types); index++) {
+		struct aq_mss_ingress_prectlf_record rx_prectlf_rec;
 		struct aq_mss_egress_ctlf_record tx_ctlf_rec;
 
 		if (ctl_ether_types[index] == 0)
@@ -815,6 +1257,15 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 		tbl_idx = NUMROWS_EGRESSCTLFRECORD - num_ctl_ether_types - 1;
 		aq_mss_set_egress_ctlf_record(hw, &tx_ctlf_rec, tbl_idx);
 
+		memset(&rx_prectlf_rec, 0, sizeof(rx_prectlf_rec));
+		rx_prectlf_rec.eth_type = ctl_ether_types[index];
+		rx_prectlf_rec.match_type = 4; /* Match eth_type only */
+		rx_prectlf_rec.match_mask = 0xf; /* match for eth_type */
+		rx_prectlf_rec.action = 0; /* Bypass MACSEC modules */
+		tbl_idx =
+			NUMROWS_INGRESSPRECTLFRECORD - num_ctl_ether_types - 1;
+		aq_mss_set_ingress_prectlf_record(hw, &rx_prectlf_rec, tbl_idx);
+
 		num_ctl_ether_types++;
 	}
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
index 5ab0ee4bea73..b8485c1cb667 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -31,6 +31,11 @@ struct aq_macsec_txsc {
 };
 
 struct aq_macsec_rxsc {
+	u32 hw_sc_idx;
+	unsigned long rx_sa_idx_busy;
+	const struct macsec_secy *sw_secy;
+	const struct macsec_rx_sc *sw_rxsc;
+	u8 rx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
 };
 
 struct aq_macsec_cfg {
-- 
2.17.1

