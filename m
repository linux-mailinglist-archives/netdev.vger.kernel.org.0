Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D85C316041
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 08:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232894AbhBJHqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 02:46:00 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:13335 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232847AbhBJHph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 02:45:37 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4DbBZ02LwKz7jYT;
        Wed, 10 Feb 2021 15:42:48 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.498.0; Wed, 10 Feb 2021 15:44:02 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <salil.mehta@huawei.com>,
        <yisen.zhuang@huawei.com>, <huangdaode@huawei.com>,
        <linuxarm@openeuler.org>, Jiaran Zhang <zhangjiaran@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>
Subject: [PATCH net-next 04/13] net: hns3: use ipv6_addr_any() helper
Date:   Wed, 10 Feb 2021 15:43:16 +0800
Message-ID: <1612943005-59416-5-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
References: <1612943005-59416-1-git-send-email-tanhuazhong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

Use common ipv6_addr_any() to determine if an addr is ipv6 any addr.

Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 64a80a5..e2c5b8f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -13,6 +13,7 @@
 #include <linux/platform_device.h>
 #include <linux/if_vlan.h>
 #include <linux/crash_dump.h>
+#include <net/ipv6.h>
 #include <net/rtnetlink.h>
 #include "hclge_cmd.h"
 #include "hclge_dcb.h"
@@ -5508,12 +5509,10 @@ static int hclge_fd_check_tcpip6_tuple(struct ethtool_tcpip6_spec *spec,
 		BIT(INNER_IP_TOS);
 
 	/* check whether src/dst ip address used */
-	if (!spec->ip6src[0] && !spec->ip6src[1] &&
-	    !spec->ip6src[2] && !spec->ip6src[3])
+	if (ipv6_addr_any((struct in6_addr *)spec->ip6src))
 		*unused_tuple |= BIT(INNER_SRC_IP);
 
-	if (!spec->ip6dst[0] && !spec->ip6dst[1] &&
-	    !spec->ip6dst[2] && !spec->ip6dst[3])
+	if (ipv6_addr_any((struct in6_addr *)spec->ip6dst))
 		*unused_tuple |= BIT(INNER_DST_IP);
 
 	if (!spec->psrc)
@@ -5538,12 +5537,10 @@ static int hclge_fd_check_ip6_tuple(struct ethtool_usrip6_spec *spec,
 		BIT(INNER_IP_TOS) | BIT(INNER_SRC_PORT) | BIT(INNER_DST_PORT);
 
 	/* check whether src/dst ip address used */
-	if (!spec->ip6src[0] && !spec->ip6src[1] &&
-	    !spec->ip6src[2] && !spec->ip6src[3])
+	if (ipv6_addr_any((struct in6_addr *)spec->ip6src))
 		*unused_tuple |= BIT(INNER_SRC_IP);
 
-	if (!spec->ip6dst[0] && !spec->ip6dst[1] &&
-	    !spec->ip6dst[2] && !spec->ip6dst[3])
+	if (ipv6_addr_any((struct in6_addr *)spec->ip6dst))
 		*unused_tuple |= BIT(INNER_DST_IP);
 
 	if (!spec->l4_proto)
-- 
2.7.4

