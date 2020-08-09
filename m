Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87DAE23FC50
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 05:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726199AbgHIDxx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Aug 2020 23:53:53 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:9254 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbgHIDxx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 8 Aug 2020 23:53:53 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id BB18C311908289016654;
        Sun,  9 Aug 2020 11:53:48 +0800 (CST)
Received: from localhost.localdomain (10.175.118.36) by
 DGGEMS413-HUB.china.huawei.com (10.3.19.213) with Microsoft SMTP Server id
 14.3.487.0; Sun, 9 Aug 2020 11:53:40 +0800
From:   Luo bin <luobin9@huawei.com>
To:     <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <luoxianjun@huawei.com>, <yin.yinshi@huawei.com>,
        <cloud.wangxiaoyun@huawei.com>, <chiqijun@huawei.com>
Subject: [PATCH net-next v2] hinic: fix strncpy output truncated compile warnings
Date:   Sun, 9 Aug 2020 11:53:49 +0800
Message-ID: <20200809035349.16715-1-luobin9@huawei.com>
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
V2~V1:
- remove strncpy
V0~V1:
- use the strlen()+1 pattern consistently

 .../net/ethernet/huawei/hinic/hinic_devlink.c | 32 +++++++------------
 .../net/ethernet/huawei/hinic/hinic_hw_dev.h  |  2 --
 2 files changed, 12 insertions(+), 22 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
index c6adc776f3c8..16bda7381ba0 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_devlink.c
@@ -334,19 +334,14 @@ void hinic_devlink_unregister(struct hinic_devlink_priv *priv)
 static int chip_fault_show(struct devlink_fmsg *fmsg,
 			   struct hinic_fault_event *event)
 {
-	char fault_level[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
-		"fatal", "reset", "flr", "general", "suggestion"};
-	char level_str[FAULT_SHOW_STR_LEN + 1] = {0};
-	u8 level;
+	const char * const level_str[FAULT_LEVEL_MAX + 1] = {
+		"fatal", "reset", "flr", "general", "suggestion", "Unknown"};
+	u8 fault_level;
 	int err;
 
-	level = event->event.chip.err_level;
-	if (level < FAULT_LEVEL_MAX)
-		strncpy(level_str, fault_level[level], strlen(fault_level[level]));
-	else
-		strncpy(level_str, "Unknown", strlen("Unknown"));
-
-	if (level == FAULT_LEVEL_SERIOUS_FLR) {
+	fault_level = (event->event.chip.err_level < FAULT_LEVEL_MAX) ?
+		event->event.chip.err_level : FAULT_LEVEL_MAX;
+	if (fault_level == FAULT_LEVEL_SERIOUS_FLR) {
 		err = devlink_fmsg_u32_pair_put(fmsg, "Function level err func_id",
 						(u32)event->event.chip.func_id);
 		if (err)
@@ -361,7 +356,7 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
 	if (err)
 		return err;
 
-	err = devlink_fmsg_string_pair_put(fmsg, "err_level", level_str);
+	err = devlink_fmsg_string_pair_put(fmsg, "err_level", level_str[fault_level]);
 	if (err)
 		return err;
 
@@ -381,18 +376,15 @@ static int chip_fault_show(struct devlink_fmsg *fmsg,
 static int fault_report_show(struct devlink_fmsg *fmsg,
 			     struct hinic_fault_event *event)
 {
-	char fault_type[FAULT_TYPE_MAX][FAULT_SHOW_STR_LEN + 1] = {
+	const char * const type_str[FAULT_TYPE_MAX + 1] = {
 		"chip", "ucode", "mem rd timeout", "mem wr timeout",
-		"reg rd timeout", "reg wr timeout", "phy fault"};
-	char type_str[FAULT_SHOW_STR_LEN + 1] = {0};
+		"reg rd timeout", "reg wr timeout", "phy fault", "Unknown"};
+	u8 fault_type;
 	int err;
 
-	if (event->type < FAULT_TYPE_MAX)
-		strncpy(type_str, fault_type[event->type], strlen(fault_type[event->type]));
-	else
-		strncpy(type_str, "Unknown", strlen("Unknown"));
+	fault_type = (event->type < FAULT_TYPE_MAX) ? event->type : FAULT_TYPE_MAX;
 
-	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str);
+	err = devlink_fmsg_string_pair_put(fmsg, "Fault type", type_str[fault_type]);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
index dc6e645f2689..701eb81e09a7 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
+++ b/drivers/net/ethernet/huawei/hinic/hinic_hw_dev.h
@@ -504,8 +504,6 @@ enum hinic_fault_type {
 	FAULT_TYPE_MAX,
 };
 
-#define FAULT_SHOW_STR_LEN 16
-
 enum hinic_fault_err_level {
 	FAULT_LEVEL_FATAL,
 	FAULT_LEVEL_SERIOUS_RESET,
-- 
2.17.1

