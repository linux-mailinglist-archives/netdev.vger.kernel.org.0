Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A65F326C1A
	for <lists+netdev@lfdr.de>; Sat, 27 Feb 2021 08:26:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbhB0HZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Feb 2021 02:25:06 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12651 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229946AbhB0HZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Feb 2021 02:25:00 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DndJN1gMCzlQ9j;
        Sat, 27 Feb 2021 15:22:12 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Sat, 27 Feb 2021 15:24:10 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jian Shen <shenjian15@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [RESEND net 2/3] net: hns3: fix query vlan mask value error for flow director
Date:   Sat, 27 Feb 2021 15:24:52 +0800
Message-ID: <1614410693-8107-3-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
References: <1614410693-8107-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Shen <shenjian15@huawei.com>

Currently, the driver returns VLAN_VID_MASK for vlan mask field,
when get flow director rule information for rule doesn't use vlan.
It may cause the vlan mask value display as 0xf000 in this
case, like below:

estuary:/$ ethtool -u eth1
50 RX rings available
Total 1 rules

Filter: 2
Rule Type: TCP over IPv4
Src IP addr: 0.0.0.0 mask: 255.255.255.255
Dest IP addr: 0.0.0.0 mask: 255.255.255.255
TOS: 0x0 mask: 0xff
Src port: 0 mask: 0xffff
Dest port: 0 mask: 0xffff
VLAN EtherType: 0x0 mask: 0xffff
VLAN: 0x0 mask: 0xf000
User-defined: 0x1234 mask: 0x0
Action: Direct to queue 3

Fix it by return 0.

Fixes: 05c2314fe6a8 ("net: hns3: Add support for rule query of flow director")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 34b744d..932cfd1 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -6330,8 +6330,7 @@ static void hclge_fd_get_ext_info(struct ethtool_rx_flow_spec *fs,
 		fs->h_ext.vlan_tci = cpu_to_be16(rule->tuples.vlan_tag1);
 		fs->m_ext.vlan_tci =
 				rule->unused_tuple & BIT(INNER_VLAN_TAG_FST) ?
-				cpu_to_be16(VLAN_VID_MASK) :
-				cpu_to_be16(rule->tuples_mask.vlan_tag1);
+				0 : cpu_to_be16(rule->tuples_mask.vlan_tag1);
 	}
 
 	if (fs->flow_type & FLOW_MAC_EXT) {
-- 
2.7.4

