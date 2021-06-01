Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0401397425
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234198AbhFAN2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:28:25 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:3368 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233998AbhFAN2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 09:28:10 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4FvXrz3LHDz67Y8;
        Tue,  1 Jun 2021 21:22:43 +0800 (CST)
Received: from dggemi759-chm.china.huawei.com (10.1.198.145) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:26 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggemi759-chm.china.huawei.com (10.1.198.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 1 Jun 2021 21:26:26 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <xie.he.0141@gmail.com>,
        <ms@dev.tdt.de>, <willemb@google.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <tanhuazhong@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH net-next 6/7] net: hdlc: move out assignment in if condition
Date:   Tue, 1 Jun 2021 21:23:21 +0800
Message-ID: <1622553802-19903-7-git-send-email-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1622553802-19903-1-git-send-email-huangguangbin2@huawei.com>
References: <1622553802-19903-1-git-send-email-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggemi759-chm.china.huawei.com (10.1.198.145)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Peng Li <lipeng321@huawei.com>

Should not use assignment in if condition.

Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/wan/hdlc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wan/hdlc.c b/drivers/net/wan/hdlc.c
index fefc732..f48d70e 100644
--- a/drivers/net/wan/hdlc.c
+++ b/drivers/net/wan/hdlc.c
@@ -212,7 +212,8 @@ int hdlc_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	/* Not handled by currently attached protocol (if any) */
 
 	while (proto) {
-		if ((result = proto->ioctl(dev, ifr)) != -EINVAL)
+		result = proto->ioctl(dev, ifr);
+		if (result != -EINVAL)
 			return result;
 		proto = proto->next;
 	}
@@ -363,7 +364,8 @@ static int __init hdlc_module_init(void)
 	int result;
 
 	pr_info("%s\n", version);
-	if ((result = register_netdevice_notifier(&hdlc_notifier)) != 0)
+	result = register_netdevice_notifier(&hdlc_notifier);
+	if (result)
 		return result;
 	dev_add_pack(&hdlc_packet_type);
 	return 0;
-- 
2.8.1

