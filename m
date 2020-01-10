Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FD4C136C32
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgAJLnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:43:07 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34245 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbgAJLnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:43:05 -0500
Received: by mail-pl1-f195.google.com with SMTP id x17so773546pln.1
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 03:43:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=6X5IztkHgtVHkRyV/Oszuo14Ifik6eB0VsDCilYnSjM=;
        b=Rd8gQhYXr39T2gL6ACO3JLe/zPNCloNV+FPI3+tK+hdKSdc+VM6c0Sx8CiC+aAa1gl
         Sy1sxsXzIWXPGezphK58MztBwweIHn6+zo6iAgDtm8VGH18hq/Z6YhVVTVFfJnLVb9Rc
         Is8TP/NyCh8XTiH0dfUAlcTe2NEHnVPIvCblapHDmJDLUzPHn0T+T4MjBeRW2OtM1Mks
         LaB1ia0Y9TnG8JqLaInpJFHVMXqumfREOwNnPGKzPXt9PC7/5F9zd3Jwni4qUVotKzc3
         ViQn/GO5Wcptknv8mUQgHIQpQGyQoT8g6cwqV5pVJfCORkEOO7Rof/WAK5pX0F1fIeU9
         M39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=6X5IztkHgtVHkRyV/Oszuo14Ifik6eB0VsDCilYnSjM=;
        b=oL75XZT3fpMO13RHlsCj/BZTo8PdJC8ktqCqLoZUOJvk/jJKsB+6Pm+/i56gkAo36j
         befijJkhoSj6R+dgHugR9qRwlRBK9BfMB2UtxWM2nghZ8gZhHIMdM8qCAjhGClnp2W8N
         oiTqJxBz8MYLSY1K3ZwD3WtqUVqXpuaQzHhD3fPSagxwP9ZC2RVcXDoyFQHDhNip6PZv
         3+38zzSmB1iOWYrY4gSf7Rnbivp+srngqXAPNDClEC7Gz07R2ZqLrc/dImEYoOih5IkA
         GxqkTSC8Kp1JKNbPHmkpjrsXvOsCwDj5uQKObQuFHgYqG6ji5EklSskhyqVtzieVf//z
         XxtQ==
X-Gm-Message-State: APjAAAVCoKX/ZEyFyQAjxUYc7zax6BGcfDotWDfz1iq2MbfHT8sArvOo
        ei6bO10KcliASD/ZlrDoh0JJje7Ucrs=
X-Google-Smtp-Source: APXvYqxH2mP2UylOc/WUamZqiUvKF60MtqPSgOYhbx2XosN1b6iI9RxoI2JhKWq+5X6+kCwKjWyvwg==
X-Received: by 2002:a17:90a:a014:: with SMTP id q20mr4297399pjp.60.1578656584489;
        Fri, 10 Jan 2020 03:43:04 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id o19sm8848866pjr.2.2020.01.10.03.43.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 10 Jan 2020 03:43:03 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>,
        Prakash Brahmajyosyula <bprakash@marvell.com>
Subject: [PATCH 15/17] octeontx2-pf: ethtool RSS config support
Date:   Fri, 10 Jan 2020 17:11:59 +0530
Message-Id: <1578656521-14189-16-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1578656521-14189-1-git-send-email-sunil.kovvuri@gmail.com>
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
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 239 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |  13 +-
 4 files changed, 258 insertions(+), 6 deletions(-)

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
index d8e7565..c82555f 100644
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
index f1ee9c2..ad30de0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c
@@ -401,7 +401,238 @@ static int otx2_set_coalesce(struct net_device *netdev,
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
+		if ((nfc->data & rxh_l4) == rxh_l4)
+			rss_cfg |= NIX_FLOW_KEY_TYPE_TCP;
+		else
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_TCP;
+		break;
+	case UDP_V4_FLOW:
+	case UDP_V6_FLOW:
+		if ((nfc->data & rxh_l4) == rxh_l4)
+			rss_cfg |= NIX_FLOW_KEY_TYPE_UDP;
+		else
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_UDP;
+		break;
+	case SCTP_V4_FLOW:
+	case SCTP_V6_FLOW:
+		if ((nfc->data & rxh_l4) == rxh_l4)
+			rss_cfg |= NIX_FLOW_KEY_TYPE_SCTP;
+		else
+			rss_cfg &= ~NIX_FLOW_KEY_TYPE_SCTP;
+		break;
+	case AH_ESP_V4_FLOW:
+	case AH_V4_FLOW:
+	case ESP_V4_FLOW:
+	case IPV4_FLOW:
+	case AH_ESP_V6_FLOW:
+	case AH_V6_FLOW:
+	case ESP_V6_FLOW:
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
@@ -412,6 +643,14 @@ static const struct ethtool_ops otx2_ethtool_ops = {
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

