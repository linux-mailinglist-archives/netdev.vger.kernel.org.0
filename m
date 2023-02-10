Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6409691A39
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 09:45:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjBJIpJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 03:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbjBJIpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 03:45:08 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92280113E2
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 00:45:06 -0800 (PST)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4PCnLL1LgxznVx5;
        Fri, 10 Feb 2023 16:42:50 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 10 Feb 2023 16:45:04 +0800
From:   gaoxingwang <gaoxingwang1@huawei.com>
To:     <netdev@vger.kernel.org>, <stephen@networkplumber.org>
CC:     <davem@davemloft.net>, <dsahern@kernel.org>, <liaichun@huawei.com>,
        <yanan@huawei.com>
Subject: [PATCH] testsuite: fix testsuite build failure when iproute build without libcap-devel
Date:   Fri, 10 Feb 2023 16:45:31 +0800
Message-ID: <20230210084531.98534-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute allows to build without libcap.The testsuite will fail to
compile when libcap dose not exists.It was required in 6d68d7f85d.

Fixes: 6d68d7f85d ("testsuite: fix build failure")
Signed-off-by: gaoxingwang <gaoxingwang1@huawei.com>
---
 testsuite/tools/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/testsuite/tools/Makefile b/testsuite/tools/Makefile
index e0162cc..0356dda 100644
--- a/testsuite/tools/Makefile
+++ b/testsuite/tools/Makefile
@@ -1,9 +1,13 @@
 # SPDX-License-Identifier: GPL-2.0
 CFLAGS=
+LDLIBS=
 include ../../config.mk
+ifeq ($(HAVE_CAP),y)
+LDLIBS+= -lcap
+endif
 
 generate_nlmsg: generate_nlmsg.c ../../lib/libnetlink.a ../../lib/libutil.a
-	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRA_CFLAGS) -I../../include -I../../include/uapi -include../../include/uapi/linux/netlink.h -o $@ $^ -lmnl -lcap
+	$(QUIET_CC)$(CC) $(CPPFLAGS) $(CFLAGS) $(EXTRA_CFLAGS) -I../../include -I../../include/uapi -include../../include/uapi/linux/netlink.h -o $@ $^ -lmnl $(LDLIBS)
 
 clean:
 	rm -f generate_nlmsg
-- 
2.27.0

