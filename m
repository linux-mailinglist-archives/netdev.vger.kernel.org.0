Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10D84D8945
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 09:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733106AbfJPHUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 03:20:14 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4172 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732849AbfJPHUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 03:20:13 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id A416E9EEC4C24B7F4C5D;
        Wed, 16 Oct 2019 15:20:08 +0800 (CST)
Received: from localhost.localdomain (10.67.212.132) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Wed, 16 Oct 2019 15:20:00 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <salil.mehta@huawei.com>, <yisen.zhuang@huawei.com>,
        <linuxarm@huawei.com>, <jakub.kicinski@netronome.com>,
        Jian Shen <shenjian15@huawei.com>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net-next 10/12] net: hns3: fix VF id issue for setting VF VLAN
Date:   Wed, 16 Oct 2019 15:17:09 +0800
Message-ID: <1571210231-29154-11-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
References: <1571210231-29154-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.212.132]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Previously, when set VF VLAN with command "ip link set <pf name>
vf <vf id> vlan <vlan id>", the vf id 0 is handled as PF incorrectly,
which should be the first VF. This patch fixes it.

This patch also adds VF VLAN information for command "ip link show".

Fixes: 21e043cd8124 ("net: hns3: fix set port based VLAN for PF")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 72c19b3..60aba81 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -2940,6 +2940,9 @@ static int hclge_get_vf_config(struct hnae3_handle *handle, int vf,
 	ivf->trusted = vport->vf_info.trusted;
 	ivf->min_tx_rate = 0;
 	ivf->max_tx_rate = vport->vf_info.max_tx_rate;
+	ivf->vlan = vport->port_base_vlan_cfg.vlan_info.vlan_tag;
+	ivf->vlan_proto = htons(vport->port_base_vlan_cfg.vlan_info.vlan_proto);
+	ivf->qos = vport->port_base_vlan_cfg.vlan_info.qos;
 	ether_addr_copy(ivf->mac, vport->vf_info.mac);
 
 	return 0;
@@ -8407,13 +8410,16 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
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
@@ -8424,21 +8430,12 @@ static int hclge_set_vf_vlan_filter(struct hnae3_handle *handle, int vfid,
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

