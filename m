Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BEE2AD914
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 15:43:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731073AbgKJOnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 09:43:23 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:7626 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730231AbgKJOnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 09:43:20 -0500
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CVrFM01VvzLwLZ;
        Tue, 10 Nov 2020 22:43:03 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS413-HUB.china.huawei.com
 (10.3.19.213) with Microsoft SMTP Server id 14.3.487.0; Tue, 10 Nov 2020
 22:43:08 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kas@fi.muni.cz>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH net] cosa: Add missing kfree in error path of cosa_write
Date:   Tue, 10 Nov 2020 22:46:14 +0800
Message-ID: <20201110144614.43194-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If memory allocation for 'kbuf' succeed, cosa_write() doesn't have a
corresponding kfree() in exception handling. Thus add kfree() for this
function implementation.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wan/cosa.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/cosa.c b/drivers/net/wan/cosa.c
index f8aed0696d77..2369ca250cd6 100644
--- a/drivers/net/wan/cosa.c
+++ b/drivers/net/wan/cosa.c
@@ -889,6 +889,7 @@ static ssize_t cosa_write(struct file *file,
 			chan->tx_status = 1;
 			spin_unlock_irqrestore(&cosa->lock, flags);
 			up(&chan->wsem);
+			kfree(kbuf);
 			return -ERESTARTSYS;
 		}
 	}
-- 
2.17.1

