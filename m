Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD33957E66A
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 20:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbiGVSXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 14:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbiGVSXF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 14:23:05 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A1479EC2
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 11:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1658514184; x=1690050184;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DNqjSpPNbwQt/VFtWwVb6J3I6h70Alz8Qt7cZIbf3w4=;
  b=RPFuMPJsB2pQqFRJhizyNL1sYHkucLTtwZCBPi6KWviuggVlxqjaG030
   E44luhRUIMHayB2RhiRrRgD5fR2jCapKDOg8GFQzQdqs7PTA2bkeWOEke
   856+lZYVJg0pjCmHt2nmN6Te2WrRRPu6ftw+MmZ892MkFX+k26hRMCEj7
   M=;
X-IronPort-AV: E=Sophos;i="5.93,186,1654560000"; 
   d="scan'208";a="224853647"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP; 22 Jul 2022 18:22:54 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2a-6a4112b2.us-west-2.amazon.com (Postfix) with ESMTPS id 0BADC4C01D9;
        Fri, 22 Jul 2022 18:22:53 +0000 (UTC)
Received: from EX19D004ANA001.ant.amazon.com (10.37.240.138) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.36; Fri, 22 Jul 2022 18:22:52 +0000
Received: from 88665a182662.ant.amazon.com (10.43.160.159) by
 EX19D004ANA001.ant.amazon.com (10.37.240.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.1118.9;
 Fri, 22 Jul 2022 18:22:50 +0000
From:   Kuniyuki Iwashima <kuniyu@amazon.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@kernel.org>
CC:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH v1 net 1/7] tcp: Fix data-races around sk_pacing_rate.
Date:   Fri, 22 Jul 2022 11:21:59 -0700
Message-ID: <20220722182205.96838-2-kuniyu@amazon.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220722182205.96838-1-kuniyu@amazon.com>
References: <20220722182205.96838-1-kuniyu@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.43.160.159]
X-ClientProxiedBy: EX13D13UWB004.ant.amazon.com (10.43.161.218) To
 EX19D004ANA001.ant.amazon.com (10.37.240.138)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While reading sysctl_tcp_pacing_(ss|ca)_ratio, they can be changed
concurrently.  Thus, we need to add READ_ONCE() to their readers.

Fixes: 43e122b014c9 ("tcp: refine pacing rate determination")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index c799f39cb774..dd05238f79f6 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -910,9 +910,9 @@ static void tcp_update_pacing_rate(struct sock *sk)
 	 *	 end of slow start and should slow down.
 	 */
 	if (tcp_snd_cwnd(tp) < tp->snd_ssthresh / 2)
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio);
 	else
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio);
 
 	rate *= max(tcp_snd_cwnd(tp), tp->packets_out);
 
-- 
2.30.2

