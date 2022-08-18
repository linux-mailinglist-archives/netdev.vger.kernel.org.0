Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C43B9598B21
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345391AbiHRS3m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbiHRS3j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:29:39 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C9E140AF
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:29:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847378; x=1692383378;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=A/az7fgmUiVAvboRMFoUPTtfSRTA9zCuqX05dM/3jPA=;
  b=cTHaUAC93JIgiY8cQWAIEm7ddiqM8UYWqeVeuFObs3xd/7OpjuAjEx2p
   jTpeGDbfj4h85r7pPKH6Lyu8ao9sNaJ1Bc2sukQA+WsgdKhGPDeYh0zOB
   xDYUi8DWIMi8nUJyJRce+eTfks1bQNVvnQ4xRpAEvOamYa97MOjxnavHr
   c=;
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:29:25 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-22c2b493.us-west-2.amazon.com (Postfix) with ESMTPS id C170744AAC;
        Thu, 18 Aug 2022 18:29:24 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:29:24 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:29:22 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Willem de Bruijn <willemb@google.com>
Subject: [PATCH v3 net 07/17] net: Fix a data-race around sysctl_tstamp_allow_data.
Date:   Thu, 18 Aug 2022 11:26:43 -0700
Message-ID: <20220818182653.38940-8-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tstamp_allow_data, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: b245be1f4db1 ("net-timestamp: no-payload only sysctl")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
CC: Willem de Bruijn <willemb@google.com>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 974bbbbe7138..174f34124c06 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4798,7 +4798,7 @@ static bool skb_may_tx_timestamp(struct sock *sk, bool tsonly)
 {
 	bool ret;
 
-	if (likely(sysctl_tstamp_allow_data || tsonly))
+	if (likely(READ_ONCE(sysctl_tstamp_allow_data) || tsonly))
 		return true;
 
 	read_lock_bh(&sk->sk_callback_lock);
-- 
2.30.2

