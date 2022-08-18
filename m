Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23214597C9E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242850AbiHRD5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiHRD5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:57:06 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74DF4A1D7A
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660795026; x=1692331026;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dk1qqFKGBHe2PX6XY+X2BcgbaI6uUEpULdKbXwkATqs=;
  b=EZsPUGjrM2AeiJ3F0cMiQINsolxX8c1CvdL+XqtS/g9MpbWDjD4Xrn1d
   G6sKYLBi2Q1a1yV6HWQUAyXeuGZ/jaPtFG1Q6CPmH54hSkAb43DYvUbJ/
   0vEMsS57oXPemtPZht7Jcps1XFO0cqfqL/Z+u2XNXTPplcA7VVhKDjf09
   4=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:57:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-26daedd8.us-east-1.amazon.com (Postfix) with ESMTPS id 492E8E0FFC;
        Thu, 18 Aug 2022 03:57:03 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:57:02 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:57:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v2 net 16/17] net: Fix a data-race around netdev_unregister_timeout_secs.
Date:   Wed, 17 Aug 2022 20:52:26 -0700
Message-ID: <20220818035227.81567-17-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818035227.81567-1-kuniyu@amazon.com>
References: <20220818035227.81567-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.55]
X-ClientProxiedBy: EX13D29UWA002.ant.amazon.com (10.43.160.63) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading netdev_unregister_timeout_secs, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Dmitry Vyukov <dvyukov@google.com>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 8221322d86db..56c8b0921c9f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10284,7 +10284,7 @@ static struct net_device *netdev_wait_allrefs_any(struct list_head *list)
 				return dev;
 
 		if (time_after(jiffies, warning_time +
-			       netdev_unregister_timeout_secs * HZ)) {
+			       READ_ONCE(netdev_unregister_timeout_secs) * HZ)) {
 			list_for_each_entry(dev, list, todo_list) {
 				pr_emerg("unregister_netdevice: waiting for %s to become free. Usage count = %d\n",
 					 dev->name, netdev_refcnt_read(dev));
-- 
2.30.2

