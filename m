Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000B039C50B
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 04:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbhFEC3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 22:29:23 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:4360 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFEC3X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 22:29:23 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Fxk2q0SmTz68nh;
        Sat,  5 Jun 2021 10:23:47 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 5 Jun 2021 10:27:34 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 5 Jun 2021
 10:27:33 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <vladimir.oltean@nxp.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH net-next v2] net: mscc: ocelot: check return value after calling platform_get_resource()
Date:   Sat, 5 Jun 2021 10:31:48 +0800
Message-ID: <20210605023148.4124956-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It will cause null-ptr-deref if platform_get_resource() returns NULL,
we need check the return value.

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
v2:
  add missing goto err_alloc_felix
---
 drivers/net/dsa/ocelot/seville_vsc9953.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index 84f93a874d50..deae923c8b7a 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1206,6 +1206,11 @@ static int seville_probe(struct platform_device *pdev)
 	felix->info = &seville_info_vsc9953;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res) {
+		err = -EINVAL;
+		dev_err(&pdev->dev, "Invalid resource\n");
+		goto err_alloc_felix;
+	}
 	felix->switch_base = res->start;
 
 	ds = kzalloc(sizeof(struct dsa_switch), GFP_KERNEL);
-- 
2.25.1

