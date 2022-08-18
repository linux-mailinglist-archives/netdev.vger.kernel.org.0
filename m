Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCAE7598B48
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343683AbiHRSbz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245037AbiHRSbn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:31:43 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C609AD21C2
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847501; x=1692383501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QpXL2t+PO1bBQjuLKpDmyzXFb+dtXVkSUGury2sOr1g=;
  b=cg9LgeOZZk4WVG6HG34yLvqxINRDX4fAQMJYdXl48FF9zKEqttdWg6Lz
   KQINf2OseH8WVoDqLYffVORQzC1+0NkQtFYYE6SSa27X4DKBoSEnsA4vV
   O7VpapxCCkfi87oGZCoUev4j7qJPKsloEOFl3EVboRMLPsJ/gniP6Sd7Y
   8=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="1045728636"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:31:41 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-4213ea4c.us-west-2.amazon.com (Postfix) with ESMTPS id C328381579;
        Thu, 18 Aug 2022 18:31:40 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:31:40 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:31:37 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH v3 net 16/17] net: Fix a data-race around netdev_unregister_timeout_secs.
Date:   Thu, 18 Aug 2022 11:26:52 -0700
Message-ID: <20220818182653.38940-17-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220818182653.38940-1-kuniyu@amazon.com>
References: <20220818182653.38940-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.162.85]
X-ClientProxiedBy: EX13D13UWB003.ant.amazon.com (10.43.161.233) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading netdev_unregister_timeout_secs, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 5aa3afe107d9 ("net: make unregister netdev warning timeout configurable")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Dmitry Vyukov <dvyukov@google.com>
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

