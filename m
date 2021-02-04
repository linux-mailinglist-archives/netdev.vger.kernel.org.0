Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7AD30EF1A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 09:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235045AbhBDI40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 03:56:26 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:12126 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231767AbhBDI4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 03:56:25 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4DWXRL4W9Jz163vC;
        Thu,  4 Feb 2021 16:54:22 +0800 (CST)
Received: from ubuntu.network (10.175.138.68) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Thu, 4 Feb 2021 16:55:33 +0800
From:   Zheng Yongjun <zhengyongjun3@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-decnet-user@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Zheng Yongjun <zhengyongjun3@huawei.com>
Subject: [PATCH net-next] net: Return the correct errno code
Date:   Thu, 4 Feb 2021 16:56:30 +0800
Message-ID: <20210204085630.19452-1-zhengyongjun3@huawei.com>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.138.68]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kzalloc failed, should return ENOMEM rather than ENOBUFS.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
---
 net/decnet/dn_dev.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 15d42353f1a3..50e375dcd5bd 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -469,7 +469,7 @@ int dn_dev_ioctl(unsigned int cmd, void __user *arg)
 	case SIOCSIFADDR:
 		if (!ifa) {
 			if ((ifa = dn_dev_alloc_ifa()) == NULL) {
-				ret = -ENOBUFS;
+				ret = -ENOMEM;
 				break;
 			}
 			memcpy(ifa->ifa_label, dev->name, IFNAMSIZ);
@@ -645,7 +645,7 @@ static int dn_nl_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	if ((ifa = dn_dev_alloc_ifa()) == NULL)
-		return -ENOBUFS;
+		return -ENOMEM;
 
 	if (tb[IFA_ADDRESS] == NULL)
 		tb[IFA_ADDRESS] = tb[IFA_LOCAL];
@@ -1088,7 +1088,7 @@ static struct dn_dev *dn_dev_create(struct net_device *dev, int *err)
 	if (i == DN_DEV_LIST_SIZE)
 		return NULL;
 
-	*err = -ENOBUFS;
+	*err = -ENOMEM;
 	if ((dn_db = kzalloc(sizeof(struct dn_dev), GFP_ATOMIC)) == NULL)
 		return NULL;
 
-- 
2.22.0

