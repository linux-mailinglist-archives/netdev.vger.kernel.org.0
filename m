Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FDB524A51
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 12:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237651AbiELKcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 06:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiELKcd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 06:32:33 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA1C52B2C
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 03:32:31 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KzSjw100sz1JBlT;
        Thu, 12 May 2022 18:31:16 +0800 (CST)
Received: from huawei.com (10.175.101.6) by canpemm500010.china.huawei.com
 (7.192.105.118) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 12 May
 2022 18:32:29 +0800
From:   Liu Jian <liujian56@huawei.com>
To:     <edumazet@google.com>, <davem@davemloft.net>,
        <yoshfuji@linux-ipv6.org>, <dsahern@kernel.org>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ncardwell@google.com>,
        <netdev@vger.kernel.org>
CC:     <liujian56@huawei.com>
Subject: [PATCH net] tcp: Add READ_ONCE() to read tcp_orphan_count
Date:   Thu, 12 May 2022 18:33:21 +0800
Message-ID: <20220512103322.380405-1-liujian56@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.101.6]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 canpemm500010.china.huawei.com (7.192.105.118)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_orphan_count per-CPU variable is read locklessly, so this commit
add the READ_ONCE() to a load in order to avoid below KCSAN warnning:

BUG: KCSAN: data-race in tcp_orphan_count_sum net/ipv4/tcp.c:2476 [inline]
BUG: KCSAN: data-race in tcp_orphan_update+0x64/0x100 net/ipv4/tcp.c:2487

race at unknown origin, with read to 0xffff9c63bbdac7a8 of 4 bytes by interrupt on cpu 2:
 tcp_orphan_count_sum net/ipv4/tcp.c:2476 [inline]
 tcp_orphan_update+0x64/0x100 net/ipv4/tcp.c:2487
 call_timer_fn+0x33/0x210 kernel/time/timer.c:1414

Fixes: 19757cebf0c5 ("tcp: switch orphan_count to bare per-cpu counters")
Signed-off-by: Liu Jian <liujian56@huawei.com>
---
 net/ipv4/tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index cf18fbcbf123..7245609f41e6 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2718,7 +2718,7 @@ int tcp_orphan_count_sum(void)
 	int i, total = 0;
 
 	for_each_possible_cpu(i)
-		total += per_cpu(tcp_orphan_count, i);
+		total += READ_ONCE(per_cpu(tcp_orphan_count, i));
 
 	return max(total, 0);
 }
-- 
2.17.1

