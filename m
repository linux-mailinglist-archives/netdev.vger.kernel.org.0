Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715672D0B0F
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 08:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgLGHVP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 02:21:15 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:9123 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgLGHVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 02:21:15 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4CqF7k4s5Dz15YTH;
        Mon,  7 Dec 2020 15:20:02 +0800 (CST)
Received: from localhost.localdomain (10.69.192.56) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Mon, 7 Dec 2020 15:20:23 +0800
From:   Huazhong Tan <tanhuazhong@huawei.com>
To:     <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kuba@kernel.org>, <huangdaode@huawei.com>, <sfr@canb.auug.org.au>,
        "Huazhong Tan" <tanhuazhong@huawei.com>
Subject: [PATCH net] net: hns3: remove a misused pragma packed
Date:   Mon, 7 Dec 2020 15:20:25 +0800
Message-ID: <1607325625-29945-1-git-send-email-tanhuazhong@huawei.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.69.192.56]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

hclge_dbg_reg_info[] is defined as an array of packed structure
accidentally. However, this array contains pointers, which are
no longer aligned naturally, and cannot be relocated on PPC64.
Hence, when compile-testing this driver on PPC64 with
CONFIG_RELOCATABLE=y (e.g. PowerPC allyesconfig), there will be
some warnings.

Since each field in structure hclge_qos_pri_map_cmd and
hclge_dbg_bitmap_cmd is type u8, the pragma packed is unnecessary
for these two structures as well, so remove the pragma packed in
hclge_debugfs.h to fix this issue, and this increases
hclge_dbg_reg_info[] by 4 bytes per entry.

Fixes: a582b78dfc33 ("net: hns3: code optimization for debugfs related to "dump reg"")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
index a9066e6..ca2ab6c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.h
@@ -35,8 +35,6 @@
 
 #define HCLGE_DBG_DFX_SSU_2_OFFSET 12
 
-#pragma pack(1)
-
 struct hclge_qos_pri_map_cmd {
 	u8 pri0_tc  : 4,
 	   pri1_tc  : 4;
@@ -85,8 +83,6 @@ struct hclge_dbg_reg_type_info {
 	struct hclge_dbg_reg_common_msg reg_msg;
 };
 
-#pragma pack()
-
 static const struct hclge_dbg_dfx_message hclge_dbg_bios_common_reg[] = {
 	{false, "Reserved"},
 	{true,	"BP_CPU_STATE"},
-- 
2.7.4

