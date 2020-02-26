Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A731416FEB0
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 13:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgBZMKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 07:10:54 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:37640 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726920AbgBZMKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Feb 2020 07:10:54 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 664CCBD4CBFC3E2EAF72;
        Wed, 26 Feb 2020 20:10:48 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.439.0; Wed, 26 Feb 2020 20:10:38 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <davem@davemloft.net>, <socketcan@hartkopp.net>
CC:     <netdev@vger.kernel.org>, <maowenan@huawei.com>,
        <yangerkun@huawei.com>
Subject: [PATCH v3] slip: not call free_netdev before rtnl_unlock in slip_open
Date:   Wed, 26 Feb 2020 20:17:50 +0800
Message-ID: <20200226121750.40925-1-yangerkun@huawei.com>
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

As the description before netdev_run_todo, we cannot call free_netdev
before rtnl_unlock, fix it by reorder the code.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Reviewed-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 drivers/net/slip/slip.c | 2 ++
 1 file changed, 2 insertions(+)

v2->v3:
delete comment exist in v2

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 6f4d7ba8b109..0d2d8c78635e 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -863,7 +863,9 @@ static int slip_open(struct tty_struct *tty)
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	sl_free_netdev(sl->dev);
+	rtnl_unlock();
 	free_netdev(sl->dev);
+	return err;
 
 err_exit:
 	rtnl_unlock();
-- 
2.23.0.rc2.8.gff66981f45

