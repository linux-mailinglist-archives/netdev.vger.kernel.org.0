Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30C132AF2A4
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727248AbgKKNzy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:55:54 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7174 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgKKNzw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:55:52 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CWR8F0KxLz15KFv;
        Wed, 11 Nov 2020 21:55:41 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Nov 2020
 21:55:49 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jiri@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <idosch@mellanox.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
Date:   Wed, 11 Nov 2020 21:58:53 +0800
Message-ID: <20201111135853.63997-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If sb_occ_port_pool_get() failed in devlink_nl_sb_port_pool_fill(),
msg should be canceled by genlmsg_cancel().

Fixes: df38dafd2559 ("devlink: implement shared buffer occupancy monitoring interface")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 net/core/devlink.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a932d95be798..83b4e7f51b35 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1447,8 +1447,10 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
 
 		err = ops->sb_occ_port_pool_get(devlink_port, devlink_sb->index,
 						pool_index, &cur, &max);
-		if (err && err != -EOPNOTSUPP)
+		if (err && err != -EOPNOTSUPP) {
+			genlmsg_cancel(msg, hdr);
 			return err;
+		}
 		if (!err) {
 			if (nla_put_u32(msg, DEVLINK_ATTR_SB_OCC_CUR, cur))
 				goto nla_put_failure;
-- 
2.17.1

