Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4916A598B43
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343777AbiHRSbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345522AbiHRSbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:31:32 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065F8D11E4
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 11:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660847490; x=1692383490;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6FBO+g3x9r+CWln8AIWDeAEfzefGazICoBnpQngNpsI=;
  b=YrGUIO9IJOyhbJsDOpNq+XbxyyZ53IqpVCcj+WCdhDSF71c6Wg3OzmYP
   2tEA71VCUT90an00U9IPTfLxfoCc8a/VbZavwuy1RFdi6/P2AlW0rBNWZ
   mrLus4Mf/vYFKqAbGb/X1ETZ+SaHVTbnvu4segyB1rnFzZXrOuOrtowcC
   E=;
X-IronPort-AV: E=Sophos;i="5.93,247,1654560000"; 
   d="scan'208";a="219033829"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 18:31:28 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-2dbf0206.us-west-2.amazon.com (Postfix) with ESMTPS id C4C91A3055;
        Thu, 18 Aug 2022 18:31:26 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 18:31:26 +0000
Received: from 88665a182662.ant.amazon.com (10.43.162.85) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 18:31:24 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v3 net 15/17] net: Fix a data-race around gro_normal_batch.
Date:   Thu, 18 Aug 2022 11:26:51 -0700
Message-ID: <20220818182653.38940-16-kuniyu@amazon.com>
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

While reading gro_normal_batch, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Edward Cree <ecree.xilinx@gmail.com>
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

