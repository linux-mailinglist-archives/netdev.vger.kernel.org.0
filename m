Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0832D4176D6
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 16:34:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346794AbhIXOfu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 10:35:50 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:17192 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346775AbhIXOfs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 10:35:48 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HGDyw6yW6z1DH59;
        Fri, 24 Sep 2021 22:32:56 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:09 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 24 Sep 2021 22:34:08 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <andrew@lunn.ch>, <amitc@mellanox.com>, <idosch@idosch.org>,
        <danieller@nvidia.com>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <jdike@addtoit.com>,
        <richard@nod.at>, <anton.ivanov@cambridgegreys.com>,
        <netanel@amazon.com>, <akiyano@amazon.com>, <gtzalik@amazon.com>,
        <saeedb@amazon.com>, <chris.snook@gmail.com>,
        <ulli.kroll@googlemail.com>, <linus.walleij@linaro.org>,
        <jeroendb@google.com>, <csully@google.com>,
        <awogbemila@google.com>, <jdmason@kudzu.us>,
        <rain.1986.08.12@gmail.com>, <zyjzyj2000@gmail.com>,
        <kys@microsoft.com>, <haiyangz@microsoft.com>, <mst@redhat.com>,
        <jasowang@redhat.com>, <doshir@vmware.com>,
        <pv-drivers@vmware.com>, <jwi@linux.ibm.com>,
        <kgraul@linux.ibm.com>, <hca@linux.ibm.com>, <gor@linux.ibm.com>,
        <johannes@sipsolutions.net>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <chenhao288@hisilicon.com>, <huangguangbin2@huawei.com>,
        <linux-s390@vger.kernel.org>
Subject: [PATCH V2 net-next 1/6] ethtool: add support to set/get tx copybreak buf size via ethtool
Date:   Fri, 24 Sep 2021 22:29:54 +0800
Message-ID: <20210924142959.7798-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924142959.7798-1-huangguangbin2@huawei.com>
References: <20210924142959.7798-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hao Chen <chenhao288@hisilicon.com>

Add support for ethtool to set/get tx copybreak buf size.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 Documentation/networking/ethtool-netlink.rst | 24 ++++++++++++++++++++
 include/uapi/linux/ethtool.h                 |  1 +
 net/ethtool/common.c                         |  1 +
 net/ethtool/ioctl.c                          |  1 +
 4 files changed, 27 insertions(+)

diff --git a/Documentation/networking/ethtool-netlink.rst b/Documentation/networking/ethtool-netlink.rst
index d9b55b7a1a4d..a47b0255aaf9 100644
--- a/Documentation/networking/ethtool-netlink.rst
+++ b/Documentation/networking/ethtool-netlink.rst
@@ -1521,6 +1521,30 @@ Kernel response contents:
   ``ETHTOOL_A_PHC_VCLOCKS_INDEX``       s32     PHC index array
   ====================================  ======  ==========================
 
+TUNABLE_SET
+===========
+
+Request contents:
+
+  =====================================  ======  ==========================
+  ``ETHTOOL_TX_COPYBREAK_BUF_SIZE``      u32     buf size for tx copybreak
+  =====================================  ======  ==========================
+
+Tx copybreak buf size is used for tx copybreak feature, the feature is used
+for small size packet or frag. It adds a queue based tx shared bounce buffer
+to memcpy the small packet when the len of xmitted skb is below tx_copybreak
+(value to distinguish small size and normal size), and reduce the overhead
+of dma map and unmap when IOMMU is on.
+
+TUNABLE_GET
+===========
+
+Kernel response contents:
+
+  ====================================  ======  ==========================
+  ``ETHTOOL_TX_COPYBREAK_BUF_SIZE``     u32     buf size for tx copybreak
+  ====================================  ======  ==========================
+
 Request translation
 ===================
 
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index b6db6590baf0..266e95e4fb33 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -231,6 +231,7 @@ enum tunable_id {
 	ETHTOOL_RX_COPYBREAK,
 	ETHTOOL_TX_COPYBREAK,
 	ETHTOOL_PFC_PREVENTION_TOUT, /* timeout in msecs */
+	ETHTOOL_TX_COPYBREAK_BUF_SIZE,
 	/*
 	 * Add your fresh new tunable attribute above and remember to update
 	 * tunable_strings[] in net/ethtool/common.c
diff --git a/net/ethtool/common.c b/net/ethtool/common.c
index c63e0739dc6a..0c5210015911 100644
--- a/net/ethtool/common.c
+++ b/net/ethtool/common.c
@@ -89,6 +89,7 @@ tunable_strings[__ETHTOOL_TUNABLE_COUNT][ETH_GSTRING_LEN] = {
 	[ETHTOOL_RX_COPYBREAK]	= "rx-copybreak",
 	[ETHTOOL_TX_COPYBREAK]	= "tx-copybreak",
 	[ETHTOOL_PFC_PREVENTION_TOUT] = "pfc-prevention-tout",
+	[ETHTOOL_TX_COPYBREAK_BUF_SIZE] = "tx-copybreak-buf-size",
 };
 
 const char
diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
index 999e2a6bed13..a6600e361c34 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2381,6 +2381,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 	case ETHTOOL_TX_COPYBREAK:
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
 		if (tuna->len != sizeof(u32) ||
 		    tuna->type_id != ETHTOOL_TUNABLE_U32)
 			return -EINVAL;
-- 
2.33.0

