Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B830B2B19BA
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 12:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgKMLNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 06:13:37 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:7229 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726309AbgKMLN2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 06:13:28 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CXbRn0gyXzkgfJ;
        Fri, 13 Nov 2020 19:13:09 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Fri, 13 Nov 2020
 19:13:21 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <kuba@kernel.org>
CC:     <jiri@nvidia.com>, <davem@davemloft.net>, <idosch@mellanox.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 net] devlink: Add missing genlmsg_cancel() in devlink_nl_sb_port_pool_fill()
Date:   Fri, 13 Nov 2020 19:16:22 +0800
Message-ID: <20201113111622.11040-1-wanghai38@huawei.com>
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
v1->v2: use goto instead of direct return
 net/core/devlink.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/devlink.c b/net/core/devlink.c
index a932d95be798..be8ee96ad188 100644
--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -1448,7 +1448,7 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
 		err = ops->sb_occ_port_pool_get(devlink_port, devlink_sb->index,
 						pool_index, &cur, &max);
 		if (err && err != -EOPNOTSUPP)
-			return err;
+			goto sb_occ_get_failure;
 		if (!err) {
 			if (nla_put_u32(msg, DEVLINK_ATTR_SB_OCC_CUR, cur))
 				goto nla_put_failure;
@@ -1461,8 +1461,10 @@ static int devlink_nl_sb_port_pool_fill(struct sk_buff *msg,
 	return 0;
 
 nla_put_failure:
+	err = -EMSGSIZE;
+sb_occ_get_failure:
 	genlmsg_cancel(msg, hdr);
-	return -EMSGSIZE;
+	return err;
 }
 
 static int devlink_nl_cmd_sb_port_pool_get_doit(struct sk_buff *skb,
-- 
2.17.1

