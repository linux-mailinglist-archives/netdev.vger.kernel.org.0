Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A66839D304
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 04:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFGCk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 22:40:26 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:7121 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbhFGCk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 22:40:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4FyyCj4nq3zYrC8;
        Mon,  7 Jun 2021 10:35:45 +0800 (CST)
Received: from dggemi762-chm.china.huawei.com (10.1.198.148) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:38:33 +0800
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 dggemi762-chm.china.huawei.com (10.1.198.148) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 7 Jun 2021 10:38:33 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <kurt@linutronix.de>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <olteanv@gmail.com>, <davem@davemloft.net>,
        <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] net: dsa: hellcreek: Use is_zero_ether_addr() instead of memcmp()
Date:   Mon, 7 Jun 2021 10:57:09 +0800
Message-ID: <1623034629-30384-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggemi762-chm.china.huawei.com (10.1.198.148)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Using is_zero_ether_addr() instead of directly use
memcmp() to determine if the ethernet address is all
zeros.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/net/dsa/hirschmann/hellcreek.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/dsa/hirschmann/hellcreek.c b/drivers/net/dsa/hirschmann/hellcreek.c
index 4d78219..9fdcc4b 100644
--- a/drivers/net/dsa/hirschmann/hellcreek.c
+++ b/drivers/net/dsa/hirschmann/hellcreek.c
@@ -927,7 +927,6 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 
 	/* Read table */
 	for (i = 0; i < hellcreek->fdb_entries; ++i) {
-		unsigned char null_addr[ETH_ALEN] = { 0 };
 		struct hellcreek_fdb_entry entry = { 0 };
 
 		/* Read entry */
@@ -937,7 +936,7 @@ static int hellcreek_fdb_dump(struct dsa_switch *ds, int port,
 		hellcreek_write(hellcreek, 0x00, HR_FDBRDH);
 
 		/* Check valid */
-		if (!memcmp(entry.mac, null_addr, ETH_ALEN))
+		if (is_zero_ether_addr(entry.mac))
 			continue;
 
 		/* Check port mask */
-- 
2.6.2

