Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9262723D7AB
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 09:49:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgHFHsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 03:48:51 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:59946 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728367AbgHFHsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Aug 2020 03:48:47 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 71E11A9348D262EB461C;
        Thu,  6 Aug 2020 15:48:38 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Thu, 6 Aug 2020 15:48:29 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next] hinic: fix strncpy output truncated compile warnings
Date:   Thu, 6 Aug 2020 15:48:30 +0800
Message-ID: <20200806074830.1375-1-luobin9@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.118.36]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

fix the compile warnings of 'strncpy' output truncated before
terminating nul copying N bytes from a string of the same length

Signed-off-by: Luo bin <luobin9@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_devlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index c6adc776f3c8..1dc948c07b94 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -342,9 +342,9 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
 
 	level = event->event.chip.err_level;
 	if (level < FAULT_LEVEL_MAX)
-		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
+		strncpy(level_str, fault_level[level], strlen(fault_level[level]) + 1);
 	else
-		strncpy(level_str, "Unknown", strlen("Unknown"));
+		strncpy(level_str, "Unknown", sizeof(level_str));
 
 	if (level == FAULT_LEVEL_SERIOUS_FLR) {
 		err = devlink_fmsg_u32_pair_put(fmsg, "Function level err func_id",
@@ -388,9 +388,9 @@ static int fault_report_show(struct devlink_fmsg *fmsg,
 	int err;
 
 	if (event->type < FAULT_TYPE_MAX)
-		strncpy(type_str, fault_type[event->type], strlen(fault_type[event->type]));
+		strncpy(type_str, fault_type[event->type], strlen(fault_type[event->type]) + 1);
 	else
-		strncpy(type_str, "Unknown", strlen("Unknown"));
+		strncpy(type_str, "Unknown", sizeof(type_str));
 
 	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str);
 	if (err)
-- 
2.17.1

