Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894E6FBF9C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 06:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfKNF13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 00:27:29 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42822 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfKNF13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 00:27:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id q17so2935647pgt.9
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 21:27:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=miDv8SxOITYI/csdUExAoBLUJeQnnpM9qLK42nDkbLc=;
        b=jDMzZbOOgmAMmE4/4QVfMC9nS61Kk8/CBcvvNKvuPUqIY+1dql1PE3FN4oBKTQNCSM
         sz02dkzEEvMHyWaTyZSwLTilr3uTQdPd/U3f5WFepZkHx6TLTKL+PvwMg6Hg73dQaI7z
         ua33ZMlsbsZffHkplJ4WH+bVm9Hxg0hb2XjBVWGCkwwkwqCwdwQ9q/6qMyEoB5+Yfi8K
         s8/J/m8asTVP/GZO0nQLL5iK475SbGCMuhQhRSNKQU1NdkI1da85adpCCiQr1PtD0koj
         97E0LfFHcavtu7j9CqrkEntOkitEWOw1Bl6f3I2qwjgo0rusenqCgKkw5gEG3Dbqitwm
         UVkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=miDv8SxOITYI/csdUExAoBLUJeQnnpM9qLK42nDkbLc=;
        b=gJr01/4hwoHCBt5aBjOUutWiIfCGfH3MAhPZ041M66+ZbNWUZ8Xw95xsQ+1xgNCTLc
         MCpBqwHHOTD1u8n9LmjoWuIwYnQOJ1G+IjUx57Bf7RcvTxlRLQwJ+oHeaeT64z+4zLOc
         pRGvsaUd3loSItT+XRahj8HcwDTC0ZJAwZeMaFjWB/Cw8XIccqgZ9SKNHLq0tQLpJF2H
         y8xGN1FqDE7Xdx8BQlhtJHAdosvqMtPlGVlTnxUBAi0zydfcK3lpOrIu8aVEJBBaeEJS
         BGUbPy9pxVTgNIQYuioZ8BTY4QoVGkiTGbkTImQw6eLW2fzfbA4tTOUgiDbGu2ZQeqML
         +ygg==
X-Gm-Message-State: APjAAAWP13oXEJCbUvSX/jqQmdblaE8oZXOZRboyFUUQBfOwGWiuZSus
        wuBiK4mRZRAy9q7C70oqs/wPAt//gQI=
X-Google-Smtp-Source: APXvYqxCnlOfArJNj779cbbQHE/jc5L2VKVVrZYAoiMsHFH8ajGhSVlJzhmPF/F8Cr9b9XUWc0VMsA==
X-Received: by 2002:a17:90b:438b:: with SMTP id in11mr10067103pjb.129.1573709247665;
        Wed, 13 Nov 2019 21:27:27 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id a6sm4913261pja.30.2019.11.13.21.27.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 13 Nov 2019 21:27:26 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Linu Cherian <lcherian@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 06/18] octeontx2-af: Add per CGX port level NIX Rx/Tx counters
Date:   Thu, 14 Nov 2019 10:56:21 +0530
Message-Id: <1573709193-15446-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1573709193-15446-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Linu Cherian <lcherian@marvell.com>

A CGX port is shared by a RVU PF and it's VFs. These per
CGX port level NIX Rx/Tx counters are cumilative stats of
all NIXLFs sharing this port. These stats when compared
to CGX Rx/Tx stats helps in identifying pkts dropped within
the system, if any.

Signed-off-by: Linu Cherian <lcherian@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 10 +++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  6 ++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 62 +++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 95 ++++++++++++++++++++++
 5 files changed, 173 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 6d55e3d..d94e682 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -138,6 +138,16 @@ void *cgx_get_pdata(int cgx_id)
 }
 EXPORT_SYMBOL(cgx_get_pdata);
 
+int cgx_get_cgxid(void *cgxd)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!cgx)
+		return -EINVAL;
+
+	return cgx->cgx_id;
+}
+
 /* Ensure the required lock for event queue(where asynchronous events are
  * posted) is acquired before calling this API. Else an asynchronous event(with
  * latest link status) can reach the destination before this function returns
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 206dc5d..c0306b2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -63,6 +63,11 @@
 #define CGX_NVEC			37
 #define CGX_LMAC_FWI			0
 
+enum  cgx_nix_stat_type {
+	NIX_STATS_RX,
+	NIX_STATS_TX,
+};
+
 enum LMAC_TYPE {
 	LMAC_MODE_SGMII		= 0,
 	LMAC_MODE_XAUI		= 1,
@@ -96,6 +101,7 @@ struct cgx_event_cb {
 extern struct pci_driver cgx_driver;
 
 int cgx_get_cgxcnt_max(void);
+int cgx_get_cgxid(void *cgxd);
 int cgx_get_lmac_cnt(void *cgxd);
 void *cgx_get_pdata(int cgx_id);
 int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 2fb871d..0451c2b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -374,6 +374,8 @@ int rvu_cgx_init(struct rvu *rvu);
 int rvu_cgx_exit(struct rvu *rvu);
 void *rvu_cgx_pdata(u8 cgx_id, struct rvu *rvu);
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start);
+int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
+			   int rxtxflag, u64 *stat);
 int rvu_mbox_handler_cgx_start_rxtx(struct rvu *rvu, struct msg_req *req,
 				    struct msg_rsp *rsp);
 int rvu_mbox_handler_cgx_stop_rxtx(struct rvu *rvu, struct msg_req *req,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 7d7133c..65d01e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -14,6 +14,7 @@
 
 #include "rvu.h"
 #include "cgx.h"
+#include "rvu_reg.h"
 
 struct cgx_evq_entry {
 	struct list_head evq_node;
@@ -40,12 +41,25 @@ MBOX_UP_CGX_MESSAGES
 #undef M
 
 /* Returns bitmap of mapped PFs */
-static inline u16 cgxlmac_to_pfmap(struct rvu *rvu, u8 cgx_id, u8 lmac_id)
+static u16 cgxlmac_to_pfmap(struct rvu *rvu, u8 cgx_id, u8 lmac_id)
 {
 	return rvu->cgxlmac2pf_map[CGX_OFFSET(cgx_id) + lmac_id];
 }
 
-static inline u8 cgxlmac_id_to_bmap(u8 cgx_id, u8 lmac_id)
+static int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id)
+{
+	unsigned long pfmap;
+
+	pfmap = cgxlmac_to_pfmap(rvu, cgx_id, lmac_id);
+
+	/* Assumes only one pf mapped to a cgx lmac port */
+	if (!pfmap)
+		return -ENODEV;
+	else
+		return find_first_bit(&pfmap, 16);
+}
+
+static u8 cgxlmac_id_to_bmap(u8 cgx_id, u8 lmac_id)
 {
 	return ((cgx_id & 0xF) << 4) | (lmac_id & 0xF);
 }
@@ -562,3 +576,47 @@ int rvu_mbox_handler_cgx_intlbk_disable(struct rvu *rvu, struct msg_req *req,
 	rvu_cgx_config_intlbk(rvu, req->hdr.pcifunc, false);
 	return 0;
 }
+
+/* Finds cumulative status of NIX rx/tx counters from LF of a PF and those
+ * from its VFs as well. ie. NIX rx/tx counters at the CGX port level
+ */
+int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id,
+			   int index, int rxtxflag, u64 *stat)
+{
+	struct rvu_block *block;
+	int blkaddr;
+	u16 pcifunc;
+	int pf, lf;
+
+	if (!cgxd || !rvu)
+		return -EINVAL;
+
+	pf = cgxlmac_to_pf(rvu, cgx_get_cgxid(cgxd), lmac_id);
+	if (pf < 0)
+		return pf;
+
+	/* Assumes LF of a PF and all of its VF belongs to the same
+	 * NIX block
+	 */
+	pcifunc = pf << RVU_PFVF_PF_SHIFT;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, pcifunc);
+	if (blkaddr < 0)
+		return 0;
+	block = &rvu->hw->block[blkaddr];
+
+	*stat = 0;
+	for (lf = 0; lf < block->lf.max; lf++) {
+		/* Check if a lf is attached to this PF or one of its VFs */
+		if (!((block->fn_map[lf] & ~RVU_PFVF_FUNC_MASK) == (pcifunc &
+			 ~RVU_PFVF_FUNC_MASK)))
+			continue;
+		if (rxtxflag == NIX_STATS_RX)
+			*stat += rvu_read64(rvu, blkaddr,
+					    NIX_AF_LFX_RX_STATX(lf, index));
+		else
+			*stat += rvu_read64(rvu, blkaddr,
+					    NIX_AF_LFX_TX_STATX(lf, index));
+	}
+
+	return 0;
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index c01a85e..023f3e5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -44,6 +44,33 @@ enum {
 	CGX_STAT18,
 };
 
+/* NIX TX stats */
+enum nix_stat_lf_tx {
+	TX_UCAST	= 0x0,
+	TX_BCAST	= 0x1,
+	TX_MCAST	= 0x2,
+	TX_DROP		= 0x3,
+	TX_OCTS		= 0x4,
+	TX_STATS_ENUM_LAST,
+};
+
+/* NIX RX stats */
+enum nix_stat_lf_rx {
+	RX_OCTS		= 0x0,
+	RX_UCAST	= 0x1,
+	RX_BCAST	= 0x2,
+	RX_MCAST	= 0x3,
+	RX_DROP		= 0x4,
+	RX_DROP_OCTS	= 0x5,
+	RX_FCS		= 0x6,
+	RX_ERR		= 0x7,
+	RX_DRP_BCAST	= 0x8,
+	RX_DRP_MCAST	= 0x9,
+	RX_DRP_L3BCAST	= 0xa,
+	RX_DRP_L3MCAST	= 0xb,
+	RX_STATS_ENUM_LAST,
+};
+
 static char *cgx_rx_stats_fields[] = {
 	[CGX_STAT0]	= "Received packets",
 	[CGX_STAT1]	= "Octets of received packets",
@@ -1329,12 +1356,39 @@ static void rvu_dbg_npa_init(struct rvu *rvu)
 	debugfs_remove_recursive(rvu->rvu_dbg.npa);
 }
 
+#define PRINT_CGX_CUML_NIXRX_STATUS(idx, name)				\
+	({								\
+		u64 cnt;						\
+		err = rvu_cgx_nix_cuml_stats(rvu, cgxd, lmac_id, (idx),	\
+					     NIX_STATS_RX, &(cnt));	\
+		if (!err)						\
+			seq_printf(s, "%s: %llu\n", name, cnt);		\
+		cnt;							\
+	})
+
+#define PRINT_CGX_CUML_NIXTX_STATUS(idx, name)			\
+	({								\
+		u64 cnt;						\
+		err = rvu_cgx_nix_cuml_stats(rvu, cgxd, lmac_id, (idx),	\
+					  NIX_STATS_TX, &(cnt));	\
+		if (!err)						\
+			seq_printf(s, "%s: %llu\n", name, cnt);		\
+		cnt;							\
+	})
+
 static int cgx_print_stats(struct seq_file *s, int lmac_id)
 {
 	struct cgx_link_user_info linfo;
 	void *cgxd = s->private;
+	u64 ucast, mcast, bcast;
 	int stat = 0, err = 0;
 	u64 tx_stat, rx_stat;
+	struct rvu *rvu;
+
+	rvu = pci_get_drvdata(pci_get_device(PCI_VENDOR_ID_CAVIUM,
+					     PCI_DEVID_OCTEONTX2_RVU_AF, NULL));
+	if (!rvu)
+		return -ENODEV;
 
 	/* Link status */
 	seq_puts(s, "\n=======Link Status======\n\n");
@@ -1345,6 +1399,47 @@ static int cgx_print_stats(struct seq_file *s, int lmac_id)
 		   linfo.link_up ? "UP" : "DOWN", linfo.speed);
 
 	/* Rx stats */
+	seq_puts(s, "\n=======NIX RX_STATS(CGX port level)======\n\n");
+	ucast = PRINT_CGX_CUML_NIXRX_STATUS(RX_UCAST, "rx_ucast_frames");
+	if (err)
+		return err;
+	mcast = PRINT_CGX_CUML_NIXRX_STATUS(RX_MCAST, "rx_mcast_frames");
+	if (err)
+		return err;
+	bcast = PRINT_CGX_CUML_NIXRX_STATUS(RX_BCAST, "rx_bcast_frames");
+	if (err)
+		return err;
+	seq_printf(s, "rx_frames: %llu\n", ucast + mcast + bcast);
+	PRINT_CGX_CUML_NIXRX_STATUS(RX_OCTS, "rx_bytes");
+	if (err)
+		return err;
+	PRINT_CGX_CUML_NIXRX_STATUS(RX_DROP, "rx_drops");
+	if (err)
+		return err;
+	PRINT_CGX_CUML_NIXRX_STATUS(RX_ERR, "rx_errors");
+	if (err)
+		return err;
+
+	/* Tx stats */
+	seq_puts(s, "\n=======NIX TX_STATS(CGX port level)======\n\n");
+	ucast = PRINT_CGX_CUML_NIXTX_STATUS(TX_UCAST, "tx_ucast_frames");
+	if (err)
+		return err;
+	mcast = PRINT_CGX_CUML_NIXTX_STATUS(TX_MCAST, "tx_mcast_frames");
+	if (err)
+		return err;
+	bcast = PRINT_CGX_CUML_NIXTX_STATUS(TX_BCAST, "tx_bcast_frames");
+	if (err)
+		return err;
+	seq_printf(s, "tx_frames: %llu\n", ucast + mcast + bcast);
+	PRINT_CGX_CUML_NIXTX_STATUS(TX_OCTS, "tx_bytes");
+	if (err)
+		return err;
+	PRINT_CGX_CUML_NIXTX_STATUS(TX_DROP, "tx_drops");
+	if (err)
+		return err;
+
+	/* Rx stats */
 	seq_puts(s, "\n=======CGX RX_STATS======\n\n");
 	while (stat < CGX_RX_STATS_COUNT) {
 		err = cgx_get_rx_stats(cgxd, lmac_id, stat, &rx_stat);
-- 
2.7.4

