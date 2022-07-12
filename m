Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C682570ED0
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbiGLATH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbiGLASn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:18:43 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9814F25CA;
        Mon, 11 Jul 2022 17:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585075; x=1689121075;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=CRTePnIGj4H8ALoH5op4ZiB9ClWBa861ZK27V5EF1iQ=;
  b=fpWJli214IGdeYR5zOtVuv5WnDmWDlypDjLctBrGtpyqMg+gl9oyMvp6
   P7259xrb+iQjTYJ+alpReLakJK6LXxJ5RekfGDPzbMxeP05L7mpBFpD7Y
   xSvuKblMms7C+dKv/NxfePnWsZXRMnomjWjaakdvNiW4XGZfMrN9pH+HV
   E=;
X-IronPort-AV: E=Sophos;i="5.92,264,1650931200"; 
   d="scan'208";a="220431228"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.124.125.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 12 Jul 2022 00:17:43 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 70F584C0053;
        Tue, 12 Jul 2022 00:17:41 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:17:40 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:17:37 +0000
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
Subject: [PATCH v1 net 06/15] icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
Date:   Mon, 11 Jul 2022 17:15:24 -0700
Message-ID: <20220712001533.89927-7-kuniyu@amazon.com>
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
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_icmp_echo_ignore_broadcasts, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/icmp.c            | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index c406e324c594..4b1d84d3feaa 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1249,7 +1249,7 @@ int icmp_rcv(struct sk_buff *skb)
 		 */
 		if ((icmph->type == ICMP_ECHO ||
 		     icmph->type == ICMP_TIMESTAMP) &&
-		    net->ipv4.sysctl_icmp_echo_ignore_broadcasts) {
+		    READ_ONCE(net->ipv4.sysctl_icmp_echo_ignore_broadcasts)) {
 			reason = SKB_DROP_REASON_INVALID_PROTO;
 			goto error;
 		}
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 64682a01914a..cb53476a292e 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -617,6 +617,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_ignore_bogus_error_responses",
-- 
2.30.2

