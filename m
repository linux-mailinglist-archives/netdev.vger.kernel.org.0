Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B80C03EE483
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 04:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236138AbhHQCkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 22:40:35 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:14215 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhHQCkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 22:40:32 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4GpZxM4gp1z1CX14;
        Tue, 17 Aug 2021 10:39:35 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 10:39:57 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 17 Aug 2021 10:39:57 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <shenjian15@huawei.com>,
        <lipeng321@huawei.com>, <yisen.zhuang@huawei.com>,
        <linyunsheng@huawei.com>, <huangguangbin2@huawei.com>,
        <chenhao288@hisilicon.com>, <salil.mehta@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>, <dledford@redhat.com>, <jgg@ziepe.ca>,
        <netanel@amazon.com>, <akiyano@amazon.com>,
        <thomas.lendacky@amd.com>, <irusskikh@marvell.com>,
        <michael.chan@broadcom.com>, <edwin.peer@broadcom.com>,
        <rohitm@chelsio.com>, <jacob.e.keller@intel.com>,
        <ioana.ciornei@nxp.com>, <vladimir.oltean@nxp.com>,
        <sgoutham@marvell.com>, <sbhatta@marvell.com>, <saeedm@nvidia.com>,
        <ecree.xilinx@gmail.com>, <grygorii.strashko@ti.com>,
        <merez@codeaurora.org>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>
Subject: [PATCH net-next 1/4] ethtool: add two coalesce attributes for CQE mode
Date:   Tue, 17 Aug 2021 10:36:04 +0800
Message-ID: <1629167767-7550-2-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
References: <1629167767-7550-1-git-send-email-moyufeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, there many drivers who support CQE mode configuration,
some configure it as a fixed when initialized, some provide an
interface to change it by ethtool private flags. In order make it
more generic, add two new 'ETHTOOL_A_COALESCE_USE_CQE_TX' and
'ETHTOOL_A_COALESCE_USE_CQE_RX' coalesce attributes, then these
parameters can be accessed by ethtool netlink coalesce uAPI.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/ethtool-netlink.rst | 15 +++++++++++++++
 include/linux/ethtool.h                      |  6 +++++-
 include/uapi/linux/ethtool_netlink.h         |  2 ++
 3 files changed, 22 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index c690bb3..d9b55b7 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -947,12 +947,25 @@ Kernel response contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
   ===========================================  ======  =======================
 
 Attributes are only included in reply if their value is not zero or the
 corresponding bit in ``ethtool_ops::supported_coalesce_params`` is set (i.e.
 they are declared as supported by driver).
 
+Timer reset mode (``ETHTOOL_A_COALESCE_USE_CQE_TX`` and
+``ETHTOOL_A_COALESCE_USE_CQE_RX``) controls the interaction between packet
+arrival and the various time based delay parameters. By default timers are
+expected to limit the max delay between any packet arrival/departure and a
+corresponding interrupt. In this mode timer should be started by packet
+arrival (sometimes delivery of previous interrupt) and reset when interrupt
+is delivered.
+Setting the appropriate attribute to 1 will enable ``CQE`` mode, where
+each packet event resets the timer. In this mode timer is used to force
+the interrupt if queue goes idle, while busy queues depend on the packet
+limit to trigger interrupts.
 
 COALESCE_SET
 ============
@@ -985,6 +998,8 @@ Request contents:
   ``ETHTOOL_A_COALESCE_TX_USECS_HIGH``         u32     delay (us), high Tx
   ``ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH``    u32     max packets, high Tx
   ``ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL``  u32     rate sampling interval
+  ``ETHTOOL_A_COALESCE_USE_CQE_TX``            bool    timer reset mode, Tx
+  ``ETHTOOL_A_COALESCE_USE_CQE_RX``            bool    timer reset mode, Rx
   ===========================================  ======  =======================
 
 Request is rejected if it attributes declared as unsupported by driver (i.e.
diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index 4711b96..bad4c7a 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -211,7 +211,9 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 #define ETHTOOL_COALESCE_TX_USECS_HIGH		BIT(19)
 #define ETHTOOL_COALESCE_TX_MAX_FRAMES_HIGH	BIT(20)
 #define ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL	BIT(21)
-#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(21, 0)
+#define ETHTOOL_COALESCE_USE_CQE_RX		BIT(22)
+#define ETHTOOL_COALESCE_USE_CQE_TX		BIT(23)
+#define ETHTOOL_COALESCE_ALL_PARAMS		GENMASK(23, 0)
 
 #define ETHTOOL_COALESCE_USECS						\
 	(ETHTOOL_COALESCE_RX_USECS | ETHTOOL_COALESCE_TX_USECS)
@@ -237,6 +239,8 @@ bool ethtool_convert_link_mode_to_legacy_u32(u32 *legacy_u32,
 	 ETHTOOL_COALESCE_RX_USECS_LOW | ETHTOOL_COALESCE_RX_USECS_HIGH | \
 	 ETHTOOL_COALESCE_PKT_RATE_LOW | ETHTOOL_COALESCE_PKT_RATE_HIGH | \
 	 ETHTOOL_COALESCE_RATE_SAMPLE_INTERVAL)
+#define ETHTOOL_COALESCE_USE_CQE					\
+	(ETHTOOL_COALESCE_USE_CQE_RX | ETHTOOL_COALESCE_USE_CQE_TX)
 
 #define ETHTOOL_STAT_NOT_SET	(~0ULL)
 
diff --git a/include/uapi/linux/ethtool_netlink.h b/include/uapi/linux/ethtool_netlink.h
index b3b9371..5545f1c 100644
--- a/include/uapi/linux/ethtool_netlink.h
+++ b/include/uapi/linux/ethtool_netlink.h
@@ -377,6 +377,8 @@ enum {
 	ETHTOOL_A_COALESCE_TX_USECS_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH,		/* u32 */
 	ETHTOOL_A_COALESCE_RATE_SAMPLE_INTERVAL,	/* u32 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,		/* u8 */
+	ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,		/* u8 */
 
 	/* add new constants above here */
 	__ETHTOOL_A_COALESCE_CNT,
-- 
2.8.1

