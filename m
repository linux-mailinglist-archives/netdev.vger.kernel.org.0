Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3834714A484
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 14:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbgA0NGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 08:06:35 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:40573 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbgA0NGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 08:06:33 -0500
Received: by mail-pj1-f66.google.com with SMTP id 12so1691073pjb.5
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 05:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ukkm1MAP/PPmG8sCqb4fNKNqLLLP69ddwEFtgbx9G0A=;
        b=MvvNoFRWxntgGsTMmtpyhbpu2/B4Gp4E77qx5cKgPEZPhGdQ8UYxhtnmFow6V/l+0l
         Wbja/YCtEFmBWsJZNGSiqPpW37m5KV7veVII7mGi4+i7syWa3b2fwwpw5N3p0ibGwvlW
         Ip6e2vttgEdueBzY6uKxb8C8/bjFw9K3LuDS0a9zK0p/4cQ1jAghpQZu/l03SIazWPUc
         NAf4Te3cPVgzDbhww357hZ+OBax2MM6kE3Q0nCXiKhlMK0WmquwbXH/U5Xllp6Qmrpbj
         i2gFg7BkdViptwMuBcoQbxkZH+bG8Cs6jPGvuHSa6TPzW5f9uJc46nNUvS61pFFeNpWy
         BaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Ukkm1MAP/PPmG8sCqb4fNKNqLLLP69ddwEFtgbx9G0A=;
        b=myw6xqBwObYmD3FY7s7yaAWVj9X2bL0KrgAcaXSFJfLwFaC0Wj4UcAPc+M6ze2Soxh
         JD7uDOVjwubOWYxTtBHD0J8BTVUUeV06t2+1jyn7ewOaN89QSdWQL/XFWUo5/oRZJtG2
         t/TkbU9Ye7noIH4+Sd6pR8F6PliW9rqFvrFYdK56NryZ9r+MxoZoXLFAJB2iEVuwmv27
         hJCAWD/iBvXcxA+CP9MMT2v0z1rJafJEruBbIaeqSabU8nJKqkuXmdJFZq1C9T8stIFt
         GDLsmf+VNR/MpD043OwvV0enJInXWCKFO1b3r8A27gvUQugeOJYHIYiyL0NW9x/pN160
         zVPA==
X-Gm-Message-State: APjAAAVyiW7Gr0gaYeVF1KGxTujrzzK27TIiPVwC9XtqDQSizrSKhEoE
        JURRuLWf0TmjcQmEIOqGamnImix3eic=
X-Google-Smtp-Source: APXvYqwOL2Mr6NI4BwOJNPZbp1h0jbP2Pyk0757soMtNnTwBVawf/t6hKyry6iAafBc68VPG1PMQfA==
X-Received: by 2002:a17:902:be14:: with SMTP id r20mr10227803pls.280.1580130391639;
        Mon, 27 Jan 2020 05:06:31 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id c15sm17241717pja.30.2020.01.27.05.06.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 Jan 2020 05:06:30 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kubakici@wp.pl, mkubecek@suse.cz,
        maciej.fijalkowski@intel.com, Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Subject: [PATCH v6 15/17] octeontx2-pf: ethtool RSS config support
Date:   Mon, 27 Jan 2020 18:35:29 +0530
Message-Id: <1580130331-8964-16-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1580130331-8964-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |   7 +-
 4 files changed, 269 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
index 07d4559..8247d21 100644
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
index 95557e8..320f3b7 100644
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
index b1f61e0..60fcf82 100644
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
+/* Get RSS configuration */
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
+/* Configure RSS table and hash key */
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
index 6a7ca3b..bef4c20 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -84,7 +84,7 @@ static void otx2_snd_pkt_handler(struct otx2_nic *pfvf,
 	struct sk_buff *skb = NULL;
 	struct sg_list *sg;
 
-	if (unlikely(snd_comp->status))
+	if (unlikely(snd_comp->status) && netif_msg_tx_err(pfvf))
 		net_err_ratelimited("%s: TX%d: Error in send CQ status:%x\n",
 				    pfvf->netdev->name, cq->cint_idx,
 				    snd_comp->status);
@@ -144,6 +144,11 @@ static bool otx2_check_rcv_errors(struct otx2_nic *pfvf,
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

