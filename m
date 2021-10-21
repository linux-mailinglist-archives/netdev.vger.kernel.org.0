Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426A6435D86
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 11:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbhJUJII (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 05:08:08 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:14837 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbhJUJII (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 05:08:08 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4HZhKK4DF9z90Ns;
        Thu, 21 Oct 2021 17:00:53 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Thu, 21 Oct 2021 17:05:50 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Thu, 21 Oct
 2021 17:05:50 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <richardcochran@gmail.com>, <kuba@kernel.org>
Subject: [PATCH -net] ptp: free 'vclock_index' in ptp_clock_release()
Date:   Thu, 21 Oct 2021 17:13:53 +0800
Message-ID: <20211021091353.457508-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'vclock_index' is accessed from sysfs, it shouled be freed
in release function, so move it from ptp_clock_unregister()
to ptp_clock_release().

Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/ptp/ptp_clock.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 7fd02aabd79a..f9b2d66b0443 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -170,6 +170,7 @@ static void ptp_clock_release(struct device *dev)
 	struct ptp_clock *ptp = container_of(dev, struct ptp_clock, dev);
 
 	ptp_cleanup_pin_groups(ptp);
+	kfree(ptp->vclock_index);
 	mutex_destroy(&ptp->tsevq_mux);
 	mutex_destroy(&ptp->pincfg_mux);
 	mutex_destroy(&ptp->n_vclocks_mux);
@@ -286,8 +287,6 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	        if (ptp->pps_source)
 	                pps_unregister_source(ptp->pps_source);
 
-		kfree(ptp->vclock_index);
-
 		if (ptp->kworker)
 	                kthread_destroy_worker(ptp->kworker);
 
@@ -328,8 +327,6 @@ int ptp_clock_unregister(struct ptp_clock *ptp)
 	ptp->defunct = 1;
 	wake_up_interruptible(&ptp->tsev_wq);
 
-	kfree(ptp->vclock_index);
-
 	if (ptp->kworker) {
 		kthread_cancel_delayed_work_sync(&ptp->aux_work);
 		kthread_destroy_worker(ptp->kworker);
-- 
2.25.1

