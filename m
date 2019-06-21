Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA8C4E9BD
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 15:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbfFUNpH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 09:45:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:41240 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725985AbfFUNpH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jun 2019 09:45:07 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 8463D206E3EF2D9D4832;
        Fri, 21 Jun 2019 21:45:01 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Fri, 21 Jun 2019
 21:44:51 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] net/sched: cbs: Fix error path of cbs_module_init
Date:   Fri, 21 Jun 2019 21:44:37 +0800
Message-ID: <20190621134437.4252-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If register_qdisc fails, we should unregister
netdevice notifier.

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 net/sched/sch_cbs.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/sched/sch_cbs.c b/net/sched/sch_cbs.c
index e16a3d3..4e1a878 100644
--- a/net/sched/sch_cbs.c
+++ b/net/sched/sch_cbs.c
@@ -549,12 +549,17 @@ static struct notifier_block cbs_device_notifier = {
 
 static int __init cbs_module_init(void)
 {
-	int err = register_netdevice_notifier(&cbs_device_notifier);
+	int err;
 
+	err = register_netdevice_notifier(&cbs_device_notifier);
 	if (err)
 		return err;
 
-	return register_qdisc(&cbs_qdisc_ops);
+	err = register_qdisc(&cbs_qdisc_ops);
+	if (err)
+		unregister_netdevice_notifier(&cbs_device_notifier);
+
+	return err;
 }
 
 static void __exit cbs_module_exit(void)
-- 
2.7.4


