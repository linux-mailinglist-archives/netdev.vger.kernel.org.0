Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE3817545A
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbgCBHUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:20:08 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:39590 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgCBHUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:20:08 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so3848120plp.6
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:20:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EPnD6fv58wTeEGDksH+EAPnHmDlhCjkBzmrenjYCO5s=;
        b=C2Qrh3Xxz2+lWmDo1AKRZWnm7QaTqPExlI+x1q1cI/QdFeFXM0ik2af0QNEZfTrThm
         8gUoizqW9NoRNg2dxKIprepgTol31WsXa8DYMW4Q775JJWRgCVQoR5rZvNgE2WJTjRAZ
         plLCjTvGf/esTwRzkDr5ti+ecTQgiGWVPkt+dtWJEkChNBI+EI2G2cFe95O5k5Rmqe/K
         DXzm2iPJ39nBK3pWYCICTfOVASXxkzxTCep3AwN9T/2ROoJRDh9sOJettjN79C0BG3N5
         ZnroRH28Y4KBlTn3dNddTgBbooQWE71J6lSmsQlQQcn0pnUhEnDpTHaO7SjtMJ5lyGtx
         Io7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EPnD6fv58wTeEGDksH+EAPnHmDlhCjkBzmrenjYCO5s=;
        b=LGs9prYdTy4uLRNcj7HyrvPJIt1DeiYePmfxjARdteTRE/WtYDvGzzK8zzj8CfLZSf
         AKBXK79lLVtp0LID9h8dPyw/EmBLsML5UfEOHkxx0l7F2GKWFgNqTugVrxN0uG+t95sh
         1w1NGFWSO8WElUEdqyFsaoFKwoKRMsD210GGeFSVNATDcs3sFpfsgtwvmalRPrvie/5W
         TFk/diTW3fATKAG1AgjkW/8nrVDGNGCYfwcsspEmxxe4WQTJSguH7/98WYSV+2RZnhzg
         7qa5JlQd9XbfQIc9kd+XxCbQPffjbkJIlD2AQ/4gxARNfkZEbknQxNoxXyY5akeLIMvJ
         S9LA==
X-Gm-Message-State: APjAAAXqSevM8oWEK3+pzrQkVmaf4mXQaHPyi39M/yaCZu/ilRxF4VvV
        UFoE7Q5LOPMj4vAFYBVB2tceC9zpAng=
X-Google-Smtp-Source: APXvYqzXP6m4gExq0aMrQJf47ZUBjE2IGetp4/sU7VACFCBMC6dkBU7JSk5B0mvSFGZe8lNHfYGNXA==
X-Received: by 2002:a17:90a:f316:: with SMTP id ca22mr19994945pjb.59.1583133607085;
        Sun, 01 Mar 2020 23:20:07 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.20.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:20:06 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 2/7] octeontx2-af: Pause frame configuration at cgx
Date:   Mon,  2 Mar 2020 12:49:23 +0530
Message-Id: <1583133568-5674-3-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

CGX LMAC, the physical interface can generate pause frames when
internal resources asserts backpressure due to exhaustion.

This patch configures CGX to generate 802.3 pause frames.
Also enabled processing of received pause frames on the line which
will assert backpressure on the internal transmit path.

Also added mailbox handlers for PF drivers to enable or disable
pause frames anytime.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 103 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  14 +++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  11 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  24 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   5 +
 5 files changed, 157 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 9f5b722..fb1971c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -367,6 +367,107 @@ int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 	return !!(last & DATA_PKT_TX_EN);
 }
 
+int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
+			   u8 *tx_pause, u8 *rx_pause)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!cgx || lmac_id >= cgx->lmac_count)
+		return -ENODEV;
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+	*rx_pause = !!(cfg & CGX_SMUX_RX_FRM_CTL_CTL_BCK);
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+	*tx_pause = !!(cfg & CGX_SMUX_TX_CTL_L2P_BP_CONV);
+	return 0;
+}
+
+int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
+			   u8 tx_pause, u8 rx_pause)
+{
+	struct cgx *cgx = cgxd;
+	u64 cfg;
+
+	if (!cgx || lmac_id >= cgx->lmac_count)
+		return -ENODEV;
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+	cfg |= rx_pause ? CGX_SMUX_RX_FRM_CTL_CTL_BCK : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+	cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
+	cfg |= tx_pause ? CGX_SMUX_TX_CTL_L2P_BP_CONV : 0x0;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
+
+	cfg = cgx_read(cgx, 0, CGXX_CMR_RX_OVR_BP);
+	if (tx_pause) {
+		cfg &= ~CGX_CMR_RX_OVR_BP_EN(lmac_id);
+	} else {
+		cfg |= CGX_CMR_RX_OVR_BP_EN(lmac_id);
+		cfg &= ~CGX_CMR_RX_OVR_BP_BP(lmac_id);
+	}
+	cgx_write(cgx, 0, CGXX_CMR_RX_OVR_BP, cfg);
+	return 0;
+}
+
+static void cgx_lmac_pause_frm_config(struct cgx *cgx, int lmac_id, bool enable)
+{
+	u64 cfg;
+
+	if (!cgx || lmac_id >= cgx->lmac_count)
+		return;
+	if (enable) {
+		/* Enable receive pause frames */
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg |= CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg |= CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		/* Enable pause frames transmission */
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+		cfg |= CGX_SMUX_TX_CTL_L2P_BP_CONV;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
+
+		/* Set pause time and interval */
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_TIME,
+			  DEFAULT_PAUSE_TIME);
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL);
+		cfg &= ~0xFFFFULL;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL,
+			  cfg | (DEFAULT_PAUSE_TIME / 2));
+
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_TIME,
+			  DEFAULT_PAUSE_TIME);
+
+		cfg = cgx_read(cgx, lmac_id,
+			       CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL);
+		cfg &= ~0xFFFFULL;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL,
+			  cfg | (DEFAULT_PAUSE_TIME / 2));
+	} else {
+		/* ALL pause frames received are completely ignored */
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+		cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		/* Disable pause frames transmission */
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+		cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
+	}
+}
+
 /* CGX Firmware interface low level support */
 static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
 {
@@ -787,6 +888,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 		/* Add reference */
 		cgx->lmac_idmap[i] = lmac;
+		cgx_lmac_pause_frm_config(cgx, i, true);
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
@@ -805,6 +907,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 
 	/* Free all lmac related resources */
 	for (i = 0; i < cgx->lmac_count; i++) {
+		cgx_lmac_pause_frm_config(cgx, i, false);
 		lmac = cgx->lmac_idmap[i];
 		if (!lmac)
 			continue;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 9343bf3..115f5ec 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -60,10 +60,20 @@
 #define CGX_SMUX_RX_FRM_CTL_CTL_BCK	BIT_ULL(3)
 #define CGXX_GMP_GMI_RXX_FRM_CTL	0x38028
 #define CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK	BIT_ULL(3)
+#define CGXX_SMUX_TX_CTL		0x20178
+#define CGXX_SMUX_TX_PAUSE_PKT_TIME	0x20110
+#define CGXX_SMUX_TX_PAUSE_PKT_INTERVAL	0x20120
+#define CGXX_GMP_GMI_TX_PAUSE_PKT_TIME	0x38230
+#define CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL	0x38248
+#define CGX_SMUX_TX_CTL_L2P_BP_CONV	BIT_ULL(7)
+#define CGXX_CMR_RX_OVR_BP		0x130
+#define CGX_CMR_RX_OVR_BP_EN(X)		BIT_ULL(((X) + 8))
+#define CGX_CMR_RX_OVR_BP_BP(X)		BIT_ULL(((X) + 4))
 
 #define CGX_COMMAND_REG			CGXX_SCRATCH1_REG
 #define CGX_EVENT_REG			CGXX_SCRATCH0_REG
 #define CGX_CMD_TIMEOUT			2200 /* msecs */
+#define DEFAULT_PAUSE_TIME		0x7FF
 
 #define CGX_NVEC			37
 #define CGX_LMAC_FWI			0
@@ -124,5 +134,9 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable);
 int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
 int cgx_lmac_linkup_start(void *cgxd);
+int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
+			   u8 *tx_pause, u8 *rx_pause);
+int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
+			   u8 tx_pause, u8 rx_pause);
 int cgx_get_mkex_prfl_info(u64 *addr, u64 *size);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index a6ae7d9..b2a6bee 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -143,6 +143,8 @@ M(CGX_STOP_LINKEVENTS,	0x208, cgx_stop_linkevents, msg_req, msg_rsp)	\
 M(CGX_GET_LINKINFO,	0x209, cgx_get_linkinfo, msg_req, cgx_link_info_msg) \
 M(CGX_INTLBK_ENABLE,	0x20A, cgx_intlbk_enable, msg_req, msg_rsp)	\
 M(CGX_INTLBK_DISABLE,	0x20B, cgx_intlbk_disable, msg_req, msg_rsp)	\
+M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
+			       cgx_pause_frm_cfg)			\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
 				npa_lf_alloc_req, npa_lf_alloc_rsp)	\
@@ -345,6 +347,15 @@ struct cgx_link_info_msg {
 	struct cgx_link_user_info link_info;
 };
 
+struct cgx_pause_frm_cfg {
+	struct mbox_msghdr hdr;
+	u8 set;
+	/* set = 1 if the request is to config pause frames */
+	/* set = 0 if the request is to fetch pause frames config */
+	u8 rx_pause;
+	u8 tx_pause;
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index b8e8f33..f3c82e4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -590,6 +590,30 @@ int rvu_mbox_handler_cgx_intlbk_disable(struct rvu *rvu, struct msg_req *req,
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
+				       struct cgx_pause_frm_cfg *req,
+				       struct cgx_pause_frm_cfg *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	/* This msg is expected only from PF/VFs that are mapped to CGX LMACs,
+	 * if received from other PF/VF simply ACK, nothing to do.
+	 */
+	if (!is_pf_cgxmapped(rvu, pf))
+		return -ENODEV;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	if (req->set)
+		cgx_lmac_set_pause_frm(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				       req->tx_pause, req->rx_pause);
+	else
+		cgx_lmac_get_pause_frm(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				       &rsp->tx_pause, &rsp->rx_pause);
+	return 0;
+}
+
 /* Finds cumulative status of NIX rx/tx counters from LF of a PF and those
  * from its VFs as well. ie. NIX rx/tx counters at the CGX port level
  */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 8c3ff63..80b1e39 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -213,6 +213,11 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
 		pfvf->tx_chan_cnt = 1;
 		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
 		rvu_npc_set_pkind(rvu, pkind, pfvf);
+
+		/* By default we enable pause frames */
+		if ((pcifunc & RVU_PFVF_FUNC_MASK) == 0)
+			cgx_lmac_set_pause_frm(rvu_cgx_pdata(cgx_id, rvu),
+					       lmac_id, true, true);
 		break;
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
-- 
2.7.4

