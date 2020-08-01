Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EABD23515F
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 11:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728752AbgHAJMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 05:12:18 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:57224 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbgHAJMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 05:12:17 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id EC0A77F7772C3C6221A6;
        Sat,  1 Aug 2020 17:12:13 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.487.0; Sat, 1 Aug 2020
 17:12:06 +0800
From:   linmiaohe <linmiaohe@huawei.com>
To:     <aelior@marvell.com>, <GR-everest-linux-l2@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linmiaohe@huawei.com>
Subject: [PATCH] net: qed: use eth_zero_addr() to clear mac address
Date:   Sat, 1 Aug 2020 17:14:41 +0800
Message-ID: <1596273281-24277-1-git-send-email-linmiaohe@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

Use eth_zero_addr() to clear mac address instead of memset().

Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
---
 drivers/net/ethernet/qlogic/qed/qed_sriov.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_sriov.c b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
index 20679fd4204b..5015890a2a59 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_sriov.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_sriov.c
@@ -5067,8 +5067,7 @@ static void qed_update_mac_for_vf_trust_change(struct qed_hwfn *hwfn, int vf_id)
 			for (i = 0; i < QED_ETH_VF_NUM_MAC_FILTERS; i++) {
 				if (ether_addr_equal(vf->shadow_config.macs[i],
 						     vf_info->mac)) {
-					memset(vf->shadow_config.macs[i], 0,
-					       ETH_ALEN);
+					eth_zero_addr(vf->shadow_config.macs[i]);
 					DP_VERBOSE(hwfn, QED_MSG_IOV,
 						   "Shadow MAC %pM removed for VF 0x%02x, VF trust mode is ON\n",
 						    vf_info->mac, vf_id);
@@ -5077,7 +5076,7 @@ static void qed_update_mac_for_vf_trust_change(struct qed_hwfn *hwfn, int vf_id)
 			}
 
 			ether_addr_copy(vf_info->mac, force_mac);
-			memset(vf_info->forced_mac, 0, ETH_ALEN);
+			eth_zero_addr(vf_info->forced_mac);
 			vf->bulletin.p_virt->valid_bitmap &=
 					~BIT(MAC_ADDR_FORCED);
 			qed_schedule_iov(hwfn, QED_IOV_WQ_BULLETIN_UPDATE_FLAG);
@@ -5088,7 +5087,7 @@ static void qed_update_mac_for_vf_trust_change(struct qed_hwfn *hwfn, int vf_id)
 	if (!vf_info->is_trusted_configured) {
 		u8 empty_mac[ETH_ALEN];
 
-		memset(empty_mac, 0, ETH_ALEN);
+		eth_zero_addr(empty_mac);
 		for (i = 0; i < QED_ETH_VF_NUM_MAC_FILTERS; i++) {
 			if (ether_addr_equal(vf->shadow_config.macs[i],
 					     empty_mac)) {
-- 
2.19.1

