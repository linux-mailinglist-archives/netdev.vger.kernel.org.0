Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D276E56967C
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 01:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234774AbiGFXlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 19:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234764AbiGFXl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 19:41:28 -0400
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 274A22CDF8;
        Wed,  6 Jul 2022 16:41:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657150885; x=1688686885;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qq/qfg904mjSo0orEnGORfkoNOzm2AdQkoF/vSc53Nw=;
  b=arfm/cTpeXAJ538ldX3l9TKlU2A8K1SqqSIJq3OpGKv7cBXd/tG88RgH
   SyxLVAiVk3Dk74/PGv77KlZpYVIVM1Uq6Q0PVfUH5ZmpjYcouRNuvT0aD
   qSFob2Uc4gAK6koN71HcBfERwR358CJyuUtPRanw3uum0WVCifXNSp+Hy
   c=;
X-IronPort-AV: E=Sophos;i="5.92,251,1650931200"; 
   d="scan'208";a="207883460"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP; 06 Jul 2022 23:41:10 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id 90205810FC;
        Wed,  6 Jul 2022 23:41:06 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Wed, 6 Jul 2022 23:41:05 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.106) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Wed, 6 Jul 2022 23:41:02 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
Subject: [PATCH v2 net 02/12] sysctl: Fix data races in proc_douintvec().
Date:   Wed, 6 Jul 2022 16:39:53 -0700
Message-ID: <20220706234003.66760-3-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220706234003.66760-1-kuniyu@amazon.com>
References: <20220706234003.66760-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.106]
X-ClientProxiedBy: EX13D36UWB001.ant.amazon.com (10.43.161.84) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A sysctl variable is accessed concurrently, and there is always a chance
of data-race.  So, all readers and writers need some basic protection to
avoid load/store-tearing.

This patch changes proc_douintvec() to use READ_ONCE() and WRITE_ONCE()
internally to fix data-races on the sysctl side.  For now, proc_douintvec()
itself is tolerant to a data-race, but we still need to add annotations on
the other subsystem's side.

Fixes: e7d316a02f68 ("sysctl: handle error writing UINT_MAX to u32 fields")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
---
 kernel/sysctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c8a05655ae60..2ab8c2a37e8f 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -472,9 +472,9 @@ static int do_proc_douintvec_conv(unsigned long *lvalp,
 	if (write) {
 		if (*lvalp > UINT_MAX)
 			return -EINVAL;
-		*valp = *lvalp;
+		WRITE_ONCE(*valp, *lvalp);
 	} else {
-		unsigned int val = *valp;
+		unsigned int val = READ_ONCE(*valp);
 		*lvalp = (unsigned long)val;
 	}
 	return 0;
-- 
2.30.2

