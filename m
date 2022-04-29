Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D62B514557
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 11:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356486AbiD2J01 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 05:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356517AbiD2J0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 05:26:14 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19144C42DD
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 02:22:56 -0700 (PDT)
Received: from kwepemi500002.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KqRjl364YzCsM5;
        Fri, 29 Apr 2022 17:18:19 +0800 (CST)
Received: from kwepemm600016.china.huawei.com (7.193.23.20) by
 kwepemi500002.china.huawei.com (7.221.188.171) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 17:22:54 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600016.china.huawei.com (7.193.23.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 29 Apr 2022 17:22:53 +0800
From:   Guangbin Huang <huangguangbin2@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <lipeng321@huawei.com>,
        <huangguangbin2@huawei.com>
Subject: [PATCH ethtool-next v3 2/2] ethtool: add support to get/set tx push by ethtool -G/g
Date:   Fri, 29 Apr 2022 17:17:04 +0800
Message-ID: <20220429091704.21258-3-huangguangbin2@huawei.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220429091704.21258-1-huangguangbin2@huawei.com>
References: <20220429091704.21258-1-huangguangbin2@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600016.china.huawei.com (7.193.23.20)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
index 119178e..3718c10 100644
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
+		.min_argc       = 1,
+	},
 	{}
 };
 
-- 
2.33.0

