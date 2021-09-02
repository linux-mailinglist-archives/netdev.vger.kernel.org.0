Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280423FEAB8
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 10:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244552AbhIBIh6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 04:37:58 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15283 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244392AbhIBIh5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 04:37:57 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4H0Z5s6C98z8Cj6;
        Thu,  2 Sep 2021 16:36:33 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Thu, 2 Sep 2021 16:36:56 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <davem@davemloft.net>
CC:     <kuba@kernel.org>, <johan@kernel.org>, <mudongliangabcd@gmail.com>,
        <linux-usb@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] net: hso: add failure handler for add_net_device
Date:   Thu, 2 Sep 2021 16:36:09 +0800
Message-ID: <20210902083609.1679146-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the network devices connected to the system beyond
HSO_MAX_NET_DEVICES. add_net_device() in hso_create_net_device()
will be failed for the network_table is full. It will lead to
business failure which rely on network_table, for example,
hso_suspend() and hso_resume(). It will also lead to memory leak
because resource release process can not search the hso_device
object from network_table in hso_free_interface().

Add failure handler for add_net_device() in hso_create_net_device()
to solve the above problems.

Fixes: 72dc1c096c70 ("HSO: add option hso driver")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 drivers/net/usb/hso.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 24bc1e678b7b..422a07fd8814 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2535,13 +2535,17 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	if (!hso_net->mux_bulk_tx_buf)
 		goto err_free_tx_urb;
 
-	add_net_device(hso_dev);
+	result = add_net_device(hso_dev);
+	if (result) {
+		dev_err(&interface->dev, "Failed to add net device\n");
+		goto err_free_tx_buf;
+	}
 
 	/* registering our net device */
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto err_free_tx_buf;
+		goto err_rmv_ndev;
 	}
 
 	hso_log_port(hso_dev);
@@ -2550,8 +2554,9 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 
 	return hso_dev;
 
-err_free_tx_buf:
+err_rmv_ndev:
 	remove_net_device(hso_dev);
+err_free_tx_buf:
 	kfree(hso_net->mux_bulk_tx_buf);
 err_free_tx_urb:
 	usb_free_urb(hso_net->mux_bulk_tx_urb);
-- 
2.25.1

