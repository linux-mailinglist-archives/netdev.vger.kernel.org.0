Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4CA644C265
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 14:49:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbhKJNuV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 08:50:21 -0500
Received: from szxga01-in.huawei.com ([45.249.212.187]:14736 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232048AbhKJNuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 08:50:16 -0500
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hq5h84yr8zZcf9;
        Wed, 10 Nov 2021 21:45:12 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 10 Nov 2021 21:47:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 7/8] net: hns3: remove check VF uc mac exist when set by PF
Date:   Wed, 10 Nov 2021 21:42:55 +0800
Message-ID: <20211110134256.25025-8-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211110134256.25025-1-huangguangbin2@huawei.com>
References: <20211110134256.25025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If users set unicast mac address for VFs by PF, they need to guarantee all
VFs' address is different. This patch removes the check mac address exist
of VFs, for usrs can refresh mac addresses of all VFs directly without
need to modify the exist mac address to other value firstly.

Fixes: 8e6de441b8e6 ("net: hns3: add support for configuring VF MAC from the host")
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_main.c        | 36 -------------------
 1 file changed, 36 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index de9cadf9b9f3..c2a58101144e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -9418,36 +9418,6 @@ static int hclge_get_mac_ethertype_cmd_status(struct hclge_dev *hdev,
 	return return_status;
 }
 
-static bool hclge_check_vf_mac_exist(struct hclge_vport *vport, int vf_idx,
-				     u8 *mac_addr)
-{
-	struct hclge_mac_vlan_tbl_entry_cmd req;
-	struct hclge_dev *hdev = vport->back;
-	struct hclge_desc desc;
-	u16 egress_port = 0;
-	int i;
-
-	if (is_zero_ether_addr(mac_addr))
-		return false;
-
-	memset(&req, 0, sizeof(req));
-	hnae3_set_field(egress_port, HCLGE_MAC_EPORT_VFID_M,
-			HCLGE_MAC_EPORT_VFID_S, vport->vport_id);
-	req.egress_port = cpu_to_le16(egress_port);
-	hclge_prepare_mac_addr(&req, mac_addr, false);
-
-	if (hclge_lookup_mac_vlan_tbl(vport, &req, &desc, false) != -ENOENT)
-		return true;
-
-	vf_idx += HCLGE_VF_VPORT_START_NUM;
-	for (i = HCLGE_VF_VPORT_START_NUM; i < hdev->num_alloc_vport; i++)
-		if (i != vf_idx &&
-		    ether_addr_equal(mac_addr, hdev->vport[i].vf_info.mac))
-			return true;
-
-	return false;
-}
-
 static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 			    u8 *mac_addr)
 {
@@ -9465,12 +9435,6 @@ static int hclge_set_vf_mac(struct hnae3_handle *handle, int vf,
 		return 0;
 	}
 
-	if (hclge_check_vf_mac_exist(vport, vf, mac_addr)) {
-		dev_err(&hdev->pdev->dev, "Specified MAC(=%pM) exists!\n",
-			mac_addr);
-		return -EEXIST;
-	}
-
 	ether_addr_copy(vport->vf_info.mac, mac_addr);
 
 	if (test_bit(HCLGE_VPORT_STATE_ALIVE, &vport->state)) {
-- 
2.33.0

