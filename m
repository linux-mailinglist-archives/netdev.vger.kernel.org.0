Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32AF5597C6E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 05:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243151AbiHRDxn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 23:53:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242726AbiHRDxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 23:53:37 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9AF57239
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 20:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1660794816; x=1692330816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ifQr4mjTwAwQ+8/6ReHn2iQrrv5H2aqkASDlxRvv4OM=;
  b=v6MVdvgOCeEgdWx3Eam5W3EvH90AGqgG6uXj7HWypBUeaKb1TKGxUdfZ
   bnxDZLrxwAVzRQw0yBtYO89eOAtZGNrc2WTaeDsD+6Dy6ab+7KKIOg0cF
   x8DOa033boSC48nDM/GSu2TeJT8EVrv3btSFOqbcrHalr9RgxU9Fr5ZM3
   g=;
X-IronPort-AV: E=Sophos;i="5.93,245,1654560000"; 
   d="scan'208";a="120534882"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 03:53:21 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-e823fbde.us-east-1.amazon.com (Postfix) with ESMTPS id 39A09C183F;
        Thu, 18 Aug 2022 03:53:18 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Thu, 18 Aug 2022 03:53:18 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.160.55) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.12;
 Thu, 18 Aug 2022 03:53:16 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>,
        Matthias Tafelmeier <matthias.tafelmeier@gmx.net>
Subject: [PATCH v2 net 02/17] net: Fix data-races around weight_p and dev_weight_[rt]x_bias.
Date:   Wed, 17 Aug 2022 20:52:12 -0700
Message-ID: <20220818035227.81567-3-kuniyu@amazon.com>
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

While reading weight_p and dev_weight_[rt]x_bias, they can be changed
concurrently.  Thus, we need to add READ_ONCE() to their readers.

Fixes: 3d48b53fb2ae ("net: dev_weight: TX/RX orthogonality")
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Matthias Tafelmeier <matthias.tafelmeier@gmx.net>
---
 net/core/dev.c             | 2 +-
 net/core/sysctl_net_core.c | 6 ++++--
 net/sched/sch_generic.c    | 2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 716df64fcfa5..b5b92dcd5eea 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5918,7 +5918,7 @@ static int process_backlog(struct napi_struct *napi, int quota)
 		net_rps_action_and_irq_enable(sd);
 	}
 
-	napi->weight = dev_rx_weight;
+	napi->weight = READ_ONCE(dev_rx_weight);
 	while (again) {
 		struct sk_buff *skb;
 
diff --git a/net/core/sysctl_net_core.c b/net/core/sysctl_net_core.c
index 71a13596ea2b..d82ba0c27175 100644
--- a/net/core/sysctl_net_core.c
+++ b/net/core/sysctl_net_core.c
@@ -240,8 +240,10 @@ static int proc_do_dev_weight(struct ctl_table *table, int write,
 	if (ret != 0)
 		return ret;
 
-	dev_rx_weight = weight_p * dev_weight_rx_bias;
-	dev_tx_weight = weight_p * dev_weight_tx_bias;
+	WRITE_ONCE(dev_rx_weight,
+		   READ_ONCE(weight_p) * READ_ONCE(dev_weight_rx_bias));
+	WRITE_ONCE(dev_tx_weight,
+		   READ_ONCE(weight_p) * READ_ONCE(dev_weight_tx_bias));
 
 	return ret;
 }
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index d47b9689eba6..99b697ad2b98 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -409,7 +409,7 @@ static inline bool qdisc_restart(struct Qdisc *q, int *packets)
 
 void __qdisc_run(struct Qdisc *q)
 {
-	int quota = dev_tx_weight;
+	int quota = READ_ONCE(dev_tx_weight);
 	int packets;
 
 	while (qdisc_restart(q, &packets)) {
-- 
2.30.2

