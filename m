Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D1F509B32
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 10:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387020AbiDUIzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 04:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387006AbiDUIzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 04:55:22 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A4620BE9
        for <netdev@vger.kernel.org>; Thu, 21 Apr 2022 01:52:33 -0700 (PDT)
Received: from kwepemi100023.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KkWVn6pdzz1J9xM;
        Thu, 21 Apr 2022 16:51:45 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi100023.china.huawei.com (7.221.188.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 16:52:31 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Apr 2022 16:52:31 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH ethtool-next v2 2/2] ethtool: add support to get/set tx push by ethtool -G/g
Date:   Thu, 21 Apr 2022 16:46:46 +0800
Message-ID: <20220421084646.15458-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220421084646.15458-1-huangguangbin2@huawei.com>
References: <20220421084646.15458-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jie Wang <wangjie125@huawei.com>

Currently tx push is a standard feature for NICs such as Mellanox, HNS3.
But there is no command to set or get this feature.

So this patch adds support for "ethtool -G <dev> tx-push on|off" and
"ethtool -g <dev>" to set/get tx push mode.

Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 ethtool.8.in    | 4 ++++
 ethtool.c       | 1 +
 netlink/rings.c | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index 12940e1..a87f31f 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -199,6 +199,7 @@ ethtool \- query or control network driver and hardware settings
 .BN rx\-jumbo
 .BN tx
 .BN rx\-buf\-len
+.BN tx\-push
 .HP
 .B ethtool \-i|\-\-driver
 .I devname
@@ -573,6 +574,9 @@ Changes the number of ring entries for the Tx ring.
 .TP
 .BI rx\-buf\-len \ N
 Changes the size of a buffer in the Rx ring.
+.TP
+.BI tx\-push \ on|off
+Specifies whether TX push should be enabled.
 .RE
 .TP
 .B \-i \-\-driver
diff --git a/ethtool.c b/ethtool.c
index 4f5c234..4d2a475 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5733,6 +5733,7 @@ static const struct option args[] = {
 			  "		[ rx-jumbo N ]\n"
 			  "		[ tx N ]\n"
 			  "             [ rx-buf-len N]\n"
+			  "		[ tx-push on|off]\n"
 	},
 	{
 		.opts	= "-k|--show-features|--show-offload",
diff --git a/netlink/rings.c b/netlink/rings.c
index 119178e..a53eed5 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -47,6 +47,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32(tb[ETHTOOL_A_RINGS_RX_JUMBO], "RX Jumbo:\t");
 	show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
 	show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
+	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
 
 	return MNL_CB_OK;
 }
@@ -105,6 +106,12 @@ static const struct param_parser sring_params[] = {
 		.handler        = nl_parse_direct_u32,
 		.min_argc       = 1,
 	},
+	{
+		.arg            = "tx-push",
+		.type           = ETHTOOL_A_RINGS_TX_PUSH,
+		.handler        = nl_parse_u8bool,
+		.min_argc       = 0,
+	},
 	{}
 };
 
-- 
2.33.0

