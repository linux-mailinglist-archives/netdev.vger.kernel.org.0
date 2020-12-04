Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1802CEA1C
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 09:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729271AbgLDIq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 03:46:59 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:9379 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728044AbgLDIq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 03:46:59 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4CnRB50XW9z78MK;
        Fri,  4 Dec 2020 16:45:49 +0800 (CST)
Received: from compute.localdomain (10.175.112.70) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 4 Dec 2020 16:46:06 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
CC:     Zhang Changzhong <zhangchangzhong@huawei.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: marvell: prestera: Fix error return code in prestera_port_create()
Date:   Fri, 4 Dec 2020 16:49:42 +0800
Message-ID: <1607071782-34006-1-git-send-email-zhangchangzhong@huawei.com>
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

Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 0f20e07..da4b286 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -318,8 +318,10 @@ static int prestera_port_create(struct prestera_switch *sw, u32 id)
 		goto err_port_init;
 	}
 
-	if (port->fp_id >= PRESTERA_MAC_ADDR_NUM_MAX)
+	if (port->fp_id >= PRESTERA_MAC_ADDR_NUM_MAX) {
+		err = -EINVAL;
 		goto err_port_init;
+	}
 
 	/* firmware requires that port's MAC address consist of the first
 	 * 5 bytes of the base MAC address
-- 
2.9.5

