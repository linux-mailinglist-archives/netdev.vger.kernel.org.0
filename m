Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1062A3C5DB3
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 15:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbhGLNw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 09:52:27 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:14070 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhGLNw0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 09:52:26 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4GNlRH37M7zYrMm;
        Mon, 12 Jul 2021 21:46:19 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 12 Jul 2021 21:49:35 +0800
Received: from localhost (10.174.179.215) by dggema769-chm.china.huawei.com
 (10.1.198.211) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Mon, 12
 Jul 2021 21:49:34 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <alex.aring@gmail.com>, <stefan@datenfreihafen.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <marcel@holtmann.org>
CC:     <linux-wpan@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] nl802154: Fix type check in nl802154_new_interface()
Date:   Mon, 12 Jul 2021 21:44:30 +0800
Message-ID: <20210712134430.19372-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.179.215]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggema769-chm.china.huawei.com (10.1.198.211)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We got this UBSAN warning:

UBSAN: shift-out-of-bounds in net/ieee802154/nl802154.c:920:44
shift exponent -1 is negative
CPU: 3 PID: 8258 Comm: repro Not tainted 5.13.0+ #222
Call Trace:
 dump_stack_lvl+0x8d/0xcf
 ubsan_epilogue+0xa/0x4e
 __ubsan_handle_shift_out_of_bounds+0x161/0x182
 nl802154_new_interface+0x3bf/0x3d0
 genl_family_rcv_msg_doit.isra.15+0x12d/0x170
 genl_rcv_msg+0x11a/0x240
 netlink_rcv_skb+0x69/0x160
 genl_rcv+0x24/0x40

NL802154_IFTYPE_UNSPEC is -1, so enum nl802154_iftype type now
is a signed integer, which is assigned by nla_get_u32 in
nl802154_new_interface(), this may cause type is negative and trigger
this warning.

Fixes: 65318680c97c ("ieee802154: add iftypes capability")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/ieee802154/nl802154.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ieee802154/nl802154.c b/net/ieee802154/nl802154.c
index 0cf2374..aab7ed4 100644
--- a/net/ieee802154/nl802154.c
+++ b/net/ieee802154/nl802154.c
@@ -915,7 +915,9 @@ static int nl802154_new_interface(struct sk_buff *skb, struct genl_info *info)
 
 	if (info->attrs[NL802154_ATTR_IFTYPE]) {
 		type = nla_get_u32(info->attrs[NL802154_ATTR_IFTYPE]);
-		if (type > NL802154_IFTYPE_MAX ||
+		if (type < NL802154_IFTYPE_UNSPEC || type > NL802154_IFTYPE_MAX)
+			return -EINVAL;
+		if (type != NL802154_IFTYPE_UNSPEC &&
 		    !(rdev->wpan_phy.supported.iftypes & BIT(type)))
 			return -EINVAL;
 	}
-- 
1.8.3.1

