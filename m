Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 274251022D6
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfKSLSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:43446 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:05 -0500
Received: by mail-pf1-f195.google.com with SMTP id 3so12005957pfb.10
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=VVTmKBwD5HaJcjDbrGJTEMxMEftyp7ie8061evSzACw=;
        b=uFK5iM0zsa0Gh+Kw13IBZel1ynw3wDyWB0TKrR/eNp3VXvV57pU51JQOUbOJfd5sIB
         5cTE7mlp/IvM4IkS8y3KTXcA4qoJx2PZ6I4UYNRVHcWmcLDLkopHaukvsjMMTHe6Ielg
         Bu1IkrjNj6PtFxGbyEaIt4TAeEldctkoxd1T4urN9cQITzhTRrsYHvr+9X4pqjo8pIVy
         RkEpDgNHYE692y5uBZR8fGHG7wl6k24ime8KLP+x25Nod8ohRlXcXsjKEz+8MsfVjC+X
         +BTvR1B12fht/twNKyX4Y6w+FWo9mphdIfPQta6S8q3nUfMWM3smU1sIloL4S9yMxbPv
         vs0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=VVTmKBwD5HaJcjDbrGJTEMxMEftyp7ie8061evSzACw=;
        b=Tln3Vb92dXf33CB8Ey5MvCqcVq713BvapUZ6QAZCUyWsk1DePiyKGzCxlqynRBPxSW
         VaptaHSGF9SHmWXyTg73baqcWiSXLZVblP5z9G9AVAiinULSHRkPehLIzz9e32w0bTxQ
         FqdWps5m2tllANfrms7vmVCID/7ZN9J6NiuZ4x87OOA2US+xWGNJnbRZHOWsC2YBPc7L
         z98qjX75G0VHkNRh2cHBgQ5BwBQcSCTKsUPgx/oY8OaCIxpKGJi5903p5FreWsiVFOdN
         RUgoMhPOxqOH0augct10Tw3++SQN8589wKmbA1EYDHVKl6j5hj8GjhLRp5uVR8hXLl7p
         0aIw==
X-Gm-Message-State: APjAAAXlUxuEuct58/Iej5TgLCJy64qhA6ViZOmHKjn/ngNmrSM2VtDU
        AUzKCx5s9KsoNfOg5lbEPVgmk43TUlI=
X-Google-Smtp-Source: APXvYqy/8UBi6m02CsOVgw8dg4TJai9qwwNronjte9VlUst7RgPVJ1h6vG7buE6ygBWyefaSI5oCjQ==
X-Received: by 2002:aa7:961d:: with SMTP id q29mr4919065pfg.89.1574162284116;
        Tue, 19 Nov 2019 03:18:04 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.18.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:03 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Geetha sowjanya <gakula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 04/15] octeontx2-af: Ingress and egress pause frame configuration
Date:   Tue, 19 Nov 2019 16:47:28 +0530
Message-Id: <1574162259-28181-5-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

Pause frames can be generated when NIX/NPA asserts backpressure
due to insufficient resources. This patch enables generation
of pause frames by CGX. Also enabled processing of received
pause frames and asserting backpressure on NIX transmit path.

Also added mailbox config messages for PF/VF to enable/disable
flow control any time.

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 106 +++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  14 +++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  11 +++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  24 +++++
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   5 +
 5 files changed, 160 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index aa2ce5e..af30dad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -381,6 +381,110 @@ int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 }
 EXPORT_SYMBOL(cgx_lmac_tx_enable);
 
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
+EXPORT_SYMBOL(cgx_lmac_get_pause_frm);
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
+EXPORT_SYMBOL(cgx_lmac_set_pause_frm);
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
+		cfg |=  CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+
+		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+		cfg |=  CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+		/* Enable pause frames transmission */
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+		cfg |= CGX_SMUX_TX_CTL_L2P_BP_CONV;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
+
+		/* Set pause time and interval*/
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_TIME,
+			  DEFAULT_PAUSE_TIME);
+		/* Set pause interval as the hardware default is too short */
+		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL);
+		cfg &= ~0xFFFFULL;
+		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_INTERVAL,
+			  cfg | (DEFAULT_PAUSE_TIME - 0x1000));
+
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_TIME,
+			  DEFAULT_PAUSE_TIME);
+
+		cfg = cgx_read(cgx, lmac_id,
+			       CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL);
+		cfg &= ~0xFFFFULL;
+		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL,
+			  cfg | (DEFAULT_PAUSE_TIME - 0x1000));
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
@@ -823,6 +927,7 @@ static int cgx_lmac_init(struct cgx *cgx)
 
 		/* Add reference */
 		cgx->lmac_idmap[i] = lmac;
+		cgx_lmac_pause_frm_config(cgx, i, true);
 	}
 
 	return cgx_lmac_verify_fwi_version(cgx);
@@ -841,6 +946,7 @@ static int cgx_lmac_exit(struct cgx *cgx)
 
 	/* Free all lmac related resources */
 	for (i = 0; i < cgx->lmac_count; i++) {
+		cgx_lmac_pause_frm_config(cgx, i, false);
 		lmac = cgx->lmac_idmap[i];
 		if (!lmac)
 			continue;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index ad47cb8..fa411d4 100644
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
+#define DEFAULT_PAUSE_TIME		0xFFFF
 
 #define CGX_NVEC			37
 #define CGX_LMAC_FWI			0
@@ -125,5 +135,9 @@ int cgx_get_link_info(void *cgxd, int lmac_id,
 		      struct cgx_link_user_info *linfo);
 int cgx_lmac_linkup_start(void *cgxd);
 int cgx_get_fwdata_base(u64 *base);
+int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
+			   u8 *tx_pause, u8 *rx_pause);
+int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
+			   u8 tx_pause, u8 rx_pause);
 int cgx_get_mkex_prfl_info(u64 *addr, u64 *size);
 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index c68266a..3dcfac5 100644
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
@@ -346,6 +348,15 @@ struct cgx_link_info_msg {
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
index e3c87c2..6859339 100644
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
index 83bd42e..10b49e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -193,6 +193,11 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf)
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

