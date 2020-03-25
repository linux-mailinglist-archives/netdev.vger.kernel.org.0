Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146CF1928F7
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 13:53:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727560AbgCYMxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 08:53:25 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:62868 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727046AbgCYMxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 08:53:24 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02PCp9W9014712;
        Wed, 25 Mar 2020 05:53:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0818; bh=qRzMPHMF7P4mGc2SuvSnzRPISyHPDgZRv9c6ywz9Ll0=;
 b=zLjfPv6Ih9zDa0LALFrlTEKQlJIKbiC02gyi5U0BWZTTUK7pkknSwT5YrjmPYiGrpgVk
 UsKVbyNTnih/vgzrwwePozgNBjI7k7fdw73qOqjlnAwxIG8mtVPwRINKgL4+/aDR6nna
 /sSHF8H7pLXvR0bXLN0CFsJGBAimleaaUJtl2Y9zDdYInUQbliX43vZmQYFD6SEfeSwb
 4PzUhZUwEI2893XO3afF0rVNDofFpRuzFhuvpYAEPjNjsOx2UlTSVX4sY6klNZUwiKgT
 BcM2WQlp3u+ERN9lbKzC9b2LoIUDskdPR27MFrGXnR3FkC7eosWp6/+mNksWVXSnWW6t 3w== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3006xkr5qf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 25 Mar 2020 05:53:21 -0700
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 25 Mar
 2020 05:53:19 -0700
Received: from maili.marvell.com (10.93.176.43) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 25 Mar 2020 05:53:18 -0700
Received: from localhost.localdomain (unknown [10.9.16.55])
        by maili.marvell.com (Postfix) with ESMTP id 5E1F53F7041;
        Wed, 25 Mar 2020 05:53:17 -0700 (PDT)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Mark Starovoytov <mstarovoitov@marvell.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        "Dmitry Bogdanov" <dbogdanov@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 12/17] net: atlantic: MACSec egress offload implementation
Date:   Wed, 25 Mar 2020 15:52:41 +0300
Message-ID: <20200325125246.987-13-irusskikh@marvell.com>
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

This patch adds support for MACSec egress HW offloading on Atlantic
network cards.

Signed-off-by: Dmitry Bogdanov <dbogdanov@marvell.com>
Signed-off-by: Mark Starovoytov <mstarovoitov@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../ethernet/aquantia/atlantic/aq_macsec.c    | 660 +++++++++++++++++-
 .../ethernet/aquantia/atlantic/aq_macsec.h    |   4 +
 2 files changed, 656 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
index e9d8852bfbe0..6ca5361387e6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.c
@@ -7,44 +7,503 @@
 #include "aq_nic.h"
 #include <linux/rtnetlink.h>
 
+#include "macsec/macsec_api.h"
+#define AQ_MACSEC_KEY_LEN_128_BIT 16
+#define AQ_MACSEC_KEY_LEN_192_BIT 24
+#define AQ_MACSEC_KEY_LEN_256_BIT 32
+
+enum aq_clear_type {
+	/* update HW configuration */
+	AQ_CLEAR_HW = BIT(0),
+	/* update SW configuration (busy bits, pointers) */
+	AQ_CLEAR_SW = BIT(1),
+	/* update both HW and SW configuration */
+	AQ_CLEAR_ALL = AQ_CLEAR_HW | AQ_CLEAR_SW,
+};
+
+static int aq_clear_txsc(struct aq_nic_s *nic, const int txsc_idx,
+			 enum aq_clear_type clear_type);
+static int aq_clear_txsa(struct aq_nic_s *nic, struct aq_macsec_txsc *aq_txsc,
+			 const int sa_num, enum aq_clear_type clear_type);
+static int aq_clear_secy(struct aq_nic_s *nic, const struct macsec_secy *secy,
+			 enum aq_clear_type clear_type);
+static int aq_apply_macsec_cfg(struct aq_nic_s *nic);
+static int aq_apply_secy_cfg(struct aq_nic_s *nic,
+			     const struct macsec_secy *secy);
+
+static void aq_ether_addr_to_mac(u32 mac[2], unsigned char *emac)
+{
+	u32 tmp[2] = { 0 };
+
+	memcpy(((u8 *)tmp) + 2, emac, ETH_ALEN);
+
+	mac[0] = swab32(tmp[1]);
+	mac[1] = swab32(tmp[0]);
+}
+
+/* There's a 1:1 mapping between SecY and TX SC */
+static int aq_get_txsc_idx_from_secy(struct aq_macsec_cfg *macsec_cfg,
+				     const struct macsec_secy *secy)
+{
+	int i;
+
+	if (unlikely(!secy))
+		return -1;
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (macsec_cfg->aq_txsc[i].sw_secy == secy)
+			return i;
+	}
+	return -1;
+}
+
+static int aq_get_txsc_idx_from_sc_idx(const enum aq_macsec_sc_sa sc_sa,
+				       const int sc_idx)
+{
+	switch (sc_sa) {
+	case aq_macsec_sa_sc_4sa_8sc:
+		return sc_idx >> 2;
+	case aq_macsec_sa_sc_2sa_16sc:
+		return sc_idx >> 1;
+	case aq_macsec_sa_sc_1sa_32sc:
+		return sc_idx;
+	default:
+		WARN_ONCE(true, "Invalid sc_sa");
+	}
+	return -1;
+}
+
+/* Rotate keys u32[8] */
+static void aq_rotate_keys(u32 (*key)[8], const int key_len)
+{
+	u32 tmp[8] = { 0 };
+
+	memcpy(&tmp, key, sizeof(tmp));
+	memset(*key, 0, sizeof(*key));
+
+	if (key_len == AQ_MACSEC_KEY_LEN_128_BIT) {
+		(*key)[0] = swab32(tmp[3]);
+		(*key)[1] = swab32(tmp[2]);
+		(*key)[2] = swab32(tmp[1]);
+		(*key)[3] = swab32(tmp[0]);
+	} else if (key_len == AQ_MACSEC_KEY_LEN_192_BIT) {
+		(*key)[0] = swab32(tmp[5]);
+		(*key)[1] = swab32(tmp[4]);
+		(*key)[2] = swab32(tmp[3]);
+		(*key)[3] = swab32(tmp[2]);
+		(*key)[4] = swab32(tmp[1]);
+		(*key)[5] = swab32(tmp[0]);
+	} else if (key_len == AQ_MACSEC_KEY_LEN_256_BIT) {
+		(*key)[0] = swab32(tmp[7]);
+		(*key)[1] = swab32(tmp[6]);
+		(*key)[2] = swab32(tmp[5]);
+		(*key)[3] = swab32(tmp[4]);
+		(*key)[4] = swab32(tmp[3]);
+		(*key)[5] = swab32(tmp[2]);
+		(*key)[6] = swab32(tmp[1]);
+		(*key)[7] = swab32(tmp[0]);
+	} else {
+		pr_warn("Rotate_keys: invalid key_len\n");
+	}
+}
+
 static int aq_mdo_dev_open(struct macsec_context *ctx)
 {
-	return 0;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	int ret = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (netif_carrier_ok(nic->ndev))
+		ret = aq_apply_secy_cfg(nic, ctx->secy);
+
+	return ret;
 }
 
 static int aq_mdo_dev_stop(struct macsec_context *ctx)
 {
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	int i;
+
+	if (ctx->prepare)
+		return 0;
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (nic->macsec_cfg->txsc_idx_busy & BIT(i))
+			aq_clear_secy(nic, nic->macsec_cfg->aq_txsc[i].sw_secy,
+				      AQ_CLEAR_HW);
+	}
+
 	return 0;
 }
 
+static int aq_set_txsc(struct aq_nic_s *nic, const int txsc_idx)
+{
+	struct aq_macsec_txsc *aq_txsc = &nic->macsec_cfg->aq_txsc[txsc_idx];
+	struct aq_mss_egress_class_record tx_class_rec = { 0 };
+	const struct macsec_secy *secy = aq_txsc->sw_secy;
+	struct aq_mss_egress_sc_record sc_rec = { 0 };
+	unsigned int sc_idx = aq_txsc->hw_sc_idx;
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+
+	aq_ether_addr_to_mac(tx_class_rec.mac_sa, secy->netdev->dev_addr);
+
+	put_unaligned_be64((__force u64)secy->sci, tx_class_rec.sci);
+	tx_class_rec.sci_mask = 0;
+
+	tx_class_rec.sa_mask = 0x3f;
+
+	tx_class_rec.action = 0; /* forward to SA/SC table */
+	tx_class_rec.valid = 1;
+
+	tx_class_rec.sc_idx = sc_idx;
+
+	tx_class_rec.sc_sa = nic->macsec_cfg->sc_sa;
+
+	ret = aq_mss_set_egress_class_record(hw, &tx_class_rec, txsc_idx);
+	if (ret)
+		return ret;
+
+	sc_rec.protect = secy->protect_frames;
+	if (secy->tx_sc.encrypt)
+		sc_rec.tci |= BIT(1);
+	if (secy->tx_sc.scb)
+		sc_rec.tci |= BIT(2);
+	if (secy->tx_sc.send_sci)
+		sc_rec.tci |= BIT(3);
+	if (secy->tx_sc.end_station)
+		sc_rec.tci |= BIT(4);
+	/* The C bit is clear if and only if the Secure Data is
+	 * exactly the same as the User Data and the ICV is 16 octets long.
+	 */
+	if (!(secy->icv_len == 16 && !secy->tx_sc.encrypt))
+		sc_rec.tci |= BIT(0);
+
+	sc_rec.an_roll = 0;
+
+	switch (secy->key_len) {
+	case AQ_MACSEC_KEY_LEN_128_BIT:
+		sc_rec.sak_len = 0;
+		break;
+	case AQ_MACSEC_KEY_LEN_192_BIT:
+		sc_rec.sak_len = 1;
+		break;
+	case AQ_MACSEC_KEY_LEN_256_BIT:
+		sc_rec.sak_len = 2;
+		break;
+	default:
+		WARN_ONCE(true, "Invalid sc_sa");
+		return -EINVAL;
+	}
+
+	sc_rec.curr_an = secy->tx_sc.encoding_sa;
+	sc_rec.valid = 1;
+	sc_rec.fresh = 1;
+
+	return aq_mss_set_egress_sc_record(hw, &sc_rec, sc_idx);
+}
+
+static u32 aq_sc_idx_max(const enum aq_macsec_sc_sa sc_sa)
+{
+	u32 result = 0;
+
+	switch (sc_sa) {
+	case aq_macsec_sa_sc_4sa_8sc:
+		result = 8;
+		break;
+	case aq_macsec_sa_sc_2sa_16sc:
+		result = 16;
+		break;
+	case aq_macsec_sa_sc_1sa_32sc:
+		result = 32;
+		break;
+	default:
+		break;
+	};
+
+	return result;
+}
+
+static u32 aq_to_hw_sc_idx(const u32 sc_idx, const enum aq_macsec_sc_sa sc_sa)
+{
+	switch (sc_sa) {
+	case aq_macsec_sa_sc_4sa_8sc:
+		return sc_idx << 2;
+	case aq_macsec_sa_sc_2sa_16sc:
+		return sc_idx << 1;
+	case aq_macsec_sa_sc_1sa_32sc:
+		return sc_idx;
+	default:
+		WARN_ONCE(true, "Invalid sc_sa");
+	};
+
+	return sc_idx;
+}
+
+static enum aq_macsec_sc_sa sc_sa_from_num_an(const int num_an)
+{
+	enum aq_macsec_sc_sa sc_sa = aq_macsec_sa_sc_not_used;
+
+	switch (num_an) {
+	case 4:
+		sc_sa = aq_macsec_sa_sc_4sa_8sc;
+		break;
+	case 2:
+		sc_sa = aq_macsec_sa_sc_2sa_16sc;
+		break;
+	case 1:
+		sc_sa = aq_macsec_sa_sc_1sa_32sc;
+		break;
+	default:
+		break;
+	}
+
+	return sc_sa;
+}
+
 static int aq_mdo_add_secy(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	const struct macsec_secy *secy = ctx->secy;
+	enum aq_macsec_sc_sa sc_sa;
+	u32 txsc_idx;
+	int ret = 0;
+
+	sc_sa = sc_sa_from_num_an(MACSEC_NUM_AN);
+	if (sc_sa == aq_macsec_sa_sc_not_used)
+		return -EINVAL;
+
+	if (hweight32(cfg->txsc_idx_busy) >= aq_sc_idx_max(sc_sa))
+		return -ENOSPC;
+
+	txsc_idx = ffz(cfg->txsc_idx_busy);
+	if (txsc_idx == AQ_MACSEC_MAX_SC)
+		return -ENOSPC;
+
+	if (ctx->prepare)
+		return 0;
+
+	cfg->sc_sa = sc_sa;
+	cfg->aq_txsc[txsc_idx].hw_sc_idx = aq_to_hw_sc_idx(txsc_idx, sc_sa);
+	cfg->aq_txsc[txsc_idx].sw_secy = secy;
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
+		ret = aq_set_txsc(nic, txsc_idx);
+
+	set_bit(txsc_idx, &cfg->txsc_idx_busy);
+
+	return 0;
 }
 
 static int aq_mdo_upd_secy(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	const struct macsec_secy *secy = ctx->secy;
+	int txsc_idx;
+	int ret = 0;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
+	if (txsc_idx < 0)
+		return -ENOENT;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
+		ret = aq_set_txsc(nic, txsc_idx);
+
+	return ret;
+}
+
+static int aq_clear_txsc(struct aq_nic_s *nic, const int txsc_idx,
+			 enum aq_clear_type clear_type)
+{
+	struct aq_macsec_txsc *tx_sc = &nic->macsec_cfg->aq_txsc[txsc_idx];
+	struct aq_mss_egress_class_record tx_class_rec = { 0 };
+	struct aq_mss_egress_sc_record sc_rec = { 0 };
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+	int sa_num;
+
+	for_each_set_bit (sa_num, &tx_sc->tx_sa_idx_busy, AQ_MACSEC_MAX_SA) {
+		ret = aq_clear_txsa(nic, tx_sc, sa_num, clear_type);
+		if (ret)
+			return ret;
+	}
+
+	if (clear_type & AQ_CLEAR_HW) {
+		ret = aq_mss_set_egress_class_record(hw, &tx_class_rec,
+						     txsc_idx);
+		if (ret)
+			return ret;
+
+		sc_rec.fresh = 1;
+		ret = aq_mss_set_egress_sc_record(hw, &sc_rec,
+						  tx_sc->hw_sc_idx);
+		if (ret)
+			return ret;
+	}
+
+	if (clear_type & AQ_CLEAR_SW) {
+		clear_bit(txsc_idx, &nic->macsec_cfg->txsc_idx_busy);
+		nic->macsec_cfg->aq_txsc[txsc_idx].sw_secy = NULL;
+	}
+
+	return ret;
 }
 
 static int aq_mdo_del_secy(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	int ret = 0;
+
+	if (ctx->prepare)
+		return 0;
+
+	if (!nic->macsec_cfg)
+		return 0;
+
+	ret = aq_clear_secy(nic, ctx->secy, AQ_CLEAR_ALL);
+
+	return ret;
+}
+
+static int aq_update_txsa(struct aq_nic_s *nic, const unsigned int sc_idx,
+			  const struct macsec_secy *secy,
+			  const struct macsec_tx_sa *tx_sa,
+			  const unsigned char *key, const unsigned char an)
+{
+	struct aq_mss_egress_sakey_record key_rec;
+	const unsigned int sa_idx = sc_idx | an;
+	struct aq_mss_egress_sa_record sa_rec;
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+
+	memset(&sa_rec, 0, sizeof(sa_rec));
+	sa_rec.valid = tx_sa->active;
+	sa_rec.fresh = 1;
+	sa_rec.next_pn = tx_sa->next_pn;
+
+	ret = aq_mss_set_egress_sa_record(hw, &sa_rec, sa_idx);
+	if (ret)
+		return ret;
+
+	if (!key)
+		return ret;
+
+	memset(&key_rec, 0, sizeof(key_rec));
+	memcpy(&key_rec.key, key, secy->key_len);
+
+	aq_rotate_keys(&key_rec.key, secy->key_len);
+
+	ret = aq_mss_set_egress_sakey_record(hw, &key_rec, sa_idx);
+
+	return ret;
 }
 
 static int aq_mdo_add_txsa(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	const struct macsec_secy *secy = ctx->secy;
+	struct aq_macsec_txsc *aq_txsc;
+	int txsc_idx;
+	int ret = 0;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(cfg, secy);
+	if (txsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_txsc = &cfg->aq_txsc[txsc_idx];
+	set_bit(ctx->sa.assoc_num, &aq_txsc->tx_sa_idx_busy);
+
+	memcpy(aq_txsc->tx_sa_key[ctx->sa.assoc_num], ctx->sa.key,
+	       secy->key_len);
+
+	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
+		ret = aq_update_txsa(nic, aq_txsc->hw_sc_idx, secy,
+				     ctx->sa.tx_sa, ctx->sa.key,
+				     ctx->sa.assoc_num);
+
+	return ret;
 }
 
 static int aq_mdo_upd_txsa(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	const struct macsec_secy *secy = ctx->secy;
+	struct aq_macsec_txsc *aq_txsc;
+	int txsc_idx;
+	int ret = 0;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(cfg, secy);
+	if (txsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	aq_txsc = &cfg->aq_txsc[txsc_idx];
+	if (netif_carrier_ok(nic->ndev) && netif_running(secy->netdev))
+		ret = aq_update_txsa(nic, aq_txsc->hw_sc_idx, secy,
+				     ctx->sa.tx_sa, NULL, ctx->sa.assoc_num);
+
+	return ret;
+}
+
+static int aq_clear_txsa(struct aq_nic_s *nic, struct aq_macsec_txsc *aq_txsc,
+			 const int sa_num, enum aq_clear_type clear_type)
+{
+	const int sa_idx = aq_txsc->hw_sc_idx | sa_num;
+	struct aq_hw_s *hw = nic->aq_hw;
+	int ret = 0;
+
+	if (clear_type & AQ_CLEAR_SW)
+		clear_bit(sa_num, &aq_txsc->tx_sa_idx_busy);
+
+	if ((clear_type & AQ_CLEAR_HW) && netif_carrier_ok(nic->ndev)) {
+		struct aq_mss_egress_sakey_record key_rec;
+		struct aq_mss_egress_sa_record sa_rec;
+
+		memset(&sa_rec, 0, sizeof(sa_rec));
+		sa_rec.fresh = 1;
+
+		ret = aq_mss_set_egress_sa_record(hw, &sa_rec, sa_idx);
+		if (ret)
+			return ret;
+
+		memset(&key_rec, 0, sizeof(key_rec));
+		return aq_mss_set_egress_sakey_record(hw, &key_rec, sa_idx);
+	}
+
+	return 0;
 }
 
 static int aq_mdo_del_txsa(struct macsec_context *ctx)
 {
-	return -EOPNOTSUPP;
+	struct aq_nic_s *nic = netdev_priv(ctx->netdev);
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	int txsc_idx;
+	int ret = 0;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(cfg, ctx->secy);
+	if (txsc_idx < 0)
+		return -EINVAL;
+
+	if (ctx->prepare)
+		return 0;
+
+	ret = aq_clear_txsa(nic, &cfg->aq_txsc[txsc_idx], ctx->sa.assoc_num,
+			    AQ_CLEAR_ALL);
+
+	return ret;
 }
 
 static int aq_mdo_add_rxsc(struct macsec_context *ctx)
@@ -77,8 +536,170 @@ static int aq_mdo_del_rxsa(struct macsec_context *ctx)
 	return -EOPNOTSUPP;
 }
 
+static int apply_txsc_cfg(struct aq_nic_s *nic, const int txsc_idx)
+{
+	struct aq_macsec_txsc *aq_txsc = &nic->macsec_cfg->aq_txsc[txsc_idx];
+	const struct macsec_secy *secy = aq_txsc->sw_secy;
+	struct macsec_tx_sa *tx_sa;
+	int ret = 0;
+	int i;
+
+	if (!netif_running(secy->netdev))
+		return ret;
+
+	ret = aq_set_txsc(nic, txsc_idx);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < MACSEC_NUM_AN; i++) {
+		tx_sa = rcu_dereference_bh(secy->tx_sc.sa[i]);
+		if (tx_sa) {
+			ret = aq_update_txsa(nic, aq_txsc->hw_sc_idx, secy,
+					     tx_sa, aq_txsc->tx_sa_key[i], i);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int aq_clear_secy(struct aq_nic_s *nic, const struct macsec_secy *secy,
+			 enum aq_clear_type clear_type)
+{
+	int txsc_idx;
+	int ret = 0;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
+	if (txsc_idx >= 0) {
+		ret = aq_clear_txsc(nic, txsc_idx, clear_type);
+		if (ret)
+			return ret;
+	}
+
+	return ret;
+}
+
+static int aq_apply_secy_cfg(struct aq_nic_s *nic,
+			     const struct macsec_secy *secy)
+{
+	int txsc_idx;
+	int ret = 0;
+
+	txsc_idx = aq_get_txsc_idx_from_secy(nic->macsec_cfg, secy);
+	if (txsc_idx >= 0)
+		apply_txsc_cfg(nic, txsc_idx);
+
+	return ret;
+}
+
+static int aq_apply_macsec_cfg(struct aq_nic_s *nic)
+{
+	int ret = 0;
+	int i;
+
+	for (i = 0; i < AQ_MACSEC_MAX_SC; i++) {
+		if (nic->macsec_cfg->txsc_idx_busy & BIT(i)) {
+			ret = apply_txsc_cfg(nic, i);
+			if (ret)
+				return ret;
+		}
+	}
+
+	return ret;
+}
+
+static int aq_sa_from_sa_idx(const enum aq_macsec_sc_sa sc_sa, const int sa_idx)
+{
+	switch (sc_sa) {
+	case aq_macsec_sa_sc_4sa_8sc:
+		return sa_idx & 3;
+	case aq_macsec_sa_sc_2sa_16sc:
+		return sa_idx & 1;
+	case aq_macsec_sa_sc_1sa_32sc:
+		return 0;
+	default:
+		WARN_ONCE(true, "Invalid sc_sa");
+	}
+	return -EINVAL;
+}
+
+static int aq_sc_idx_from_sa_idx(const enum aq_macsec_sc_sa sc_sa,
+				 const int sa_idx)
+{
+	switch (sc_sa) {
+	case aq_macsec_sa_sc_4sa_8sc:
+		return sa_idx & ~3;
+	case aq_macsec_sa_sc_2sa_16sc:
+		return sa_idx & ~1;
+	case aq_macsec_sa_sc_1sa_32sc:
+		return sa_idx;
+	default:
+		WARN_ONCE(true, "Invalid sc_sa");
+	}
+	return -EINVAL;
+}
+
 static void aq_check_txsa_expiration(struct aq_nic_s *nic)
 {
+	u32 egress_sa_expired, egress_sa_threshold_expired;
+	struct aq_macsec_cfg *cfg = nic->macsec_cfg;
+	struct aq_hw_s *hw = nic->aq_hw;
+	struct aq_macsec_txsc *aq_txsc;
+	const struct macsec_secy *secy;
+	int sc_idx = 0, txsc_idx = 0;
+	enum aq_macsec_sc_sa sc_sa;
+	struct macsec_tx_sa *tx_sa;
+	unsigned char an = 0;
+	int ret;
+	int i;
+
+	sc_sa = cfg->sc_sa;
+
+	ret = aq_mss_get_egress_sa_expired(hw, &egress_sa_expired);
+	if (unlikely(ret))
+		return;
+
+	ret = aq_mss_get_egress_sa_threshold_expired(hw,
+		&egress_sa_threshold_expired);
+
+	for (i = 0; i < AQ_MACSEC_MAX_SA; i++) {
+		if (egress_sa_expired & BIT(i)) {
+			an = aq_sa_from_sa_idx(sc_sa, i);
+			sc_idx = aq_sc_idx_from_sa_idx(sc_sa, i);
+			txsc_idx = aq_get_txsc_idx_from_sc_idx(sc_sa, sc_idx);
+			if (txsc_idx < 0)
+				continue;
+
+			aq_txsc = &cfg->aq_txsc[txsc_idx];
+			if (!(cfg->txsc_idx_busy & BIT(txsc_idx))) {
+				netdev_warn(nic->ndev,
+					"PN threshold expired on invalid TX SC");
+				continue;
+			}
+
+			secy = aq_txsc->sw_secy;
+			if (!netif_running(secy->netdev)) {
+				netdev_warn(nic->ndev,
+					"PN threshold expired on down TX SC");
+				continue;
+			}
+
+			if (unlikely(!(aq_txsc->tx_sa_idx_busy & BIT(an)))) {
+				netdev_warn(nic->ndev,
+					"PN threshold expired on invalid TX SA");
+				continue;
+			}
+
+			tx_sa = rcu_dereference_bh(secy->tx_sc.sa[an]);
+			macsec_pn_wrapped((struct macsec_secy *)secy, tx_sa);
+		}
+	}
+
+	aq_mss_set_egress_sa_expired(hw, egress_sa_expired);
+	if (likely(!ret))
+		aq_mss_set_egress_sa_threshold_expired(hw,
+			egress_sa_threshold_expired);
 }
 
 const struct macsec_ops aq_macsec_ops = {
@@ -129,10 +750,13 @@ void aq_macsec_free(struct aq_nic_s *nic)
 
 int aq_macsec_enable(struct aq_nic_s *nic)
 {
+	u32 ctl_ether_types[1] = { ETH_P_PAE };
 	struct macsec_msg_fw_response resp = { 0 };
 	struct macsec_msg_fw_request msg = { 0 };
 	struct aq_hw_s *hw = nic->aq_hw;
-	int ret = 0;
+	int num_ctl_ether_types = 0;
+	int index = 0, tbl_idx;
+	int ret;
 
 	if (!nic->macsec_cfg)
 		return 0;
@@ -155,6 +779,26 @@ int aq_macsec_enable(struct aq_nic_s *nic)
 			goto unlock;
 	}
 
+	/* Init Ethertype bypass filters */
+	for (index = 0; index < ARRAY_SIZE(ctl_ether_types); index++) {
+		struct aq_mss_egress_ctlf_record tx_ctlf_rec;
+
+		if (ctl_ether_types[index] == 0)
+			continue;
+
+		memset(&tx_ctlf_rec, 0, sizeof(tx_ctlf_rec));
+		tx_ctlf_rec.eth_type = ctl_ether_types[index];
+		tx_ctlf_rec.match_type = 4; /* Match eth_type only */
+		tx_ctlf_rec.match_mask = 0xf; /* match for eth_type */
+		tx_ctlf_rec.action = 0; /* Bypass MACSEC modules */
+		tbl_idx = NUMROWS_EGRESSCTLFRECORD - num_ctl_ether_types - 1;
+		aq_mss_set_egress_ctlf_record(hw, &tx_ctlf_rec, tbl_idx);
+
+		num_ctl_ether_types++;
+	}
+
+	ret = aq_apply_macsec_cfg(nic);
+
 unlock:
 	rtnl_unlock();
 	return ret;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
index e4c4cf3bea38..5ab0ee4bea73 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_macsec.h
@@ -24,6 +24,10 @@ enum aq_macsec_sc_sa {
 };
 
 struct aq_macsec_txsc {
+	u32 hw_sc_idx;
+	unsigned long tx_sa_idx_busy;
+	const struct macsec_secy *sw_secy;
+	u8 tx_sa_key[MACSEC_NUM_AN][MACSEC_KEYID_LEN];
 };
 
 struct aq_macsec_rxsc {
-- 
2.17.1

