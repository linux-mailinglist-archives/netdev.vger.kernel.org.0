Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E99B02CED37
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 12:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388133AbgLDLiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 06:38:22 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8666 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgLDLiV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 06:38:21 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CnVzp0dmWz15Vtb;
        Fri,  4 Dec 2020 19:37:10 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Fri, 4 Dec 2020
 19:37:35 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <pshelar@ovn.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <echaudro@redhat.com>
CC:     <dev@openvswitch.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] openvswitch: fix error return code in validate_and_copy_dec_ttl()
Date:   Fri, 4 Dec 2020 19:43:14 +0800
Message-ID: <20201204114314.1596-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Changing 'return start' to 'return action_start' can fix this bug.

Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action netlink message format")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/openvswitch/flow_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index ec0689ddc635..4c5c2331e764 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2531,7 +2531,7 @@ static int validate_and_copy_dec_ttl(struct net *net,
 
 	action_start = add_nested_action_start(sfa, OVS_DEC_TTL_ATTR_ACTION, log);
 	if (action_start < 0)
-		return start;
+		return action_start;
 
 	err = __ovs_nla_copy_actions(net, actions, key, sfa, eth_type,
 				     vlan_tci, mpls_label_count, log);
-- 
2.17.1

