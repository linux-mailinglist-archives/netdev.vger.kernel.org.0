Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33F1F6266F8
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:33:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234754AbiKLEdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:33:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234480AbiKLEcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:32:33 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BA0606BD;
        Fri, 11 Nov 2022 20:32:26 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AC1FX9C018810;
        Fri, 11 Nov 2022 20:32:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=QoK7Ceat/Zk5IcsFJLduL9+StA7lF8EbzsV4nxurJg0=;
 b=in31PWm72L38BTPPBgCB6z8iS+VMWNShWJilgDrldd+i0LfPojRB+rgs2yCksqFAKXbV
 JyTf+pDBBlrHhvCmzc4/9GAyOFVzeHt4JW03x9Qgi/7Wej52av6lvvRQnAVY8uaq3K8+
 H9gjQdlAWDuKe7iI5TzLbo4CHB2H2f1gHg+py9nb6CSYtK5uEUnioVEK+U4qEV31U4HT
 t7boTcVPziQZXRpjNg4Ysv85z6Nl25BKyK5iC4xKvQpb3zKf8IHS/bU3yhxMTmjO22ST
 2o64GxlrtNj5II/J19zyklOmIadeQ93lUHR9RKQhupmnrGBK/DwStZ7Y8lVmBTm7YB09 aQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3kt1nv0bf0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Nov 2022 20:32:21 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Nov
 2022 20:32:19 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 11 Nov 2022 20:32:19 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id F1EFA3F7054;
        Fri, 11 Nov 2022 20:32:14 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>
Subject: [net-next PATCH 8/9] octeontx2-af: physical link state change
Date:   Sat, 12 Nov 2022 10:01:40 +0530
Message-ID: <20221112043141.13291-9-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221112043141.13291-1-hkelam@marvell.com>
References: <20221112043141.13291-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4tbqJ5GHFZEXfTAfKnNHI2LhhXSlyvBT
X-Proofpoint-GUID: 4tbqJ5GHFZEXfTAfKnNHI2LhhXSlyvBT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-12_02,2022-11-11_01,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vamsi Attunuru <vattunuru@marvell.com>

There are few scenarios where physical link change is required.
This patch adds mailbox support for the same such that PF and VF
netdevices can request for link change.

Signed-off-by: Vamsi Attunuru <vattunuru@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 10 ++++++++
 .../net/ethernet/marvell/octeontx2/af/cgx.h   |  1 +
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  7 ++++++
 .../ethernet/marvell/octeontx2/af/rvu_cgx.c   | 24 +++++++++++++++++++
 4 files changed, 42 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 1383d1636cbe..33d1bd6734ea 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1587,6 +1587,16 @@ static void cgx_lmac_linkup_work(struct work_struct *work)
 	}
 }
 
+int cgx_set_link_state(void *cgxd, int lmac_id, bool enable)
+{
+	struct cgx *cgx = cgxd;
+
+	if (!cgx)
+		return -ENODEV;
+
+	return cgx_fwi_link_change(cgx, lmac_id, enable);
+}
+
 int cgx_lmac_linkup_start(void *cgxd)
 {
 	struct cgx *cgx = cgxd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index a34f45367d82..f62d033a511d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -163,6 +163,7 @@ int cgx_lmac_get_pause_frm(void *cgxd, int lmac_id,
 int cgx_lmac_set_pause_frm(void *cgxd, int lmac_id,
 			   u8 tx_pause, u8 rx_pause);
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
+int cgx_set_link_state(void *cgxd, int lmac_id, bool enable);
 u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 int cgx_set_fec(u64 fec, int cgx_id, int lmac_id);
 int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 260c48ba2c98..fb895ace2b0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -162,6 +162,8 @@ M(CGX_MAC_ADDR_DEL,	0x212, cgx_mac_addr_del, cgx_mac_addr_del_req,    \
 			       msg_rsp)		\
 M(CGX_MAC_MAX_ENTRIES_GET, 0x213, cgx_mac_max_entries_get, msg_req,    \
 				  cgx_max_dmac_entries_get_rsp)		\
+M(CGX_SET_LINK_STATE,	0x214, cgx_set_link_state,    \
+				cgx_set_link_state_msg, msg_rsp)	\
 M(CGX_FEC_STATS,	0x217, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
 M(CGX_SET_LINK_MODE,	0x218, cgx_set_link_mode, cgx_set_link_mode_req,\
 			       cgx_set_link_mode_rsp)	\
@@ -713,6 +715,11 @@ struct npc_set_pkind {
 	u8 shift_dir; /* shift direction to get length of the header at var_len_off */
 };
 
+struct cgx_set_link_state_msg {
+	struct mbox_msghdr hdr;
+	u8 enable; /* '1' for link up, '0' for link down */
+};
+
 /* NPA mbox message formats */
 
 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index b603fcb8673f..60c77db3ba6d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -1137,6 +1137,30 @@ int rvu_mbox_handler_cgx_set_fec_param(struct rvu *rvu,
 	return 0;
 }
 
+int rvu_mbox_handler_cgx_set_link_state(struct rvu *rvu,
+					struct cgx_set_link_state_msg *req,
+					struct msg_rsp *rsp)
+{
+	u16 pcifunc = req->hdr.pcifunc;
+	u8 cgx_id, lmac_id;
+	int pf, err;
+
+	pf = rvu_get_pf(pcifunc);
+
+	if (!is_cgx_config_permitted(rvu, pcifunc))
+		return LMAC_AF_ERR_PERM_DENIED;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	err = cgx_set_link_state(rvu_cgx_pdata(cgx_id, rvu), lmac_id,
+				 !!req->enable);
+	if (err)
+		dev_warn(rvu->dev, "Cannot set link state to %s, err %d\n",
+			 (req->enable) ? "enable" : "disable", err);
+
+	return err;
+}
+
 int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
 					   struct cgx_fw_data *rsp)
 {
-- 
2.17.1

