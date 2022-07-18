Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 009D057874C
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 18:25:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234422AbiGRQYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 12:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235228AbiGRQYR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 12:24:17 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7542A26D
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 09:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658161456; x=1689697456;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/RBNCH80TDQvkYUuIaUt35rVQdjltJAKEvEYkHGTvIE=;
  b=kZA9LVA341TJNDwX7fRUe/uTPpKDb9847o+O8NxPwgm0dfGxh+I9Vgyv
   UyM5XXJQY19j3Os0jPTngzUVg8HHlE02sXiQn3pmV0XrzujbHMlUI+WJx
   QqBgFqRGVb3FWuhWr0ZMDItHFJyAkPXetLZMWlYCwYNibfN08NqQDuKgV
   o=;
X-IronPort-AV: E=Sophos;i="5.92,281,1650931200"; 
   d="scan'208";a="219602872"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP; 18 Jul 2022 16:24:04 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2c-90419278.us-west-2.amazon.com (Postfix) with ESMTPS id 013E844380;
        Mon, 18 Jul 2022 16:24:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Mon, 18 Jul 2022 16:24:02 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Mon, 18 Jul 2022 16:23:59 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, kernel test robot <lkp@intel.com>
Subject: [PATCH v1 net-next] selftests: net: af_unix: Fix a build error of unix_connect.c.
Date:   Mon, 18 Jul 2022 09:23:50 -0700
Message-ID: <20220718162350.19186-1-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D35UWC004.ant.amazon.com (10.43.162.180) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

The checkpatch.pl will complain about this change, but the root cause of
the build failure is that I fixed this in the v2 -> v3 change. [1]

  CHECK: Macro argument 'member' may be better as '(member)' to avoid precedence issues
  #33: FILE: tools/testing/selftests/net/af_unix/unix_connect.c:115:
  +#define offsetof(type, member) ((size_t)&((type *)0)->member)

[0]: https://lore.kernel.org/linux-mm/202207182205.FrkMeDZT-lkp@intel.com/
[1]: https://lore.kernel.org/netdev/20220702154818.66761-1-kuniyu@amazon.com/

Fixes: e95ab1d85289 ("selftests: net: af_unix: Test connect() with different netns.")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 tools/testing/selftests/net/af_unix/unix_connect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/af_unix/unix_connect.c b/tools/testing/selftests/net/af_unix/unix_connect.c
index 157e44ef7f37..5b231d8c4683 100644
--- a/tools/testing/selftests/net/af_unix/unix_connect.c
+++ b/tools/testing/selftests/net/af_unix/unix_connect.c
@@ -112,7 +112,7 @@ FIXTURE_TEARDOWN(unix_connect)
 		remove("test");
 }
 
-#define offsetof(type, member) ((size_t)&((type *)0)->(member))
+#define offsetof(type, member) ((size_t)&((type *)0)->member)
 
 TEST_F(unix_connect, test)
 {
-- 
2.30.2

