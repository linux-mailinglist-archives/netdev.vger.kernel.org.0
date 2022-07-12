Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0139570ED4
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 02:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiGLATV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 20:19:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbiGLASw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 20:18:52 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186792AC59;
        Mon, 11 Jul 2022 17:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1657585093; x=1689121093;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T96SKobnwkQzkhGFjnOXsplpnmFTCsIPgrL3HmDTp+k=;
  b=j5i2iwaAvtFoGm+aktgcIq8WxJ4q4Jzm+ny+VBLePLZDYwZmgyBpTGKf
   LSxcPZI5m4A0yuiSilw9kojtey3L83uWBfUH8SacCS1aoayPRVHJ+Ek57
   wvwdDfkzNfV1ScNshfB1O8DTC14ogXaJt9VEd5l1FTDvzHsCPCafBMgDn
   A=;
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com) ([10.124.125.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 12 Jul 2022 00:18:11 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-388992e0.us-west-2.amazon.com (Postfix) with ESMTPS id D392B8EC28;
        Tue, 12 Jul 2022 00:18:10 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Tue, 12 Jul 2022 00:18:10 +0000
Received: from 88665a182662.ant.amazon.com.com (10.43.161.185) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Tue, 12 Jul 2022 00:18:06 +0000
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
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "J . Simonetti" <jeroen@simonetti.nl>
Subject: [PATCH v1 net 08/15] icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
Date:   Mon, 11 Jul 2022 17:15:26 -0700
Message-ID: <20220712001533.89927-9-kuniyu@amazon.com>
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

While reading sysctl_icmp_errors_use_inbound_ifaddr, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 1c2fb7f93cb2 ("[IPV4]: Sysctl configurable icmp error source address.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
CC: J. Simonetti <jeroen@simonetti.nl>
---
 net/ipv4/icmp.c            | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 0c01696c5584..a49b68d6b969 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -693,7 +693,7 @@ void __icmp_send(struct sk_buff *skb_in, int type, int code, __be32 info,
 
 		rcu_read_lock();
 		if (rt_is_input_route(rt) &&
-		    net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr)
+		    READ_ONCE(net->ipv4.sysctl_icmp_errors_use_inbound_ifaddr))
 			dev = dev_get_by_index_rcu(net, inet_iif(skb_in));
 
 		if (dev)
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 3122e652f3c3..66159d49a575 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -635,6 +635,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_ratelimit",
-- 
2.30.2

