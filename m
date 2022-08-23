Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F29D59EC0D
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 21:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiHWTR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 15:17:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiHWTPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 15:15:06 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00457A8CF1
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 10:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661277150; x=1692813150;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6FBO+g3x9r+CWln8AIWDeAEfzefGazICoBnpQngNpsI=;
  b=OQpUrY8qQ4lcNi178bX+6oIqCRYJck4U7CAFgqhth3zDwRCH4gwJHuqh
   ggb7+pdbW53WEHOErbwXF3P6mSxBbIoOWHUJaek/81WdO5+KuPxe88Ao4
   ssrLVD2/v/6HAXHwQxVGQZuIrvTBnqMZyyCEFr0L3/F12ar11y5Qz9od2
   s=;
X-IronPort-AV: E=Sophos;i="5.93,258,1654560000"; 
   d="scan'208";a="122631876"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 17:52:01 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-5feb294a.us-west-2.amazon.com (Postfix) with ESMTPS id 7260DE01E8;
        Tue, 23 Aug 2022 17:52:01 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Tue, 23 Aug 2022 17:52:00 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.160) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Tue, 23 Aug 2022 17:51:58 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v4 net 15/17] net: Fix a data-race around gro_normal_batch.
Date:   Tue, 23 Aug 2022 10:46:58 -0700
Message-ID: <20220823174700.88411-16-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220823174700.88411-1-kuniyu@amazon.com>
References: <20220823174700.88411-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.160]
X-ClientProxiedBy: EX13D07UWA003.ant.amazon.com (10.43.160.35) To
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

