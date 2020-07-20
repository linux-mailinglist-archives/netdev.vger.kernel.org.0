Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A822614F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 15:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgGTNt4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 09:49:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725792AbgGTNtx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Jul 2020 09:49:53 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 87602778C169FD4F0C84;
        Mon, 20 Jul 2020 21:49:49 +0800 (CST)
Received: from huawei.com (10.175.101.6) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.487.0; Mon, 20 Jul 2020
 21:49:43 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <h.morris@cascoda.com>, <alex.aring@gmail.com>,
        <stefan@datenfreihafen.org>, <davem@davemloft.net>,
        <kuba@kernel.org>, <marcel@holtmann.or>, <netdev@vger.kernel.org>
Subject: [PATCH net] ieee802154: fix one possible memleak in ca8210_dev_com_init
Date:   Mon, 20 Jul 2020 22:33:15 +0800
Message-ID: <20200720143315.40523-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We should call destroy_workqueue to destroy mlme_workqueue in error branch.

Fixes: ded845a781a5 ("ieee802154: Add CA8210 IEEE 802.15.4 device driver")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 drivers/net/ieee802154/ca8210.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ieee802154/ca8210.c b/drivers/net/ieee802154/ca8210.c
index e04c3b60cae7..4eb64709d44c 100644
--- a/drivers/net/ieee802154/ca8210.c
+++ b/drivers/net/ieee802154/ca8210.c
@@ -2925,6 +2925,7 @@ static int ca8210_dev_com_init(struct ca8210_priv *priv)
 	);
 	if (!priv->irq_workqueue) {
 		dev_crit(&priv->spi->dev, "alloc of irq_workqueue failed!\n");
+		destroy_workqueue(priv->mlme_workqueue);
 		return -ENOMEM;
 	}
 
-- 
2.17.1

