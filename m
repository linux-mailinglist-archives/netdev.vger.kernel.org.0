Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B597E347AC4
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbhCXOcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:32:51 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14576 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236342AbhCXOcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 10:32:39 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F59d913s2z19Hrb;
        Wed, 24 Mar 2021 22:30:37 +0800 (CST)
Received: from localhost.localdomain (10.175.102.38) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Wed, 24 Mar 2021 22:32:25 +0800
From:   'Wei Yongjun <weiyongjun1@huawei.com>
To:     <weiyongjun1@huawei.com>, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] netdevsim: switch to memdup_user_nul()
Date:   Wed, 24 Mar 2021 14:42:20 +0000
Message-ID: <20210324144220.974575-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.102.38]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

Use memdup_user_nul() helper instead of open-coding to
simplify the code.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/netdevsim/health.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/netdevsim/health.c b/drivers/net/netdevsim/health.c
index 21e2974660e7..04aebdf85747 100644
--- a/drivers/net/netdevsim/health.c
+++ b/drivers/net/netdevsim/health.c
@@ -235,15 +235,10 @@ static ssize_t nsim_dev_health_break_write(struct file *file,
 	char *break_msg;
 	int err;
 
-	break_msg = kmalloc(count + 1, GFP_KERNEL);
-	if (!break_msg)
-		return -ENOMEM;
+	break_msg = memdup_user_nul(data, count);
+	if (IS_ERR(break_msg))
+		return PTR_ERR(break_msg);
 
-	if (copy_from_user(break_msg, data, count)) {
-		err = -EFAULT;
-		goto out;
-	}
-	break_msg[count] = '\0';
 	if (break_msg[count - 1] == '\n')
 		break_msg[count - 1] = '\0';
 

