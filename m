Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1E52CEA1B
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgLDIqH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:46:07 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:9013 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgLDIqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:46:07 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CnR9452ZRzhmN3;
        Fri,  4 Dec 2020 16:44:56 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 16:45:16 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: bridge: vlan: fix error return code in __vlan_add()
Date:   Fri, 4 Dec 2020 16:48:56 +0800
Message-ID: <1607071737-33875-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: f8ed289fab84 ("bridge: vlan: use br_vlan_(get|put)_master to deal with refcounts")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 net/bridge/br_vlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_vlan.c b/net/bridge/br_vlan.c
index 3e493eb..08c7741 100644
--- a/net/bridge/br_vlan.c
+++ b/net/bridge/br_vlan.c
@@ -266,8 +266,10 @@ static int __vlan_add(struct net_bridge_vlan *v, u16 flags,
 		}
 
 		masterv = br_vlan_get_master(br, v->vid, extack);
-		if (!masterv)
+		if (!masterv) {
+			err = -ENOMEM;
 			goto out_filt;
+		}
 		v->brvlan = masterv;
 		if (br_opt_get(br, BROPT_VLAN_STATS_PER_PORT)) {
 			v->stats = netdev_alloc_pcpu_stats(struct br_vlan_stats);
-- 
2.9.5

