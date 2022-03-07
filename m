Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A30784CF358
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 09:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiCGIPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 03:15:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiCGIPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 03:15:16 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CE85AA42
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 00:14:21 -0800 (PST)
Received: from kwepemi100023.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KBrhs5g0Nz1GC3r;
        Mon,  7 Mar 2022 16:09:33 +0800 (CST)
Received: from kwepemm600017.china.huawei.com (7.193.23.234) by
 kwepemi100023.china.huawei.com (7.221.188.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Mon, 7 Mar 2022 16:14:19 +0800
Received: from localhost.localdomain (10.67.165.24) by
 kwepemm600017.china.huawei.com (7.193.23.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 7 Mar 2022 16:14:19 +0800
From:   Jie Wang <wangjie125@huawei.com>
To:     <mkubecek@suse.cz>, <davem@davemloft.net>, <kuba@kernel.org>,
        <wangjie125@huawei.com>
CC:     <netdev@vger.kernel.org>, <huangguangbin2@huawei.com>,
        <lipeng321@huawei.com>, <shenjian15@huawei.com>,
        <moyufeng@huawei.com>, <linyunsheng@huawei.com>,
        <salil.mehta@huawei.com>, <chenhao288@hisilicon.com>
Subject: [PATCH] ethtool: add the memory free operation after send_ioctl call fails
Date:   Mon, 7 Mar 2022 16:08:56 +0800
Message-ID: <20220307080856.39536-1-wangjie125@huawei.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.67.165.24]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm600017.china.huawei.com (7.193.23.234)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The memory is not freed after send_ioctl fails in function do_gtunable and
do_stunable. This will cause memory leaks.

So this patch adds memory free operation after send_ioctl call fails.

Fixes: b717ed22d984 ("ethtool: add support for get/set ethtool_tunable")
Signed-off-by: Jie Wang <wangjie125@huawei.com>
---
 ethtool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ethtool.c b/ethtool.c
index 5d718a2..0fbb96b 100644
--- a/ethtool.c
+++ b/ethtool.c
@@ -5097,6 +5097,7 @@ static int do_stunable(struct cmd_context *ctx)
 		ret = send_ioctl(ctx, tuna);
 		if (ret) {
 			perror(tunable_strings[tuna->id]);
+			free(tuna);
 			return ret;
 		}
 		free(tuna);
@@ -5174,6 +5175,7 @@ static int do_gtunable(struct cmd_context *ctx)
 			ret = send_ioctl(ctx, tuna);
 			if (ret) {
 				fprintf(stderr, "%s: Cannot get tunable\n", ts);
+				free(tuna);
 				return ret;
 			}
 			print_tunable(tuna);
-- 
2.33.0

