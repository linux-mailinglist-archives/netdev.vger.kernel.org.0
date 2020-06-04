Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1A191EE457
	for <lists+netdev@lfdr.de>; Thu,  4 Jun 2020 14:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgFDMT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 08:19:28 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5852 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727944AbgFDMT1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Jun 2020 08:19:27 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4F1943A5487BC59EE09D;
        Thu,  4 Jun 2020 20:19:22 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Thu, 4 Jun 2020
 20:19:12 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <jpr@f6fbb.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-hams@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <wanghai38@huawei.com>
Subject: [PATCH] yam: fix possible memory leak in yam_init_driver
Date:   Thu, 4 Jun 2020 20:18:51 +0800
Message-ID: <20200604121851.63880-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_netdev(dev) fails, free_netdev(dev) needs
to be called, otherwise a memory leak will occur.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/hamradio/yam.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/hamradio/yam.c b/drivers/net/hamradio/yam.c
index 71cdef9..5ab53e9 100644
--- a/drivers/net/hamradio/yam.c
+++ b/drivers/net/hamradio/yam.c
@@ -1133,6 +1133,7 @@ static int __init yam_init_driver(void)
 		err = register_netdev(dev);
 		if (err) {
 			printk(KERN_WARNING "yam: cannot register net device %s\n", dev->name);
+			free_netdev(dev);
 			goto error;
 		}
 		yam_devs[i] = dev;
-- 
1.8.3.1

