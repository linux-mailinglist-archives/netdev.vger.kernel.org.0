Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6AF4171D6D
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 15:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390069AbgB0OUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 09:20:36 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:54696 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389914AbgB0OUe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 09:20:34 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 86CB185F19145C58DE54;
        Thu, 27 Feb 2020 22:20:22 +0800 (CST)
Received: from localhost.localdomain (10.175.34.53) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.439.0; Thu, 27 Feb 2020 22:20:15 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, Luo bin <luobin9@huawei.com>
Subject: [PATCH net v1 3/3] hinic: fix a bug of rss configuration
Date:   Thu, 27 Feb 2020 06:34:44 +0000
Message-ID: <20200227063444.2143-4-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200227063444.2143-1-luobin9@huawei.com>
References: <20200227063444.2143-1-luobin9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.34.53]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

should use real receive queue number to configure hw rss
indirect table rather than maximal queue number

Signed-off-by: Luo bin <luobin9@huawei.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index 2411ad270c98..42d00b049c6e 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -356,7 +356,8 @@ static void hinic_enable_rss(struct hinic_dev *nic_dev)
 	if (!num_cpus)
 		num_cpus = num_online_cpus();
 
-	nic_dev->num_qps = min_t(u16, nic_dev->max_qps, num_cpus);
+	nic_dev->num_qps = hinic_hwdev_num_qps(hwdev);
+	nic_dev->num_qps = min_t(u16, nic_dev->num_qps, num_cpus);
 
 	nic_dev->rss_limit = nic_dev->num_qps;
 	nic_dev->num_rss = nic_dev->num_qps;
-- 
2.17.1

