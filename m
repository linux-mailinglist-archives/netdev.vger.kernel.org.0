Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 097C45F19EB
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 07:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiJAFAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Oct 2022 01:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbiJAFAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Oct 2022 01:00:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF4F75FEE
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 22:00:36 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2913xP6n012130;
        Fri, 30 Sep 2022 22:00:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6Age43u4LiQkDj8tSEzfvnRghrFII1DE2rtiv/bJTDo=;
 b=f/RyU555EY3VXDi4eSEgmgMQmpu+BwX7CyEozxRG0kyxbuIsFkZ3ucc417ORNyWawzg1
 EnT8crv4esIS7UHwtwoMVWN9SWf15q+HlCL554bSNlxHVUYcm6TWlpTT2AV2K5NCTkqL
 NwlZnOVSm6yENWsTILwUgGBDIkS/4Wj9NWRHDsBo6GqPimZhyVhG7KDBc/qZ/uQrWLP3
 qQX5FwkJWcv78HhlgRdtSnrNgkyPRYHy8qa66VfIa+aKlVsrAT3COB4bvNadEHMnrZnO
 LjHwWOo65j/UdwQx7Has0cmsWQTRtb/P9JbzZNG5G9VHIlUp4klzjIEZg5NxPuzS30xd pg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3jw1rt9fke-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Sep 2022 22:00:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 30 Sep
 2022 22:00:24 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 30 Sep 2022 22:00:24 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 059E33F70AD;
        Fri, 30 Sep 2022 22:00:21 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Ankur Dwivedi <adwivedi@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH v3 5/8] octeontx2-af: cn10k: mcs: Support for stats collection
Date:   Sat, 1 Oct 2022 10:29:46 +0530
Message-ID: <1664600389-5758-6-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
References: <1664600389-5758-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: OoVkr0AK2sEJlNcXVYRssAmaitize6kn
X-Proofpoint-ORIG-GUID: OoVkr0AK2sEJlNcXVYRssAmaitize6kn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-10-01_03,2022-09-29_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Add mailbox messages to return the resource stats to the
caller. Stats of SecY, SC and SAs as per the macsec standard,
TCAM flow id hits/miss, mailbox to clear the stats are
implemented.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Ankur Dwivedi <adwivedi@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 111 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    | 310 +++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  13 +
 .../ethernet/marvell/octeontx2/af/mcs_cnf10kb.c    |  26 ++
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    | 435 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 153 ++++++++
 6 files changed, 1048 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 3213b1512..e01a705 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -317,6 +317,15 @@ M(MCS_PN_TABLE_WRITE,	0xa009, mcs_pn_table_write, mcs_pn_table_write_req,	\
 M(MCS_SET_ACTIVE_LMAC,	0xa00a,	mcs_set_active_lmac, mcs_set_active_lmac,	\
 				msg_rsp)					\
 M(MCS_GET_HW_INFO,	0xa00b,	mcs_get_hw_info, msg_req, mcs_hw_info)		\
+M(MCS_GET_FLOWID_STATS, 0xa00c, mcs_get_flowid_stats, mcs_stats_req,		\
+				mcs_flowid_stats)				\
+M(MCS_GET_SECY_STATS,	0xa00d, mcs_get_secy_stats, mcs_stats_req,		\
+				mcs_secy_stats)					\
+M(MCS_GET_SC_STATS,	0xa00e, mcs_get_sc_stats, mcs_stats_req, mcs_sc_stats)	\
+M(MCS_GET_SA_STATS,	0xa00f, mcs_get_sa_stats, mcs_stats_req, mcs_sa_stats)	\
+M(MCS_GET_PORT_STATS,	0xa010, mcs_get_port_stats, mcs_stats_req,		\
+				mcs_port_stats)					\
+M(MCS_CLEAR_STATS,	0xa011,	mcs_clear_stats, mcs_clear_stats, msg_rsp)	\
 M(MCS_SET_LMAC_MODE,	0xa013, mcs_set_lmac_mode, mcs_set_lmac_mode, msg_rsp)	\
 M(MCS_SET_PN_THRESHOLD, 0xa014, mcs_set_pn_threshold, mcs_set_pn_threshold,	\
 				msg_rsp)					\
@@ -1973,4 +1982,106 @@ struct mcs_ctrl_pkt_rule_write_req {
 	u64 rsvd;
 };
 
+struct mcs_stats_req {
+	struct mbox_msghdr hdr;
+	u8 id;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+struct mcs_flowid_stats {
+	struct mbox_msghdr hdr;
+	u64 tcam_hit_cnt;
+	u64 rsvd;
+};
+
+struct mcs_secy_stats {
+	struct mbox_msghdr hdr;
+	u64 ctl_pkt_bcast_cnt;
+	u64 ctl_pkt_mcast_cnt;
+	u64 ctl_pkt_ucast_cnt;
+	u64 ctl_octet_cnt;
+	u64 unctl_pkt_bcast_cnt;
+	u64 unctl_pkt_mcast_cnt;
+	u64 unctl_pkt_ucast_cnt;
+	u64 unctl_octet_cnt;
+	/* Valid only for RX */
+	u64 octet_decrypted_cnt;
+	u64 octet_validated_cnt;
+	u64 pkt_port_disabled_cnt;
+	u64 pkt_badtag_cnt;
+	u64 pkt_nosa_cnt;
+	u64 pkt_nosaerror_cnt;
+	u64 pkt_tagged_ctl_cnt;
+	u64 pkt_untaged_cnt;
+	u64 pkt_ctl_cnt;	/* CN10K-B */
+	u64 pkt_notag_cnt;	/* CNF10K-B */
+	/* Valid only for TX */
+	u64 octet_encrypted_cnt;
+	u64 octet_protected_cnt;
+	u64 pkt_noactivesa_cnt;
+	u64 pkt_toolong_cnt;
+	u64 pkt_untagged_cnt;
+	u64 rsvd[4];
+};
+
+struct mcs_port_stats {
+	struct mbox_msghdr hdr;
+	u64 tcam_miss_cnt;
+	u64 parser_err_cnt;
+	u64 preempt_err_cnt;  /* CNF10K-B */
+	u64 sectag_insert_err_cnt;
+	u64 rsvd[4];
+};
+
+/* Only for CN10K-B */
+struct mcs_sa_stats {
+	struct mbox_msghdr hdr;
+	/* RX */
+	u64 pkt_invalid_cnt;
+	u64 pkt_nosaerror_cnt;
+	u64 pkt_notvalid_cnt;
+	u64 pkt_ok_cnt;
+	u64 pkt_nosa_cnt;
+	/* TX */
+	u64 pkt_encrypt_cnt;
+	u64 pkt_protected_cnt;
+	u64 rsvd[4];
+};
+
+struct mcs_sc_stats {
+	struct mbox_msghdr hdr;
+	/* RX */
+	u64 hit_cnt;
+	u64 pkt_invalid_cnt;
+	u64 pkt_late_cnt;
+	u64 pkt_notvalid_cnt;
+	u64 pkt_unchecked_cnt;
+	u64 pkt_delay_cnt;	/* CNF10K-B */
+	u64 pkt_ok_cnt;		/* CNF10K-B */
+	u64 octet_decrypt_cnt;	/* CN10K-B */
+	u64 octet_validate_cnt;	/* CN10K-B */
+	/* TX */
+	u64 pkt_encrypt_cnt;
+	u64 pkt_protected_cnt;
+	u64 octet_encrypt_cnt;		/* CN10K-B */
+	u64 octet_protected_cnt;	/* CN10K-B */
+	u64 rsvd[4];
+};
+
+struct mcs_clear_stats {
+	struct mbox_msghdr hdr;
+#define MCS_FLOWID_STATS	0
+#define MCS_SECY_STATS		1
+#define MCS_SC_STATS		2
+#define MCS_SA_STATS		3
+#define MCS_PORT_STATS		4
+	u8 type;	/* FLOWID, SECY, SC, SA, PORT */
+	u8 id;		/* type = PORT, If id = FF(invalid) port no is derived from pcifunc */
+	u8 mcs_id;
+	u8 dir;
+	u8 all;		/* All resources stats mapped to PF are cleared */
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index 5c8a5bc..002ccb0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -24,6 +24,311 @@ static const struct pci_device_id mcs_id_table[] = {
 
 static LIST_HEAD(mcs_list);
 
+void mcs_get_tx_secy_stats(struct mcs *mcs, struct mcs_secy_stats *stats, int id)
+{
+	u64 reg;
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLBCPKTSX(id);
+	stats->ctl_pkt_bcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLMCPKTSX(id);
+	stats->ctl_pkt_mcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLOCTETSX(id);
+	stats->ctl_octet_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLUCPKTSX(id);
+	stats->ctl_pkt_ucast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLBCPKTSX(id);
+	stats->unctl_pkt_bcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLMCPKTSX(id);
+	stats->unctl_pkt_mcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLOCTETSX(id);
+	stats->unctl_octet_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLUCPKTSX(id);
+	stats->unctl_pkt_ucast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSECYENCRYPTEDX(id);
+	stats->octet_encrypted_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSECYPROTECTEDX(id);
+	stats->octet_protected_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECYNOACTIVESAX(id);
+	stats->pkt_noactivesa_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECYTOOLONGX(id);
+	stats->pkt_toolong_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECYUNTAGGEDX(id);
+	stats->pkt_untagged_cnt =  mcs_reg_read(mcs, reg);
+}
+
+void mcs_get_rx_secy_stats(struct mcs *mcs, struct mcs_secy_stats *stats, int id)
+{
+	u64 reg;
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINCTLBCPKTSX(id);
+	stats->ctl_pkt_bcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINCTLMCPKTSX(id);
+	stats->ctl_pkt_mcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINCTLOCTETSX(id);
+	stats->ctl_octet_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINCTLUCPKTSX(id);
+	stats->ctl_pkt_ucast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLBCPKTSX(id);
+	stats->unctl_pkt_bcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLMCPKTSX(id);
+	stats->unctl_pkt_mcast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLOCTETSX(id);
+	stats->unctl_octet_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLUCPKTSX(id);
+	stats->unctl_pkt_ucast_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INOCTETSSECYDECRYPTEDX(id);
+	stats->octet_decrypted_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INOCTETSSECYVALIDATEX(id);
+	stats->octet_validated_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSCTRLPORTDISABLEDX(id);
+	stats->pkt_port_disabled_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYBADTAGX(id);
+	stats->pkt_badtag_cnt =  mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOSAX(id);
+	stats->pkt_nosa_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOSAERRORX(id);
+	stats->pkt_nosaerror_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYTAGGEDCTLX(id);
+	stats->pkt_tagged_ctl_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYUNTAGGEDORNOTAGX(id);
+	stats->pkt_untaged_cnt = mcs_reg_read(mcs, reg);
+
+	reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYCTLX(id);
+	stats->pkt_ctl_cnt = mcs_reg_read(mcs, reg);
+
+	if (mcs->hw->mcs_blks > 1) {
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOTAGX(id);
+		stats->pkt_notag_cnt = mcs_reg_read(mcs, reg);
+	}
+}
+
+void mcs_get_flowid_stats(struct mcs *mcs, struct mcs_flowid_stats *stats,
+			  int id, int dir)
+{
+	u64 reg;
+
+	if (dir == MCS_RX)
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSFLOWIDTCAMHITX(id);
+	else
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSFLOWIDTCAMHITX(id);
+
+	stats->tcam_hit_cnt = mcs_reg_read(mcs, reg);
+}
+
+void mcs_get_port_stats(struct mcs *mcs, struct mcs_port_stats *stats,
+			int id, int dir)
+{
+	u64 reg;
+
+	if (dir == MCS_RX) {
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSFLOWIDTCAMMISSX(id);
+		stats->tcam_miss_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSPARSEERRX(id);
+		stats->parser_err_cnt = mcs_reg_read(mcs, reg);
+		if (mcs->hw->mcs_blks > 1) {
+			reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSEARLYPREEMPTERRX(id);
+			stats->preempt_err_cnt = mcs_reg_read(mcs, reg);
+		}
+	} else {
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSFLOWIDTCAMMISSX(id);
+		stats->tcam_miss_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSPARSEERRX(id);
+		stats->parser_err_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECTAGINSERTIONERRX(id);
+		stats->sectag_insert_err_cnt = mcs_reg_read(mcs, reg);
+	}
+}
+
+void mcs_get_sa_stats(struct mcs *mcs, struct mcs_sa_stats *stats, int id, int dir)
+{
+	u64 reg;
+
+	if (dir == MCS_RX) {
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSAINVALIDX(id);
+		stats->pkt_invalid_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSANOTUSINGSAERRORX(id);
+		stats->pkt_nosaerror_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSANOTVALIDX(id);
+		stats->pkt_notvalid_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSAOKX(id);
+		stats->pkt_ok_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSAUNUSEDSAX(id);
+		stats->pkt_nosa_cnt = mcs_reg_read(mcs, reg);
+	} else {
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSAENCRYPTEDX(id);
+		stats->pkt_encrypt_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSAPROTECTEDX(id);
+		stats->pkt_protected_cnt = mcs_reg_read(mcs, reg);
+	}
+}
+
+void mcs_get_sc_stats(struct mcs *mcs, struct mcs_sc_stats *stats,
+		      int id, int dir)
+{
+	u64 reg;
+
+	if (dir == MCS_RX) {
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCCAMHITX(id);
+		stats->hit_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCINVALIDX(id);
+		stats->pkt_invalid_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCLATEORDELAYEDX(id);
+		stats->pkt_late_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCNOTVALIDX(id);
+		stats->pkt_notvalid_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCUNCHECKEDOROKX(id);
+		stats->pkt_unchecked_cnt = mcs_reg_read(mcs, reg);
+
+		if (mcs->hw->mcs_blks > 1) {
+			reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCDELAYEDX(id);
+			stats->pkt_delay_cnt = mcs_reg_read(mcs, reg);
+
+			reg = MCSX_CSE_RX_MEM_SLAVE_INPKTSSCOKX(id);
+			stats->pkt_ok_cnt = mcs_reg_read(mcs, reg);
+		}
+		if (mcs->hw->mcs_blks == 1) {
+			reg = MCSX_CSE_RX_MEM_SLAVE_INOCTETSSCDECRYPTEDX(id);
+			stats->octet_decrypt_cnt = mcs_reg_read(mcs, reg);
+
+			reg = MCSX_CSE_RX_MEM_SLAVE_INOCTETSSCVALIDATEX(id);
+			stats->octet_validate_cnt = mcs_reg_read(mcs, reg);
+		}
+	} else {
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSCENCRYPTEDX(id);
+		stats->pkt_encrypt_cnt = mcs_reg_read(mcs, reg);
+
+		reg = MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSCPROTECTEDX(id);
+		stats->pkt_protected_cnt = mcs_reg_read(mcs, reg);
+
+		if (mcs->hw->mcs_blks == 1) {
+			reg = MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSCENCRYPTEDX(id);
+			stats->octet_encrypt_cnt = mcs_reg_read(mcs, reg);
+
+			reg = MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSCPROTECTEDX(id);
+			stats->octet_protected_cnt = mcs_reg_read(mcs, reg);
+		}
+	}
+}
+
+void mcs_clear_stats(struct mcs *mcs, u8 type, u8 id, int dir)
+{
+	struct mcs_flowid_stats flowid_st;
+	struct mcs_port_stats port_st;
+	struct mcs_secy_stats secy_st;
+	struct mcs_sc_stats sc_st;
+	struct mcs_sa_stats sa_st;
+	u64 reg;
+
+	if (dir == MCS_RX)
+		reg = MCSX_CSE_RX_SLAVE_CTRL;
+	else
+		reg = MCSX_CSE_TX_SLAVE_CTRL;
+
+	mcs_reg_write(mcs, reg, BIT_ULL(0));
+
+	switch (type) {
+	case MCS_FLOWID_STATS:
+		mcs_get_flowid_stats(mcs, &flowid_st, id, dir);
+		break;
+	case MCS_SECY_STATS:
+		if (dir == MCS_RX)
+			mcs_get_rx_secy_stats(mcs, &secy_st, id);
+		else
+			mcs_get_tx_secy_stats(mcs, &secy_st, id);
+		break;
+	case MCS_SC_STATS:
+		mcs_get_sc_stats(mcs, &sc_st, id, dir);
+		break;
+	case MCS_SA_STATS:
+		mcs_get_sa_stats(mcs, &sa_st, id, dir);
+		break;
+	case MCS_PORT_STATS:
+		mcs_get_port_stats(mcs, &port_st, id, dir);
+		break;
+	}
+
+	mcs_reg_write(mcs, reg, 0x0);
+}
+
+int mcs_clear_all_stats(struct mcs *mcs, u16 pcifunc, int dir)
+{
+	struct mcs_rsrc_map *map;
+	int id;
+
+	if (dir == MCS_RX)
+		map = &mcs->rx;
+	else
+		map = &mcs->tx;
+
+	/* Clear FLOWID stats */
+	for (id = 0; id < map->flow_ids.max; id++) {
+		if (map->flowid2pf_map[id] != pcifunc)
+			continue;
+		mcs_clear_stats(mcs, MCS_FLOWID_STATS, id, dir);
+	}
+
+	/* Clear SECY stats */
+	for (id = 0; id < map->secy.max; id++) {
+		if (map->secy2pf_map[id] != pcifunc)
+			continue;
+		mcs_clear_stats(mcs, MCS_SECY_STATS, id, dir);
+	}
+
+	/* Clear SC stats */
+	for (id = 0; id < map->secy.max; id++) {
+		if (map->sc2pf_map[id] != pcifunc)
+			continue;
+		mcs_clear_stats(mcs, MCS_SC_STATS, id, dir);
+	}
+
+	/* Clear SA stats */
+	for (id = 0; id < map->sa.max; id++) {
+		if (map->sa2pf_map[id] != pcifunc)
+			continue;
+		mcs_clear_stats(mcs, MCS_SA_STATS, id, dir);
+	}
+	return 0;
+}
+
 void mcs_pn_table_write(struct mcs *mcs, u8 pn_id, u64 next_pn, u8 dir)
 {
 	u64 reg;
@@ -816,6 +1121,10 @@ static void mcs_global_cfg(struct mcs *mcs)
 	/* Disable external bypass */
 	mcs_set_external_bypass(mcs, false);
 
+	/* Reset TX/RX stats memory */
+	mcs_reg_write(mcs, MCSX_CSE_RX_SLAVE_STATS_CLEAR, 0x1F);
+	mcs_reg_write(mcs, MCSX_CSE_TX_SLAVE_STATS_CLEAR, 0x1F);
+
 	/* Set MCS to perform standard IEEE802.1AE macsec processing */
 	if (mcs->hw->mcs_blks == 1) {
 		mcs_reg_write(mcs, MCSX_IP_MODE, BIT_ULL(3));
@@ -921,6 +1230,7 @@ static int mcs_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	mcs->mcs_ops->mcs_parser_cfg(mcs);
 
 	list_add(&mcs->mcs_list, &mcs_list);
+	mutex_init(&mcs->stats_lock);
 
 	return 0;
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
index 615a3ad..28600ef 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
@@ -85,6 +85,8 @@ struct mcs {
 	u8			mcs_id;
 	struct mcs_ops		*mcs_ops;
 	struct list_head	mcs_list;
+	/* Lock for mcs stats */
+	struct mutex		stats_lock;
 };
 
 struct mcs_ops {
@@ -156,4 +158,15 @@ void cnf10kb_mcs_flowid_secy_map(struct mcs *mcs, struct secy_mem_map *map, int
 void cnf10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *map);
 void cnf10kb_mcs_parser_cfg(struct mcs *mcs);
 
+/* Stats APIs */
+void mcs_get_sc_stats(struct mcs *mcs, struct mcs_sc_stats *stats, int id, int dir);
+void mcs_get_sa_stats(struct mcs *mcs, struct mcs_sa_stats *stats, int id, int dir);
+void mcs_get_port_stats(struct mcs *mcs, struct mcs_port_stats *stats, int id, int dir);
+void mcs_get_flowid_stats(struct mcs *mcs, struct mcs_flowid_stats *stats, int id, int dir);
+void mcs_get_rx_secy_stats(struct mcs *mcs, struct mcs_secy_stats *stats, int id);
+void mcs_get_tx_secy_stats(struct mcs *mcs, struct mcs_secy_stats *stats, int id);
+void mcs_clear_stats(struct mcs *mcs, u8 type, u8 id, int dir);
+int mcs_clear_all_stats(struct mcs *mcs, u16 pcifunc, int dir);
+int mcs_set_force_clk_en(struct mcs *mcs, bool set);
+
 #endif /* MCS_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
index f375402..5ed5deb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_cnf10kb.c
@@ -118,3 +118,29 @@ void cnf10kb_mcs_rx_sa_mem_map_write(struct mcs *mcs, struct mcs_rx_sc_sa_map *m
 	reg = MCSX_CPM_RX_SLAVE_SA_MAP_MEMX((4 * map->sc_id) + map->an);
 	mcs_reg_write(mcs, reg, val);
 }
+
+int mcs_set_force_clk_en(struct mcs *mcs, bool set)
+{
+	unsigned long timeout = jiffies + usecs_to_jiffies(2000);
+	u64 val;
+
+	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
+
+	if (set) {
+		val |= BIT_ULL(4);
+		mcs_reg_write(mcs, MCSX_MIL_GLOBAL, val);
+
+		/* Poll till mcsx_mil_ip_gbl_status.mcs_ip_stats_ready value is 1 */
+		while (!(mcs_reg_read(mcs, MCSX_MIL_IP_GBL_STATUS) & BIT_ULL(0))) {
+			if (time_after(jiffies, timeout)) {
+				dev_err(mcs->dev, "MCS set force clk enable failed\n");
+				break;
+			}
+		}
+	} else {
+		val &= ~BIT_ULL(4);
+		mcs_reg_write(mcs, MCSX_MIL_GLOBAL, val);
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index e192a68..12be9f9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -72,6 +72,14 @@
 		offset = 0x600c8ull;			\
 	offset; })
 
+#define MCSX_MIL_IP_GBL_STATUS ({			\
+	u64 offset;					\
+							\
+	offset = 0x800d0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x600d0ull;			\
+	offset; })
+
 /* PAB */
 #define MCSX_PAB_RX_SLAVE_PORT_CFGX(a) ({	\
 	u64 offset;				\
@@ -496,4 +504,431 @@
 #define MCSX_CPM_TX_SLAVE_SA_INDEX1_VLDX(a)		(0x5f50 + (a) * 0x8ull)
 #define MCSX_CPM_TX_SLAVE_AUTO_REKEY_ENABLE_0		0x5500ull
 
+/* CSE */
+#define MCSX_CSE_RX_MEM_SLAVE_IFINCTLBCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x9e80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xc218ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_IFINCTLMCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x9680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xc018ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_IFINCTLOCTETSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x6e80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xbc18ull;			\
+	offset +=  (a) * 0x8ull;			\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_IFINCTLUCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x8e80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xbe18ull;			\
+	offset +=  (a) * 0x8ull;			\
+	offset; })
+
+#define	MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLBCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x8680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xca18ull;			\
+	offset +=  (a) * 0x8ull;			\
+	offset; })
+
+#define	MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLMCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x7e80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xc818ull;			\
+	offset +=  (a) * 0x8ull;			\
+	offset; })
+
+#define	MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLOCTETSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x6680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xc418ull;			\
+	offset +=  (a) * 0x8ull;			\
+	offset; })
+
+#define	MCSX_CSE_RX_MEM_SLAVE_IFINUNCTLUCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x7680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xc618ull;			\
+	offset +=  (a) * 0x8ull;			\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INOCTETSSECYDECRYPTEDX(a) ({ \
+	u64 offset;					\
+							\
+	offset = 0x5e80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xdc18ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INOCTETSSECYVALIDATEX(a)({ \
+	u64 offset;					\
+							\
+	offset = 0x5680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xda18ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSCTRLPORTDISABLEDX(a) ({ \
+	u64 offset;					\
+							\
+	offset = 0xd680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xce18ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSFLOWIDTCAMHITX(a) ({ \
+	u64 offset;					\
+							\
+	offset = 0x16a80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xec78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSFLOWIDTCAMMISSX(a) ({ \
+	u64 offset;					\
+							\
+	offset = 0x16680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xec38ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSPARSEERRX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x16880ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xec18ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCCAMHITX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0xfe80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xde18ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCINVALIDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x10680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xe418ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCNOTVALIDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x10e80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xe218ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYBADTAGX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0xae80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xd418ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOSAX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0xc680ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xd618ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOSAERRORX(a) ({ \
+	u64 offset;					\
+							\
+	offset = 0xce80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xd818ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYTAGGEDCTLX(a) ({ \
+	u64 offset;					\
+							\
+	offset = 0xbe80ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xcc18ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_RX_SLAVE_CTRL	({			\
+	u64 offset;					\
+							\
+	offset = 0x52a0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x9c0ull;			\
+	offset; })
+
+#define MCSX_CSE_RX_SLAVE_STATS_CLEAR	({		\
+	u64 offset;					\
+							\
+	offset = 0x52b8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x9d8ull;			\
+	offset; })
+
+#define MCSX_CSE_RX_MEM_SLAVE_INOCTETSSCDECRYPTEDX(a)	(0xe680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INOCTETSSCVALIDATEX(a)	(0xde80ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYUNTAGGEDORNOTAGX(a)	(0xa680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYNOTAGX(a)	(0xd218 + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYUNTAGGEDX(a)	(0xd018ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCUNCHECKEDOROKX(a)	(0xee80ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSECYCTLX(a)		(0xb680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCLATEORDELAYEDX(a) (0xf680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSAINVALIDX(a)	(0x12680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSANOTUSINGSAERRORX(a) (0x15680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSANOTVALIDX(a)	(0x13680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSAOKX(a)		(0x11680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSAUNUSEDSAX(a)	(0x14680ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSEARLYPREEMPTERRX(a) (0xec58ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCOKX(a)		(0xea18ull + (a) * 0x8ull)
+#define MCSX_CSE_RX_MEM_SLAVE_INPKTSSCDELAYEDX(a)	(0xe618ull + (a) * 0x8ull)
+
+/* CSE TX */
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTCOMMONOCTETSX(a)	(0x18440ull + (a) * 0x8ull)
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLBCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1c440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xf478ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLMCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1bc40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xf278ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLOCTETSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x19440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xee78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTCTLUCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1b440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xf078ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLBCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1ac40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xfc78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLMCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1a440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xfa78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLOCTETSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x18c40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xf678ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_IFOUTUNCTLUCPKTSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x19c40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xf878ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSECYENCRYPTEDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x17c40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10878ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSECYPROTECTEDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x17440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10678ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSCTRLPORTDISABLEDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1e440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xfe78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSFLOWIDTCAMHITX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x23240ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10ed8ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSFLOWIDTCAMMISSX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x22c40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10e98ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSPARSEERRX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x22e40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10e78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSCENCRYPTEDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x20440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10c78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSCPROTECTEDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1fc40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10a78ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECTAGINSERTIONERRX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x23040ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x110d8ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECYNOACTIVESAX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1dc40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10278ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECYTOOLONGX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1d440ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10478ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSECYUNTAGGEDX(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x1cc40ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x10078ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
+#define MCSX_CSE_TX_SLAVE_CTRL	({	\
+	u64 offset;					\
+							\
+	offset = 0x54a0ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa00ull;			\
+	offset; })
+
+#define MCSX_CSE_TX_SLAVE_STATS_CLEAR ({		\
+	u64 offset;					\
+							\
+	offset = 0x54b8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa18ull;			\
+	offset; })
+
+#define MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSCENCRYPTEDX(a)	(0x1f440ull + (a) * 0x8ull)
+#define MCSX_CSE_TX_MEM_SLAVE_OUTOCTETSSCPROTECTEDX(a)	(0x1ec40ull + (a) * 0x8ull)
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSEARLYPREEMPTERRX(a) (0x10eb8ull + (a) * 0x8ull)
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSAENCRYPTEDX(a)	(0x21c40ull + (a) * 0x8ull)
+#define MCSX_CSE_TX_MEM_SLAVE_OUTPKTSSAPROTECTEDX(a)	(0x20c40ull + (a) * 0x8ull)
+
 #endif
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index 8a7d455..939c9b6 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -64,6 +64,159 @@ int rvu_mbox_handler_mcs_port_reset(struct rvu *rvu, struct mcs_port_reset_req *
 	return 0;
 }
 
+int rvu_mbox_handler_mcs_clear_stats(struct rvu *rvu,
+				     struct mcs_clear_stats *req,
+				     struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	mutex_lock(&mcs->stats_lock);
+	if (req->all)
+		mcs_clear_all_stats(mcs, pcifunc, req->dir);
+	else
+		mcs_clear_stats(mcs, req->type, req->id, req->dir);
+
+	mutex_unlock(&mcs->stats_lock);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_get_flowid_stats(struct rvu *rvu,
+					  struct mcs_stats_req *req,
+					  struct mcs_flowid_stats *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	/* In CNF10K-B, before reading the statistics,
+	 * MCSX_MIL_GLOBAL.FORCE_CLK_EN_IP needs to be set
+	 * to get accurate statistics
+	 */
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, true);
+
+	mutex_lock(&mcs->stats_lock);
+	mcs_get_flowid_stats(mcs, rsp, req->id, req->dir);
+	mutex_unlock(&mcs->stats_lock);
+
+	/* Clear MCSX_MIL_GLOBAL.FORCE_CLK_EN_IP after reading
+	 * the statistics
+	 */
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, false);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_get_secy_stats(struct rvu *rvu,
+					struct mcs_stats_req *req,
+					struct mcs_secy_stats *rsp)
+{	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, true);
+
+	mutex_lock(&mcs->stats_lock);
+
+	if (req->dir == MCS_RX)
+		mcs_get_rx_secy_stats(mcs, rsp, req->id);
+	else
+		mcs_get_tx_secy_stats(mcs, rsp, req->id);
+
+	mutex_unlock(&mcs->stats_lock);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, false);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_get_sc_stats(struct rvu *rvu,
+				      struct mcs_stats_req *req,
+				      struct mcs_sc_stats *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, true);
+
+	mutex_lock(&mcs->stats_lock);
+	mcs_get_sc_stats(mcs, rsp, req->id, req->dir);
+	mutex_unlock(&mcs->stats_lock);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, false);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_get_sa_stats(struct rvu *rvu,
+				      struct mcs_stats_req *req,
+				      struct mcs_sa_stats *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, true);
+
+	mutex_lock(&mcs->stats_lock);
+	mcs_get_sa_stats(mcs, rsp, req->id, req->dir);
+	mutex_unlock(&mcs->stats_lock);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, false);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_get_port_stats(struct rvu *rvu,
+					struct mcs_stats_req *req,
+					struct mcs_port_stats *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, true);
+
+	mutex_lock(&mcs->stats_lock);
+	mcs_get_port_stats(mcs, rsp, req->id, req->dir);
+	mutex_unlock(&mcs->stats_lock);
+
+	if (mcs->hw->mcs_blks > 1)
+		mcs_set_force_clk_en(mcs, false);
+
+	return 0;
+}
+
 int rvu_mbox_handler_mcs_set_active_lmac(struct rvu *rvu,
 					 struct mcs_set_active_lmac *req,
 					 struct msg_rsp *rsp)
-- 
2.7.4

