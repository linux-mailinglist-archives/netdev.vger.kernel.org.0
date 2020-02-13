Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F90B15BBA1
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:25:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbgBMJZq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:25:46 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:10617 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729578AbgBMJZq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:25:46 -0500
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8F3F1770D89F0872390C;
        Thu, 13 Feb 2020 17:25:43 +0800 (CST)
Received: from localhost.localdomain (10.90.53.225) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.439.0; Thu, 13 Feb 2020 17:25:35 +0800
From:   yangerkun <yangerkun@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <maowenan@huawei.com>,
        <yangerkun@huawei.com>
Subject: [RFC] slip: not call free_netdev before rtnl_unlock in slip_open
Date:   Thu, 13 Feb 2020 17:32:48 +0800
Message-ID: <20200213093248.129757-1-yangerkun@huawei.com>
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
---
 drivers/net/slip/slip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/slip/slip.c b/drivers/net/slip/slip.c
index 6f4d7ba8b109..babb01888b78 100644
--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -863,7 +863,10 @@ static int slip_open(struct tty_struct *tty)
 	tty->disc_data = NULL;
 	clear_bit(SLF_INUSE, &sl->flags);
 	sl_free_netdev(sl->dev);
+	/* do not call free_netdev before rtnl_unlock */
+	rtnl_unlock();
 	free_netdev(sl->dev);
+	return err;
 
 err_exit:
 	rtnl_unlock();
-- 
2.23.0.rc2.8.gff66981f45

