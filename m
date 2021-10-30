Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC59744090C
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 15:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbhJ3NQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Oct 2021 09:16:59 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:30883 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbhJ3NQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Oct 2021 09:16:59 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HhKQJ1pfZzbnL8;
        Sat, 30 Oct 2021 21:09:44 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 30 Oct 2021 21:14:25 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 30 Oct 2021 21:14:24 +0800
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
Subject: [PATCH V5 net-next 1/6] ethtool: add support to set/get tx copybreak buf size via ethtool
Date:   Sat, 30 Oct 2021 21:09:56 +0800
Message-ID: <20211030131001.38739-2-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030131001.38739-1-huangguangbin2@huawei.com>
References: <20211030131001.38739-1-huangguangbin2@huawei.com>
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

From: Hao Chen <chenhao288@hisilicon.com>

Add support for ethtool to set/get tx copybreak buf size.

Signed-off-by: Hao Chen <chenhao288@hisilicon.com>
Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
---
 include/uapi/linux/ethtool.h | 1 +
 net/ethtool/common.c         | 1 +
 net/ethtool/ioctl.c          | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index a2223b685451..7bc4b8def12c 100644
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
index 44430b6ab843..3dc81edf5ca5 100644
--- a/net/ethtool/ioctl.c
+++ b/net/ethtool/ioctl.c
@@ -2382,6 +2382,7 @@ static int ethtool_tunable_valid(const struct ethtool_tunable *tuna)
 	switch (tuna->id) {
 	case ETHTOOL_RX_COPYBREAK:
 	case ETHTOOL_TX_COPYBREAK:
+	case ETHTOOL_TX_COPYBREAK_BUF_SIZE:
 		if (tuna->len != sizeof(u32) ||
 		    tuna->type_id != ETHTOOL_TUNABLE_U32)
 			return -EINVAL;
-- 
2.33.0

