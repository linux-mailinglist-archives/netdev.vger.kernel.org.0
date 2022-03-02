Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9CC4CA28C
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 11:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241194AbiCBKyV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 05:54:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241160AbiCBKyT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 05:54:19 -0500
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DACDC43385;
        Wed,  2 Mar 2022 02:53:07 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2225aKIA005813;
        Wed, 2 Mar 2022 02:53:06 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=CIPDx3KIDn7vamQLNJInS6FarWu9GmTshTbEoirn/Ug=;
 b=hO9cpD0PJxIQnHO4c5Lvs4RfTJvE07GDevLSaLz29C3+RNMWxtA0qpVzWFwa2vDt9TkY
 D/ozWz4Ru+4WDWUBvjv6wqrclPHFnkuVv4nEuee/1pFwTMUnnMWphPE2nj41payQTock
 6PZai5XturLKLP7hYUuusr2xKEE39vS2xO+cTZim9m+Qp81m4H9A+l1eaFYAnzNryQrQ
 +3JE7kmsaXpDSM0ydLslT/eYbxjn3oFbZznsB/bm1daWIOFx99Cz6+E+YSyaD2YFnOBW
 MS7mvh3pBMCQIlvY7c+qaMW8MmhL4GdyXxaH/u9K+a2CWgPg4KQuggBegEUjQiPsiBiK 7g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3ej2k496kh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 02 Mar 2022 02:53:06 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 2 Mar
 2022 02:53:04 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 2 Mar 2022 02:53:04 -0800
Received: from dut1171.mv.qlogic.com (unknown [10.112.88.18])
        by maili.marvell.com (Postfix) with ESMTP id 92CCF67387;
        Wed,  2 Mar 2022 02:53:04 -0800 (PST)
Received: from dut1171.mv.qlogic.com (localhost [127.0.0.1])
        by dut1171.mv.qlogic.com (8.14.7/8.14.7) with ESMTP id 222Aqsuv008250;
        Wed, 2 Mar 2022 02:52:59 -0800
Received: (from root@localhost)
        by dut1171.mv.qlogic.com (8.14.7/8.14.7/Submit) id 222Aqitv008241;
        Wed, 2 Mar 2022 02:52:44 -0800
From:   Manish Chopra <manishc@marvell.com>
To:     <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <aelior@marvell.com>,
        <palok@marvell.com>, <stable@vger.kernel.org>
Subject: [PATCH v2 net-next 2/2] qed: validate and restrict untrusted VFs vlan promisc mode
Date:   Wed, 2 Mar 2022 02:52:22 -0800
Message-ID: <20220302105222.8201-2-manishc@marvell.com>
X-Mailer: git-send-email 2.12.0
In-Reply-To: <20220302105222.8201-1-manishc@marvell.com>
References: <20220302105222.8201-1-manishc@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: CbDQclJEjNw0hdhsKE3pvMH7g6eTxJV_
X-Proofpoint-GUID: CbDQclJEjNw0hdhsKE3pvMH7g6eTxJV_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-02_01,2022-02-26_01,2022-02-23_01
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

From security POV, when VLAN is configured for VF through PF (via ip link),
honour such config requests from VF only when they are configured to be
trusted, otherwise restrict such VFs vlan promisc mode config.

Cc: stable@vger.kernel.org
Fixes: f990c82c385b ("qed*: Add support for ndo_set_vf_trust")
Signed-off-by: Manish Chopra <manishc@marvell.com>
Signed-off-by: Ariel Elior <aelior@marvell.com>
---

v1->v2:
--------

* Add Cc and Fixes tags for stable inclusion
* Cosmetic changes pointed by Jakub in v1

 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 28 +++++++++++++++++++--
 drivers/net/ethernet/qlogic/qed/qed_sriov.h |  1 +
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index c5abfb28cf3f..bf4a95186e55 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -2984,12 +2984,16 @@ static int qed_iov_pre_update_vport(struct qed_hwfn *hwfn,
 	u8 mask = QED_ACCEPT_UCAST_UNMATCHED | QED_ACCEPT_MCAST_UNMATCHED;
 	struct qed_filter_accept_flags *flags = &params->accept_flags;
 	struct qed_public_vf_info *vf_info;
+	u16 tlv_mask;
+
+	tlv_mask = BIT(QED_IOV_VP_UPDATE_ACCEPT_PARAM) |
+		   BIT(QED_IOV_VP_UPDATE_ACCEPT_ANY_VLAN);

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

