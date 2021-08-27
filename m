Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 631EB3F9452
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 08:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244247AbhH0GLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 02:11:31 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:8785 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbhH0GLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 02:11:31 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Gwq7c4hb8zYtsS;
        Fri, 27 Aug 2021 14:10:04 +0800 (CST)
Received: from dggpeml500024.china.huawei.com (7.185.36.10) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 14:10:40 +0800
Received: from localhost.localdomain (10.67.165.24) by
 dggpeml500024.china.huawei.com (7.185.36.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 27 Aug 2021 14:10:40 +0800
From:   Yufeng Mo <moyufeng@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <mkubecek@suse.cz>,
        <amitc@mellanox.com>, <idosch@idosch.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <f.fainelli@gmail.com>,
        <jacob.e.keller@intel.com>, <mlxsw@mellanox.com>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <moyufeng@huawei.com>, <linuxarm@huawei.com>,
        <linuxarm@openeuler.org>
Subject: [PATCH RESEND ethtool-next] netlink: settings: add netlink support for coalesce cqe mode parameter
Date:   Fri, 27 Aug 2021 14:06:48 +0800
Message-ID: <1630044408-32819-1-git-send-email-moyufeng@huawei.com>
X-Mailer: git-send-email 2.8.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500024.china.huawei.com (7.185.36.10)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for "ethtool -c <dev> cqe-mode-rx/cqe-mode-tx on/off"
for setting coalesce cqe mode.

Signed-off-by: Yufeng Mo <moyufeng@huawei.com>
---
 ethtool.c          |  2 ++
 netlink/coalesce.c | 15 +++++++++++++++
 2 files changed, 17 insertions(+)

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
index 75922a9..762d0e3 100644
--- a/netlink/coalesce.c
+++ b/netlink/coalesce.c
@@ -66,6 +66,9 @@ int coalesce_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32(tb[ETHTOOL_A_COALESCE_TX_USECS_HIGH], "tx-usecs-high: ");
 	show_u32(tb[ETHTOOL_A_COALESCE_TX_MAX_FRAMES_HIGH], "tx-frame-high: ");
 	putchar('\n');
+	show_bool("rx", "CQE mode RX: %s  ",
+		  tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_RX]);
+	show_bool("tx", "TX: %s\n", tb[ETHTOOL_A_COALESCE_USE_CQE_MODE_TX]);
 
 	return MNL_CB_OK;
 }
@@ -226,6 +229,18 @@ static const struct param_parser scoalesce_params[] = {
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

