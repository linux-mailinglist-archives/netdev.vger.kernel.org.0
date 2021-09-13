Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F7D4408C26
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 15:12:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239125AbhIMNN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 09:13:59 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:9424 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236725AbhIMNNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Sep 2021 09:13:50 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4H7Rc373w6z8yVZ;
        Mon, 13 Sep 2021 21:08:03 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:28 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 21:12:28 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>
Subject: [PATCH net 2/6] net: hns3: pad the short tunnel frame before sending to hardware
Date:   Mon, 13 Sep 2021 21:08:21 +0800
Message-ID: <20210913130825.27025-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913130825.27025-1-huangguangbin2@huawei.com>
References: <20210913130825.27025-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yufeng Mo <moyufeng@huawei.com>

The hardware cannot handle short tunnel frames below 65 bytes,
and will cause vlan tag missing problem. So pads packet size to
65 bytes for tunnel frames to fix this bug.

Fixes: 3db084d28dc0("net: hns3: Fix for vxlan tx checksum bug")
Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 293243bbe407..adc54a726661 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -76,6 +76,7 @@ module_param(page_pool_enabled, bool, 0400);
 #define HNS3_OUTER_VLAN_TAG	2
 
 #define HNS3_MIN_TX_LEN		33U
+#define HNS3_MIN_TUN_PKT_LEN	65U
 
 /* hns3_pci_tbl - PCI Device ID Table
  *
@@ -1427,8 +1428,11 @@ static int hns3_set_l2l3l4(struct sk_buff *skb, u8 ol4_proto,
 			       l4.tcp->doff);
 		break;
 	case IPPROTO_UDP:
-		if (hns3_tunnel_csum_bug(skb))
-			return skb_checksum_help(skb);
+		if (hns3_tunnel_csum_bug(skb)) {
+			int ret = skb_put_padto(skb, HNS3_MIN_TUN_PKT_LEN);
+
+			return ret ? ret : skb_checksum_help(skb);
+		}
 
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4CS_B, 1);
 		hns3_set_field(*type_cs_vlan_tso, HNS3_TXD_L4T_S,
-- 
2.33.0

