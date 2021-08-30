Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95CE3FAFE4
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 04:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236254AbhH3Ckm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 22:40:42 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15268 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236223AbhH3Ckl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Aug 2021 22:40:41 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4GyZKC0Gm8z8CQ1;
        Mon, 30 Aug 2021 10:39:27 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 10:39:46 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 30 Aug 2021 10:39:46 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <f.fainelli@gmail.com>,
        <jacob.e.keller@intel.com>, <mlxsw@mellanox.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH V2 ethtool-next] netlink: settings: add netlink support for coalesce cqe mode parameter
Date:   Mon, 30 Aug 2021 10:35:53 +0800
Message-ID: <1630290953-52439-1-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for "ethtool -C <dev> cqe-mode-rx/cqe-mode-tx on/off"
for setting coalesce cqe mode.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
ChangeLogs:
V1 -> V2:
         1. update the man page for new paremeters cqe-mode-rx/cqe-mode-tx.
         2. add '\n' in coalesce_reply_cb() after showing new paremeters.
---
 ethtool.8.in       |  2 ++
 ethtool.c          |  2 ++
 netlink/coalesce.c | 16 ++++++++++++++++
 3 files changed, 20 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index f83d6d1..c187c32 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -186,6 +186,8 @@ ethtool \- query or control network driver and hardware settings
 .BN tx\-usecs\-high
 .BN tx\-frames\-high
 .BN sample\-interval
+.B2 cqe\-mode\-rx on off
+.B2 cqe\-mode\-tx on off
 .HP
 .B ethtool \-g|\-\-show\-ring
 .I devname
diff --git a/ethtool.c b/ethtool.c
index 2486caa..a6826e9 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5703,6 +5703,8 @@ static const struct option args[] = {
 			  "		[tx-usecs-high N]\n"
 			  "		[tx-frames-high N]\n"
 			  "		[sample-interval N]\n"
+			  "		[cqe-mode-rx on|off]\n"
+			  "		[cqe-mode-tx on|off]\n"
 	},
 	{
 		.opts	= "-g|--show-ring",
diff --git a/netlink/coalesce.c b/netlink/coalesce.c
index 75922a9..15037c2 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -66,6 +66,10 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
 	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
 	putchar('\n');
+	show_bool("rx", "CQE mode RX: %s  ",
+		  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
+	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
+	putchar('\n');
 
 	return MNL_CB_OK;
 }
@@ -226,6 +230,18 @@ static const struct param_parser scoalesce_params[] = {
 		.handler	= nl_parse_direct_u32,
 		.min_argc	= 1,
 	},
+	{
+		.arg		= "cqe-mode-rx",
+		.type		= ETHTOOL_A_COALESCE_USE_CQE_MODE_RX,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
+	{
+		.arg		= "cqe-mode-tx",
+		.type		= ETHTOOL_A_COALESCE_USE_CQE_MODE_TX,
+		.handler	= nl_parse_u8bool,
+		.min_argc	= 1,
+	},
 	{}
 };
 
-- 
2.8.1

