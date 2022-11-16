Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0F2D62BC6C
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 12:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbiKPLrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 06:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239295AbiKPLq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 06:46:26 -0500
Received: from azure-sdnproxy.icoremail.net (azure-sdnproxy.icoremail.net [20.232.28.96])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id E7314C6F;
        Wed, 16 Nov 2022 03:32:43 -0800 (PST)
Received: from 102.wangsu.com (unknown [59.61.78.232])
        by app2 (Coremail) with SMTP id SyJltADX31tDynRjv7gBAA--.7945S6;
        Wed, 16 Nov 2022 19:32:40 +0800 (CST)
From:   Pengcheng Yang <yangpc@wangsu.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Pengcheng Yang <yangpc@wangsu.com>
Subject: [PATCH bpf 4/4] selftests/bpf: Add ingress tests for txmsg with apply_bytes
Date:   Wed, 16 Nov 2022 19:29:21 +0800
Message-Id: <1668598161-15455-5-git-send-email-yangpc@wangsu.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1668598161-15455-1-git-send-email-yangpc@wangsu.com>
References: <1668598161-15455-1-git-send-email-yangpc@wangsu.com>
X-CM-TRANSID: SyJltADX31tDynRjv7gBAA--.7945S6
X-Coremail-Antispam: 1UD129KBjvJXoW7ArWkWr45KFyrCw4UZF4DCFg_yoW8Gr1xp3
        ZxJ39xKF95J3y7XF43JFy3tF4F9rW0qrWjyF4xAr1qvw43AFyxtrWrtFWYqF98JrWFq3Wa
        vayUGF4Uuw15Ja7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnUUvcSsGvfC2KfnxnUUI43ZEXa7xR_UUUUUUUUU==
X-CM-SenderInfo: p1dqw1nf6zt0xjvxhudrp/
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_VALIDITY_RPBL,SPF_HELO_NONE,T_SPF_PERMERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the ingress redirect is not covered in "txmsg test apply".

Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
---
 tools/testing/selftests/bpf/test_sockmap.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 0fbaccd..9bc0cb4 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -1649,24 +1649,42 @@ static void test_txmsg_apply(int cgrp, struct sockmap_options *opt)
 {
 	txmsg_pass = 1;
 	txmsg_redir = 0;
+	txmsg_ingress = 0;
 	txmsg_apply = 1;
 	txmsg_cork = 0;
 	test_send_one(opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
+	txmsg_ingress = 0;
+	txmsg_apply = 1;
+	txmsg_cork = 0;
+	test_send_one(opt, cgrp);
+
+	txmsg_pass = 0;
+	txmsg_redir = 1;
+	txmsg_ingress = 1;
 	txmsg_apply = 1;
 	txmsg_cork = 0;
 	test_send_one(opt, cgrp);
 
 	txmsg_pass = 1;
 	txmsg_redir = 0;
+	txmsg_ingress = 0;
+	txmsg_apply = 1024;
+	txmsg_cork = 0;
+	test_send_large(opt, cgrp);
+
+	txmsg_pass = 0;
+	txmsg_redir = 1;
+	txmsg_ingress = 0;
 	txmsg_apply = 1024;
 	txmsg_cork = 0;
 	test_send_large(opt, cgrp);
 
 	txmsg_pass = 0;
 	txmsg_redir = 1;
+	txmsg_ingress = 1;
 	txmsg_apply = 1024;
 	txmsg_cork = 0;
 	test_send_large(opt, cgrp);
-- 
1.8.3.1

