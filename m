Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44390550D96
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 01:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbiFSXaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 19:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbiFSXaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 19:30:16 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88C4C64F2
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 16:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1655681415; x=1687217415;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=laLVpyv37FfI4qLMQWUW98s32IZvkWuLJAqV/AwwssI=;
  b=aGh4SISS5GeJ81fxgL3HhenIRJZbZTRruqgMzI/SqH8BiYL5hSvCgymk
   wUelBYeKG39dGIjXSc62tpVfJuK7EFAFKJ2RHEZVOGzsJ3gxXaS1iNih5
   dJu0Da1d+L5cC6q4DQUg5WeYtDVr9lNKIf+1/gdxBll3GfDb3R5IZfWZc
   s=;
X-IronPort-AV: E=Sophos;i="5.92,306,1650931200"; 
   d="scan'208";a="99448297"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP; 19 Jun 2022 23:30:14 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-8be8ed69.us-east-1.amazon.com (Postfix) with ESMTPS id 30BD2C3CD3;
        Sun, 19 Jun 2022 23:30:12 +0000 (UTC)
Received: from EX13D04ANC001.ant.amazon.com (10.43.157.89) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:30:11 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.133) by
 EX13D04ANC001.ant.amazon.com (10.43.157.89) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Sun, 19 Jun 2022 23:30:08 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net-next 1/2] raw: Fix mixed declarations error in raw_icmp_error().
Date:   Sun, 19 Jun 2022 16:29:26 -0700
Message-ID: <20220619232927.54259-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220619232927.54259-1-kuniyu@amazon.com>
References: <20220619232927.54259-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.43.162.133]
X-ClientProxiedBy: EX13D05UWB003.ant.amazon.com (10.43.161.26) To
 EX13D04ANC001.ant.amazon.com (10.43.157.89)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The trailing semicolon causes a compiler error, so let's remove it.

net/ipv4/raw.c: In function ‘raw_icmp_error’:
net/ipv4/raw.c:266:2: error: ISO C90 forbids mixed declarations and code [-Werror=declaration-after-statement]
  266 |  struct hlist_nulls_head *hlist;
      |  ^~~~~~

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/raw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index d28bf0b901a2..b3b255db9021 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -262,7 +262,7 @@ static void raw_err(struct sock *sk, struct sk_buff *skb, u32 info)
 
 void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 {
-	struct net *net = dev_net(skb->dev);;
+	struct net *net = dev_net(skb->dev);
 	struct hlist_nulls_head *hlist;
 	struct hlist_nulls_node *hnode;
 	int dif = skb->dev->ifindex;
-- 
2.30.2

