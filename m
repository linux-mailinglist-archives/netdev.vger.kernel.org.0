Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6445ED3B5
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiI1D7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232932AbiI1D67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:58:59 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45AD1176F0
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:58:54 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RJJQbj006358;
        Tue, 27 Sep 2022 20:58:49 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=qCznu0Ue/l570eh3KkUh+7D3El3xqoWXYiQXTgtPIOU=;
 b=jz5BlYuXy9T0rd6knWSuovb303wVP8RY/amCD35ydJTQ8XQH/183FudeM66PTKBNNJyG
 Ogm8mCnkMXutPvpZLAHBXQS/gQuRf8Nc2PHrq6mgNM++Q31ZSSH6VxfJwEvd8wL1cU/N
 tW6tvzfEQDsIr6ZE2fNRAjiQbX05I+ZENcTimplOiqyUHLv2Njw10J02fNI/bd6YjtIf
 OP/b14CFGV6J4d8GnUfrAVpKG3smapbhO5r46odBwQzd/k4Whw1tpJQj0mcwiE+xczHY
 FnsIJm7EWs+dQ6O2xhHcn8LghP/bSBnGa4CDLNTsIst5RfJDNo+dG9DbC2snhoIQ7Fhm DA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jt1dpcy8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 20:58:48 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 27 Sep
 2022 20:58:46 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 27 Sep 2022 20:58:46 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 9581F3F70E9;
        Tue, 27 Sep 2022 20:58:43 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v2 7/8] octeontx2-af: cn10k: mcs: Add debugfs support
Date:   Wed, 28 Sep 2022 09:28:09 +0530
Message-ID: <1664337490-20231-8-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
References: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: nQNeJ_d4SwL8JNIyE_kpOzSU6cWB-MNW
X-Proofpoint-GUID: nQNeJ_d4SwL8JNIyE_kpOzSU6cWB-MNW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-27_12,2022-09-27_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

This patch adds debugfs entry to dump MCS secy, sc,
sa, flowid and port stats. This helps in debugging
the packet path and to figure out where exactly packet
was dropped.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 346 +++++++++++++++++++++
 2 files changed, 350 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d0268c4..76474385 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -64,6 +64,10 @@ struct rvu_debugfs {
 	struct dentry *nix;
 	struct dentry *npc;
 	struct dentry *cpt;
+	struct dentry *mcs_root;
+	struct dentry *mcs;
+	struct dentry *mcs_rx;
+	struct dentry *mcs_tx;
 	struct dump_ctx npa_aura_ctx;
 	struct dump_ctx npa_pool_ctx;
 	struct dump_ctx nix_cq_ctx;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index f42a09f..c944884 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -19,6 +19,7 @@
 #include "lmac_common.h"
 #include "npc.h"
 #include "rvu_npc_hash.h"
+#include "mcs.h"
 
 #define DEBUGFS_DIR_NAME "octeontx2"
 
@@ -227,6 +228,350 @@ static const struct file_operations rvu_dbg_##name##_fops = { \
 
 static void print_nix_qsize(struct seq_file *filp, struct rvu_pfvf *pfvf);
 
+static int rvu_dbg_mcs_port_stats_display(struct seq_file *filp, void *unused, int dir)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_port_stats stats;
+	int lmac;
+
+	seq_puts(filp, "\n port stats\n");
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(lmac, &mcs->hw->lmac_bmap, mcs->hw->lmac_cnt) {
+		mcs_get_port_stats(mcs, &stats, lmac, dir);
+		seq_printf(filp, "port%d: Tcam Miss: %lld\n", lmac, stats.tcam_miss_cnt);
+		seq_printf(filp, "port%d: Parser errors: %lld\n", lmac, stats.parser_err_cnt);
+
+		if (dir == MCS_RX && mcs->hw->mcs_blks > 1)
+			seq_printf(filp, "port%d: Preempt error: %lld\n", lmac,
+				   stats.preempt_err_cnt);
+		if (dir == MCS_TX)
+			seq_printf(filp, "port%d: Sectag insert error: %lld\n", lmac,
+				   stats.sectag_insert_err_cnt);
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+static int rvu_dbg_mcs_rx_port_stats_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_mcs_port_stats_display(filp, unused, MCS_RX);
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_rx_port_stats, mcs_rx_port_stats_display, NULL);
+
+static int rvu_dbg_mcs_tx_port_stats_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_mcs_port_stats_display(filp, unused, MCS_TX);
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_tx_port_stats, mcs_tx_port_stats_display, NULL);
+
+static int rvu_dbg_mcs_sa_stats_display(struct seq_file *filp, void *unused, int dir)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_sa_stats stats;
+	struct rsrc_bmap *map;
+	int sa_id;
+
+	if (dir == MCS_TX) {
+		mutex_lock(&mcs->stats_lock);
+		map = &mcs->tx.sa;
+		seq_puts(filp, "\n TX SA stats\n");
+		mcs_get_sa_stats(mcs, &stats, sa_id, MCS_TX);
+		for_each_set_bit(sa_id, map->bmap, mcs->hw->sa_entries) {
+			seq_printf(filp, "sa%d: Pkts encrypted: %lld\n", sa_id,
+				   stats.pkt_encrypt_cnt);
+
+			seq_printf(filp, "sa%d: Pkts protected: %lld\n", sa_id,
+				   stats.pkt_protected_cnt);
+		}
+		mutex_unlock(&mcs->stats_lock);
+		return 0;
+	}
+
+	/* RX stats */
+	map = &mcs->rx.sa;
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(sa_id, map->bmap, mcs->hw->sa_entries) {
+		seq_puts(filp, "\n RX SA stats\n");
+		mcs_get_sa_stats(mcs, &stats, sa_id, MCS_RX);
+		seq_printf(filp, "sa%d: Invalid pkts: %lld\n", sa_id, stats.pkt_invalid_cnt);
+		seq_printf(filp, "sa%d: Pkts no sa error: %lld\n", sa_id, stats.pkt_nosaerror_cnt);
+		seq_printf(filp, "sa%d: Pkts not valid: %lld\n", sa_id, stats.pkt_notvalid_cnt);
+		seq_printf(filp, "sa%d: Pkts ok: %lld\n", sa_id, stats.pkt_ok_cnt);
+		seq_printf(filp, "sa%d: Pkts no sa: %lld\n", sa_id, stats.pkt_nosa_cnt);
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+static int rvu_dbg_mcs_rx_sa_stats_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_mcs_sa_stats_display(filp, unused, MCS_RX);
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_rx_sa_stats, mcs_rx_sa_stats_display, NULL);
+
+static int rvu_dbg_mcs_tx_sa_stats_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_mcs_sa_stats_display(filp, unused, MCS_TX);
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_tx_sa_stats, mcs_tx_sa_stats_display, NULL);
+
+static int rvu_dbg_mcs_tx_sc_stats_display(struct seq_file *filp, void *unused)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_sc_stats stats;
+	struct rsrc_bmap *map;
+	int sc_id;
+
+	map = &mcs->tx.sc;
+	seq_puts(filp, "\n SC stats\n");
+
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(sc_id, map->bmap, mcs->hw->sc_entries) {
+		mcs_get_sc_stats(mcs, &stats, sc_id, MCS_TX);
+		seq_printf(filp, "\n=======sc%d======\n\n", sc_id);
+		seq_printf(filp, "sc%d: Pkts encrypted: %lld\n", sc_id, stats.pkt_encrypt_cnt);
+		seq_printf(filp, "sc%d: Pkts protected: %lld\n", sc_id, stats.pkt_protected_cnt);
+
+		if (mcs->hw->mcs_blks == 1) {
+			seq_printf(filp, "sc%d: Octets encrypted: %lld\n", sc_id,
+				   stats.octet_encrypt_cnt);
+			seq_printf(filp, "sc%d: Octets protected: %lld\n", sc_id,
+				   stats.octet_protected_cnt);
+		}
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_tx_sc_stats, mcs_tx_sc_stats_display, NULL);
+
+static int rvu_dbg_mcs_rx_sc_stats_display(struct seq_file *filp, void *unused)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_sc_stats stats;
+	struct rsrc_bmap *map;
+	int sc_id;
+
+	map = &mcs->rx.sc;
+	seq_puts(filp, "\n SC stats\n");
+
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(sc_id, map->bmap, mcs->hw->sc_entries) {
+		mcs_get_sc_stats(mcs, &stats, sc_id, MCS_RX);
+		seq_printf(filp, "\n=======sc%d======\n\n", sc_id);
+		seq_printf(filp, "sc%d: Cam hits: %lld\n", sc_id, stats.hit_cnt);
+		seq_printf(filp, "sc%d: Invalid pkts: %lld\n", sc_id, stats.pkt_invalid_cnt);
+		seq_printf(filp, "sc%d: Late pkts: %lld\n", sc_id, stats.pkt_late_cnt);
+		seq_printf(filp, "sc%d: Notvalid pkts: %lld\n", sc_id, stats.pkt_notvalid_cnt);
+		seq_printf(filp, "sc%d: Unchecked pkts: %lld\n", sc_id, stats.pkt_unchecked_cnt);
+
+		if (mcs->hw->mcs_blks > 1) {
+			seq_printf(filp, "sc%d: Delay pkts: %lld\n", sc_id, stats.pkt_delay_cnt);
+			seq_printf(filp, "sc%d: Pkts ok: %lld\n", sc_id, stats.pkt_ok_cnt);
+		}
+		if (mcs->hw->mcs_blks == 1) {
+			seq_printf(filp, "sc%d: Octets decrypted: %lld\n", sc_id,
+				   stats.octet_decrypt_cnt);
+			seq_printf(filp, "sc%d: Octets validated: %lld\n", sc_id,
+				   stats.octet_validate_cnt);
+		}
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_rx_sc_stats, mcs_rx_sc_stats_display, NULL);
+
+static int rvu_dbg_mcs_flowid_stats_display(struct seq_file *filp, void *unused, int dir)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_flowid_stats stats;
+	struct rsrc_bmap *map;
+	int flow_id;
+
+	seq_puts(filp, "\n Flowid stats\n");
+
+	if (dir == MCS_RX)
+		map = &mcs->rx.flow_ids;
+	else
+		map = &mcs->tx.flow_ids;
+
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(flow_id, map->bmap, mcs->hw->tcam_entries) {
+		mcs_get_flowid_stats(mcs, &stats, flow_id, dir);
+		seq_printf(filp, "Flowid%d: Hit:%lld\n", flow_id, stats.tcam_hit_cnt);
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+static int rvu_dbg_mcs_tx_flowid_stats_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_mcs_flowid_stats_display(filp, unused, MCS_TX);
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_tx_flowid_stats, mcs_tx_flowid_stats_display, NULL);
+
+static int rvu_dbg_mcs_rx_flowid_stats_display(struct seq_file *filp, void *unused)
+{
+	return rvu_dbg_mcs_flowid_stats_display(filp, unused, MCS_RX);
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_rx_flowid_stats, mcs_rx_flowid_stats_display, NULL);
+
+static int rvu_dbg_mcs_tx_secy_stats_display(struct seq_file *filp, void *unused)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_secy_stats stats;
+	struct rsrc_bmap *map;
+	int secy_id;
+
+	map = &mcs->tx.secy;
+	seq_puts(filp, "\n MCS TX secy stats\n");
+
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(secy_id, map->bmap, mcs->hw->secy_entries) {
+		mcs_get_tx_secy_stats(mcs, &stats, secy_id);
+		seq_printf(filp, "\n=======Secy%d======\n\n", secy_id);
+		seq_printf(filp, "secy%d: Ctrl bcast pkts: %lld\n", secy_id,
+			   stats.ctl_pkt_bcast_cnt);
+		seq_printf(filp, "secy%d: Ctrl Mcast pkts: %lld\n", secy_id,
+			   stats.ctl_pkt_mcast_cnt);
+		seq_printf(filp, "secy%d: Ctrl ucast pkts: %lld\n", secy_id,
+			   stats.ctl_pkt_ucast_cnt);
+		seq_printf(filp, "secy%d: Ctrl octets: %lld\n", secy_id, stats.ctl_octet_cnt);
+		seq_printf(filp, "secy%d: Unctrl bcast cnt: %lld\n", secy_id,
+			   stats.unctl_pkt_bcast_cnt);
+		seq_printf(filp, "secy%d: Unctrl mcast pkts: %lld\n", secy_id,
+			   stats.unctl_pkt_mcast_cnt);
+		seq_printf(filp, "secy%d: Unctrl ucast pkts: %lld\n", secy_id,
+			   stats.unctl_pkt_ucast_cnt);
+		seq_printf(filp, "secy%d: Unctrl octets: %lld\n", secy_id, stats.unctl_octet_cnt);
+		seq_printf(filp, "secy%d: Octet encrypted: %lld\n", secy_id,
+			   stats.octet_encrypted_cnt);
+		seq_printf(filp, "secy%d: octet protected: %lld\n", secy_id,
+			   stats.octet_protected_cnt);
+		seq_printf(filp, "secy%d: Pkts on active sa: %lld\n", secy_id,
+			   stats.pkt_noactivesa_cnt);
+		seq_printf(filp, "secy%d: Pkts too long: %lld\n", secy_id, stats.pkt_toolong_cnt);
+		seq_printf(filp, "secy%d: Pkts untagged: %lld\n", secy_id, stats.pkt_untagged_cnt);
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_tx_secy_stats, mcs_tx_secy_stats_display, NULL);
+
+static int rvu_dbg_mcs_rx_secy_stats_display(struct seq_file *filp, void *unused)
+{
+	struct mcs *mcs = filp->private;
+	struct mcs_secy_stats stats;
+	struct rsrc_bmap *map;
+	int secy_id;
+
+	map = &mcs->rx.secy;
+	seq_puts(filp, "\n MCS secy stats\n");
+
+	mutex_lock(&mcs->stats_lock);
+	for_each_set_bit(secy_id, map->bmap, mcs->hw->secy_entries) {
+		mcs_get_rx_secy_stats(mcs, &stats, secy_id);
+		seq_printf(filp, "\n=======Secy%d======\n\n", secy_id);
+		seq_printf(filp, "secy%d: Ctrl bcast pkts: %lld\n", secy_id,
+			   stats.ctl_pkt_bcast_cnt);
+		seq_printf(filp, "secy%d: Ctrl Mcast pkts: %lld\n", secy_id,
+			   stats.ctl_pkt_mcast_cnt);
+		seq_printf(filp, "secy%d: Ctrl ucast pkts: %lld\n", secy_id,
+			   stats.ctl_pkt_ucast_cnt);
+		seq_printf(filp, "secy%d: Ctrl octets: %lld\n", secy_id, stats.ctl_octet_cnt);
+		seq_printf(filp, "secy%d: Unctrl bcast cnt: %lld\n", secy_id,
+			   stats.unctl_pkt_bcast_cnt);
+		seq_printf(filp, "secy%d: Unctrl mcast pkts: %lld\n", secy_id,
+			   stats.unctl_pkt_mcast_cnt);
+		seq_printf(filp, "secy%d: Unctrl ucast pkts: %lld\n", secy_id,
+			   stats.unctl_pkt_ucast_cnt);
+		seq_printf(filp, "secy%d: Unctrl octets: %lld\n", secy_id, stats.unctl_octet_cnt);
+		seq_printf(filp, "secy%d: Octet decrypted: %lld\n", secy_id,
+			   stats.octet_decrypted_cnt);
+		seq_printf(filp, "secy%d: octet validated: %lld\n", secy_id,
+			   stats.octet_validated_cnt);
+		seq_printf(filp, "secy%d: Pkts on disable port: %lld\n", secy_id,
+			   stats.pkt_port_disabled_cnt);
+		seq_printf(filp, "secy%d: Octets validated: %lld\n", secy_id, stats.pkt_badtag_cnt);
+		seq_printf(filp, "secy%d: Octets validated: %lld\n", secy_id, stats.pkt_nosa_cnt);
+		seq_printf(filp, "secy%d: Pkts with nosaerror: %lld\n", secy_id,
+			   stats.pkt_nosaerror_cnt);
+		seq_printf(filp, "secy%d: Tagged ctrl pkts: %lld\n", secy_id,
+			   stats.pkt_tagged_ctl_cnt);
+		seq_printf(filp, "secy%d: Untaged pkts: %lld\n", secy_id, stats.pkt_untaged_cnt);
+		seq_printf(filp, "secy%d: Ctrl pkts: %lld\n", secy_id, stats.pkt_ctl_cnt);
+		if (mcs->hw->mcs_blks > 1)
+			seq_printf(filp, "secy%d: pkts notag: %lld\n", secy_id,
+				   stats.pkt_notag_cnt);
+	}
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(mcs_rx_secy_stats, mcs_rx_secy_stats_display, NULL);
+
+static void rvu_dbg_mcs_init(struct rvu *rvu)
+{
+	struct mcs *mcs;
+	char dname[10];
+	int i;
+
+	if (!rvu->mcs_blk_cnt)
+		return;
+
+	rvu->rvu_dbg.mcs_root = debugfs_create_dir("mcs", rvu->rvu_dbg.root);
+
+	for (i = 0; i < rvu->mcs_blk_cnt; i++) {
+		mcs = mcs_get_pdata(i);
+
+		sprintf(dname, "mcs%d", i);
+		rvu->rvu_dbg.mcs = debugfs_create_dir(dname,
+						      rvu->rvu_dbg.mcs_root);
+
+		rvu->rvu_dbg.mcs_rx = debugfs_create_dir("rx_stats", rvu->rvu_dbg.mcs);
+
+		debugfs_create_file("flowid", 0600, rvu->rvu_dbg.mcs_rx, mcs,
+				    &rvu_dbg_mcs_rx_flowid_stats_fops);
+
+		debugfs_create_file("secy", 0600, rvu->rvu_dbg.mcs_rx, mcs,
+				    &rvu_dbg_mcs_rx_secy_stats_fops);
+
+		debugfs_create_file("sc", 0600, rvu->rvu_dbg.mcs_rx, mcs,
+				    &rvu_dbg_mcs_rx_sc_stats_fops);
+
+		debugfs_create_file("sa", 0600, rvu->rvu_dbg.mcs_rx, mcs,
+				    &rvu_dbg_mcs_rx_sa_stats_fops);
+
+		debugfs_create_file("port", 0600, rvu->rvu_dbg.mcs_rx, mcs,
+				    &rvu_dbg_mcs_rx_port_stats_fops);
+
+		rvu->rvu_dbg.mcs_tx = debugfs_create_dir("tx_stats", rvu->rvu_dbg.mcs);
+
+		debugfs_create_file("flowid", 0600, rvu->rvu_dbg.mcs_tx, mcs,
+				    &rvu_dbg_mcs_tx_flowid_stats_fops);
+
+		debugfs_create_file("secy", 0600, rvu->rvu_dbg.mcs_tx, mcs,
+				    &rvu_dbg_mcs_tx_secy_stats_fops);
+
+		debugfs_create_file("sc", 0600, rvu->rvu_dbg.mcs_tx, mcs,
+				    &rvu_dbg_mcs_tx_sc_stats_fops);
+
+		debugfs_create_file("sa", 0600, rvu->rvu_dbg.mcs_tx, mcs,
+				    &rvu_dbg_mcs_tx_sa_stats_fops);
+
+		debugfs_create_file("port", 0600, rvu->rvu_dbg.mcs_tx, mcs,
+				    &rvu_dbg_mcs_tx_port_stats_fops);
+	}
+}
+
 #define LMT_MAPTBL_ENTRY_SIZE 16
 /* Dump LMTST map table */
 static ssize_t rvu_dbg_lmtst_map_table_display(struct file *filp,
@@ -3053,6 +3398,7 @@ void rvu_dbg_init(struct rvu *rvu)
 	rvu_dbg_npc_init(rvu);
 	rvu_dbg_cpt_init(rvu, BLKADDR_CPT0);
 	rvu_dbg_cpt_init(rvu, BLKADDR_CPT1);
+	rvu_dbg_mcs_init(rvu);
 }
 
 void rvu_dbg_exit(struct rvu *rvu)
-- 
2.7.4

