Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38A25888B1
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 10:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiHCI0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 04:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233103AbiHCI0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 04:26:24 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA746E08C
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 01:26:21 -0700 (PDT)
Received: from dggpeml500021.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LyPzC0JyYzmVJS;
        Wed,  3 Aug 2022 16:24:23 +0800 (CST)
Received: from localhost.huawei.com (10.137.16.204) by
 dggpeml500021.china.huawei.com (7.185.36.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 3 Aug 2022 16:26:19 +0800
From:   sunsuwan <sunsuwan3@huawei.com>
To:     <netdev@vger.kernel.org>
CC:     <sunsuwan3@huawei.com>, <chenzhen126@huawei.com>,
        <liaichun@huawei.com>, <yanan@huawei.com>, <roopa@nvidia.com>,
        <nikolay@nvidia.com>, <davem@davemloft.net>, <kuba@kernel.org>
Subject: [PATCH] bridge-utils:close socket before exit
Date:   Wed, 3 Aug 2022 16:20:51 +0800
Message-ID: <20220803082051.1704227-1-sunsuwan3@huawei.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.137.16.204]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500021.china.huawei.com (7.185.36.21)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

brctl should close socket before exit.

Signed-off-by: sunsuwan <sunsuwan3@huawei.com>

---
 brctl/brctl.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/brctl/brctl.c b/brctl/brctl.c
index 8855234..dd6c347 100644
--- a/brctl/brctl.c
+++ b/brctl/brctl.c
@@ -37,7 +37,7 @@ static void help()
 int main(int argc, char *const* argv)
 {
 	const struct command *cmd;
-	int f;
+	int f, ret;
 	static const struct option options[] = {
 		{ .name = "help", .val = 'h' },
 		{ .name = "version", .val = 'V' },
@@ -70,16 +70,20 @@ int main(int argc, char *const* argv)
 	argv += optind;
 	if ((cmd = command_lookup(*argv)) == NULL) {
 		fprintf(stderr, "never heard of command [%s]\n", *argv);
+		br_shutdown();
 		goto help;
 	}
 	
 	if (argc < cmd->nargs + 1) {
 		printf("Incorrect number of arguments for command\n");
 		printf("Usage: brctl %s %s\n", cmd->name, cmd->help);
+		br_shutdown();
 		return 1;
 	}
 
-	return cmd->func(argc, argv);
+	ret = cmd->func(argc, argv);
+	br_shutdown();
+	return ret;
 
 help:
 	help();
-- 
2.30.0

