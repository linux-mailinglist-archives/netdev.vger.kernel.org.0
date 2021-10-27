Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1803443C95D
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241838AbhJ0MSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 08:18:42 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:26127 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241817AbhJ0MSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 08:18:39 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HfSKh4m5rz1DHvB;
        Wed, 27 Oct 2021 20:14:16 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:11 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Wed, 27 Oct 2021 20:16:10 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net 4/7] net: hns3: fix data endian problem of some functions of debugfs
Date:   Wed, 27 Oct 2021 20:11:46 +0800
Message-ID: <20211027121149.45897-5-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211027121149.45897-1-huangguangbin2@huawei.com>
References: <20211027121149.45897-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

The member data in struct hclge_desc is type of __le32, it needs endian
conversion before using it, and some functions of debugfs didn't do that,
so this patch fixes it.

Fixes: c0ebebb9ccc1 ("net: hns3: Add "dcb register" status information query function")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 .../hisilicon/hns3/hns3pf/hclge_debugfs.c     | 30 +++++++++----------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
index 32f62cd2dd99..9cda8b3562b8 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_debugfs.c
@@ -391,7 +391,7 @@ static int hclge_dbg_dump_mac(struct hclge_dev *hdev, char *buf, int len)
 static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 				   int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u16 qset_id, qset_num;
 	int ret;
@@ -408,12 +408,12 @@ static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 		if (ret)
 			return ret;
 
-		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+		req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 		*pos += scnprintf(buf + *pos, len - *pos,
 				  "%04u           %#x            %#x             %#x               %#x\n",
-				  qset_id, bitmap->bit0, bitmap->bit1,
-				  bitmap->bit2, bitmap->bit3);
+				  qset_id, req.bit0, req.bit1, req.bit2,
+				  req.bit3);
 	}
 
 	return 0;
@@ -422,7 +422,7 @@ static int hclge_dbg_dump_dcb_qset(struct hclge_dev *hdev, char *buf, int len,
 static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 				  int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 pri_id, pri_num;
 	int ret;
@@ -439,12 +439,11 @@ static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 		if (ret)
 			return ret;
 
-		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+		req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 		*pos += scnprintf(buf + *pos, len - *pos,
 				  "%03u       %#x           %#x                %#x\n",
-				  pri_id, bitmap->bit0, bitmap->bit1,
-				  bitmap->bit2);
+				  pri_id, req.bit0, req.bit1, req.bit2);
 	}
 
 	return 0;
@@ -453,7 +452,7 @@ static int hclge_dbg_dump_dcb_pri(struct hclge_dev *hdev, char *buf, int len,
 static int hclge_dbg_dump_dcb_pg(struct hclge_dev *hdev, char *buf, int len,
 				 int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 pg_id;
 	int ret;
@@ -466,12 +465,11 @@ static int hclge_dbg_dump_dcb_pg(struct hclge_dev *hdev, char *buf, int len,
 		if (ret)
 			return ret;
 
-		bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+		req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 		*pos += scnprintf(buf + *pos, len - *pos,
 				  "%03u      %#x           %#x               %#x\n",
-				  pg_id, bitmap->bit0, bitmap->bit1,
-				  bitmap->bit2);
+				  pg_id, req.bit0, req.bit1, req.bit2);
 	}
 
 	return 0;
@@ -511,7 +509,7 @@ static int hclge_dbg_dump_dcb_queue(struct hclge_dev *hdev, char *buf, int len,
 static int hclge_dbg_dump_dcb_port(struct hclge_dev *hdev, char *buf, int len,
 				   int *pos)
 {
-	struct hclge_dbg_bitmap_cmd *bitmap;
+	struct hclge_dbg_bitmap_cmd req;
 	struct hclge_desc desc;
 	u8 port_id = 0;
 	int ret;
@@ -521,12 +519,12 @@ static int hclge_dbg_dump_dcb_port(struct hclge_dev *hdev, char *buf, int len,
 	if (ret)
 		return ret;
 
-	bitmap = (struct hclge_dbg_bitmap_cmd *)&desc.data[1];
+	req.bitmap = (u8)le32_to_cpu(desc.data[1]);
 
 	*pos += scnprintf(buf + *pos, len - *pos, "port_mask: %#x\n",
-			 bitmap->bit0);
+			 req.bit0);
 	*pos += scnprintf(buf + *pos, len - *pos, "port_shaping_pass: %#x\n",
-			 bitmap->bit1);
+			 req.bit1);
 
 	return 0;
 }
-- 
2.33.0

