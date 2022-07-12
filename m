Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420EA570EDF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiGLAUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:20:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbiGLATt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:19:49 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186C83204A;
        Mon, 11 Jul 2022 17:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585147; x=1689121147;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=o/qzj0VyfhkINHUYt/PftJYBOgZ3F6bk6ZZr6d+kK/o=;
  b=Ak1h8uCpfS/BOvlRdRImd+cfyEi3/hQw1M5JH3SNTMvDiC74EEc1zA9W
   jSVVAmptnUyEOKB0+HNzYF0Yx1dbuFFsYWHW772jXg3rm27awggRKsnhs
   Hp3Zc2JesMLYE0X6WwdwNPufr2/8LQOGBelGtDSXjLqxYv94rAk0RFCti
   s=;
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 12 Jul 2022 00:19:05 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-6e5a0cd6.us-west-2.amazon.com (Postfix) with ESMTPS id C4C2BA272C;
        Tue, 12 Jul 2022 00:19:04 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:19:04 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:19:00 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v1 net 10/15] icmp: Fix a data-race around sysctl_icmp_ratemask.
Date:   Mon, 11 Jul 2022 17:15:28 -0700
Message-ID: <20220712001533.89927-11-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220712001533.89927-1-kuniyu@amazon.com>
References: <20220712001533.89927-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.161.185]
X-ClientProxiedBy: EX13D04UWB002.ant.amazon.com (10.43.161.133) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_icmp_ratemask, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 1d454cc41713..57c4f0d87a7a 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -282,7 +282,7 @@ static bool icmpv4_mask_allow(struct net *net, int type, int code)
 		return true;
 
 	/* Limit if icmp type is enabled in ratemask. */
-	if (!((1 << type) & net->ipv4.sysctl_icmp_ratemask))
+	if (!((1 << type) & READ_ONCE(net->ipv4.sysctl_icmp_ratemask)))
 		return true;
 
 	return false;
-- 
2.30.2

