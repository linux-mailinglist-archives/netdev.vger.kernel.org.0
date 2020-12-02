Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24432CB9D1
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 10:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388361AbgLBJzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 04:55:45 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8557 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387880AbgLBJzp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 04:55:45 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CmDpP1FgnzhkcG;
        Wed,  2 Dec 2020 17:54:37 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Wed, 2 Dec 2020 17:54:59 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <ap420073@gmail.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] vxlan: fix error return code in __vxlan_dev_create()
Date:   Wed, 2 Dec 2020 17:58:42 +0800
Message-ID: <1606903122-2098-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/vxlan.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index 1a557ae..a506872 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -3877,8 +3877,10 @@ static int __vxlan_dev_create(struct net *net, struct net_device *dev,
 
 	if (dst->remote_ifindex) {
 		remote_dev = __dev_get_by_index(net, dst->remote_ifindex);
-		if (!remote_dev)
+		if (!remote_dev) {
+			err = -ENODEV;
 			goto errout;
+		}
 
 		err = netdev_upper_dev_link(remote_dev, dev, extack);
 		if (err)
-- 
2.9.5

