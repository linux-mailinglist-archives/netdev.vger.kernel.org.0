Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885715ED3B0
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:59:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbiI1D67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbiI1D6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:58:46 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26D31166CF
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:58:43 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28RIV5H7001893;
        Tue, 27 Sep 2022 20:58:31 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=A01v2mNJc4pw1O7eLDcLvVGHIoQNRH3qr1cTJGuHV5o=;
 b=kGNJBZloKHexCHcDw8OeXzAY8mWs+hleoDb4AdCoedeQkFBQhH1wniW5ud5bkmrff1z7
 6pqIHbHcudBltdDaC9OAzDgGzKL1+MeWmkmaKddC16Cwf46niZ/krI0cWyLPm1yUcg/n
 zHl2d5a2JKdjAdjUjrrKZRKdafxjhU0JL1CEP9jSoUFTv759TPkE974C+zislr9Cy/kl
 Nf09qXMlLa4beoaY6BDPuSBcS1zgmu8H6Unmc4I/osGXLdaP7lgAr93lbKHrWMutT6nB
 bvukUCYfccEsaFNqaRwkOkwad/0mQYIN3ICtwbye48pS4Wnulel1T7BRrURuV7E9s4o7 IQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3jv6guhqc0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 27 Sep 2022 20:58:30 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 27 Sep
 2022 20:58:29 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 27 Sep 2022 20:58:29 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 003903F70E8;
        Tue, 27 Sep 2022 20:58:25 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <naveenm@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Vamsi Attunuru <vattunuru@marvell.com>,
        "Subbaraya Sundeep" <sbhatta@marvell.com>
Subject: [net-next PATCH v2 2/8] octeontx2-af: cn10k: mcs: Add mailboxes for port related operations
Date:   Wed, 28 Sep 2022 09:28:04 +0530
Message-ID: <1664337490-20231-3-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
References: <1664337490-20231-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: mXYzFqAuilP6hdB3pOoE8-n72qpLBDtG
X-Proofpoint-GUID: mXYzFqAuilP6hdB3pOoE8-n72qpLBDtG
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

There are set of configurations to be done at MCS port level like
bringing port out of reset, making port as operational or bypass.
This patch adds all the port related mailbox message handlers
so that AF consumers can use them.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 111 +++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c    |  94 +++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/mcs.h    |  10 ++
 .../net/ethernet/marvell/octeontx2/af/mcs_reg.h    |  36 ++++++
 .../net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c | 129 ++++++++++++++++++++-
 5 files changed, 376 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index e26c3b0..207cd4f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -293,9 +293,21 @@ M(NIX_BANDPROF_ALLOC,	0x801d, nix_bandprof_alloc, nix_bandprof_alloc_req, \
 M(NIX_BANDPROF_FREE,	0x801e, nix_bandprof_free, nix_bandprof_free_req,   \
 				msg_rsp)				    \
 M(NIX_BANDPROF_GET_HWINFO, 0x801f, nix_bandprof_get_hwinfo, msg_req,		\
-				nix_bandprof_get_hwinfo_rsp)
-
-/* Messages initiated by AF (range 0xC00 - 0xDFF) */
+				nix_bandprof_get_hwinfo_rsp)		    \
+/* MCS mbox IDs (range 0xA000 - 0xBFFF) */					\
+M(MCS_SET_ACTIVE_LMAC,	0xa00a,	mcs_set_active_lmac, mcs_set_active_lmac,	\
+				msg_rsp)					\
+M(MCS_GET_HW_INFO,	0xa00b,	mcs_get_hw_info, msg_req, mcs_hw_info)		\
+M(MCS_SET_LMAC_MODE,	0xa013, mcs_set_lmac_mode, mcs_set_lmac_mode, msg_rsp)	\
+M(MCS_PORT_RESET,	0xa018, mcs_port_reset, mcs_port_reset_req, msg_rsp)	\
+M(MCS_PORT_CFG_SET,	0xa019, mcs_port_cfg_set, mcs_port_cfg_set_req, msg_rsp)\
+M(MCS_PORT_CFG_GET,	0xa020, mcs_port_cfg_get, mcs_port_cfg_get_req,		\
+				mcs_port_cfg_get_rsp)				\
+M(MCS_CUSTOM_TAG_CFG_GET, 0xa021, mcs_custom_tag_cfg_get,			\
+				  mcs_custom_tag_cfg_get_req,			\
+				  mcs_custom_tag_cfg_get_rsp)
+
+/* Messages initiated by AF (range 0xC00 - 0xEFF) */
 #define MBOX_UP_CGX_MESSAGES						\
 M(CGX_LINK_EVENT,	0xC00, cgx_link_event, cgx_link_info_msg, msg_rsp)
 
@@ -1657,4 +1669,97 @@ enum cgx_af_status {
 	LMAC_AF_ERR_EXACT_MATCH_TBL_LOOK_UP_FAILED = -1110,
 };
 
+enum mcs_direction {
+	MCS_RX,
+	MCS_TX,
+};
+
+struct mcs_hw_info {
+	struct mbox_msghdr hdr;
+	u8 num_mcs_blks;	/* Number of MCS blocks */
+	u8 tcam_entries;	/* RX/TX Tcam entries per mcs block */
+	u8 secy_entries;	/* RX/TX SECY entries per mcs block */
+	u8 sc_entries;		/* RX/TX SC CAM entries per mcs block */
+	u8 sa_entries;		/* PN table entries = SA entries */
+	u64 rsvd[16];
+};
+
+struct mcs_set_active_lmac {
+	struct mbox_msghdr hdr;
+	u32 lmac_bmap;	/* bitmap of active lmac per mcs block */
+	u8 mcs_id;
+	u16 chan_base; /* MCS channel base */
+	u64 rsvd;
+};
+
+struct mcs_set_lmac_mode {
+	struct mbox_msghdr hdr;
+	u8 mode;	/* 1:Bypass 0:Operational */
+	u8 lmac_id;
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_port_reset_req {
+	struct mbox_msghdr hdr;
+	u8 reset;
+	u8 mcs_id;
+	u8 port_id;
+	u64 rsvd;
+};
+
+struct mcs_port_cfg_set_req {
+	struct mbox_msghdr hdr;
+	u8 cstm_tag_rel_mode_sel;
+	u8 custom_hdr_enb;
+	u8 fifo_skid;
+	u8 port_mode;
+	u8 port_id;
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_port_cfg_get_req {
+	struct mbox_msghdr hdr;
+	u8 port_id;
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_port_cfg_get_rsp {
+	struct mbox_msghdr hdr;
+	u8 cstm_tag_rel_mode_sel;
+	u8 custom_hdr_enb;
+	u8 fifo_skid;
+	u8 port_mode;
+	u8 port_id;
+	u8 mcs_id;
+	u64 rsvd;
+};
+
+struct mcs_custom_tag_cfg_get_req {
+	struct mbox_msghdr hdr;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+struct mcs_custom_tag_cfg_get_rsp {
+	struct mbox_msghdr hdr;
+	u16 cstm_etype[8];
+	u8 cstm_indx[8];
+	u8 cstm_etype_en;
+	u8 mcs_id;
+	u8 dir;
+	u64 rsvd;
+};
+
+/* MCS mailbox error codes
+ * Range 1201 - 1300.
+ */
+enum mcs_af_status {
+	MCS_AF_ERR_INVALID_MCSID        = -1201,
+	MCS_AF_ERR_NOT_MAPPED           = -1202,
+};
+
 #endif /* MBOX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index a4e919c..89a3c54 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -107,6 +107,100 @@ struct mcs *mcs_get_pdata(int mcs_id)
 	return NULL;
 }
 
+void mcs_set_port_cfg(struct mcs *mcs, struct mcs_port_cfg_set_req *req)
+{
+	u64 val = 0;
+
+	mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_PORT_CFGX(req->port_id),
+		      req->port_mode & MCS_PORT_MODE_MASK);
+
+	req->cstm_tag_rel_mode_sel &= 0x3;
+
+	if (mcs->hw->mcs_blks > 1) {
+		req->fifo_skid &= MCS_PORT_FIFO_SKID_MASK;
+		val = (u32)req->fifo_skid << 0x10;
+		val |= req->fifo_skid;
+		mcs_reg_write(mcs, MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(req->port_id), val);
+		mcs_reg_write(mcs, MCSX_PEX_TX_SLAVE_CUSTOM_TAG_REL_MODE_SEL(req->port_id),
+			      req->cstm_tag_rel_mode_sel);
+		val = mcs_reg_read(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION);
+
+		if (req->custom_hdr_enb)
+			val |= BIT_ULL(req->port_id);
+		else
+			val &= ~BIT_ULL(req->port_id);
+
+		mcs_reg_write(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION, val);
+	} else {
+		val = mcs_reg_read(mcs, MCSX_PEX_TX_SLAVE_PORT_CONFIG(req->port_id));
+		val |= (req->cstm_tag_rel_mode_sel << 2);
+		mcs_reg_write(mcs, MCSX_PEX_TX_SLAVE_PORT_CONFIG(req->port_id), val);
+	}
+}
+
+void mcs_get_port_cfg(struct mcs *mcs, struct mcs_port_cfg_get_req *req,
+		      struct mcs_port_cfg_get_rsp *rsp)
+{
+	u64 reg = 0;
+
+	rsp->port_mode = mcs_reg_read(mcs, MCSX_PAB_RX_SLAVE_PORT_CFGX(req->port_id)) &
+			 MCS_PORT_MODE_MASK;
+
+	if (mcs->hw->mcs_blks > 1) {
+		reg = MCSX_PAB_RX_SLAVE_FIFO_SKID_CFGX(req->port_id);
+		rsp->fifo_skid = mcs_reg_read(mcs, reg) & MCS_PORT_FIFO_SKID_MASK;
+		reg = MCSX_PEX_TX_SLAVE_CUSTOM_TAG_REL_MODE_SEL(req->port_id);
+		rsp->cstm_tag_rel_mode_sel = mcs_reg_read(mcs, reg) & 0x3;
+		if (mcs_reg_read(mcs, MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION) & BIT_ULL(req->port_id))
+			rsp->custom_hdr_enb = 1;
+	} else {
+		reg = MCSX_PEX_TX_SLAVE_PORT_CONFIG(req->port_id);
+		rsp->cstm_tag_rel_mode_sel = mcs_reg_read(mcs, reg) >> 2;
+	}
+
+	rsp->port_id = req->port_id;
+	rsp->mcs_id = req->mcs_id;
+}
+
+void mcs_get_custom_tag_cfg(struct mcs *mcs, struct mcs_custom_tag_cfg_get_req *req,
+			    struct mcs_custom_tag_cfg_get_rsp *rsp)
+{
+	u64 reg = 0, val = 0;
+	u8 idx;
+
+	for (idx = 0; idx < MCS_MAX_CUSTOM_TAGS; idx++) {
+		if (mcs->hw->mcs_blks > 1)
+			reg  = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_CUSTOM_TAGX(idx) :
+				MCSX_PEX_TX_SLAVE_CUSTOM_TAGX(idx);
+		else
+			reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_VLAN_CFGX(idx) :
+				MCSX_PEX_TX_SLAVE_VLAN_CFGX(idx);
+
+		val = mcs_reg_read(mcs, reg);
+		if (mcs->hw->mcs_blks > 1) {
+			rsp->cstm_etype[idx] = val & GENMASK(15, 0);
+			rsp->cstm_indx[idx] = (val >> 0x16) & 0x3;
+			reg = (req->dir == MCS_RX) ? MCSX_PEX_RX_SLAVE_ETYPE_ENABLE :
+				MCSX_PEX_TX_SLAVE_ETYPE_ENABLE;
+			rsp->cstm_etype_en = mcs_reg_read(mcs, reg) & 0xFF;
+		} else {
+			rsp->cstm_etype[idx] = (val >> 0x1) & GENMASK(15, 0);
+			rsp->cstm_indx[idx] = (val >> 0x11) & 0x3;
+			rsp->cstm_etype_en |= (val & 0x1) << idx;
+		}
+	}
+
+	rsp->mcs_id = req->mcs_id;
+	rsp->dir = req->dir;
+}
+
+void mcs_reset_port(struct mcs *mcs, u8 port_id, u8 reset)
+{
+	u64 reg = MCSX_MCS_TOP_SLAVE_PORT_RESET(port_id);
+
+	mcs_reg_write(mcs, reg, reset & 0x1);
+}
+
 /* Set lmac to bypass/operational mode */
 void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode)
 {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
index 002fee8..c11d507 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.h
@@ -17,6 +17,10 @@
 
 #define MCS_ID_MASK			0x7
 
+#define MCS_PORT_MODE_MASK		0x3
+#define MCS_PORT_FIFO_SKID_MASK		0x3F
+#define MCS_MAX_CUSTOM_TAGS		0x8
+
 /* Reserved resources for default bypass entry */
 #define MCS_RSRC_RSVD_CNT		1
 
@@ -79,6 +83,12 @@ int mcs_set_lmac_channels(int mcs_id, u16 base);
 
 int mcs_install_flowid_bypass_entry(struct mcs *mcs);
 void mcs_set_lmac_mode(struct mcs *mcs, int lmac_id, u8 mode);
+void mcs_reset_port(struct mcs *mcs, u8 port_id, u8 reset);
+void mcs_set_port_cfg(struct mcs *mcs, struct mcs_port_cfg_set_req *req);
+void mcs_get_port_cfg(struct mcs *mcs, struct mcs_port_cfg_get_req *req,
+		      struct mcs_port_cfg_get_rsp *rsp);
+void mcs_get_custom_tag_cfg(struct mcs *mcs, struct mcs_custom_tag_cfg_get_req *req,
+			    struct mcs_custom_tag_cfg_get_rsp *rsp);
 
 /* CN10K-B APIs */
 void cn10kb_mcs_set_hw_capabilities(struct mcs *mcs);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
index 61bf8ab..1ce3442 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_reg.h
@@ -11,6 +11,15 @@
 
 /* Registers */
 #define MCSX_IP_MODE					0x900c8ull
+#define MCSX_MCS_TOP_SLAVE_PORT_RESET(a) ({	\
+	u64 offset;					\
+							\
+	offset = 0x408ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa28ull;			\
+	offset += (a) * 0x8ull;				\
+	offset; })
+
 
 #define MCSX_MCS_TOP_SLAVE_CHANNEL_CFG(a) ({		\
 	u64 offset;					\
@@ -29,6 +38,23 @@
 		offset = 0x60000ull;			\
 	offset; })
 
+#define MCSX_MIL_RX_LMACX_CFG(a) ({			\
+	u64 offset;					\
+							\
+	offset = 0x900a8ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x700a8ull;			\
+	offset += (a) * 0x800ull;			\
+	offset; })
+
+#define MCSX_HIL_GLOBAL ({				\
+	u64 offset;					\
+							\
+	offset = 0xc0000ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0xa0000ull;			\
+	offset; })
+
 #define MCSX_LINK_LMACX_CFG(a) ({			\
 	u64 offset;					\
 							\
@@ -61,6 +87,16 @@
 /* PEX registers */
 #define MCSX_PEX_RX_SLAVE_VLAN_CFGX(a)          (0x3b58ull + (a) * 0x8ull)
 #define MCSX_PEX_TX_SLAVE_VLAN_CFGX(a)          (0x46f8ull + (a) * 0x8ull)
+#define MCSX_PEX_TX_SLAVE_CUSTOM_TAG_REL_MODE_SEL(a)	(0x788ull + (a) * 0x8ull)
+#define MCSX_PEX_TX_SLAVE_PORT_CONFIG(a)		(0x4738ull + (a) * 0x8ull)
+
+#define MCSX_PEX_RX_SLAVE_PEX_CONFIGURATION ({		\
+	u64 offset;					\
+							\
+	offset = 0x3b50ull;				\
+	if (mcs->hw->mcs_blks > 1)			\
+		offset = 0x4c0ull;			\
+	offset; })
 
 /* CNF10K-B */
 #define MCSX_PEX_RX_SLAVE_CUSTOM_TAGX(a)        (0x4c8ull + (a) * 0x8ull)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
index c3f5b39..9eaa8ee 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs_rvu_if.c
@@ -13,6 +13,126 @@
 #include "rvu.h"
 #include "lmac_common.h"
 
+int rvu_mbox_handler_mcs_set_lmac_mode(struct rvu *rvu,
+				       struct mcs_set_lmac_mode *req,
+				       struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (BIT_ULL(req->lmac_id) & mcs->hw->lmac_bmap)
+		mcs_set_lmac_mode(mcs, req->lmac_id, req->mode);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_get_hw_info(struct rvu *rvu,
+				     struct msg_req *req,
+				     struct mcs_hw_info *rsp)
+{
+	struct mcs *mcs;
+
+	if (!rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_NOT_MAPPED;
+
+	/* MCS resources are same across all blocks */
+	mcs = mcs_get_pdata(0);
+	rsp->num_mcs_blks = rvu->mcs_blk_cnt;
+	rsp->tcam_entries = mcs->hw->tcam_entries;
+	rsp->secy_entries = mcs->hw->secy_entries;
+	rsp->sc_entries = mcs->hw->sc_entries;
+	rsp->sa_entries = mcs->hw->sa_entries;
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_port_reset(struct rvu *rvu, struct mcs_port_reset_req *req,
+				    struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	mcs_reset_port(mcs, req->port_id, req->reset);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_set_active_lmac(struct rvu *rvu,
+					 struct mcs_set_active_lmac *req,
+					 struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+	if (!mcs)
+		return MCS_AF_ERR_NOT_MAPPED;
+
+	mcs->hw->lmac_bmap = req->lmac_bmap;
+	mcs_set_lmac_channels(req->mcs_id, req->chan_base);
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_port_cfg_set(struct rvu *rvu, struct mcs_port_cfg_set_req *req,
+				      struct msg_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (mcs->hw->lmac_cnt <= req->port_id || !(mcs->hw->lmac_bmap & BIT_ULL(req->port_id)))
+		return -EINVAL;
+
+	mcs_set_port_cfg(mcs, req);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_port_cfg_get(struct rvu *rvu, struct mcs_port_cfg_get_req *req,
+				      struct mcs_port_cfg_get_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	if (mcs->hw->lmac_cnt <= req->port_id || !(mcs->hw->lmac_bmap & BIT_ULL(req->port_id)))
+		return -EINVAL;
+
+	mcs_get_port_cfg(mcs, req, rsp);
+
+	return 0;
+}
+
+int rvu_mbox_handler_mcs_custom_tag_cfg_get(struct rvu *rvu, struct mcs_custom_tag_cfg_get_req *req,
+					    struct mcs_custom_tag_cfg_get_rsp *rsp)
+{
+	struct mcs *mcs;
+
+	if (req->mcs_id >= rvu->mcs_blk_cnt)
+		return MCS_AF_ERR_INVALID_MCSID;
+
+	mcs = mcs_get_pdata(req->mcs_id);
+
+	mcs_get_custom_tag_cfg(mcs, req, rsp);
+
+	return 0;
+}
+
 static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 {
 	struct mcs *mcs = mcs_get_pdata(0);
@@ -32,7 +152,8 @@ static void rvu_mcs_set_lmac_bmap(struct rvu *rvu)
 int rvu_mcs_init(struct rvu *rvu)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
-	int err = 0;
+	int lmac, err = 0, mcs_id;
+	struct mcs *mcs;
 
 	rvu->mcs_blk_cnt = mcs_get_blkcnt();
 
@@ -48,5 +169,11 @@ int rvu_mcs_init(struct rvu *rvu)
 		rvu_mcs_set_lmac_bmap(rvu);
 	}
 
+	for (mcs_id = 0; mcs_id < rvu->mcs_blk_cnt; mcs_id++) {
+		mcs = mcs_get_pdata(mcs_id);
+		for (lmac = 0; lmac < mcs->hw->lmac_cnt; lmac++)
+			mcs_set_lmac_mode(mcs, lmac, 0);
+	}
+
 	return err;
 }
-- 
2.7.4

