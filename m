Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 705FB534DF1
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 13:21:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiEZLVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 07:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233141AbiEZLVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 07:21:20 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D65212
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 04:21:13 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q2Aiw7003225;
        Thu, 26 May 2022 04:21:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=6bXeV2tmootwmcnxbnzgGgrVE6IQGIHDGJHEfmyvYeY=;
 b=U4jbIdnmyh2DTBBYLrUBSqNoVf7qwR/ZgcE1Wgtnm8XdaspWhdCrlpW3tTUEOg0x5/w+
 3Q5xm2PWYsng8alWatMlhTAHVkIvmW5wYCTon18ga3SNZQpTi40rCfZWvr5lsNFSDxyQ
 kXG3Z36pjJ66LMscbXLphn3+jsHuWX3kmOaVoNYJgOSqMVbafmkzABzNmJTt6GrYWNyN
 2jcaP1NAYMnNUtS3Os4Lc4y7nl5ZwKtV3PQ9UhakB7VL/3j4V//bbvjwU6ZvowxbW/0V
 Dp5ERAHfBMZfJ5bBKF7Kcj0nWgojO/juMWOgBcDMB23tTjaGFL+VZxQ23QWPtYggYzlW Ow== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3g9jap5cjf-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 26 May 2022 04:21:06 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 26 May
 2022 04:19:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Thu, 26 May 2022 04:19:14 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id BD76B3F70A8;
        Thu, 26 May 2022 04:19:11 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <sgoutham@marvell.com>,
        <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [ethtool-next PATCH] rings: add support to set/get cqe size
Date:   Thu, 26 May 2022 16:48:45 +0530
Message-ID: <1653563925-21327-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: X0vLU_xqjiOjldV3DZPff0hGtr1zom80
X-Proofpoint-ORIG-GUID: X0vLU_xqjiOjldV3DZPff0hGtr1zom80
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-26_06,2022-05-25_02,2022-02-23_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After a packet is sent or received by NIC then NIC posts
a completion queue event which consists of transmission status
(like send success or error) and received status(like
pointers to packet fragments). These completion events may
also use a ring similar to rx and tx rings. This patch
introduces cqe-size ethtool parameter to modify the size
of the completion queue event if NIC hardware has that capability.
With this patch in place, cqe size can be set via
"ethtool -G <dev> cqe-size xxx" and get via "ethtool -g <dev>".

Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 ethtool.8.in    | 4 ++++
 ethtool.c       | 1 +
 netlink/rings.c | 7 +++++++
 3 files changed, 12 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index cbfe9cf..92ba229 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -200,6 +200,7 @@ ethtool \- query or control network driver and hardware settings
 .BN tx
 .BN rx\-buf\-len
 .BN tx\-push
+.BN cqe\-size
 .HP
 .B ethtool \-i|\-\-driver
 .I devname
@@ -577,6 +578,9 @@ Changes the size of a buffer in the Rx ring.
 .TP
 .BI tx\-push \ on|off
 Specifies whether TX push should be enabled.
+.TP
+.BI cqe\-size \ N
+Changes the size of completion queue event.
 .RE
 .TP
 .B \-i \-\-driver
diff --git a/ethtool.c b/ethtool.c
index c58c73b..ef4e4c6 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5734,6 +5734,7 @@ static const struct option args[] = {
 			  "		[ tx N ]\n"
 			  "		[ rx-buf-len N]\n"
 			  "		[ tx-push on|off]\n"
+			  "             [ cqe-size N]\n"
 	},
 	{
 		.opts	= "-k|--show-features|--show-offload",
diff --git a/netlink/rings.c b/netlink/rings.c
index 3718c10..5999247 100644
--- a/netlink/rings.c
+++ b/netlink/rings.c
@@ -48,6 +48,7 @@ int rings_reply_cb(const struct nlmsghdr *nlhdr, void *data)
 	show_u32(tb[ETHTOOL_A_RINGS_TX], "TX:\t\t");
 	show_u32(tb[ETHTOOL_A_RINGS_RX_BUF_LEN], "RX Buf Len:\t\t");
 	show_bool("tx-push", "TX Push:\t%s\n", tb[ETHTOOL_A_RINGS_TX_PUSH]);
+	show_u32(tb[ETHTOOL_A_RINGS_CQE_SIZE], "CQE Size:\t\t");
 
 	return MNL_CB_OK;
 }
@@ -112,6 +113,12 @@ static const struct param_parser sring_params[] = {
 		.handler        = nl_parse_u8bool,
 		.min_argc       = 1,
 	},
+	{
+		.arg            = "cqe-size",
+		.type           = ETHTOOL_A_RINGS_CQE_SIZE,
+		.handler        = nl_parse_direct_u32,
+		.min_argc       = 1,
+	},
 	{}
 };
 
-- 
2.7.4

