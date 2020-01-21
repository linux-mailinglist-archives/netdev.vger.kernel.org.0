Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F92C143DF0
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 14:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbgAUNWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 08:22:43 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39701 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgAUNWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 08:22:42 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so1336535plp.6
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 05:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L+N9By85wTacwy5z1pmCq7w8yjF3LWIpjaBTkC/thKU=;
        b=amDc4SJ0XKKcE3omlR7XdYYFWT/7AJ1qubsxMVeElrmGF8sl3gaIjuQfTcp6jqjpYM
         EWS60mfoIW27PZJvH2C6dv/zP3vySt5GuZTjsmRdcFpTgf80Sx/runpU9iK6PlA6XYIL
         CNZVVJ//NRkPrGRnx9/Th31k/Gf3FpNYQZpKZM1pZXTwgGwKx3hgoYF7SQq3wUz9yvPi
         hpIw6ZHjDnqUEz0esElOcl4vmAV3luuIRn3V+1kxgs45UoNCvkWTfLGDVZB6UfASwGEe
         J40unTk67YiEiGF4B7uG1dRrGdKfEIztCa0aBogrdAW92l/At1HtEwb7o1B+6TWuhAGI
         Zhmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L+N9By85wTacwy5z1pmCq7w8yjF3LWIpjaBTkC/thKU=;
        b=SZOo6T9sM8taxjC30hNen+xR2wfsajyjbRIaUvU4U1QT7c+LrsdfswwxfyWZRwkdUZ
         tf1a1zM6VosW5/KLvTiR2pr+UrelGsSjfOgkBdkEOuyoUnuafYJAiIV8dCeIIE/BVEdk
         cSRpjDL/81J7BBCYEPCblq9jsn1a0AsncsLqVb4y3Kxnpgpl5qViEaPDSPrkx3csogGa
         nmqkEb9XnUj7ZbPsyxStipdXi7d8/93jBKjJKYtRWSTtjjoW6LHjF8iEla3q6pVH0Fua
         LTCfhtoo3/8GKIlb3efYoLjgjdEy8LTO+Hn0EEJSR6ExndYabhq8DHxHL90jIhljdDlp
         bbSA==
X-Gm-Message-State: APjAAAWSB2nZd4UUd7l4iXj8XWl6Cht9b9BpFyjAAU1/QlOrleRCw7pw
        cgbqUNv7sKuXBixbEh1qbT0Lw7P+7mY=
X-Google-Smtp-Source: APXvYqyw3xhY+qs1r8vwUKS9hYGYVfUq4CRg6ZhSq4VdowlgHazKgNy3uCuHmYa3sW7rUsuza9ZNVA==
X-Received: by 2002:a17:90a:30a4:: with SMTP id h33mr5424989pjb.50.1579612961636;
        Tue, 21 Jan 2020 05:22:41 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y21sm43328076pfm.136.2020.01.21.05.22.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 21 Jan 2020 05:22:41 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Subject: [PATCH v4 15/17] octeontx2-pf: ethtool RSS config support
Date:   Tue, 21 Jan 2020 18:51:49 +0530
Message-Id: <1579612911-24497-16-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1579612911-24497-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 254 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  13 +-
 4 files changed, 273 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index a8d7966..45c1614 100644
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
index b1f61e0..8c69b63 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -389,7 +389,253 @@ static int otx2_set_coalesce(struct net_device *netdev,
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
+	if (!rss->enable) {
+		netdev_err(pfvf->netdev,
+			   "RSS is disabled, cannot change settings\n");
+		return -EIO;
+	}
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
@@ -400,6 +646,14 @@ static const struct ethtool_ops otx2_ethtool_ops = {
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

