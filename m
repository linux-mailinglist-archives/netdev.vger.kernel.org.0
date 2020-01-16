Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B800F13F9D5
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 20:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730117AbgAPTsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 14:48:33 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38102 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730020AbgAPTsc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 14:48:32 -0500
Received: by mail-pj1-f66.google.com with SMTP id l35so2143351pje.3
        for <netdev@vger.kernel.org>; Thu, 16 Jan 2020 11:48:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2HbIoaVb/CGZVqs5I1Udem+puHBLT1a/174QvJxtSYk=;
        b=DWdamYJ8sjVuyCsY5yJx5EqPuOiQ6c1JcvvEMk/cgpE/ors/66Y7mjs8j8wyNrjkol
         8A3/1BVBHW9z5kF4i/SJZ8PU72KWJRpy0Kj7flZRi1f3Lk+43Cf8NyznfdBi/+A2/CsR
         Is7xE/RbCtgRMGmPyzdDtT1F7RQETZ5ure+1g6bjnfIa2dGqYrtbwQ5BvcmV+zDmyki+
         EyEVBq3YX1evVmrr/PFNPL/DAWxFv01YoWbvQXM7iifjB7k/+4ST/KVRHGYEAyiRaBYo
         g9AlseHh24V1zisnCG33rre6bM5MdPytp4lubwjlOych7B55/CJBzXpaEniVvpZCmW/3
         lz9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2HbIoaVb/CGZVqs5I1Udem+puHBLT1a/174QvJxtSYk=;
        b=Z+9MpHUx4MkBCePAPtOzDb64TkvyiifVKlMoVtMj9FWnD3HzwPxKQNAMFvd8jNK9M6
         hZYJDNtUhhUkI13JGxm0aqaUiUgEsaA5DxMgnrGRRJKR4nLWmAeLxcVpzSInzmueVtqH
         61ZFqZ0O0IY04Pl2dQ9kKmKVbt2R0KBy0P6iaXIGwzK0MKd3FrMOE0Om0TnKH/xDC004
         Gr6ETEHX3kLBv8p/51UROS1mwyH0UWMFpYotPpj1sggFj3wbB20XyhfMf/ZDFDB+u4Zp
         pgXPN64pHQpykKFyMWZ4TxoNuPRw6astNhb04wlf8K+YBarjMDz/zogTUGrjjqI3sN2U
         lCgg==
X-Gm-Message-State: APjAAAUWcUN/TS4uGP3r+obn6hBZ1PNMoHJ1JzL2a4tm2YR9S1KU9Yon
        /XuCTgCM22fP/ykTQPRMnGkUcu8wgMU=
X-Google-Smtp-Source: APXvYqxHWua6DxwJlKqT7QEum3oh93gNuljjBcfAyWEzJypjRMvZnEhDpir+2dLagA31ak6xbayqGg==
X-Received: by 2002:a17:902:aa45:: with SMTP id c5mr33884389plr.305.1579204110835;
        Thu, 16 Jan 2020 11:48:30 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j28sm26174623pgb.36.2020.01.16.11.48.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 16 Jan 2020 11:48:30 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Subject: [PATCH v3 15/17] octeontx2-pf: ethtool RSS config support
Date:   Fri, 17 Jan 2020 01:17:31 +0530
Message-Id: <1579204053-28797-16-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579204053-28797-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Added support to show or configure RSS hash key, indirection table,
2,4 tuple via ethtool. Also added debug msg_level support
to dump messages when HW reports errors in packet received
or transmitted.

Signed-off-by: Prakash Brahmajyosyula <bprakash@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 .../ethernet/marvell/octeontx2/nic/otx2_common.c   |   6 +-
 .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 251 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  13 +-
 4 files changed, 270 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 3de1fcf..6e4a108 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
@@ -220,7 +220,7 @@ int otx2_hw_set_mtu(struct otx2_nic *pfvf, int mtu)
 	return err;
 }
 
-static int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
+int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
 	struct nix_rss_flowkey_cfg *req;
@@ -241,7 +241,7 @@ static int otx2_set_flowkey_cfg(struct otx2_nic *pfvf)
 	return err;
 }
 
-static int otx2_set_rss_table(struct otx2_nic *pfvf)
+int otx2_set_rss_table(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
 	struct mbox *mbox = &pfvf->mbox;
@@ -280,7 +280,7 @@ static int otx2_set_rss_table(struct otx2_nic *pfvf)
 	return err;
 }
 
-static void otx2_set_rss_key(struct otx2_nic *pfvf)
+void otx2_set_rss_key(struct otx2_nic *pfvf)
 {
 	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
 	u64 *key = (u64 *)&rss->key[4];
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 28dcfab..31aeb48 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -222,6 +222,9 @@ struct otx2_nic {
 	struct work_struct	reset_task;
 	struct refill_work	*refill_wrk;
 
+	/* Ethtool stuff */
+	u32			msg_enable;
+
 	/* Block address of NIX either BLKADDR_NIX0 or BLKADDR_NIX1 */
 	int			nix_blkaddr;
 };
@@ -580,6 +583,9 @@ void otx2_cleanup_tx_cqes(struct otx2_nic *pfvf, struct otx2_cq_queue *cq);
 
 /* RSS configuration APIs*/
 int otx2_rss_init(struct otx2_nic *pfvf);
+int otx2_set_flowkey_cfg(struct otx2_nic *pfvf);
+void otx2_set_rss_key(struct otx2_nic *pfvf);
+int otx2_set_rss_table(struct otx2_nic *pfvf);
 
 /* Mbox handlers */
 void mbox_handler_msix_offset(struct otx2_nic *pfvf,
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
index 35c2533..eec4270 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -391,7 +391,250 @@ static int otx2_set_coalesce(struct net_device *netdev,
 	return 0;
 }
 
+static int otx2_get_rss_hash_opts(struct otx2_nic *pfvf,
+				  struct ethtool_rxnfc *nfc)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+
+	if (!(rss->flowkey_cfg &
+	    (NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6)))
+		return 0;
+
+	/* Mimimum is IPv4 and IPv6, SIP/DIP */
+	nfc->data = RXH_IP_SRC | RXH_IP_DST;
+
+	switch (nfc->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+		if (rss->flowkey_cfg & NIX_FLOW_KEY_TYPE_TCP)
+			nfc->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case UDP_V4_FLOW:
+	case UDP_V6_FLOW:
+		if (rss->flowkey_cfg & NIX_FLOW_KEY_TYPE_UDP)
+			nfc->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case SCTP_V4_FLOW:
+	case SCTP_V6_FLOW:
+		if (rss->flowkey_cfg & NIX_FLOW_KEY_TYPE_SCTP)
+			nfc->data |= RXH_L4_B_0_1 | RXH_L4_B_2_3;
+		break;
+	case AH_ESP_V4_FLOW:
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+	case IPV4_FLOW:
+	case AH_ESP_V6_FLOW:
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
+	case IPV6_FLOW:
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int otx2_set_rss_hash_opts(struct otx2_nic *pfvf,
+				  struct ethtool_rxnfc *nfc)
+{
+	struct otx2_rss_info *rss = &pfvf->hw.rss_info;
+	u32 rxh_l4 = RXH_L4_B_0_1 | RXH_L4_B_2_3;
+	u32 rss_cfg = rss->flowkey_cfg;
+
+	if (!rss->enable)
+		netdev_err(pfvf->netdev, "RSS is disabled, cmd ignored\n");
+
+	/* Mimimum is IPv4 and IPv6, SIP/DIP */
+	if (!(nfc->data & RXH_IP_SRC) || !(nfc->data & RXH_IP_DST))
+		return -EINVAL;
+
+	switch (nfc->flow_type) {
+	case TCP_V4_FLOW:
+	case TCP_V6_FLOW:
+		/* Different config for v4 and v6 is not supported.
+		 * Both of them have to be either 4-tuple or 2-tuple.
+		 */
+		switch (nfc->data & rxh_l4) {
+		case 0:
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_TCP;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_cfg |= NIX_FLOW_KEY_TYPE_TCP;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case UDP_V4_FLOW:
+	case UDP_V6_FLOW:
+		switch (nfc->data & rxh_l4) {
+		case 0:
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_UDP;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_cfg |= NIX_FLOW_KEY_TYPE_UDP;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case SCTP_V4_FLOW:
+	case SCTP_V6_FLOW:
+		switch (nfc->data & rxh_l4) {
+		case 0:
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_SCTP;
+			break;
+		case (RXH_L4_B_0_1 | RXH_L4_B_2_3):
+			rss_cfg |= NIX_FLOW_KEY_TYPE_SCTP;
+			break;
+		default:
+			return -EINVAL;
+		}
+		break;
+	case IPV4_FLOW:
+	case IPV6_FLOW:
+		rss_cfg = NIX_FLOW_KEY_TYPE_IPV4 | NIX_FLOW_KEY_TYPE_IPV6;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	rss->flowkey_cfg = rss_cfg;
+	otx2_set_flowkey_cfg(pfvf);
+	return 0;
+}
+
+static int otx2_get_rxnfc(struct net_device *dev,
+			  struct ethtool_rxnfc *nfc, u32 *rules)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	switch (nfc->cmd) {
+	case ETHTOOL_GRXRINGS:
+		nfc->data = pfvf->hw.rx_queues;
+		ret = 0;
+		break;
+	case ETHTOOL_GRXFH:
+		return otx2_get_rss_hash_opts(pfvf, nfc);
+	default:
+		break;
+	}
+	return ret;
+}
+
+static int otx2_set_rxnfc(struct net_device *dev, struct ethtool_rxnfc *nfc)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	int ret = -EOPNOTSUPP;
+
+	switch (nfc->cmd) {
+	case ETHTOOL_SRXFH:
+		ret = otx2_set_rss_hash_opts(pfvf, nfc);
+		break;
+	default:
+		break;
+	}
+
+	return ret;
+}
+
+static u32 otx2_get_rxfh_key_size(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+	struct otx2_rss_info *rss;
+
+	rss = &pfvf->hw.rss_info;
+
+	return sizeof(rss->key);
+}
+
+static u32 otx2_get_rxfh_indir_size(struct net_device *dev)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+
+	return pfvf->hw.rss_info.rss_size;
+}
+
+/* Get RSS configuration*/
+static int otx2_get_rxfh(struct net_device *dev, u32 *indir,
+			 u8 *hkey, u8 *hfunc)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	struct otx2_rss_info *rss;
+	int idx;
+
+	rss = &pfvf->hw.rss_info;
+
+	if (indir) {
+		for (idx = 0; idx < rss->rss_size; idx++)
+			indir[idx] = rss->ind_tbl[idx];
+	}
+
+	if (hkey)
+		memcpy(hkey, rss->key, sizeof(rss->key));
+
+	if (hfunc)
+		*hfunc = ETH_RSS_HASH_TOP;
+
+	return 0;
+}
+
+/* Configure RSS table and hash key*/
+static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
+			 const u8 *hkey, const u8 hfunc)
+{
+	struct otx2_nic *pfvf = netdev_priv(dev);
+	struct otx2_rss_info *rss;
+	int idx;
+
+	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc != ETH_RSS_HASH_TOP)
+		return -EOPNOTSUPP;
+
+	rss = &pfvf->hw.rss_info;
+
+	if (!rss->enable) {
+		netdev_err(dev, "RSS is disabled, cannot change settings\n");
+		return -EIO;
+	}
+
+	if (indir) {
+		for (idx = 0; idx < rss->rss_size; idx++)
+			rss->ind_tbl[idx] = indir[idx];
+	}
+
+	if (hkey) {
+		memcpy(rss->key, hkey, sizeof(rss->key));
+		otx2_set_rss_key(pfvf);
+	}
+
+	otx2_set_rss_table(pfvf);
+	return 0;
+}
+
+static u32 otx2_get_msglevel(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	return pfvf->msg_enable;
+}
+
+static void otx2_set_msglevel(struct net_device *netdev, u32 val)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	pfvf->msg_enable = val;
+}
+
+static u32 otx2_get_link(struct net_device *netdev)
+{
+	struct otx2_nic *pfvf = netdev_priv(netdev);
+
+	return pfvf->linfo.link_up;
+}
+
 static const struct ethtool_ops otx2_ethtool_ops = {
+	.get_link		= otx2_get_link,
 	.get_drvinfo		= otx2_get_drvinfo,
 	.get_strings		= otx2_get_strings,
 	.get_ethtool_stats	= otx2_get_ethtool_stats,
@@ -402,6 +645,14 @@ static const struct ethtool_ops otx2_ethtool_ops = {
 	.set_ringparam		= otx2_set_ringparam,
 	.get_coalesce		= otx2_get_coalesce,
 	.set_coalesce		= otx2_set_coalesce,
+	.get_rxnfc		= otx2_get_rxnfc,
+	.set_rxnfc              = otx2_set_rxnfc,
+	.get_rxfh_key_size	= otx2_get_rxfh_key_size,
+	.get_rxfh_indir_size	= otx2_get_rxfh_indir_size,
+	.get_rxfh		= otx2_get_rxfh,
+	.set_rxfh		= otx2_set_rxfh,
+	.get_msglevel		= otx2_get_msglevel,
+	.set_msglevel		= otx2_set_msglevel,
 };
 
 void otx2_set_ethtool_ops(struct net_device *netdev)
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 993e045..135506f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -85,9 +85,11 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 	struct sg_list *sg;
 
 	if (unlikely(snd_comp->status)) {
-		netdev_info(pfvf->netdev,
-			    "TX%d: Error in send CQ status:%x\n",
-			    cq->cint_idx, snd_comp->status);
+		if (netif_msg_tx_err(pfvf)) {
+			netdev_info(pfvf->netdev,
+				    "TX%d: Error in send CQ status:%x\n",
+				    cq->cint_idx, snd_comp->status);
+		}
 	}
 
 	/* Barrier, so that update to sq by other cpus is visible */
@@ -148,6 +150,11 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
 	struct otx2_drv_stats *stats = &pfvf->hw.drv_stats;
 	struct nix_rx_parse_s *parse = &cqe->parse;
 
+	if (netif_msg_rx_err(pfvf))
+		netdev_err(pfvf->netdev,
+			   "RQ%d: Error pkt with errlev:0x%x errcode:0x%x\n",
+			   qidx, parse->errlev, parse->errcode);
+
 	if (parse->errlev == NPC_ERRLVL_RE) {
 		switch (parse->errcode) {
 		case ERRCODE_FCS:
-- 
2.7.4

