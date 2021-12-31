Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73676482357
	for <lists+netdev@lfdr.de>; Fri, 31 Dec 2021 11:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhLaK1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Dec 2021 05:27:41 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:29317 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230109AbhLaK1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Dec 2021 05:27:40 -0500
Received: from kwepemi500004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4JQLt43Dgnzbjlf;
        Fri, 31 Dec 2021 18:27:08 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500004.china.huawei.com (7.221.188.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:38 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 31 Dec 2021 18:27:38 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <lipeng321@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>
Subject: [PATCH net-next 01/13] net: hns3: refactor hns3 makefile to support hns3_common module
Date:   Fri, 31 Dec 2021 18:22:31 +0800
Message-ID: <20211231102243.3006-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211231102243.3006-1-huangguangbin2@huawei.com>
References: <20211231102243.3006-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently we plan to refactor PF and VF cmdq module. A new file folder
hns3_common will be created to store new common APIs used by PF and VF
cmdq module. Thus the PF and VF compilation process will both depends on
the hns3_common. This may cause parallel building problems if we add a new
makefile building unit.

So this patch combined the PF and VF makefile scripts to the top level
makefile to support the new hns3_common which will be created in the next
patch.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 drivers/net/ethernet/hisilicon/hns3/Makefile       | 14 +++++++++++---
 .../net/ethernet/hisilicon/hns3/hns3pf/Makefile    | 12 ------------
 .../net/ethernet/hisilicon/hns3/hns3vf/Makefile    | 10 ----------
 3 files changed, 11 insertions(+), 25 deletions(-)
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
 delete mode 100644 drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile

diff --git a/drivers/net/ethernet/hisilicon/hns3/Makefile b/drivers/net/ethernet/hisilicon/hns3/Makefile
index 7aa2fac76c5e..32e24e0945f5 100644
--- a/drivers/net/ethernet/hisilicon/hns3/Makefile
+++ b/drivers/net/ethernet/hisilicon/hns3/Makefile
@@ -4,9 +4,8 @@
 #
 
 ccflags-y += -I$(srctree)/$(src)
-
-obj-$(CONFIG_HNS3) += hns3pf/
-obj-$(CONFIG_HNS3) += hns3vf/
+ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3pf
+ccflags-y += -I$(srctree)/drivers/net/ethernet/hisilicon/hns3/hns3vf
 
 obj-$(CONFIG_HNS3) += hnae3.o
 
@@ -14,3 +13,12 @@ obj-$(CONFIG_HNS3_ENET) += hns3.o
 hns3-objs = hns3_enet.o hns3_ethtool.o hns3_debugfs.o
 
 hns3-$(CONFIG_HNS3_DCB) += hns3_dcbnl.o
+
+obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
+hclgevf-objs = hns3vf/hclgevf_main.o hns3vf/hclgevf_cmd.o hns3vf/hclgevf_mbx.o  hns3vf/hclgevf_devlink.o
+
+obj-$(CONFIG_HNS3_HCLGE) += hclge.o
+hclge-objs = hns3pf/hclge_main.o hns3pf/hclge_cmd.o hns3pf/hclge_mdio.o hns3pf/hclge_tm.o \
+		hns3pf/hclge_mbx.o hns3pf/hclge_err.o  hns3pf/hclge_debugfs.o hns3pf/hclge_ptp.o hns3pf/hclge_devlink.o
+
+hclge-$(CONFIG_HNS3_DCB) += hns3pf/hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
deleted file mode 100644
index d1bf5c4c0abb..000000000000
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/Makefile
+++ /dev/null
@@ -1,12 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0+
-#
-# Makefile for the HISILICON network device drivers.
-#
-
-ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
-ccflags-y += -I $(srctree)/$(src)
-
-obj-$(CONFIG_HNS3_HCLGE) += hclge.o
-hclge-objs = hclge_main.o hclge_cmd.o hclge_mdio.o hclge_tm.o hclge_mbx.o hclge_err.o  hclge_debugfs.o hclge_ptp.o hclge_devlink.o
-
-hclge-$(CONFIG_HNS3_DCB) += hclge_dcb.o
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile b/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
deleted file mode 100644
index 51ff7d86ee90..000000000000
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/Makefile
+++ /dev/null
@@ -1,10 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0+
-#
-# Makefile for the HISILICON network device drivers.
-#
-
-ccflags-y := -I $(srctree)/drivers/net/ethernet/hisilicon/hns3
-ccflags-y += -I $(srctree)/$(src)
-
-obj-$(CONFIG_HNS3_HCLGEVF) += hclgevf.o
-hclgevf-objs = hclgevf_main.o hclgevf_cmd.o hclgevf_mbx.o  hclgevf_devlink.o
-- 
2.33.0

