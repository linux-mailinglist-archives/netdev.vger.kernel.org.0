Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83A3A173869
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 14:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgB1Ndy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 08:33:54 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:33530 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726388AbgB1Ndy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Feb 2020 08:33:54 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 6EEC59F670D228EA0821;
        Fri, 28 Feb 2020 21:33:45 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server id
 14.3.439.0; Fri, 28 Feb 2020 21:33:36 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <yangerkun@huawei.com>
Subject: [PATCH linux-4.4.y/linux-4.9.y v2] slip: stop double free sl->dev in slip_open
Date:   Fri, 28 Feb 2020 21:40:48 +0800
Message-ID: <20200228134048.19675-1-yangerkun@huawei.com>
X-Mailer: git-send-email 2.23.0.rc2.8.gff66981f45
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After include 3b5a39979daf ("slip: Fix memory leak in slip_open error path")
and e58c19124189 ("slip: Fix use-after-free Read in slip_open") with 4.4.y/4.9.y.
We will trigger a bug since we can double free sl->dev in slip_open. Actually,
we should backport cf124db566e6 ("net: Fix inconsistent teardown and release
of private netdev state.") too since it has delete free_netdev from sl_free_netdev.
Fix it by delete free_netdev from slip_open.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 drivers/net/slip/slip.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 0f8d5609ed51..d4a33baa33b6 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -868,7 +868,6 @@ err_free_chan:
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	sl_free_netdev(sl->dev);
-	free_netdev(sl->dev);
 
 err_exit:
 	rtnl_unlock();
-- 
2.23.0.rc2.8.gff66981f45

