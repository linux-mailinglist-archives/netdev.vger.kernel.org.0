Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A540B597C97
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 06:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242806AbiHRD4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiHRD4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:56:53 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60A0AA3F3
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:56:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660795012; x=1692331012;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=417Kq7gZ0P7onAfhblAyumQQkIDZJHeFEzRcxtimM6I=;
  b=jyyvrjZo1D4xhVyBRtjPONQay40cwCPQ0ZaUZrUuhJKnYMfAfmFb8qNv
   HFSECOaJ5wTNbgzTn/Ca1Ij56nfVpqpU3+43B9nW4sDS3IkxInDpaNBDw
   VUQlS4vkcckqG+X/Z4koBPDzCkXM5fo/DOaT/LPQrpSs91LEeNKUXWtNA
   4=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="1045472058"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:56:51 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-0bfdb89e.us-east-1.amazon.com (Postfix) with ESMTPS id B5DBCE2AB5;
        Thu, 18 Aug 2022 03:56:49 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:56:48 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:56:46 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net 15/17] net: Fix a data-race around gro_normal_batch.
Date:   Wed, 17 Aug 2022 20:52:25 -0700
Message-ID: <20220818035227.81567-16-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading gro_normal_batch, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Edward Cree <ecree@solarflare.com>
---
 include/net/gro.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gro.h b/include/net/gro.h
index 867656b0739c..24003dea8fa4 100644
--- a/include/net/gro.h
+++ b/include/net/gro.h
@@ -439,7 +439,7 @@ static inline void gro_normal_one(struct napi_struct *napi, struct sk_buff *skb,
 {
 	list_add_tail(&skb->list, &napi->rx_list);
 	napi->rx_count += segs;
-	if (napi->rx_count >= gro_normal_batch)
+	if (napi->rx_count >= READ_ONCE(gro_normal_batch))
 		gro_normal_list(napi);
 }
 
-- 
2.30.2

