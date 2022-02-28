Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 480BF4C7984
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 21:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230064AbiB1UIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 15:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbiB1UI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 15:08:29 -0500
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A55AC5EDF8
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 12:07:43 -0800 (PST)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SB9h9U013917;
        Mon, 28 Feb 2022 12:07:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CgIar8iD/MuDlCqa9COaz6vB2SRPoBSbBe3vkuaQuJg=;
 b=DHbXRrDwOiwvbvaInYSEp1famkVqWVtc6CaSi3zqaSwQbVXFLZS9vaxjmb/2ioIfHKwS
 awOzXMPrRdp0P/Fktg2TyMQ1M+0E75nKgcReug8vSAujLnxnyO4jKLpjTxlMz12/SoBW
 O6+0291f/Y3NMUj9miK5vk+mr5XxW2hhdl7Mi0+sj2OUv17Orz3aqbncDtKwbPb+U+LZ
 t+XmLsmczj7YYUpsdQVSDJviPO9G4XECPdCeQPTdD6GVXbqwWOc1ZQx9c0rL/m7uO/hP
 phR7GmWSuwuPsO72c7iEEVwOjzdvoQxsZwwd12e9QRB2vseB+nPNhHXUsjbRTMiDZzDy Xw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3egn96utnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 12:07:35 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 28 Feb
 2022 12:07:33 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 28 Feb 2022 12:07:33 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id B0D6B3F704C;
        Mon, 28 Feb 2022 12:07:33 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 21SK7UDA004353;
        Mon, 28 Feb 2022 12:07:30 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 21SK7Plh004352;
        Mon, 28 Feb 2022 12:07:25 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>, <palok@marvell.com>
Subject: [PATCH net-next 2/2] qed: validate and restrict untrusted VFs vlan promisc mode
Date:   Mon, 28 Feb 2022 12:07:08 -0800
Message-ID: <20220228200708.4312-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220228200708.4312-1-manishc@marvell.com>
References: <20220228200708.4312-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: o_dharzmcqXYQeYCmT24KE7Mc10c2jzG
X-Proofpoint-ORIG-GUID: o_dharzmcqXYQeYCmT24KE7Mc10c2jzG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_09,2022-02-26_01,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Today when VFs are put in promiscuous mode, they can request PF
to configure device for them to receive all VLANs traffic regardless
of what vlan is configured by the PF (via ip link) and PF allows this
config request regardless of whether VF is trusted or not.

From secuirty POV, when VLAN is configured for VF through PF (via ip link),
honour such config requests from VF only when they are configured to be
trusted, otherwise restrict such VFs vlan promisc mode config.

Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 28 +++++++++++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_sriov.h |  1 +
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index c5abfb28cf3f..34f9ad260fe8 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -2984,12 +2984,16 @@ static int qed_iov_pre_update_vport(struct qed_hwfn *hwfn,
 	u8 mask = QED_ACCEPT_UCAST_UNMATCHED | QED_ACCEPT_MCAST_UNMATCHED;
 	struct qed_filter_accept_flags *flags = &params->accept_flags;
 	struct qed_public_vf_info *vf_info;
+	u16 tlv_mask;
+
+	tlv_mask = BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM) | BIT(QED_IOV_VP_UPDATE_ACCEPT_ANY_VLAN);
+
 
 	/* Untrusted VFs can't even be trusted to know that fact.
 	 * Simply indicate everything is configured fine, and trace
 	 * configuration 'behind their back'.
 	 */
-	if (!(*tlvs & BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM)))
+	if (!(*tlvs & tlv_mask))
 		return 0;
 
 	vf_info = qed_iov_get_public_vf_info(hwfn, vfid, true);
@@ -3006,6 +3010,13 @@ static int qed_iov_pre_update_vport(struct qed_hwfn *hwfn,
 			flags->tx_accept_filter &= ~mask;
 	}
 
+	if (params->update_accept_any_vlan_flg) {
+		vf_info->accept_any_vlan = params->accept_any_vlan;
+
+		if (vf_info->forced_vlan && !vf_info->is_trusted_configured)
+			params->accept_any_vlan = false;
+	}
+
 	return 0;
 }
 
@@ -5146,6 +5157,12 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 
 		params.update_ctl_frame_check = 1;
 		params.mac_chk_en = !vf_info->is_trusted_configured;
+		params.update_accept_any_vlan_flg = 0;
+
+		if (vf_info->accept_any_vlan && vf_info->forced_vlan) {
+			params.update_accept_any_vlan_flg = 1;
+			params.accept_any_vlan = vf_info->accept_any_vlan;
+		}
 
 		if (vf_info->rx_accept_mode & mask) {
 			flags->update_rx_mode_config = 1;
@@ -5161,13 +5178,20 @@ static void qed_iov_handle_trust_change(struct qed_hwfn *hwfn)
 		if (!vf_info->is_trusted_configured) {
 			flags->rx_accept_filter &= ~mask;
 			flags->tx_accept_filter &= ~mask;
+			params.accept_any_vlan = false;
 		}
 
 		if (flags->update_rx_mode_config ||
 		    flags->update_tx_mode_config ||
-		    params.update_ctl_frame_check)
+		    params.update_ctl_frame_check ||
+		    params.update_accept_any_vlan_flg) {
+			DP_VERBOSE(hwfn, QED_MSG_IOV,
+				   "vport update config for %s VF[abs 0x%x rel 0x%x]\n",
+				   vf_info->is_trusted_configured ? "trusted" : "untrusted",
+				   vf->abs_vf_id, vf->relative_vf_id);
 			qed_sp_vport_update(hwfn, &params,
 					    QED_SPQ_MODE_EBLOCK, NULL);
+		}
 	}
 }
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.h b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
index f448e3dd6c8b..6ee2493de164 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.h
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.h
@@ -62,6 +62,7 @@ struct qed_public_vf_info {
 	bool is_trusted_request;
 	u8 rx_accept_mode;
 	u8 tx_accept_mode;
+	bool accept_any_vlan;
 };
 
 struct qed_iov_vf_init_params {
-- 
2.35.1.273.ge6ebfd0

