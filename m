Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36493953EF
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 04:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhEaCku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 22:40:50 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:6082 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhEaCkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 22:40:47 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FtfYj0Y8JzYpnc;
        Mon, 31 May 2021 10:36:25 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:07 +0800
Received: from localhost.localdomain (10.69.192.56) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 31 May 2021 10:39:01 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@huawei.com>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 3/8] net: hns3: remove unnecessary updating port based VLAN
Date:   Mon, 31 May 2021 10:38:40 +0800
Message-ID: <1622428725-30049-4-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
References: <1622428725-30049-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

For the PF have called hclge_update_port_base_vlan_cfg() already
before notify VF, it's unnecessary to update port based VLAN again
when received mailbox request from VF.

Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
index 16b42ce..3f7d1f2 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c
@@ -360,15 +360,6 @@ static int hclge_set_vf_vlan_cfg(struct hclge_vport *vport,
 		bool en = msg_cmd->is_kill ? true : false;
 
 		status = hclge_en_hw_strip_rxvtag(handle, en);
-	} else if (msg_cmd->subcode == HCLGE_MBX_PORT_BASE_VLAN_CFG) {
-		struct hclge_vlan_info *vlan_info;
-		u16 *state;
-
-		state = (u16 *)&mbx_req->msg.data[HCLGE_MBX_VLAN_STATE_OFFSET];
-		vlan_info = (struct hclge_vlan_info *)
-			&mbx_req->msg.data[HCLGE_MBX_VLAN_INFO_OFFSET];
-		status = hclge_update_port_base_vlan_cfg(vport, *state,
-							 vlan_info);
 	} else if (msg_cmd->subcode == HCLGE_MBX_GET_PORT_BASE_VLAN_STATE) {
 		struct hnae3_ae_dev *ae_dev = pci_get_drvdata(vport->nic.pdev);
 		/* vf does not need to know about the port based VLAN state
-- 
2.7.4

