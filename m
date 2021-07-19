Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5591F3CCFC5
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 11:04:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235713AbhGSITw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Jul 2021 04:19:52 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44842 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235831AbhGSITg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Jul 2021 04:19:36 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16J8u6aM031979;
        Mon, 19 Jul 2021 02:00:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=QUvBFUyo3hiMIAsDWdJFip3ZVA5jYDYQZqNM+BOT/gY=;
 b=IYttAhEYGwjTWec4q73/IzL4MQfvTkQpOTJwQFaB0co1Khtjfehv6Q4dVP7qoYCzdVFa
 cNB7UVKrFjZC43OPJO99YFm3qCnXmh4DqbNVTPPnjJWErHtKikZ2xjz3K1rHEX6fJihE
 veB4UcpIApwXOm6ZXbD9ZolXEOWacM5ZHphvlMY5LrAixlbFrCdLVJQJ8CsD7AVwVjjo
 h2J9ToMhYU2Q0Em9c/sTa1Cx9wvHxpa7i4zSD7EplD+L+md2EwWZKzvM9w3vfMyFwaN1
 Vbse01aALn6WYyuYzDWOFMpQeuSbXlMcBjdggRpfDCwmX7922l8lcV5g378GuVpxGE8H vw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 39vysrs7ea-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 19 Jul 2021 02:00:12 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 19 Jul
 2021 02:00:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 19 Jul 2021 02:00:10 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 495FA5E686A;
        Mon, 19 Jul 2021 02:00:07 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 3/3] octeontx2-af: Introduce internal packet switching
Date:   Mon, 19 Jul 2021 14:29:34 +0530
Message-ID: <1626685174-4766-4-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
References: <1626685174-4766-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: umTM2jEeXJlHCv-bpqpo_uKQ9oT3gVrj
X-Proofpoint-ORIG-GUID: umTM2jEeXJlHCv-bpqpo_uKQ9oT3gVrj
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-19_02:2021-07-16,2021-07-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of now any communication between CGXs PFs and
their VFs within the system is possible only by
external switches sending packets back to the
system. This patch adds internal switching support.
Broadcast packet replication is not covered here.
RVU admin function (AF) maintains MAC addresses
of all interfaces in the system. When switching is
enabled, MCAM entries are allocated to install rules
such that packets with DMAC matching any of the
internal interface MAC addresses is punted back
into the system via the loopback channel.
On the receive side the default unicast rules
are modified to not check for ingress channel.
So any packet with matching DMAC irrespective of
which interface it is coming from will be forwarded
to the respective PF/VF interface.
The transmit side rules and default unicast rules
are updated if user changes MAC address of an interface.

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/Makefile |   2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   4 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  19 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |   3 +
 .../ethernet/marvell/octeontx2/af/rvu_devlink.c    |  48 +++-
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    |   4 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c |   9 +-
 .../net/ethernet/marvell/octeontx2/af/rvu_switch.c | 258 +++++++++++++++++++++
 8 files changed, 336 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/Makefile b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
index 1a34556..cc8ac36 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/Makefile
+++ b/drivers/net/ethernet/marvell/octeontx2/af/Makefile
@@ -10,4 +10,4 @@ obj-$(CONFIG_OCTEONTX2_AF) += rvu_af.o
 rvu_mbox-y := mbox.o rvu_trace.o
 rvu_af-y := cgx.o rvu.o rvu_cgx.o rvu_npa.o rvu_nix.o \
 		  rvu_reg.o rvu_npc.o rvu_debugfs.o ptp.o rvu_npc_fs.o \
-		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o
+		  rvu_cpt.o rvu_devlink.o rpm.o rvu_cn10k.o rvu_switch.o
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 086eb6d..017163f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -1314,7 +1314,7 @@ int rvu_mbox_handler_detach_resources(struct rvu *rvu,
 	return rvu_detach_rsrcs(rvu, detach, detach->hdr.pcifunc);
 }
 
-static int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
+int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc)
 {
 	struct rvu_pfvf *pfvf = rvu_get_pfvf(rvu, pcifunc);
 	int blkaddr = BLKADDR_NIX0, vf;
@@ -3007,6 +3007,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Initialize debugfs */
 	rvu_dbg_init(rvu);
 
+	mutex_init(&rvu->rswitch.switch_lock);
+
 	return 0;
 err_dl:
 	rvu_unregister_dl(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index e53f530..91503fb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -417,6 +417,14 @@ struct npc_kpu_profile_adapter {
 
 #define RVU_SWITCH_LBK_CHAN	63
 
+struct rvu_switch {
+	struct mutex switch_lock; /* Serialize flow installation */
+	u32 used_entries;
+	u16 *entry2pcifunc;
+	u16 mode;
+	u16 start_entry;
+};
+
 struct rvu {
 	void __iomem		*afreg_base;
 	void __iomem		*pfreg_base;
@@ -447,6 +455,7 @@ struct rvu {
 
 	/* CGX */
 #define PF_CGXMAP_BASE		1 /* PF 0 is reserved for RVU PF */
+	u16			cgx_mapped_vfs; /* maximum CGX mapped VFs */
 	u8			cgx_mapped_pfs;
 	u8			cgx_cnt_max;	 /* CGX port count max */
 	u8			*pf2cgxlmac_map; /* pf to cgx_lmac map */
@@ -479,6 +488,9 @@ struct rvu {
 	struct rvu_debugfs	rvu_dbg;
 #endif
 	struct rvu_devlink	*rvu_dl;
+
+	/* RVU switch implementation over NPC with DMAC rules */
+	struct rvu_switch	rswitch;
 };
 
 static inline void rvu_write64(struct rvu *rvu, u64 block, u64 offset, u64 val)
@@ -693,6 +705,7 @@ int nix_aq_context_read(struct rvu *rvu, struct nix_hw *nix_hw,
 			struct nix_cn10k_aq_enq_req *aq_req,
 			struct nix_cn10k_aq_enq_rsp *aq_rsp,
 			u16 pcifunc, u8 ctype, u32 qidx);
+int rvu_get_nix_blkaddr(struct rvu *rvu, u16 pcifunc);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
@@ -770,4 +783,10 @@ void rvu_dbg_exit(struct rvu *rvu);
 static inline void rvu_dbg_init(struct rvu *rvu) {}
 static inline void rvu_dbg_exit(struct rvu *rvu) {}
 #endif
+
+/* RVU Switch */
+void rvu_switch_enable(struct rvu *rvu);
+void rvu_switch_disable(struct rvu *rvu);
+void rvu_switch_update_rules(struct rvu *rvu, u16 pcifunc);
+
 #endif /* RVU_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 6cc8fbb..fe99ac4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -126,6 +126,7 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 	unsigned long lmac_bmap;
 	int size, free_pkind;
 	int cgx, lmac, iter;
+	int numvfs, hwvfs;
 
 	if (!cgx_cnt_max)
 		return 0;
@@ -166,6 +167,8 @@ static int rvu_map_cgx_lmac_pf(struct rvu *rvu)
 			pkind->pfchan_map[free_pkind] = ((pf) & 0x3F) << 16;
 			rvu_map_cgx_nix_block(rvu, pf, cgx, lmac);
 			rvu->cgx_mapped_pfs++;
+			rvu_get_pf_numvfs(rvu, pf, &numvfs, &hwvfs);
+			rvu->cgx_mapped_vfs += numvfs;
 			pf++;
 		}
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 10a98bc..2688186 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -1364,6 +1364,44 @@ static void rvu_health_reporters_destroy(struct rvu *rvu)
 	rvu_nix_health_reporters_destroy(rvu_dl);
 }
 
+static int rvu_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	struct rvu_switch *rswitch;
+
+	rswitch = &rvu->rswitch;
+	*mode = rswitch->mode;
+
+	return 0;
+}
+
+static int rvu_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
+					struct netlink_ext_ack *extack)
+{
+	struct rvu_devlink *rvu_dl = devlink_priv(devlink);
+	struct rvu *rvu = rvu_dl->rvu;
+	struct rvu_switch *rswitch;
+
+	rswitch = &rvu->rswitch;
+	switch (mode) {
+	case DEVLINK_ESWITCH_MODE_LEGACY:
+	case DEVLINK_ESWITCH_MODE_SWITCHDEV:
+		if (rswitch->mode == mode)
+			return 0;
+		rswitch->mode = mode;
+		if (mode == DEVLINK_ESWITCH_MODE_SWITCHDEV)
+			rvu_switch_enable(rvu);
+		else
+			rvu_switch_disable(rvu);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
 				struct netlink_ext_ack *extack)
 {
@@ -1372,6 +1410,8 @@ static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req
 
 static const struct devlink_ops rvu_devlink_ops = {
 	.info_get = rvu_devlink_info_get,
+	.eswitch_mode_get = rvu_devlink_eswitch_mode_get,
+	.eswitch_mode_set = rvu_devlink_eswitch_mode_set,
 };
 
 int rvu_register_dl(struct rvu *rvu)
@@ -1380,14 +1420,9 @@ int rvu_register_dl(struct rvu *rvu)
 	struct devlink *dl;
 	int err;
 
-	rvu_dl = kzalloc(sizeof(*rvu_dl), GFP_KERNEL);
-	if (!rvu_dl)
-		return -ENOMEM;
-
 	dl = devlink_alloc(&rvu_devlink_ops, sizeof(struct rvu_devlink));
 	if (!dl) {
 		dev_warn(rvu->dev, "devlink_alloc failed\n");
-		kfree(rvu_dl);
 		return -ENOMEM;
 	}
 
@@ -1395,10 +1430,10 @@ int rvu_register_dl(struct rvu *rvu)
 	if (err) {
 		dev_err(rvu->dev, "devlink register failed with error %d\n", err);
 		devlink_free(dl);
-		kfree(rvu_dl);
 		return err;
 	}
 
+	rvu_dl = devlink_priv(dl);
 	rvu_dl->dl = dl;
 	rvu_dl->rvu = rvu;
 	rvu->rvu_dl = rvu_dl;
@@ -1417,5 +1452,4 @@ void rvu_unregister_dl(struct rvu *rvu)
 	rvu_health_reporters_destroy(rvu);
 	devlink_unregister(dl);
 	devlink_free(dl);
-	kfree(rvu_dl);
 }
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index a2d69ea..0933699 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3212,6 +3212,8 @@ int rvu_mbox_handler_nix_set_mac_addr(struct rvu *rvu,
 	if (test_bit(PF_SET_VF_TRUSTED, &pfvf->flags) && from_vf)
 		ether_addr_copy(pfvf->default_mac, req->mac_addr);
 
+	rvu_switch_update_rules(rvu, pcifunc);
+
 	return 0;
 }
 
@@ -3881,6 +3883,8 @@ int rvu_mbox_handler_nix_lf_start_rx(struct rvu *rvu, struct msg_req *req,
 	pfvf = rvu_get_pfvf(rvu, pcifunc);
 	set_bit(NIXLF_INITIALIZED, &pfvf->flags);
 
+	rvu_switch_update_rules(rvu, pcifunc);
+
 	return rvu_cgx_start_stop_io(rvu, pcifunc, true);
 }
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
index c1f35a0..5c01cf4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_fs.c
@@ -910,10 +910,15 @@ static void rvu_mcam_add_counter_to_rule(struct rvu *rvu, u16 pcifunc,
 
 static void npc_update_rx_entry(struct rvu *rvu, struct rvu_pfvf *pfvf,
 				struct mcam_entry *entry,
-				struct npc_install_flow_req *req, u16 target)
+				struct npc_install_flow_req *req,
+				u16 target, bool pf_set_vfs_mac)
 {
+	struct rvu_switch *rswitch = &rvu->rswitch;
 	struct nix_rx_action action;
 
+	if (rswitch->mode == DEVLINK_ESWITCH_MODE_SWITCHDEV && pf_set_vfs_mac)
+		req->chan_mask = 0x0; /* Do not care channel */
+
 	npc_update_entry(rvu, NPC_CHAN, entry, req->channel, 0, req->chan_mask,
 			 0, NIX_INTF_RX);
 
@@ -1007,7 +1012,7 @@ static int npc_install_flow(struct rvu *rvu, int blkaddr, u16 target,
 			req->intf);
 
 	if (is_npc_intf_rx(req->intf))
-		npc_update_rx_entry(rvu, pfvf, entry, req, target);
+		npc_update_rx_entry(rvu, pfvf, entry, req, target, pf_set_vfs_mac);
 	else
 		npc_update_tx_entry(rvu, pfvf, entry, req, target);
 
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
new file mode 100644
index 0000000..2e53797
--- /dev/null
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
@@ -0,0 +1,258 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Marvell OcteonTx2 RVU Admin Function driver
+ *
+ * Copyright (C) 2021 Marvell.
+ */
+
+#include <linux/bitfield.h>
+#include "rvu.h"
+
+static int rvu_switch_install_rx_rule(struct rvu *rvu, u16 pcifunc,
+				      u16 chan_mask)
+{
+	struct npc_install_flow_req req = { 0 };
+	struct npc_install_flow_rsp rsp = { 0 };
+	struct rvu_pfvf *pfvf;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	/* If the pcifunc is not initialized then nothing to do.
+	 * This same function will be called again via rvu_switch_update_rules
+	 * after pcifunc is initialized.
+	 */
+	if (!test_bit(NIXLF_INITIALIZED, &pfvf->flags))
+		return 0;
+
+	ether_addr_copy(req.packet.dmac, pfvf->mac_addr);
+	eth_broadcast_addr((u8 *)&req.mask.dmac);
+	req.hdr.pcifunc = 0; /* AF is requester */
+	req.vf = pcifunc;
+	req.features = BIT_ULL(NPC_DMAC);
+	req.channel = pfvf->rx_chan_base;
+	req.chan_mask = chan_mask;
+	req.intf = pfvf->nix_rx_intf;
+	req.op = NIX_RX_ACTION_DEFAULT;
+	req.default_rule = 1;
+
+	return rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
+}
+
+static int rvu_switch_install_tx_rule(struct rvu *rvu, u16 pcifunc, u16 entry)
+{
+	struct npc_install_flow_req req = { 0 };
+	struct npc_install_flow_rsp rsp = { 0 };
+	struct rvu_pfvf *pfvf;
+	u8 lbkid;
+
+	pfvf = rvu_get_pfvf(rvu, pcifunc);
+	/* If the pcifunc is not initialized then nothing to do.
+	 * This same function will be called again via rvu_switch_update_rules
+	 * after pcifunc is initialized.
+	 */
+	if (!test_bit(NIXLF_INITIALIZED, &pfvf->flags))
+		return 0;
+
+	lbkid = pfvf->nix_blkaddr == BLKADDR_NIX0 ? 0 : 1;
+	ether_addr_copy(req.packet.dmac, pfvf->mac_addr);
+	eth_broadcast_addr((u8 *)&req.mask.dmac);
+	req.hdr.pcifunc = 0; /* AF is requester */
+	req.vf = pcifunc;
+	req.entry = entry;
+	req.features = BIT_ULL(NPC_DMAC);
+	req.intf = pfvf->nix_tx_intf;
+	req.op = NIX_TX_ACTIONOP_UCAST_CHAN;
+	req.index = (lbkid << 8) | RVU_SWITCH_LBK_CHAN;
+	req.set_cntr = 1;
+
+	return rvu_mbox_handler_npc_install_flow(rvu, &req, &rsp);
+}
+
+static int rvu_switch_install_rules(struct rvu *rvu)
+{
+	struct rvu_switch *rswitch = &rvu->rswitch;
+	u16 start = rswitch->start_entry;
+	struct rvu_hwinfo *hw = rvu->hw;
+	int pf, vf, numvfs, hwvf;
+	u16 pcifunc, entry = 0;
+	int err;
+
+	for (pf = 1; pf < hw->total_pfs; pf++) {
+		if (!is_pf_cgxmapped(rvu, pf))
+			continue;
+
+		pcifunc = pf << 10;
+		/* rvu_get_nix_blkaddr sets up the corresponding NIX block
+		 * address and NIX RX and TX interfaces for a pcifunc.
+		 * Generally it is called during attach call of a pcifunc but it
+		 * is called here since we are pre-installing rules before
+		 * nixlfs are attached
+		 */
+		rvu_get_nix_blkaddr(rvu, pcifunc);
+
+		/* MCAM RX rule for a PF/VF already exists as default unicast
+		 * rules installed by AF. Hence change the channel in those
+		 * rules to ignore channel so that packets with the required
+		 * DMAC received from LBK(by other PF/VFs in system) or from
+		 * external world (from wire) are accepted.
+		 */
+		err = rvu_switch_install_rx_rule(rvu, pcifunc, 0x0);
+		if (err) {
+			dev_err(rvu->dev, "RX rule for PF%d failed(%d)\n",
+				pf, err);
+			return err;
+		}
+
+		err = rvu_switch_install_tx_rule(rvu, pcifunc, start + entry);
+		if (err) {
+			dev_err(rvu->dev, "TX rule for PF%d failed(%d)\n",
+				pf, err);
+			return err;
+		}
+
+		rswitch->entry2pcifunc[entry++] = pcifunc;
+
+		rvu_get_pf_numvfs(rvu, pf, &numvfs, &hwvf);
+		for (vf = 0; vf < numvfs; vf++, hwvf++) {
+			pcifunc = pf << 10 | ((vf + 1) & 0x3FF);
+			rvu_get_nix_blkaddr(rvu, pcifunc);
+
+			err = rvu_switch_install_rx_rule(rvu, pcifunc, 0x0);
+			if (err) {
+				dev_err(rvu->dev,
+					"RX rule for PF%dVF%d failed(%d)\n",
+					pf, vf, err);
+				return err;
+			}
+
+			err = rvu_switch_install_tx_rule(rvu, pcifunc,
+							 start + entry);
+			if (err) {
+				dev_err(rvu->dev,
+					"TX rule for PF%dVF%d failed(%d)\n",
+					pf, vf, err);
+				return err;
+			}
+
+			rswitch->entry2pcifunc[entry++] = pcifunc;
+		}
+	}
+
+	return 0;
+}
+
+void rvu_switch_enable(struct rvu *rvu)
+{
+	struct npc_mcam_alloc_entry_req alloc_req = { 0 };
+	struct npc_mcam_alloc_entry_rsp alloc_rsp = { 0 };
+	struct npc_delete_flow_req uninstall_req = { 0 };
+	struct npc_mcam_free_entry_req free_req = { 0 };
+	struct rvu_switch *rswitch = &rvu->rswitch;
+	struct msg_rsp rsp;
+	int ret;
+
+	alloc_req.contig = true;
+	alloc_req.count = rvu->cgx_mapped_pfs + rvu->cgx_mapped_vfs;
+	ret = rvu_mbox_handler_npc_mcam_alloc_entry(rvu, &alloc_req,
+						    &alloc_rsp);
+	if (ret) {
+		dev_err(rvu->dev,
+			"Unable to allocate MCAM entries\n");
+		goto exit;
+	}
+
+	if (alloc_rsp.count != alloc_req.count) {
+		dev_err(rvu->dev,
+			"Unable to allocate %d MCAM entries, got %d\n",
+			alloc_req.count, alloc_rsp.count);
+		goto free_entries;
+	}
+
+	rswitch->entry2pcifunc = kcalloc(alloc_req.count, sizeof(u16),
+					 GFP_KERNEL);
+	if (!rswitch->entry2pcifunc)
+		goto free_entries;
+
+	rswitch->used_entries = alloc_rsp.count;
+	rswitch->start_entry = alloc_rsp.entry;
+
+	ret = rvu_switch_install_rules(rvu);
+	if (ret)
+		goto uninstall_rules;
+
+	return;
+
+uninstall_rules:
+	uninstall_req.start = rswitch->start_entry;
+	uninstall_req.end =  rswitch->start_entry + rswitch->used_entries - 1;
+	rvu_mbox_handler_npc_delete_flow(rvu, &uninstall_req, &rsp);
+	kfree(rswitch->entry2pcifunc);
+free_entries:
+	free_req.all = 1;
+	rvu_mbox_handler_npc_mcam_free_entry(rvu, &free_req, &rsp);
+exit:
+	return;
+}
+
+void rvu_switch_disable(struct rvu *rvu)
+{
+	struct npc_delete_flow_req uninstall_req = { 0 };
+	struct npc_mcam_free_entry_req free_req = { 0 };
+	struct rvu_switch *rswitch = &rvu->rswitch;
+	struct rvu_hwinfo *hw = rvu->hw;
+	int pf, vf, numvfs, hwvf;
+	struct msg_rsp rsp;
+	u16 pcifunc;
+	int err;
+
+	if (!rswitch->used_entries)
+		return;
+
+	for (pf = 1; pf < hw->total_pfs; pf++) {
+		if (!is_pf_cgxmapped(rvu, pf))
+			continue;
+
+		pcifunc = pf << 10;
+		err = rvu_switch_install_rx_rule(rvu, pcifunc, 0xFFF);
+		if (err)
+			dev_err(rvu->dev,
+				"Reverting RX rule for PF%d failed(%d)\n",
+				pf, err);
+
+		for (vf = 0; vf < numvfs; vf++, hwvf++) {
+			pcifunc = pf << 10 | ((vf + 1) & 0x3FF);
+			err = rvu_switch_install_rx_rule(rvu, pcifunc, 0xFFF);
+			if (err)
+				dev_err(rvu->dev,
+					"Reverting RX rule for PF%dVF%d failed(%d)\n",
+					pf, vf, err);
+		}
+	}
+
+	uninstall_req.start = rswitch->start_entry;
+	uninstall_req.end =  rswitch->start_entry + rswitch->used_entries - 1;
+	free_req.all = 1;
+	rvu_mbox_handler_npc_delete_flow(rvu, &uninstall_req, &rsp);
+	rvu_mbox_handler_npc_mcam_free_entry(rvu, &free_req, &rsp);
+	rswitch->used_entries = 0;
+	kfree(rswitch->entry2pcifunc);
+}
+
+void rvu_switch_update_rules(struct rvu *rvu, u16 pcifunc)
+{
+	struct rvu_switch *rswitch = &rvu->rswitch;
+	u32 max = rswitch->used_entries;
+	u16 entry;
+
+	if (!rswitch->used_entries)
+		return;
+
+	for (entry = 0; entry < max; entry++) {
+		if (rswitch->entry2pcifunc[entry] == pcifunc)
+			break;
+	}
+
+	if (entry >= max)
+		return;
+
+	rvu_switch_install_tx_rule(rvu, pcifunc, rswitch->start_entry + entry);
+	rvu_switch_install_rx_rule(rvu, pcifunc, 0x0);
+}
-- 
2.7.4

