Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F43E39F79C
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 15:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhFHNVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 09:21:02 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:5293 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhFHNVA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 09:21:00 -0400
Received: from dggeme766-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4FzrKy0ypxz1BJjF;
        Tue,  8 Jun 2021 21:14:14 +0800 (CST)
Received: from huawei.com (10.175.113.133) by dggeme766-chm.china.huawei.com
 (10.3.19.112) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Tue, 8 Jun
 2021 21:19:04 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <shshaikh@marvell.com>, <manishc@marvell.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <GR-Linux-NIC-Dev@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net-next] ethernet/qlogic: Use list_for_each_entry() to simplify code in qlcnic_hw.c
Date:   Tue, 8 Jun 2021 13:29:08 +0000
Message-ID: <20210608132908.68891-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggeme766-chm.china.huawei.com (10.3.19.112)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert list_for_each() to list_for_each_entry() where
applicable. This simplifies the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
index e1b8490bed0a..4b8bc46f55c2 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_hw.c
@@ -460,12 +460,10 @@ int qlcnic_82xx_sre_macaddr_change(struct qlcnic_adapter *adapter, u8 *addr,
 int qlcnic_nic_del_mac(struct qlcnic_adapter *adapter, const u8 *addr)
 {
 	struct qlcnic_mac_vlan_list *cur;
-	struct list_head *head;
 	int err = -EINVAL;
 
 	/* Delete MAC from the existing list */
-	list_for_each(head, &adapter->mac_list) {
-		cur = list_entry(head, struct qlcnic_mac_vlan_list, list);
+	list_for_each_entry(cur, &adapter->mac_list, list) {
 		if (ether_addr_equal(addr, cur->mac_addr)) {
 			err = qlcnic_sre_macaddr_change(adapter, cur->mac_addr,
 							0, QLCNIC_MAC_DEL);
@@ -483,11 +481,9 @@ int qlcnic_nic_add_mac(struct qlcnic_adapter *adapter, const u8 *addr, u16 vlan,
 		       enum qlcnic_mac_type mac_type)
 {
 	struct qlcnic_mac_vlan_list *cur;
-	struct list_head *head;
 
 	/* look up if already exists */
-	list_for_each(head, &adapter->mac_list) {
-		cur = list_entry(head, struct qlcnic_mac_vlan_list, list);
+	list_for_each_entry(cur, &adapter->mac_list, list) {
 		if (ether_addr_equal(addr, cur->mac_addr) &&
 		    cur->vlan_id == vlan)
 			return 0;
-- 
2.17.1

