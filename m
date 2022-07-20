Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9759557AB3B
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 02:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237303AbiGTA6W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 20:58:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiGTA6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 20:58:21 -0400
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 987FF422D1
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 17:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658278700; x=1689814700;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=j2kriUbnAfHpL6pn+9Mkc6xiHOmARhZ8YDVy2cZI77Q=;
  b=uyGrUnPWhjOkTHNmcvWo9gVkru20dsSFPuzS525VA5ZIbguSfMLaWmhy
   jnlIqYSD4vuLI423g7+XOTcgeJ2JiBcj2BDmpxB+lD8Q9fdgU0aV5D8Wa
   jyWyu7Y+WGoTa2Zbe2yJCns8+K3ZLXiqpAcc9pMq1o9i2PFQ0MVo3e7mB
   4=;
X-IronPort-AV: E=Sophos;i="5.92,285,1650931200"; 
   d="scan'208";a="110199718"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP; 20 Jul 2022 00:58:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id 4AA80E0153;
        Wed, 20 Jul 2022 00:58:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 20 Jul 2022 00:58:02 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.172) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 20 Jul 2022 00:57:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH v2 net-next] selftests: net: af_unix: Fix a build error of unix_connect.c.
Date:   Tue, 19 Jul 2022 17:57:50 -0700
Message-ID: <20220720005750.16600-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.161.172]
X-ClientProxiedBy: EX13D29UWC003.ant.amazon.com (10.43.162.80) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes a build error reported in the link. [0]

  unix_connect.c: In function ‘unix_connect_test’:
  unix_connect.c:115:55: error: expected identifier before ‘(’ token
   #define offsetof(type, member) ((size_t)&((type *)0)->(member))
                                                       ^
  unix_connect.c:128:12: note: in expansion of macro ‘offsetof’
    addrlen = offsetof(struct sockaddr_un, sun_path) + variant->len;
              ^~~~~~~~

We can fix this by removing () around member, but checkpatch will complain
about it, and the root cause of the build failure is that I followed the
warning and fixed this in the v2 -> v3 change of the blamed commit. [1]

  CHECK: Macro argument 'member' may be better as '(member)' to avoid precedence issues
  #33: FILE: tools/testing/selftests/net/af_unix/unix_connect.c:115:
  +#define offsetof(type, member) ((size_t)&((type *)0)->member)

To avoid this warning, let's use offsetof() defined in stddef.h instead.

[0]: https://lore.kernel.org/linux-mm/202207182205.FrkMeDZT-lkp@intel.com/
[1]: https://lore.kernel.org/netdev/20220702154818.66761-1-kuniyu@amazon.com/

Fixes: e95ab1d85289 ("selftests: net: af_unix: Test connect() with different netns.")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
v2:
  * Use offsetof() in stddef.h instead of defining it. (Jakub Kicinski)

v1: https://lore.kernel.org/netdev/20220718162350.19186-1-kuniyu@amazon.com/
---
 tools/testing/selftests/net/af_unix/unix_connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/af_unix/unix_connect.c b/tools/testing/selftests/net/af_unix/unix_connect.c
index 157e44ef7f37..d799fd8f5c7c 100644
--- a/tools/testing/selftests/net/af_unix/unix_connect.c
+++ b/tools/testing/selftests/net/af_unix/unix_connect.c
@@ -3,6 +3,7 @@
 #define _GNU_SOURCE
 #include <sched.h>
 
+#include <stddef.h>
 #include <stdio.h>
 #include <unistd.h>
 
@@ -112,8 +113,6 @@ FIXTURE_TEARDOWN(unix_connect)
 		remove("test");
 }
 
-#define offsetof(type, member) ((size_t)&((type *)0)->(member))
-
 TEST_F(unix_connect, test)
 {
 	socklen_t addrlen;
-- 
2.30.2

