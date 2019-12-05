Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 030A311399B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbfLECMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:12:22 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44892 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728121AbfLECMW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 21:12:22 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BDF575FDA47BD4328101;
        Thu,  5 Dec 2019 10:12:17 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.439.0; Thu, 5 Dec 2019 10:12:09 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Jian Shen <shenjian15@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH V2 net 3/3] net: hns3: fix VF ID issue for setting VF VLAN
Date:   Thu, 5 Dec 2019 10:12:29 +0800
Message-ID: <1575511949-1613-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1575511949-1613-1-git-send-email-tanhuazhong@huawei.com>
References: <1575511949-1613-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, when set VF VLAN with command "ip link set <pf name>
vf <vf id> vlan <vlan id>", the VF ID 0 is handled as PF incorrectly,
which should be the first VF. This patch fixes it.

Fixes: 21e043cd8124 ("net: hns3: fix set port based VLAN for PF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c    | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 7c703867..d862e9b 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -8438,13 +8438,16 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	if (hdev->pdev->revision == 0x20)
 		return -EOPNOTSUPP;
 
+	vport = hclge_get_vf_vport(hdev, vfid);
+	if (!vport)
+		return -EINVAL;
+
 	/* qos is a 3 bits value, so can not be bigger than 7 */
-	if (vfid >= hdev->num_alloc_vfs || vlan > VLAN_N_VID - 1 || qos > 7)
+	if (vlan > VLAN_N_VID - 1 || qos > 7)
 		return -EINVAL;
 	if (proto != htons(ETH_P_8021Q))
 		return -EPROTONOSUPPORT;
 
-	vport = &hdev->vport[vfid];
 	state = hclge_get_port_base_vlan_state(vport,
 					       vport->port_base_vlan_cfg.state,
 					       vlan);
@@ -8455,21 +8458,12 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
 	vlan_info.qos = qos;
 	vlan_info.vlan_proto = ntohs(proto);
 
-	/* update port based VLAN for PF */
-	if (!vfid) {
-		hclge_notify_client(hdev, HNAE3_DOWN_CLIENT);
-		ret = hclge_update_port_base_vlan_cfg(vport, state, &vlan_info);
-		hclge_notify_client(hdev, HNAE3_UP_CLIENT);
-
-		return ret;
-	}
-
 	if (!test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
 		return hclge_update_port_base_vlan_cfg(vport, state,
 						       &vlan_info);
 	} else {
 		ret = hclge_push_vf_port_base_vlan_info(&hdev->vport[0],
-							(u8)vfid, state,
+							vport->vport_id, state,
 							vlan, qos,
 							ntohs(proto));
 		return ret;
-- 
2.7.4

